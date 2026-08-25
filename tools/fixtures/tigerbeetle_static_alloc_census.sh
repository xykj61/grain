#!/bin/sh
# Census static-allocation law on held TigerStyle / TAME / TigerBeetle clone.
# Clean-room study only -- prints presence and counts; never copies into rye/.
set -eu
ROOT="${1:-gratitude/tigerbeetle}"
GUIDE=gratitude/TIGER_STYLE.md
TAME=external-research/TAME_GUIDANCE.md

if ! test -d "$ROOT/src"; then
  echo "CLONE=ABSENT"
  echo "verdict=absent"
  exit 2
fi

REV=$(git -C "$ROOT" rev-parse --short=10 HEAD 2>/dev/null || echo unknown)

GUIDE_STATIC=no
if rg -q 'statically allocated' "$GUIDE" \
  && rg -q 'dynamically allocated' "$GUIDE" \
  && rg -q 'after initialization' "$GUIDE"; then
  GUIDE_STATIC=yes
fi

GUIDE_LIMIT=no
if rg -q 'Put a limit on everything' "$GUIDE" \
  && rg -q 'fixed upper bound' "$GUIDE"; then
  GUIDE_LIMIT=yes
fi

TAME_STATIC=no
if rg -q 'Allocate all memory at startup' "$TAME" \
  && rg -q 'After initialization, Rye programs allocate nothing dynamically' "$TAME"; then
  TAME_STATIC=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'statically allocated' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

STATIC_MENTIONS=$(rg -c 'static.?alloc|statically allocated|no.?alloc' "$ROOT/src" -g '*.zig' -i 2>/dev/null \
  | awk -F: '{s+=$2} END{print s+0}')
ALLOCATOR_WORD=$(rg -c '\ballocator\b' "$ROOT/src" -g '*.zig' 2>/dev/null \
  | awk -F: '{s+=$2} END{print s+0}')
INIT_ALLOC_FILES=$(rg -l 'fn init\([^)]*Allocator' "$ROOT/src" -g '*.zig' 2>/dev/null | wc -l | tr -d ' ')
FIXED_BUF=$(rg -c 'FixedBufferAllocator' "$ROOT/src" -g '*.zig' 2>/dev/null \
  | awk -F: '{s+=$2} END{print s+0}')

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_STATIC=${GUIDE_STATIC}"
echo "GUIDE_LIMIT=${GUIDE_LIMIT}"
echo "TAME_STATIC=${TAME_STATIC}"
echo "STYLE=${STYLE}"
echo "static_mentions=${STATIC_MENTIONS}"
echo "allocator_word=${ALLOCATOR_WORD}"
echo "init_allocator_files=${INIT_ALLOC_FILES}"
echo "fixed_buffer_allocator=${FIXED_BUF}"

if test "$GUIDE_STATIC" = yes \
  && test "$GUIDE_LIMIT" = yes \
  && test "$TAME_STATIC" = yes \
  && test "$STYLE" = yes \
  && test "$STATIC_MENTIONS" -ge 10 \
  && test "$ALLOCATOR_WORD" -ge 500 \
  && test "$INIT_ALLOC_FILES" -ge 20; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
