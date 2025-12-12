<?php
require_once __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET' && $_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['success' => false, 'message' => 'Method not allowed']);
  exit();
}

$student_id = '';
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  $student_id = isset($_GET['student_id']) ? trim((string)$_GET['student_id']) : '';
} else {
  $payload = read_json_body();
  if (is_array($payload)) {
    $student_id = isset($payload['student_id']) ? trim((string)$payload['student_id']) : '';
  }
}

if ($student_id === '') {
  http_response_code(422);
  echo json_encode(['success' => false, 'message' => 'student_id is required']);
  exit();
}

$mysqli = db_connect();
$sql = 'SELECT 
  u.student_id,
  u.role,
  u.department,
  u.position,
  u.phone,
  u.email,
  u.created_at,
  s.first_name,
  s.middle_name,
  s.last_name,
  s.course,
  s.year,
  s.section,
  TRIM(CONCAT(s.first_name, " ", IFNULL(s.middle_name, ""), " ", s.last_name)) AS full_name
FROM users u
LEFT JOIN student s ON s.id_number = u.student_id
WHERE u.student_id = ?
LIMIT 1';
if ($stmt = $mysqli->prepare($sql)) {
  $stmt->bind_param('s', $student_id);
  if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'DB error: execute failed', 'error' => $mysqli->error]);
    $stmt->close();
    $mysqli->close();
    exit();
  }
  $res = $stmt->get_result();
  $row = $res->fetch_assoc();
  $stmt->close();
  $mysqli->close();

  if (!$row) {
    echo json_encode(['success' => false, 'message' => 'User not found', 'user' => null]);
    exit();
  }

  echo json_encode(['success' => true, 'user' => $row]);
  exit();
} else {
  http_response_code(500);
  echo json_encode(['success' => false, 'message' => 'DB error: prepare failed', 'error' => $mysqli->error]);
  $mysqli->close();
  exit();
}
