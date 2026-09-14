<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../includes/curriculum_helpers.php';

require_get_method();

$id = $_GET['id'] ?? '';
if (empty($id)) {
    error_response('Chapter ID required', 400);
}

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();

    $stmt = $db->prepare("SELECT course_id FROM chapters WHERE id = ?");
    $stmt->execute([$id]);
    $chapter = $stmt->fetch();
    
    if (!$chapter) {
        error_response('Chapter not found', 404);
    }
    
    $course_id = $chapter['course_id'];

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
        SELECT id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward 
        FROM chapters 
        WHERE id = ?
    ");
    $stmt->execute([$id]);
    $chapter_details = $stmt->fetch();

    success_response($chapter_details);

} catch (Exception $e) {
    error_response('Server error', 500);
}
