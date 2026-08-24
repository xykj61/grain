#!/bin/sh
# tools/fixtures/rule_twin_control.sh -- prove the rule-twin meter from both sides.
#
#   sh tools/fixtures/rule_twin_control.sh
#
# WHY. A guard that cannot red guards nothing. This builds real rule directories in a throwaway
# pen and proves the transform accepts what it should and refuses what it should -- because a
# transform that is too generous reports agreement over two files saying different things, which
# is worse than no meter at all.
#
# WHAT IS PROVEN, both directions:
#
#   1 free    -- a pair identical but for Cursor frontmatter reads as agreeing
#   2 free    -- a link written `.mdc)` in the twin and `.md)` in the canonical reads as agreeing
#   3 free    -- a link written in backticks reads the same way
#   4 free    -- the closing cross-pointer, which each file aims at the other on purpose, is
#                dropped from both rather than demanded equal
#   5 free    -- a blank-line reflow reads as agreeing, so formatting is not called drift
#   6 bitten  -- one changed word in the body counts as drift
#   7 bitten  -- a whole paragraph present on one side only counts as drift
#   8 bitten  -- a stale path on the twin counts as drift, the reds-first shape
#   9 bitten  -- drift above the ceiling refuses, and the ceiling is shown from both sides
#  10 free    -- drift at exactly the ceiling passes free
#  11 bitten  -- an empty corpus reads as empty rather than clean
#  12 free    -- a Cursor rule with no Claude canonical is counted rather than ignored
#
# Run from the repository root.
set -eu

PASS=0
FAIL=0
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

check() {
  if [ "$2" = "$3" ]; then PASS=$((PASS + 1)); echo "$1 -- ok"
  else FAIL=$((FAIL + 1)); echo "$1 -- FAIL (wanted $2, got $3)"; fi
}

C="$PEN/claude"; U="$PEN/cursor"
run_scan() { RULE_TWIN_CLAUDE_DIR="$C" RULE_TWIN_CURSOR_DIR="$U" RULE_TWIN_CEILING="${1:-99}" \
  sh tools/fixtures/rule_twin_scan.sh census 2>&1 || true; }

fresh() { rm -rf "$C" "$U"; mkdir -p "$C" "$U"; }

# ---- 1..5: the transform's five honest readings ---------------------------------------
fresh
printf '# A\n\nSee [b](b.md) and `c.md`.\n\nCanonical Cursor twin: [x](x.mdc).\n' > "$C/a.md"
printf -- '---\ndescription: d\nalwaysApply: false\n---\n\n# A\n\nSee [b](b.mdc) and `c.mdc`.\n\n\nCanonical Claude twin: [x](x.md).\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_agree=1*) got=agree;; *) got=drift;; esac
check "1 free: a pair identical but for Cursor frontmatter reads as agreeing" agree "$got"
check "2 free: a link written .mdc in the twin reads as agreeing" agree "$got"
check "3 free: a link written in backticks reads the same way" agree "$got"
check "4 free: the closing cross-pointer is dropped from both rather than demanded equal" agree "$got"
check "5 free: a blank-line reflow reads as agreeing" agree "$got"

# ---- 6: one changed word is drift ------------------------------------------------------
fresh
printf '# A\n\nThe ceiling only ever falls.\n' > "$C/a.md"
printf -- '---\ndescription: d\n---\n\n# A\n\nThe ceiling only ever rises.\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_drifted=1*) got=drift;; *) got=agree;; esac
check "6 bitten: one changed word in the body counts as drift" drift "$got"

# ---- 7: a paragraph on one side only ---------------------------------------------------
fresh
printf '# A\n\nOne.\n\nTwo, which the twin has never held.\n' > "$C/a.md"
printf -- '---\ndescription: d\n---\n\n# A\n\nOne.\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_drifted=1*) got=drift;; *) got=agree;; esac
check "7 bitten: a whole paragraph present on one side only counts as drift" drift "$got"

# ---- 8: a stale path on the twin -- the reds-first shape -------------------------------
fresh
printf '# A\n\nLedger: `construction/REDS.md`.\n' > "$C/a.md"
printf -- '---\ndescription: d\n---\n\n# A\n\nLedger: `work-in-progress/REDS.md`.\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_drifted=1*) got=drift;; *) got=agree;; esac
check "8 bitten: a stale path on the twin counts as drift" drift "$got"

# ---- 9..10: the ceiling, from both sides -----------------------------------------------
fresh
i=1
while [ "$i" -le 3 ]; do
  printf '# R%s\n\nsame\n' "$i" > "$C/r$i.md"
  printf -- '---\nd: x\n---\n\n# R%s\n\ndifferent\n' "$i" > "$U/r$i.mdc"
  i=$((i + 1))
done
out=$(run_scan 2)
case "$out" in *verdict=drift_over_ceiling*) got=refused;; *) got=allowed;; esac
check "9 bitten: drift above the ceiling refuses" refused "$got"
out=$(run_scan 3)
case "$out" in *verdict=ok*) got=free;; *) got=refused;; esac
check "10 free: drift at exactly the ceiling passes free" free "$got"

# ---- 11: an empty corpus ---------------------------------------------------------------
fresh
out=$(run_scan)
case "$out" in *verdict=empty_corpus*) got=empty;; *) got=clean;; esac
check "11 bitten: an empty corpus reads as empty rather than clean" empty "$got"

# ---- 12: a Cursor rule with no Claude canonical ----------------------------------------
fresh
printf '# A\n\nsame\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nsame\n' > "$U/a.mdc"
printf -- '---\nd: x\n---\n\n# Orphan\n\nno canonical\n' > "$U/orphan.mdc"
out=$(run_scan)
case "$out" in *cursor_only=1*) got=counted;; *) got=ignored;; esac
check "12 free: a Cursor rule with no Claude canonical is counted rather than ignored" counted "$got"

echo "control_cases=$((PASS + FAIL))"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=drift"; exit 1; fi
