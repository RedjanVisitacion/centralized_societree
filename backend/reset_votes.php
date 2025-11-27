<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

function respond($ok, $message) {
  echo json_encode(['success' => (bool)$ok, 'message' => (string)$message]);
  exit();
}

try {
  // Initialize DB connection
  $mysqli = db_connect();
  // Ensure tables exist (safety)
  $ddl1 = "CREATE TABLE IF NOT EXISTS votes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(64) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
  if (!$mysqli->query($ddl1)) { respond(false, 'Failed to ensure votes table'); }

  $ddl2 = "CREATE TABLE IF NOT EXISTS vote_items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    vote_id INT UNSIGNED NOT NULL,
    position VARCHAR(128) NOT NULL,
    candidate_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_vote_position (vote_id, position),
    CONSTRAINT fk_vote_items_vote FOREIGN KEY (vote_id) REFERENCES votes(id) ON DELETE CASCADE
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
  if (!$mysqli->query($ddl2)) { respond(false, 'Failed to ensure vote_items table'); }
  // Ensure results table exists (and clear it as part of reset)
  $ddl3 = "CREATE TABLE IF NOT EXISTS vote_results (
    candidate_id INT UNSIGNED NOT NULL,
    position VARCHAR(128) NOT NULL,
    votes INT NOT NULL DEFAULT 0,
    PRIMARY KEY (candidate_id),
    KEY idx_position (position)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4";
  if (!$mysqli->query($ddl3)) { respond(false, 'Failed to ensure vote_results table'); }

  $mysqli->begin_transaction();
  try {
    // Only clear vote tables. Do NOT modify candidate tallies per request
    if (!$mysqli->query('DELETE FROM vote_items')) { throw new Exception('Failed to clear vote_items'); }
    if (!$mysqli->query('DELETE FROM votes')) { throw new Exception('Failed to clear votes'); }
    if (!$mysqli->query('DELETE FROM vote_results')) { throw new Exception('Failed to clear vote_results'); }

    $mysqli->commit();
    respond(true, 'All votes have been cleared.');
  } catch (Exception $e) {
    $mysqli->rollback();
    respond(false, 'Reset failed: ' . $e->getMessage());
  }
} catch (Throwable $e) {
  respond(false, 'Server error: ' . $e->getMessage());
}
