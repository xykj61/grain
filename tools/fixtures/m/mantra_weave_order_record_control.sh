#!/bin/sh
# tools/fixtures/m/mantra_weave_order_record_control.sh -- the order record, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_order_record_witness.rye asserts that the
# `mantra-weave-20260916.101910` record -- the one every store written since `20260916` holds --
# goes out through `Weave.to_order_record` and comes back through `Weave.from_order_record`
# without a field moving, and that every one of the six fields a row publishes is actually READ
# by the comparison. This control copies the module and its witness into a throwaway pen,
# changes ONE thing in the copy, and watches the witness answer with a non-zero exit.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye and its witnesses sit side by side here.
#
# TWO KINDS OF LEG, AND THE SECOND IS THE MEASUREMENT. The breaks below must exit non-zero.
# The three `_blind` legs must exit ZERO, and they are what says this guard was worth building:
# with `from_order_record` parsing `site` where `run` was written, the two rostered weave guards
# closest to this record -- tools/m/mantra_weave_merge_witness.rish and
# tools/m/mantra_weave_apply_witness.rish -- both still reach GREEN, because neither reads the
# record at all. A repair proven only by its own new guard going red is a repair whose value is
# asserted; a repair whose fault is shown walking past every standing guard is a repair whose
# value is measured.
#
# THE PHASES:
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   row_int_blind  -- `row_eql`'s integer arm never refuses, so five of the six fields go
#                     unread. Claim 1 answers.
#   row_text_blind -- `row_eql`'s text arm never refuses, so the line's own text goes unread.
#                     Claim 1 answers, and this is the field a document comparison DOES see --
#                     which is why the other five are the ones that needed a guard.
#   rows_blind     -- `order_record_eql` compares the counters and walks past every row. Claims
#                     2 through 4 and claim 7 answer.
#   pos_blind      -- the `next_pos` comparison is deleted. Claim 6 answers.
#   run_blind      -- the `next_run` comparison is deleted, read apart from `next_pos` because
#                     one check standing for two counters is a check that proves one.
#   count_moved    -- `order_row_fields` is set one below the struct's own field count, so the
#                     comptime assert inside `order_record_eql` refuses at BUILD time. This is
#                     the wall that stops a field being published without a stated comparison,
#                     and it is the half of the repair no runtime leg can show.
#   lower_site     -- `to_order_record` writes site 0 rather than the line's, so a merged
#                     history is written back one-handed.
#   lower_ord      -- `to_order_record` writes the position as the order key, which is the exact
#                     fault the order key was added to end (REDS %680): a replacement written
#                     this way lands at the end of its document.
#   lift_swap      -- `from_order_record` reads `site` where `run` was written and `run` where
#                     `site` was. THE CENTREPIECE. Six fields still cross the record, the arity
#                     is untouched, the header is untouched, and in a single-site store the
#                     document renders identically -- so this is the fault the standing header
#                     check, row-count check and document comparison are each blind to.
#   merge_blind    -- the same swapped module, under the rostered merge witness. Exit 0.
#   apply_blind    -- the same swapped module, under the rostered apply witness. Exit 0.
#
# EXPECTED: clean_exit=0, merge_blind_exit=0, apply_blind_exit=0, every other phase non-zero.
#
# Driven by tools/m/mantra_weave_order_record_witness.rish. Run from the repository root.

set -eu

# The plant law, imported rather than restated: `plant_apply` rewrites a pen file through a sed
# program and refuses by name when the program matched nothing, so a line that moves in the module
# reds this control instead of quietly handing a phase an unmutated file (REDS %519). Root by
# upward walk (seated 20260828), so the letter fold's depth is never spelled here.
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
. "$_fd_root/tools/fixtures/p/plant.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
module="$root/mantra/src/weave.rye"
witness="$root/mantra/src/weave_order_record_witness.rye"
merge_witness="$root/mantra/src/weave_merge_witness.rye"
apply_witness="$root/mantra/src/weave_apply_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply an optional sed program to the module copy, then build
# and run the named witness. Echoes the exit code and nothing else.
run_pen() {
  name="$1"
  program="$2"
  root_file="$3"
  pen="$work/$name"
  mkdir -p "$pen"
  cp "$module" "$pen/weave.rye"
  cp "$witness" "$pen/weave_order_record_witness.rye"
  cp "$merge_witness" "$pen/weave_merge_witness.rye"
  cp "$apply_witness" "$pen/weave_apply_witness.rye"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the
    # phase reads the UNMUTATED module's exit code -- 0, indistinguishable from a
    # law that holds (REDS %519).
    if ! plant_apply "$pen/weave.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build "$root_file" \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

own="weave_order_record_witness.rye"

# The three field plants are ADDRESSED to their own function rather than matched on their own
# text, because `.site = line.site,` and `.ord = line.ord,` each stand more than once in this
# module -- in the writes, in `merge`, and in `annotate`. A plant rewriting all of them would be
# testing several functions at once and reporting one number.
lower_range='/pub fn to_order_record(/,/^    }$/'
lift_range='/pub fn from_order_record(/,/^    }$/'

clean_exit="$(run_pen clean '' "$own")"
row_int_blind_exit="$(run_pen row_int_blind 's/^            \.int => if (lhs != rhs) return false,$/            .int => if (lhs != lhs) return false,/' "$own")"
row_text_blind_exit="$(run_pen row_text_blind 's/^                if (!std\.mem\.eql(u8, lhs, rhs)) return false;$/                if (!std.mem.eql(u8, lhs, lhs)) return false;/' "$own")"
rows_blind_exit="$(run_pen rows_blind '/^        if (!row_eql(OrderRow, left, right)) return false;$/d' "$own")"
pos_blind_exit="$(run_pen pos_blind '/^    if (a\.next_pos != b\.next_pos) return false;$/d' "$own")"
run_blind_exit="$(run_pen run_blind '/^    if (a\.next_run != b\.next_run) return false;$/d' "$own")"
count_moved_exit="$(run_pen count_moved 's/^pub const order_row_fields = 6;$/pub const order_row_fields = 5;/' "$own")"
lower_site_exit="$(run_pen lower_site "${lower_range} s/\.site = line\.site,/.site = 0,/" "$own")"
lower_ord_exit="$(run_pen lower_ord "${lower_range} s/\.ord = line\.ord,/.ord = line.pos,/" "$own")"

# The one swap, planted once and read by three witnesses: this guard, and the two rostered weave
# guards closest to the record. Only the first is supposed to notice.
swap_program="${lift_range} s/\.site = row\.site,/.site = row.run,/; ${lift_range} s/\.run = row\.run,/.run = row.site,/"
lift_swap_exit="$(run_pen lift_swap "$swap_program" "$own")"
merge_blind_exit="$(run_pen merge_blind "$swap_program" "weave_merge_witness.rye")"
apply_blind_exit="$(run_pen apply_blind "$swap_program" "weave_apply_witness.rye")"

report="$(
echo "phase=clean";          echo "clean_exit=$clean_exit"
echo "phase=row_int_blind";  echo "row_int_blind_exit=$row_int_blind_exit"
echo "phase=row_text_blind"; echo "row_text_blind_exit=$row_text_blind_exit"
echo "phase=rows_blind";     echo "rows_blind_exit=$rows_blind_exit"
echo "phase=pos_blind";      echo "pos_blind_exit=$pos_blind_exit"
echo "phase=run_blind";      echo "run_blind_exit=$run_blind_exit"
echo "phase=count_moved";    echo "count_moved_exit=$count_moved_exit"
echo "phase=lower_site";     echo "lower_site_exit=$lower_site_exit"
echo "phase=lower_ord";      echo "lower_ord_exit=$lower_ord_exit"
echo "phase=lift_swap";      echo "lift_swap_exit=$lift_swap_exit"
echo "phase=merge_blind";    echo "merge_blind_exit=$merge_blind_exit"
echo "phase=apply_blind";    echo "apply_blind_exit=$apply_blind_exit"
)"
printf '%s\n' "$report"

# THE PEN COUNTS ITS OWN LEGS OUT LOUD, for the reason its siblings give: a control that merely
# finishes proves nothing about how much of it ran. `legs_expected` is declared beside the phase
# list and asserted by the witness, so a deleted leg reds both.
legs_expected=12
legs_ran="$(printf '%s\n' "$report" | grep -c '_exit=')"
echo "legs_expected=$legs_expected"
echo "legs_ran=$legs_ran"

# TWO READINGS AS WORDS RATHER THAN NUMBERS, because an exit code read by substring is a reading
# that matches its own prefix: `lift_swap_exit=134` contains `lift_swap_exit=1`, so a witness
# asserting the second would welcome any three-digit code and call it the one it named. A word
# cannot be half-matched.
centrepiece_caught=no
[ "$lift_swap_exit" = 0 ] || centrepiece_caught=yes
echo "centrepiece_caught=$centrepiece_caught"
blindness_held=no
if [ "$merge_blind_exit" = 0 ] && [ "$apply_blind_exit" = 0 ]; then blindness_held=yes; fi
echo "blindness_held=$blindness_held"
count_wall_caught=no
[ "$count_moved_exit" = 0 ] || count_wall_caught=yes
echo "count_wall_caught=$count_wall_caught"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every other reading
# below is a number and this one is a word.
for reading in "$clean_exit" "$row_int_blind_exit" "$row_text_blind_exit" "$rows_blind_exit" \
               "$pos_blind_exit" "$run_blind_exit" "$count_moved_exit" "$lower_site_exit" \
               "$lower_ord_exit" "$lift_swap_exit" "$merge_blind_exit" "$apply_blind_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$legs_ran" -eq "$legs_expected" ] || verdict=leg_count_disagrees
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  # The two blindness legs, asserted as hard as every break: if the swapped module ever RED a
  # sibling witness, the measurement this control reports would be false and the reader would
  # never know.
  [ "$merge_blind_exit" -eq 0 ] || verdict=merge_blind_noticed
  [ "$apply_blind_exit" -eq 0 ] || verdict=apply_blind_noticed
  for broken in "$row_int_blind_exit" "$row_text_blind_exit" "$rows_blind_exit" \
                "$pos_blind_exit" "$run_blind_exit" "$count_moved_exit" \
                "$lower_site_exit" "$lower_ord_exit" "$lift_swap_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
