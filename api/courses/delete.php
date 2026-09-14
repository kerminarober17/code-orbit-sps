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

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("SELECT id FROM courses WHERE id = ?");
    $stmt->execute([$id]);
    if (!$stmt->fetch()) {
        error_response('Course not found', 404);
    }

    // Check dependent chapters
    $stmt = $db->prepare("SELECT COUNT(*) FROM chapters WHERE course_id = ?");
    $stmt->execute([$id]);
    $count = $stmt->fetchColumn();
    
    if ($count > 0) {
        error_response("Cannot delete course because it has $count dependent chapters. Please delete or move them first.", 400);
    }
    
    // Delete enrollments and assignments first if needed, though they cascade.
    // Assuming we want to be safe, we will just delete the course and rely on DB cascade for simple things, 
    // but the user requested: "Do NOT perform dangerous cascading deletion of educational content... Prefer returning a clear error telling the admin that dependent content must be handled first."
    // Educational content = chapters, lessons, blocks, exams. Chapters cover the rest.
    
    $stmt = $db->prepare("DELETE FROM courses WHERE id = ?");
    $stmt->execute([$id]);
    
    success_response(['message' => 'Course deleted successfully']);
} catch (PDOException $e) {
    error_response('Database error', 500);
}
