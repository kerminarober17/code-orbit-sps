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
    error_response('Chapter ID is required', 400);
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT id FROM chapters WHERE id = ?");
    $stmt->execute([$id]);
    if (!$stmt->fetch()) {
        error_response('Chapter not found', 404);
    }

    // Check dependent lessons
    $stmt = $db->prepare("SELECT COUNT(*) FROM lessons WHERE chapter_id = ?");
    $stmt->execute([$id]);
    $count = $stmt->fetchColumn();
    
    if ($count > 0) {
        error_response("Cannot delete chapter because it has $count dependent lessons. Please delete or move them first.", 400);
    }
    
    $stmt = $db->prepare("DELETE FROM chapters WHERE id = ?");
    $stmt->execute([$id]);
    
    success_response(['message' => 'Chapter deleted successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
