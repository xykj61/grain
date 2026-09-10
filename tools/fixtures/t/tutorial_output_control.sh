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
  echo "$d"
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

# ---- 9. prose between the blocks is not a pair -------------------------------------------------
# A sentence between a command and a block means the page is saying something the parser cannot
# read, and guessing there would invent claims the writer never made.
d=$(new_pen prose)
{
  printf '# a page\n\n```sh\nsh tools/fixtures/p/say_two.sh\n```\n\nAnd here is a listing:\n\n```\nnothing to do with it\n```\n'
} > "$d/docs-geode/tutorials/page.md"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *pairs=0*) ok prose_between_not_a_pair ;;
  *) bad prose_between_not_a_pair "prose between the blocks was read as a claim" ;;
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
