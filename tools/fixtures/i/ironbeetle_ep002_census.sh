#!/bin/sh
# Census IronBeetle ep002 own-voice lesson -- presence only; never copies into rye/.
# Clean-room study of gratitude/ironbeetle ep002 structure and teach limbs.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP002_NAME=20260712-092212_ironbeetle-ep002-double-entry-bookkeeping.md
EP002="$ROOT/$EP002_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP002"; then
  echo "IRON=present"
  echo "EP002=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP002"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP002"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Why Two Columns Instead of One' "$EP002" \
  && rg -q 'Double-Entry' "$EP002" \
  && rg -qi 'debit' "$EP002" \
  && rg -qi 'credit' "$EP002" \
  && rg -qi 'batch' "$EP002" \
  && rg -qi 'gateway' "$EP002" \
  && rg -q 'Money That Cannot Silently Appear' "$EP002"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP002"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP002"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP002=yes"
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
