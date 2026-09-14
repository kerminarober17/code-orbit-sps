<?php
/**
 * PUBLIC safe DB connectivity probe for deployment diagnosis.
 * Does NOT require login (needed when login itself is broken).
 * Does NOT expose passwords, hashes, or full credentials.
 * Remove or restrict this file after production is stable if desired.
 */
header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

$result = [
    'status' => 'error',
    'success' => false,
    'php_version' => PHP_VERSION,
    'pdo_mysql_loaded' => extension_loaded('pdo_mysql'),
    'env_file_exists' => false,
    'env_loaded' => [
        'DB_HOST_set' => false,
        'DB_NAME_set' => false,
        'DB_USER_set' => false,
        'DB_PASSWORD_set' => false,
    ],
    'connection' => 'not_attempted',
    'select_database' => null,
    'server_version' => null,
    'profiles_count' => null,
    'courses_count' => null,
    'hint' => null,
];

// Locate .env the same way config does
$envPath = __DIR__ . '/../../.env';
$result['env_file_exists'] = file_exists($envPath);
$result['env_path_checked'] = '.env next to config/ (project root)';

try {
    require_once __DIR__ . '/../../config/database.php';

    $result['env_loaded'] = [
        'DB_HOST_set' => (DB_HOST !== ''),
        'DB_NAME_set' => (DB_NAME !== ''),
        'DB_USER_set' => (DB_USER !== ''),
        'DB_PASSWORD_set' => (DB_PASSWORD !== ''),
        // Safe partial host (first label only) to confirm which host was loaded
        'DB_HOST_preview' => DB_HOST !== '' ? (explode('.', DB_HOST)[0] . '.***') : '',
        'DB_NAME_preview' => DB_NAME !== '' ? (substr(DB_NAME, 0, 6) . '***') : '',
        'DB_USER_preview' => DB_USER !== '' ? (substr(DB_USER, 0, 4) . '***') : '',
    ];

    if (!extension_loaded('pdo_mysql')) {
        $result['hint'] = 'Enable pdo_mysql in InfinityFree / PHP settings.';
        echo json_encode($result, JSON_PRETTY_PRINT);
        exit;
    }

    if (DB_HOST === '' || DB_NAME === '' || DB_USER === '') {
        $result['connection'] = 'skipped_incomplete_config';
        $result['hint'] = '.env missing or DB_HOST/DB_NAME/DB_USER empty. Place .env in project root (same level as config/).';
        echo json_encode($result, JSON_PRETTY_PRINT);
        exit;
    }

    $db = get_db_connection();
    $result['connection'] = 'ok';
    $result['select_database'] = $db->query('SELECT DATABASE()')->fetchColumn();
    $result['server_version'] = $db->query('SELECT VERSION()')->fetchColumn();
    try {
        $result['profiles_count'] = (int)$db->query('SELECT COUNT(*) FROM profiles')->fetchColumn();
        $result['courses_count'] = (int)$db->query('SELECT COUNT(*) FROM courses')->fetchColumn();
    } catch (Exception $e) {
        $result['hint'] = 'Connected, but tables missing. Import database/database.sql then run seeds.';
        $result['schema_error'] = 'tables_or_query_failed';
    }
    $result['status'] = 'success';
    $result['success'] = true;
    $result['hint'] = 'Connection OK. Use the same DB in phpMyAdmin. Signup should insert into this profiles table.';
} catch (Throwable $e) {
    $result['connection'] = 'failed';
    // Do not expose full exception to public; log only
    error_log('db_ping failed: ' . $e->getMessage());
    $msg = $e->getMessage();
    if (stripos($msg, 'configuration') !== false) {
        $result['hint'] = 'DB config incomplete. Check .env path and DB_HOST/DB_NAME/DB_USER.';
    } elseif (stripos($msg, 'connection') !== false || stripos($msg, 'Access denied') !== false || stripos($msg, 'Unknown database') !== false) {
        $result['hint'] = 'Cannot connect. Check DB_HOST (InfinityFree often uses sqlXXX.infinityfree.com), DB_NAME, DB_USER, DB_PASSWORD exactly as in the panel.';
    } else {
        $result['hint'] = 'Connection failed. Check PHP error log and .env values. Ensure pdo_mysql is enabled.';
    }
}

echo json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
