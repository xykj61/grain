#!/bin/sh
# Shed census scan -- orphan floor behind planted C1/C2 controls.
# Exit 0 only when both controls honor and the census is released.
# No backtick characters in patterns.
#
#   sh tools/fixtures/s/shed_census_scan.sh           # living green
#   sh tools/fixtures/s/shed_census_scan.sh prove-red  # must exit 1 (greedy index)
#
# Law: no duty reports a total until its planted control reads correctly.
# A planted control only becomes a control once it is tracked (git ls-files).
# Self-mention counts; the orphan count is a FLOOR (errs toward keeping).
set -eu

MODE=${1:-}
CITER=tools/fixtures/s/shed_census_citer.md
# Cited control path is allowed as a literal (C1 must see it named).
CITED=tools/fixtures/2/20260731-124500_shed_census_cited_control.md
# Orphan control path is assembled from fragments so this scan file never
# contains the contiguous path string (C2 planted negative).
#
# AND THAT ASSEMBLY IS WHY THIS PATH WENT STALE AND ITS NEIGHBOR DID NOT (row `20260908.020050`).
# `tools/` folded into letter rooms on `20260823.144100`, and `tools/t/tool_path_repoint.rish`
# carried every literal path across. `CITED` above is a literal, so it was repointed and reads
# `tools/fixtures/2/` today; this one is four variables, so the repointer never saw it and the
# directory stayed `tools/fixtures`. One file, one fold, two paths, and the only difference is
# whether the string was contiguous -- which is the exact property the assembly exists to destroy.
# The scan then answered `CONTROL=untracked` about a file that is tracked, and reddened
# `shed_census`, `instrument_suite`, and the seven equinox leaves above it for sixteen days.
#
# A repointer reads text, so a path a program computes is a path no repointer can follow. Where a
# fixture must hide a literal, the fold-fragile part is the DIRECTORY, and it is named here on its
# own line so a reader repairing a fold finds it by eye.
ORPHAN_DIR=tools/fixtures/2
ORPHAN_STAMP=20260731-124500
ORPHAN_STEM=shed_census_orphan_control
ORPHAN="${ORPHAN_DIR}/${ORPHAN_STAMP}_${ORPHAN_STEM}.md"

CONTROL_SCAN=tools/fixtures/c/census_control_scan.sh

# --- commence law: census control before totals ---
if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  echo "detail=census_control_missing"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | sed 's/^/gate_/'
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  echo "detail=control_must_read_before_shed_totals"
  exit 1
}
echo "control_gate=honored"

# --- planted controls must be tracked ---
for p in "$CITER" "$CITED" "$ORPHAN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "CONTROL=untracked"
    echo "verdict=misread"
    echo "detail=planted_control_must_be_tracked"
    echo "detail_path=$p"
    exit 1
  }
done
echo "tracked_controls=honored"

# prove-red: pretend the orphan is referenced by forcing a greedy read --
# require orphan to be ORPHAN but inject a false REFERENCED claim.
if test "$MODE" = "prove-red"; then
  echo "C1=REFERENCED"
  echo "C2=REFERENCED"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=RED_C2-orphan"
  echo "detail=index_is_greedy"
  echo "census=withheld"
  exit 1
fi

# --- census: dated paths - mention floor - C1/C2 (shared dated_classify) ---
# The classifier now speaks Rishi (Python -> Rishi molt 20260809): Rishi owns the
# interface, a POSIX-sh rg seam holds the regex and mention floor. Output matches the
# elder Python byte-for-byte; python3 is not on this pier's PATH.
REPORT=$(rishi/bin/rishi run tools/fixtures/d/dated_classify.rish shed "$CITED" "$ORPHAN" "$CITER")

echo "$REPORT"

echo "$REPORT" | rg -q '^verdict=ok$' || {
  echo "census=withheld"
  exit 1
}
echo "$REPORT" | rg -q '^controls_honored=2$' || {
  echo "census=withheld"
  exit 1
}

echo "shed_census=ok"
exit 0
