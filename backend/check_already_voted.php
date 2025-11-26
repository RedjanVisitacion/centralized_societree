<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
require_once __DIR__ . '/config.php';
$mysqli = db_connect();

function respond($ok, $extra = []) {
  echo json_encode(array_merge(['success' => $ok], $extra));
  exit;
}

$student_id = $_GET['student_id'] ?? '';
if (!$student_id) {
  http_response_code(400);
  echo json_encode(['success' => false, 'message' => 'Missing student_id']);
  exit;
}

// Ensure votes table exists (matches submit_vote.php)
$ddl = "CREATE TABLE IF NOT EXISTS votes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(64) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
@$mysqli->query($ddl);

$already = false;
if ($stmt = $mysqli->prepare('SELECT 1 FROM votes WHERE student_id = ? LIMIT 1')) {
  $stmt->bind_param('s', $student_id);
  $stmt->execute();
  $stmt->store_result();
  $already = $stmt->num_rows > 0;
  $stmt->close();
}

respond(true, ['already_voted' => $already]);
