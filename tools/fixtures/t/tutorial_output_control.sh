#!/bin/sh
# tools/fixtures/t/tutorial_output_control.sh -- proves tools/fixtures/t/tutorial_output_scan.sh
# from both sides, on real git repositories built in a throwaway pen.
#
# A guard proven only in the passing direction cannot be told apart from a guard that reads
# nothing at all, so every refusal below is planted and watched, then lifted and watched to go
# free again. The aether threshold says it in one line: a witness must be proven able to make a
# sound before its silence means anything.
#
#   sh tools/fixtures/t/tutorial_output_control.sh
#
# Run from the repository root. Driven by tools/t/tutorial_output_witness.rish.

set -u

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/t/tutorial_output_scan.sh"

fails=0
ok() { echo "case=$1 ok"; }
bad() { echo "case=$1 RED -- $2"; fails=$((fails + 1)); }

# A pen repository holding one page in a docs-geode room, plus the tiny script its page runs.
# The script is `sh`-run and tracked, so it sits on the scan's roster the way the real pages do.
new_pen() {
  d="$pen/$1"
  mkdir -p "$d/docs-geode/tutorials" "$d/tools/fixtures/p"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email pen@example.invalid
  git -C "$d" config user.name pen
  printf 'echo one\necho two\n' > "$d/tools/fixtures/p/say_two.sh"
  # A longer report, so a selection can be quoted as one unbroken run or gathered from lines that
  # stand apart -- the two shapes the scan tells apart.
  printf 'echo one\necho two\necho three\necho four\n' > "$d/tools/fixtures/p/say_four.sh"
  echo "$d"
}

# The same page, running the four-line script. $1 pen dir, $2 output-block body, $3 line above.
page4() {
  d=$1; body=$2; above=${3:-}
  {
    printf '# a page\n\nRun it:\n\n'
    printf '```sh\n'
    printf 'sh tools/fixtures/p/say_four.sh\n'
    printf '```\n\n'
    [ -n "$above" ] && printf '%s\n\n' "$above"
    printf '```\n'
    printf '%s' "$body"
    printf '```\n'
  } > "$d/docs-geode/tutorials/page.md"
  git -C "$d" add -A >/dev/null 2>&1
}

# $1 pen dir, $2 output-block body, $3 optional line placed just above the output fence
page() {
  d=$1; body=$2; above=${3:-}
  {
    printf '# a page\n\nRun it:\n\n'
    printf '```sh\n'
    printf 'sh tools/fixtures/p/say_two.sh\n'
    printf '```\n\n'
    [ -n "$above" ] && printf '%s\n\n' "$above"
    printf '```\n'
    printf '%s' "$body"
    printf '```\n'
  } > "$d/docs-geode/tutorials/page.md"
  git -C "$d" add -A >/dev/null 2>&1
}

run_scan() { ( cd "$1" && sh "$SCAN" 2>&1 ); }
run_list() { ( cd "$1" && sh "$SCAN" list 2>&1 ); }

# ---- 1. a matching block goes free -------------------------------------------------------------
d=$(new_pen match)
page "$d" 'one
two
'
out=$(run_scan "$d")
case "$out" in
  *every_quoted_block_still_prints*) ok match_free ;;
  *) bad match_free "a page quoting exactly what its command prints was refused: $out" ;;
esac
case "$out" in
  *exact=1*) ok match_counted_exact ;;
  *) bad match_counted_exact "the matching pair was not counted exact: $out" ;;
esac

# ---- 2. a drifted block is bitten --------------------------------------------------------------
# The command still prints two lines; the page quotes three. This is the first hour's own fault,
# planted: a page promising fewer or other lines than the command produces.
d=$(new_pen drift)
page "$d" 'one
two
three
'
out=$(run_scan "$d")
case "$out" in
  *a_quoted_block_no_longer_matches*) ok drift_bitten ;;
  *) bad drift_bitten "a page quoting a line the command never prints went free: $out" ;;
esac
case "$out" in
  *"docs-geode/tutorials/page.md"*) ok drift_named ;;
  *) bad drift_named "the refusal named no page: $out" ;;
esac
case "$out" in
  *"quoted 3 lines, printed 2"*) ok drift_measured ;;
  *) bad drift_measured "the refusal did not say how far apart the two are: $out" ;;
esac

# ---- 3. lifting the plant returns it to green --------------------------------------------------
# A refusal that survives its own repair is a refusal nobody can act on.
page "$d" 'one
two
'
case "$(run_scan "$d")" in
  *every_quoted_block_still_prints*) ok drift_lifted ;;
  *) bad drift_lifted "the repaired page stayed refused" ;;
esac

# ---- 4. a declared volatile block reports and never gates ---------------------------------------
d=$(new_pen volatile)
page "$d" 'one
seventy-two
' '<!-- volatile: the second line counts a growing tree -->'
out=$(run_scan "$d")
case "$out" in
  *every_quoted_block_still_prints*) ok volatile_free ;;
  *) bad volatile_free "a declared moving block was gated: $out" ;;
esac
case "$out" in
  *volatile=1*) ok volatile_counted ;;
  *) bad volatile_counted "the declared pair was not counted volatile: $out" ;;
esac
case "$out" in
  *drift=0*) ok volatile_not_drift ;;
  *) bad volatile_not_drift "a declared pair was counted as drift too: $out" ;;
esac

# ---- 5. a volatile comment with no reason declares nothing --------------------------------------
# The tree says why beside every exemption, so an empty one buys nothing.
d=$(new_pen noreason)
page "$d" 'one
seventy-two
' '<!-- volatile: -->'
case "$(run_scan "$d")" in
  *a_quoted_block_no_longer_matches*) ok reasonless_bitten ;;
  *) bad reasonless_bitten "a reasonless declaration excused a drift" ;;
esac

# ---- 6. an unrunnable fence is held rather than run ----------------------------------------------
d=$(new_pen held)
{
  printf '# a page\n\n```sh\nmkdir -p out\nsh tools/fixtures/p/say_two.sh > out/f\n```\n\n```\none\ntwo\n```\n'
} > "$d/docs-geode/tutorials/page.md"
git -C "$d" add -A >/dev/null 2>&1
out=$(run_scan "$d")
case "$out" in
  *held=1*) ok redirect_held ;;
  *) bad redirect_held "a fence with a redirect was not held: $out" ;;
esac
case "$out" in
  *checked=0*) ok redirect_not_run ;;
  *) bad redirect_not_run "a fence outside the roster was run anyway: $out" ;;
esac

# ---- 7. an untracked script is held ---------------------------------------------------------------
# Step 6 of the first hour tells the reader to write first.rish. The tree cannot run what it does
# not carry, and calling that a drift would refuse a page for teaching correctly.
d=$(new_pen untracked)
{
  printf '# a page\n\n```sh\nsh first.sh\n```\n\n```\none\n```\n'
} > "$d/docs-geode/tutorials/page.md"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *held=1*) ok untracked_held ;;
  *) bad untracked_held "a script the reader writes was treated as runnable" ;;
esac

# ---- 8. the held ceiling bites, and from both sides ------------------------------------------------
d=$(new_pen ceiling)
{
  printf '# a page\n\n```sh\nsh first.sh\n```\n\n```\none\n```\n\n```sh\nsh second.sh\n```\n\n```\ntwo\n```\n'
} > "$d/docs-geode/tutorials/page.md"
git -C "$d" add -A >/dev/null 2>&1
case "$( cd "$d" && TUTORIAL_OUTPUT_HELD_CEILING=1 sh "$SCAN" 2>&1 )" in
  *held_above_ceiling*) ok ceiling_bitten ;;
  *) bad ceiling_bitten "two held pairs passed a ceiling of one" ;;
esac
case "$( cd "$d" && TUTORIAL_OUTPUT_HELD_CEILING=2 sh "$SCAN" 2>&1 )" in
  *every_quoted_block_still_prints*) ok ceiling_met_free ;;
  *) bad ceiling_met_free "two held pairs were refused at a ceiling of two" ;;
esac

# ---- 9. prose between the blocks is a candidate nobody checks ----------------------------------
# A sentence between a command and a block means the page is saying something the parser cannot
# read, and guessing there would invent claims the writer never made. So the pair is still NOT
# checked -- what changed 20260910 is that it is now counted and named rather than dropped in
# silence, because a block nothing reads and a block nothing MAY read read alike from outside.
d=$(new_pen prose)
{
  printf '# a page\n\n```sh\nsh tools/fixtures/p/say_two.sh\n```\n\nAnd here is a listing:\n\n```\nnothing to do with it\n```\n'
} > "$d/docs-geode/tutorials/page.md"
git -C "$d" add -A >/dev/null 2>&1
out=$(run_scan "$d")
case "$out" in
  *undeclared_after_prose=1*) ok prose_between_named ;;
  *) bad prose_between_named "prose between the blocks was dropped in silence: $out" ;;
esac
case "$out" in
  *checked=0*) ok prose_between_unchecked ;;
  *) bad prose_between_unchecked "an undeclared block behind prose was checked anyway: $out" ;;
esac
case "$out" in
  *every_quoted_block_still_prints*) ok prose_between_ungated ;;
  *) bad prose_between_ungated "an undeclared block behind prose gated the tree: $out" ;;
esac

# ---- 9a. a declared selection is checked by containment and goes free --------------------------
# The demos room quotes two lines of a longer report. Equality is the wrong test there; every
# quoted line appearing in what ran, in order, is the right one.
d=$(new_pen sel_free)
page "$d" 'two
' 'Just the second line:

<!-- selected: one line of a longer report -->'
out=$(run_scan "$d")
case "$out" in
  *selected=1*) ok selection_counted ;;
  *) bad selection_counted "a declared selection was not counted: $out" ;;
esac
case "$out" in
  *every_quoted_block_still_prints*) ok selection_free ;;
  *) bad selection_free "a true selection of the output was refused: $out" ;;
esac

# ---- 9b. a selection quoting a line that never prints is bitten --------------------------------
d=$(new_pen sel_bite)
page "$d" 'three
' 'Just one line:

<!-- selected: one line of a longer report -->'
out=$(run_scan "$d")
case "$out" in
  *a_quoted_block_no_longer_matches*) ok selection_drift_bitten ;;
  *) bad selection_drift_bitten "a selection quoting a line no command prints went free: $out" ;;
esac
case "$out" in
  *"never printed: three"*) ok selection_drift_named ;;
  *) bad selection_drift_named "the drifted selection did not name the missing line: $out" ;;
esac

# ---- 9c. a selection with every line present and the ORDER wrong is bitten ---------------------
# The sharpest leg here, and the one that proves order is genuinely enforced rather than
# incidentally satisfied: both lines print, and the page prints them the other way round. A page
# that lists a verdict above the count that produced it teaches the output's shape wrongly.
d=$(new_pen sel_order)
page "$d" 'two
one
' '<!-- selected: both lines, in the wrong order -->'
out=$(run_scan "$d")
case "$out" in
  *a_quoted_block_no_longer_matches*) ok selection_order_bitten ;;
  *) bad selection_order_bitten "a selection with its lines out of order went free: $out" ;;
esac

# ---- 9d. lifting the selection plant returns it to green --------------------------------------
# A refusal that survives its own repair is a refusal nobody can act on.
d=$(new_pen sel_lift)
page "$d" 'one
two
' '<!-- selected: both lines, in the order they print -->'
case "$(run_scan "$d")" in
  *every_quoted_block_still_prints*) ok selection_lifted ;;
  *) bad selection_lifted "the repaired selection stayed refused" ;;
esac

# ---- 9e. a selected comment with no reason declares nothing ------------------------------------
# The same discipline case 5 holds for volatile: the tree says why beside every exemption, so an
# empty one buys nothing and the pair falls back to undeclared.
d=$(new_pen sel_empty)
page "$d" 'two
' 'Just one line:

<!-- selected: -->'
out=$(run_scan "$d")
case "$out" in
  *undeclared_after_prose=1*) ok selection_reasonless_declares_nothing ;;
  *) bad selection_reasonless_declares_nothing "a reasonless selection was honored: $out" ;;
esac

# ---- 9g. a selection quoted as one unbroken run reads contiguous -------------------------------
# Containment in order says every quoted line printed. It says nothing about what stands between
# them, so each selection is read a second time for its shape.
d=$(new_pen sel_run)
page4 "$d" 'two
three
' '<!-- selected: two adjacent lines of a longer report -->'
out=$(run_scan "$d")
case "$out" in
  *selected_contiguous=1*) ok selection_run_contiguous ;;
  *) bad selection_run_contiguous "an unbroken run was not read as contiguous: $out" ;;
esac
case "$out" in
  *selected_scattered=0*) ok selection_run_not_scattered ;;
  *) bad selection_run_not_scattered "an unbroken run was counted as a gathering: $out" ;;
esac

# ---- 9h. a selection gathered from lines that stand apart is counted and its middle named -------
# The case the shape reading exists for: every quoted line prints, in order, and a line the page
# never shows stands in the middle of the run.
d=$(new_pen sel_gap)
page4 "$d" 'two
four
' '<!-- selected: two lines of a longer report -->'
out=$(run_scan "$d")
case "$out" in
  *selected_scattered=1*) ok selection_gathered_counted ;;
  *) bad selection_gathered_counted "a gathering was not counted: $out" ;;
esac
case "$out" in
  *"stands between the quoted lines: three"*) ok selection_gathered_named ;;
  *) bad selection_gathered_named "the line standing between the quoted ones was not named: $out" ;;
esac
case "$out" in
  *drift=0*) ok selection_gathered_not_drift ;;
  *) bad selection_gathered_not_drift "a lawful gathering was called a drift: $out" ;;
esac

# ---- 9i. the scattered ceiling bites, and passes at exactly its own number ----------------------
# Proven from both sides against one pen, so a refusal cannot be told apart from a reading that
# never fires.
out=$( cd "$d" && TUTORIAL_OUTPUT_SCATTERED_CEILING=0 sh "$SCAN" 2>&1 )
case "$out" in
  *a_selection_broke_its_run*) ok scattered_ceiling_bitten ;;
  *) bad scattered_ceiling_bitten "one gathering past a ceiling of zero went free: $out" ;;
esac
case "$out" in
  *"stands between the quoted lines: three"*) ok scattered_ceiling_names_the_middle ;;
  *) bad scattered_ceiling_names_the_middle "the refusal did not say what the page passes over: $out" ;;
esac
out=$( cd "$d" && TUTORIAL_OUTPUT_SCATTERED_CEILING=1 sh "$SCAN" 2>&1 )
case "$out" in
  *every_quoted_block_still_prints*) ok scattered_ceiling_met_free ;;
  *) bad scattered_ceiling_met_free "a gathering at exactly the ceiling was refused: $out" ;;
esac

# ---- 9j. a run broken by an inserted line is bitten --------------------------------------------
# The whole reason the ceiling is a shape rather than a line count. The page is unchanged and its
# quoted lines all still print, in order; what changed is that the command now prints something
# between them, and the page teaches a run that no longer exists.
d=$(new_pen sel_break)
page4 "$d" 'two
three
' '<!-- selected: two adjacent lines of a longer report -->'
case "$(run_scan "$d")" in
  *selected_contiguous=1*) : ;;
  *) bad selection_break_setup "the pen did not start contiguous" ;;
esac
printf 'echo one\necho two\necho wedge\necho three\necho four\n' > "$d/tools/fixtures/p/say_four.sh"
git -C "$d" add -A >/dev/null 2>&1
out=$( cd "$d" && TUTORIAL_OUTPUT_SCATTERED_CEILING=0 sh "$SCAN" 2>&1 )
case "$out" in
  *a_selection_broke_its_run*) ok selection_break_bitten ;;
  *) bad selection_break_bitten "a run broken by an inserted line went free: $out" ;;
esac
case "$out" in
  *"stands between the quoted lines: wedge"*) ok selection_break_names_the_wedge ;;
  *) bad selection_break_names_the_wedge "the refusal did not name the inserted line: $out" ;;
esac

# ---- 9k. a gathering whose output GROWS keeps its shape -----------------------------------------
# The design leg, and the reason a count of skipped lines would have been the wrong instrument.
# announced_length_scan prints one more line for every ladder anybody announces, so a ceiling on
# skipped lines would red on a page nobody touched. A shape reading holds still through that.
d=$(new_pen sel_grow)
page4 "$d" 'two
four
' '<!-- selected: two lines of a longer report -->'
printf 'echo one\necho two\necho three\necho grew\necho four\n' > "$d/tools/fixtures/p/say_four.sh"
git -C "$d" add -A >/dev/null 2>&1
out=$(run_scan "$d")
case "$out" in
  *selected_scattered=1*) ok selection_growth_keeps_shape ;;
  *) bad selection_growth_keeps_shape "growth between the quoted lines moved the shape count: $out" ;;
esac
case "$out" in
  *every_quoted_block_still_prints*) ok selection_growth_free ;;
  *) bad selection_growth_free "honest growth between quoted lines was refused: $out" ;;
esac

# ---- 9f. the gap bound bites, and from both sides ----------------------------------------------
# An output fence far below its command answers a question the reader has stopped holding. Proven
# at the bound and one past it, so the number is a wall rather than a decoration.
gap_page() {
  d=$1; n=$2
  {
    printf '# a page\n\n```sh\nsh tools/fixtures/p/say_two.sh\n```\n'
    i=0; while [ "$i" -lt "$n" ]; do printf '\n'; i=$((i + 1)); done
    printf '```\none\ntwo\n```\n'
  } > "$d/docs-geode/tutorials/page.md"
  git -C "$d" add -A >/dev/null 2>&1
}
d=$(new_pen gap_at); gap_page "$d" 12
case "$(run_scan "$d")" in
  *pairs=1*) ok gap_at_bound_free ;;
  *) bad gap_at_bound_free "a block exactly at the gap bound was dropped" ;;
esac
d=$(new_pen gap_past); gap_page "$d" 13
case "$(run_scan "$d")" in
  *pairs=0*) ok gap_past_bound_dropped ;;
  *) bad gap_past_bound_dropped "a block past the gap bound was paired anyway" ;;
esac

# ---- 10. a command fence with no output fence promises nothing ---------------------------------
d=$(new_pen lone)
{
  printf '# a page\n\n```sh\nsh tools/fixtures/p/say_two.sh\n```\n\nThat is all.\n'
} > "$d/docs-geode/tutorials/page.md"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *pairs=0*) ok lone_command_free ;;
  *) bad lone_command_free "a command promising no output was counted as a claim" ;;
esac

# ---- 11. an empty corpus refuses rather than reading clean --------------------------------------
d=$(new_pen empty)
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *no_pairs_read*) ok empty_corpus_refused ;;
  *) bad empty_corpus_refused "a corpus with no pairs reported clean" ;;
esac

# ---- 12. no git tree reads distinctly from a clean one ------------------------------------------
d="$pen/bare"; mkdir -p "$d"
case "$(run_scan "$d")" in
  *not_a_git_tree*) ok no_tree_told_apart ;;
  *) bad no_tree_told_apart "a directory with no git tree did not say so" ;;
esac

# ---- 13. the list verb names every pair with its verdict ------------------------------------------
d=$(new_pen listing)
page "$d" 'one
two
'
case "$(run_list "$d")" in
  *"page.md:"*exact*) ok list_names_pairs ;;
  *) bad list_names_pairs "the list verb did not name the pair and its verdict" ;;
esac

if [ "$fails" -eq 0 ]; then
  echo "control=ok"
  exit 0
fi
echo "control=RED fails=$fails"
exit 1
