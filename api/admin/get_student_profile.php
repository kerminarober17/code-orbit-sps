<?php
ini_set('display_errors', 0);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED);
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_get_method();
$user = require_auth(['admin', 'teacher']);

$student_id = trim($_GET['student_id'] ?? $_GET['id'] ?? '');

if (empty($student_id)) {
    json_response([
        'status' => 'error',
        'success' => false,
        'message' => 'student_id parameter is required'
    ], 200);
    exit;
}

try {
    $db = get_db_connection();

    // Check if separate users table exists
    $has_users_table = false;
    try {
        $u_res = $db->query("SHOW TABLES LIKE 'users'")->fetch();
        if ($u_res) $has_users_table = true;
    } catch (\Throwable $e) {}

    $email_select = $has_users_table ? "u.email as email" : "'' as email";
    $user_join = $has_users_table ? "LEFT JOIN users u ON u.id = p.id" : "";

    // 1. Fetch student basic profile - NEVER select p.email from profiles
    $profile_stmt = $db->prepare("
        SELECT 
            p.id, p.id as user_id, p.username, p.full_name, p.role, p.avatar_url, p.created_at,
            {$email_select},
            c.id as class_id, c.name as class_name, c.name as class_group,
            g.id as grade_id, g.name as grade_name,
            ag.id as academic_group_id, ag.name as academic_group_name
        FROM profiles p
        {$user_join}
        LEFT JOIN classes c ON p.class_id = c.id
        LEFT JOIN grades g ON c.grade_id = g.id
        LEFT JOIN academic_groups ag ON g.academic_group_id = ag.id
        WHERE p.id = :student_id AND p.role = 'student'
        LIMIT 1
    ");
    $profile_stmt->execute([':student_id' => $student_id]);
    $student = $profile_stmt->fetch(PDO::FETCH_ASSOC);

    if (!$student) {
        // Try without role check in case profile role is stored differently
        $profile_stmt2 = $db->prepare("
            SELECT 
                p.id, p.id as user_id, p.username, p.full_name, p.role, p.avatar_url, p.created_at,
                {$email_select},
                c.id as class_id, c.name as class_name, c.name as class_group,
                g.id as grade_id, g.name as grade_name,
                ag.id as academic_group_id, ag.name as academic_group_name
            FROM profiles p
            {$user_join}
            LEFT JOIN classes c ON p.class_id = c.id
            LEFT JOIN grades g ON c.grade_id = g.id
            LEFT JOIN academic_groups ag ON g.academic_group_id = ag.id
            WHERE p.id = :student_id
            LIMIT 1
        ");
        $profile_stmt2->execute([':student_id' => $student_id]);
        $student = $profile_stmt2->fetch(PDO::FETCH_ASSOC);
    }

    if (!$student) {
        json_response([
            'status' => 'error',
            'success' => false,
            'message' => 'Student record not found in system'
        ], 200);
        exit;
    }

    // 2. Gamification & Activity Stats
    $gamification = [
        'total_xp' => 0,
        'xp' => 0,
        'current_streak' => 0,
        'streak' => 0,
        'longest_streak' => 0,
        'last_activity_date' => null
    ];
    try {
        $gamification_stmt = $db->prepare("
            SELECT 
                total_xp, total_xp as xp, current_streak, current_streak as streak, longest_streak, last_activity_date
            FROM student_gamification
            WHERE user_id = ?
            LIMIT 1
        ");
        $gamification_stmt->execute([$student_id]);
        $g_row = $gamification_stmt->fetch(PDO::FETCH_ASSOC);
        if ($g_row) {
            $gamification = $g_row;
        }
    } catch (\Throwable $e) {}

    // 3. Course & Lesson Progress
    $courses_progress = [];
    try {
        $courses_stmt = $db->prepare("
            SELECT 
                c.id, c.title, c.slug, c.description, c.image_url, c.accent_color,
                ag.name as academic_group_name,
                COALESCE(cp.progress_percent, 0) as progress_percent,
                COALESCE(cp.status, 'not_started') as status,
                (SELECT COUNT(*) FROM lessons l JOIN chapters ch ON l.chapter_id = ch.id WHERE ch.course_id = c.id) as total_lessons,
                (
                    SELECT COUNT(DISTINCT lp.lesson_id) 
                    FROM lesson_progress lp 
                    JOIN lessons l ON lp.lesson_id = l.id
                    JOIN chapters ch ON l.chapter_id = ch.id
                    WHERE lp.user_id = ? AND ch.course_id = c.id AND lp.status = 'completed'
                ) as completed_lessons
            FROM courses c
            LEFT JOIN academic_groups ag ON c.academic_group_id = ag.id
            LEFT JOIN course_progress cp ON cp.course_id = c.id AND cp.user_id = ?
            WHERE c.academic_group_id = ? OR c.id IN (SELECT course_id FROM course_enrollments WHERE user_id = ?)
            ORDER BY c.title ASC
        ");
        $courses_stmt->execute([$student_id, $student_id, $student['academic_group_id'], $student_id]);
        $courses_progress = $courses_stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (\Throwable $e) {}

    // 4. Completed Lessons List
    $completed_lessons = [];
    try {
        $completed_lessons_stmt = $db->prepare("
            SELECT 
                l.id, l.title, l.slug, l.xp_reward, l.duration_minutes,
                ch.title as chapter_title,
                c.title as course_title,
                lp.completed_at
            FROM lesson_progress lp
            JOIN lessons l ON lp.lesson_id = l.id
            JOIN chapters ch ON l.chapter_id = ch.id
            JOIN courses c ON ch.course_id = c.id
            WHERE lp.user_id = ? AND lp.status = 'completed'
            ORDER BY lp.completed_at DESC
        ");
        $completed_lessons_stmt->execute([$student_id]);
        $completed_lessons = $completed_lessons_stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (\Throwable $e) {}

    // 5. Exam Scores & History
    $exam_history = [];
    try {
        $exams_stmt = $db->prepare("
            SELECT 
                ea.id as attempt_id, ea.score, ea.passed, ea.started_at, ea.completed_at,
                e.id as exam_id, e.title as exam_title, e.passing_score_percent,
                ch.title as chapter_title,
                c.title as course_title,
                (SELECT COUNT(*) FROM exam_questions eq WHERE eq.exam_id = e.id) as total_questions,
                (SELECT COUNT(*) FROM answers a WHERE a.exam_attempt_id = ea.id AND a.is_correct = 1) as correct_answers
            FROM exam_attempts ea
            JOIN exams e ON ea.exam_id = e.id
            LEFT JOIN chapters ch ON e.chapter_id = ch.id
            LEFT JOIN courses c ON ch.course_id = c.id
            WHERE ea.user_id = ?
            ORDER BY ea.started_at DESC
        ");
        $exams_stmt->execute([$student_id]);
        $exam_history = $exams_stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (\Throwable $e) {}

    // 6. Submitted Projects
    $project_submissions = [];
    try {
        $projects_stmt = $db->prepare("
            SELECT 
                ps.id as submission_id, ps.status, ps.grade, ps.feedback, ps.content_json,
                ps.created_at as submitted_at, ps.updated_at,
                p.id as project_id, p.title as project_title, p.description as project_desc,
                p.xp_reward,
                c.title as course_title
            FROM project_submissions ps
            JOIN projects p ON ps.project_id = p.id
            LEFT JOIN courses c ON p.course_id = c.id
            WHERE ps.user_id = ?
            ORDER BY ps.created_at DESC
        ");
        $projects_stmt->execute([$student_id]);
        $project_submissions = $projects_stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach ($project_submissions as &$ps) {
            if (!empty($ps['content_json']) && is_string($ps['content_json'])) {
                $ps['content_data'] = json_decode($ps['content_json'], true);
            } else {
                $ps['content_data'] = $ps['content_json'];
            }
        }
        unset($ps);
    } catch (\Throwable $e) {}

    // 7. Achievements
    $achievements = [];
    try {
        $achievements_stmt = $db->prepare("
            SELECT 
                a.id, a.title, a.description, a.icon_url, a.xp_reward,
                sa.earned_at
            FROM student_achievements sa
            JOIN achievements a ON sa.achievement_id = a.id
            WHERE sa.user_id = ?
            ORDER BY sa.earned_at DESC
        ");
        $achievements_stmt->execute([$student_id]);
        $achievements = $achievements_stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (\Throwable $e) {}

    success_response([
        'profile' => $student,
        'gamification' => $gamification,
        'courses_progress' => $courses_progress,
        'completed_lessons' => $completed_lessons,
        'exam_history' => $exam_history,
        'project_submissions' => $project_submissions,
        'achievements' => $achievements
    ]);

} catch (\Throwable $e) {
    error_log('Admin Get Student Profile Error: ' . $e->getMessage());
    json_response([
        'status' => 'error',
        'success' => false,
        'message' => 'Failed to fetch student profile. Please try again.'
    ], 200);
}
