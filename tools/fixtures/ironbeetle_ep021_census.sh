#!/bin/sh
# Census IronBeetle ep021 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP021_NAME=20260712-092212_ironbeetle-ep021-a-queue-with-no-memory-of-its-own.md
EP021="$ROOT/$EP021_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP021"; then
  echo "IRON=present"
  echo "EP021=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP021"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP021"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Queue With No Memory of Its Own' "$EP021" \
  && rg -q 'Grid.Write' "$EP021" \
  && rg -q 'One Substrate, Everything Built on Top' "$EP021" \
  && rg -q 'A Queue That Borrows Its Memory From Its Own Callers' "$EP021" \
  && rg -q 'Grid' "$EP021" \
  && rg -qi 'checksum' "$EP021"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP021"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP021"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP021=yes"
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
