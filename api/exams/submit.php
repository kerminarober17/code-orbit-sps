<?php
ini_set('display_errors', 0);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED);
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../middleware/csrf.php';

try {
    require_post_method();

    // Require student authentication
    $user = require_auth(['student', 'teacher', 'admin']);

    // Verify CSRF token
    verify_csrf_token();
    $user_id = $user['id'];

    $data = get_json_request();
    $exam_id = trim($data['exam_id'] ?? '');
    $submitted_answers = $data['answers'] ?? [];

    if (empty($exam_id)) {
        json_response([
            'status' => 'error',
            'success' => false,
            'message' => 'Exam ID is required'
        ], 200);
        exit;
    }

    $db = get_db_connection();

    // 1. Verify exam exists and retrieve course/chapter
    $stmt = $db->prepare("
        SELECT 
            e.id, e.title, e.chapter_id, e.passing_score_percent,
            ch.course_id, c.is_published
        FROM exams e
        LEFT JOIN chapters ch ON e.chapter_id = ch.id
        LEFT JOIN courses c ON ch.course_id = c.id
        WHERE e.id = ? OR e.chapter_id = ? OR ch.id = ? OR ch.slug = ?
        LIMIT 1
    ");
    $stmt->execute([$exam_id, $exam_id, $exam_id, $exam_id]);
    $exam = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$exam) {
        $ch_search = !empty($data['chapter_id']) ? $data['chapter_id'] : $exam_id;
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
            // Chapter found but no exam record in DB. Materialize a real exam record
            // to satisfy the exam_attempts.exam_id FK constraint (REFERENCES exams(id)).
            // Check first whether one was already created (idempotent).
            $find_exam = $db->prepare("SELECT id FROM exams WHERE chapter_id = ? LIMIT 1");
            $find_exam->execute([$ch_row['chapter_id']]);
            $existing_exam = $find_exam->fetch(PDO::FETCH_ASSOC);
            if ($existing_exam) {
                $real_exam_id = $existing_exam['id'];
            } else {
                $real_exam_id = generate_uuid_v4(); // proper CHAR(36) UUID
                $exam_title_str = $ch_row['chapter_title'] . ' Final Exam & Assessment';
                $ins_exam = $db->prepare("
                    INSERT INTO exams (id, chapter_id, title, description, passing_score_percent)
                    VALUES (?, ?, ?, 'Comprehensive chapter assessment covering core topics.', 60)
                ");
                $ins_exam->execute([$real_exam_id, $ch_row['chapter_id'], $exam_title_str]);
            }
            $exam = [
                'id' => $real_exam_id,
                'title' => $ch_row['chapter_title'] . ' Final Exam & Assessment',
                'chapter_id' => $ch_row['chapter_id'],
                'passing_score_percent' => 60,
                'course_id' => $ch_row['course_id'],
                'is_published' => $ch_row['is_published'] ?? 1
            ];
            // Update $exam_id to the materialized real ID so subsequent queries use it
            $exam_id = $real_exam_id;
        } else {
            // No exam and no matching chapter found — refuse submission
            json_response([
                'status' => 'error',
                'success' => false,
                'message' => 'Exam not found'
            ], 404);
            exit;
        }
    }
    
    $exam_id = $exam['id'];

    // Enforce lesson completion prerequisite for students only if no prior attempts
    $att_count_stmt = $db->prepare("
        SELECT COUNT(*) FROM exam_attempts 
        WHERE user_id = ? AND (
            exam_id = ? OR 
            exam_id = ? OR 
            exam_id = ? OR 
            exam_id IN (SELECT id FROM exams WHERE chapter_id = ?)
        )
    ");
    $att_count_stmt->execute([$user_id, $exam_id, $exam['chapter_id'], 'exam-' . $exam['chapter_id'], $exam['chapter_id']]);
    $existing_attempts = (int)$att_count_stmt->fetchColumn();

    if ($existing_attempts === 0 && $user['role'] === 'student' && !empty($exam['chapter_id']) && $exam['chapter_id'] !== 'chap-default') {
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

    if ($existing_attempts >= 3) {
        json_response([
            'status' => 'error',
            'success' => false,
            'message' => 'Maximum 3 attempts limit reached for this chapter exam.',
            'attempts_left' => 0,
            'can_retry' => false
        ], 200);
        exit;
    }

    // 3. Load all questions for this exam along with SECURE answer keys
    $q_stmt = $db->prepare("
        SELECT 
            q.id as question_id, q.question_text, q.question_type, q.options_json, q.points,
            eq.order_index,
            k.correct_answer, k.explanation
        FROM exam_questions eq
        JOIN questions q ON eq.question_id = q.id
        LEFT JOIN question_answer_keys k ON k.question_id = q.id
        WHERE eq.exam_id = ?
        ORDER BY eq.order_index ASC
    ");
    $q_stmt->execute([$exam_id]);
    $exam_questions = $q_stmt->fetchAll(PDO::FETCH_ASSOC);

    // Normalize submitted answers into a map [question_id => selected_answer]
    $answers_map = [];
    if (is_array($submitted_answers)) {
        $is_assoc = array_keys($submitted_answers) !== range(0, count($submitted_answers) - 1);
        if ($is_assoc) {
            $answers_map = $submitted_answers;
        } else {
            foreach ($submitted_answers as $item) {
                if (is_array($item) && isset($item['question_id'])) {
                    $answers_map[$item['question_id']] = $item['answer'] ?? null;
                }
            }
        }
    }

    $total_points = 0;
    $earned_points = 0;
    $graded_answers = [];
    $letters = ['A', 'B', 'C', 'D', 'E', 'F'];

    // FAIL CLOSED: MySQL is sole authority. No hardcoded exam_questions.php fallback.
    if (empty($exam_questions)) {
        error_log('Exam Submit: No questions in DB for exam_id=' . ($exam['id'] ?? 'unknown'));
        error_response('Exam questions are not available. Please contact support.', 503);
    }

    foreach ($exam_questions as $q) {
        $qid = $q['question_id'];
        $order_idx = (int)($q['order_index'] ?? 1);
        $pts = (int)($q['points'] > 0 ? $q['points'] : 10);
        $total_points += $pts;

        // Multi-fallback answer lookup by ID or index
        $user_answer = $answers_map[$qid] 
            ?? $answers_map[(string)$qid] 
            ?? $answers_map[$order_idx] 
            ?? $answers_map[(string)$order_idx] 
            ?? $answers_map[$order_idx - 1] 
            ?? $answers_map[(string)($order_idx - 1)] 
            ?? null;

        if (($q['question_type'] ?? '') === 'essay') {
            $user_text = strtolower(trim((string)$user_answer));
            $keywords = $q['auto_grade_keywords'] ?? ['doctype', 'html', 'head', 'body', 'heading', 'paragraph', 'semantic', 'structure', 'tag'];
            $matched = 0;
            foreach ($keywords as $kw) {
                if (!empty($kw) && strpos($user_text, strtolower($kw)) !== false) {
                    $matched++;
                }
            }
            $points_earned = 0;
            if ($matched >= 2) {
                $points_earned = $pts;
            } elseif ($matched === 1) {
                $points_earned = (int)round($pts * 0.6);
            } elseif (strlen($user_text) >= 10) {
                $points_earned = (int)round($pts * 0.4);
            }
            $is_correct = ($points_earned >= (int)round($pts * 0.6));
            $earned_points += $points_earned;

            $graded_answers[] = [
                'question_id' => $qid,
                'question_type' => 'essay',
                'order_index' => $order_idx,
                'submitted_answer' => $user_answer ?: 'No response provided',
                'correct_answer' => 'See Model Answer',
                'model_answer' => $q['model_answer'] ?? '',
                'is_correct' => $is_correct ? 1 : 0,
                'points_possible' => $pts,
                'points_earned' => $points_earned,
                'explanation' => $q['explanation'] ?? ''
            ];
        } else {
            // Multiple Choice Evaluation
            $key_data = json_decode($q['correct_answer'] ?? 'null', true);
            $expected_key = null;

            if ($key_data !== null) {
                if (is_array($key_data)) {
                    if (isset($key_data['correct_index'])) {
                        $expected_key = strtoupper(trim((string)($letters[$key_data['correct_index']] ?? $key_data['correct_index'])));
                    } elseif (isset($key_data['correct_value'])) {
                        $expected_key = strtoupper(trim((string)$key_data['correct_value']));
                    } elseif (isset($key_data['answer'])) {
                        $expected_key = strtoupper(trim((string)$key_data['answer']));
                    }
                } else {
                    $expected_key = strtoupper(trim((string)$key_data));
                }
            } else {
                $expected_key = strtoupper(trim((string)$q['correct_answer']));
            }

            $is_correct = false;
            if ($user_answer !== null) {
                if (is_numeric($user_answer)) {
                    $user_key = strtoupper(trim((string)($letters[(int)$user_answer] ?? $user_answer)));
                } else {
                    $user_key = strtoupper(trim((string)$user_answer));
                }

                if ($expected_key !== null && $user_key !== null && $expected_key === $user_key) {
                    $is_correct = true;
                }
            }

            if ($is_correct) {
                $earned_points += $pts;
            }

            $graded_answers[] = [
                'question_id' => $qid,
                'question_type' => 'multiple_choice',
                'order_index' => $order_idx,
                'submitted_answer' => $user_answer,
                'correct_answer' => $expected_key,
                'is_correct' => $is_correct ? 1 : 0,
                'points_possible' => $pts,
                'points_earned' => $is_correct ? $pts : 0,
                'explanation' => $q['explanation'] ?? ''
            ];
        }
    }

    // Score calculation
    $score_percent = $total_points > 0 ? (int)round(($earned_points / $total_points) * 100) : 0;
    $passing_percent = 60; // Enforce strict 60% passing score threshold per requirements
    $passed = ($score_percent >= $passing_percent) ? 1 : 0;

    // BADGE EVALUATION RULE:
    // 100%       -> "PERFECT" Badge (Emerald Green)
    // 80% - 99%  -> "CLEAR" Badge (Cyan Blue)
    // 60% - 79%  -> "PASS" Badge
    // Below 60%  -> "NEEDS_RETRY" Badge (Warm Amber/Yellow)
    $badge = 'NEEDS_RETRY';
    if ($score_percent == 100) {
        $badge = 'PERFECT';
    } elseif ($score_percent >= 80) {
        $badge = 'CLEAR';
    } elseif ($score_percent >= $passing_percent) {
        $badge = 'PASS';
    }

    // Database transaction
    $attempt_id = generate_uuid_v4();
    $now = date('Y-m-d H:i:s');

    $db->beginTransaction();

    // 1. Insert into exam_attempts
    $ins_attempt = $db->prepare("
        INSERT INTO exam_attempts (id, user_id, exam_id, score, passed, started_at, completed_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ");
    $ins_attempt->execute([$attempt_id, $user_id, $exam_id, $score_percent, $passed, $now, $now]);

    // 2. Insert into answers
    $ins_ans = $db->prepare("
        INSERT INTO answers (id, exam_attempt_id, question_id, submitted_answer, is_correct)
        VALUES (?, ?, ?, ?, ?)
    ");
    foreach ($graded_answers as $ans) {
        $ans_id = generate_uuid_v4();
        $ins_ans->execute([
            $ans_id,
            $attempt_id,
            $ans['question_id'],
            json_encode($ans['submitted_answer']),
            $ans['is_correct']
        ]);
    }

    // 3. Compute Highest Score achieved among all attempts
    $max_stmt = $db->prepare("SELECT MAX(score) as highest_score FROM exam_attempts WHERE user_id = ? AND exam_id = ?");
    $max_stmt->execute([$user_id, $exam_id]);
    $highest_score = (int)$max_stmt->fetchColumn();
    if ($highest_score < $score_percent) {
        $highest_score = $score_percent;
    }

    // Evaluate official chapter badge based on HIGHEST score
    $highest_badge = 'NEEDS_RETRY';
    if ($highest_score == 100) {
        $highest_badge = 'PERFECT';
    } elseif ($highest_score >= 80) {
        $highest_badge = 'CLEAR';
    } elseif ($highest_score >= $passing_percent) {
        $highest_badge = 'PASS';
    }

    $highest_passed = ($highest_score >= $passing_percent);

    // 4. Award XP (+50 XP) and update gamification if passed
    $xp_awarded = 0;
    if ($passed) {
        // Prevent multiple XP farming for the same exam
        $prev_pass_stmt = $db->prepare("
            SELECT COUNT(*) FROM exam_attempts 
            WHERE user_id = ? AND exam_id = ? AND passed = 1 AND id != ?
        ");
        $prev_pass_stmt->execute([$user_id, $exam_id, $attempt_id]);
        $already_passed = (int)$prev_pass_stmt->fetchColumn() > 0;

        if (!$already_passed) {
            $xp_awarded = 50;
            // Record XP Event
            $xp_id = generate_uuid_v4();
            $ins_xp = $db->prepare("
                INSERT INTO xp_events (id, user_id, amount, source_type, source_id)
                VALUES (?, ?, ?, 'exam', ?)
            ");
            $ins_xp->execute([$xp_id, $user_id, $xp_awarded, $exam_id]);

            // Update student_gamification
            $upd_gam = $db->prepare("
                INSERT INTO student_gamification (id, user_id, total_xp, current_streak, longest_streak, last_activity_date)
                VALUES (?, ?, ?, 1, 1, CURRENT_DATE())
                ON DUPLICATE KEY UPDATE 
                    total_xp = total_xp + VALUES(total_xp),
                    last_activity_date = CURRENT_DATE()
            ");
            $upd_gam->execute([generate_uuid_v4(), $user_id, $xp_awarded]);
        }
    }

    // Mark chapter progress as completed if highest score has passed
    if ($highest_passed && !empty($exam['chapter_id'])) {
        $ch_id = $exam['chapter_id'];
        $check_cp = $db->prepare("SELECT id, status FROM chapter_progress WHERE user_id = ? AND chapter_id = ?");
        $check_cp->execute([$user_id, $ch_id]);
        $existing_cp = $check_cp->fetch();
        if ($existing_cp) {
            $upd = $db->prepare("UPDATE chapter_progress SET status = 'completed', completed_at = IFNULL(completed_at, NOW()) WHERE id = ?");
            $upd->execute([$existing_cp['id']]);
        } else {
            $ins = $db->prepare("INSERT INTO chapter_progress (id, user_id, chapter_id, status, started_at, completed_at) VALUES (?, ?, ?, 'completed', NOW(), NOW())");
            $ins->execute([generate_uuid_v4(), $user_id, $ch_id]);
        }
    }

    if (!empty($exam['course_id']) && $exam['course_id'] !== 'course-default') {
        $c_id = $exam['course_id'];
        $check_cop = $db->prepare("SELECT id, status FROM course_progress WHERE user_id = ? AND course_id = ?");
        $check_cop->execute([$user_id, $c_id]);
        $existing_cop = $check_cop->fetch();
        if (!$existing_cop) {
            $db->prepare("INSERT INTO course_progress (id, user_id, course_id, status, started_at) VALUES (?, ?, ?, 'in_progress', NOW())")->execute([generate_uuid_v4(), $user_id, $c_id]);
        }
    }

    $db->commit();

    $attempts_used = $existing_attempts + 1;
    $attempts_left = max(0, 3 - $attempts_used);
    $can_retry = ($attempts_left > 0);
    $is_review_mode = ($attempts_left <= 0);

    success_response([
        'attempt_id' => $attempt_id,
        'exam_id' => $exam_id,
        'chapter_id' => $exam['chapter_id'] ?? '',
        'course_id' => $exam['course_id'] ?? '',
        'score' => $score_percent,
        'highest_score' => $highest_score,
        'passed' => (bool)$passed,
        'highest_passed' => (bool)$highest_passed,
        'passing_score_percent' => $passing_percent,
        'badge' => $badge,
        'badge_label' => str_replace('_', ' ', $badge),
        'highest_badge' => $highest_badge,
        'highest_badge_label' => str_replace('_', ' ', $highest_badge),
        'points_earned' => $earned_points,
        'total_points' => $total_points,
        'xp_awarded' => $xp_awarded,
        'attempts_used' => $attempts_used,
        'attempts_left' => $attempts_left,
        'max_attempts' => 3,
        'can_retry' => $can_retry,
        'is_review_mode' => $is_review_mode,
        'review' => $graded_answers
    ]);

} catch (\Throwable $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    error_log('Exam Submit Server Error: ' . $e->getMessage());
    json_response([
        'status' => 'error',
        'success' => false,
        'message' => 'Error submitting exam. Please try again.'
    ], 200);
}
