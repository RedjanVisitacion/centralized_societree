<?php
require_once __DIR__ . '/config.php';

$mysqli = db_connect();

// Get all announcements ordered by datetime (newest first)
$query = "SELECT 
            announcement_id, 
            announcement_title, 
            NULLIF(announcement_type, '') as announcement_type,
            announcement_content, 
            announcement_datetime
          FROM usg_announcement 
          ORDER BY announcement_datetime DESC";

$result = $mysqli->query($query);

if (!$result) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $mysqli->error,
        'announcements' => []
    ]);
    exit();
}

$announcements = [];
while ($row = $result->fetch_assoc()) {
    $announcements[] = $row;
}

$result->free();
$mysqli->close();

echo json_encode([
    'success' => true,
    'message' => 'Announcements retrieved successfully',
    'announcements' => $announcements,
    'count' => count($announcements)
]);
?>