#!/usr/bin/env sh
# two_rooms_doorway_scan_one.sh — per-file doorway verdict for native orchestrator.
set -eu
f="$1"
seating="$2"
base=$(basename "$f")
file_stamp=$(echo "$base" | sed -n 's/^\([0-9]\{8\}-[0-9]\{6\}\).*/\1/p')
if [ -z "$file_stamp" ]; then
  echo "OK   $f (no one-clock stamp — grandfathered)"
  exit 0
fi
if [ "$file_stamp" \< "$seating" ]; then
  echo "OK   $f (before seating $seating)"
  exit 0
fi
status=$(head -25 "$f" | grep '^\*\*Status:\*\*' | head -1 || true)
if [ -z "$status" ]; then
  echo "FAIL $f missing Status line (stamp $file_stamp)"
  exit 1
fi
if echo "$status" | grep -qiE 'checkable|vision|mixed|research for understanding'; then
  echo "OK   $f"
  exit 0
fi
echo "FAIL $f Status does not name a room: $status"
exit 1
