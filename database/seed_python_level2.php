<?php
/**
 * Seed Python Level 2 into MySQL using curriculum_export.json
 * Safe: does not delete other courses or student data.
 */
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/helpers.php';

try {
    $db = get_db_connection();
    echo "Seeding Python Level 2...\n";

    $json_file = __DIR__ . '/../data/curriculum_export.json';
    $curriculum = json_decode(file_get_contents($json_file), true) ?: [];
    $target = null;
    foreach ($curriculum as $c) {
        if (($c['id'] ?? '') === 'course-python-level-2') { $target = $c; break; }
    }
    if (!$target) {
        throw new Exception('course-python-level-2 not found in curriculum_export.json');
    }

    $ag_stmt = $db->query("SELECT id FROM academic_groups WHERE name LIKE '%Prep%' OR name = 'Preparatory' ORDER BY name LIMIT 1");
    $ag_id = $ag_stmt->fetchColumn();
    if (!$ag_id) {
        throw new Exception('No Preparatory academic group found');
    }

    $stmt_course = $db->prepare("
        INSERT INTO courses (id, academic_group_id, title, slug, description, image_url, accent_color, is_published, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, 1, NOW(), NOW())
        ON DUPLICATE KEY UPDATE academic_group_id=VALUES(academic_group_id), title=VALUES(title), slug=VALUES(slug),
            description=VALUES(description), image_url=VALUES(image_url), accent_color=VALUES(accent_color), is_published=1, updated_at=NOW()
    ");
    $stmt_course->execute([
        $target['id'], $ag_id, $target['title'], $target['slug'], $target['description'],
        $target['image_url'] ?? null, $target['accent_color'] ?? '#8B5CF6'
    ]);
    echo "Course upserted: {$target['title']}\n";

    $stmt_ch = $db->prepare("
        INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, 100, NOW(), NOW())
        ON DUPLICATE KEY UPDATE course_id=VALUES(course_id), slug=VALUES(slug), chapter_number=VALUES(chapter_number),
            title=VALUES(title), description=VALUES(description), icon_symbol=VALUES(icon_symbol), updated_at=NOW()
    ");
    $stmt_l = $db->prepare("
        INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ON DUPLICATE KEY UPDATE chapter_id=VALUES(chapter_id), slug=VALUES(slug), lesson_number=VALUES(lesson_number),
            title=VALUES(title), duration_minutes=VALUES(duration_minutes), xp_reward=VALUES(xp_reward), updated_at=NOW()
    ");
    $del_blocks = $db->prepare("DELETE FROM lesson_blocks WHERE lesson_id = ?");
    $ins_block = $db->prepare("INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (?, ?, ?, ?, ?)");

    $lesson_count = 0;
    $block_count = 0;
    foreach ($target['chapters'] as $ch_idx => $ch) {
        $stmt_ch->execute([
            $ch['id'], $target['id'], $ch['slug'] ?? ('chapter-' . ($ch['chapter_number'] ?? $ch_idx+1)),
            $ch['chapter_number'] ?? ($ch_idx+1), $ch['title'], $ch['description'] ?? '', $ch['icon_symbol'] ?? '🚀'
        ]);
        foreach ($ch['lessons'] as $l_idx => $les) {
            $stmt_l->execute([
                $les['id'], $ch['id'], $les['slug'] ?? $les['id'],
                $les['lesson_number'] ?? ($l_idx+1), $les['title'],
                $les['duration'] ?? 12, $les['xp'] ?? 25
            ]);
            $lesson_count++;
            $del_blocks->execute([$les['id']]);
            $order = 1;
            foreach ($les['blocks'] ?? [] as $b) {
                $bid = sprintf('%s-%02d', $les['id'], $order); // may exceed 36 chars - use uuid
                $bid = sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
                    mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff),
                    mt_rand(0, 0x0fff) | 0x4000, mt_rand(0, 0x3fff) | 0x8000,
                    mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff));
                $content = $b['content'] ?? $b;
                $ins_block->execute([$bid, $les['id'], $b['block_type'] ?? 'text', $order++, json_encode($content, JSON_UNESCAPED_UNICODE)]);
                $block_count++;
            }
        }
        echo "  Chapter {$ch['chapter_number']}: {$ch['title']} (" . count($ch['lessons']) . " lessons)\n";
    }

    echo "Done. Lessons={$lesson_count}, blocks={$block_count}\n";
    echo "Run database/seed_python_level2_full.sql for exams/questions if needed.\n";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
    exit(1);
}
