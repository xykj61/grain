#!/bin/sh
# tools/fixtures/m/mantra_weave_v1_lift_control.sh -- the lift, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_v1_lift_witness.rye asserts that `Weave.from_v1` reads an
# elder `mantra-weave-v1` record as a weave of one hand, without moving a byte on disk: the
# lifted document is the elder document line for line, identity and parity survive, a later
# hand's edit follows the whole elder block, and four shapes are refused by name. This control
# copies the module and its witness into a throwaway pen, changes ONE thing in the copy, and
# watches the witness answer with a non-zero exit. Each break is shown from both sides, so a
# real refusal stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye and its witness sit side by side here.
#
# EIGHTEEN PHASES -- fourteen over the Rye witness, four over the head scan. Three are
# innocence legs that must exit 0 (clean, bound_shrunk, head_clean); the other fifteen are
# breaks that must not. The count is declared once, as `legs_expected` beside the readings at
# the foot, counted at runtime as `legs_ran`, and asserted by the witness -- so a leg deleted
# here reds rather than passing with less proof than the run before it.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   site           -- a lifted line is stamped with a site of its own rather than `v1_site`,
#                     so the record stops being one hand's history. Claim 1 answers.
#   run            -- a lifted line is stamped with its own run, so the elder block stops
#                     being one block. Claim 1 answers, and claim 5 behind it.
#   next_run       -- the lifted weave hands the next edit run 0 rather than 1, so a later
#                     hand's lines share a run with the elder document and are ordered against
#                     it by the site tie instead of following it. Claims 1 and 5 answer.
#   next_pos       -- the position floor is left at the last position rather than one above
#                     it, so the next edit would reissue a name the record already holds. The
#                     module's own postcondition assert answers first, which is the point:
#                     the lift proves its own counters rather than trusting them.
#   order_check    -- the rise check is deleted, so a record whose positions fall is lifted
#                     instead of refused. Claims 7 and 8 answer, and this is the refusal the
#                     elder reader has never had.
#   gen_check      -- the generation floor is deleted, so a row at generation zero lifts as a
#                     line that predates its weave. Claim 9 answers.
#   parity         -- the lift copies the row's generation as 1 rather than as written, so a
#                     deleted line comes back present. Claims 1 and 3 answer.
#   bound_shrunk   -- max_weave_lines drops from 1<<20 to 8, and that is the only change.
#                     Staying GREEN here is what makes the two phases below attributable to
#                     what they break rather than to the shrink. At 8 every plant still fits:
#                     the widest record the witness lifts is three rows.
#   bound_removed  -- shrunk, with the edge check deleted. Claim 10 answers.
#   bound_misnamed -- shrunk, check intact, refusing under the wrong error name.
#   ceiling_removed -- `from_v1`'s counter-ceiling check is deleted, so a row at the u32
#                     ceiling lifts and `next_pos = row.pos + 1` overflows. Claim 11 answers,
#                     and the answer is the original panic naming itself.
#   ceiling_misnamed -- that check intact, refusing under the wrong error name, so a refusal
#                     proven only by its direction stays tellable from one proven by name.
#   apply_ceiling  -- `apply`'s position-counter guard is made unreachable, so the sparse lift
#                     -- two rows at 0 and max-1, two lines against a bound of a million --
#                     meets the counter at the ceiling on its next insert. Claim 12 answers,
#                     and it is the case the LINE bound cannot see.
#
# THE LAST FOUR READ A DIFFERENT INSTRUMENT, and one of them is why this control exists in the
# shape it does. tools/fixtures/m/mantra_weave_head_scan.sh holds the module head to the
# module's own declarations, and until `20260908` it read an operation name as `[a-z_]+` --
# so `from_v1`, whose name carries a digit, was invisible to BOTH of its readings at once and
# the scan answered ok over a module publishing an operation its head could not have named.
# A census blind to a member reads exactly like a healthy file. The class is widened now, and
# the digit leg below is the regression that holds it there.
#   head_clean     -- the unmutated copy reads ok, exit 0. The head scan's own innocence leg.
#   head_missing   -- the head's `merge` line is deleted, so an operation stands unnamed.
#   head_digit     -- the head's `from_v1` line is deleted. The same direction as the leg
#                     above, aimed at the name shape that was unreadable, so a narrowing of
#                     the class reds here rather than in a year.
#   head_stale     -- a head line names an operation the module does not publish.
#
# EXPECTED: clean_exit=0, bound_shrunk_exit=0, head_clean_exit=0, every other phase non-zero,
# and legs_ran equal to legs_expected.
#
# Driven by tools/m/mantra_weave_v1_lift_witness.rish. Run from the repository root.

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
witness="$root/mantra/src/weave_v1_lift_witness.rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Build a pen from the real sources, apply an optional sed program to the module copy,
# then build and run. Echoes the exit code and nothing else.
run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  cp "$module" "$pen/weave.rye"
  cp "$witness" "$pen/weave_v1_lift_witness.rye"
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
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_v1_lift_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

# The head scan reads a file rather than building one, so its pens skip the compiler.
run_head_pen() {
  name="$1"
  program="$2"
  pen="$work/head_$name"
  mkdir -p "$pen"
  cp "$module" "$pen/weave.rye"
  if [ -n "$program" ]; then
    if ! plant_apply "$pen/weave.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  sh "$root/tools/fixtures/m/mantra_weave_head_scan.sh" "$pen/weave.rye" >/dev/null 2>&1 || code=$?
  echo "$code"
}

shrink='s/pub const max_weave_lines: u32 = 1 << 20;/pub const max_weave_lines: u32 = 8;/'

clean_exit="$(run_pen clean '')"
site_exit="$(run_pen site 's/^                \.site = v1_site,$/                .site = 7,/')"
run_exit="$(run_pen run 's/^                \.run = v1_run,$/                .run = 7,/')"
next_run_exit="$(run_pen next_run 's/\.next_pos = next_pos, \.next_run = 1 };/.next_pos = next_pos, .next_run = 0 };/')"
next_pos_exit="$(run_pen next_pos 's/^            next_pos = row\.pos + 1;$/            next_pos = row.pos;/')"
order_check_exit="$(run_pen order_check '/if (seen_any and row\.pos <= previous_pos) return WeaveError\.V1PositionsDoNotRise;/d')"
gen_check_exit="$(run_pen gen_check '/if (row\.gen == 0) return WeaveError\.V1GenerationBelowOne;/d')"
parity_exit="$(run_pen parity 's/^                \.gen = row\.gen,$/                .gen = 1,/')"
shrunk_exit="$(run_pen bound_shrunk "$shrink")"
removed_exit="$(run_pen bound_removed "$shrink; /if (rows\.len > max_weave_lines) return WeaveError\.TooManyLines;/d")"
misnamed_exit="$(run_pen bound_misnamed "$shrink; s/if (rows\.len > max_weave_lines) return WeaveError\.TooManyLines;/if (rows.len > max_weave_lines) return WeaveError.V1GenerationBelowOne;/")"

# The three below hold the counter ceiling the module gained on `20260912.003734`. Until this
# lap the pen held none of them: the module proved two new refusals and the pen could not tell
# a live check from a deleted one -- a half-heard pen, the shape a peer named one room over.
ceiling_removed_exit="$(run_pen ceiling_removed '/if (row\.pos >= max_weave_lines) return WeaveError\.CounterPastCeiling;/d')"
ceiling_misnamed_exit="$(run_pen ceiling_misnamed 's/if (row\.pos >= max_weave_lines) return WeaveError\.CounterPastCeiling;/if (row.pos >= max_weave_lines) return WeaveError.V1GenerationBelowOne;/')"
apply_ceiling_exit="$(run_pen apply_ceiling 's/^        if (diff\.inserts\.len > max_weave_lines - self\.next_pos) {$/        if (false) {/')"

head_clean_exit="$(run_head_pen clean '')"
head_missing_exit="$(run_head_pen missing '/^\/\/!   weave\.merge(/d')"
head_digit_exit="$(run_head_pen digit '/^\/\/!   Weave\.from_v1(/d')"
head_stale_exit="$(run_head_pen stale 's|^//!   weave\.merge(alloc, w)    -- one weave from two, by union and max|&\n//!   weave.dissolve(alloc)    -- an operation the module does not publish|')"

report="$(
echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=site"
echo "site_exit=$site_exit"
echo "phase=run"
echo "run_exit=$run_exit"
echo "phase=next_run"
echo "next_run_exit=$next_run_exit"
echo "phase=next_pos"
echo "next_pos_exit=$next_pos_exit"
echo "phase=order_check"
echo "order_check_exit=$order_check_exit"
echo "phase=gen_check"
echo "gen_check_exit=$gen_check_exit"
echo "phase=parity"
echo "parity_exit=$parity_exit"
echo "phase=bound_shrunk"
echo "bound_shrunk_exit=$shrunk_exit"
echo "phase=bound_removed"
echo "bound_removed_exit=$removed_exit"
echo "phase=bound_misnamed"
echo "bound_misnamed_exit=$misnamed_exit"
echo "phase=ceiling_removed"
echo "ceiling_removed_exit=$ceiling_removed_exit"
echo "phase=ceiling_misnamed"
echo "ceiling_misnamed_exit=$ceiling_misnamed_exit"
echo "phase=apply_ceiling"
echo "apply_ceiling_exit=$apply_ceiling_exit"
echo "phase=head_clean"
echo "head_clean_exit=$head_clean_exit"
echo "phase=head_missing"
echo "head_missing_exit=$head_missing_exit"
echo "phase=head_digit"
echo "head_digit_exit=$head_digit_exit"
echo "phase=head_stale"
echo "head_stale_exit=$head_stale_exit"

)"
printf '%s\n' "$report"

# THE PEN COUNTS ITS OWN LEGS OUT LOUD. `fail=0` is what an empty pen prints too, so a
# control that merely finishes proves nothing about how much of it ran. `legs_ran` counts the
# readings this run actually emitted; `legs_expected` is declared beside the phase list above
# and asserted by the witness, so deleting a leg reds both the control and its witness rather
# than passing quietly with less proof than yesterday.
legs_expected=18
legs_ran="$(printf '%s\n' "$report" | grep -c '_exit=')"
echo "legs_expected=$legs_expected"
echo "legs_ran=$legs_ran"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every
# other reading below is a number and this one is a word.
for reading in "$clean_exit" "$site_exit" "$run_exit" "$next_run_exit" "$next_pos_exit" \
               "$order_check_exit" "$gen_check_exit" "$parity_exit" "$shrunk_exit" \
               "$removed_exit" "$misnamed_exit" "$ceiling_removed_exit" \
               "$ceiling_misnamed_exit" "$apply_ceiling_exit" "$head_clean_exit" \
               "$head_missing_exit" "$head_digit_exit" "$head_stale_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$legs_ran" -eq "$legs_expected" ] || verdict=leg_count_disagrees
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  [ "$shrunk_exit" -eq 0 ] || verdict=shrink_not_innocent
  [ "$head_clean_exit" -eq 0 ] || verdict=head_clean_failed
  for broken in "$site_exit" "$run_exit" "$next_run_exit" "$next_pos_exit" \
                "$order_check_exit" "$gen_check_exit" "$parity_exit" \
                "$removed_exit" "$misnamed_exit" "$ceiling_removed_exit" \
                "$ceiling_misnamed_exit" "$apply_ceiling_exit" \
                "$head_missing_exit" "$head_digit_exit" "$head_stale_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
