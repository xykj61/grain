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
# reading can say and the whole of it. It follows that the remainder is not the ratchet and cannot
# be one -- it can never reach zero -- so the number gated below is `sourcing`, under a floor.
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

# THE FLOOR RISES, AND IT IS A NUMBER RATHER THAN A SPELLING (`20260907.171500`). This reading was
# gated in `tools/p/plant_witness.rish` by `assert adoption.out contains "sourcing=13"`, beneath a
# paragraph calling it "a floor that only ever RISES". An equality is not a floor, and the gap cost
# two things on metal. A lane that ADOPTED the law -- the one act this number exists to reward --
# moves the count to 14 and refuses that assert, and `construction/standing-equipment.kyri` seats
# `guard plant` at `tier lap`, so the red lands on every lap of all eight ships until a hand edits
# the witness. And Rishi's `contains` is a substring reading, so `sourcing=130` satisfies
# `sourcing=13` -- out of reach at 178 tracked controls today, inside it as the corpus grows.
#
# So the bound lives here and is compared numerically, which is the shape every other ratchet in
# this tree already keeps -- `ceiling=57` in `tools/fixtures/e/exec_bit_scan.sh`, compared with
# `-le`, its witness asserting a word rather than the measurement. Raise this when a lane adopts;
# it may never fall. The chronicle of who raised it and why stays in the witness.
floor=13

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
echo "floor=$floor"
echo "remainder=$remainder"

# The arithmetic is read FIRST and decides alone. A scan whose parts do not sum to its whole has
# measured something other than what it named, and a floor read off a miscount is a second claim
# resting on a broken first one.
if [ "$((sourcing + remainder))" -ne "$controls" ]; then
  echo "verdict=unbalanced"
  exit 1
fi

# WHICH NUMBER IS THE RATCHET. `sourcing` is, and `remainder` is a population this scan reports
# rather than gates. The remainder cannot reach zero and was never meant to: some of those controls
# plant nothing at all, and a control that authors its own fixtures has no claim about somebody
# else's line to check. A floor under the good population moves the only direction adoption can
# move, so the number to watch rises rather than falls.
if [ "$sourcing" -lt "$floor" ]; then
  echo "verdict=below_floor"
  exit 1
fi

echo "verdict=ok"
exit 0
