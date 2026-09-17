#!/bin/sh
# tools/fixtures/f/falsifier_reach_control.sh -- the pen for
# tools/fixtures/f/falsifier_reach_scan.sh.
#
# Every refusal is planted and then lifted, so a leg passing in one direction alone
# cannot be told from a bypass. Real git repositories in a throwaway pen, because the
# scan draws its corpus with `git ls-files`: a pen whose pages merely sat on disk would
# read as an empty tree and every leg would pass for the wrong reason.
#
# THE MUTATIONS, each asserted to bite, and each preceded in the same pen by the
# unmutated reading it replaces -- a mutation is evidence only where the truth it
# displaces differs from it:
#
#   m1  read a heading mention like an inline one, so the region is the heading text
#       and the condition beneath it goes unread. This is the first draft's own fault,
#       and it read 509 of 676 mentions as carrying no condition.
#   m2  end the region at its first line, so a condition on the paragraph's second line
#       is lost.
#   m3  drop the citation strip, so a stamp or a REDS row lifts a narrative region into
#       `quantified` -- the meter counting its own footnotes as measurements.
#   m4  drop the roster `case`, so a page the baseline never named reads as legacy and
#       the gate at zero never fires.
#
# Run from the repository root:  sh tools/fixtures/f/falsifier_reach_control.sh
set -u

ROOT=$(pwd)
. "$ROOT/tools/fixtures/s/shell_portable.sh"
SCAN="$ROOT/tools/fixtures/f/falsifier_reach_scan.sh"

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
  mkdir -p "$pen/tree/external-research" "$pen/tree/active-designing" "$pen/tree/tools/fixtures/f" "$pen/tree/tools/fixtures/s"
  cd "$pen/tree" || exit 1
  git init -q .
  git config user.email pen@example.invalid
  git config user.name pen
  git config commit.gpgsign false
  cp "$SCAN" tools/fixtures/f/falsifier_reach_scan.sh
  cp "$ROOT/tools/fixtures/s/shell_portable.sh" tools/fixtures/s/shell_portable.sh
  printf '# pen roster\n' > tools/fixtures/f/falsifier_field_baseline.txt
}

seal() { git add -A >/dev/null 2>&1; git commit -qm pen >/dev/null 2>&1; }

read_key() { sh tools/fixtures/f/falsifier_reach_scan.sh 2>/dev/null | grep "^$1=" | cut -d= -f2; }

# A page carrying a falsifier and nothing that would wall it.
plain_page() {
  printf '# %s\n\n**Style:** Gauge\n\n%s\n' "$1" "$2" > "$3"
}

# ------------------------------------------------------------- the three classes
new_pen
plain_page one 'The falsifier is `sh tools/fixtures/f/pen_probe.sh` reading nonzero.' external-research/a.md
plain_page two 'Falsifier: a trial plot that fails the floor two seasons running.'   external-research/b.md
plain_page three 'The falsifier is a corridor whose verifiers are paid by the mill.' external-research/c.md
seal
leg "$(read_key runnable)"   1 runnable_counted
leg "$(read_key quantified)" 1 quantified_counted
leg "$(read_key narrative)"  1 narrative_counted
leg "$(read_key regions)"    3 regions_total
leg "$(read_key verdict)"    ok three_classes_ok

# A spelled number counts, and the scan says which half read it.
leg "$(read_key quantified_by_words)" 1 quantified_by_words_counted

# -------------------------------------------- the heading region, and its mutation
new_pen
cat > external-research/h.md <<'MD'
# heading page

**Style:** Gauge

## The falsifier

A plot that fails the fibre floor two seasons running kills this shape.
MD
seal
leg "$(read_key quantified)" 1 heading_region_reads_the_block
leg "$(read_key narrative)"  0 heading_alone_is_not_the_region
# m1 -- read the heading like an inline line, so the region is the heading text alone.
sed_inplace 's|if (line ~ /\^\[ \\t\]\*#+\[ \\t\]/) { rtext = ""; rlines = 0; pend = 0 }|if (0) { rtext = ""; rlines = 0; pend = 0 }|' tools/fixtures/f/falsifier_reach_scan.sh
m1=$(read_key narrative)
leg "$([ "$m1" = 1 ] && echo bitten || echo unbitten)" bitten m1_heading_region_bites

# ------------------------------------ the paragraph continuation, and its mutation
new_pen
cat > external-research/p.md <<'MD'
# paragraph page

**Style:** Gauge

The falsifier for this shape is plain and it runs to a second line,
where the condition finally lands: three consecutive seasons under floor.
MD
seal
leg "$(read_key quantified)" 1 continuation_reaches_line_two
# m2 -- end the region at its first line.
sed_inplace 's/if (!pend \&\& line !~ \/\^\[ \\t\]\*\$\/) pend = 1/{ flush_region(); inregion = 0; next }/' tools/fixtures/f/falsifier_reach_scan.sh
m2=$(read_key quantified)
leg "$([ "$m2" = 1 ] && echo unbitten || echo bitten)" bitten m2_continuation_bites

# ------------------------------------------ the citation strip, and its mutation
new_pen
plain_page cite 'The falsifier, booked at `20260917` under REDS %811, is a corridor whose verifiers are paid by the mill.' external-research/d.md
seal
leg "$(read_key narrative)"  1 citation_is_not_a_measurement
leg "$(read_key quantified)" 0 citation_does_not_quantify
# m3 -- drop the stamp strip.
sed_inplace 's|gsub(/20\[0-9\]{6}/, " ", t)|;|' tools/fixtures/f/falsifier_reach_scan.sh
m3=$(read_key narrative)
leg "$([ "$m3" = 1 ] && echo unbitten || echo bitten)" bitten m3_citation_strip_bites

# ------------------------------------------------- one paragraph is one region
new_pen
cat > external-research/e.md <<'MD'
# twice page

**Style:** Gauge

The falsifier here is plain and it runs on,
and the same falsifier is named again on this second line.
MD
seal
leg "$(read_key regions)"        1 one_paragraph_one_region
leg "$(read_key regions_nested)" 1 second_mention_counted_nested

# ------------------------------------------------------ the shelves are read past
new_pen
mkdir -p active-designing/date/20260101
plain_page shelf 'The falsifier is a plot failing two seasons running.' active-designing/date/20260101/20260101-010101_shelf.md
plain_page live  'The falsifier is a plot failing two seasons running.' active-designing/live.md
seal
leg "$(read_key living_pages)"      1 shelf_outside_the_corpus
leg "$(read_key shelved_read_past)" 1 shelf_counted_apart
leg "$(read_key regions)"           1 shelf_region_unread

# ------------------------------------------- the wall, from both sides
new_pen
cat > active-designing/w.md <<'MD'
# walled page

**Style:** Gauge, Field setting

The projection here reaches a year out and names no killing measurement.
MD
seal
leg "$(read_key unfalsified_new)"    1 unrostered_field_page_reds
leg "$(read_key verdict)" unfalsified_field_page wall_verdict
sh tools/fixtures/f/falsifier_reach_scan.sh >/dev/null 2>&1
leg "$?" 1 wall_exits_nonzero
# Lift it: the roster names the page.
printf 'active-designing/w.md\n' >> tools/fixtures/f/falsifier_field_baseline.txt
seal
leg "$(read_key unfalsified_new)"    0 roster_lifts_the_gate
leg "$(read_key unfalsified_legacy)" 1 roster_row_reads_legacy
leg "$(read_key verdict)"            ok rostered_page_walks_free
# m4 -- drop the roster case, so every page reads legacy and the gate never fires.
new_pen
cat > active-designing/w.md <<'MD'
# walled page

**Style:** Gauge, Field setting

The projection here reaches a year out and names no killing measurement.
MD
seal
leg "$(read_key unfalsified_new)" 1 unrostered_reds_before_mutation
sed_inplace 's@\*"|\$f|"\*)@*)@' tools/fixtures/f/falsifier_reach_scan.sh
m4=$(read_key unfalsified_new)
leg "$([ "$m4" = 1 ] && echo unbitten || echo bitten)" bitten m4_roster_case_bites

# --------------------------------------------- a falsifier lifts the wall entirely
new_pen
cat > active-designing/ok.md <<'MD'
# field page with a falsifier

**Style:** Gauge, Field setting

The projection reaches a year out. The falsifier is two seasons under floor.
MD
seal
leg "$(read_key unfalsified_new)" 0 falsifier_lifts_the_wall
leg "$(read_key verdict)"         ok field_page_with_falsifier_ok

# --------------------------------- a page outside Field is not walled
new_pen
cat > active-designing/n.md <<'MD'
# door page

**Style:** Gauge

The projection here reaches a year out and names no killing measurement.
MD
seal
leg "$(read_key unfalsified_new)" 0 non_field_page_not_walled

# ----------------------------------------- the ceiling, from both sides
new_pen
i=1
while [ "$i" -le 2 ]; do
  cat > "active-designing/c$i.md" <<MD
# ceiling page $i

**Style:** Gauge, Field setting

The projection here reaches a year out and names no killing measurement.
MD
  printf 'active-designing/c%s.md\n' "$i" >> tools/fixtures/f/falsifier_field_baseline.txt
  i=$((i + 1))
done
seal
sed_inplace 's/^LEGACY_CEILING=.*/LEGACY_CEILING=2/' tools/fixtures/f/falsifier_reach_scan.sh
leg "$(read_key unfalsified_legacy)" 2 legacy_at_the_ceiling
leg "$(read_key verdict)"            ok legacy_at_ceiling_walks_free
sed_inplace 's/^LEGACY_CEILING=.*/LEGACY_CEILING=1/' tools/fixtures/f/falsifier_reach_scan.sh
leg "$(read_key verdict)" legacy_over_ceiling one_over_the_ceiling_reds

# --------------------------------------- the page reading, and what it means
new_pen
cat > external-research/m.md <<'MD'
# mixed page

**Style:** Gauge

The falsifier is a corridor whose verifiers are paid by the mill.

A second falsifier: two seasons under the fibre floor.
MD
seal
leg "$(read_key narrative)"           1 mixed_page_has_a_narrative_region
leg "$(read_key page_narrative_only)" 0 mixed_page_is_not_narrative_only
leg "$(read_key page_quantified)"     1 mixed_page_reads_quantified

# ------------------------------------------------- the instrument's own refusals
new_pen
seal
leg "$(read_key verdict)" no_pages_found refuses_without_pages

# A corpus naming no falsifier anywhere is a lawful reading rather than a refusal --
# it is exactly the state the wall exists to catch.
new_pen
plain_page quiet 'This page names no such word at all.' external-research/q.md
seal
leg "$(read_key regions)" 0 empty_corpus_reads_zero_regions
leg "$(read_key verdict)" ok empty_corpus_does_not_refuse

new_pen
plain_page r 'The falsifier is two seasons under floor.' external-research/r.md
rm tools/fixtures/f/falsifier_field_baseline.txt
seal
leg "$(read_key verdict)" no_baseline refuses_without_a_roster

new_pen
plain_page s 'The falsifier is two seasons under floor.' external-research/s.md
seal
rm -rf .git
leg "$(read_key verdict)" not_a_repo refuses_outside_a_repo

# ------------------------------------------------------------------ the list face
new_pen
plain_page t 'The falsifier is two seasons under floor.' external-research/t.md
seal
leg "$(sh tools/fixtures/f/falsifier_reach_scan.sh --list 2>/dev/null | grep -c 'class=quantified')" 1 list_names_the_region
leg "$(sh tools/fixtures/f/falsifier_reach_scan.sh 2>/dev/null | grep -c 'detail:')" 0 bare_run_prints_no_detail

# ------------------------------------------------- the region bound is real
new_pen
{
  printf '# long page\n\n**Style:** Gauge\n\nThe falsifier opens here\n'
  i=1
  while [ "$i" -le 14 ]; do printf 'and this line carries no condition at all\n'; i=$((i + 1)); done
  printf '\n'
} > external-research/l.md
seal
leg "$(read_key regions_truncated)" 1 long_region_is_truncated

cd "$ROOT" || exit 1
echo "legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=red"
