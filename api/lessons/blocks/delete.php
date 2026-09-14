<?php
require_once __DIR__ . '/../../../config/database.php';
require_once __DIR__ . '/../../../includes/helpers.php';
require_once __DIR__ . '/../../../includes/response.php';
require_once __DIR__ . '/../../../middleware/admin.php';
require_once __DIR__ . '/../../../middleware/csrf.php';

require_post_method();
require_admin();
verify_csrf_token();

$data = get_json_request();
$id = trim($data['id'] ?? '');

if (empty($id)) {
    error_response('Block ID is required', 400);
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT id FROM lesson_blocks WHERE id = ?");
    $stmt->execute([$id]);
    if (!$stmt->fetch()) {
        error_response('Block not found', 404);
    }
    
    $stmt = $db->prepare("DELETE FROM lesson_blocks WHERE id = ?");
    $stmt->execute([$id]);
    
    success_response(['message' => 'Block deleted successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
