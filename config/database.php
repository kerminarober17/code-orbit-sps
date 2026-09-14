<?php
require_once __DIR__ . '/config.php';

/**
 * Canonical single database connection for the entire application.
 * ALL APIs must use get_db_connection() — no alternate PDO/mysqli connections.
 */
function get_db_connection() {
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $host = DB_HOST;
    $port = DB_PORT;
    $db   = DB_NAME;
    $user = DB_USER;
    $pass = DB_PASSWORD;
    $charset = DB_CHARSET;

    // Fail early with clear log if critical config is missing (common on misconfigured InfinityFree deploys)
    if ($host === '' || $db === '' || $user === '') {
        error_log('SPS DB config incomplete: DB_HOST/DB_NAME/DB_USER must be set in .env (or environment).');
        throw new \Exception('Database configuration error.');
    }

    $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
    ];

    // Prefer TCP DSN. Optional unix socket via DB_SOCKET in .env (local/dev only).
    $socket = getenv('DB_SOCKET') ?: '';
    if ($socket !== '' && file_exists($socket)) {
        $dsn = "mysql:unix_socket={$socket};dbname={$db};charset={$charset}";
    } else {
        $dsn = "mysql:host={$host};port={$port};dbname={$db};charset={$charset}";
    }

    try {
        $pdo = new PDO($dsn, $user, $pass, $options);
        // Ensure session timezone consistency is not required here; charset is set in DSN.
        return $pdo;
    } catch (\PDOException $e) {
        error_log('SPS DB connection failed: ' . $e->getMessage() . ' | host=' . $host . ' db=' . $db . ' user=' . $user);
        if (defined('APP_ENV') && APP_ENV === 'development') {
            throw new \PDOException($e->getMessage(), (int)$e->getCode());
        }
        throw new \Exception('Database connection error.');
    }
}
