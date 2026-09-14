<?php
ini_set('display_errors', 0);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED);
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_get_method();
$user = require_auth(['admin']);

try {
    $db = get_db_connection();

    $academic_group_id = trim($_GET['academic_group_id'] ?? '');
    $class_id = trim($_GET['class_id'] ?? '');
    $grade_id = trim($_GET['grade_id'] ?? '');
    $search = trim($_GET['search'] ?? '');

    // Check if separate users table exists
    $has_users_table = false;
    try {
        $u_check = $db->query("SHOW TABLES LIKE 'users'")->fetch();
        if ($u_check) $has_users_table = true;
    } catch (\Throwable $e) {}

    // Safely query profiles table columns
    $profile_cols = [];
    try {
        $cols_res = $db->query("SHOW COLUMNS FROM profiles")->fetchAll(PDO::FETCH_COLUMN);
        $profile_cols = is_array($cols_res) ? $cols_res : [];
    } catch (\Throwable $e) {}

    // Never select p.email from profiles; use u.email if users table exists, otherwise blank string
    $email_select = $has_users_table ? "u.email as email" : "'' as email";
    $user_join = $has_users_table ? "LEFT JOIN users u ON u.id = p.id" : "";

    $username_select = in_array('username', $profile_cols) ? 'p.username' : "'' as username";
    $avatar_select = in_array('avatar_url', $profile_cols) ? 'p.avatar_url' : "'' as avatar_url";
    $xp_select = in_array('xp', $profile_cols) ? 'COALESCE(sg.total_xp, p.xp, 0) as total_xp' : 'COALESCE(sg.total_xp, 0) as total_xp';

    $query = "
        SELECT 
            p.id, {$username_select}, p.full_name, {$email_select}, {$avatar_select}, p.created_at,
            c.id as class_id, c.name as class_name,
            g.id as grade_id, g.name as grade_name,
            ag.id as academic_group_id, ag.name as academic_group_name,
            {$xp_select},
            COALESCE(sg.current_streak, 0) as current_streak,
            COALESCE(sg.longest_streak, 0) as longest_streak,
            sg.last_activity_date,
            (SELECT COUNT(*) FROM lesson_progress lp WHERE lp.user_id = p.id AND lp.status = 'completed') as completed_lessons_count,
            (SELECT COUNT(*) FROM exam_attempts ea WHERE ea.user_id = p.id) as exam_attempts_count,
            (SELECT COUNT(*) FROM project_submissions ps WHERE ps.user_id = p.id) as project_submissions_count
        FROM profiles p
        {$user_join}
        LEFT JOIN classes c ON p.class_id = c.id
        LEFT JOIN grades g ON c.grade_id = g.id
        LEFT JOIN academic_groups ag ON g.academic_group_id = ag.id
        LEFT JOIN student_gamification sg ON sg.user_id = p.id
        WHERE p.role = 'student'
    ";

    $params = [];

    if (!empty($search)) {
        $username_search = in_array('username', $profile_cols) ? "OR p.username LIKE ?" : "";
        $email_search = $has_users_table ? "OR u.email LIKE ?" : "";
        $query .= " AND (p.full_name LIKE ? {$username_search} {$email_search})";
        $searchTerm = "%$search%";
        $params[] = $searchTerm;
        if (!empty($username_search)) $params[] = $searchTerm;
        if (!empty($email_search)) $params[] = $searchTerm;
    }

    if (!empty($academic_group_id)) {
        $query .= " AND ag.id = ?";
        $params[] = $academic_group_id;
    }

    if (!empty($grade_id)) {
        $query .= " AND g.id = ?";
        $params[] = $grade_id;
    }

    if (!empty($class_id)) {
        $query .= " AND c.id = ?";
        $params[] = $class_id;
    }

    $query .= " ORDER BY p.full_name ASC";

    $stmt = $db->prepare($query);
    $stmt->execute($params);
    $students = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Fetch Academic Groups
    $groups_stmt = $db->query("SELECT id, name FROM academic_groups ORDER BY name ASC");
    $academic_groups = $groups_stmt ? $groups_stmt->fetchAll(PDO::FETCH_ASSOC) : [];

    // Fetch Classes
    $classes_stmt = $db->query("SELECT id, name, grade_id FROM classes ORDER BY name ASC");
    $classes = $classes_stmt ? $classes_stmt->fetchAll(PDO::FETCH_ASSOC) : [];

    // Fetch Grades
    $grades_stmt = $db->query("SELECT id, name, academic_group_id FROM grades ORDER BY name ASC");
    $grades = $grades_stmt ? $grades_stmt->fetchAll(PDO::FETCH_ASSOC) : [];

    success_response([
        'students' => $students,
        'academic_groups' => $academic_groups,
        'grades' => $grades,
        'classes' => $classes,
        'filters' => [
            'academic_group_id' => $academic_group_id,
            'grade_id' => $grade_id,
            'class_id' => $class_id,
            'search' => $search
        ]
    ]);

} catch (\Throwable $e) {
    error_log('Admin Students API Error: ' . $e->getMessage());
    json_response([
        'status' => 'error',
        'success' => false,
        'message' => 'Failed to fetch students. Please try again.',
        'error' => 'server_error'
    ], 200);
}
