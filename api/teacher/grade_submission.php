<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/teacher.php';
require_once __DIR__ . '/../../middleware/csrf.php';

require_post_method();
$user = require_teacher();
verify_csrf_token();

$data = get_json_request();
$submission_id = trim($data['submission_id'] ?? '');
$grade = isset($data['grade']) ? (int)$data['grade'] : null;
$feedback = trim($data['feedback'] ?? '');
$status = trim($data['status'] ?? 'graded');

if (empty($submission_id) || $grade === null || $grade < 0 || $grade > 100) {
    error_response('submission_id and a valid grade (0-100) are required', 400);
}

try {
    $db = get_db_connection();

    // IDOR Check: Ensure this submission belongs to a student in an academic group or class assigned to this teacher
    $stmt = $db->prepare("
        SELECT 
            ps.id, ps.user_id, ps.project_id, ps.grade as prev_grade,
            p.xp_reward, p.title as project_title,
            stu.full_name as student_name
        FROM project_submissions ps
        JOIN profiles stu ON ps.user_id = stu.id
        LEFT JOIN classes c ON stu.class_id = c.id
        LEFT JOIN grades g ON c.grade_id = g.id
        JOIN projects p ON ps.project_id = p.id
        WHERE ps.id = ? AND (
            g.academic_group_id IN (SELECT academic_group_id FROM teacher_academic_groups WHERE teacher_id = ?)
            OR c.id IN (SELECT class_id FROM teacher_classes WHERE teacher_id = ?)
        )
    ");
    $stmt->execute([$submission_id, $user['id'], $user['id']]);
    $submission = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$submission) {
        error_response('Forbidden: You are not authorized to grade this student submission.', 403);
    }

    $db->beginTransaction();

    // Update submission record
    $stmt = $db->prepare("
        UPDATE project_submissions
        SET grade = ?, feedback = ?, status = ?, updated_at = NOW()
        WHERE id = ?
    ");
    $stmt->execute([$grade, $feedback, $status, $submission_id]);

    $awarded_xp = 0;
    // Award XP if grade is passing (>= 70) and not previously awarded
    if ($grade >= 70 && $status === 'graded') {
        $student_id = $submission['user_id'];
        $project_id = $submission['project_id'];
        $xp_amount = (int)($submission['xp_reward'] ?: 50);

        $chk = $db->prepare("SELECT id FROM xp_events WHERE user_id = ? AND source_type = 'project' AND source_id = ?");
        $chk->execute([$student_id, $project_id]);
        if (!$chk->fetch()) {
            $eventId = generate_uuid_v4();
            $xpStmt = $db->prepare("
                INSERT INTO xp_events (id, user_id, amount, source_type, source_id, created_at)
                VALUES (?, ?, ?, 'project', ?, NOW())
            ");
            $xpStmt->execute([$eventId, $student_id, $xp_amount, $project_id]);

            // Update student gamification total
            $gamStmt = $db->prepare("
                INSERT INTO student_gamification (id, user_id, total_xp, current_streak, updated_at)
                VALUES (?, ?, ?, 1, NOW())
                ON DUPLICATE KEY UPDATE total_xp = total_xp + VALUES(total_xp), updated_at = NOW()
            ");
            $gamStmt->execute([generate_uuid_v4(), $student_id, $xp_amount]);
            $awarded_xp = $xp_amount;
        }
    }

    $db->commit();

    success_response([
        'submission_id' => $submission_id,
        'grade' => $grade,
        'feedback' => $feedback,
        'status' => $status,
        'awarded_xp' => $awarded_xp,
        'message' => 'Submission graded successfully'
    ]);

} catch (Exception $e) {
    if ($db->inTransaction()) {
        $db->rollBack();
    }
    error_log('Grade Submission Error: ' . $e->getMessage()); error_response('Server error. Please try again.', 500);
}
