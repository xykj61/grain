#!/bin/sh
# Census IronBeetle ep014 own-voice lesson -- presence only; never copies into rye/.
set -eu
ROOT="${1:-gratitude/ironbeetle}"
EP014_NAME=20260712-092212_ironbeetle-ep014-trust-the-primary-verify-everyone-else.md
EP014="$ROOT/$EP014_NAME"
MATKLAD=gratitude/matklad.md

if ! test -d "$ROOT"; then
  echo "IRON=ABSENT"
  echo "verdict=absent"
  exit 2
fi

if ! test -f "$EP014"; then
  echo "IRON=present"
  echo "EP014=ABSENT"
  echo "verdict=absent"
  exit 2
fi

HONORS=no
if rg -q '^## Honors$' "$EP014"; then
  HONORS=yes
fi

SOURCE=no
if rg -q '^## Source$' "$EP014"; then
  SOURCE=yes
fi

TEACH=no
if rg -q 'Trust the Primary, Verify Everyone Else' "$EP014" \
  && rg -q 'Repairing Headers' "$EP014" \
  && rg -q 'Two Ways to Receive the Same Kind of Message' "$EP014" \
  && rg -q 'repair_header' "$EP014" \
  && rg -q 'on_start_view' "$EP014" \
  && rg -q 'Who Gets Asked, and a Word Worth Retiring' "$EP014"; then
  TEACH=yes
fi

RHYME=no
if rg -q '^## Where It Rhymes With Our Own Work$' "$EP014"; then
  RHYME=yes
fi

CLEAN=no
if rg -q '^## Clean Room$' "$EP014"; then
  CLEAN=yes
fi

MATKLAD_OK=no
if test -f "$MATKLAD" \
  && rg -q 'ironbeetle/' "$MATKLAD"; then
  MATKLAD_OK=yes
fi

echo "IRON=present"
echo "EP014=yes"
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
