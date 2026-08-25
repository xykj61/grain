#!/bin/sh
# Census IronBeetle ep001 own-voice lesson -- presence only; never copies into rye/.
# Clean-room study of gratitude/ironbeetle ep001 structure and teach limbs.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP001_NAME=20260712-092212_ironbeetle-ep001-intro-message-parsing.md
EP001="$ROOT/$EP001_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP001"; then
  echo "IRON=present"
  echo "EP001=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP001"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP001"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Wire With No Parser' "$EP001" \
  && rg -q 'Message That Needs No Parser' "$EP001" \
  && rg -q 'checksum' "$EP001" \
  && rg -q 'cast' "$EP001"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP001"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP001"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP001=yes"
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
