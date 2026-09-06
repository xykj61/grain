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
# SEVEN PHASES.
#   clean          -- the unmutated copy reaches GREEN, exit 0. This leg is what lets every
#                     other phase read as the break speaking rather than the pen.
#   join           -- `@max(held.gen, line.gen)` becomes `line.gen`, so the last weave read
#                     wins where the higher count should. Commutativity goes with it.
#   order          -- the sort inside merge is deleted. Measured `20260906`: claims 1 through
#                     7 all still print GREEN, and the run stops inside claim 8, at merge's own
#                     strictly-increasing postcondition (weave.rye line 272). Claim 8 exists
#                     for exactly this. Every other merge in the witness has a union already
#                     in position order, so the sort stayed unreachable until a leg was
#                     written to reach it.
#   text           -- the shared-position text comparison is neutered, so two branches that
#                     both insert join where they should be refused.
#   bound_shrunk   -- max_weave_lines drops from 1<<20 to 8, and that is the only change.
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
# EXPECTED: clean_exit=0, bound_shrunk_exit=0, and every other phase non-zero.
#
# Driven by tools/m/mantra_weave_merge_witness.rish. Run from the repository root.

set -eu

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
    sed "$program" "$pen/weave.rye" > "$pen/weave.tmp"
    cat "$pen/weave.tmp" > "$pen/weave.rye"
    rm -f "$pen/weave.tmp"
  fi
  code=0
  ( cd "$pen" && env RYE_ZIG="$zig" "$rye" build weave_merge_witness.rye \
      -femit-bin="$pen/run" >/dev/null 2>&1 ) || code=$?
  if [ "$code" -eq 0 ]; then
    "$pen/run" >/dev/null 2>&1 || code=$?
  fi
  echo "$code"
}

shrink='s/pub const max_weave_lines: u32 = 1 << 20;/pub const max_weave_lines: u32 = 8;/'

clean_exit="$(run_pen clean '')"
join_exit="$(run_pen join 's/held.gen = @max(held.gen, line.gen);/held.gen = line.gen;/')"
order_exit="$(run_pen order '/std.mem.sort(Line, out.items/,/}.less_than);/d')"
text_exit="$(run_pen text 's/if (!std.mem.eql(u8, held.text, line.text)) {/if (false) {/')"
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
echo "phase=bound_shrunk"
echo "bound_shrunk_exit=$shrunk_exit"
echo "phase=bound_removed"
echo "bound_removed_exit=$removed_exit"
echo "phase=bound_misnamed"
echo "bound_misnamed_exit=$misnamed_exit"

verdict=ok
[ "$clean_exit" -eq 0 ] || verdict=clean_failed
[ "$shrunk_exit" -eq 0 ] || verdict=shrink_not_innocent
for broken in "$join_exit" "$order_exit" "$text_exit" "$removed_exit" "$misnamed_exit"; do
  [ "$broken" -ne 0 ] || verdict=break_not_caught
done
echo "control_verdict=$verdict"
[ "$verdict" = ok ]
