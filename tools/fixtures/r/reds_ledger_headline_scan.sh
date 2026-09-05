#!/bin/sh
# tools/fixtures/r/reds_ledger_headline_scan.sh -- the ledger's headline agrees with the ledger.
#
#   sh tools/fixtures/r/reds_ledger_headline_scan.sh <ledger.md> <measured_rows>
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
#
# How many times, as well as what (REDS %420). Each of the three numbers is lifted with
# `head -n 1`, so a second copy of the census line is invisible to the reading by
# construction -- and one stood in `construction/REDS.md` at lines 38 and 39, byte
# identical, through two commits. A rebase found it, because a hand had to read the page
# line by line to place a renumbered row; nothing was looking for it. So each extraction
# now reports how many lines answered it, and more than one refuses: a page that states
# its own total twice has no single total, and `head -n 1` would pick a winner in silence.
# The sibling reading in reds_ledger_monotone_scan.sh counts ROW headlines sharing one
# number, which is a different question -- this one counts the CENSUS line itself.

set -eu

opening_census=20   # the 20 rows the ledger opened with on 20260729: 6 in-tree, 14 recovered.

ledger=${1:-construction/REDS.md}
measured=${2:-}

[ -f "$ledger" ] || { echo "detail: absent ($ledger)"; echo "verdict=missing_ledger"; exit 2; }
case "$measured" in
  ''|*[!0-9]*) echo "detail: measured row count must be a number, got '$measured'"
               echo "verdict=no_measurement"; exit 2 ;;
esac

totals=$(sed -n 's/^\*\*Rows: \([0-9][0-9]*\) .*/\1/p' "$ledger")
remainders=$(sed -n 's/.*added under the reds-first law: \([0-9][0-9]*\)\*\*.*/\1/p' "$ledger")
spans=$(sed -n 's/.*Every number from 1 to \([0-9][0-9]*\) is used.*/\1/p' "$ledger")

# Count what each extraction answered before taking its first line, so the cardinality
# reading measures exactly the lines the check below consumes rather than a pattern
# beside them. An empty extraction must read 0 rather than the 1 a bare `wc -l` on an
# empty string would report, which is why each count is guarded on emptiness.
count_lines() { if [ -z "$1" ]; then echo 0; else printf '%s\n' "$1" | wc -l | tr -d ' \t'; fi; }
total_lines=$(count_lines "$totals")
remainder_lines=$(count_lines "$remainders")
span_lines=$(count_lines "$spans")

total=$(printf '%s' "$totals" | head -n 1)
remainder=$(printf '%s' "$remainders" | head -n 1)
span=$(printf '%s' "$spans" | head -n 1)

echo "measured=$measured"
echo "headline_total=${total:-absent}"
echo "headline_remainder=${remainder:-absent}"
echo "headline_span=${span:-absent}"
echo "headline_total_lines=$total_lines"
echo "headline_remainder_lines=$remainder_lines"
echo "headline_span_lines=$span_lines"

if [ -z "$total" ] || [ -z "$remainder" ] || [ -z "$span" ]; then
  echo "detail: the headline must recite a total, a remainder, and a span"
  echo "verdict=no_headline"
  exit 1
fi

# The cardinality gate stands ahead of the arithmetic, because a page stating its total
# twice has no one total for the arithmetic to be about, and the drift check reads only
# the first line either way.
dup=0
if [ "$total_lines" -gt 1 ]; then
  echo "detail: the census total stands $total_lines times, and only the first is read"
  dup=$((dup + 1))
fi
if [ "$remainder_lines" -gt 1 ]; then
  echo "detail: the census remainder stands $remainder_lines times, and only the first is read"
  dup=$((dup + 1))
fi
if [ "$span_lines" -gt 1 ]; then
  echo "detail: the census span stands $span_lines times, and only the first is read"
  dup=$((dup + 1))
fi
echo "duplicate_census_lines=$dup"
if [ "$dup" -ne 0 ]; then
  echo "detail: a ledger states its own census once"
  echo "verdict=duplicate_census"
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
