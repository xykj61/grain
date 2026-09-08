#!/bin/sh
# tools/fixtures/m/mantra_weave_merge_control.sh -- the merge law, broken on purpose.
#
# WHAT THIS DOES. mantra/src/weave_merge_witness.rye asserts that merging two weaves is a
# join: commutative, associative, idempotent, and refusing by name. This control copies the
# module and its witness into a throwaway pen, changes ONE thing in the copy, and watches the
# witness answer with a non-zero exit. Each break is shown from both sides, so a real refusal
# stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own directory, so
# weave.rye and its witness sit side by side here. Everything reads from the filesystem
# alone, which makes a plain directory the honest pen.
#
# TEN PHASES -- two innocent, eight breaks.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   join           -- `@max(held.gen, line.gen)` becomes `line.gen`, so the last weave read
#                     wins where the higher count should. Commutativity goes with it.
#   order          -- the sort inside merge is deleted. Measured `20260906`: claims 1 through
#                     7 all still print GREEN, and the run stops inside claim 8, at merge's own
#                     strictly-increasing postcondition -- the `assert` on consecutive places
#                     in `merge`, named rather than cited by line, since a line number is a
#                     claim that goes stale on the next edit. Claim 8 exists for exactly this.
#                     Every other merge in the witness has a union already in place order, so
#                     the sort stayed unreachable until a leg was written to reach it.
#   text           -- the shared-position text comparison is neutered, so two branches that
#                     both insert join where they should be refused.
#   identity       -- LineId.eq narrows back to the position alone, the state that refused two
#                     branches before the site landed.
#   tiebreak       -- the site leaves Place.less_than, so two concurrent lines are never
#                     strictly ordered and the merge postcondition fires.
#   run_ignored    -- the run leaves Place.less_than and the position takes its seat, which is
#                     the elder order exactly; claim 10's paragraphs come back shuffled.
#   bound_shrunk   -- max_weave_lines drops from 1<<20 to 16, and that is the only change.
#                     Staying GREEN here is what makes the two phases below attributable to
#                     what they break rather than to the shrink.
#   bound_removed  -- shrunk, with the edge check deleted. The oversize union is admitted.
#   bound_misnamed -- shrunk, check intact, refusing under the wrong error name.
#
# WHY THE BOUND PHASES SHRINK IT. At 1<<20 an admitted union is half a million lines against
# half a million, and merge compares texts pairwise, so a full-size deletion would run for
# hours. Shrinking gets the same answer in milliseconds, and bound_shrunk keeps the shrink
# itself honest.
#
# WHY THE SHRINK IS 16 AND NOT 8. bound_shrunk must stay GREEN, so the ceiling has to sit above
# the largest union the witness's WELCOME claims build -- and claim 10 merges two branches of a
# three-line base plus a three-line block each, a union of twelve. It was 8 until 20260907, and
# the lap that added claim 10 read `shrink_not_innocent`: the shrink had stopped being innocent,
# which is exactly what that phase exists to say. 16 is the next power of two above twelve, and
# bound_refused still refuses at nine against nine, in milliseconds.
#
# EXPECTED: clean_exit=0, bound_shrunk_exit=0, and every other phase non-zero.
#
# EIGHT BREAKS. `identity` narrows LineId.eq back to the position alone, which is the state
# that refused two branches before the site landed (20260906.210016); `tiebreak` drops the
# site from Place.less_than, so two concurrent lines are never strictly ordered and the merge
# postcondition fires; `run_ignored` drops the RUN from Place.less_than, which is the exact
# elder order -- position first, site second -- and it fires on claim 10, the paragraphs
# arriving whole. A control that does not plant the law a round added is a control that would
# not notice that law leaving.
#
# `tiebreak` HAD to be repointed on 20260907, and how it failed is worth the sentence: it aimed
# at `return self.site < other.site;` inside LineId.less_than, and when document order moved out
# of LineId and into Place, that line was still there and the sed still matched. So the plant
# landed, the bytes changed, `plant_apply`'s own matched-nothing refusal stayed quiet -- and the
# phase exited 0, because the function it broke no longer decided anything the witness reads.
# A plant can miss in TWO ways: matching nothing, which %519 named and `cmp -s` catches, and
# matching something that has stopped mattering, which only the verdict loop's demand that every
# break be caught can see. It saw it: `break_not_caught`.
#
# Driven by tools/m/mantra_weave_merge_witness.rish. Run from the repository root.

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
witness="$root/mantra/src/weave_merge_witness.rye"
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
  cp "$witness" "$pen/weave_merge_witness.rye"
  if [ -n "$program" ]; then
    # A plant that matched nothing leaves the pen byte for byte identical, so the
    # phase reads the UNMUTATED module's exit code -- 0, indistinguishable from a
    # law that holds. Every plant here names a literal line of weave.rye, and a
    # line that is edited stops being that literal. `plant_apply` refuses by name,
    # and it is imported rather than written here so the next control inherits it.
    if ! plant_apply "$pen/weave.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_merge_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

shrink='s/pub const max_weave_lines: u32 = 1 << 20;/pub const max_weave_lines: u32 = 16;/'

clean_exit="$(run_pen clean '')"
join_exit="$(run_pen join 's/held.gen = @max(held.gen, line.gen);/held.gen = line.gen;/')"
order_exit="$(run_pen order '/std.mem.sort(Line, out.items/,/}.less_than);/d')"
text_exit="$(run_pen text 's/if (!std.mem.eql(u8, held.text, line.text)) {/if (false) {/')"
# Identity is a PAIR. Narrow it back to the position alone and two branches'
# concurrent inserts answer to one name again -- which is the exact state this
# module refused before the site landed, so a plant of it is the law of this
# movement shown from the failing side.
#
# The plant names `LineId.order` rather than `LineId.eq`, and the move is the
# whole reason this comment is longer than its neighbours. Until `20260907` the
# fold walked the held side calling `eq`, so narrowing `eq` broke the merge.
# The fold searches now, which reads `order`; `eq` and `less_than` are both
# derived from that one function, so `order` is where the pair is either read
# or lost. A plant left on `eq` would have gone on matching a real line and
# proving nothing -- which is the shape a control cannot afford, since it is
# indistinguishable from a law that holds.
identity_exit="$(run_pen identity 's/        return std.math.order(self.site, other.site);/        return .eq;/')"
# The site orders as well as separates. Drop the tiebreak from the DOCUMENT order
# -- Place.less_than, not LineId.less_than -- and two concurrent lines are never
# strictly ordered, so the merge postcondition fires.
tiebreak_exit="$(run_pen tiebreak 's/        if (self.site != other.site) return self.site < other.site;/        _ = other.site;/')"
# The run groups each hand's edit. Put the POSITION back in front of the site and
# the order is exactly what it was before this law landed -- position first, site
# second -- so two branches that each appended a paragraph come back shuffled and
# claim 10 fires. Deleting the run line alone would NOT do it: that leaves site
# first, which groups by hand and keeps the blocks whole for a different reason,
# and a plant that leaves the law satisfied proves nothing.
run_ignored_exit="$(run_pen run_ignored 's/        if (self.run != other.run) return self.run < other.run;/        if (self.pos != other.pos) return self.pos < other.pos;/')"
shrunk_exit="$(run_pen bound_shrunk "$shrink")"
removed_exit="$(run_pen bound_removed "$shrink; /if (self.lines.items.len + other.lines.items.len > max_weave_lines) {/,+2d")"
misnamed_exit="$(run_pen bound_misnamed "$shrink; s/            return WeaveError.TooManyLines;/            return WeaveError.PositionTextDisagrees;/")"

echo "phase=clean"
echo "clean_exit=$clean_exit"
echo "phase=join"
echo "join_exit=$join_exit"
echo "phase=order"
echo "order_exit=$order_exit"
echo "phase=text"
echo "text_exit=$text_exit"
echo "phase=identity"
echo "identity_exit=$identity_exit"
echo "phase=tiebreak"
echo "tiebreak_exit=$tiebreak_exit"
echo "phase=run_ignored"
echo "run_ignored_exit=$run_ignored_exit"
echo "phase=bound_shrunk"
echo "bound_shrunk_exit=$shrunk_exit"
echo "phase=bound_removed"
echo "bound_removed_exit=$removed_exit"
echo "phase=bound_misnamed"
echo "bound_misnamed_exit=$misnamed_exit"

verdict=ok
# A plant that matched nothing is read FIRST and by its own name, because every
# other reading below is a number and this one is a word.
for reading in "$clean_exit" "$join_exit" "$order_exit" "$text_exit" "$identity_exit" \
               "$tiebreak_exit" "$run_ignored_exit" "$shrunk_exit" "$removed_exit" \
               "$misnamed_exit"; do
  [ "$reading" != plant_matched_nothing ] || verdict=plant_matched_nothing
done
if [ "$verdict" = ok ]; then
  [ "$clean_exit" -eq 0 ] || verdict=clean_failed
  [ "$shrunk_exit" -eq 0 ] || verdict=shrink_not_innocent
  for broken in "$join_exit" "$order_exit" "$text_exit" "$identity_exit" "$tiebreak_exit" \
                "$run_ignored_exit" "$removed_exit" "$misnamed_exit"; do
    [ "$broken" -ne 0 ] || verdict=break_not_caught
  done
fi
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
