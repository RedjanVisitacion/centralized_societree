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
if ($student_id === '') {
  http_response_code(400);
  echo json_encode(['success'=>false,'message'=>'student_id required']);
  exit();
}

$mysqli = db_connect();

// Load latest window and check visibility
$win = null;
if ($res = $mysqli->query("SELECT id, start_at, end_at, results_at FROM vote_windows ORDER BY COALESCE(updated_at, created_at) DESC, id DESC LIMIT 1")) {
  $win = $res->fetch_assoc();
  $res->close();
}
if (!$win) { echo json_encode(['success'=>false,'message'=>'No vote window']); exit(); }
$now = time();
$endTs = $win['end_at'] ? strtotime($win['end_at']) : null;
$resultsTs = $win['results_at'] ? strtotime($win['results_at']) : null;
$results_visible = false;
if ($resultsTs !== null) { $results_visible = ($now >= $resultsTs); }
elseif ($endTs !== null) { $results_visible = ($now >= $endTs); }
if (!$results_visible) { echo json_encode(['success'=>false,'message'=>'Results not visible yet']); exit(); }

$window_id = (int)$win['id'];
$rid = 'RESULTS_' . $window_id;

// Ensure user_notifications table exists and has receipt_id unique key
@ $mysqli->query("CREATE TABLE IF NOT EXISTS user_notifications (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id VARCHAR(64) NOT NULL,
  receipt_id VARCHAR(64) NULL,
  type VARCHAR(32) NOT NULL DEFAULT 'info',
  title VARCHAR(255) NOT NULL,
  body TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP NULL DEFAULT NULL,
  pinned TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uniq_student_receipt (student_id, receipt_id),
  KEY idx_student_created (student_id, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

// Build winners per position using vote_results if available, otherwise live aggregate
$winners = [];
$byPosition = [];
$hasVoteResults = false;
if ($chk = @$mysqli->query("SHOW TABLES LIKE 'vote_results'")) { $hasVoteResults = $chk->num_rows > 0; $chk->close(); }
if ($hasVoteResults) {
  $sql = "SELECT vr.position, vr.candidate_id, vr.votes,
                 TRIM(CONCAT(COALESCE(c.first_name,''),' ',COALESCE(c.middle_name,''),' ',COALESCE(c.last_name,''))) AS name
          FROM vote_results vr
          LEFT JOIN candidates_registration c ON c.id = vr.candidate_id";
  if (!($res = $mysqli->query($sql))) { echo json_encode(['success'=>false,'message'=>'Query failed']); exit(); }
  while ($row = $res->fetch_assoc()) {
    $pos = (string)$row['position'];
    $votes = (int)$row['votes'];
    $name = preg_replace('/\s+/', ' ', trim($row['name'] ?? ''));
    if (!isset($byPosition[$pos])) $byPosition[$pos] = [];
    $byPosition[$pos][] = ['name'=>$name,'votes'=>$votes];
  }
  $res->close();
} else {
  $sql = "SELECT c.position AS position, c.id AS candidate_id,
                 TRIM(CONCAT(COALESCE(c.first_name,''),' ',COALESCE(c.middle_name,''),' ',COALESCE(c.last_name,''))) AS name,
                 COUNT(vi.id) AS votes
          FROM candidates_registration c
          LEFT JOIN vote_items vi ON vi.candidate_id = c.id
          GROUP BY c.id, position, name";
  if (!($res = $mysqli->query($sql))) { echo json_encode(['success'=>false,'message'=>'Query failed']); exit(); }
  while ($row = $res->fetch_assoc()) {
    $pos = (string)$row['position'];
    $votes = (int)$row['votes'];
    $name = preg_replace('/\s+/', ' ', trim($row['name'] ?? ''));
    if (!isset($byPosition[$pos])) $byPosition[$pos] = [];
    $byPosition[$pos][] = ['name'=>$name,'votes'=>$votes];
  }
  $res->close();
}

foreach ($byPosition as $pos => $list) {
  usort($list, function($a,$b){ return $b['votes'] <=> $a['votes']; });
  if (empty($list)) continue;
  $topVotes = $list[0]['votes'];
  $winners[$pos] = array_values(array_filter($list, function($x) use ($topVotes){ return $x['votes'] === $topVotes; }));
}

if (empty($winners)) { echo json_encode(['success'=>false,'message'=>'No results']); exit(); }

// Compose summary text
$lines = [];
foreach ($winners as $pos => $arr) {
  $names = array_map(function($x){ return $x['name'] . ' (' . (int)$x['votes'] . ')'; }, $arr);
  $lines[] = $pos . ': ' . implode(', ', $names);
}
$title = 'Winners announced';
$body = implode("\n", $lines);

// Insert a single notification per student, idempotent by receipt_id, and auto-pin it
$mysqli->begin_transaction();
$ok = true;
if ($stmt = $mysqli->prepare('INSERT INTO user_notifications (student_id, receipt_id, type, title, body) VALUES (?, ?, "info", ?, ?) ON DUPLICATE KEY UPDATE title=VALUES(title), body=VALUES(body)')) {
  $stmt->bind_param('ssss', $student_id, $rid, $title, $body);
  $ok = @$stmt->execute();
  $stmt->close();
} else { $ok = false; }

// Get the id of the notification
$nid = 0;
if ($ok && ($sel = $mysqli->prepare('SELECT id FROM user_notifications WHERE student_id = ? AND receipt_id = ? LIMIT 1'))) {
  $sel->bind_param('ss', $student_id, $rid);
  if ($sel->execute()) {
    $sel->bind_result($nid);
    $sel->fetch();
  } else { $ok = false; }
  $sel->close();
}

// Unpin others and pin this one
if ($ok && $nid > 0) {
  if ($u1 = $mysqli->prepare('UPDATE user_notifications SET pinned = 0 WHERE student_id = ?')) {
    $u1->bind_param('s', $student_id);
    $ok = @$u1->execute();
    $u1->close();
  } else { $ok = false; }
  if ($ok && ($u2 = $mysqli->prepare('UPDATE user_notifications SET pinned = 1 WHERE id = ? AND student_id = ?'))) {
    $u2->bind_param('is', $nid, $student_id);
    $ok = @$u2->execute();
    $u2->close();
  } else { $ok = false; }
}

if ($ok) { $mysqli->commit(); } else { $mysqli->rollback(); }
echo json_encode(['success'=>$ok, 'title'=>$title, 'body'=>$body]);
exit();

http_response_code(500);
echo json_encode(['success'=>false,'message'=>'DB error']);
