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

$course_id = trim($data['course_id'] ?? '');
$slug = trim($data['slug'] ?? '');
$chapter_number = isset($data['chapter_number']) ? (int)$data['chapter_number'] : 0;
$title = trim($data['title'] ?? '');
$description = trim($data['description'] ?? '');
$icon_symbol = trim($data['icon_symbol'] ?? '');
$xp_reward = isset($data['xp_reward']) ? (int)$data['xp_reward'] : 0;

if (empty($course_id) || empty($slug) || empty($title) || $chapter_number <= 0) {
    error_response('course_id, slug, title, and valid chapter_number are required', 400);
}

try {
    $db = get_db_connection();
    
    // Check course exists
    $stmt = $db->prepare("SELECT id FROM courses WHERE id = ?");
    $stmt->execute([$course_id]);
    if (!$stmt->fetch()) {
        error_response('Course not found', 400);
    }
    
    // Check unique slug within course
    $stmt = $db->prepare("SELECT id FROM chapters WHERE course_id = ? AND slug = ?");
    $stmt->execute([$course_id, $slug]);
    if ($stmt->fetch()) {
        error_response('Chapter slug already exists in this course', 409);
    }
    
    $id = generate_uuid_v4();
    
    $stmt = $db->prepare("
        INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ");
    $stmt->execute([$id, $course_id, $slug, $chapter_number, $title, $description, $icon_symbol, $xp_reward]);
    
    success_response(['id' => $id], 201);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
