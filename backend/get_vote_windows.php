<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

$limit = isset($_GET['limit']) ? max(1, min(50, (int)$_GET['limit'])) : 10;

try {
  $mysqli = db_connect();
  $sql = "SELECT id, start_at, end_at, results_at, note, created_at, updated_at
          FROM vote_windows
          ORDER BY COALESCE(updated_at, created_at) DESC, id DESC
          LIMIT ?";
  $stmt = $mysqli->prepare($sql);
  if (!$stmt) { http_response_code(500); echo json_encode(['success'=>false,'message'=>'DB error: prepare failed']); exit(); }
  $stmt->bind_param('i', $limit);
  $stmt->execute();
  $res = $stmt->get_result();
  $items = [];
  while ($row = $res->fetch_assoc()) { $items[] = $row; }
  $stmt->close();
  echo json_encode(['success'=>true, 'windows'=>$items]);
} catch (Throwable $e) {
  http_response_code(500);
  echo json_encode(['success'=>false,'message'=>'Server error: '.$e->getMessage()]);
}
