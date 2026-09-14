<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_get_method();

try {
    $db = get_db_connection();
    // Get all groups, grades, and classes
    $stmt = $db->query("
        SELECT 
            c.id as class_id, c.name as class_name,
            g.id as grade_id, g.name as grade_name,
            ag.id as group_id, ag.name as group_name
        FROM academic_groups ag
        LEFT JOIN grades g ON g.academic_group_id = ag.id
        LEFT JOIN classes c ON c.grade_id = g.id
        ORDER BY ag.name, g.level, c.name
    ");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    $groups = [];
    foreach ($rows as $row) {
        $gid = $row['group_id'];
        if (!$gid) continue;
        if (!isset($groups[$gid])) {
            $groups[$gid] = [
                'id' => $gid,
                'name' => $row['group_name'],
                'grades' => []
            ];
        }
        $grid = $row['grade_id'];
        if ($grid) {
            if (!isset($groups[$gid]['grades'][$grid])) {
                $groups[$gid]['grades'][$grid] = [
                    'id' => $grid,
                    'name' => $row['grade_name'],
                    'classes' => []
                ];
            }
            $cid = $row['class_id'];
            if ($cid) {
                $groups[$gid]['grades'][$grid]['classes'][$cid] = [
                    'id' => $cid,
                    'name' => $row['class_name']
                ];
            }
        }
    }
    
    // Convert to flat arrays
    $result = array_values(array_map(function($group) {
        $group['grades'] = array_values(array_map(function($gr) {
            $gr['classes'] = array_values($gr['classes']);
            return $gr;
        }, $group['grades']));
        return $group;
    }, $groups));

    success_response(['groups' => $result]);
} catch (Exception $e) {
    error_response('Database error loading classes', 500);
}

