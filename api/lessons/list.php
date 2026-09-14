<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../includes/curriculum_helpers.php';

require_get_method();

$chapter_id = $_GET['chapter_id'] ?? '';
if (empty($chapter_id)) {
    error_response('Chapter ID required', 400);
}

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();
    
    // Get course_id to check access
    $stmt = $db->prepare("SELECT course_id FROM chapters WHERE id = ?");
    $stmt->execute([$chapter_id]);
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

    if ($user && $user['role'] === 'student') {
        $stmt = $db->prepare("
            SELECT l.id, l.chapter_id, l.slug, l.lesson_number, l.title, l.duration_minutes, l.xp_reward,
                   IF(lp.status = 'completed', 1, 0) as is_completed
            FROM lessons l
            LEFT JOIN lesson_progress lp ON lp.lesson_id = l.id AND lp.user_id = ?
            WHERE l.chapter_id = ? 
            ORDER BY l.lesson_number ASC
        ");
        $stmt->execute([$user['id'], $chapter_id]);
        $lessons = $stmt->fetchAll();
    } else {
        $stmt = $db->prepare("
            SELECT id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, 0 as is_completed
            FROM lessons 
            WHERE chapter_id = ? 
            ORDER BY lesson_number ASC
        ");
        $stmt->execute([$chapter_id]);
        $lessons = $stmt->fetchAll();
    }
    
    success_response($lessons);

} catch (Exception $e) {
    error_response('Server error', 500);
}
