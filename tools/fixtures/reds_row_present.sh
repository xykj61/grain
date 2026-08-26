#!/bin/sh
# tools/fixtures/reds_row_present.sh -- is REDS row N recorded anywhere in the ledger's spine?
#
# WHY THIS FILE EXISTS. The REDS ledger folds. Its living pin construction/REDS.md holds the rows
# still flat, and every elder row moves onto a shelf under construction/archive/, so the ledger's
# spine is the pin PLUS its archives rather than the pin alone. Seventeen season scans grep the
# living pin for a numbered elder row -- `rg -q '^| 42 |' "$REDS"` -- and every one of them began
# refusing on the lap that row folded, in silence, because nothing in the tree ran them
# (REDS %231). A fold repoints documents and leaves guards standing, since a guard's citation is
# code rather than a link.
#
# So the question moves here, once, and the callers ask it instead of spelling it. Row 42 is a fact
# the ledger holds forever; WHICH FILE holds it is a detail that changes every time the pin folds.
#
# WHAT IT READS. The same file set and the same two row shapes as the sibling
# tools/fixtures/reds_ledger_monotone_scan.sh: the elder table line opening on a digit cell, and
# the prose row opening on a bold `**REDS %N` or `**REDS #N`. The living ledger writes the second
# and wrote the first, so the spine spans both. That the two readings agree is proven on metal by
# tools/r/reds_row_present_witness.rish rather than promised in this comment -- it asks this script
# for every row the monotone scan counts, and for the one past the end.
#
# USAGE
#   sh tools/fixtures/reds_row_present.sh 42        # exit 0 when the spine holds row 42
#   sh tools/fixtures/reds_row_present.sh 42 --say  # and print where it was found
#   REDS_SPINE_GLOB=... sh tools/fixtures/reds_row_present.sh 42   # for a control's pen, honored
#                                                                  # by tools/fixtures/reds_spine_files.sh
#
# Exit 0 present - 1 absent - 2 misuse. A misuse exits DIFFERENTLY from an absence, because a
# caller reading "absent" from a typo would repair the ledger for a fault the ledger never had.
set -eu

N=${1:-}
SAY=${2:-}

case "$N" in
  '' ) echo "verdict=misuse detail=want_row_number"; exit 2 ;;
  *[!0-9]* ) echo "verdict=misuse detail=not_a_number row=${N}"; exit 2 ;;
esac
if [ "$N" -lt 1 ]; then echo "verdict=misuse detail=row_below_one row=${N}"; exit 2; fi

# The spine's file set is spelled ONCE, in tools/fixtures/reds_spine_files.sh, and both readings
# ask that script for it -- a set spelled twice is a set two files may come to disagree about.
SPINE=$(sh tools/fixtures/reds_spine_files.sh) || {
  echo "verdict=misuse detail=no_spine_files"
  exit 2
}

found=
for f in $SPINE; do
  if sed -n 's/^| *\([0-9][0-9]*\) *|.*/\1/p; s/^\*\*REDS [%#]\([0-9][0-9]*\).*/\1/p' "$f" \
     | grep -qx "$N"; then
    found=$f
    break
  fi
done

if [ -z "$found" ]; then
  # Distinguish "the spine holds no row at all" from "the spine holds rows, and not this one".
  # A scan that reads a real set and answers zero on its own blindness is REDS %97's shape.
  any=$(for f in $SPINE; do
    sed -n 's/^| *\([0-9][0-9]*\) *|.*/\1/p; s/^\*\*REDS [%#]\([0-9][0-9]*\).*/\1/p' "$f"
  done | grep -c '[0-9]' || true)
  if [ "${any:-0}" -eq 0 ]; then
    echo "verdict=misuse detail=no_spine_read"
    exit 2
  fi
  echo "verdict=absent row=${N}"
  exit 1
fi

if [ "$SAY" = "--say" ]; then
  echo "verdict=present row=${N} file=${found}"
fi
exit 0
