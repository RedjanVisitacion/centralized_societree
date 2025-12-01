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
$type = isset($payload['type']) ? trim((string)$payload['type']) : 'info';
$title = isset($payload['title']) ? trim((string)$payload['title']) : '';
$body = isset($payload['body']) ? trim((string)$payload['body']) : '';
$link = isset($payload['link']) ? trim((string)$payload['link']) : '';
$effective_at = isset($payload['effective_at']) ? trim((string)$payload['effective_at']) : '';

if ($title === '') {
  http_response_code(400);
  echo json_encode(['success'=>false,'message'=>'title is required']);
  exit();
}

$mysqli = db_connect();
// Ensure table exists
$ddl = "CREATE TABLE IF NOT EXISTS vote_notifications (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  type VARCHAR(32) NOT NULL DEFAULT 'info',
  title VARCHAR(255) NOT NULL,
  body TEXT NULL,
  link VARCHAR(255) NULL,
  effective_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
$mysqli->query($ddl);

$ins = $mysqli->prepare('INSERT INTO vote_notifications (type, title, body, link, effective_at) VALUES (?, ?, ?, ?, ?)');
if (!$ins) { http_response_code(500); echo json_encode(['success'=>false,'message'=>'DB error']); exit(); }
$ea = ($effective_at !== '') ? $effective_at : null;
$ins->bind_param('sssss', $type, $title, $body, $link, $ea);
$ok = $ins->execute();
$id = $ins->insert_id;
$ins->close();

echo json_encode(['success'=>$ok, 'id'=>$id]);
