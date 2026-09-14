<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_get_method();
$user = require_auth();

try {
    $db = get_db_connection();

    $stmt = $db->query("
        SELECT 
            e.id, e.title, e.description, e.passing_score_percent, e.created_at,
            ch.id as chapter_id, ch.title as chapter_title, ch.chapter_number,
            c.id as course_id, c.title as course_title,
            ag.name as academic_group_name,
            (SELECT COUNT(*) FROM exam_questions eq WHERE eq.exam_id = e.id) as questions_count,
            (SELECT COUNT(*) FROM exam_attempts ea WHERE ea.exam_id = e.id) as attempts_count,
            (SELECT COUNT(*) FROM exam_attempts ea WHERE ea.exam_id = e.id AND ea.passed = 1) as passed_count,
            (SELECT ROUND(AVG(ea.score)) FROM exam_attempts ea WHERE ea.exam_id = e.id) as avg_score
        FROM exams e
        JOIN chapters ch ON e.chapter_id = ch.id
        JOIN courses c ON ch.course_id = c.id
        JOIN academic_groups ag ON c.academic_group_id = ag.id
        ORDER BY c.title ASC, ch.chapter_number ASC, e.title ASC
    ");
    $exams = $stmt->fetchAll(PDO::FETCH_ASSOC);

    success_response(['exams' => $exams]);

} catch (Exception $e) {
    error_log('Exams List Error: ' . $e->getMessage()); error_response('Failed to fetch exams list. Please try again.', 500);
}
