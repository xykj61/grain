#!/bin/sh
# tools/fixtures/p/plant_adoption_scan.sh -- how many controls import the plant law.
#
# WHAT THIS COUNTS, AND WHY IT COUNTS THAT. A control that breaks a module on purpose makes a claim
# about a line of the real source, and REDS %519 booked what happens when that line moves: the sed
# matches nothing, the pen is copied byte for byte, and the phase reads the UNMUTATED module's exit
# code, which is 0 and reads exactly like a law that holds. `tools/fixtures/p/plant.sh` answers that
# once. This scan counts the controls that source it.
#
# WHY ADOPTION RATHER THAN EXPOSURE. The obvious reading -- count the controls that plant without
# checking -- needs a rule for telling a plant from a fixture build, and every candidate rule is a
# proxy that misreads real files today. Measured at `e567cbc128` over the seven controls carrying
# `cmp -s`: four use it to prove a plant landed, and three use it to prove a file did NOT change
# (`reds_ledger_headline` proves rows stand byte-identical, `remember_git_nib_write` proves refusal
# before mutation, `shell_portable` proves `sed_inplace` matching nothing leaves a file alone). The
# word `planted` fails from the other side -- `reds_ledger_headline` writes pen rows it calls
# planted, and `remember_git_nib_write` carries the word only in its header prose. One operator,
# three claims, so neither the operator nor the word can name the population.
#
# Sourcing a file is not a proxy. It is exact, it is one grep, and it is the same reading the tree
# already takes of `tools/fixtures/s/shell_portable.sh`.
#
# WHAT THIS DOES NOT CLAIM. That the remainder is unsafe. Some of those controls plant nothing at
# all; some carry their own correct check in one of five local spellings. The remainder is the
# population that has NOT yet imported one proven implementation, which is the honest thing this
# reading can say and the whole of it.
#
# Run from anywhere; the root is found by upward walk.
#   sh tools/fixtures/p/plant_adoption_scan.sh          # the counts
#   sh tools/fixtures/p/plant_adoption_scan.sh --list   # ... and every control not yet sourcing

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

want_list=no
[ "${1:-}" = "--list" ] && want_list=yes

cd "$_fd_root"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The index is the reading, never the working tree: a control staged but not yet on disk, or a file
# on disk nobody tracked, are both outside what a fresh clone would run.
git ls-files 'tools/fixtures/*_control.sh' > "$work/controls.txt" 2>/dev/null || : > "$work/controls.txt"
controls=$(wc -l < "$work/controls.txt" | tr -d ' ')

: > "$work/sourcing.txt"
: > "$work/remainder.txt"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$f" ] || continue
  # The DOT-COMMAND spelling, not merely the path. A control that copies the functions rather than
  # sourcing them reads as remainder on purpose -- a copy is what this law exists to stop
  # multiplying.
  #
  # WHY THE LINE AND NOT THE PATH (`20260907.145907`). This read `grep -q tools/fixtures/p/plant.sh`
  # and called that exact, in a header arguing that sourcing is exact where `cmp -s` is a proxy. A
  # control landed whose header says in prose WHY it does not use the plant law -- its plants are
  # files it authors, so there is no claim about somebody else's line to check -- and naming the
  # helper in that sentence counted it as an adopter, raising `sourcing` 12 to 13 and reding the
  # witness that holds the floor. A grep for a path reads every mention of it, including the ones
  # that say the opposite. Every one of the twelve real adopters carries `. "<root>/tools/fixtures/
  # p/plant.sh"`, so the dot command IS the import and the reading is exact again.
  if grep -qE '^[[:space:]]*\.[[:space:]].*tools/fixtures/p/plant\.sh' "$f"; then
    echo "$f" >> "$work/sourcing.txt"
  else
    echo "$f" >> "$work/remainder.txt"
  fi
done < "$work/controls.txt"

sourcing=$(wc -l < "$work/sourcing.txt" | tr -d ' ')
remainder=$(wc -l < "$work/remainder.txt" | tr -d ' ')

if [ "$want_list" = yes ]; then
  echo "-- controls not yet sourcing the plant law --"
  cat "$work/remainder.txt"
  echo "-- end --"
fi

echo "controls=$controls"
echo "sourcing=$sourcing"
echo "remainder=$remainder"

# The arithmetic is stated so a reader can check the reading rather than trust it. A scan whose
# parts do not sum to its whole has measured something other than what it named.
if [ "$((sourcing + remainder))" -eq "$controls" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=unbalanced"
exit 1
