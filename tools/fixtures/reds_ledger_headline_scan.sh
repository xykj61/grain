#!/bin/sh
# tools/fixtures/reds_ledger_headline_scan.sh -- the ledger's headline agrees with the ledger.
#
#   sh tools/fixtures/reds_ledger_headline_scan.sh <ledger.md> <measured_rows>
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Companion to reds_ledger_monotone_scan.sh, which measures the spine. This seam
# proves the headline SAYS what that measurement found. The two are a mirrored pair
# in the happy-zone sense: one side counts, the other side publishes the count, and
# a contract check on the publishing side is the only thing that can catch a headline
# drifting away from its own tool.
#
# Why it exists (REDS %127). The headline names the witness that measures it, and it
# still read 125 while that witness read 126 -- corrected by hand one lap earlier and
# stale again within the same lap, because booking a row and republishing the total are
# two acts and only one of them was guarded. REDS %110's lesson is that a recited number
# drifts; the answer here is not to recite it more carefully but to let a machine refuse
# the disagreement. A number a human republishes is a number that will eventually be
# republished wrong.
#
# Three numbers are recited about the spine, so all three are checked. The remainder is
# derived (total minus the opening census of 20) rather than counted, which is exactly
# how the headline itself says it is derived -- so the check reads the headline's own
# stated arithmetic back to it.

set -eu

opening_census=20   # the 20 rows the ledger opened with on 20260729: 6 in-tree, 14 recovered.

ledger=${1:-crux/REDS.md}
measured=${2:-}

[ -f "$ledger" ] || { echo "detail: absent ($ledger)"; echo "verdict=missing_ledger"; exit 2; }
case "$measured" in
  ''|*[!0-9]*) echo "detail: measured row count must be a number, got '$measured'"
               echo "verdict=no_measurement"; exit 2 ;;
esac

total=$(sed -n 's/^\*\*Rows: \([0-9][0-9]*\) .*/\1/p' "$ledger" | head -n 1)
remainder=$(sed -n 's/.*added under the reds-first law: \([0-9][0-9]*\)\*\*.*/\1/p' "$ledger" | head -n 1)
span=$(sed -n 's/.*Every number from 1 to \([0-9][0-9]*\) is used.*/\1/p' "$ledger" | head -n 1)

echo "measured=$measured"
echo "headline_total=${total:-absent}"
echo "headline_remainder=${remainder:-absent}"
echo "headline_span=${span:-absent}"

if [ -z "$total" ] || [ -z "$remainder" ] || [ -z "$span" ]; then
  echo "detail: the headline must recite a total, a remainder, and a span"
  echo "verdict=no_headline"
  exit 1
fi

want_remainder=$((measured - opening_census))
echo "want_remainder=$want_remainder"

fail=0
if [ "$total" -ne "$measured" ]; then
  echo "detail: headline total $total disagrees with the measured $measured"
  fail=$((fail + 1))
fi
if [ "$span" -ne "$measured" ]; then
  echo "detail: headline span 1 to $span disagrees with the measured $measured"
  fail=$((fail + 1))
fi
if [ "$remainder" -ne "$want_remainder" ]; then
  echo "detail: headline remainder $remainder disagrees with the derived $want_remainder"
  fail=$((fail + 1))
fi

echo "disagreements=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=headline_drift"
exit 1
