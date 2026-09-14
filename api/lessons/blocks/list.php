<?php
require_once __DIR__ . '/../../../config/database.php';
require_once __DIR__ . '/../../../includes/helpers.php';
require_once __DIR__ . '/../../../includes/response.php';
require_once __DIR__ . '/../../../middleware/auth.php';
require_once __DIR__ . '/../../../includes/curriculum_helpers.php';

require_get_method();

$lesson_id = $_GET['lesson_id'] ?? '';
if (empty($lesson_id)) {
    error_response('Lesson ID required', 400);
}

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();
    
    $stmt = $db->prepare("
        SELECT l.id, c.course_id
        FROM lessons l
        JOIN chapters c ON l.chapter_id = c.id
        WHERE l.id = ?
    ");
    $stmt->execute([$lesson_id]);
    $lesson = $stmt->fetch();
    
    if (!$lesson) {
        error_response('Lesson not found', 404);
    }
    
    $course_id = $lesson['course_id'];

    if ($user && $user['role'] === 'student') {
        if (!can_student_access_course($db, $course_id, $user)) {
            error_response('Forbidden', 403);
        }
    } else if (!$user) {
        $stmt = $db->prepare("SELECT is_published FROM courses WHERE id = ?");
        $stmt->execute([$course_id]);
        $c = $stmt->fetch();
        if (!$c || !$c['is_published']) {
            error_response('Forbidden', 403);
        }
    }

    $stmt = $db->prepare("
        SELECT id, lesson_id, block_type, order_index, content_json 
        FROM lesson_blocks 
        WHERE lesson_id = ? 
        ORDER BY order_index ASC
    ");
    $stmt->execute([$lesson_id]);
    $blocks_raw = $stmt->fetchAll();
    
    $blocks = [];
    foreach ($blocks_raw as $b) {
        $b['content_json'] = json_decode($b['content_json'], true);
        $blocks[] = $b;
    }

    success_response($blocks);

} catch (Exception $e) {
    error_response('Server error', 500);
}
