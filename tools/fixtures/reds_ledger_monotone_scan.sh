#!/bin/sh
# tools/fixtures/reds_ledger_monotone_scan.sh -- REDS row numbers accrete, never rewrite.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Companion to reds_ledger_scan.sh (three fields - living-pin bound).
# This seam proves row indices are 1..N with no gaps and no duplicates --
# the mechanical half of "rows are never edited or removed."
#
# Fold-aware (20260811.143500): a closed-range fold moves a contiguous PREFIX of
# rows into an archive file to keep the living pin under bound, so the living
# ledger holds only a suffix. The 1..N spine therefore spans the living pin AND its
# fold archives together. Pass every file that holds rows (the archives then the
# living pin); this scan unions their row indices and proves the UNION is 1..N with
# no gaps or dupes -- so a fold never breaks the spine and a bundle still cannot
# silently rewrite a landed row number. Before this, the scan read one file and
# expected it to start at 1, so it went red the moment the first fold landed.
#
# TWO ROW SHAPES (20260820.232126, REDS %102). The ledger grew a second shape and
# this scan was never taught it. Elder rows are table lines opening on a digit cell;
# every row from %81 forward is prose -- a bold `**REDS %N ...**` opening followed by
# the three fields in italics. Reading only the table shape, this scan could see 73
# of the 101 rows that exist, and it answered `verdict=ok` over that partial spine
# because the witness above it happened to pass only the three archives whose rows
# were all table-shaped. A count that cannot see what it measures is a guess wearing
# a measurement's clothes -- REDS %97's own lesson, which repaired the sibling scan
# beside this one and left this one exactly as it was. Both shapes are unioned now,
# so the spine is proven over every row the ledger actually holds.

set -eu
if [ "$#" -eq 0 ]; then set -- crux/REDS.md; fi
for f in "$@"; do
  [ -f "$f" ] || { echo "detail: absent ($f)"; echo "verdict=missing_ledger"; exit 2; }
done

# Union every "| N |" row index across all given files, sorted numerically.
# Both shapes: the elder table line opening on a digit cell, and the prose row opening
# on a bold `**REDS %N` or `**REDS #N` -- the living ledger writes the latter and wrote
# the former, so the spine spans both.
mentions=$(for f in "$@"; do
  sed -n 's/^| *\([0-9][0-9]*\) *|.*/\1/p' "$f"
  sed -n 's/^\*\*REDS [%#]\([0-9][0-9]*\).*/\1/p' "$f"
done | sort -n)

# The spine is the DISTINCT set of row numbers, because the ledger honestly names one
# row more than once: a full row is written when the red is found, and a closure note
# written later speaks ABOUT that row rather than opening a new one, keeping its number
# (REDS %97 drew exactly this distinction in the sibling scan). Counting mentions would
# read every closure note as a duplicate and refuse a ledger that is perfectly whole --
# a gate that reds on valid input, which REDS %100 named as its own kind of fault. Both
# counts are printed, so the gap between them stays visible rather than folded away.
n_mentions=$(printf '%s\n' "$mentions" | grep -c '[0-9]' || true)
sorted=$(printf '%s\n' "$mentions" | sort -n -u)

rows=0
expect=1
fail=0
for n in $sorted; do
  rows=$((rows + 1))
  if [ "$n" -ne "$expect" ]; then
    echo "detail: expected row $expect, found $n"
    fail=$((fail + 1))
  fi
  expect=$((n + 1))
done

echo "mentions=$n_mentions"
echo "rows=$rows"
echo "expect_next=$expect"
echo "gaps_or_dupes=$fail"
if [ "$rows" -eq 0 ]; then echo "verdict=no_rows"; exit 1; fi
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=not_monotone"
exit 1
