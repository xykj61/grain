#!/bin/sh
# Census IronBeetle ep015 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP015_NAME=20260712-092212_ironbeetle-ep015-proving-a-negative.md
EP015="$ROOT/$EP015_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP015"; then
  echo "IRON=present"
  echo "EP015=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP015"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP015"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Proving a Negative' "$EP015" \
  && rg -q 'View Change' "$EP015" \
  && rg -q 'The Deadlock Hiding in the Naive Approach' "$EP015" \
  && rg -qi 'nack' "$EP015" \
  && rg -q 'Canonical Histories and the Right to Be Stuck' "$EP015" \
  && rg -q 'do_view_change' "$EP015"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP015"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP015"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP015=yes"
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
