<?php
/**
 * Safe admin-only DB health check.
 * Shows which database the application is actually connected to.
 * NEVER exposes passwords, hashes, or secrets.
 */
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/admin.php';

require_get_method();
require_admin();

try {
    $db = get_db_connection();

    $current_db = $db->query('SELECT DATABASE() AS d')->fetchColumn();
    $version = $db->query('SELECT VERSION() AS v')->fetchColumn();

    $counts = [
        'profiles' => (int)$db->query("SELECT COUNT(*) FROM profiles")->fetchColumn(),
        'students' => (int)$db->query("SELECT COUNT(*) FROM profiles WHERE role = 'student'")->fetchColumn(),
        'teachers' => (int)$db->query("SELECT COUNT(*) FROM profiles WHERE role = 'teacher'")->fetchColumn(),
        'admins' => (int)$db->query("SELECT COUNT(*) FROM profiles WHERE role = 'admin'")->fetchColumn(),
        'courses' => (int)$db->query("SELECT COUNT(*) FROM courses")->fetchColumn(),
        'chapters' => (int)$db->query("SELECT COUNT(*) FROM chapters")->fetchColumn(),
        'lessons' => (int)$db->query("SELECT COUNT(*) FROM lessons")->fetchColumn(),
        'exams' => (int)$db->query("SELECT COUNT(*) FROM exams")->fetchColumn(),
        'questions' => (int)$db->query("SELECT COUNT(*) FROM questions")->fetchColumn(),
        'exam_questions' => (int)$db->query("SELECT COUNT(*) FROM exam_questions")->fetchColumn(),
        'enrollments' => (int)$db->query("SELECT COUNT(*) FROM course_enrollments")->fetchColumn(),
        'lesson_progress' => (int)$db->query("SELECT COUNT(*) FROM lesson_progress")->fetchColumn(),
        'exam_attempts' => (int)$db->query("SELECT COUNT(*) FROM exam_attempts")->fetchColumn(),
    ];

    // is_active column present?
    $has_is_active = (int)$db->query("
        SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'profiles' AND COLUMN_NAME = 'is_active'
    ")->fetchColumn() === 1;

    $has_tsa = (int)$db->query("
        SELECT COUNT(*) FROM information_schema.TABLES
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'teacher_student_assignments'
    ")->fetchColumn() === 1;

    success_response([
        'configured' => [
            'DB_HOST' => DB_HOST,
            'DB_PORT' => DB_PORT,
            'DB_NAME' => DB_NAME,
            'DB_USER' => DB_USER,
            // password intentionally omitted
            'DB_CHARSET' => DB_CHARSET,
            'APP_ENV' => APP_ENV,
        ],
        'live' => [
            'SELECT_DATABASE' => $current_db,
            'server_version' => $version,
            'profiles_is_active_column' => $has_is_active,
            'teacher_student_assignments_table' => $has_tsa,
        ],
        'counts' => $counts,
        'authority' => 'Single PDO connection via config/database.php → get_db_connection()',
    ]);
} catch (Exception $e) {
    error_log('DB Health Error: ' . $e->getMessage());
    error_response('Database health check failed. Check server logs and .env configuration.', 500);
}
