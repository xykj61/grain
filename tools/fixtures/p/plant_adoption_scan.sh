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
# THE FLOOR IS A FLOOR, and it was an equality until `20260907.180000`. `tools/p/plant_witness.rish`
# held `sourcing=13` as a literal, under its own comment calling it "a floor that only rises" and a
# header calling adoption "reported rather than gated". Neither sentence described the code: an
# equality refuses a count that RISES exactly as hard as one that falls. So every lane that ADOPTED
# the law reddened the tree for every ship until a hand edited one number, and the number was raised
# by hand seven times in one day -- 4 to 5 to 7 to 9 to 11 to 12 to 13. The eighth rise, to 14, is
# the refusal this repair was found by, and it stopped a full roster pass on a tree whose only fault
# was that one more control had done the right thing.
#
# A guard that reds on the exact work it exists to encourage is a guard somebody turns off.
#
# So the number lives here, once, and it is compared as `sourcing >= FLOOR`. Adoption passes free;
# only a REGRESSION -- a control that dropped the import, or a rename that lost it -- refuses, by
# name. Raise it on a lane's word when a fall is worth locking in; never lower it.
#
# Run from anywhere; the root is found by upward walk.
#   sh tools/fixtures/p/plant_adoption_scan.sh          # the counts
#   sh tools/fixtures/p/plant_adoption_scan.sh --list   # ... and every control not yet sourcing

set -eu

# Seated at 13 on `20260907.180000`, the count standing when the equality became a floor. The
# adoption history a hand used to record by raising this number lives in the witness header.
FLOOR=13

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

floor_held=yes
[ "$sourcing" -ge "$FLOOR" ] || floor_held=no

echo "controls=$controls"
echo "sourcing=$sourcing"
echo "remainder=$remainder"
echo "adoption_floor=$FLOOR"
echo "adoption_floor_held=$floor_held"

# The arithmetic is stated so a reader can check the reading rather than trust it. A scan whose
# parts do not sum to its whole has measured something other than what it named. It is asked FIRST,
# because a reading that does not sum has measured something other than adoption, and a floor over
# such a number would refuse or welcome for a reason nobody could act on.
if [ "$((sourcing + remainder))" -ne "$controls" ]; then
  echo "verdict=unbalanced"
  exit 1
fi

if [ "$floor_held" = no ]; then
  echo "verdict=adoption_regressed"
  echo "refused: $sourcing controls source the plant law where $FLOOR did -- an import was lost, never merely unadded" >&2
  exit 1
fi

echo "verdict=ok"
exit 0
