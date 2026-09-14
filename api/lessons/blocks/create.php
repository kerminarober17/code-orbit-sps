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

$lesson_id = trim($data['lesson_id'] ?? '');
$block_type = trim($data['block_type'] ?? '');
$order_index = isset($data['order_index']) ? (int)$data['order_index'] : 0;
$content_json = $data['content_json'] ?? null;

if (empty($lesson_id) || empty($block_type) || !isset($data['order_index'])) {
    error_response('lesson_id, block_type, and order_index are required', 400);
}

if (!is_valid_block_type($block_type)) {
    error_response('Invalid block_type', 400);
}

if (!is_array($content_json)) {
    $content_json = [];
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT id FROM lessons WHERE id = ?");
    $stmt->execute([$lesson_id]);
    if (!$stmt->fetch()) {
        error_response('Lesson not found', 400);
    }
    
    $id = generate_uuid_v4();
    $content_str = json_encode($content_json);
    
    $stmt = $db->prepare("
        INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json)
        VALUES (?, ?, ?, ?, ?)
    ");
    $stmt->execute([$id, $lesson_id, $block_type, $order_index, $content_str]);
    
    success_response(['id' => $id], 201);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
