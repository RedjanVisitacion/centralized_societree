<?php
require_once __DIR__ . '/config.php';

header('Content-Type: application/json');

function respond($statusCode, $payload) {
  http_response_code($statusCode);
  echo json_encode($payload);
  exit;
}

$mysqli = db_connect();
if (!$mysqli) {
  respond(500, ['success' => false, 'message' => 'DB connection failed']);
}

// Ensure dependent tables exist (defensive, in case migrations were skipped)
@ $mysqli->query("CREATE TABLE IF NOT EXISTS votes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(64) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

@ $mysqli->query("CREATE TABLE IF NOT EXISTS vote_items (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  vote_id INT UNSIGNED NOT NULL,
  position VARCHAR(128) NOT NULL,
  candidate_id INT UNSIGNED NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_vote_position (vote_id, position),
  CONSTRAINT fk_vote_items_vote FOREIGN KEY (vote_id) REFERENCES votes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

// Optional: some deployments maintain a tally column on candidates_registration
// We prefer live aggregation from vote_items when present

try {
  $positionFilter = isset($_GET['position']) ? trim($_GET['position']) : '';
  $orgFilter = isset($_GET['organization']) ? trim($_GET['organization']) : '';

  // Prefer accurate vote_results if present and has rows
  $hasVoteResults = false;
  if ($chk = @$mysqli->query("SHOW TABLES LIKE 'vote_results'")) {
    $hasVoteResults = $chk->num_rows > 0; $chk->close();
  }

  $items = [];
  if ($hasVoteResults) {
    $sql = "SELECT vr.candidate_id,
                   vr.position AS position_name,
                   vr.votes,
                   TRIM(CONCAT(COALESCE(c.first_name,''), ' ', COALESCE(c.middle_name,''), ' ', COALESCE(c.last_name,''))) AS candidate_name,
                   COALESCE(c.party_name, '') AS party_name,
                   COALESCE(c.organization, '') AS organization
            FROM vote_results vr
            LEFT JOIN candidates_registration c ON c.id = vr.candidate_id";
    $params = [];
    $wheres = [];
    if ($positionFilter !== '') { $wheres[] = 'vr.position = ?'; $params[] = $positionFilter; }
    if ($orgFilter !== '') { $wheres[] = 'c.organization = ?'; $params[] = $orgFilter; }
    if (!empty($wheres)) { $sql .= ' WHERE ' . implode(' AND ', $wheres); }
    $sql .= " ORDER BY vr.votes DESC, candidate_name ASC";

    if (!empty($params)) {
      $stmt = $mysqli->prepare($sql);
      if (!$stmt) { respond(500, ['success' => false, 'message' => 'Prepare failed', 'error' => $mysqli->error]); }
      $types = str_repeat('s', count($params));
      $stmt->bind_param($types, ...$params);
      if (!$stmt->execute()) { $stmt->close(); respond(500, ['success' => false, 'message' => 'Exec failed', 'error' => $mysqli->error]); }
      $res = $stmt->get_result();
    } else {
      $res = $mysqli->query($sql);
    }
    if (!$res) { respond(500, ['success' => false, 'message' => 'Query failed', 'error' => $mysqli->error]); }
    while ($row = $res->fetch_assoc()) {
      $name = preg_replace('/\s+/', ' ', trim($row['candidate_name'] ?? ''));
      $items[] = [
        'id' => (int)($row['candidate_id'] ?? 0),
        'candidate' => $name,
        'name' => $name,
        'position' => (string)($row['position_name'] ?? ''),
        'party_name' => (string)($row['party_name'] ?? ''),
        'votes' => (int)($row['votes'] ?? 0),
        'organization' => (string)($row['organization'] ?? ''),
      ];
    }
    if (!empty($params) && isset($stmt)) { $stmt->close(); }
  }

  if (!$hasVoteResults || empty($items)) {
    // Fallback to live aggregate from vote_items
    $sql = "SELECT 
              c.id AS candidate_id,
              TRIM(CONCAT(COALESCE(c.first_name,''), ' ', COALESCE(c.middle_name,''), ' ', COALESCE(c.last_name,''))) AS candidate_name,
              c.position AS position_name,
              COALESCE(c.party_name, '') AS party_name,
              COALESCE(c.organization, '') AS organization,
              COUNT(vi.id) AS votes
            FROM candidates_registration c
            LEFT JOIN vote_items vi ON vi.candidate_id = c.id";
    $params = [];
    $wheres = [];
    if ($positionFilter !== '') { $wheres[] = 'c.position = ?'; $params[] = $positionFilter; }
    if ($orgFilter !== '') { $wheres[] = 'c.organization = ?'; $params[] = $orgFilter; }
    if (!empty($wheres)) { $sql .= ' WHERE ' . implode(' AND ', $wheres); }
    $sql .= " GROUP BY c.id, candidate_name, position_name, party_name
              ORDER BY votes DESC, candidate_name ASC";

    if (!empty($params)) {
      $stmt = $mysqli->prepare($sql);
      if (!$stmt) { respond(500, ['success' => false, 'message' => 'Prepare failed', 'error' => $mysqli->error]); }
      $stmt->bind_param('s', $params[0]);
      if (!$stmt->execute()) { $stmt->close(); respond(500, ['success' => false, 'message' => 'Exec failed', 'error' => $mysqli->error]); }
      $res = $stmt->get_result();
    } else {
      $res = $mysqli->query($sql);
    }
    if (!$res) { respond(500, ['success' => false, 'message' => 'Query failed', 'error' => $mysqli->error]); }
    while ($row = $res->fetch_assoc()) {
      $name = preg_replace('/\s+/', ' ', trim($row['candidate_name'] ?? ''));
      $items[] = [
        'id' => (int)($row['candidate_id'] ?? 0),
        'candidate' => $name,
        'name' => $name,
        'position' => (string)($row['position_name'] ?? ''),
        'party_name' => (string)($row['party_name'] ?? ''),
        'votes' => (int)($row['votes'] ?? 0),
      ];
    }
    if (!empty($params) && isset($stmt)) { $stmt->close(); }
  }

  respond(200, ['success' => true, 'results' => $items]);
} catch (Throwable $e) {
  respond(500, ['success' => false, 'message' => 'Server error', 'error' => $e->getMessage()]);
}
