#!/bin/sh
# Census IronBeetle ep004 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP004_NAME=20260712-092212_ironbeetle-ep004-refuses-to-be-sharded.md
EP004="$ROOT/$EP004_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP004"; then
  echo "IRON=present"
  echo "EP004=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP004"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP004"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Why the Ledger Refuses to Be Sharded' "$EP004" \
  && rg -q 'Two Shapes of Doing Many Things at Once' "$EP004" \
  && rg -qi 'shard' "$EP004" \
  && rg -qi 'pipelin' "$EP004" \
  && rg -q 'single thread' "$EP004" \
  && rg -q 'io_uring' "$EP004"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP004"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP004"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP004=yes"
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
