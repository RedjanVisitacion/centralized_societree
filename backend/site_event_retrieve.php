<?php
require_once __DIR__ . '/config.php';

$mysqli = db_connect();

// Get all SITE events ordered by datetime (newest first)
$query = "SELECT 
            id,
            event_title, 
            event_description,
            event_datetime,
            event_location,
            created_at
          FROM site_event 
          ORDER BY event_datetime DESC";

$result = $mysqli->query($query);

if (!$result) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $mysqli->error,
        'data' => []
    ]);
    exit();
}

$events = [];
while ($row = $result->fetch_assoc()) {
    $events[] = $row;
}

$result->free();
$mysqli->close();

echo json_encode([
    'success' => true,
    'message' => 'Events retrieved successfully',
    'data' => $events,
    'count' => count($events)
]);