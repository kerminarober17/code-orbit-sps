<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/student.php';

require_get_method();
$user = require_student();

try {
    $db = get_db_connection();
    $user_id = $user['id'];

    $gam_stmt = $db->prepare("SELECT total_xp, current_streak, longest_streak, last_activity_date FROM student_gamification WHERE user_id = ?");
    $gam_stmt->execute([$user_id]);
    $gam = $gam_stmt->fetch() ?: ['total_xp' => 0, 'current_streak' => 0, 'longest_streak' => 0];

    $total_xp = (int)$gam['total_xp'];
    $level = (int)floor($total_xp / 100) + 1;
    $next_level_xp = $level * 100;
    $level_progress_pct = min(100, round((($total_xp % 100) / 100) * 100));

    // Recent XP events
    $xp_stmt = $db->prepare("
        SELECT amount, source_type, source_id, created_at 
        FROM xp_events 
        WHERE user_id = ? 
        ORDER BY created_at DESC 
        LIMIT 10
    ");
    $xp_stmt->execute([$user_id]);
    $events = $xp_stmt->fetchAll();

    success_response([
        'total_xp' => $total_xp,
        'level' => $level,
        'current_streak' => (int)$gam['current_streak'],
        'longest_streak' => (int)$gam['longest_streak'],
        'next_level_xp' => $next_level_xp,
        'level_progress_pct' => $level_progress_pct,
        'recent_events' => $events
    ]);

} catch (Exception $e) {
    error_log('Gamification Status Error: ' . $e->getMessage()); error_response('Failed to fetch gamification status. Please try again.', 500);
}
