<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/admin.php';
require_once __DIR__ . '/../../middleware/csrf.php';

require_post_method();
require_admin();
verify_csrf_token();

$data = get_json_request();
$id = trim($data['id'] ?? '');

if (empty($id)) {
    error_response('Lesson ID is required', 400);
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT id FROM lessons WHERE id = ?");
    $stmt->execute([$id]);
    if (!$stmt->fetch()) {
        error_response('Lesson not found', 404);
    }

    $stmt = $db->prepare("SELECT COUNT(*) FROM lesson_blocks WHERE lesson_id = ?");
    $stmt->execute([$id]);
    $count = $stmt->fetchColumn();
    
    if ($count > 0) {
        error_response("Cannot delete lesson because it has $count dependent blocks. Please delete them first.", 400);
    }
    
    $stmt = $db->prepare("DELETE FROM lessons WHERE id = ?");
    $stmt->execute([$id]);
    
    success_response(['message' => 'Lesson deleted successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
