<?php
require_once __DIR__ . '/../../../config/database.php';
require_once __DIR__ . '/../../../includes/helpers.php';
require_once __DIR__ . '/../../../includes/response.php';
require_once __DIR__ . '/../../../middleware/admin.php';
require_once __DIR__ . '/../../../middleware/csrf.php';
require_once __DIR__ . '/../../../includes/curriculum_helpers.php';

require_post_method();
require_admin();
verify_csrf_token();

$data = get_json_request();
$id = trim($data['id'] ?? '');

if (empty($id)) {
    error_response('Block ID is required', 400);
}

$block_type = trim($data['block_type'] ?? '');
$order_index = isset($data['order_index']) ? (int)$data['order_index'] : null;
$content_json = $data['content_json'] ?? null;

if (empty($block_type) || $order_index === null) {
    error_response('block_type and order_index are required', 400);
}

if (!is_valid_block_type($block_type)) {
    error_response('Invalid block_type', 400);
}

if (!is_array($content_json)) {
    $content_json = [];
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT id FROM lesson_blocks WHERE id = ?");
    $stmt->execute([$id]);
    if (!$stmt->fetch()) {
        error_response('Block not found', 404);
    }
    
    $content_str = json_encode($content_json);
    
    $stmt = $db->prepare("
        UPDATE lesson_blocks 
        SET block_type = ?, order_index = ?, content_json = ?
        WHERE id = ?
    ");
    $stmt->execute([$block_type, $order_index, $content_str, $id]);
    
    success_response(['message' => 'Block updated successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
