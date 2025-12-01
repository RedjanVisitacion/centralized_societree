<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

$limit = isset($_GET['limit']) ? max(1, min(100, (int)$_GET['limit'])) : 20;

$mysqli = db_connect();
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

$sql = "SELECT id, type, title, body, link, effective_at, created_at
        FROM vote_notifications
        ORDER BY created_at DESC, id DESC
        LIMIT ?";
$stmt = $mysqli->prepare($sql);
if (!$stmt) { http_response_code(500); echo json_encode(['success'=>false,'message'=>'DB error']); exit(); }
$stmt->bind_param('i', $limit);
$stmt->execute();
$res = $stmt->get_result();
$items = [];
while ($row = $res->fetch_assoc()) { $items[] = $row; }
$stmt->close();

echo json_encode(['success'=>true, 'notifications'=>$items]);
