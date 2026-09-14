<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_get_method();

try {
    $db = get_db_connection();
    
    // Fetch full academic structure (Groups -> Grades -> Classes)
    $stmt = $db->query("
        SELECT 
            ag.id as group_id, ag.name as group_name, ag.description as group_description,
            g.id as grade_id, g.name as grade_name, g.level as grade_level,
            c.id as class_id, c.name as class_name
        FROM academic_groups ag
        LEFT JOIN grades g ON g.academic_group_id = ag.id
        LEFT JOIN classes c ON c.grade_id = g.id
        ORDER BY ag.name, g.level, c.name
    ");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $groupsMap = [];
    foreach ($rows as $row) {
        $gid = $row['group_id'];
        if (!$gid) continue;
        if (!isset($groupsMap[$gid])) {
            $groupsMap[$gid] = [
                'id' => $gid,
                'name' => $row['group_name'],
                'description' => $row['group_description'] ?? '',
                'grades' => []
            ];
        }
        $grid = $row['grade_id'];
        if ($grid) {
            if (!isset($groupsMap[$gid]['grades'][$grid])) {
                $groupsMap[$gid]['grades'][$grid] = [
                    'id' => $grid,
                    'name' => $row['grade_name'],
                    'level' => (int)$row['grade_level'],
                    'classes' => []
                ];
            }
            $cid = $row['class_id'];
            if ($cid) {
                $groupsMap[$gid]['grades'][$grid]['classes'][$cid] = [
                    'id' => $cid,
                    'name' => $row['class_name']
                ];
            }
        }
    }

    $tree = array_values(array_map(function($g) {
        $g['grades'] = array_values(array_map(function($gr) {
            $gr['classes'] = array_values($gr['classes']);
            return $gr;
        }, $g['grades']));
        return $g;
    }, $groupsMap));

    $flatList = array_map(function($g) {
        return [
            'id' => $g['id'],
            'name' => $g['name'],
            'description' => $g['description']
        ];
    }, $tree);

    success_response([
        'groups' => $tree,
        'tree' => $tree,
        'list' => $flatList
    ]);
} catch (Exception $e) {
    error_response('Database error fetching academic groups', 500);
}

