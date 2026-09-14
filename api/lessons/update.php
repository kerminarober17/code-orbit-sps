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

$slug = trim($data['slug'] ?? '');
$lesson_number = isset($data['lesson_number']) ? (int)$data['lesson_number'] : 0;
$title = trim($data['title'] ?? '');
$duration_minutes = isset($data['duration_minutes']) ? (int)$data['duration_minutes'] : 0;
$xp_reward = isset($data['xp_reward']) ? (int)$data['xp_reward'] : 0;

if (empty($slug) || empty($title) || $lesson_number <= 0) {
    error_response('slug, title, and valid lesson_number are required', 400);
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT chapter_id FROM lessons WHERE id = ?");
    $stmt->execute([$id]);
    $lesson = $stmt->fetch();
    
    if (!$lesson) {
        error_response('Lesson not found', 404);
    }
    $chapter_id = $lesson['chapter_id'];
    
    $stmt = $db->prepare("SELECT id FROM lessons WHERE chapter_id = ? AND slug = ? AND id != ?");
    $stmt->execute([$chapter_id, $slug, $id]);
    if ($stmt->fetch()) {
        error_response('Lesson slug already exists in this chapter', 409);
    }
    
    $stmt = $db->prepare("
        UPDATE lessons 
        SET slug = ?, lesson_number = ?, title = ?, duration_minutes = ?, xp_reward = ?
        WHERE id = ?
    ");
    $stmt->execute([$slug, $lesson_number, $title, $duration_minutes, $xp_reward, $id]);
    
    success_response(['message' => 'Lesson updated successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
