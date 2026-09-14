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

$chapter_id = trim($data['chapter_id'] ?? '');
$slug = trim($data['slug'] ?? '');
$lesson_number = isset($data['lesson_number']) ? (int)$data['lesson_number'] : 0;
$title = trim($data['title'] ?? '');
$duration_minutes = isset($data['duration_minutes']) ? (int)$data['duration_minutes'] : 0;
$xp_reward = isset($data['xp_reward']) ? (int)$data['xp_reward'] : 0;

if (empty($chapter_id) || empty($slug) || empty($title) || $lesson_number <= 0) {
    error_response('chapter_id, slug, title, and valid lesson_number are required', 400);
}

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT id FROM chapters WHERE id = ?");
    $stmt->execute([$chapter_id]);
    if (!$stmt->fetch()) {
        error_response('Chapter not found', 400);
    }
    
    $stmt = $db->prepare("SELECT id FROM lessons WHERE chapter_id = ? AND slug = ?");
    $stmt->execute([$chapter_id, $slug]);
    if ($stmt->fetch()) {
        error_response('Lesson slug already exists in this chapter', 409);
    }
    
    $id = generate_uuid_v4();
    
    $stmt = $db->prepare("
        INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ");
    $stmt->execute([$id, $chapter_id, $slug, $lesson_number, $title, $duration_minutes, $xp_reward]);
    
    success_response(['id' => $id], 201);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
