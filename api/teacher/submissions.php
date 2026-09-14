<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/teacher.php';

require_get_method();
$user = require_teacher();

try {
    $db = get_db_connection();

    $project_id = $_GET['project_id'] ?? null;
    $status = $_GET['status'] ?? null;

    $query = "
        SELECT DISTINCT
            ps.id as submission_id,
            ps.user_id as student_id,
            ps.project_id,
            ps.status,
            ps.grade,
            ps.feedback,
            ps.content_json,
            ps.created_at as submitted_at,
            ps.updated_at,
            stu.full_name as student_name,
            stu.username as student_username,
            stu.avatar_url as student_avatar,
            c.name as class_name,
            ag.name as academic_group_name,
            p.title as project_title,
            p.xp_reward,
            crs.title as course_title
        FROM project_submissions ps
        JOIN profiles stu ON ps.user_id = stu.id
        JOIN classes c ON stu.class_id = c.id
        JOIN grades g ON c.grade_id = g.id
        JOIN academic_groups ag ON g.academic_group_id = ag.id
        JOIN projects p ON ps.project_id = p.id
        JOIN courses crs ON p.course_id = crs.id
        WHERE (
            ag.id IN (SELECT academic_group_id FROM teacher_academic_groups WHERE teacher_id = ?)
            OR c.id IN (SELECT class_id FROM teacher_classes WHERE teacher_id = ?)
        )
    ";

    $params = [$user['id'], $user['id']];

    if (!empty($project_id)) {
        $query .= " AND ps.project_id = ?";
        $params[] = $project_id;
    }

    if (!empty($status) && $status !== 'all') {
        $query .= " AND ps.status = ?";
        $params[] = $status;
    }

    $query .= " ORDER BY ps.created_at DESC";

    $stmt = $db->prepare($query);
    $stmt->execute($params);
    $submissions = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($submissions as &$sub) {
        if ($sub['content_json']) {
            $sub['content_json'] = json_decode($sub['content_json'], true);
        }
    }

    success_response(['submissions' => $submissions]);

} catch (Exception $e) {
    error_log('Teacher Submissions Error: ' . $e->getMessage()); error_response('Server error. Please try again.', 500);
}
