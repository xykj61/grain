#!/bin/sh
# Census IronBeetle ep020 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP020_NAME=20260712-092212_ironbeetle-ep020-a-change-that-never-touches-what-came-before.md
EP020="$ROOT/$EP020_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP020"; then
  echo "IRON=present"
  echo "EP020=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP020"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP020"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Change That Never Touches What Came Before' "$EP020" \
  && rg -q 'Log-Structured Merge Tree' "$EP020" \
  && rg -q 'Why One Table Was Never Going to Be Enough' "$EP020" \
  && rg -q 'Keeping the Stack from Becoming a Line' "$EP020" \
  && rg -q 'Manifest' "$EP020" \
  && rg -qi 'compaction' "$EP020"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP020"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP020"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP020=yes"
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
