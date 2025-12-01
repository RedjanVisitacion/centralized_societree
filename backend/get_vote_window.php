<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
  http_response_code(405);
  echo json_encode(['success' => false, 'message' => 'Method not allowed']);
  exit();
}

$mysqli = db_connect();

$sql = "SELECT id, start_at, end_at, results_at, note, created_at, updated_at FROM vote_windows ORDER BY COALESCE(updated_at, created_at) DESC, id DESC LIMIT 1";
if ($res = $mysqli->query($sql)) {
  if ($row = $res->fetch_assoc()) {
    $res->close();
    $now = time();
    $startTs = $row['start_at'] ? strtotime($row['start_at']) : null;
    $endTs = $row['end_at'] ? strtotime($row['end_at']) : null;
    $resultsTs = $row['results_at'] ? strtotime($row['results_at']) : null;

    $voting_open = false;
    if ($startTs !== null && $endTs !== null) {
      $voting_open = ($now >= $startTs && $now <= $endTs);
    } elseif ($startTs !== null && $endTs === null) {
      $voting_open = ($now >= $startTs);
    } elseif ($startTs === null && $endTs !== null) {
      $voting_open = ($now <= $endTs);
    }

    $results_visible = false;
    if ($resultsTs !== null) {
      $results_visible = ($now >= $resultsTs);
    } elseif ($endTs !== null) {
      $results_visible = ($now >= $endTs);
    }

    echo json_encode([
      'success' => true,
      'window' => $row,
      'now' => date('Y-m-d H:i:s', $now),
      'voting_open' => $voting_open,
      'results_visible' => $results_visible,
    ]);
  } else {
    echo json_encode(['success' => true, 'window' => null]);
  }
} else {
  http_response_code(500);
  echo json_encode(['success' => false, 'message' => 'Database error', 'error' => $mysqli->error]);
}
$mysqli->close();
