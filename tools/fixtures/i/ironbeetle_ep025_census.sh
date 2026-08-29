#!/bin/sh
# Census IronBeetle ep025 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP025_NAME=20260712-092212_ironbeetle-ep025-a-history-written-as-a-list-of-changes.md
EP025="$ROOT/$EP025_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP025"; then
  echo "IRON=present"
  echo "EP025=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP025"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP025"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A History Written as a List of Changes' "$EP025" \
  && rg -q 'The Changeable Nature of Persistent Persistent Data Structures' "$EP025" \
  && rg -q 'Two Meanings Folded Into One Word' "$EP025" \
  && rg -q 'The Log That Remembers Every Table It Ever Held' "$EP025" \
  && rg -qi 'manifest' "$EP025" \
  && rg -qi 'persistent' "$EP025"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP025"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP025"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP025=yes"
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
