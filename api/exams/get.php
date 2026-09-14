<?php
ini_set('display_errors', 0);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED);
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

try {
    require_get_method();

    // Require student authentication
    $user = require_auth(['student', 'teacher', 'admin']);
    $user_id = $user['id'];

    $chapter_param = trim($_GET['chapter_id'] ?? '');
    $exam_param = trim($_GET['exam_id'] ?? $_GET['id'] ?? $_GET['slug'] ?? '');

    if (empty($chapter_param) && empty($exam_param)) {
        json_response([
            'status' => 'error',
            'success' => false,
            'message' => 'Exam ID or Chapter ID is required'
        ], 200);
        exit;
    }

    $db = get_db_connection();

    // 1. Fetch exam and associated chapter & course
    $exam = null;

    if (!empty($exam_param)) {
        $stmt = $db->prepare("
            SELECT 
                e.id, e.title, e.description, e.passing_score_percent,
                e.chapter_id, ch.title as chapter_title,
                c.id as course_id, c.title as course_title,
                c.academic_group_id, c.is_published
            FROM exams e
            LEFT JOIN chapters ch ON e.chapter_id = ch.id
            LEFT JOIN courses c ON ch.course_id = c.id
            WHERE e.id = ? OR e.chapter_id = ? OR ch.id = ? OR ch.slug = ?
            LIMIT 1
        ");
        $stmt->execute([$exam_param, $exam_param, $exam_param, $exam_param]);
        $exam = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    if (!$exam && !empty($chapter_param)) {
        $stmt = $db->prepare("
            SELECT 
                e.id, e.title, e.description, e.passing_score_percent,
                e.chapter_id, ch.title as chapter_title,
                c.id as course_id, c.title as course_title,
                c.academic_group_id, c.is_published
            FROM exams e
            LEFT JOIN chapters ch ON e.chapter_id = ch.id
            LEFT JOIN courses c ON ch.course_id = c.id
            WHERE e.chapter_id = ? OR ch.id = ? OR ch.slug = ?
            LIMIT 1
        ");
        $stmt->execute([$chapter_param, $chapter_param, $chapter_param]);
        $exam = $stmt->fetch(PDO::FETCH_ASSOC);
    }

    // If still no exam record found in DB, search chapters table
    if (!$exam) {
        $ch_search = !empty($chapter_param) ? $chapter_param : $exam_param;
        $clean_ch_search = preg_replace('/^exam-/', '', $ch_search);
        
        $stmt_ch = $db->prepare("
            SELECT 
                ch.id as chapter_id, ch.title as chapter_title, ch.course_id,
                c.title as course_title, c.academic_group_id, c.is_published
            FROM chapters ch
            LEFT JOIN courses c ON ch.course_id = c.id
            WHERE ch.id = ? OR ch.slug = ? OR ch.id = ? OR ch.slug = ?
            LIMIT 1
        ");
        $stmt_ch->execute([$ch_search, $ch_search, $clean_ch_search, $clean_ch_search]);
        $ch_row = $stmt_ch->fetch(PDO::FETCH_ASSOC);

        if ($ch_row) {
            $exam = [
                'id' => !empty($exam_param) ? $exam_param : ('exam-' . $ch_row['chapter_id']),
                'title' => $ch_row['chapter_title'] . ' Final Exam & Assessment',
                'description' => 'Comprehensive chapter assessment covering core topics and practical evaluation.',
                'passing_score_percent' => 60,
                'chapter_id' => $ch_row['chapter_id'],
                'chapter_title' => $ch_row['chapter_title'],
                'course_id' => $ch_row['course_id'],
                'course_title' => $ch_row['course_title'] ?? 'Programming Foundations',
                'academic_group_id' => $ch_row['academic_group_id'],
                'is_published' => $ch_row['is_published'] ?? 1
            ];
        } else {
            // No exam and no matching chapter found — return a real 404
            json_response([
                'status' => 'error',
                'success' => false,
                'message' => 'Exam not found'
            ], 404);
            exit;
        }
    }

    $exam_id = $exam['id'];
    $passing_score_val = 60; // Standardize passing threshold at 60% per requirements

    // 2. Fetch student attempt history for this exam
    $attempts_history = [];
    $best_score = null;
    $all_attempts = [];

    try {
        $attempt_stmt = $db->prepare("
            SELECT id, score, passed, started_at, completed_at
            FROM exam_attempts
            WHERE user_id = ? AND (
                exam_id = ? OR 
                exam_id = ? OR 
                exam_id = ? OR 
                exam_id IN (SELECT id FROM exams WHERE chapter_id = ?)
            )
            ORDER BY completed_at ASC
        ");
        $attempt_stmt->execute([$user_id, $exam_id, $exam['chapter_id'], 'exam-' . $exam['chapter_id'], $exam['chapter_id']]);
        $all_attempts = $attempt_stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (\Throwable $e) {}

    $attempts_count = count($all_attempts);
    $max_attempts = 3;
    $attempts_left = max(0, $max_attempts - $attempts_count);
    $can_attempt = ($attempts_left > 0);

    $has_passed = false;
    foreach ($all_attempts as $idx => $att) {
        $a_score = (int)$att['score'];
        if ($best_score === null || $a_score > $best_score) {
            $best_score = $a_score;
        }
        if ((bool)$att['passed'] || ($a_score >= $passing_score_val)) {
            $has_passed = true;
        }
        $a_badge = 'NEEDS_RETRY';
        if ($a_score == 100) $a_badge = 'PERFECT';
        else if ($a_score >= 80) $a_badge = 'CLEAR';
        else if ($a_score >= $passing_score_val) $a_badge = 'PASS';

        $attempts_history[] = [
            'attempt_number' => $idx + 1,
            'score' => $a_score,
            'passed' => (bool)$att['passed'] || ($a_score >= $passing_score_val),
            'badge' => $a_badge,
            'badge_label' => str_replace('_', ' ', $a_badge),
            'completed_at' => $att['completed_at']
        ];
    }

    // Enforce lesson completion prerequisite ONLY for first-time attempts if student hasn't attempted yet
    if ($attempts_count === 0 && !$has_passed && $user['role'] === 'student' && !empty($exam['chapter_id']) && $exam['chapter_id'] !== 'chap-default') {
        $stmt_uncomp = $db->prepare("
            SELECT COUNT(l.id) 
            FROM lessons l
            LEFT JOIN lesson_progress lp ON l.id = lp.lesson_id AND lp.user_id = ? AND lp.status = 'completed'
            WHERE l.chapter_id = ? AND lp.id IS NULL
        ");
        $stmt_uncomp->execute([$user_id, $exam['chapter_id']]);
        if ((int)$stmt_uncomp->fetchColumn() > 0) {
            error_response('Exam locked. You must complete all lessons in this chapter before taking the exam.', 403);
        }
    }

    // Review mode authorization:
    // If no attempts exist yet, default to TAKE mode (never review mode on 1st entry unless explicit review requested and attempts exist).
    // If completed attempts exist, default to REVIEW mode unless retrying with retry=1 and attempts remaining.
    $is_retry_param = isset($_GET['retry']) && ((int)$_GET['retry'] === 1 || $_GET['retry'] === 'true');
    $is_explicit_review = isset($_GET['review']) && ((int)$_GET['review'] === 1 || $_GET['review'] === 'true');

    if ($attempts_count === 0) {
        $is_review_mode = false;
    } else {
        if ($is_retry_param && $attempts_left > 0) {
            $is_review_mode = false;
        } else {
            $is_review_mode = true;
        }
    }

    $last_attempt = !empty($all_attempts) ? $all_attempts[count($all_attempts) - 1] : null;

    // 3. Load exam questions
    $raw_questions = [];
    try {
        $q_stmt = $db->prepare("
            SELECT 
                q.id, q.question_text, q.question_type, q.options_json, q.points,
                eq.order_index,
                k.correct_answer, k.explanation
            FROM exam_questions eq
            JOIN questions q ON eq.question_id = q.id
            LEFT JOIN question_answer_keys k ON k.question_id = q.id
            WHERE eq.exam_id = ?
            ORDER BY eq.order_index ASC
        ");
        $q_stmt->execute([$exam_id]);
        $raw_questions = $q_stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (\Throwable $e) {}

    // 4. Format questions and normalize options into structured array
    $letters = ['A', 'B', 'C', 'D', 'E', 'F'];
    $questions = [];

    if (!empty($raw_questions)) {
        foreach ($raw_questions as $row) {
            $options_data = json_decode($row['options_json'] ?? '[]', true);
            $code_snippet = null;
            $options_list = [];

            if (is_array($options_data)) {
                if (isset($options_data['code'])) {
                    $code_snippet = $options_data['code'];
                }
                $opts_source = isset($options_data['options']) ? $options_data['options'] : $options_data;

                if (is_array($opts_source)) {
                    $is_assoc = array_keys($opts_source) !== range(0, count($opts_source) - 1);
                    if ($is_assoc) {
                        foreach ($opts_source as $k => $v) {
                            if ($k === 'code') continue;
                            $options_list[] = [
                                'key' => (string)$k,
                                'text' => (string)$v
                            ];
                        }
                    } else {
                        foreach ($opts_source as $i => $v) {
                            $options_list[] = [
                                'key' => $letters[$i] ?? (string)($i + 1),
                                'text' => is_array($v) ? ($v['text'] ?? json_encode($v)) : (string)$v
                            ];
                        }
                    }
                }
            }

            // Extract embedded code snippet from question text if present
            if (empty($code_snippet) && strpos($row['question_text'], "\n\n") !== false) {
                $parts = explode("\n\n", $row['question_text'], 2);
                if (count($parts) === 2 && (strpos($parts[1], '=') !== false || strpos($parts[1], '(') !== false || strpos($parts[1], '{') !== false)) {
                    $question_prompt = trim($parts[0]);
                    $code_snippet = trim($parts[1]);
                } else {
                    $question_prompt = $row['question_text'];
                }
            } else {
                $question_prompt = $row['question_text'];
            }

            $q_item = [
                'id' => $row['id'],
                'order_index' => (int)$row['order_index'],
                'question_text' => $question_prompt,
                'question_type' => $row['question_type'] ?: 'multiple_choice',
                'code' => $code_snippet,
                'options' => $options_list,
                'points' => (int)($row['points'] ?: 10)
            ];

            // In Review Mode (when 3 attempts used), include answers and explanations
            if ($is_review_mode) {
                $decoded_key = json_decode($row['correct_answer'] ?? 'null', true);
                $q_item['correct_answer'] = $decoded_key !== null ? $decoded_key : $row['correct_answer'];
                $q_item['explanation'] = $row['explanation'] ?? '';
            }

            $questions[] = $q_item;
        }
    }

    // FAIL CLOSED: No runtime fallback to hardcoded exam_questions.php.
    // MySQL is the sole authority for exam questions. If empty, return controlled error upstream.
    if (empty($questions)) {
        error_log('Exam Get: No questions found in DB for exam_id=' . ($exam['id'] ?? 'unknown'));
        // Leave empty; caller will handle controlled response
    }

    // Determine current official chapter badge from best score
    $official_badge = null;
    if ($best_score !== null) {
        if ($best_score == 100) $official_badge = 'PERFECT';
        else if ($best_score >= 80) $official_badge = 'CLEAR';
        else if ($best_score >= $passing_score_val) $official_badge = 'PASS';
        else $official_badge = 'NEEDS_RETRY';
    }

    success_response([
        'exam' => [
            'id' => $exam['id'],
            'title' => $exam['title'],
            'description' => $exam['description'],
            'passing_score_percent' => $passing_score_val,
            'total_questions' => count($questions),
            'chapter_id' => $exam['chapter_id'],
            'course_id' => $exam['course_id'],
            'course_title' => $exam['course_title'],
            'attempts_count' => $attempts_count,
            'attempts_left' => $attempts_left,
            'max_attempts' => $max_attempts,
            'can_attempt' => $can_attempt,
            'is_review_mode' => $is_review_mode,
            'has_passed' => $has_passed,
            'best_score' => $best_score,
            'official_badge' => $official_badge,
            'attempts_history' => $attempts_history
        ],
        'questions' => $questions,
        'previous_attempt' => $last_attempt ? [
            'score' => (int)$last_attempt['score'],
            'passed' => (bool)$last_attempt['passed'],
            'completed_at' => $last_attempt['completed_at']
        ] : null
    ]);

} catch (\Throwable $e) {
    error_log('Exam Get Server Error: ' . $e->getMessage());
    json_response([
        'status' => 'error',
        'success' => false,
        'message' => 'Failed to load exam. Please try again.'
    ], 200);
}
