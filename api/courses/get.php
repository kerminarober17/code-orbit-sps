<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../includes/curriculum_helpers.php';

require_get_method();

$course_id = $_GET['id'] ?? $_GET['course'] ?? $_GET['slug'] ?? '';
if (empty($course_id)) {
    error_response('Course ID or slug required', 400);
}

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();
    ensure_curriculum_seeded($db);

    // Fetch course details
    $stmt = $db->prepare("
        SELECT c.id, c.slug, c.academic_group_id, c.title, c.description, 
               c.image_url, c.accent_color, c.is_published,
               ag.name as academic_group_name
        FROM courses c
        LEFT JOIN academic_groups ag ON c.academic_group_id = ag.id
        WHERE c.id = ? OR c.slug = ?
    ");
    $stmt->execute([$course_id, $course_id]);
    $course = $stmt->fetch();
    
    if (!$course) {
        error_response('Course not found', 404);
    }

    $actual_course_id = $course['id'];

    if (!$user && !$course['is_published']) {
        error_response('Forbidden. Course not accessible.', 403);
    }

    // Chapters
    $stmt = $db->prepare("
        SELECT id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward 
        FROM chapters 
        WHERE course_id = ? 
        ORDER BY chapter_number ASC
    ");
    $stmt->execute([$actual_course_id]);
    $chapters = $stmt->fetchAll();

    // Lessons for these chapters
    $chapter_ids = array_column($chapters, 'id');
    $lessons = [];
    $all_ordered_lessons = [];

    if (!empty($chapter_ids)) {
        $in = str_repeat('?,', count($chapter_ids) - 1) . '?';
        $stmt = $db->prepare("
            SELECT l.id, l.chapter_id, l.slug, l.lesson_number, l.title, l.duration_minutes, l.xp_reward,
                   ch.chapter_number
            FROM lessons l
            JOIN chapters ch ON l.chapter_id = ch.id
            WHERE l.chapter_id IN ($in) 
            ORDER BY ch.chapter_number ASC, l.lesson_number ASC
        ");
        $stmt->execute($chapter_ids);
        $lessons_raw = $stmt->fetchAll();
        $all_ordered_lessons = $lessons_raw;
    }

    // Completed lesson IDs for this user
    $completed_lesson_ids = [];
    if ($user) {
        $stmt_lp = $db->prepare("
            SELECT lp.lesson_id 
            FROM lesson_progress lp
            JOIN lessons l ON lp.lesson_id = l.id
            JOIN chapters ch ON l.chapter_id = ch.id
            WHERE ch.course_id = ? AND lp.user_id = ? AND lp.status = 'completed'
        ");
        $stmt_lp->execute([$actual_course_id, $user['id']]);
        $completed_lesson_ids = $stmt_lp->fetchAll(PDO::FETCH_COLUMN);
    }

    // Group regular lessons by chapter
    $lessons_by_chapter = [];
    foreach ($all_ordered_lessons as $l) {
        $lessons_by_chapter[$l['chapter_id']][] = $l;
    }

    // Prepare exam query statements
    $exam_stmt = $db->prepare("
        SELECT id, title, description, passing_score_percent 
        FROM exams 
        WHERE chapter_id = ? 
        LIMIT 1
    ");

    $attempts_stmt = $db->prepare("
        SELECT id, score, passed, started_at, completed_at 
        FROM exam_attempts 
        WHERE user_id = ? AND (exam_id = ? OR exam_id = ? OR exam_id IN (SELECT id FROM exams WHERE chapter_id = ?)) 
        ORDER BY completed_at ASC
    ");

    $prev_ch_completed = true; // Chapter 1 (index 0) is unlocked by default
    $current_lesson_assigned = false;

    foreach ($chapters as $ch_idx => &$chapter) {
        $raw_ch_lessons = $lessons_by_chapter[$chapter['id']] ?? [];
        $is_chapter_unlocked = ($ch_idx === 0) || $prev_ch_completed;

        // Process regular lessons for this chapter
        $processed_lessons = [];
        $ch_comp = 0;
        $prev_lesson_completed = true;

        foreach ($raw_ch_lessons as $l_idx => $l) {
            $l_id = $l['id'];
            $is_comp = in_array($l_id, $completed_lesson_ids);
            if ($is_comp) $ch_comp++;

            $is_les_unlocked = $is_chapter_unlocked && (($l_idx === 0) || $is_comp || $prev_lesson_completed);

            $is_curr = false;
            if ($is_les_unlocked && !$is_comp && !$current_lesson_assigned) {
                $is_curr = true;
                $current_lesson_assigned = true;
            }

            $processed_lessons[] = array_merge($l, [
                'is_completed' => $is_comp,
                'is_unlocked' => $is_les_unlocked,
                'is_current' => $is_curr,
                'status' => $is_comp ? 'completed' : ($is_curr ? 'current' : ($is_les_unlocked ? 'unlocked' : 'locked'))
            ]);

            $prev_lesson_completed = $is_comp;
        }

        $chapter['lessons'] = $processed_lessons;
        $ch_total = count($processed_lessons);
        $all_regular_completed = ($ch_total > 0 && $ch_comp == $ch_total);

        // Fetch Exam & Attempt History
        $exam_stmt->execute([$chapter['id']]);
        $exam = $exam_stmt->fetch(PDO::FETCH_ASSOC);

        $exam_info = null;
        $best_score = null;
        $passing_score = 60; // Enforce strict 60% passing score threshold per requirements

        if (!$exam) {
            $exam = [
                'id' => 'exam-' . $chapter['id'],
                'title' => 'Chapter Assessment Quiz',
                'description' => 'Comprehensive chapter assessment covering core topics and practical evaluation.'
            ];
        }

        $att_user_id = $user ? $user['id'] : '';
        $attempts_stmt->execute([$att_user_id, $exam['id'], $chapter['id'], $chapter['id']]);
        $attempts_raw = $attempts_stmt->fetchAll(PDO::FETCH_ASSOC);

        $att_count = count($attempts_raw);
        $att_left = max(0, 3 - $att_count);

        $attempts_history = [];
        foreach ($attempts_raw as $a_idx => $a) {
            $a_score = (int)$a['score'];
            if ($best_score === null || $a_score > $best_score) {
                $best_score = $a_score;
            }
            $a_badge = 'NEEDS_RETRY';
            if ($a_score == 100) $a_badge = 'PERFECT';
            else if ($a_score >= 80) $a_badge = 'CLEAR';
            else if ($a_score >= $passing_score) $a_badge = 'PASS';

            $attempts_history[] = [
                'attempt_number' => $a_idx + 1,
                'score' => $a_score,
                'passed' => (bool)$a['passed'] || ($a_score >= $passing_score),
                'badge' => $a_badge,
                'badge_label' => str_replace('_', ' ', $a_badge),
                'completed_at' => $a['completed_at']
            ];
        }

        $exam_info = [
            'id' => $exam['id'],
            'title' => $exam['title'],
            'description' => $exam['description'],
            'passing_score_percent' => $passing_score,
            'attempts_count' => $att_count,
            'attempts_left' => $att_left,
            'max_attempts' => 3,
            'best_score' => $best_score,
            'attempts_history' => $attempts_history
        ];

        $exam_passed = ($best_score !== null && $best_score >= $passing_score);
        $exam_unlocked = $is_chapter_unlocked && $all_regular_completed;

        // Authoritative Chapter Badge & Status Evaluation:
        // A chapter is ONLY COMPLETED if the student took and passed the chapter exam.
        if ($exam_passed) {
            if ($best_score == 100) $badge = 'PERFECT';
            else if ($best_score >= 80) $badge = 'CLEAR';
            else $badge = 'PASS';
            $ch_status = 'COMPLETED';
            $prev_ch_completed = true; // Unlocks the NEXT chapter!
        } else {
            $prev_ch_completed = false; // Next chapter remains locked!
            if (!$is_chapter_unlocked) {
                $badge = 'LOCKED';
                $ch_status = 'LOCKED';
            } else if ($all_regular_completed) {
                $badge = 'EXAM_UNLOCKED';
                $ch_status = 'IN_PROGRESS';
            } else if ($ch_comp > 0) {
                $badge = 'IN_PROGRESS';
                $ch_status = 'IN_PROGRESS';
            } else {
                $badge = 'UNLOCKED';
                $ch_status = 'UNLOCKED';
            }
        }

        $chapter['badge'] = $badge;
        $chapter['status'] = $ch_status;
        $chapter['is_unlocked'] = $is_chapter_unlocked;
        $chapter['exam'] = $exam_info;

        // Append Chapter Exam as the 5th item inside $chapter['lessons']
        $exam_lesson_id = $exam ? $exam['id'] : ('exam-' . $chapter['id']);
        $exam_is_curr = false;
        if ($exam_unlocked && !$exam_passed && !$current_lesson_assigned) {
            $exam_is_curr = true;
            $current_lesson_assigned = true;
        }

        $exam_lesson = [
            'id' => $exam_lesson_id,
            'chapter_id' => $chapter['id'],
            'slug' => 'exam-' . $chapter['slug'],
            'lesson_number' => $ch_total + 1,
            'title' => 'Lesson ' . ($ch_total + 1) . ': Chapter ' . ($chapter['chapter_number'] ?? ($ch_idx + 1)) . ' Final Exam & Assessment',
            'duration_minutes' => 15,
            'xp_reward' => 50,
            'is_exam' => true,
            'is_completed' => $exam_passed,
            'is_unlocked' => $exam_passed || $exam_unlocked,
            'is_current' => $exam_is_curr,
            'status' => $exam_passed ? 'completed' : ($exam_unlocked ? 'unlocked' : 'locked')
        ];

        $chapter['lessons'][] = $exam_lesson;

        // Explicit counts: regular lessons are always 4; exam is appended as a synthetic 5th UI item only.
        $ch_total_with_exam = count($chapter['lessons']);
        $ch_comp_with_exam = $ch_comp + ($exam_passed ? 1 : 0);

        $chapter['regular_lessons_count'] = $ch_total;           // authoritative DB regular lessons (4)
        $chapter['completed_regular_count'] = $ch_comp;
        $chapter['completed_count'] = $ch_comp_with_exam;        // includes exam when passed
        $chapter['total_count'] = $ch_total_with_exam;           // regular + exam slot (UI)
        $chapter['progress'] = $ch_total_with_exam > 0 ? round(($ch_comp_with_exam / $ch_total_with_exam) * 100) : 0;
    }
    unset($chapter);
    
    // Recalculate total course lessons & completion
    $total_lessons_count = 0;
    $completed_lessons_count = 0;
    foreach ($chapters as $ch) {
        $total_lessons_count += count($ch['lessons'] ?? []);
        foreach ($ch['lessons'] ?? [] as $cl) {
            if (!empty($cl['is_completed'])) {
                $completed_lessons_count++;
            }
        }
    }

    $course['chapters'] = $chapters;
    $course['total_lessons'] = $total_lessons_count;
    $course['completed_lessons'] = $completed_lessons_count;
    $course['progress'] = $total_lessons_count > 0 ? round(($completed_lessons_count / $total_lessons_count) * 100) : 0;

    // Fetch Capstone project for course
    $stmt_p = $db->prepare("SELECT id, title, description, xp_reward FROM projects WHERE course_id = ? LIMIT 1");
    $stmt_p->execute([$actual_course_id]);
    $course['capstone_project'] = $stmt_p->fetch() ?: null;

    success_response($course);

} catch (Exception $e) {
    error_log('Course Get Server Error: ' . $e->getMessage());
    error_response('Server error. Please try again.', 500);
}

