#!/bin/sh
# Census amortize-by-batching law on held TigerStyle / TAME / clone / Grain metal.
# Clean-room study only -- prints presence; never copies into rye/.
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

GUIDE_BATCH=no
if rg -q 'Amortize network, disk, memory and CPU costs by batching accesses' "$GUIDE" \
  && rg -q 'through the use of batching' "$GUIDE"; then
  GUIDE_BATCH=yes
fi

GUIDE_SPRINTER=no
if rg -q 'Let the CPU be a sprinter' "$GUIDE" \
  && rg -q 'This comes back to batching' "$GUIDE"; then
  GUIDE_SPRINTER=yes
fi

TAME_BATCH=no
if rg -q 'Amortize costs by batching' "$TAME" \
  && rg -q 'drawn with batching' "$TAME"; then
  TAME_BATCH=yes
fi

TAME_SPRINTER=no
if rg -q 'Let the CPU be a sprinter' "$TAME" \
  && rg -q 'brings us back to batching' "$TAME"; then
  TAME_SPRINTER=yes
fi

STYLE=no
if test -f "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Amortize network, disk, memory and CPU costs by batching accesses' "$ROOT/docs/TIGER_STYLE.md" \
  && rg -q 'Let the CPU be a sprinter' "$ROOT/docs/TIGER_STYLE.md"; then
  STYLE=yes
fi

GRAIN_BATCH=no
if test -f mantra/resin_batch.rye \
  && rg -q 'max_batch_entries' mantra/resin_batch.rye \
  && rg -q 'max_batch_bytes' mantra/resin_batch.rye; then
  GRAIN_BATCH=yes
fi

echo "CLONE=present"
echo "REV=${REV}"
echo "GUIDE_BATCH=${GUIDE_BATCH}"
echo "GUIDE_SPRINTER=${GUIDE_SPRINTER}"
echo "TAME_BATCH=${TAME_BATCH}"
echo "TAME_SPRINTER=${TAME_SPRINTER}"
echo "STYLE=${STYLE}"
echo "GRAIN_BATCH=${GRAIN_BATCH}"

if test "$GUIDE_BATCH" = yes \
  && test "$GUIDE_SPRINTER" = yes \
  && test "$TAME_BATCH" = yes \
  && test "$TAME_SPRINTER" = yes \
  && test "$STYLE" = yes \
  && test "$GRAIN_BATCH" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
