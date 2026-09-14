<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/student.php';

require_get_method();
$user = require_student();
$user_id = $user['id'];

try {
    $db = get_db_connection();

    // 1. Fetch academic profile
    $stmt = $db->prepare("
        SELECT 
            p.id, p.username, p.full_name, p.role, p.avatar_url, p.created_at,
            cl.name as class_name,
            g.name as grade_name,
            ag.name as academic_group_name
        FROM profiles p
        LEFT JOIN classes cl ON p.class_id = cl.id
        LEFT JOIN grades g ON cl.grade_id = g.id
        LEFT JOIN academic_groups ag ON g.academic_group_id = ag.id
        WHERE p.id = ?
    ");
    $stmt->execute([$user_id]);
    $profile = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$profile) {
        error_response('Profile not found', 404);
    }

    // 2. Gamification stats
    $gam_stmt = $db->prepare("
        SELECT total_xp, current_streak, longest_streak, last_activity_date 
        FROM student_gamification 
        WHERE user_id = ?
    ");
    $gam_stmt->execute([$user_id]);
    $gam = $gam_stmt->fetch(PDO::FETCH_ASSOC) ?: [
        'total_xp' => 0,
        'current_streak' => 0,
        'longest_streak' => 0,
        'last_activity_date' => null
    ];

    $total_xp = (int)$gam['total_xp'];
    $level = (int)floor($total_xp / 100) + 1;

    // 3. Counts
    $lessons_stmt = $db->prepare("
        SELECT COUNT(*) FROM lesson_progress 
        WHERE user_id = ? AND status = 'completed'
    ");
    $lessons_stmt->execute([$user_id]);
    $completed_lessons = (int)$lessons_stmt->fetchColumn();

    $exams_stmt = $db->prepare("
        SELECT COUNT(*) FROM exam_attempts 
        WHERE user_id = ? AND passed = 1
    ");
    $exams_stmt->execute([$user_id]);
    $completed_exams = (int)$exams_stmt->fetchColumn();

    success_response([
        'profile' => [
            'id' => $profile['id'],
            'username' => $profile['username'],
            'full_name' => $profile['full_name'],
            'role' => $profile['role'],
            'avatar_url' => $profile['avatar_url'],
            'academic_group' => $profile['academic_group_name'] ?? 'Not Assigned',
            'grade' => $profile['grade_name'] ?? 'Not Assigned',
            'class' => $profile['class_name'] ?? 'Not Assigned',
            'created_at' => $profile['created_at']
        ],
        'stats' => [
            'total_xp' => $total_xp,
            'level' => $level,
            'current_streak' => (int)$gam['current_streak'],
            'completed_lessons' => $completed_lessons,
            'completed_exams' => $completed_exams
        ]
    ]);

} catch (PDOException $e) {
    error_log('Student Profile DB Error: ' . $e->getMessage());
    error_response('Database error loading profile', 500);
} catch (Exception $e) {
    error_log('Student Profile Server Error: ' . $e->getMessage());
    error_response('Server error loading profile', 500);
}
