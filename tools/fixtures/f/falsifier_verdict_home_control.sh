#!/bin/sh
# tools/fixtures/f/falsifier_verdict_home_control.sh -- the pen for
# tools/fixtures/f/falsifier_verdict_home_scan.sh.
#
# Real git repositories in a throwaway pen, because the scan draws its pages with
# `git ls-files`: a pen whose pages merely sat on disk would read as an empty tree
# and every leg would pass for the wrong reason. Every refusal is planted and then
# lifted, so a leg passing in one direction alone cannot be told from a bypass.
#
# THE MUTATIONS, each asserted to bite, and each preceded in the same pen by the
# unmutated reading it replaces -- a mutation is evidence only where the truth it
# displaces differs from it:
#
#   m1  match an erratum without comparing its ROW, so an elder answering row 9
#       reads as an answer to a child that graded row 4. The gate then reports
#       zero on a page whose graded row still stands unrefuted.
#   m2  lift the 25-line door bound off form B, so an ordinary body sentence
#       naming a row and linking a dated page reads as a declaration. Measured on
#       the live tree while this scan was being written: without the bound it read
#       26 declarations rather than 14, named 13 elders that were never graded,
#       and put 12 false entries in front of a gate held at zero.
#   m3  drop the shelf exclusion, so a declaration on a dated shelf enters the
#       gate. Accrete-never-break keeps a shelved page exactly as written, so that
#       page can never be repaired and the gate would red forever on testimony.
#   m4  match an erratum line unanchored, so an elder MENTIONING `**Row 4
#       erratum:**` mid-sentence reads as carrying one.
#
# Run from the repository root:  sh tools/fixtures/f/falsifier_verdict_home_control.sh
set -u

ROOT=$(pwd)
. "$ROOT/tools/fixtures/s/shell_portable.sh"
SCAN="$ROOT/tools/fixtures/f/falsifier_verdict_home_scan.sh"

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

legs=0
failed=0

# leg <got> <want> <name> -- got first, because the printout says "wanted W, read G".
leg() {
  legs=$((legs + 1))
  if [ "$1" = "$2" ]; then
    printf 'leg %s ok (%s)\n' "$3" "$1"
  else
    failed=$((failed + 1))
    printf 'leg %s FAILED -- wanted %s, read %s\n' "$3" "$2" "$1"
  fi
}

new_pen() {
  rm -rf "$pen/tree"
  mkdir -p "$pen/tree/external-research" "$pen/tree/active-designing" "$pen/tree/tools/fixtures/f"
  cd "$pen/tree" || exit 1
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  cp "$SCAN" tools/fixtures/f/falsifier_verdict_home_scan.sh
}

seal() { git add -A >/dev/null 2>&1; git commit -qm pen >/dev/null 2>&1; }

run_scan() { sh tools/fixtures/f/falsifier_verdict_home_scan.sh 2>/dev/null; }
read_key() { run_scan | grep "^$1=" | cut -d= -f2; }

# An elder page carrying a ranked row, and the erratum a child writes back onto it.
elder_page() {  # <path> <erratum-row-or-none> <stamp>
  {
    printf '# pen elder\n\n**Style:** Gauge, Field setting\n\n'
    [ "$2" = "none" ] || printf '**Row %s erratum:** `%s` -- the row was graded and it fell.\n\n' "$2" "$3"
    printf 'Row 4 ranks the bearing scheme first.\n'
  } > "$1"
}

# A child page declaring which elder row it graded, under whatever key it chose.
child_page() {  # <path> <key> <row> <elder-basename>
  printf '# pen child\n\n**%s:** row %s of [`%s`](%s)\n\nThe reading stands.\n' \
    "$2" "$3" "$4" "$4" > "$1"
}

# --------------------------------------------------- the answered and unanswered pair
new_pen
elder_page active-designing/20260910-060204_pen-elder.md 4 20260911.195059
child_page active-designing/20260911-195059_pen-child.md Answers 4 20260910-060204_pen-elder.md
seal
leg "$(read_key declarations)" 1 answered_declaration_counted
leg "$(read_key answered)"     1 answered_counted
leg "$(read_key unanswered)"   0 answered_leaves_gate_clear
leg "$(read_key errata_total)" 1 errata_counted
leg "$(read_key verdict)" answered answered_verdict

# The same pen with the erratum removed: the child graded the row and the elder is silent.
elder_page active-designing/20260910-060204_pen-elder.md none -
seal
leg "$(read_key unanswered)" 1 unanswered_planted
leg "$(read_key answered)"   0 unanswered_leaves_no_answer
leg "$(read_key verdict)" unanswered unanswered_verdict
run_scan >/dev/null 2>&1; leg "$?" 0 unanswered_still_exits_zero

# Lift the plant: the reading returns, so the refusal is the plant rather than the pen.
elder_page active-designing/20260910-060204_pen-elder.md 4 20260911.195059
seal
leg "$(read_key unanswered)" 0 plant_lifted_returns

# ------------------------------------------------------------ the elder that is absent
new_pen
child_page active-designing/20260911-195059_pen-child.md Reads 4 20260910-060204_absent-elder.md
seal
leg "$(read_key elder_missing)" 1 elder_missing_counted
leg "$(read_key unanswered)"    0 elder_missing_never_gated
leg "$(read_key verdict)" answered elder_missing_verdict_clear

# ------------------------------------------------------------------- the closed stacks
new_pen
mkdir -p active-designing/date/20260911
elder_page active-designing/20260910-060204_pen-elder.md none -
child_page active-designing/date/20260911/20260911-195059_pen-child.md Reads 4 20260910-060204_pen-elder.md
seal
leg "$(read_key declarations)" 0 shelved_child_read_past
leg "$(read_key unanswered)"   0 shelved_child_never_gated

# ------------------------------------------------------------------ the key census
new_pen
elder_page active-designing/20260910-060204_pen-elder.md 4 20260911.195059
elder_page active-designing/20260910-060205_pen-elder-two.md 9 20260912.021711
child_page active-designing/20260911-195059_pen-child.md Answers 4 20260910-060204_pen-elder.md
child_page active-designing/20260912-021711_pen-child-two.md Serves 9 20260910-060205_pen-elder-two.md
printf '# keyed\n\n**Runs the falsifier of:** [`x`](x) -- fired\n' > external-research/20260913-000000_pen-keyed.md
seal
leg "$(read_key keys_count)" 2 keys_counted
leg "$(read_key keys)" "Answers,Serves" keys_listed
leg "$(read_key key_seated)" 1 seated_key_counted
leg "$(read_key answered)" 2 two_elders_two_answers

# ------------------------------------------------- an erratum whose stamp names no page
new_pen
elder_page active-designing/20260910-060204_pen-elder.md 4 20260999.999999
child_page active-designing/20260911-195059_pen-child.md Reads 4 20260910-060204_pen-elder.md
seal
leg "$(read_key erratum_no_paper)" 1 erratum_without_paper_counted
leg "$(read_key unanswered)" 0 erratum_without_paper_never_gated
elder_page active-designing/20260910-060204_pen-elder.md 4 20260911.195059
seal
leg "$(read_key erratum_no_paper)" 0 erratum_with_paper_clears

# ------------------------------------------------------------------- the two refusals
new_pen
seal
leg "$(read_key verdict)" no_pages_found empty_corpus_refuses
run_scan >/dev/null 2>&1; leg "$?" 2 empty_corpus_exit_two

rm -rf "$pen/bare"; mkdir -p "$pen/bare/tools/fixtures/f"
cp "$SCAN" "$pen/bare/tools/fixtures/f/falsifier_verdict_home_scan.sh"
cd "$pen/bare" || exit 1
leg "$(sh tools/fixtures/f/falsifier_verdict_home_scan.sh 2>/dev/null | grep '^verdict=' | cut -d= -f2)" not_a_repo outside_repo_refuses

# ------------------------------------------------------------------------- the bound
new_pen
elder_page active-designing/20260910-060204_pen-elder.md 4 20260911.195059
child_page active-designing/20260911-195059_pen-child.md Answers 4 20260910-060204_pen-elder.md
child_page active-designing/20260912-021711_pen-child-two.md Reads 4 20260910-060204_pen-elder.md
seal
leg "$(read_key declarations)" 2 bound_baseline_two
cp tools/fixtures/f/falsifier_verdict_home_scan.sh "$pen/scan.keep"
sed_inplace 's/^MAX_DECL=.*/MAX_DECL=1/' tools/fixtures/f/falsifier_verdict_home_scan.sh
leg "$(read_key verdict)" over_bound bound_refuses
run_scan >/dev/null 2>&1; leg "$?" 2 bound_exit_two
cat "$pen/scan.keep" > tools/fixtures/f/falsifier_verdict_home_scan.sh
leg "$(read_key verdict)" answered bound_restored

# ---------------------------------------------------------------------- m1: row blind
new_pen
elder_page active-designing/20260910-060204_pen-elder.md 9 20260912.021711
child_page active-designing/20260911-195059_pen-child.md Answers 4 20260910-060204_pen-elder.md
seal
leg "$(read_key unanswered)" 1 m1_unmutated_reads_unanswered
sed_inplace 's/\$2==p \&\& \$3==n/$2==p/' tools/fixtures/f/falsifier_verdict_home_scan.sh
leg "$(read_key unanswered)" 0 m1_mutation_bites

# ---------------------------------------------------------------- m2: the door bound
new_pen
elder_page active-designing/20260910-060204_pen-elder.md 4 20260911.195059
{
  printf '# pen child\n\n**Reads:** row 4 of [`%s`](%s)\n\n' \
    20260910-060204_pen-elder.md 20260910-060204_pen-elder.md
  i=0; while [ "$i" -lt 30 ]; do printf 'Body prose, line %s of the argument.\n\n' "$i"; i=$((i + 1)); done
  printf '**Note:** row 9 of the grid in [`%s`](%s) is a table row rather than a graded one.\n' \
    20260910-060204_pen-elder.md 20260910-060204_pen-elder.md
} > active-designing/20260911-195059_pen-child.md
seal
leg "$(read_key declarations)" 1 m2_unmutated_reads_door_only
leg "$(read_key unanswered)"   0 m2_unmutated_gate_clear
sed_inplace 's/FNR > 25/FNR > 100000/' tools/fixtures/f/falsifier_verdict_home_scan.sh
leg "$(read_key declarations)" 2 m2_mutation_bites
leg "$(read_key unanswered)"   1 m2_mutation_reaches_the_gate

# ------------------------------------------------------------- m3: shelf exclusion off
new_pen
mkdir -p active-designing/date/20260911
elder_page active-designing/20260910-060204_pen-elder.md none -
child_page active-designing/date/20260911/20260911-195059_pen-child.md Reads 4 20260910-060204_pen-elder.md
seal
leg "$(read_key declarations)" 0 m3_unmutated_reads_past_shelf
sed_inplace 's/| grep -vE .\/(date|archive|yonder)\/. //' tools/fixtures/f/falsifier_verdict_home_scan.sh
leg "$(read_key declarations)" 1 m3_mutation_bites
leg "$(read_key unanswered)"   1 m3_mutation_reaches_the_gate

# ------------------------------------------------------------- m4: unanchored erratum
new_pen
{
  printf '# pen elder\n\n**Style:** Gauge, Field setting\n\n'
  printf 'A reader may ask whether **Row 4 erratum:** `20260911.195059` belongs here.\n'
} > active-designing/20260910-060204_pen-elder.md
child_page active-designing/20260911-195059_pen-child.md Reads 4 20260910-060204_pen-elder.md
seal
leg "$(read_key unanswered)" 1 m4_unmutated_reads_unanswered
sed_inplace 's/-v anchored=1/-v anchored=0/' tools/fixtures/f/falsifier_verdict_home_scan.sh
leg "$(read_key unanswered)" 0 m4_mutation_bites

cd "$ROOT" || exit 1
printf 'legs=%s\n' "$legs"
printf 'control_failed=%s\n' "$failed"
printf 'control_verdict=%s\n' "$([ "$failed" -eq 0 ] && echo ok || echo red)"
