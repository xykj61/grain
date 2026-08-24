#!/bin/sh
# tools/fixtures/loop_prompt_parse_scan.sh -- every shell command this tree prints for a hand to
# paste must parse as a shell command.
#
# WHY. tools/l/launch-claude-season.rish prints the unattended-loop recipe: long single-quoted
# prompts a hand copies into an outer terminal. A literal apostrophe inside a single-quoted shell
# string has to be written '' -- and one written as a lone ' silently flips every character after
# it out of quoting. On 20260824 the recipe carried exactly one, in the words "the linker's own
# search path", and both printed launch lines died on the first later parenthesis with
# `syntax error near unexpected token ('`. The loop could not start, and nothing in the tree said so,
# because a printed string is not code any compiler reads.
#
# WHAT IS GATED, hard, at zero. Every printed line that looks like a runnable shell command and
# fails `bash -n`. A line is taken as runnable when it invokes the jail elder (./tools/ag/agent-jail.sh)
# or opens the outer loop (D=$(TZ=...).
#
# WHAT PASSES FREE. Prose, headings, and the numbered narration around the commands -- they are read
# by a person and parse as nothing at all. Apostrophes in that prose are correct English and are
# left alone; only a line the reader is told to run is measured.
#
# USAGE
#   sh tools/fixtures/loop_prompt_parse_scan.sh                 # report on the real recipe
#   sh tools/fixtures/loop_prompt_parse_scan.sh report <file>   # report on a pen's own printout
#
# Driven by tools/l/loop_prompt_parse_witness.rish. Run from the repository root.

set -u

mode=${1:-report}
src=${2:-}

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT

if [ -n "$src" ]; then
  if [ ! -f "$src" ]; then
    echo "verdict=no_printout"
    echo "refused: $src is the printout this scan reads, and it is absent" >&2
    exit 1
  fi
  cp "$src" "$work/recipe.txt"
else
  if [ ! -f tools/l/launch-claude-season.rish ]; then
    echo "verdict=no_recipe_tool"
    echo "refused: tools/l/launch-claude-season.rish is the tool this scan reads, and it is absent" >&2
    exit 1
  fi
  rishi/bin/rishi run tools/l/launch-claude-season.rish > "$work/recipe.txt" 2>/dev/null || {
    echo "verdict=recipe_tool_failed"
    echo "refused: the recipe tool exited non-zero, so there is no printout to measure" >&2
    exit 2
  }
fi

runnable=0
broken=0

# invariant: a line is measured only when the reader is told to run it -- the jail elder or the
# outer loop's own opening assignment. Narration parses as nothing and is not a defect.
line_no=0
while IFS= read -r line; do
  line_no=$((line_no + 1))
  case "$line" in
    *"./tools/ag/agent-jail.sh"*|*'D=$(TZ='*) ;;
    *) continue ;;
  esac
  runnable=$((runnable + 1))
  printf '%s\n' "$line" > "$work/one.sh"
  if bash -n "$work/one.sh" 2>/dev/null; then
    :
  else
    broken=$((broken + 1))
    echo "detail: printed line $line_no does not parse -- $(bash -n "$work/one.sh" 2>&1 | head -1)"
  fi
done < "$work/recipe.txt"

echo "runnable_lines=$runnable"
echo "lines_that_do_not_parse=$broken"

if [ "$runnable" -eq 0 ]; then
  echo "verdict=no_runnable_lines"
  echo "refused: a recipe that prints no runnable command has stopped being a recipe" >&2
  exit 3
fi

if [ "$broken" -ne 0 ]; then
  echo "verdict=printed_line_does_not_parse"
  exit 4
fi

echo "verdict=every_printed_line_parses"
exit 0
