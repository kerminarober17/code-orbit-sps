<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_get_method();

$user = is_logged_in() ? current_user() : null;

try {
    $db = get_db_connection();
    $course_id = $_GET['course_id'] ?? null;

    if ($user && $user['role'] === 'student') {
        // Students see projects for published courses in their group/enrolled
        $params = [$user['id']];
        $whereCourse = '';
        if ($course_id) {
            $whereCourse = 'AND p.course_id = ?';
            $params[] = $course_id;
        }

        $stmt = $db->prepare("
            SELECT 
                p.id, p.course_id, p.title, p.description, p.instructions, p.xp_reward, p.created_at,
                c.title as course_title, c.slug as course_slug,
                ps.id as submission_id, ps.status as submission_status, ps.grade, ps.feedback, ps.created_at as submitted_at,
                ps.content_json
            FROM projects p
            JOIN courses c ON p.course_id = c.id
            LEFT JOIN project_submissions ps ON ps.project_id = p.id AND ps.user_id = ?
            WHERE c.is_published = 1 $whereCourse
            ORDER BY p.created_at DESC
        ");
        $stmt->execute($params);
        $projects = $stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach ($projects as &$proj) {
            if ($proj['content_json']) {
                $proj['content_json'] = json_decode($proj['content_json'], true);
            }
        }

        success_response($projects);

    } else if ($user && $user['role'] === 'teacher') {
        // Teachers see projects for courses assigned to their classes or courses they teach
        $stmt = $db->prepare("
            SELECT 
                p.id, p.course_id, p.title, p.description, p.instructions, p.xp_reward, p.created_at,
                c.title as course_title, c.slug as course_slug,
                (
                    SELECT COUNT(ps.id) 
                    FROM project_submissions ps 
                    JOIN profiles stu ON ps.user_id = stu.id 
                    JOIN teacher_classes tc ON tc.class_id = stu.class_id 
                    WHERE ps.project_id = p.id AND tc.teacher_id = ?
                ) as total_submissions,
                (
                    SELECT COUNT(ps.id) 
                    FROM project_submissions ps 
                    JOIN profiles stu ON ps.user_id = stu.id 
                    JOIN teacher_classes tc ON tc.class_id = stu.class_id 
                    WHERE ps.project_id = p.id AND tc.teacher_id = ? AND ps.status = 'submitted'
                ) as pending_submissions
            FROM projects p
            JOIN courses c ON p.course_id = c.id
            ORDER BY p.created_at DESC
        ");
        $stmt->execute([$user['id'], $user['id']]);
        $projects = $stmt->fetchAll(PDO::FETCH_ASSOC);

        success_response($projects);

    } else {
        // Admin or public
        $stmt = $db->prepare("
            SELECT 
                p.id, p.course_id, p.title, p.description, p.instructions, p.xp_reward, p.created_at,
                c.title as course_title, c.slug as course_slug,
                (SELECT COUNT(*) FROM project_submissions ps WHERE ps.project_id = p.id) as total_submissions
            FROM projects p
            JOIN courses c ON p.course_id = c.id
            ORDER BY p.created_at DESC
        ");
        $stmt->execute();
        $projects = $stmt->fetchAll(PDO::FETCH_ASSOC);

        success_response($projects);
    }

} catch (Exception $e) {
    error_log('Projects Error: ' . $e->getMessage()); error_response('Server error. Please try again.', 500);
}
