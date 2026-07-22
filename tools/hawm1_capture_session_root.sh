#!/usr/bin/env bash
# hawm1_capture_session_root.sh — pull 64-hex session root from HAWM1/Sala stdout.
# Reads stdin; writes tools/.cache/hawm0/hawm1-session-root.txt (no trailing newline).
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$REPO_ROOT/tools/.cache/hawm0/hawm1-session-root.txt"
mkdir -p "$(dirname "$OUT")"
hex="$(sed -n 's/.*session root -- \([0-9a-f]\{64\}\).*/\1/p' | head -n1)"
if [[ ! "$hex" =~ ^[0-9a-f]{64}$ ]]; then
  echo "RED: no 64-hex session root on stdin" >&2
  exit 1
fi
printf '%s' "$hex" >"$OUT"
echo "hawm1: wrote session_root $hex → $OUT"
