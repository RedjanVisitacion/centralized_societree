<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['success' => false, 'message' => 'Method not allowed']);
  exit();
}

$payload = read_json_body();
if (!is_array($payload)) {
  $payload = $_POST; // allow form encoded as fallback
}

$student_id = isset($payload['student_id']) ? trim((string)$payload['student_id']) : '';
$password = isset($payload['password']) ? (string)$payload['password'] : '';
$start_at  = isset($payload['start_at']) ? trim((string)$payload['start_at']) : '';
$end_at    = isset($payload['end_at']) ? trim((string)$payload['end_at']) : '';
$results_at= isset($payload['results_at']) ? trim((string)$payload['results_at']) : '';
$note      = isset($payload['note']) ? trim((string)$payload['note']) : '';

if ($student_id === '' || $password === '') {
  http_response_code(401);
  echo json_encode(['success' => false, 'message' => 'Admin credentials required']);
  exit();
}

function parse_dt($v) {
  if ($v === '' || $v === null) return null;
  $v = trim($v);
  $ts = strtotime($v);
  if ($ts === false) return null;
  return date('Y-m-d H:i:s', $ts);
}

$start_dt = parse_dt($start_at);
$end_dt = parse_dt($end_at);
$results_dt = parse_dt($results_at);

$mysqli = db_connect();

$stmt = $mysqli->prepare('SELECT id, password_hash, role FROM users WHERE student_id = ?');
if (!$stmt) { http_response_code(500); echo json_encode(['success'=>false,'message'=>'Database error (prepare)']); exit(); }
$stmt->bind_param('s', $student_id);
$stmt->execute();
$stmt->bind_result($uid, $hash, $role);
if ($stmt->fetch()) {
  $stmt->close();
  $isBcrypt = (strpos($hash, '$2') === 0);
  $ok = password_verify($password, $hash) || (!$isBcrypt && hash_equals($password, $hash));
  if (!$ok || strtolower((string)$role) !== 'admin') {
    http_response_code(403);
    echo json_encode(['success'=>false,'message'=>'Forbidden: admin only']);
    $mysqli->close();
    exit();
  }
} else {
  $stmt->close();
  http_response_code(401);
  echo json_encode(['success'=>false,'message'=>'Invalid credentials']);
  $mysqli->close();
  exit();
}

$ins = $mysqli->prepare('INSERT INTO vote_windows (start_at, end_at, results_at, note) VALUES (?, ?, ?, ?)');
if (!$ins) { http_response_code(500); echo json_encode(['success'=>false,'message'=>'Database error (prepare insert)','error'=>$mysqli->error]); $mysqli->close(); exit(); }
$ins->bind_param('ssss', $start_dt, $end_dt, $results_dt, $note);
if (!$ins->execute()) {
  $err = $mysqli->error;
  $ins->close();
  http_response_code(500);
  echo json_encode(['success'=>false,'message'=>'Failed to set vote window','error'=>$err]);
  $mysqli->close();
  exit();
}
$id = $ins->insert_id;
$ins->close();

// Return the saved record
if ($res = $mysqli->query("SELECT id, start_at, end_at, results_at, note, created_at, updated_at FROM vote_windows WHERE id = " . (int)$id)) {
  $row = $res->fetch_assoc();
  $res->close();
  echo json_encode(['success'=>true, 'window'=>$row]);
} else {
  echo json_encode(['success'=>true, 'id'=>$id]);
}
$mysqli->close();
