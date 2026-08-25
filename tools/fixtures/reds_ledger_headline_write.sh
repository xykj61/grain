#!/bin/sh
# tools/fixtures/reds_headline_write.sh -- the ledger's headline is written by the tool that
# measures it, rather than typed by a hand and refused afterwards.
#
# WHAT THIS IS FOR. construction/REDS.md opens with a sentence reciting three numbers about
# itself: how many rows the ledger holds, how many of those were added under the reds-first law,
# and the span every row number fills. All three are pure functions of the spine that
# reds_ledger_monotone_scan.sh already counts off disk. This writes them.
#
# WHY IT EXISTS. The class has fired three times. REDS %127 found the headline reciting 125 while
# its own named tool read 126, one lap after a hand had corrected it. REDS %141 found it one row
# behind the row that had just been written, and closed by hand again. On 20260825.180329 a lap
# booked row %225 and moved no number, so the headline read 224 against a measured 225 and the
# drift shipped in a signed commit.
#
# The ladder REDS %223 names is rule, then reading, then refusal. The rule was written in %141 --
# a row and its headline are one edit. The reading is reds_ledger_headline_scan.sh. The refusal is
# the next lap's cold roster. This is the rung past all three, and it is the right one whenever a
# number is DERIVED: a hand should not be asked to republish arithmetic it can get wrong. The
# scan beside this one said so in its own header a year of laps ago -- "a number a human
# republishes is a number that will one day be republished wrong" -- and then left the human
# republishing it.
#
#   sh tools/fixtures/reds_headline_write.sh          # report the three numbers; change nothing
#   sh tools/fixtures/reds_headline_write.sh write    # rewrite them in place
#
# LEDGER and ARCHIVE_GLOB point it at a planted ledger, which is how the control proves it.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# It writes THROUGH the original inode (`cat "$tmp" > "$f"`), so the mode the repository tracks
# survives the rewrite -- .claude/rules/exec-bit.md, where a `mv` cost thirty-nine exec bits.
#
# WHAT IT DOES NOT REACH, said plainly: it edits the headline's three numbers and nothing else.
# A row's text, a row's number, and the fold recital are the ledger's own content, and no tool
# in this tree writes those.
set -eu

MODE=${1:-check}
LEDGER=${LEDGER:-construction/REDS.md}
ARCHIVE_GLOB=${ARCHIVE_GLOB:-construction/archive/REDS-*rows-*.md}

# invariant: the 20 rows the ledger opened with on 20260729 -- 6 already written into the tree and
# 14 recovered out of chat windows. The headline states this arithmetic itself, so the constant is
# read back to it rather than invented here.
opening_census=20

[ -f "$LEDGER" ] || { echo "detail: absent ($LEDGER)"; echo "verdict=missing_ledger"; exit 2; }

# The spine spans every fold shelf and the living pin together, which is the reading the monotone
# witness takes. A glob matching nothing is passed through unexpanded by the shell, so the scan
# would be handed a literal path and refuse -- hence the explicit test.
set +f
# shellcheck disable=SC2086
shelves=$(ls $ARCHIVE_GLOB 2>/dev/null || true)
set -f
measured=$(sh tools/fixtures/reds_ledger_monotone_scan.sh $shelves "$LEDGER" 2>/dev/null | sed -n 's/^rows=//p')
set +f

case "$measured" in
  ''|*[!0-9]*) echo "detail: the spine could not be measured over $LEDGER"
               echo "verdict=no_measurement"; exit 2 ;;
esac

remainder=$((measured - opening_census))

total_now=$(sed -n 's/^\*\*Rows: \([0-9][0-9]*\) .*/\1/p' "$LEDGER" | head -n 1)
remainder_now=$(sed -n 's/.*added under the reds-first law: \([0-9][0-9]*\)\*\*.*/\1/p' "$LEDGER" | head -n 1)
span_now=$(sed -n 's/.*Every number from 1 to \([0-9][0-9]*\) is used.*/\1/p' "$LEDGER" | head -n 1)

echo "measured=$measured"
echo "want_total=$measured"
echo "want_remainder=$remainder"
echo "want_span=$measured"
echo "headline_total=${total_now:-absent}"
echo "headline_remainder=${remainder_now:-absent}"
echo "headline_span=${span_now:-absent}"

if [ -z "$total_now" ] || [ -z "$remainder_now" ] || [ -z "$span_now" ]; then
  echo "detail: the headline must already carry a total, a remainder, and a span for this to rewrite"
  echo "verdict=no_headline"
  exit 1
fi

if [ "$total_now" = "$measured" ] && [ "$remainder_now" = "$remainder" ] && [ "$span_now" = "$measured" ]; then
  echo "changed=no"
  echo "verdict=ok"
  exit 0
fi

if [ "$MODE" != write ]; then
  echo "changed=would"
  echo "detail: the headline disagrees with the measured spine -- run with 'write' to repair it"
  echo "verdict=headline_drift"
  exit 1
fi

tmp="$LEDGER.headline.tmp"
sed \
  -e "s/^\*\*Rows: [0-9][0-9]* /**Rows: $measured /" \
  -e "s/added under the reds-first law: [0-9][0-9]*\*\*/added under the reds-first law: $remainder**/" \
  -e "s/Every number from 1 to [0-9][0-9]* is used/Every number from 1 to $measured is used/" \
  "$LEDGER" > "$tmp"
cat "$tmp" > "$LEDGER"
rm -f "$tmp"

echo "changed=yes"
echo "verdict=ok"
exit 0
