<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../middleware/csrf.php';

require_post_method();
$user = require_auth(['admin', 'teacher']);
verify_csrf_token();

$data = get_json_request();
if (empty($data) && !empty($_POST)) {
    $data = $_POST;
}

$chapter_id = trim($data['chapter_id'] ?? '');
$title = trim($data['title'] ?? '');
$description = trim($data['description'] ?? '');
$passing_score_percent = isset($data['passing_score_percent']) ? (int)$data['passing_score_percent'] : 70;
$questions = $data['questions'] ?? [];

if (empty($chapter_id) || empty($title)) {
    error_response('Chapter ID and Exam Title are required', 400);
}

if (!is_array($questions) || count($questions) === 0) {
    error_response('At least one question is required for the exam', 400);
}

try {
    $db = get_db_connection();

    // Verify chapter exists and retrieve course
    $ch_stmt = $db->prepare("SELECT id, course_id, title FROM chapters WHERE id = ?");
    $ch_stmt->execute([$chapter_id]);
    $chapter = $ch_stmt->fetch(PDO::FETCH_ASSOC);
    if (!$chapter) {
        error_response('Chapter not found', 404);
    }

    $db->beginTransaction();

    $exam_id = generate_uuid_v4();

    // 1. Insert Exam record
    $exam_stmt = $db->prepare("
        INSERT INTO exams (id, chapter_id, title, description, passing_score_percent, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, NOW(), NOW())
    ");
    $exam_stmt->execute([
        $exam_id,
        $chapter_id,
        $title,
        $description,
        $passing_score_percent
    ]);

    // 2. Insert Questions, Answer Keys, and Exam Question mappings
    $q_insert_stmt = $db->prepare("
        INSERT INTO questions (id, question_text, question_type, options_json, points, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, NOW(), NOW())
    ");

    $key_insert_stmt = $db->prepare("
        INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation, created_at)
        VALUES (?, ?, ?, ?, NOW())
    ");

    $eq_insert_stmt = $db->prepare("
        INSERT INTO exam_questions (id, exam_id, question_id, order_index, created_at)
        VALUES (?, ?, ?, ?, NOW())
    ");

    $order_index = 1;
    foreach ($questions as $q) {
        $q_text = trim($q['question_text'] ?? '');
        $q_type = trim($q['question_type'] ?? 'multiple_choice');
        $q_options = $q['options'] ?? $q['options_json'] ?? [];
        $correct_answer = $q['correct_answer'] ?? '';
        $explanation = trim($q['explanation'] ?? '');
        $points = isset($q['points']) ? (int)$q['points'] : 1;

        if (empty($q_text)) continue;

        $question_id = generate_uuid_v4();
        $q_insert_stmt->execute([
            $question_id,
            $q_text,
            $q_type,
            json_encode($q_options),
            $points
        ]);

        $key_id = generate_uuid_v4();
        $key_insert_stmt->execute([
            $key_id,
            $question_id,
            json_encode($correct_answer),
            $explanation
        ]);

        $eq_id = generate_uuid_v4();
        $eq_insert_stmt->execute([
            $eq_id,
            $exam_id,
            $question_id,
            $order_index++
        ]);
    }

    $db->commit();

    success_response([
        'message' => 'Exam created successfully with ' . ($order_index - 1) . ' questions',
        'exam_id' => $exam_id,
        'title' => $title
    ], 201);

} catch (Exception $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    error_log('Exam Create Error: ' . $e->getMessage()); error_response('Failed to create exam. Please try again.', 500);
}
