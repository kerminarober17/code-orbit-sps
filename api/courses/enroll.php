<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/student.php';
require_once __DIR__ . '/../../middleware/csrf.php';
require_once __DIR__ . '/../../includes/curriculum_helpers.php';

require_post_method();
$user = require_student();
verify_csrf_token();

$data = get_json_request();
$course_id = trim($data['course_id'] ?? '');

if (empty($course_id)) {
    error_response('Course ID is required', 400);
}

try {
    $db = get_db_connection();
    ensure_curriculum_seeded($db);
    
    // Resolve course by id or slug
    $stmt_c = $db->prepare("SELECT id, title, is_published, academic_group_id FROM courses WHERE id = ? OR slug = ? LIMIT 1");
    $stmt_c->execute([$course_id, $course_id]);
    $course_row = $stmt_c->fetch();
    
    $actual_course_id = $course_row ? $course_row['id'] : $course_id;

    // Verify course exists, is published, and student is allowed to access it
    if (!can_student_access_course($db, $actual_course_id, $user)) {
        error_response('Forbidden. Course not accessible or does not exist.', 403);
    }

    // Check existing enrollment
    $stmt = $db->prepare("SELECT id FROM course_enrollments WHERE course_id = ? AND user_id = ?");
    $stmt->execute([$actual_course_id, $user['id']]);
    $existing = $stmt->fetch();
    if ($existing) {
        success_response([
            'id' => $existing['id'],
            'course_id' => $actual_course_id,
            'message' => 'Already enrolled in this course',
            'already_enrolled' => true
        ], 200);
    }
    
    $id = generate_uuid_v4();
    $stmt = $db->prepare("INSERT INTO course_enrollments (id, course_id, user_id) VALUES (?, ?, ?)");
    $stmt->execute([$id, $actual_course_id, $user['id']]);

    // Ensure initial course_progress record exists
    $check_cp = $db->prepare("SELECT id FROM course_progress WHERE user_id = ? AND course_id = ?");
    $check_cp->execute([$user['id'], $actual_course_id]);
    if (!$check_cp->fetch()) {
        $db->prepare("INSERT INTO course_progress (id, user_id, course_id, status, started_at) VALUES (?, ?, ?, 'in_progress', NOW())")
           ->execute([generate_uuid_v4(), $user['id'], $actual_course_id]);
    }
    
    success_response([
        'id' => $id,
        'course_id' => $actual_course_id,
        'message' => 'Successfully enrolled',
        'already_enrolled' => false
    ], 200);
} catch (PDOException $e) {
    error_log('Enroll Error: ' . $e->getMessage()); error_response('Database error. Please try again.', 500);
}

