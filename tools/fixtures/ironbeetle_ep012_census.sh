#!/bin/sh
# Census IronBeetle ep012 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP012_NAME=20260712-092212_ironbeetle-ep012-a-ring-for-asking-a-ring-for-answering.md
EP012="$ROOT/$EP012_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP012"; then
  echo "IRON=present"
  echo "EP012=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP012"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP012"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Ring for Asking, A Ring for Answering' "$EP012" \
  && rg -q 'Run to the IO_urings' "$EP012" \
  && rg -q 'The Loop That Refuses to Wait Twice' "$EP012" \
  && rg -qi 'submission' "$EP012" \
  && rg -qi 'completion' "$EP012" \
  && rg -q 'io_uring' "$EP012"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP012"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP012"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP012=yes"
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
