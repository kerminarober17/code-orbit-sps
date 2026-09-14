<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/teacher.php';
require_get_method();

$user = require_teacher();

try {
    $db = get_db_connection();
    
    // Union of all assignment scopes: academic groups, classes, AND explicit student IDs
    $stmt = $db->prepare("
        SELECT DISTINCT
            p.id, p.username, p.full_name, p.avatar_url, p.created_at,
            c.name as class_name,
            ag.id as academic_group_id, ag.name as academic_group_name,
            COALESCE(sg.total_xp, 0) as total_xp,
            COALESCE(sg.current_streak, 0) as current_streak,
            sg.last_activity_date,
            (
                SELECT ROUND(AVG(cp.progress_percent))
                FROM course_progress cp
                WHERE cp.user_id = p.id
            ) as progress_percent
        FROM profiles p
        LEFT JOIN classes c ON p.class_id = c.id
        LEFT JOIN grades g ON c.grade_id = g.id
        LEFT JOIN academic_groups ag ON g.academic_group_id = ag.id
        LEFT JOIN student_gamification sg ON sg.user_id = p.id
        WHERE p.role = 'student' AND (
            (ag.id IS NOT NULL AND ag.id IN (SELECT academic_group_id FROM teacher_academic_groups WHERE teacher_id = ?))
            OR (c.id IS NOT NULL AND c.id IN (SELECT class_id FROM teacher_classes WHERE teacher_id = ?))
            OR p.id IN (SELECT student_id FROM teacher_student_assignments WHERE teacher_id = ?)
        )
        ORDER BY ag.name, c.name, p.full_name
    ");
    
    $stmt->execute([$user['id'], $user['id'], $user['id']]);
    $students = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Also fetch teacher's assigned academic levels
    $levels_stmt = $db->prepare("
        SELECT ag.id, ag.name 
        FROM teacher_academic_groups tag
        JOIN academic_groups ag ON tag.academic_group_id = ag.id
        WHERE tag.teacher_id = ?
        ORDER BY ag.name ASC
    ");
    $levels_stmt->execute([$user['id']]);
    $assigned_levels = $levels_stmt->fetchAll(PDO::FETCH_ASSOC);

    success_response([
        'students' => $students,
        'assigned_levels' => $assigned_levels
    ]);
} catch (Exception $e) {
    error_response('Server error', 500);
}
