#!/bin/sh
# tools/fixtures/reds_ledger_monotone_scan.sh — REDS row numbers accrete, never rewrite.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value · detail: prefixed · verdict= its own key · status agrees.
#
# Companion to reds_ledger_scan.sh (three fields · living-pin bound).
# This seam proves row indices are 1..N with no gaps and no duplicates —
# the mechanical half of "rows are never edited or removed."

set -eu
f="${1:-work-in-progress/REDS.md}"
[ -f "$f" ] || { echo "verdict=missing_ledger"; exit 2; }

rows=0
expect=1
fail=0
while IFS= read -r line; do
  case "$line" in
    '| '[0-9]*'|'*) : ;;
    *) continue ;;
  esac
  n=$(printf '%s' "$line" | sed -n 's/^| *\([0-9][0-9]*\) *|.*/\1/p')
  if [ -z "$n" ]; then
    echo "detail: unreadable row index -> $(printf '%s' "$line" | cut -c1-58)"
    fail=$((fail + 1))
    continue
  fi
  rows=$((rows + 1))
  if [ "$n" -ne "$expect" ]; then
    echo "detail: expected row $expect, found $n"
    fail=$((fail + 1))
  fi
  expect=$((n + 1))
done < "$f"

echo "rows=$rows"
echo "expect_next=$expect"
echo "gaps_or_dupes=$fail"
if [ "$rows" -eq 0 ]; then echo "verdict=no_rows"; exit 1; fi
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=not_monotone"
exit 1
