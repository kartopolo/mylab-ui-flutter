#!/usr/bin/env bash
set -euo pipefail

# Script to run Flutter with Windows Chrome/Edge for debugging
# Usage: ./scripts/run-chrome.sh [chrome|edge]

BROWSER=${1:-edge}
PORT=${PORT:-36883}
HOST=${HOST:-0.0.0.0}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${SCRIPT_DIR%/scripts}"
FLUTTER_BIN="$REPO_ROOT/flutter/bin/flutter"
LOG_FILE="$REPO_ROOT/dev-chrome.log"
PID_FILE="$REPO_ROOT/dev-chrome.pid"

cd "$REPO_ROOT"

# Set browser executable path
if [[ "$BROWSER" == "chrome" ]]; then
  export CHROME_EXECUTABLE="/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
  if [[ ! -f "$CHROME_EXECUTABLE" ]]; then
    export CHROME_EXECUTABLE="/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
  fi
  DEVICE_ID="chrome"
  echo "Using Chrome: $CHROME_EXECUTABLE"
else
  export CHROME_EXECUTABLE="/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
  if [[ ! -f "$CHROME_EXECUTABLE" ]]; then
    export CHROME_EXECUTABLE="/mnt/c/Program Files/Microsoft/Edge/Application/msedge.exe"
  fi
  DEVICE_ID="edge"
  echo "Using Edge: $CHROME_EXECUTABLE"
fi

# Check if browser exists
if [[ ! -f "$CHROME_EXECUTABLE" ]]; then
  echo "ERROR: Browser not found at: $CHROME_EXECUTABLE"
  echo "Available browsers:"
  ls -la /mnt/c/Program\ Files*/*/Chrome/Application/*.exe 2>/dev/null || true
  ls -la /mnt/c/Program\ Files*/Microsoft/Edge/Application/*.exe 2>/dev/null || true
  exit 1
fi

# Kill existing if running
if [[ -f "$PID_FILE" ]]; then
  OLD_PID=$(cat "$PID_FILE")
  if ps -p "$OLD_PID" > /dev/null 2>&1; then
    echo "Stopping existing Flutter process (pid $OLD_PID)..."
    kill "$OLD_PID" 2>/dev/null || true
    sleep 2
  fi
  rm -f "$PID_FILE"
fi

# Show Flutter version
"$FLUTTER_BIN" --version || true

# Show available devices
echo ""
echo "Available devices:"
"$FLUTTER_BIN" devices || true

echo ""
echo "Starting Flutter with Windows $BROWSER..."
echo "Host: $HOST:$PORT"
echo "Log: $LOG_FILE"
echo ""

# Run Flutter with hot reload enabled
nohup "$FLUTTER_BIN" run \
  -d "$DEVICE_ID" \
  --web-hostname "$HOST" \
  --web-port "$PORT" \
  --web-browser-flag="--remote-debugging-port=9222" \
  --web-browser-flag="--disable-web-security" \
  --web-browser-flag="--user-data-dir=/tmp/flutter-chrome-$PORT" \
  > "$LOG_FILE" 2>&1 &

WEB_PID=$!
echo "$WEB_PID" > "$PID_FILE"

# Wait and show log
sleep 4
echo "=== Log output ==="
tail -n 30 "$LOG_FILE" || true
echo ""
echo "Flutter running with $BROWSER (pid $WEB_PID)"
echo "Press 'r' in terminal to hot reload, 'R' to hot restart"
echo "To view log: tail -f $LOG_FILE"
echo "To stop: kill $WEB_PID"
