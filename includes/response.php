<?php
ini_set('display_errors', 0);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED);

function json_response($data, $status_code = 200) {
    if (ob_get_length()) {
        ob_clean();
    }
    http_response_code($status_code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function success_response($data = [], $status_code = 200) {
    json_response([
        'status' => 'success',
        'success' => true,
        'data' => $data
    ], $status_code);
}

function error_response($message, $status_code = 400) {
    json_response([
        'status' => 'error',
        'success' => false,
        'error' => $message,
        'message' => $message
    ], $status_code);
}
