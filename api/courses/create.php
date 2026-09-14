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
    
    // Check academic group exists
    $stmt = $db->prepare("SELECT id FROM academic_groups WHERE id = ?");
    $stmt->execute([$academic_group_id]);
    if (!$stmt->fetch()) {
        error_response('Invalid academic_group_id', 400);
    }
    
    // Check unique slug
    $stmt = $db->prepare("SELECT id FROM courses WHERE slug = ?");
    $stmt->execute([$slug]);
    if ($stmt->fetch()) {
        error_response('Course slug already exists', 409);
    }
    
    $id = generate_uuid_v4();
    
    $stmt = $db->prepare("
        INSERT INTO courses (id, academic_group_id, slug, title, description, image_url, accent_color, is_published)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ");
    $stmt->execute([$id, $academic_group_id, $slug, $title, $description, $image_url, $accent_color, $is_published]);
    
    success_response(['id' => $id], 201);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
