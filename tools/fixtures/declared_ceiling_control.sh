#!/bin/sh
# tools/fixtures/declared_ceiling_control.sh -- prove the declared-ceiling meter from both sides.
#
#   sh tools/fixtures/declared_ceiling_control.sh
#
# WHY. A guard that cannot red guards nothing, and a refusal proven only in the passing direction
# cannot be told apart from a bypass. So this builds real pages in a throwaway pen and checks the
# verdict STRING rather than only the exit code -- a scan that exits 1 for the wrong reason has
# not proven the reading anyone cared about.
#
# WHAT IS PROVEN, both directions:
#
#   1 free    -- a page under its declared ceiling passes
#   2 free    -- a page at exactly its ceiling passes, or it is not a ceiling
#   3 bitten  -- a page one line over its ceiling refuses, and the refusal names the page
#   4 bitten  -- a declaration written with the single glyph reads as unreadable
#   5 bitten  -- a `Ceiling:` header carrying no number reads as unreadable
#   6 free    -- a page declaring nothing is not counted at all
#   7 free    -- dated testimony over its own declared ceiling passes free, since testimony keeps
#                every word it wrote
#   8 bitten  -- an empty corpus reads as empty rather than clean
#   9 free    -- the word `Ceiling:` mid-prose is not read as a declaration, since the pattern is
#                anchored to the start of a line
#  10 free    -- a bound in the H1 title is counted as the third reading rather than ignored
#  11 free    -- the title-grade form at exactly its ceiling passes
#  12 bitten  -- the title-grade form spreading past its ceiling refuses
#  13 free    -- an over-ceiling page and a holding page in one pen still refuse for the right
#                reason, so one honest page cannot mask a drifted one
#
# Read-only toward the tree: the pen is a temporary directory, and DECLARED_CEILING_ROOT keeps
# the scan inside it. Run from the repository root.
set -eu

PASS=0
FAIL=0
PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

check() {
  if [ "$2" = "$3" ]; then PASS=$((PASS + 1)); echo "$1 -- ok"
  else FAIL=$((FAIL + 1)); echo "$1 -- FAIL (wanted $2, got $3)"; fi
}

D="$PEN/pages"
run_scan() {
  DECLARED_CEILING_ROOT="$D" DECLARED_CEILING_GRADE_CEILING="${1:-1}" \
    sh tools/fixtures/declared_ceiling_scan.sh census 2>&1 || true
}
verdict() { printf '%s\n' "$1" | sed -n 's/^verdict=//p' | head -1; }
field() { printf '%s\n' "$2" | sed -n "s/^$1=//p" | head -1; }

fresh() { rm -rf "$D"; mkdir -p "$D"; }

# A page of exactly $2 lines declaring a ceiling of $3, written to $1.
page() {
  {
    echo "# A page"
    echo "**Ceiling:** <=$3 lines"
    i=2
    while [ "$i" -lt "$2" ]; do echo "body line $i"; i=$((i + 1)); done
  } > "$1"
}

# ---- 1..3: the ceiling, shown from both sides ------------------------------------------
fresh
page "$D/under.md" 10 40
out=$(run_scan)
check "1 free: a page under its declared ceiling passes" "ok" "$(verdict "$out")"

fresh
page "$D/exact.md" 40 40
out=$(run_scan)
check "2 free: a page at exactly its ceiling passes free" "ok" "$(verdict "$out")"

fresh
page "$D/over.md" 41 40
out=$(run_scan)
check "3 bitten: a page one line over its ceiling refuses" "over_declared_ceiling" "$(verdict "$out")"
named=$(printf '%s\n' "$out" | grep -c 'over.md stands above the ceiling it declares' || true)
check "3 bitten: the refusal names the page that drifted" "1" "$named"

# ---- 4..5: a declaration a tool cannot read is the same as none ------------------------
fresh
printf '# A page\n**Ceiling:** \342\211\24440 lines\nbody\n' > "$D/glyph.md"
out=$(run_scan)
check "4 bitten: the single-glyph form reads as unreadable" "unreadable_declaration" "$(verdict "$out")"

fresh
printf '# A page\n**Ceiling:** short, and getting shorter\nbody\n' > "$D/wordy.md"
out=$(run_scan)
check "5 bitten: a header carrying no number reads as unreadable" "unreadable_declaration" "$(verdict "$out")"

# ---- 6: silence is not a declaration --------------------------------------------------
fresh
page "$D/holds.md" 10 40
printf '# Another page\n\nA long page that declares nothing at all.\n' > "$D/quiet.md"
i=0; while [ "$i" -lt 500 ]; do echo "filler" >> "$D/quiet.md"; i=$((i + 1)); done
out=$(run_scan)
check "6 free: a page declaring nothing is not counted" "ok" "$(verdict "$out")"
check "6 free: the corpus holds only the declaring page" "1" "$(field pages_declaring "$out")"

# ---- 7: dated testimony keeps every word it wrote --------------------------------------
fresh
page "$D/holds.md" 10 40
page "$D/20260812-171050_a-dated-note.md" 900 40
page "$D/20260812-171050.md" 900 40
out=$(run_scan)
check "7 free: dated testimony over its own ceiling passes free" "ok" "$(verdict "$out")"
check "7 free: testimony is not counted among the declarations" "1" "$(field pages_declaring "$out")"

# ---- 8: a meter over nothing must say so ----------------------------------------------
fresh
printf '# Nothing declared here\n\nbody\n' > "$D/quiet.md"
out=$(run_scan)
check "8 bitten: an empty corpus reads as empty rather than clean" "empty_corpus" "$(verdict "$out")"

# ---- 9: the pattern is anchored --------------------------------------------------------
fresh
page "$D/holds.md" 10 40
printf '# A page\n\nThe **Ceiling:** <=1 lines idea is discussed here in prose.\nbody\nbody\n' > "$D/prose.md"
out=$(run_scan)
check "9 free: a Ceiling word mid-prose is not read as a declaration" "ok" "$(verdict "$out")"
check "9 free: the prose page is not counted" "1" "$(field pages_declaring "$out")"

# ---- 10..12: the third reading, and its ceiling from both sides ------------------------
fresh
page "$D/holds.md" 10 40
printf '# Title page -- guide - <=80 - a ladder\nbody\nbody\n' > "$D/titled.md"
out=$(run_scan 1)
check "10 free: a bound in the H1 title is counted rather than ignored" "1" "$(field pages_grade_only "$out")"
check "11 free: the title-grade form at exactly its ceiling passes" "ok" "$(verdict "$out")"

printf '# Second title -- guide - <=80 - another ladder\nbody\n' > "$D/titled2.md"
out=$(run_scan 1)
check "12 bitten: the title-grade form spreading past its ceiling refuses" "grade_form_spread" "$(verdict "$out")"
check "12 bitten: both title pages are counted" "2" "$(field pages_grade_only "$out")"

# ---- 13: one honest page cannot mask a drifted one ------------------------------------
fresh
page "$D/holds.md" 10 40
page "$D/drifted.md" 99 40
out=$(run_scan)
check "13 free: a holding page beside a drifted one still refuses for the right reason" "over_declared_ceiling" "$(verdict "$out")"
check "13 free: the holding page is still counted as holding" "1" "$(field pages_holding "$out")"

echo ""
echo "control_pass=$PASS"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=fail"; exit 1; fi
