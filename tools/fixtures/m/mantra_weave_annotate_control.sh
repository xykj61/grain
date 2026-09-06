#!/bin/sh
# tools/fixtures/m/mantra_weave_annotate_control.sh -- the reading, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_annotate_witness.rye asserts that `Weave.annotate` tells
# the truth about a merge: one Note per position in the union, both sides' generation counts
# carried, and a single word naming what each side did. This control copies the module and its
# witness into a throwaway pen, changes ONE thing in the copy, and watches the witness answer
# with a non-zero exit. Each break is shown from both sides, so a real refusal stays tellable
# from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye and its witness sit side by side here. Everything reads from the filesystem alone,
# which makes a plain directory the honest pen.
#
# THIRTEEN PHASES -- nine over the Rye witness, four over the head scan. Three are innocence
# legs that must exit 0 (clean, bound_shrunk, head_clean); the other ten are breaks that must not.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   derive         -- `Note.gen` returns `left_gen` instead of the max of the two counts, so
#                     the story stops agreeing with the merge it describes. Claim 4 is written
#                     for exactly this: a position the left has never seen derives 0 where the
#                     merge lands on 1.
#   unseen         -- a position only the right has seen is written with `left_gen = 1` rather
#                     than the reserved 0, so a line one side never met reads as agreed.
#   side           -- the higher count names the wrong side, so a delete on the left is
#                     credited to the right. Claims 3 and 5 both answer.
#   text           -- the shared-position text comparison is neutered, so two branches that
#                     both insert are read side by side where they should be refused. The line
#                     is written identically in merge's `union_into` and in annotate, so both
#                     are neutered; the claim that answers is annotate's own claim 6, and no
#                     other claim here hands merge a shared position the two sides disagree on.
#   order          -- the sort inside annotate is deleted. Every other claim reads weaves whose
#                     union is already position-ordered, because a per-weave counter hands out
#                     a contiguous run, so claim 8 is the only leg that reaches it.
#   bound_shrunk   -- max_weave_lines drops from 1<<20 to 8, and that is the only change.
#                     Staying GREEN here is what makes the two phases below attributable to
#                     what they break rather than to the shrink.
#   bound_removed  -- shrunk, with annotate's own edge check deleted. The check is addressed
#                     through the comment above it, so merge's identically-worded check one
#                     function up stays intact and the break stays attributable to annotate.
#                     Measured 20260906: what refuses then is `notes_from_right`'s own ceiling
#                     invariant, one step later -- 5 notes already written plus 5 incoming
#                     against a max of 8 -- rather than the witness reaching its
#                     `OversizeUnionNotRefused` return. Named here rather than left as a bare
#                     exit code: the module holds the bound twice, at the edge and inside each
#                     fold, and this phase proves the second holds when the first is gone.
#   bound_misnamed -- shrunk, check intact, refusing under the wrong error name.
#
# THE LAST FOUR READ A DIFFERENT INSTRUMENT. tools/fixtures/m/mantra_weave_head_scan.sh holds
# the module head to the module's own declarations, and a guard nobody has watched fail is a
# guard nobody has tested -- so it is broken here too, in the same pens, one direction each:
#   head_clean     -- the unmutated copy reads ok, exit 0. The head scan's own innocence leg.
#   head_missing   -- the head's `merge` line is deleted, so an operation stands unnamed.
#                     This is the exact state REDS %506 was booked for, replanted.
#   head_stale     -- a head line names `dissolve(alloc)`, which the module does not publish.
#   head_container -- `pub const Weave = struct {` is renamed, so the scan can no longer find
#                     the scope it counts in. It must say so rather than count zero and pass.
#
# WHY THE BOUND PHASES SHRINK IT. At 1<<20 an admitted union is half a million lines against
# half a million, and annotate compares texts pairwise, so a full-size deletion would run for
# hours. Shrinking gets the same answer in milliseconds, and bound_shrunk keeps the shrink
# itself honest. At 8 every ordinary plant still fits -- the widest union the witness builds is
# four lines against four -- so the shrink refuses nothing the other claims need.
#
# EXPECTED: clean_exit=0, bound_shrunk_exit=0, head_clean_exit=0, and every other phase
# non-zero.
#
# Driven by tools/m/mantra_weave_annotate_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
module="$root/mantra/src/weave.rye"
witness="$root/mantra/src/weave_annotate_witness.rye"
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
  cp "$witness" "$pen/weave_annotate_witness.rye"
  if [ -n "$program" ]; then
    sed "$program" "$pen/weave.rye" > "$pen/weave.tmp"
    cat "$pen/weave.tmp" > "$pen/weave.rye"
    rm -f "$pen/weave.tmp"
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_annotate_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

# The head scan reads a file rather than building one, so its pens skip the compiler. The
# scan is invoked from the repository root against the pen copy, which is why it takes the
# module path as an argument.
run_head_pen() {
  name="$1"
  program="$2"
  pen="$work/head_$name"
  mkdir -p "$pen"
  cp "$module" "$pen/weave.rye"
  if [ -n "$program" ]; then
    sed "$program" "$pen/weave.rye" > "$pen/weave.tmp"
    cat "$pen/weave.tmp" > "$pen/weave.rye"
    rm -f "$pen/weave.tmp"
  fi
  code=0
  sh "$root/tools/fixtures/m/mantra_weave_head_scan.sh" "$pen/weave.rye" >/dev/null 2>&1 || code=$?
  echo "$code"
}

shrink='s/pub const max_weave_lines: u32 = 1 << 20;/pub const max_weave_lines: u32 = 8;/'

clean_exit="$(run_pen clean '')"
derive_exit="$(run_pen derive 's/return @max(self.left_gen, self.right_gen);/return self.left_gen;/')"
unseen_exit="$(run_pen unseen 's/                    .left_gen = 0,/                    .left_gen = 1,/')"
side_exit="$(run_pen side 's/if (self.left_gen > self.right_gen) return .left_moved;/if (self.left_gen > self.right_gen) return .right_moved;/')"
text_exit="$(run_pen text 's/if (!std.mem.eql(u8, held.text, line.text)) {/if (false) {/g')"
order_exit="$(run_pen order '/std.mem.sort(Note, result/,/}.less_than);/d')"
shrunk_exit="$(run_pen bound_shrunk "$shrink")"
removed_exit="$(run_pen bound_removed "$shrink; /checking the sum checks the notes/,+4d")"
misnamed_exit="$(run_pen bound_misnamed "$shrink; /checking the sum checks the notes/,+4 s/TooManyLines/PositionTextDisagrees/")"

head_clean_exit="$(run_head_pen clean '')"
head_missing_exit="$(run_head_pen missing '/^\/\/!   weave\.merge(/d')"
head_stale_exit="$(run_head_pen stale 's|^//!   weave\.merge(alloc, w)    -- one weave from two, by union and max|&\n//!   weave.dissolve(alloc)    -- an operation the module does not publish|')"
head_container_exit="$(run_head_pen container 's/^pub const Weave = struct {/pub const Loom = struct {/')"

echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=derive"
echo "derive_exit=$derive_exit"
echo "phase=unseen"
echo "unseen_exit=$unseen_exit"
echo "phase=side"
echo "side_exit=$side_exit"
echo "phase=text"
echo "text_exit=$text_exit"
echo "phase=order"
echo "order_exit=$order_exit"
echo "phase=bound_shrunk"
echo "bound_shrunk_exit=$shrunk_exit"
echo "phase=bound_removed"
echo "bound_removed_exit=$removed_exit"
echo "phase=bound_misnamed"
echo "bound_misnamed_exit=$misnamed_exit"

verdict=ok
[ "$clean_exit" -eq 0 ] || verdict=clean_failed
[ "$shrunk_exit" -eq 0 ] || verdict=shrink_not_innocent
[ "$head_clean_exit" -eq 0 ] || verdict=head_clean_failed
for broken in "$derive_exit" "$unseen_exit" "$side_exit" "$text_exit" "$order_exit" \
              "$removed_exit" "$misnamed_exit" \
              "$head_missing_exit" "$head_stale_exit" "$head_container_exit"; do
  [ "$broken" -ne 0 ] || verdict=break_not_caught
done
echo "phase=head_clean"
echo "head_clean_exit=$head_clean_exit"
echo "phase=head_missing"
echo "head_missing_exit=$head_missing_exit"
echo "phase=head_stale"
echo "head_stale_exit=$head_stale_exit"
echo "phase=head_container"
echo "head_container_exit=$head_container_exit"

echo "control_verdict=$verdict"
[ "$verdict" = ok ]
