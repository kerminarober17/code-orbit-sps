<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../middleware/csrf.php';

require_post_method();
$user = require_auth();

if ($user['role'] !== 'student') {
    error_response('Forbidden: Only students can submit projects.', 403);
}

verify_csrf_token();

$data = get_json_request();
$project_id = trim($data['project_id'] ?? '');
$code = trim($data['code'] ?? '');
$notes = trim($data['notes'] ?? '');

if (empty($project_id) || empty($code)) {
    error_response('project_id and code are required', 400);
}

try {
    $db = get_db_connection();

    // Check project exists
    $stmt = $db->prepare("SELECT id, course_id, title FROM projects WHERE id = ?");
    $stmt->execute([$project_id]);
    $project = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$project) {
        error_response('Project not found', 404);
    }

    $zipName = trim($data['zip_name'] ?? '');
    $zipData = trim($data['zip_data'] ?? '');

    $contentJson = json_encode([
        'code' => $code,
        'notes' => $notes,
        'zip_name' => $zipName,
        'zip_data' => $zipData,
        'submitted_at' => date('Y-m-d H:i:s')
    ]);

    // Check if submission already exists for this student + project
    $stmt = $db->prepare("SELECT id FROM project_submissions WHERE user_id = ? AND project_id = ?");
    $stmt->execute([$user['id'], $project_id]);
    $existing = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($existing) {
        $stmt = $db->prepare("
            UPDATE project_submissions 
            SET status = 'submitted', content_json = ?, feedback = NULL, updated_at = NOW()
            WHERE id = ?
        ");
        $stmt->execute([$contentJson, $existing['id']]);
        $subId = $existing['id'];
    } else {
        $subId = generate_uuid_v4();
        $stmt = $db->prepare("
            INSERT INTO project_submissions (id, user_id, project_id, status, content_json, created_at, updated_at)
            VALUES (?, ?, ?, 'submitted', ?, NOW(), NOW())
        ");
        $stmt->execute([$subId, $user['id'], $project_id, $contentJson]);
    }

    success_response([
        'submission_id' => $subId,
        'status' => 'submitted',
        'message' => 'Project submitted successfully for teacher review!'
    ]);

} catch (Exception $e) {
    error_log('Projects Error: ' . $e->getMessage()); error_response('Server error. Please try again.', 500);
}
