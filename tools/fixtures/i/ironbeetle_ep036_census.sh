#!/bin/sh
# Census IronBeetle ep036 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP036_NAME=20260712-092212_ironbeetle-ep036-a-promise-with-a-deadline.md
EP036="$ROOT/$EP036_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP036"; then
  echo "IRON=present"
  echo "EP036=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP036"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP036"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Promise With a Deadline' "$EP036" \
  && rg -q 'A Cache That Always Hits' "$EP036" \
  && rg -q 'Two Structures, One Honest Promise' "$EP036" \
  && rg -q 'An Undo Log for a Promise That Might Be Broken' "$EP036" \
  && rg -qi 'stash' "$EP036" \
  && rg -qi 'deadline' "$EP036"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP036"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP036"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP036=yes"
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
