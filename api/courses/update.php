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
    error_response('Course ID is required', 400);
}

$slug = trim($data['slug'] ?? '');
$academic_group_id = trim($data['academic_group_id'] ?? '');
$title = trim($data['title'] ?? '');
$description = trim($data['description'] ?? '');
$image_url = trim($data['image_url'] ?? '');
$accent_color = trim($data['accent_color'] ?? '');
$is_published = isset($data['is_published']) ? (int)(bool)$data['is_published'] : 0;

if (empty($slug) || empty($academic_group_id) || empty($title)) {
    error_response('slug, academic_group_id, and title are required', 400);
}

try {
    $db = get_db_connection();
    
    // Check if course exists
    $stmt = $db->prepare("SELECT id FROM courses WHERE id = ?");
    $stmt->execute([$id]);
    if (!$stmt->fetch()) {
        error_response('Course not found', 404);
    }

    // Check academic group exists
    $stmt = $db->prepare("SELECT id FROM academic_groups WHERE id = ?");
    $stmt->execute([$academic_group_id]);
    if (!$stmt->fetch()) {
        error_response('Invalid academic_group_id', 400);
    }
    
    // Check unique slug for other courses
    $stmt = $db->prepare("SELECT id FROM courses WHERE slug = ? AND id != ?");
    $stmt->execute([$slug, $id]);
    if ($stmt->fetch()) {
        error_response('Course slug already exists', 409);
    }
    
    $stmt = $db->prepare("
        UPDATE courses 
        SET academic_group_id = ?, slug = ?, title = ?, description = ?, image_url = ?, accent_color = ?, is_published = ?
        WHERE id = ?
    ");
    $stmt->execute([$academic_group_id, $slug, $title, $description, $image_url, $accent_color, $is_published, $id]);
    
    success_response(['message' => 'Course updated successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
