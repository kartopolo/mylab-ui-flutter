#!/usr/bin/env bash
set -euo pipefail

# Helper to standardize how we pass runtime config to Flutter.
# Usage:
#   ./scripts/print-dart-define.sh http://localhost:18080

API_BASE_URL="${1:-http://localhost:18080}"

echo "--dart-define=API_BASE_URL=${API_BASE_URL}"
