<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../includes/curriculum_helpers.php';
require_once __DIR__ . '/../../middleware/student.php';

require_get_method();
$user = require_student();

try {
    $db = get_db_connection();
    $user_id = $user['id'];

    // Auto-enrollment removed to support manual student enrollments

    // 1. Gamification stats
    $gam_stmt = $db->prepare("SELECT total_xp, current_streak, longest_streak, last_activity_date FROM student_gamification WHERE user_id = ?");
    $gam_stmt->execute([$user_id]);
    $gam = $gam_stmt->fetch() ?: [
        'total_xp' => 0,
        'current_streak' => 0,
        'longest_streak' => 0,
        'last_activity_date' => null
    ];

    $total_xp = (int)$gam['total_xp'];
    $current_streak = (int)$gam['current_streak'];
    $level = (int)floor($total_xp / 100) + 1;
    $next_level_xp = $level * 100;
    $level_progress_pct = min(100, round((($total_xp % 100) / 100) * 100));

    // 2. Counts
    $completed_lessons_stmt = $db->prepare("SELECT COUNT(*) FROM lesson_progress WHERE user_id = ? AND status = 'completed'");
    $completed_lessons_stmt->execute([$user_id]);
    $completed_lessons_count = (int)$completed_lessons_stmt->fetchColumn();

    $achievements_count_stmt = $db->prepare("SELECT COUNT(*) FROM student_achievements WHERE user_id = ?");
    $achievements_count_stmt->execute([$user_id]);
    $unlocked_achievements_count = (int)$achievements_count_stmt->fetchColumn();

    // 3. Enrolled Courses with dynamic progress calculations
    $courses_stmt = $db->prepare("
        SELECT c.id, c.slug, c.title, c.description, c.image_url, c.accent_color, ag.name as academic_group_name
        FROM courses c
        LEFT JOIN academic_groups ag ON c.academic_group_id = ag.id
        JOIN course_enrollments ce ON c.id = ce.course_id
        WHERE ce.user_id = ? AND c.is_published = 1
        ORDER BY ce.created_at DESC
    ");
    $courses_stmt->execute([$user_id]);
    $enrolled_courses = $courses_stmt->fetchAll();

    $courses_data = [];
    foreach ($enrolled_courses as $c) {
        $course_id = $c['id'];

        // Total lessons in course
        $tl_stmt = $db->prepare("
            SELECT COUNT(l.id) 
            FROM lessons l
            JOIN chapters ch ON l.chapter_id = ch.id
            WHERE ch.course_id = ?
        ");
        $tl_stmt->execute([$course_id]);
        $total_lessons = (int)$tl_stmt->fetchColumn();

        // Also count exams (1 per chapter that has an exam)
        $te_stmt = $db->prepare("
            SELECT COUNT(e.id)
            FROM exams e
            JOIN chapters ch ON e.chapter_id = ch.id
            WHERE ch.course_id = ?
        ");
        $te_stmt->execute([$course_id]);
        $total_exams = (int)$te_stmt->fetchColumn();
        $total_lessons += $total_exams;

        // Total completed lessons in course
        $cl_stmt = $db->prepare("
            SELECT COUNT(DISTINCT l.id) 
            FROM lessons l
            JOIN chapters ch ON l.chapter_id = ch.id
            JOIN lesson_progress lp ON l.id = lp.lesson_id
            WHERE ch.course_id = ? AND lp.user_id = ? AND lp.status = 'completed'
        ");
        $cl_stmt->execute([$course_id, $user_id]);
        $completed_in_course = (int)$cl_stmt->fetchColumn();

        // Total completed exams in course
        $ce_stmt = $db->prepare("
            SELECT COUNT(DISTINCT e.id)
            FROM exams e
            JOIN chapters ch ON e.chapter_id = ch.id
            JOIN exam_attempts ea ON e.id = ea.exam_id
            WHERE ch.course_id = ? AND ea.user_id = ? AND (ea.passed = 1 OR ea.score >= 60)
        ");
        $ce_stmt->execute([$course_id, $user_id]);
        $completed_exams = (int)$ce_stmt->fetchColumn();
        $completed_in_course += $completed_exams;

        $progress_pct = $total_lessons > 0 ? round(($completed_in_course / $total_lessons) * 100) : 0;

        // Find next/current lesson to resume
        // Either the first uncompleted lesson, or the very first lesson
        $next_lesson_stmt = $db->prepare("
            SELECT l.id, l.title, l.slug, l.lesson_number, ch.chapter_number, ch.title as chapter_title
            FROM lessons l
            JOIN chapters ch ON l.chapter_id = ch.id
            LEFT JOIN lesson_progress lp ON l.id = lp.lesson_id AND lp.user_id = ? AND lp.status = 'completed'
            WHERE ch.course_id = ? AND lp.id IS NULL
            ORDER BY ch.chapter_number ASC, l.lesson_number ASC
            LIMIT 1
        ");
        $next_lesson_stmt->execute([$user_id, $course_id]);
        $next_lesson = $next_lesson_stmt->fetch();

        // If all completed, get the last lesson
        if (!$next_lesson) {
            $last_lesson_stmt = $db->prepare("
                SELECT l.id, l.title, l.slug, l.lesson_number, ch.chapter_number, ch.title as chapter_title
                FROM lessons l
                JOIN chapters ch ON l.chapter_id = ch.id
                WHERE ch.course_id = ?
                ORDER BY ch.chapter_number DESC, l.lesson_number DESC
                LIMIT 1
            ");
            $last_lesson_stmt->execute([$course_id]);
            $next_lesson = $last_lesson_stmt->fetch();
        }

        // Chapters count
        $ch_count_stmt = $db->prepare("SELECT COUNT(*) FROM chapters WHERE course_id = ?");
        $ch_count_stmt->execute([$course_id]);
        $chapters_count = (int)$ch_count_stmt->fetchColumn();

        $is_course_completed = ($progress_pct >= 100);

        $courses_data[] = [
            'id' => $c['id'],
            'slug' => $c['slug'],
            'title' => $c['title'],
            'description' => $c['description'],
            'image' => $c['image_url'] ?: '/assets/courses/prog.png',
            'accentColor' => $c['accent_color'] ?: '#2563EB',
            'academicGroupLabel' => $c['academic_group_name'] ?: 'Computer Science',
            'chaptersCount' => $chapters_count,
            'lessonsCount' => $total_lessons,
            'completedLessonsCount' => $completed_in_course,
            'progress' => $progress_pct,
            'isCompleted' => $is_course_completed,
            'currentLessonId' => $is_course_completed ? null : ($next_lesson ? $next_lesson['id'] : null),
            'currentLessonTitle' => $is_course_completed ? 'Course Completed' : ($next_lesson ? $next_lesson['title'] : 'Start Course'),
            'currentChapter' => $is_course_completed ? 'All Chapters Completed' : ($next_lesson ? "Chapter {$next_lesson['chapter_number']} · Lesson {$next_lesson['lesson_number']}" : 'Not started')
        ];
    }

    // 4. Recent completed lessons
    $recent_stmt = $db->prepare("
        SELECT lp.completed_at, l.id as lesson_id, l.title as lesson_title, ch.title as chapter_title, c.title as course_title, c.id as course_id
        FROM lesson_progress lp
        JOIN lessons l ON lp.lesson_id = l.id
        JOIN chapters ch ON l.chapter_id = ch.id
        JOIN courses c ON ch.course_id = c.id
        WHERE lp.user_id = ? AND lp.status = 'completed'
        ORDER BY lp.completed_at DESC
        LIMIT 5
    ");
    $recent_stmt->execute([$user_id]);
    $recent_activities = $recent_stmt->fetchAll();

    // 5. Recent achievements
    $ach_stmt = $db->prepare("
        SELECT a.id, a.title, a.description, a.xp_reward, a.icon_url, sa.earned_at
        FROM student_achievements sa
        JOIN achievements a ON sa.achievement_id = a.id
        WHERE sa.user_id = ?
        ORDER BY sa.earned_at DESC
        LIMIT 4
    ");
    $ach_stmt->execute([$user_id]);
    $recent_achievements = $ach_stmt->fetchAll();

    // 6. Completed lesson IDs list for frontend synchronization
    $comp_ids_stmt = $db->prepare("SELECT lesson_id FROM lesson_progress WHERE user_id = ? AND status = 'completed'");
    $comp_ids_stmt->execute([$user_id]);
    $completed_lesson_ids = $comp_ids_stmt->fetchAll(PDO::FETCH_COLUMN);

    success_response([
        'stats' => [
            'total_xp' => $total_xp,
            'current_streak' => $current_streak,
            'longest_streak' => (int)$gam['longest_streak'],
            'level' => $level,
            'next_level_xp' => $next_level_xp,
            'level_progress_pct' => $level_progress_pct,
            'completed_lessons' => $completed_lessons_count,
            'unlocked_achievements' => $unlocked_achievements_count
        ],
        'courses' => $courses_data,
        'completed_lesson_ids' => $completed_lesson_ids,
        'recent_activities' => $recent_activities,
        'achievements' => $recent_achievements
    ]);

} catch (Exception $e) {
    error_log('Student Dashboard Error: ' . $e->getMessage()); error_response('Failed to load student dashboard. Please try again.', 500);
}
