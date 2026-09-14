<?php

function get_json_request() {
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    return is_array($data) ? $data : [];
}

function require_post_method() {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        require_once __DIR__ . '/response.php';
        error_response('Method Not Allowed', 405);
    }
}

function require_get_method() {
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        require_once __DIR__ . '/response.php';
        error_response('Method Not Allowed', 405);
    }
}

function generate_uuid_v4() {
    // Generate 16 bytes (128 bits) of random data
    $data = random_bytes(16);

    // Set version to 0100
    $data[6] = chr(ord($data[6]) & 0x0f | 0x40);
    // Set bits 6-7 to 10
    $data[8] = chr(ord($data[8]) & 0x3f | 0x80);

    // Output the 36 character UUID.
    return vsprintf('%s%s-%s-%s-%s-%s%s%s', str_split(bin2hex($data), 4));
}

function sanitize_string($str) {
    return htmlspecialchars(trim($str), ENT_QUOTES, 'UTF-8');
}
