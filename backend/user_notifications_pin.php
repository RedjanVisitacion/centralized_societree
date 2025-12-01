<?php
require_once __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['success' => false, 'message' => 'Method not allowed']);
  exit();
}

$payload = read_json_body();
if (!is_array($payload)) { $payload = $_POST; }
$student_id = isset($payload['student_id']) ? trim((string)$payload['student_id']) : '';
$id = isset($payload['id']) ? (int)$payload['id'] : 0;
$pinned = isset($payload['pinned']) ? (int)!!$payload['pinned'] : 1;

if ($student_id === '' || $id <= 0) {
  http_response_code(400);
  echo json_encode(['success'=>false,'message'=>'student_id and id are required']);
  exit();
}

$mysqli = db_connect();
// Ensure schema has pinned column
@$mysqli->query("ALTER TABLE user_notifications ADD COLUMN pinned TINYINT(1) NOT NULL DEFAULT 0");

if ($pinned === 1) {
  $mysqli->begin_transaction();
  $ok = true;
  if ($stmt = $mysqli->prepare('UPDATE user_notifications SET pinned = 0 WHERE student_id = ?')) {
    $stmt->bind_param('s', $student_id);
    $ok = @$stmt->execute();
    $stmt->close();
  } else { $ok = false; }
  if ($ok && ($stmt = $mysqli->prepare('UPDATE user_notifications SET pinned = 1 WHERE id = ? AND student_id = ?'))) {
    $stmt->bind_param('is', $id, $student_id);
    $ok = @$stmt->execute();
    $stmt->close();
  } else { $ok = false; }
  if ($ok) { $mysqli->commit(); } else { $mysqli->rollback(); }
  echo json_encode(['success' => (bool)$ok]);
  exit();
} else {
  if ($stmt = $mysqli->prepare('UPDATE user_notifications SET pinned = 0 WHERE id = ? AND student_id = ?')) {
    $stmt->bind_param('is', $id, $student_id);
    $ok = @$stmt->execute();
    $stmt->close();
    echo json_encode(['success' => (bool)$ok]);
    exit();
  }
}
http_response_code(500);
echo json_encode(['success'=>false,'message'=>'DB error']);
