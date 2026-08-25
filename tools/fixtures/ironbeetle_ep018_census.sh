#!/bin/sh
# Census IronBeetle ep018 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP018_NAME=20260712-092212_ironbeetle-ep018-the-same-bug-byte-for-byte.md
EP018="$ROOT/$EP018_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP018"; then
  echo "IRON=present"
  echo "EP018=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP018"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP018"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'The Same Bug, Byte for Byte' "$EP018" \
  && rg -q 'Simulation Failure' "$EP018" \
  && rg -q 'A Bug Willing to Repeat Itself Exactly' "$EP018" \
  && rg -qi 'deterministic' "$EP018" \
  && rg -q 'Two Correct Rules Meeting in an Incorrect Place' "$EP018" \
  && rg -qi 'liveness' "$EP018"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP018"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP018"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP018=yes"
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
