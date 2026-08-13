#!/bin/sh
# tools/fixtures/vols_survey_readtrue.sh — VOLS survey, the ledger read true (r4's crux).
#
#   sh tools/fixtures/vols_survey_readtrue.sh <root> <guardlist>
#
# Renders the survey ledger and cross-checks its declared totals against the independent
# measure (vols_survey_truth.sh, a grep -rl traversal classified by basename) — two tools,
# one answer. Emits readtrue=agree only when the ledger's sites, handles, and prose_gaps
# each equal the independent count; readtrue=disagree (verdict=drift) otherwise. Free of
# any hardcoded number, so it stays true as the tree grows. Uses a fixed stamp for the
# render (the counts, not the stamp, are what read true). Output convention:
# context/specs/20260729-215600_scan-seam-convention.md.
set -eu

if [ "$#" -ne 2 ]; then
  echo "detail: usage — vols_survey_readtrue.sh <root> <guardlist>"
  echo "verdict=noroot"
  exit 2
fi
root=$1
guardlist=$2
if [ ! -d "$root" ]; then echo "detail: absent root ($root)"; echo "verdict=noroot"; exit 2; fi
if [ ! -f "$guardlist" ]; then echo "detail: absent guardlist ($guardlist)"; echo "verdict=noroot"; exit 2; fi

ledger=$(sh tools/fixtures/vols_survey_render.sh "$root" "$guardlist" 20260101.000000 2>/dev/null)
l_sites=$(printf '%s\n' "$ledger" | sed -n 's/^sites //p')
l_handles=$(printf '%s\n' "$ledger" | sed -n 's/^handles //p')
l_prose=$(printf '%s\n' "$ledger" | sed -n 's/^prose_gaps //p')

truth=$(sh tools/fixtures/vols_survey_truth.sh "$root" "$guardlist" 2>/dev/null)
t_sites=$(printf '%s\n' "$truth" | sed -n 's/^truth_sites=//p')
t_handles=$(printf '%s\n' "$truth" | sed -n 's/^truth_handles=//p')
t_prose=$(printf '%s\n' "$truth" | sed -n 's/^truth_prose_gaps=//p')

echo "ledger_sites=$l_sites truth_sites=$t_sites"
echo "ledger_handles=$l_handles truth_handles=$t_handles"
echo "ledger_prose_gaps=$l_prose truth_prose_gaps=$t_prose"

if [ "$l_sites" = "$t_sites" ] && [ "$l_handles" = "$t_handles" ] && [ "$l_prose" = "$t_prose" ]; then
  echo "readtrue=agree"
  echo "verdict=ok"
  exit 0
fi
echo "detail: ledger and independent measure disagree"
echo "readtrue=disagree"
echo "verdict=drift"
exit 1
