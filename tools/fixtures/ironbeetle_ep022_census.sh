#!/bin/sh
# Census IronBeetle ep022 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP022_NAME=20260712-092212_ironbeetle-ep022-a-read-that-cannot-fail.md
EP022="$ROOT/$EP022_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP022"; then
  echo "IRON=present"
  echo "EP022=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP022"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP022"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'A Read That Cannot Fail' "$EP022" \
  && rg -q 'The Disk Fails, But The Reads Succeed' "$EP022" \
  && rg -q 'Local First, Then Whichever Peer Answers' "$EP022" \
  && rg -q 'Where the Repair Actually Lives' "$EP022" \
  && rg -qi 'checksum' "$EP022" \
  && rg -qi 'repair' "$EP022"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP022"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP022"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP022=yes"
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
