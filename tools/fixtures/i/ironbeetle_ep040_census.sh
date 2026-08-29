#!/bin/sh
# Census IronBeetle ep040 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP040_NAME=20260712-092212_ironbeetle-ep040-three-stages-offset-by-one.md
EP040="$ROOT/$EP040_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP040"; then
  echo "IRON=present"
  echo "EP040=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP040"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP040"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Three Stages, Offset By One' "$EP040" \
  && rg -q 'Compaction Pipeline' "$EP040" \
  && rg -q 'A Free List Shared By Everyone, Three Slots for Each' "$EP040" \
  && rg -q 'Two Clocks Inside One Round' "$EP040" \
  && rg -qi 'pipeline' "$EP040" \
  && rg -qi 'beat' "$EP040"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP040"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP040"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP040=yes"
echo "HONORS=${HONORS}"
echo "SOURCE=${SOURCE}"
echo "TEACH=${TEACH}"
echo "RHYME=${RHYME}"
echo "CLEAN=${CLEAN}"
echo "MATKLAD_OK=${MATKLAD_OK}"

if test "$HONORS" = yes \
  && test "$SOURCE" = yes \
  && test "$TEACH" = yes \
  && test "$RHYME" = yes \
  && test "$CLEAN" = yes \
  && test "$MATKLAD_OK" = yes; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=thin"
exit 1
