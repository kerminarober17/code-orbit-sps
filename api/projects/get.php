<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_get_method();

$id = $_GET['id'] ?? '';
if (empty($id)) {
    error_response('Project ID required', 400);
}

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();

    $stmt = $db->prepare("
        SELECT 
            p.id, p.course_id, p.title, p.description, p.instructions, p.xp_reward, p.created_at,
            c.title as course_title, c.slug as course_slug
        FROM projects p
        JOIN courses c ON p.course_id = c.id
        WHERE p.id = ?
    ");
    $stmt->execute([$id]);
    $project = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$project) {
        error_response('Project not found', 404);
    }

    if ($user && $user['role'] === 'student') {
        $stmt = $db->prepare("
            SELECT id as submission_id, status, content_json, feedback, grade, created_at as submitted_at, updated_at
            FROM project_submissions
            WHERE project_id = ? AND user_id = ?
        ");
        $stmt->execute([$id, $user['id']]);
        $sub = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($sub && $sub['content_json']) {
            $sub['content_json'] = json_decode($sub['content_json'], true);
        }
        $project['submission'] = $sub ?: null;
    }

    success_response($project);

} catch (Exception $e) {
    error_response('Server error', 500);
}
