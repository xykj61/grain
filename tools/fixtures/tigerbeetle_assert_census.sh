#!/bin/sh
# Census assert / maybe / constants.verify under gratitude/tigerbeetle/src.
# Clean-room study only -- prints counts; never copies into rye/.
set -eu
ROOT=gratitude/tigerbeetle
if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 1
fi
REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)
ASSERT=$(rg -c '\bassert\s*\(' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
MAYBE=$(rg -c '\bmaybe\s*\(' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
VERIFY=$(rg -c 'constants\.verify' "$ROOT/src" -g '*.zig' 2>/dev/null | awk -F: '{s+=$2} END{print s+0}')
FILES_ASSERT=$(rg -l '\bassert\s*\(' "$ROOT/src" -g '*.zig' 2>/dev/null | wc -l | tr -d ' ')
STYLE=no
test -f "$ROOT/docs/TIGER_STYLE.md" && STYLE=yes
MAYBE_DEF=no
if rg -q 'pub fn maybe\(ok: bool\) void' "$ROOT/src/stdx/stdx.zig" 2>/dev/null; then
  MAYBE_DEF=yes
fi
GUIDE_DENSITY=no
if rg -q 'assertion density of the code must average a minimum of two' gratitude/TIGER_STYLE.md 2>/dev/null; then
  GUIDE_DENSITY=yes
fi
echo "CLONE=present"
echo "REV=${REV}"
echo "assert_calls=${ASSERT}"
echo "maybe_calls=${MAYBE}"
echo "constants_verify=${VERIFY}"
echo "files_assert=${FILES_ASSERT}"
echo "STYLE=${STYLE}"
echo "MAYBE_DEF=${MAYBE_DEF}"
echo "GUIDE_DENSITY=${GUIDE_DENSITY}"
if test "$ASSERT" -ge 2000 \
  && test "$MAYBE" -ge 100 \
  && test "$VERIFY" -ge 20 \
  && test "$FILES_ASSERT" -ge 100 \
  && test "$STYLE" = yes \
  && test "$MAYBE_DEF" = yes \
  && test "$GUIDE_DENSITY" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
