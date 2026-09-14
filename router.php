<?php
// router.php - Router for SPS Code Orbit PHP Server

$uri = urldecode(
    parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH)
);

// Normalize path to avoid traversal/security issues
if (strpos($uri, '..') !== false) {
    header("HTTP/1.1 400 Bad Request");
    echo "Bad Request";
    exit;
}

// 1. If it's the root path, serve index.html
if ($uri === '/' || $uri === '') {
    if (file_exists(__DIR__ . '/index.html')) {
        header("Content-Type: text/html; charset=UTF-8");
        readfile(__DIR__ . '/index.html');
        return true;
    }
}

// 2. If the file exists and is not a PHP file, serve it statically
$filePath = __DIR__ . $uri;
if (file_exists($filePath) && !is_dir($filePath)) {
    $ext = pathinfo($filePath, PATHINFO_EXTENSION);
    if ($ext !== 'php') {
        // Set correct MIME type for static files
        $mimeTypes = [
            'html' => 'text/html; charset=UTF-8',
            'css'  => 'text/css; charset=UTF-8',
            'js'   => 'application/javascript; charset=UTF-8',
            'json' => 'application/json; charset=UTF-8',
            'png'  => 'image/png',
            'jpg'  => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'gif'  => 'image/gif',
            'svg'  => 'image/svg+xml',
            'ico'  => 'image/x-icon',
            'mp4'  => 'video/mp4',
            'webm' => 'video/webm',
            'woff' => 'font/woff',
            'woff2'=> 'font/woff2',
            'ttf'  => 'font/ttf',
            'otf'  => 'font/otf',
            'txt'  => 'text/plain; charset=UTF-8'
        ];
        if (isset($mimeTypes[$ext])) {
            header("Content-Type: " . $mimeTypes[$ext]);
        }
        readfile($filePath);
        return true;
    }
}

// 3. Otherwise, let the PHP built-in web server execute the .php file or handle directory listings
return false;
