<?php
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../includes/helpers.php';

try {
    $db = get_db_connection();
    echo "Synchronizing SPS Code Orbit production curriculum (MySQL source of truth)...\n";

    // 1. Ensure Standard Academic Groups exist
    $groups = [
        ['name' => 'Preparatory', 'desc' => 'Interactive coding and web adventures for preparatory students'],
        ['name' => 'Primary 3 & 4', 'desc' => 'Visual programming logic'],
        ['name' => 'Primary 5 & 6', 'desc' => 'Creative coding'],
        ['name' => 'Secondary', 'desc' => 'Advanced computer science']
    ];

    $ag_map = [];
    foreach ($groups as $g) {
        $alt_name = str_replace(' & ', '-', $g['name']);
        $stmt = $db->prepare("SELECT id FROM academic_groups WHERE name = ? OR name = ? LIMIT 1");
        $stmt->execute([$g['name'], $alt_name]);
        $row = $stmt->fetch();
        if ($row) {
            $ag_map[$g['name']] = $row['id'];
            $ag_map[$alt_name] = $row['id'];
        } else {
            $id = generate_uuid_v4();
            $ins = $db->prepare("INSERT INTO academic_groups (id, name, description) VALUES (?, ?, ?)");
            $ins->execute([$id, $g['name'], $g['desc']]);
            $ag_map[$g['name']] = $id;
            $ag_map[$alt_name] = $id;
        }
    }

    // 2. Load the clean 2-course curriculum export
    $json_file = __DIR__ . '/../data/curriculum_export.json';
    if (!file_exists($json_file)) {
        throw new Exception("Curriculum export file missing: {$json_file}");
    }

    $curriculum = json_decode(file_get_contents($json_file), true) ?: [];
    $allowed_course_ids = ['course-programming-foundations', 'course-python-foundations', 'course-python-level-2'];

    foreach ($curriculum as $c_def) {
        if (!in_array($c_def['id'], $allowed_course_ids)) {
            continue;
        }

        $ag_name = $c_def['academic_group'] ?? $c_def['academic_group_name'] ?? 'Preparatory';
        $ag_id = $ag_map[$ag_name] ?? array_values($ag_map)[0];

        // Upsert course
        $stmt_course = $db->prepare("
            INSERT INTO courses (id, academic_group_id, title, slug, description, image_url, accent_color, is_published, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, 1, NOW(), NOW())
            ON DUPLICATE KEY UPDATE
                academic_group_id = VALUES(academic_group_id),
                title = VALUES(title),
                slug = VALUES(slug),
                description = VALUES(description),
                image_url = VALUES(image_url),
                accent_color = VALUES(accent_color),
                is_published = 1,
                updated_at = NOW()
        ");
        $stmt_course->execute([
            $c_def['id'],
            $ag_id,
            $c_def['title'],
            $c_def['slug'],
            $c_def['description'],
            $c_def['image_url'] ?? null,
            $c_def['accent_color'] ?? null
        ]);

        echo "Synced course: {$c_def['title']}\n";

        foreach (($c_def['chapters'] ?? []) as $ch_idx => $ch_def) {
            $ch_number = $ch_def['chapter_number'] ?? $ch_def['number'] ?? ($ch_idx + 1);
            $stmt_ch = $db->prepare("
                INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, 100, NOW(), NOW())
                ON DUPLICATE KEY UPDATE
                    course_id = VALUES(course_id),
                    slug = VALUES(slug),
                    chapter_number = VALUES(chapter_number),
                    title = VALUES(title),
                    description = VALUES(description),
                    icon_symbol = VALUES(icon_symbol),
                    updated_at = NOW()
            ");
            $stmt_ch->execute([
                $ch_def['id'],
                $c_def['id'],
                $ch_def['slug'],
                $ch_number,
                $ch_def['title'],
                $ch_def['description'],
                $ch_def['icon_symbol'] ?? '🚀'
            ]);

            foreach (($ch_def['lessons'] ?? []) as $l_idx => $l_def) {
                $l_number = $l_def['lesson_number'] ?? $l_def['number'] ?? ($l_idx + 1);
                $stmt_l = $db->prepare("
                    INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
                    ON DUPLICATE KEY UPDATE
                        chapter_id = VALUES(chapter_id),
                        slug = VALUES(slug),
                        lesson_number = VALUES(lesson_number),
                        title = VALUES(title),
                        duration_minutes = VALUES(duration_minutes),
                        xp_reward = VALUES(xp_reward),
                        updated_at = NOW()
                ");
                $stmt_l->execute([
                    $l_def['id'],
                    $ch_def['id'],
                    $l_def['slug'],
                    $l_number,
                    $l_def['title'],
                    $l_def['duration'] ?? 12,
                    $l_def['xp'] ?? 25
                ]);

                // Sync lesson blocks if present and not already created
                if (!empty($l_def['blocks']) && is_array($l_def['blocks'])) {
                    $chk_blocks = $db->prepare("SELECT COUNT(*) FROM lesson_blocks WHERE lesson_id = ?");
                    $chk_blocks->execute([$l_def['id']]);
                    if ((int)$chk_blocks->fetchColumn() === 0) {
                        $order = 1;
                        $stmt_insert_block = $db->prepare("INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (?, ?, ?, ?, ?)");
                        foreach ($l_def['blocks'] as $b) {
                            $b_id = generate_uuid_v4();
                            $b_type = $b['block_type'] ?? 'text';
                            $b_content = $b['content'] ?? $b['content_json'] ?? $b;
                            $stmt_insert_block->execute([$b_id, $l_def['id'], $b_type, $order++, json_encode($b_content)]);
                        }
                    }
                }
            }
        }
    }

    echo "Curriculum sync completed safely and successfully!\n";

} catch (Exception $e) {
    echo "Error during curriculum synchronization: " . $e->getMessage() . "\n";
    exit(1);
}
