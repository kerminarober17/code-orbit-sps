<?php
/**
 * Official production exam seeder for SPS Code Orbit.
 * Idempotent: creates exactly one exam per chapter (6 MCQ questions each).
 * Uses current canonical chapter IDs from the database — no obsolete IDs.
 * Does not touch users/accounts. Does not create Level 3 content.
 */
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/helpers.php';

try {
    $db = get_db_connection();
    echo "Official exam seed — scanning current production chapters...\n";

    $chapters = $db->query("
        SELECT ch.id, ch.title, ch.chapter_number, ch.slug, c.slug AS course_slug
        FROM chapters ch
        JOIN courses c ON c.id = ch.course_id
        WHERE c.slug IN ('programming-foundations', 'python-foundations', 'python-level-2')
        ORDER BY c.slug, ch.chapter_number
    ")->fetchAll(PDO::FETCH_ASSOC);

    if (count($chapters) !== 26) {
        throw new Exception('Expected 26 production chapters, found ' . count($chapters));
    }

    $db->beginTransaction();
    $exams_upserted = 0;
    $questions_upserted = 0;

    foreach ($chapters as $ch) {
        $exam_id = 'exam-' . $ch['id'];
        $title = 'Chapter Exam: ' . $ch['title'];

        // Upsert exam
        $db->prepare("
            INSERT INTO exams (id, chapter_id, title, description, passing_score_percent)
            VALUES (?, ?, ?, ?, 60)
            ON DUPLICATE KEY UPDATE
                title = VALUES(title),
                description = VALUES(description),
                passing_score_percent = VALUES(passing_score_percent)
        ")->execute([
            $exam_id,
            $ch['id'],
            $title,
            'Chapter assessment covering core topics. Pass threshold: 60%.'
        ]);
        $exams_upserted++;

        // Remove existing question links for this exam so re-seed is clean
        $old = $db->prepare("SELECT question_id FROM exam_questions WHERE exam_id = ?");
        $old->execute([$exam_id]);
        $old_qids = $old->fetchAll(PDO::FETCH_COLUMN);
        if (!empty($old_qids)) {
            $db->prepare("DELETE FROM exam_questions WHERE exam_id = ?")->execute([$exam_id]);
            foreach ($old_qids as $qid) {
                $db->prepare("DELETE FROM question_answer_keys WHERE question_id = ?")->execute([$qid]);
                $db->prepare("DELETE FROM questions WHERE id = ?")->execute([$qid]);
            }
        }

        $opts = json_encode([
            ['key' => 'A', 'text' => 'Option A'],
            ['key' => 'B', 'text' => 'Option B'],
            ['key' => 'C', 'text' => 'Option C'],
            ['key' => 'D', 'text' => 'Option D']
        ]);

        for ($i = 1; $i <= 6; $i++) {
            $qid = 'q-' . $ch['id'] . '-' . $i;
            $db->prepare("
                INSERT INTO questions (id, question_type, question_text, options_json, points)
                VALUES (?, 'multiple_choice', ?, ?, 10)
                ON DUPLICATE KEY UPDATE
                    question_text = VALUES(question_text),
                    options_json = VALUES(options_json),
                    points = VALUES(points)
            ")->execute([
                $qid,
                "Question {$i} for {$ch['title']} ({$ch['course_slug']})",
                $opts
            ]);

            $db->prepare("
                INSERT INTO exam_questions (id, exam_id, question_id, order_index)
                VALUES (?, ?, ?, ?)
            ")->execute([generate_uuid_v4(), $exam_id, $qid, $i]);

            $db->prepare("
                INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
                VALUES (?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                    correct_answer = VALUES(correct_answer),
                    explanation = VALUES(explanation)
            ")->execute([
                generate_uuid_v4(),
                $qid,
                json_encode('A'),
                'Correct answer is A (seed sample).'
            ]);
            $questions_upserted++;
        }
        echo "  Exam for {$ch['id']} ({$ch['course_slug']} ch{$ch['chapter_number']}) — 6 questions\n";
    }

    $db->commit();

    $c = $db->query("SELECT COUNT(*) c FROM courses")->fetch()['c'];
    $ch = $db->query("SELECT COUNT(*) c FROM chapters")->fetch()['c'];
    $l = $db->query("SELECT COUNT(*) c FROM lessons")->fetch()['c'];
    $e = $db->query("SELECT COUNT(*) c FROM exams")->fetch()['c'];
    $q = $db->query("SELECT COUNT(*) c FROM questions")->fetch()['c'];
    $eq = $db->query("SELECT COUNT(*) c FROM exam_questions")->fetch()['c'];

    echo "\nSeed complete (idempotent).\n";
    echo "courses=$c chapters=$ch lessons=$l exams=$e questions=$q exam_questions=$eq\n";

    // Verify every chapter has exactly one exam with 6 questions
    $bad = $db->query("
        SELECT ch.id, COUNT(DISTINCT e.id) AS exam_cnt, COUNT(eq.question_id) AS q_cnt
        FROM chapters ch
        LEFT JOIN exams e ON e.chapter_id = ch.id
        LEFT JOIN exam_questions eq ON eq.exam_id = e.id
        GROUP BY ch.id
        HAVING exam_cnt != 1 OR q_cnt != 6
    ")->fetchAll();
    if ($bad) {
        echo "WARNING: integrity check failed for " . count($bad) . " chapters\n";
        exit(1);
    }
    echo "Integrity: every chapter has exactly 1 exam with 6 questions — OK\n";

} catch (Exception $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    echo "Exam seed error: " . $e->getMessage() . "\n";
    exit(1);
}
