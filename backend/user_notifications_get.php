<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

$student_id = isset($_GET['student_id']) ? trim((string)$_GET['student_id']) : '';
$limit = isset($_GET['limit']) ? max(1, min(100, (int)$_GET['limit'])) : 20;
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
  pinned TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_student_created (student_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
$mysqli->query($ddl);

// Migration: ensure pinned column exists on older installs
@ $mysqli->query("ALTER TABLE user_notifications ADD COLUMN pinned TINYINT(1) NOT NULL DEFAULT 0");

// Load current notifications
$sql = "SELECT id, type, title, body, created_at, read_at, pinned
        FROM user_notifications
        WHERE student_id = ?
        ORDER BY pinned DESC, created_at DESC, id DESC
        LIMIT ?";
$stmt = $mysqli->prepare($sql);
if (!$stmt) { http_response_code(500); echo json_encode(['success'=>false,'message'=>'DB error']); exit(); }
$stmt->bind_param('si', $student_id, $limit);
$stmt->execute();
$res = $stmt->get_result();
$items = [];
while ($row = $res->fetch_assoc()) { $items[] = $row; }
$stmt->close();

// Backfill a vote notification if user already voted but has no such notification yet
if (count($items) === 0) {
  $voted = false;
  if ($q = $mysqli->prepare('SELECT 1 FROM votes WHERE student_id = ? LIMIT 1')) {
    $q->bind_param('s', $student_id);
    $q->execute();
    $q->store_result();
    $voted = $q->num_rows > 0;
    $q->close();
  }
  if ($voted) {
    // Avoid duplicate backfill: check if any existing row with title like 'Vote submitted'
    $hasRow = false;
    if ($q2 = $mysqli->prepare("SELECT 1 FROM user_notifications WHERE student_id = ? AND title LIKE 'Vote submitted%' LIMIT 1")) {
      $q2->bind_param('s', $student_id);
      $q2->execute();
      $q2->store_result();
      $hasRow = $q2->num_rows > 0;
      $q2->close();
    }
    if (!$hasRow) {
      // Try to get latest receipt id
      $rid = null;
      if ($qr = $mysqli->prepare('SELECT receipt_id FROM vote_receipts WHERE student_id = ? ORDER BY created_at DESC, id DESC LIMIT 1')) {
        $qr->bind_param('s', $student_id);
        if ($qr->execute()) {
          $qr->bind_result($ridTmp);
          if ($qr->fetch()) { $rid = $ridTmp; }
        }
        $qr->close();
      }
      $body = 'Your vote has been recorded.' . ($rid ? (' Receipt: ' . $rid) : '');
      if ($ins = $mysqli->prepare('INSERT INTO user_notifications (student_id, type, title, body) VALUES (?, "success", "Vote submitted", ?)')) {
        $ins->bind_param('ss', $student_id, $body);
        @$ins->execute();
        $ins->close();
      }
      // Reload list after insert
      if ($stmt2 = $mysqli->prepare($sql)) {
        $stmt2->bind_param('si', $student_id, $limit);
        $stmt2->execute();
        $res2 = $stmt2->get_result();
        $items = [];
        while ($row = $res2->fetch_assoc()) { $items[] = $row; }
        $stmt2->close();
      }
    }
  }
}

echo json_encode(['success'=>true, 'notifications'=>$items]);
