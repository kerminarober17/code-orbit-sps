<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../middleware/csrf.php';

require_post_method();
$user = require_auth();

if (!in_array($user['role'], ['admin', 'teacher'])) {
    error_response('Forbidden. Teacher or Admin access required.', 403);
}

verify_csrf_token();

$data = get_json_request();
$course_id = trim($data['course_id'] ?? '');
$title = trim($data['title'] ?? '');
$description = trim($data['description'] ?? '');
$instructions = trim($data['instructions'] ?? '');
$xp_reward = isset($data['xp_reward']) ? (int)$data['xp_reward'] : 50;

if (empty($course_id) || empty($title) || empty($instructions)) {
    error_response('course_id, title, and instructions are required', 400);
}

try {
    $db = get_db_connection();

    // Verify course exists
    $stmt = $db->prepare("SELECT id, academic_group_id FROM courses WHERE id = ?");
    $stmt->execute([$course_id]);
    $course = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$course) {
        error_response('Course not found', 404);
    }

    // If teacher, check access to this course/academic group
    if ($user['role'] === 'teacher') {
        $stmt = $db->prepare("
            SELECT COUNT(*) 
            FROM teacher_academic_groups tag
            WHERE tag.teacher_id = ? AND tag.academic_group_id = ?
            UNION
            SELECT COUNT(*) 
            FROM teacher_classes tc
            JOIN classes c ON tc.class_id = c.id
            JOIN grades g ON c.grade_id = g.id
            WHERE tc.teacher_id = ? AND (
                g.academic_group_id = ? OR 
                tc.class_id IN (SELECT class_id FROM course_class_assignments WHERE course_id = ?)
            )
        ");
        $stmt->execute([$user['id'], $course['academic_group_id'], $user['id'], $course['academic_group_id'], $course_id]);
        $hasAccess = (int)$stmt->fetchColumn() > 0;

        if (!$hasAccess) {
            error_response('Forbidden: You can only create projects for courses relevant to your assigned academic levels.', 403);
        }
    }

    $id = generate_uuid_v4();

    $stmt = $db->prepare("
        INSERT INTO projects (id, course_id, title, description, instructions, xp_reward, created_at)
        VALUES (?, ?, ?, ?, ?, ?, NOW())
    ");
    $stmt->execute([$id, $course_id, $title, $description, $instructions, $xp_reward]);

    success_response([
        'id' => $id,
        'message' => 'Project created successfully'
    ], 201);

} catch (Exception $e) {
    error_log('Projects Error: ' . $e->getMessage()); error_response('Server error. Please try again.', 500);
}
