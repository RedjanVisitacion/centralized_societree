<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['success' => false, 'message' => 'Method not allowed']);
  exit();
}

$payload = read_json_body();
if (!is_array($payload)) { http_response_code(400); echo json_encode(['success'=>false,'message'=>'Invalid JSON']); exit(); }
$student_id = isset($payload['student_id']) ? trim((string)$payload['student_id']) : '';
$email = isset($payload['email']) ? trim((string)$payload['email']) : null;
$phone = isset($payload['phone']) ? trim((string)$payload['phone']) : null;

if ($student_id === '') { http_response_code(422); echo json_encode(['success'=>false,'message'=>'student_id is required']); exit(); }
if ($email !== null && $email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) {
  http_response_code(422); echo json_encode(['success'=>false,'message'=>'Invalid email']); exit();
}
if ($phone !== null && $phone !== '' && strlen(preg_replace('/\D+/', '', $phone)) < 10) {
  http_response_code(422); echo json_encode(['success'=>false,'message'=>'Invalid phone number']); exit();
}

$mysqli = db_connect();

if ($email === null && $phone === null) {
  echo json_encode(['success'=>false,'message'=>'Nothing to update']);
  $mysqli->close();
  exit();
}

$sets = [];
$params = [];
$types = '';
if ($email !== null) { $sets[] = 'email = ?'; $params[] = $email; $types .= 's'; }
if ($phone !== null) { $sets[] = 'phone = ?'; $params[] = $phone; $types .= 's'; }
$params[] = $student_id; $types .= 's';
$sql = 'UPDATE users SET ' . implode(', ', $sets) . ' WHERE student_id = ?';

if ($stmt = $mysqli->prepare($sql)) {
  $stmt->bind_param($types, ...$params);
  if (!$stmt->execute()) {
    http_response_code(500);
    echo json_encode(['success'=>false,'message'=>'DB error: execute failed','error'=>$mysqli->error]);
    $stmt->close();
    $mysqli->close();
    exit();
  }
  $affected = $stmt->affected_rows;
  $stmt->close();
  if ($affected >= 0) {
    echo json_encode(['success'=>true,'message'=>'Contact updated','affected_rows'=>$affected,'student_id'=>$student_id]);
  } else {
    http_response_code(500);
    echo json_encode(['success'=>false,'message'=>'Update failed']);
  }
} else {
  http_response_code(500);
  echo json_encode(['success'=>false,'message'=>'DB error: prepare failed','error'=>$mysqli->error]);
}
$mysqli->close();
