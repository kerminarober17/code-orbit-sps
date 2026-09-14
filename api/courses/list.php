<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/curriculum_helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_get_method();

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();
    ensure_curriculum_seeded($db);
    
    // Auto-enrollment removed to support manual student enrollments

    $where = "c.is_published = 1";
    if (($user && in_array($user['role'], ['admin', 'teacher'])) || isset($_GET['all'])) {
        $where = "1=1";
    }

    $query = "
        SELECT c.id, c.slug, c.academic_group_id, c.title, c.description, 
               c.image_url, c.accent_color, c.is_published,
               ag.name as academic_group_name,
               (SELECT COUNT(ch.id) FROM chapters ch WHERE ch.course_id = c.id) as chapters_count,
               (SELECT COUNT(l.id) FROM lessons l JOIN chapters ch ON l.chapter_id = ch.id WHERE ch.course_id = c.id) as lessons_count
        FROM courses c
        LEFT JOIN academic_groups ag ON c.academic_group_id = ag.id
        WHERE $where
        ORDER BY c.created_at DESC
    ";
    
    $stmt = $db->query($query);
    $courses = $stmt->fetchAll();

    // No fallback. If no published courses exist, return an empty list.
    // Do NOT silently fall back to unpublished/all courses.

    $student_tier = $user ? get_student_academic_tier($db, $user) : null;
    
    if ($user && $user['role'] === 'student') {
        $enroll_stmt = $db->prepare("SELECT course_id FROM course_enrollments WHERE user_id = ?");
        $enroll_stmt->execute([$user['id']]);
        $enrolled_ids = $enroll_stmt->fetchAll(PDO::FETCH_COLUMN);
        
        foreach ($courses as &$course) {
            $course['is_enrolled'] = in_array($course['id'], $enrolled_ids);

            // Compute progress percentage for this user
            $tot_stmt = $db->prepare("
                SELECT COUNT(l.id) FROM lessons l 
                JOIN chapters ch ON l.chapter_id = ch.id 
                WHERE ch.course_id = ?
            ");
            $tot_stmt->execute([$course['id']]);
            $tot = (int)$tot_stmt->fetchColumn();

            $comp_stmt = $db->prepare("
                SELECT COUNT(DISTINCT l.id) FROM lessons l 
                JOIN chapters ch ON l.chapter_id = ch.id 
                JOIN lesson_progress lp ON l.id = lp.lesson_id 
                WHERE ch.course_id = ? AND lp.user_id = ? AND lp.status = 'completed'
            ");
            $comp_stmt->execute([$course['id'], $user['id']]);
            $comp = (int)$comp_stmt->fetchColumn();

            $course['total_lessons'] = $tot;
            $course['completed_lessons'] = $comp;
            $course['progress'] = $tot > 0 ? round(($comp / $tot) * 100) : 0;

            // Check if matches student tier
            $is_match = false;
            if ($student_tier && stristr($course['academic_group_name'], $student_tier) !== false) {
                $is_match = true;
            }
            $course['is_tier_match'] = $is_match;
        }
    }
    
    success_response($courses);
} catch (Exception $e) {
    error_log('Courses List Error: ' . $e->getMessage()); error_response('Server error. Please try again.', 500);
}

