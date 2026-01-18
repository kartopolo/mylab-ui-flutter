#!/usr/bin/env bash
set -euo pipefail

PORT=${PORT:-36883}
HOST=${HOST:-0.0.0.0}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${SCRIPT_DIR%/scripts}"
FLUTTER_BIN="$REPO_ROOT/flutter/bin/flutter"
LOG_FILE="$REPO_ROOT/web-run.log"
PID_FILE="$REPO_ROOT/web-run.pid"

cd "$REPO_ROOT"

# Check if already listening
EXISTING_PID=$(ss -ltnp | awk -v p=":$PORT$" '$4 ~ p { if(match($0, /pid=([0-9]+)/, m)) { print m[1] } }') || true
if [[ -n "${EXISTING_PID:-}" ]]; then
  echo "Flutter web already running on :$PORT (pid $EXISTING_PID)"
  STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:$PORT/" || echo "curl_failed")
  echo "HTTP check: $STATUS"
  exit 0
fi

# Show Flutter version
"$FLUTTER_BIN" --version || true

# Start dev server
nohup "$FLUTTER_BIN" run -d web-server --web-hostname "$HOST" --web-port "$PORT" > "$LOG_FILE" 2>&1 &
WEB_PID=$!
echo "$WEB_PID" > "$PID_FILE"

# Wait briefly and show log tail
sleep 6
head -n 40 "$LOG_FILE" || true

# Verify HTTP
STATUS=$(curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:$PORT/" || echo "curl_failed")
if [[ "$STATUS" == "200" ]]; then
  echo "Started Flutter web on :$PORT (pid $WEB_PID) — HTTP 200"
else
  echo "Flutter web start attempted (pid $WEB_PID) — HTTP $STATUS"
fi
