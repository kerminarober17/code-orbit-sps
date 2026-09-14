<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/student.php';

require_get_method();
$user = require_student();

try {
    $db = get_db_connection();
    $user_id = $user['id'];

    // 1. Gamification summary
    $gam_stmt = $db->prepare("SELECT total_xp, current_streak, longest_streak FROM student_gamification WHERE user_id = ?");
    $gam_stmt->execute([$user_id]);
    $gam = $gam_stmt->fetch() ?: ['total_xp' => 0, 'current_streak' => 0, 'longest_streak' => 0];

    $total_xp = (int)$gam['total_xp'];
    $level = (int)floor($total_xp / 100) + 1;

    // 2. Completed lessons total
    $comp_stmt = $db->prepare("SELECT COUNT(*) FROM lesson_progress WHERE user_id = ? AND status = 'completed'");
    $comp_stmt->execute([$user_id]);
    $total_completed_lessons = (int)$comp_stmt->fetchColumn();

    // 3. Completed chapters total
    $comp_ch_stmt = $db->prepare("SELECT COUNT(*) FROM chapter_progress WHERE user_id = ? AND status = 'completed'");
    $comp_ch_stmt->execute([$user_id]);
    $total_completed_chapters = (int)$comp_ch_stmt->fetchColumn();

    // 4. Detailed courses breakdown
    $courses_stmt = $db->prepare("
        SELECT c.id, c.title, c.slug, c.description, c.image_url, c.accent_color, ce.created_at as enrolled_at
        FROM courses c
        JOIN course_enrollments ce ON c.id = ce.course_id
        WHERE ce.user_id = ?
        ORDER BY ce.created_at ASC
    ");
    $courses_stmt->execute([$user_id]);
    $courses = $courses_stmt->fetchAll();

    $courses_progress = [];
    foreach ($courses as $c) {
        $course_id = $c['id'];

        // Chapters in this course
        $ch_stmt = $db->prepare("
            SELECT ch.id, ch.chapter_number, ch.title, ch.description, ch.xp_reward,
                   cp.status as chapter_status, cp.completed_at as chapter_completed_at
            FROM chapters ch
            LEFT JOIN chapter_progress cp ON ch.id = cp.chapter_id AND cp.user_id = ?
            WHERE ch.course_id = ?
            ORDER BY ch.chapter_number ASC
        ");
        $ch_stmt->execute([$user_id, $course_id]);
        $chapters = $ch_stmt->fetchAll();

        $chapters_data = [];
        $total_course_lessons = 0;
        $completed_course_lessons = 0;

        foreach ($chapters as $ch) {
            $chapter_id = $ch['id'];

            // Lessons in chapter
            $l_stmt = $db->prepare("
                SELECT l.id, l.lesson_number, l.title, l.duration_minutes, l.xp_reward,
                       lp.status as lesson_status, lp.completed_at
                FROM lessons l
                LEFT JOIN lesson_progress lp ON l.id = lp.lesson_id AND lp.user_id = ?
                WHERE l.chapter_id = ?
                ORDER BY l.lesson_number ASC
            ");
            $l_stmt->execute([$user_id, $chapter_id]);
            $lessons = $l_stmt->fetchAll();

            $total_ch_l = count($lessons);
            $comp_ch_l = 0;
            foreach ($lessons as $l) {
                if ($l['lesson_status'] === 'completed') {
                    $comp_ch_l++;
                }
            }

            $total_course_lessons += $total_ch_l;
            $completed_course_lessons += $comp_ch_l;

            $chapters_data[] = [
                'id' => $ch['id'],
                'number' => $ch['chapter_number'],
                'title' => $ch['title'],
                'status' => ($ch['chapter_status'] === 'completed' || ($total_ch_l > 0 && $comp_ch_l >= $total_ch_l)) ? 'completed' : ($comp_ch_l > 0 ? 'in_progress' : 'not_started'),
                'total_lessons' => $total_ch_l,
                'completed_lessons' => $comp_ch_l,
                'lessons' => array_map(function($l) {
                    return [
                        'id' => $l['id'],
                        'number' => $l['lesson_number'],
                        'title' => $l['title'],
                        'duration' => $l['duration_minutes'] . ' min',
                        'xp' => (int)$l['xp_reward'],
                        'status' => $l['lesson_status'] ?: 'not_started',
                        'completed_at' => $l['completed_at']
                    ];
                }, $lessons)
            ];
        }

        $pct = $total_course_lessons > 0 ? round(($completed_course_lessons / $total_course_lessons) * 100) : 0;

        $courses_progress[] = [
            'id' => $c['id'],
            'title' => $c['title'],
            'slug' => $c['slug'],
            'image' => $c['image_url'] ?: '/assets/courses/prog.png',
            'accentColor' => $c['accent_color'] ?: '#2563EB',
            'total_lessons' => $total_course_lessons,
            'completed_lessons' => $completed_course_lessons,
            'progress_percent' => $pct,
            'chapters' => $chapters_data
        ];
    }

    // 5. All achievements and student earned status
    $all_ach_stmt = $db->query("SELECT id, title, description, xp_reward, icon_url FROM achievements ORDER BY xp_reward ASC");
    $all_achievements = $all_ach_stmt->fetchAll();

    $earned_ach_stmt = $db->prepare("SELECT achievement_id, earned_at FROM student_achievements WHERE user_id = ?");
    $earned_ach_stmt->execute([$user_id]);
    $earned_map = [];
    while ($row = $earned_ach_stmt->fetch()) {
        $earned_map[$row['achievement_id']] = $row['earned_at'];
    }

    $achievements_data = [];
    foreach ($all_achievements as $a) {
        $is_earned = isset($earned_map[$a['id']]);
        $achievements_data[] = [
            'id' => $a['id'],
            'title' => $a['title'],
            'description' => $a['description'],
            'xp_reward' => (int)$a['xp_reward'],
            'icon_url' => $a['icon_url'],
            'unlocked' => $is_earned,
            'unlocked_at' => $is_earned ? $earned_map[$a['id']] : null
        ];
    }

    success_response([
        'stats' => [
            'total_xp' => $total_xp,
            'level' => $level,
            'current_streak' => (int)$gam['current_streak'],
            'longest_streak' => (int)$gam['longest_streak'],
            'completed_lessons' => $total_completed_lessons,
            'completed_chapters' => $total_completed_chapters
        ],
        'courses' => $courses_progress,
        'achievements' => $achievements_data
    ]);

} catch (Exception $e) {
    error_log('Student Progress Error: ' . $e->getMessage()); error_response('Failed to load progress data. Please try again.', 500);
}
