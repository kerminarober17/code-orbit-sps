<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../middleware/csrf.php';

require_get_method();

$user = current_user();
$csrf_token = get_csrf_token();

if ($user) {
    try {
        $db = get_db_connection();
        $stmt = $db->prepare("
            SELECT 
                cl.name as class_name,
                g.name as grade_name,
                ag.name as academic_group_name
            FROM profiles p
            LEFT JOIN classes cl ON p.class_id = cl.id
            LEFT JOIN grades g ON cl.grade_id = g.id
            LEFT JOIN academic_groups ag ON g.academic_group_id = ag.id
            WHERE p.id = ?
        ");
        $stmt->execute([$user['id']]);
        $academic = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($academic) {
            $user['class_name'] = $academic['class_name'] ?? null;
            $user['grade_name'] = $academic['grade_name'] ?? null;
            $user['academic_group_name'] = $academic['academic_group_name'] ?? null;
        }
    } catch (Exception $e) {}

    success_response([
        'user' => $user,
        'csrf_token' => $csrf_token
    ]);
} else {
    // Return csrf token even for guest sessions so login/signup forms have a valid token
    success_response([
        'user' => null,
        'csrf_token' => $csrf_token
    ]);
}

