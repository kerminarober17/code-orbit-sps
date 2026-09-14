<?php

function map_string_to_academic_tier($str) {
    if (empty($str)) return null;
    $s = strtolower($str);

    if (strpos($s, 'sec') !== false || strpos($s, 'secondary') !== false || strpos($s, 'prep 3') !== false || strpos($s, 'grade 7') !== false || strpos($s, 'grade 8') !== false || strpos($s, 'grade 9') !== false) {
        return 'Secondary';
    }
    if (strpos($s, 'prep') !== false || strpos($s, 'preparatory') !== false) {
        return 'Preparatory';
    }
    if (strpos($s, 'p5') !== false || strpos($s, 'p6') !== false || strpos($s, 'primary 5') !== false || strpos($s, 'primary 6') !== false || strpos($s, '5') !== false || strpos($s, '6') !== false) {
        return 'Primary 5 & 6';
    }
    if (strpos($s, 'p3') !== false || strpos($s, 'p4') !== false || strpos($s, 'primary 3') !== false || strpos($s, 'primary 4') !== false || strpos($s, '3') !== false || strpos($s, '4') !== false) {
        return 'Primary 3 & 4';
    }
    return null;
}

function get_student_academic_tier($db, $user) {
    if (!$user) return null;
    if (!empty($user['class_id'])) {
        $stmt = $db->prepare("
            SELECT ag.name as ag_name, g.name as grade_name, c.name as class_name
            FROM classes c
            LEFT JOIN grades g ON c.grade_id = g.id
            LEFT JOIN academic_groups ag ON g.academic_group_id = ag.id
            WHERE c.id = ?
        ");
        $stmt->execute([$user['class_id']]);
        $row = $stmt->fetch();
        if ($row) {
            $combined = ($row['ag_name'] ?? '') . ' ' . ($row['grade_name'] ?? '') . ' ' . ($row['class_name'] ?? '');
            $tier = map_string_to_academic_tier($combined);
            if ($tier) return $tier;
            if (!empty($row['ag_name'])) return $row['ag_name'];
        }
    }
    return null;
}

function ensure_curriculum_seeded($db) {
    // Production curriculum is authoritative in MySQL.
    // Auto-seeding during runtime is disabled to prevent accidental wipes or overrides.
    return;
}

// auto_enroll_student_in_tier_course REMOVED — enrollment is manual only (Phase 5)

function can_student_access_course($db, $course_id, $user) {
    if (!$user || $user['role'] !== 'student') {
        return false;
    }

    // Check if course is published
    $stmt = $db->prepare("SELECT is_published, academic_group_id FROM courses WHERE id = ?");
    $stmt->execute([$course_id]);
    $course = $stmt->fetch();

    if (!$course || !$course['is_published']) {
        return false;
    }

    return true; // Allow students to access any published course
}

function can_user_access_course($db, $course_id, $user) {
    if (!$user) return false;
    if ($user['role'] === 'admin') return true;
    if ($user['role'] === 'teacher') return true; 

    return can_student_access_course($db, $course_id, $user);
}

function is_valid_block_type($type) {
    $allowed = [
        'text', 'image', 'example', 'code', 'quiz',
        'multiple_choice', 'true_false', 'interactive',
        'hint', 'challenge', 'completion', 'story_dialogue'
    ];
    return in_array($type, $allowed, true);
}

