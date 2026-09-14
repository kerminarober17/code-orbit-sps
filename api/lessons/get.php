<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../includes/curriculum_helpers.php';

require_get_method();

$id = $_GET['id'] ?? '';
if (empty($id)) {
    error_response('Lesson ID required', 400);
}

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();
    
    // Get lesson, chapter, course, and academic group
    $stmt = $db->prepare("
        SELECT 
            l.id, l.chapter_id, l.slug, l.lesson_number, l.title, l.duration_minutes, l.xp_reward,
            c.id as chapter_id, c.title as chapter_title, c.chapter_number, c.icon_symbol as chapter_icon, c.course_id,
            co.slug as course_slug, co.title as course_title, co.accent_color, co.image_url as course_image,
            ag.name as academic_group_name
        FROM lessons l
        JOIN chapters c ON l.chapter_id = c.id
        JOIN courses co ON c.course_id = co.id
        LEFT JOIN academic_groups ag ON co.academic_group_id = ag.id
        WHERE l.id = ? OR l.slug = ?
    ");
    $stmt->execute([$id, $id]);
    $lesson = $stmt->fetch();

    // Fallback: resolve lesson from curriculum_export.json when not yet present in MySQL
    // (e.g. Python Level 2 content shipped in export before/without full SQL import)
    if (!$lesson) {
        $export_file = __DIR__ . '/../../data/curriculum_export.json';
        $export_lesson = null;
        $export_chapter = null;
        $export_course = null;
        if (file_exists($export_file)) {
            $export_courses = json_decode(file_get_contents($export_file), true);
            if (is_array($export_courses)) {
                foreach ($export_courses as $ec) {
                    foreach (($ec['chapters'] ?? []) as $ech) {
                        foreach (($ech['lessons'] ?? []) as $eles) {
                            $lid = (string)($eles['id'] ?? '');
                            $lslug = (string)($eles['slug'] ?? '');
                            if ($lid === $id || $lslug === $id || strcasecmp($lid, $id) === 0) {
                                $export_lesson = $eles;
                                $export_chapter = $ech;
                                $export_course = $ec;
                                break 3;
                            }
                        }
                    }
                }
            }
        }
        if (!$export_lesson || !$export_course) {
            error_response('Lesson not found', 404);
        }

        $course_id = $export_course['id'] ?? '';
        $chapter_id = $export_chapter['id'] ?? '';

        // Prefer live course/chapter rows when they exist (for enrollment + progress)
        $stmt_co = $db->prepare("SELECT id, slug, title, accent_color, image_url, academic_group_id, is_published FROM courses WHERE id = ? OR slug = ? LIMIT 1");
        $stmt_co->execute([$course_id, $export_course['slug'] ?? '']);
        $co_row = $stmt_co->fetch();
        if ($co_row) {
            $course_id = $co_row['id'];
        }

        $stmt_ch = $db->prepare("SELECT id, title, chapter_number, icon_symbol, course_id FROM chapters WHERE id = ? OR (course_id = ? AND chapter_number = ?) LIMIT 1");
        $stmt_ch->execute([
            $chapter_id,
            $course_id,
            (int)($export_chapter['chapter_number'] ?? 1)
        ]);
        $ch_row = $stmt_ch->fetch();
        if ($ch_row) {
            $chapter_id = $ch_row['id'];
        }

        $lesson = [
            'id' => $export_lesson['id'],
            'chapter_id' => $chapter_id,
            'slug' => $export_lesson['slug'] ?? $export_lesson['id'],
            'lesson_number' => (int)($export_lesson['lesson_number'] ?? 1),
            'title' => $export_lesson['title'] ?? 'Lesson',
            'duration_minutes' => (int)($export_lesson['duration'] ?? $export_lesson['duration_minutes'] ?? 12),
            'xp_reward' => (int)($export_lesson['xp'] ?? $export_lesson['xp_reward'] ?? 25),
            'chapter_title' => $ch_row['title'] ?? ($export_chapter['title'] ?? ''),
            'chapter_number' => (int)($ch_row['chapter_number'] ?? $export_chapter['chapter_number'] ?? 1),
            'chapter_icon' => $ch_row['icon_symbol'] ?? ($export_chapter['icon_symbol'] ?? '🚀'),
            'course_id' => $course_id,
            'course_slug' => $co_row['slug'] ?? ($export_course['slug'] ?? ''),
            'course_title' => $co_row['title'] ?? ($export_course['title'] ?? ''),
            'accent_color' => $co_row['accent_color'] ?? ($export_course['accent_color'] ?? null),
            'course_image' => $co_row['image_url'] ?? ($export_course['image_url'] ?? null),
            'academic_group_name' => null,
            '_from_export' => true,
            '_export_blocks' => $export_lesson['blocks'] ?? [],
        ];
    }
    
    $course_id = $lesson['course_id'];
    $chapter_id = $lesson['chapter_id'];

    if ($user && $user['role'] === 'student') {
        if (!can_student_access_course($db, $course_id, $user)) {
            error_response('Forbidden', 403);
        }

        // Confirm enrollment
        $stmt_enroll = $db->prepare("SELECT id FROM course_enrollments WHERE course_id = ? AND user_id = ?");
        $stmt_enroll->execute([$course_id, $user['id']]);
        if (!$stmt_enroll->fetch()) {
            error_response('Forbidden. You are not enrolled in this course.', 403);
        }

        // --- SERVER SIDE SEQUENTIAL UNLOCK VALIDATION ---
        $stmt_first_ch = $db->prepare("SELECT id FROM chapters WHERE course_id = ? ORDER BY chapter_number ASC LIMIT 1");
        $stmt_first_ch->execute([$course_id]);
        $first_chapter_id = $stmt_first_ch->fetchColumn();

        $stmt_first_les = $db->prepare("SELECT id FROM lessons WHERE chapter_id = ? ORDER BY lesson_number ASC LIMIT 1");
        $stmt_first_les->execute([$chapter_id]);
        $first_lesson_id = $stmt_first_les->fetchColumn();

        $is_first_lesson_of_course = ($chapter_id === $first_chapter_id && $lesson['id'] === $first_lesson_id);

        if (!$is_first_lesson_of_course) {
            if ($lesson['id'] === $first_lesson_id) {
                // First lesson of subsequent chapter: Check if previous chapter exam is passed (or lessons completed if no exam)
                $stmt_prev_ch = $db->prepare("
                    SELECT id FROM chapters 
                    WHERE course_id = ? AND chapter_number < ? 
                    ORDER BY chapter_number DESC LIMIT 1
                ");
                $stmt_prev_ch->execute([$course_id, $lesson['chapter_number']]);
                $prev_chapter_id = $stmt_prev_ch->fetchColumn();

                if ($prev_chapter_id) {
                    // Check 1: Is chapter_progress marked 'completed' for this user & chapter?
                    $stmt_cp = $db->prepare("SELECT id FROM chapter_progress WHERE user_id = ? AND chapter_id = ? AND status = 'completed'");
                    $stmt_cp->execute([$user['id'], $prev_chapter_id]);
                    $prev_cp_completed = (bool)$stmt_cp->fetch();

                    if (!$prev_cp_completed) {
                        // Check 2: Does a passing exam attempt exist for the previous chapter?
                        $stmt_prev_exam = $db->prepare("SELECT id FROM exams WHERE chapter_id = ? LIMIT 1");
                        $stmt_prev_exam->execute([$prev_chapter_id]);
                        $prev_exam_id = $stmt_prev_exam->fetchColumn();

                        $stmt_pass = $db->prepare("
                            SELECT id FROM exam_attempts 
                            WHERE user_id = ? AND (passed = 1 OR score >= 60) AND (
                                exam_id = ? OR 
                                exam_id = ? OR 
                                exam_id = ? OR 
                                exam_id IN (SELECT id FROM exams WHERE chapter_id = ?)
                            )
                        ");
                        $stmt_pass->execute([
                            $user['id'],
                            $prev_exam_id ?: '',
                            $prev_chapter_id,
                            'exam-' . $prev_chapter_id,
                            $prev_chapter_id
                        ]);
                        $prev_exam_passed = (bool)$stmt_pass->fetch();

                        if (!$prev_exam_passed) {
                            if (!$prev_exam_id) {
                                $stmt_uncomp = $db->prepare("
                                    SELECT COUNT(l.id) FROM lessons l
                                    LEFT JOIN lesson_progress lp ON l.id = lp.lesson_id AND lp.user_id = ? AND lp.status = 'completed'
                                    WHERE l.chapter_id = ? AND lp.id IS NULL
                                ");
                                $stmt_uncomp->execute([$user['id'], $prev_chapter_id]);
                                if ((int)$stmt_uncomp->fetchColumn() > 0) {
                                    error_response('Chapter locked. Complete all lessons of the previous chapter first.', 403);
                                }
                            } else {
                                error_response('Chapter locked. You must pass the previous chapter exam to unlock this chapter.', 403);
                            }
                        }
                    }
                }
            } else {
                // Subsequent lesson of current chapter: check if previous lesson is completed
                $stmt_prev_les = $db->prepare("
                    SELECT id FROM lessons 
                    WHERE chapter_id = ? AND lesson_number < ? 
                    ORDER BY lesson_number DESC LIMIT 1
                ");
                $stmt_prev_les->execute([$chapter_id, $lesson['lesson_number']]);
                $prev_lesson_id = $stmt_prev_les->fetchColumn();
                
                if ($prev_lesson_id) {
                    $stmt_lp_check = $db->prepare("SELECT id FROM lesson_progress WHERE user_id = ? AND lesson_id = ? AND status = 'completed'");
                    $stmt_lp_check->execute([$user['id'], $prev_lesson_id]);
                    if (!$stmt_lp_check->fetch()) {
                        error_response('Lesson locked. You must complete the previous lesson first.', 403);
                    }
                }
            }
        }
    } else if (!$user) {
        $stmt = $db->prepare("SELECT is_published FROM courses WHERE id = ?");
        $stmt->execute([$course_id]);
        $c = $stmt->fetch();
        if (!$c || !$c['is_published']) {
            error_response('Forbidden', 403);
        }
    }

    // Check if current user completed this lesson
    $is_completed = false;
    if ($user) {
        $stmt_lp = $db->prepare("SELECT status FROM lesson_progress WHERE user_id = ? AND lesson_id = ?");
        $stmt_lp->execute([$user['id'], $lesson['id']]);
        $lp = $stmt_lp->fetch();
        if ($lp && $lp['status'] === 'completed') {
            $is_completed = true;
        }
    }
    $lesson['is_completed'] = $is_completed;
    // If we reached here without a 403, the lesson is accessible.
    // Set is_unlocked so the client-side access guard trusts the server verdict.
    $lesson['is_unlocked'] = true;

    // Get all lessons in this chapter for outline / stepper
    $stmt_all = $db->prepare("
        SELECT id, slug, lesson_number, title, duration_minutes, xp_reward
        FROM lessons
        WHERE chapter_id = ?
        ORDER BY lesson_number ASC
    ");
    $stmt_all->execute([$chapter_id]);
    $all_lessons = $stmt_all->fetchAll();

    // Attach completion states to all lessons
    $completed_map = [];
    if ($user) {
        $stmt_user_lps = $db->prepare("SELECT lesson_id FROM lesson_progress WHERE user_id = ? AND status = 'completed'");
        $stmt_user_lps->execute([$user['id']]);
        $comp_ids = $stmt_user_lps->fetchAll(PDO::FETCH_COLUMN);
        foreach ($comp_ids as $c_id) {
            $completed_map[$c_id] = true;
        }
    }

    // Append Chapter Exam as Lesson 5 in all_lessons
    $exam_stmt = $db->prepare("SELECT id, passing_score_percent FROM exams WHERE chapter_id = ? LIMIT 1");
    $exam_stmt->execute([$chapter_id]);
    $exam_row = $exam_stmt->fetch();
    $exam_id = $exam_row ? $exam_row['id'] : ('exam-' . $chapter_id);
    $passing_score = (int)($exam_row['passing_score_percent'] ?? 70);

    $exam_passed = false;
    if ($user) {
        $att_stmt = $db->prepare("SELECT score FROM exam_attempts WHERE user_id = ? AND (exam_id = ? OR exam_id = ?) AND (passed = 1 OR score >= ?) LIMIT 1");
        $att_stmt->execute([$user['id'], $exam_id, $chapter_id, $passing_score]);
        if ($att_stmt->fetch()) {
            $exam_passed = true;
        }
    }

    $exam_lesson_item = [
        'id' => $exam_id,
        'slug' => 'exam-' . $chapter_id,
        'lesson_number' => count($all_lessons) + 1,
        'title' => 'Lesson ' . (count($all_lessons) + 1) . ': Final Exam & Assessment',
        'duration_minutes' => 15,
        'xp_reward' => 50,
        'is_exam' => true,
        'is_completed' => $exam_passed
    ];
    $all_lessons[] = $exam_lesson_item;

    $prev_lesson = null;
    $next_lesson = null;
    $curr_idx = -1;

    foreach ($all_lessons as $idx => &$al) {
        if (empty($al['is_exam'])) {
            $al['is_completed'] = !empty($completed_map[$al['id']]);
        }
        if ($al['id'] === $lesson['id']) {
            $curr_idx = $idx;
        }
    }
    unset($al);

    if ($curr_idx > 0) {
        $prev_lesson = $all_lessons[$curr_idx - 1];
    }
    if ($curr_idx >= 0 && $curr_idx < count($all_lessons) - 1) {
        $next_lesson = $all_lessons[$curr_idx + 1];
    }

    $lesson['chapter_lessons'] = $all_lessons;
    $lesson['prev_lesson'] = $prev_lesson;
    $lesson['next_lesson'] = $next_lesson;

    // Get Capstone Project
    $stmt_cap = $db->prepare("SELECT id, title, description, xp_reward FROM projects WHERE course_id = ? LIMIT 1");
    $stmt_cap->execute([$course_id]);
    $lesson['capstone_project'] = $stmt_cap->fetch() ?: null;

    // Get lesson blocks
    $stmt_b = $db->prepare("
        SELECT id, lesson_id, block_type, order_index, content_json 
        FROM lesson_blocks 
        WHERE lesson_id = ? 
        ORDER BY order_index ASC
    ");
    $stmt_b->execute([$lesson['id']]);
    $blocks_raw = $stmt_b->fetchAll();
    
    $blocks = [];
    foreach ($blocks_raw as $b) {
        $content = json_decode($b['content_json'], true);
        $blocks[] = [
            'id' => $b['id'],
            'block_type' => $b['block_type'],
            'order_index' => (int)$b['order_index'],
            'content_json' => $content,
            'content' => $content
        ];
    }

    // Prefer blocks captured during export-only resolution
    if (empty($blocks) && !empty($lesson['_export_blocks']) && is_array($lesson['_export_blocks'])) {
        foreach ($lesson['_export_blocks'] as $eb) {
            $blocks[] = [
                'id' => $eb['id'] ?? null,
                'block_type' => $eb['block_type'] ?? 'text',
                'order_index' => $eb['order_index'] ?? $eb['sort_order'] ?? count($blocks) + 1,
                'content_json' => $eb['content'] ?? $eb['content_json'] ?? [],
                'content' => $eb['content'] ?? $eb['content_json'] ?? [],
            ];
        }
    }
    unset($lesson['_export_blocks'], $lesson['_from_export']);

    // If database blocks are empty or sparse, fall back to curriculum_export.json
    $export_file = __DIR__ . '/../../data/curriculum_export.json';
    if (file_exists($export_file)) {
        $export_courses = json_decode(file_get_contents($export_file), true);
        if (is_array($export_courses)) {
            foreach ($export_courses as $ec) {
                foreach (($ec['chapters'] ?? []) as $ech) {
                    foreach (($ech['lessons'] ?? []) as $eles) {
                        $is_match = false;
                        if (($eles['id'] ?? '') === $lesson['id']) {
                            $is_match = true;
                        } elseif (($eles['slug'] ?? '') === $lesson['slug']) {
                            if (($ec['id'] ?? '') === $lesson['course_id'] || ($ec['slug'] ?? '') === $lesson['course_slug']) {
                                $is_match = true;
                            }
                        }

                        if ($is_match) {
                            if (empty($blocks) && !empty($eles['blocks'])) {
                                $blocks = $eles['blocks'];
                            }
                            if (!empty($eles['predict_question'])) {
                                $lesson['predict_question'] = $eles['predict_question'];
                            }
                            if (!empty($eles['checkpoint_question'])) {
                                $lesson['checkpoint_question'] = $eles['checkpoint_question'];
                            }
                            if (!empty($eles['key_points'])) {
                                $lesson['key_points'] = $eles['key_points'];
                            }
                            break 3;
                        }
                    }
                }
            }
        }
    }
    
    $lesson['blocks'] = $blocks;

    success_response($lesson);

} catch (Exception $e) {
    error_log('Lessons Get Error: ' . $e->getMessage()); error_response('Server error. Please try again.', 500);
}