#!/bin/sh
# tools/fixtures/r/rule_twin_control.sh -- prove the rule-twin meter from both sides.
#
#   sh tools/fixtures/r/rule_twin_control.sh
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
#  13 free    -- a drifted arrival raises the total and leaves the gated cohort reading alone
#  14 free    -- and the same tree passes free at a ceiling the elder absolute would have refused
#  15 free    -- a pair born outside the cohort, drifted, is reported rather than refused
#  16 bitten  -- a cohort name that is no longer a pair reads as absent rather than shrinking
#  17 bitten  -- an absent cohort roster refuses rather than reading every pair as an arrival
#  18 free    -- a link into the rules room naming each editor's own copy reads as agreeing
#  19 bitten  -- and a changed word on that same line still counts as drift
#  20 free    -- a table delimiter row written to a different width reads as agreeing
#  21 bitten  -- and a changed cell in the table below it still counts as drift
#  22 free    -- an escaped `&lt;` reads as the character it names
#  23 bitten  -- and a changed bound beside it still counts as drift
#
# Cases 18 through 23 come in pairs on purpose. A transform step that reads two spellings as one
# can hide a real disagreement, so each is planted twice -- the spelling alone, which must read
# free, and the spelling with a genuine change riding on the same line, which must still bite.
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

C="$PEN/claude"; U="$PEN/cursor"; COH="$PEN/cohort.txt"
run_scan() { RULE_TWIN_CLAUDE_DIR="$C" RULE_TWIN_CURSOR_DIR="$U" RULE_TWIN_COHORT="$COH" \
  RULE_TWIN_COHORT_CEILING="${1:-99}" \
  sh tools/fixtures/r/rule_twin_scan.sh census 2>&1 || true; }

# Every planted pair joins the pen's cohort unless a case says otherwise, so cases 1-14 read the
# gated leg. Cases 15-17 rewrite it on purpose.
fresh() { rm -rf "$C" "$U"; mkdir -p "$C" "$U"; printf 'a\nr1\nr2\nr3\n' > "$COH"; }

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
case "$out" in *verdict=cohort_over_ceiling*) got=refused;; *) got=allowed;; esac
check "9 bitten: cohort drift above the ceiling refuses" refused "$got"
out=$(run_scan 3)
case "$out" in *verdict=ok*) got=free;; *) got=refused;; esac
check "10 free: cohort drift at exactly the ceiling passes free" free "$got"

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

# ---- 13..14: growth does not enter the gated reading ------------------------------------
# This is the repair itself. The elder meter held ONE number, so a new rule pair written drifted
# raised the same figure a standing pair's regression would -- and on 20260908 it refused the tree
# for exactly that, while drift among the pairs it was seated over had fallen.
fresh
i=1
while [ "$i" -le 3 ]; do
  printf '# R%s\n\nsame\n' "$i" > "$C/r$i.md"
  printf -- '---\nd: x\n---\n\n# R%s\n\ndifferent\n' "$i" > "$U/r$i.mdc"
  i=$((i + 1))
done
printf '# N\n\none\n' > "$C/newbie.md"
printf -- '---\nd: x\n---\n\n# N\n\ntwo\n' > "$U/newbie.mdc"
out=$(run_scan 3)
case "$out" in *cohort_drifted=3*pairs_drifted=4*|*pairs_drifted=4*cohort_drifted=3*) got=apart;; *) got=fused;; esac
check "13 free: a drifted arrival raises the total and leaves the cohort reading alone" apart "$got"
case "$out" in *verdict=ok*) got=free;; *) got=refused;; esac
check "14 free: and the tree passes free at a ceiling the elder absolute would have refused" free "$got"

# ---- 15: an arrival is reported rather than gated --------------------------------------
# The elder absolute refused the tree for exactly this -- a new rule pair written drifted, over a
# ceiling set before it existed. Reconciling a pair is Keaton's word, so growth must not refuse.
fresh
printf 'a\n' > "$COH"
printf '# A\n\nsame\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nsame\n' > "$U/a.mdc"
printf '# N\n\none\n' > "$C/newbie.md"
printf -- '---\nd: x\n---\n\n# N\n\ntwo\n' > "$U/newbie.mdc"
out=$(run_scan 0)
case "$out" in *verdict=ok*) got=free;; *) got=refused;; esac
check "15 free: a pair born outside the cohort, drifted, is reported rather than refused" free "$got"
case "$out" in *arrival_drifted=1*) got=named;; *) got=silent;; esac
check "15b free: and it is named in the reading rather than passed over" named "$got"

# ---- 16: a cohort name that is no longer a pair -----------------------------------------
fresh
printf 'a\nghost\n' > "$COH"
printf '# A\n\nsame\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nsame\n' > "$U/a.mdc"
out=$(run_scan 0)
case "$out" in *cohort_missing=1*) got=reported;; *) got=silent;; esac
check "16 bitten: a cohort name that is no longer a pair reads as absent" reported "$got"

# ---- 18..23: the three transform steps added 20260910, each free and each still biting ----
# A step that reads two spellings as one is a step that can hide a real disagreement, so every
# one of the three is planted twice: once as the spelling difference alone, which must read free,
# and once with a genuine change riding on the same line, which must still bite.

fresh
printf '# A\n\nRead [kyri](.claude/rules/kyri.md) first.\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nRead [kyri](.cursor/rules/kyri.mdc) first.\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_agree=1*) got=agree;; *) got=drift;; esac
check "18 free: a link into the rules room naming each editor's own copy reads as agreeing" agree "$got"

fresh
printf '# A\n\nRead [kyri](.claude/rules/kyri.md) first.\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nRead [kyri](.cursor/rules/kyri.mdc) last.\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_drifted=1*) got=drift;; *) got=agree;; esac
check "19 bitten: and a changed word on that same line still counts as drift" drift "$got"

fresh
printf '# A\n\n| Form | Meaning |\n|------|---------|\n| kg | keep going |\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\n| Form | Meaning |\n|---|---|\n| kg | keep going |\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_agree=1*) got=agree;; *) got=drift;; esac
check "20 free: a table delimiter row written to a different width reads as agreeing" agree "$got"

fresh
printf '# A\n\n| Form | Meaning |\n|------|---------|\n| kg | keep going |\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\n| Form | Meaning |\n|---|---|\n| kg | keep waiting |\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_drifted=1*) got=drift;; *) got=agree;; esac
check "21 bitten: and a changed cell in the table below it still counts as drift" drift "$got"

fresh
printf '# A\n\nNarrow-scope when fascia < 80.\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nNarrow-scope when fascia &lt; 80.\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_agree=1*) got=agree;; *) got=drift;; esac
check "22 free: an escaped &lt; reads as the character it names" agree "$got"

fresh
printf '# A\n\nNarrow-scope when fascia < 80.\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nNarrow-scope when fascia &lt; 90.\n' > "$U/a.mdc"
out=$(run_scan)
case "$out" in *pairs_drifted=1*) got=drift;; *) got=agree;; esac
check "23 bitten: and a changed bound beside it still counts as drift" drift "$got"

# ---- 17: an absent cohort roster ---------------------------------------------------------
fresh
printf '# A\n\nsame\n' > "$C/a.md"
printf -- '---\nd: x\n---\n\n# A\n\nsame\n' > "$U/a.mdc"
rm -f "$COH"
out=$(run_scan 0)
case "$out" in *verdict=cohort_absent*) got=refused;; *) got=allowed;; esac
check "17 bitten: an absent cohort roster refuses rather than reading every pair as an arrival" refused "$got"

echo "control_cases=$((PASS + FAIL))"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=drift"; exit 1; fi
