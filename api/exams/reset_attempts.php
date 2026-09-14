<?php
ini_set('display_errors', 0);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED);
header('Content-Type: application/json; charset=utf-8');

require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

try {
    require_post_method();

    // Require student/teacher/admin authentication
    $user = require_auth(['student', 'teacher', 'admin']);
    $user_id = $user['id'];

    $data = get_json_request();
    $exam_id = trim($data['exam_id'] ?? '');

    if (empty($exam_id)) {
        json_response([
            'status' => 'error',
            'success' => false,
            'message' => 'Exam ID is required'
        ], 200);
        exit;
    }

    $db = get_db_connection();

    // Find actual exam details
    $stmt = $db->prepare("
        SELECT e.id, e.passing_score_percent, e.chapter_id 
        FROM exams e
        WHERE e.id = ? OR e.chapter_id = ?
        LIMIT 1
    ");
    $stmt->execute([$exam_id, $exam_id]);
    $exam = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$exam) {
        $exam = [
            'id' => $exam_id,
            'passing_score_percent' => 60
        ];
    }
    $actual_exam_id = $exam['id'];
    $passing_percent = 60; // Standard passing threshold

    // Get attempt stats to ensure they have actually failed before allowing reset
    $att_check = $db->prepare("SELECT id, score, passed FROM exam_attempts WHERE user_id = ? AND exam_id = ?");
    $att_check->execute([$user_id, $actual_exam_id]);
    $attempts = $att_check->fetchAll(PDO::FETCH_ASSOC);

    $attempts_count = count($attempts);
    $has_passed = false;
    foreach ($attempts as $att) {
        if ((bool)$att['passed'] || (int)$att['score'] >= $passing_percent) {
            $has_passed = true;
        }
    }

    // Enforce eligibility rules: must have at least 1 attempt, used up to 3 attempts, and NOT passed
    if ($attempts_count === 0) {
        json_response([
            'status' => 'error',
            'success' => false,
            'message' => 'No attempts registered yet. Reset is only available after failing attempts.'
        ], 200);
        exit;
    }

    if ($has_passed) {
        json_response([
            'status' => 'error',
            'success' => false,
            'message' => 'You have already passed this assessment. Reset is not allowed.'
        ], 200);
        exit;
    }

    // Ensure archive table exists
    $db->exec("
        CREATE TABLE IF NOT EXISTS exam_attempts_archive (
            id CHAR(36) PRIMARY KEY,
            user_id CHAR(36) NOT NULL,
            exam_id CHAR(36) NOT NULL,
            score INT,
            passed TINYINT(1),
            started_at DATETIME,
            completed_at DATETIME,
            archived_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ");

    // Reset attempts by archiving then deleting them
    $db->beginTransaction();
    
    $arch = $db->prepare("
        INSERT INTO exam_attempts_archive (id, user_id, exam_id, score, passed, started_at, completed_at)
        SELECT id, user_id, exam_id, score, passed, started_at, completed_at 
        FROM exam_attempts 
        WHERE user_id = ? AND exam_id = ?
    ");
    $arch->execute([$user_id, $actual_exam_id]);

    $del = $db->prepare("DELETE FROM exam_attempts WHERE user_id = ? AND exam_id = ?");
    $del->execute([$user_id, $actual_exam_id]);
    $db->commit();

    success_response([
        'message' => 'Your attempt cycle has been reset successfully. You now have 3 new official attempts!',
        'exam_id' => $actual_exam_id,
        'attempts_left' => 3
    ]);

} catch (\Throwable $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    error_log('Reset Attempts Error: ' . $e->getMessage());
    json_response([
        'status' => 'error',
        'success' => false,
        'message' => 'Error resetting attempts. Please try again.'
    ], 200);
}
