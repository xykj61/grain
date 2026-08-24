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
# AND THE BYTE-BOUND READING, added `20260824.130807`, the same shape one unit over:
#
#  14 free    -- a pin under its declared byte bound passes
#  15 bitten  -- a pin over its declared byte bound counts, and refuses once past the ceiling
#  16 free    -- the refusal names the pin and both numbers
#  17 free    -- a `Bound:` header naming no measurable limit is counted as prose, never as a fault
#  18 bitten  -- the prose form spreading past its ceiling refuses
#  19 bitten  -- a pin spelling a number the seated law does not is gated at zero
#  20 free    -- a corpus of byte declarations alone is a corpus, rather than empty
#  21 free    -- dated testimony carrying a `Bound:` header passes free and is not counted
#  22 free    -- the law's number is read from the spec rather than assumed
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
  DECLARED_BOUND_OVER_CEILING="${2:-1}" DECLARED_BOUND_PROSE_CEILING="${3:-2}" \
    sh tools/fixtures/declared_ceiling_scan.sh census 2>&1 || true
}

# A pin of $2 bytes declaring the seated byte bound, written to $1. The optional $3 spells a
# different number, which is the drift reading.
pin() {
  {
    echo "# A living pin"
    if [ -n "${3:-}" ]; then
      echo "**Bound:** under \`living_pin_max_bytes\` ($3)"
    else
      echo "**Bound:** under \`living_pin_max_bytes\`"
    fi
  } > "$1"
  while [ "$(wc -c < "$1" | tr -d ' ')" -lt "$2" ]; do echo "filler filler filler filler" >> "$1"; done
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

# ---- 14..16: the byte bound, shown from both sides -------------------------------------
fresh
pin "$D/small.md" 400
out=$(run_scan)
check "14 free: a pin under its declared byte bound passes" "ok" "$(verdict "$out")"
check "14 free: it is counted as holding" "1" "$(field bounds_holding "$out")"

fresh
pin "$D/fat.md" 30000
out=$(run_scan)
check "15 free: a pin over its bound is counted rather than ignored" "1" "$(field bounds_over "$out")"
check "15 free: it passes while the ceiling admits it" "ok" "$(verdict "$out")"
out=$(run_scan 1 0)
check "15 bitten: the same pin refuses once the ceiling falls to zero" "over_declared_bound" "$(verdict "$out")"
named=$(printf '%s\n' "$out" | grep -c 'fat.md stands above the byte bound it declares' || true)
check "16 free: the refusal names the pin" "1" "$named"
both=$(printf '%s\n' "$out" | grep -c 'against_24576' || true)
check "16 free: the refusal carries both numbers" "1" "$both"

# ---- 17..18: a bound written in words is honest, and may not spread ---------------------
fresh
pin "$D/small.md" 400
printf '# A page\n**Bound:** keep thin\nbody\n' > "$D/wordy.md"
out=$(run_scan)
check "17 free: a Bound header naming no measurable limit is counted as prose" "1" "$(field bounds_prose "$out")"
check "17 free: prose is not a fault while under its ceiling" "ok" "$(verdict "$out")"
printf '# Another page\n**Bound:** listings stay sentence-cheap\nbody\n' > "$D/wordy2.md"
printf '# A third page\n**Bound:** as short as it wants to be\nbody\n' > "$D/wordy3.md"
out=$(run_scan)
check "18 bitten: the prose form spreading past its ceiling refuses" "bound_prose_spread" "$(verdict "$out")"
check "18 bitten: all three are counted" "3" "$(field bounds_prose "$out")"

# ---- 19: a declaration that disagrees with the law it cites ----------------------------
fresh
pin "$D/small.md" 400
pin "$D/liberal.md" 400 99999
out=$(run_scan)
check "19 bitten: a pin spelling a number the law does not is gated at zero" "bound_disagrees_with_law" "$(verdict "$out")"
named=$(printf '%s\n' "$out" | grep -c 'liberal.md spells a bound the seated law does not' || true)
check "19 bitten: the refusal names the pin and both numbers" "1" "$named"

# ---- 20: byte declarations alone are a corpus ------------------------------------------
fresh
pin "$D/small.md" 400
out=$(run_scan)
check "20 free: a corpus of byte declarations alone is a corpus" "ok" "$(verdict "$out")"
check "20 free: no Ceiling declarations are counted" "0" "$(field pages_declaring "$out")"

# ---- 21: dated testimony keeps every word it wrote, here too ---------------------------
fresh
pin "$D/small.md" 400
pin "$D/20260812-171050_a-dated-pin.md" 30000
out=$(run_scan 1 0)
check "21 free: dated testimony over its own byte bound passes free" "ok" "$(verdict "$out")"
check "21 free: testimony is not counted among the declarations" "1" "$(field bounds_declaring "$out")"

# ---- 22: the number comes from the law rather than from a copy -------------------------
fresh
pin "$D/small.md" 400
out=$(run_scan)
spec_n=$(grep -m1 '^living_pin_max_bytes' context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md | sed -n 's/.*=[[:space:]]*\([0-9][0-9]*\).*/\1/p')
spec_bound="$spec_n"
check "22 free: the scan reports the number the seated law states" "$spec_n" "$(field living_pin_max_bytes "$out")"

# ---- 23..27: the meter's own copy of the bound ------------------------------------------
# The pages are one half of the law; the meters measuring them are the other, and until
# `20260824.140523` five of those meters spelled the number themselves. These behaviors prove the
# wall that keeps the reading in one place, on real git repositories in the pen rather than on the
# tree, so both refusals stand at every roster pass.
L="$PEN/lawpen"
law_pen() {
  rm -rf "$L"
  mkdir -p "$L/tools/fixtures" "$L/tools/d"
  ( cd "$L" && git init -q . )
  printf '#!/bin/sh\nMAX_BYTES=$(sh "$(dirname "$0")/living_pin_max_bytes.sh")\n' > "$L/tools/fixtures/honest_scan.sh"
}
law_stage() { ( cd "$L" && git add -A . >/dev/null 2>&1 ) || true; }
law_scan() {
  DECLARED_CEILING_ROOT="$D" DECLARED_LAW_ROOT="$L" \
  DECLARED_LAW_RECITE_CEILING="${1:-0}" \
    sh tools/fixtures/declared_ceiling_scan.sh census 2>&1 || true
}

fresh
pin "$D/small.md" 400
law_pen; law_stage
out=$(law_scan 0)
check "23 free: a meter reading the law rather than spelling it passes" "ok" "$(verdict "$out")"
check "23 free: nothing decides with a copy" "0" "$(field law_copies_deciding "$out")"
check "23 free: nothing writes the number down" "0" "$(field law_copies_reciting "$out")"

law_pen
printf '#!/bin/sh\nMAX_BYTES=%s\n' "$spec_bound" > "$L/tools/fixtures/copy_scan.sh"
law_stage
out=$(law_scan 9)
check "24 bitten: a meter assigning its own copy of the bound refuses" "law_number_copied" "$(verdict "$out")"
check "24 bitten: the copy is counted" "1" "$(field law_copies_deciding "$out")"
named=$(printf '%s\n' "$out" | grep -c 'copy_scan.sh decides with its own copy of the bound' || true)
check "24 bitten: the refusal names the meter" "1" "$named"

law_pen
printf '#!/bin/sh\nif [ "$b" -gt %s ]; then :; fi\n' "$spec_bound" > "$L/tools/fixtures/cmp_scan.sh"
law_stage
out=$(law_scan 9)
check "25 bitten: a meter comparing against a literal copy refuses" "law_number_copied" "$(verdict "$out")"

law_pen
printf '# a witness pins the law value on purpose\nMAX_BYTES=%s\n' "$spec_bound" > "$L/tools/d/some_witness.rish"
law_stage
out=$(law_scan 9)
check "26 free: a witness pinning the value is a role, not a fault" "ok" "$(verdict "$out")"
check "26 free: it does not read as deciding" "0" "$(field law_copies_deciding "$out")"
check "26 free: it is counted as writing the number down" "1" "$(field law_copies_reciting "$out")"

law_pen
printf '#!/bin/sh\n# the seated bound is %s\n' "$spec_bound" > "$L/tools/fixtures/comment_scan.sh"
law_stage
out=$(law_scan 1)
check "27 free: a comment recites rather than decides" "0" "$(field law_copies_deciding "$out")"
check "27 free: a recitation under its ceiling passes" "ok" "$(verdict "$out")"
out=$(law_scan 0)
check "27 bitten: the recitation form spreading past its ceiling refuses" "law_recitation_spread" "$(verdict "$out")"

# --- 28. the one reading answers PER PAGE, proven from both sides -------------------------------
# A page may carry its own bound where the general one would refuse it for doing its job. The law
# states an exception as `living_pin_max_bytes[<path>] = <n>`, and the reading must answer it
# without ever letting a partial path stand in for a stated one.
reading=tools/fixtures/living_pin_max_bytes.sh
rp=$(mktemp -d)
mkdir -p "$rp/context/specs" "$rp/tools/fixtures"
cp "$reading" "$rp/tools/fixtures/"
cat > "$rp/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md" <<'LAW'
# pen law
```
living_pin_max_bytes = 1000
living_pin_max_bytes[a/README.md] = 4000
```
LAW
r() { sh "$rp/tools/fixtures/living_pin_max_bytes.sh" "$@" 2>/dev/null; }
check "28 free: no argument answers the general bound" "1000" "$(r)"
check "28 free: a named page answers its own bound" "4000" "$(r a/README.md)"
check "28 free: an unnamed page answers the general bound" "1000" "$(r b/README.md)"
check "28 free: a longer path never borrows a shorter page's bound" "1000" "$(r x/a/README.md)"
check "28 free: a shorter path never borrows a longer page's bound" "1000" "$(r README.md)"
rm -f "$rp/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md"
if r a/README.md >/dev/null 2>&1; then rr=no; else rr=yes; fi
check "28 bitten: an absent law refuses rather than defaulting" "yes" "$rr"
printf '# pen law with no number\n' > "$rp/context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md"
if r >/dev/null 2>&1; then rn=no; else rn=yes; fi
check "28 bitten: a law stating no number refuses rather than defaulting" "yes" "$rn"
rm -rf "$rp"

echo ""
echo "control_pass=$PASS"
echo "control_fail=$FAIL"
if [ "$FAIL" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=fail"; exit 1; fi
