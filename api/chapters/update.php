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

$slug = trim($data['slug'] ?? '');
$chapter_number = isset($data['chapter_number']) ? (int)$data['chapter_number'] : 0;
$title = trim($data['title'] ?? '');
$description = trim($data['description'] ?? '');
$icon_symbol = trim($data['icon_symbol'] ?? '');
$xp_reward = isset($data['xp_reward']) ? (int)$data['xp_reward'] : 0;

if (empty($slug) || empty($title) || $chapter_number <= 0) {
    error_response('slug, title, and valid chapter_number are required', 400);
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT course_id FROM chapters WHERE id = ?");
    $stmt->execute([$id]);
    $chapter = $stmt->fetch();
    
    if (!$chapter) {
        error_response('Chapter not found', 404);
    }
    $course_id = $chapter['course_id'];
    
    // Check unique slug within course for other chapters
    $stmt = $db->prepare("SELECT id FROM chapters WHERE course_id = ? AND slug = ? AND id != ?");
    $stmt->execute([$course_id, $slug, $id]);
    if ($stmt->fetch()) {
        error_response('Chapter slug already exists in this course', 409);
    }
    
    $stmt = $db->prepare("
        UPDATE chapters 
        SET slug = ?, chapter_number = ?, title = ?, description = ?, icon_symbol = ?, xp_reward = ?
        WHERE id = ?
    ");
    $stmt->execute([$slug, $chapter_number, $title, $description, $icon_symbol, $xp_reward, $id]);
    
    success_response(['message' => 'Chapter updated successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
