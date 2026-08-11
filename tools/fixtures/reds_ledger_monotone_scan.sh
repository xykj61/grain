#!/bin/sh
# tools/fixtures/reds_ledger_monotone_scan.sh — REDS row numbers accrete, never rewrite.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value · detail: prefixed · verdict= its own key · status agrees.
#
# Companion to reds_ledger_scan.sh (three fields · living-pin bound).
# This seam proves row indices are 1..N with no gaps and no duplicates —
# the mechanical half of "rows are never edited or removed."
#
# Fold-aware (20260811.143500): a closed-range fold moves a contiguous PREFIX of
# rows into an archive file to keep the living pin under bound, so the living
# ledger holds only a suffix. The 1..N spine therefore spans the living pin AND its
# fold archives together. Pass every file that holds rows (the archives then the
# living pin); this scan unions their row indices and proves the UNION is 1..N with
# no gaps or dupes — so a fold never breaks the spine and a bundle still cannot
# silently rewrite a landed row number. Before this, the scan read one file and
# expected it to start at 1, so it went red the moment the first fold landed.

set -eu
if [ "$#" -eq 0 ]; then set -- work-in-progress/REDS.md; fi
for f in "$@"; do
  [ -f "$f" ] || { echo "detail: absent ($f)"; echo "verdict=missing_ledger"; exit 2; }
done

# Union every "| N |" row index across all given files, sorted numerically.
sorted=$(for f in "$@"; do sed -n 's/^| *\([0-9][0-9]*\) *|.*/\1/p' "$f"; done | sort -n)

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

echo "rows=$rows"
echo "expect_next=$expect"
echo "gaps_or_dupes=$fail"
if [ "$rows" -eq 0 ]; then echo "verdict=no_rows"; exit 1; fi
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=not_monotone"
exit 1
