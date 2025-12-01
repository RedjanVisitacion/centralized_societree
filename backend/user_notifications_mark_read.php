<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['success' => false, 'message' => 'Method not allowed']);
  exit();
}

$payload = read_json_body();
if (!is_array($payload)) { $payload = $_POST; }
$student_id = isset($payload['student_id']) ? trim((string)$payload['student_id']) : '';
$idsRaw = $payload['ids'] ?? null;

if ($student_id === '') {
  http_response_code(400);
  echo json_encode(['success'=>false,'message'=>'student_id required']);
  exit();
}

$mysqli = db_connect();
$ddl = "CREATE TABLE IF NOT EXISTS user_notifications (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id VARCHAR(64) NOT NULL,
  type VARCHAR(32) NOT NULL DEFAULT 'info',
  title VARCHAR(255) NOT NULL,
  body TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_student_created (student_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
$mysqli->query($ddl);

$where = 'student_id = ? AND read_at IS NULL';
$idParams = '';
$idList = [];
if (is_array($idsRaw) && count($idsRaw) > 0) {
  $placeholders = [];
  foreach ($idsRaw as $id) { $placeholders[] = '?'; $idList[] = (int)$id; $idParams .= 'i'; }
  $where .= ' AND id IN (' . implode(',', $placeholders) . ')';
}

$sql = 'UPDATE user_notifications SET read_at = NOW() WHERE ' . $where;
$stmt = $mysqli->prepare($sql);
if (!$stmt) { http_response_code(500); echo json_encode(['success'=>false,'message'=>'DB error']); exit(); }
if (count($idList) > 0) {
  $types = 's' . $idParams;
  $stmt->bind_param($types, $student_id, ...$idList);
} else {
  $stmt->bind_param('s', $student_id);
}
$stmt->execute();
$affected = $stmt->affected_rows;
$stmt->close();

echo json_encode(['success'=>true, 'updated'=>$affected]);
