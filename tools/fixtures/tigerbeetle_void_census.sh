#!/bin/sh
# Census void / !void return braces under gratitude/tigerbeetle/src.
# Clean-room study only -- prints counts; never copies into rye/.
set -eu
ROOT=gratitude/tigerbeetle
if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 1
fi
REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)
BANG=$(rg -c '\)\s*!void\s*\{' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
PLAIN=$(rg -c '\)\s*void\s*\{' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
# files that have either shape
FILES=$(rg -l '\)\s*!void\s*\{|\)\s*void\s*\{' "$ROOT/src" -g '*.zig' 2>/dev/null | wc -l | tr -d ' ')
TOTAL=$((BANG + PLAIN))
STYLE=no
test -f "$ROOT/docs/TIGER_STYLE.md" && STYLE=yes
echo "CLONE=present"
echo "REV=${REV}"
echo "files=${FILES}"
echo "bang_void=${BANG}"
echo "plain_void=${PLAIN}"
echo "total_voidish=${TOTAL}"
echo "STYLE=${STYLE}"
if test "$FILES" -ge 100 && test "$TOTAL" -ge 1000 && test "$STYLE" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
