#!/bin/sh
# tools/fixtures/b/build_target_race_probe.sh -- does a build into a shared path actually hurt?
#
#   sh tools/fixtures/b/build_target_race_probe.sh
#
# WHY A PROBE RATHER THAN A GUARD. `tools/fixtures/b/build_target_scan.sh` counts how many rostered
# guards build into a fixed path in the tree. That count is worth something only if a shared build
# target genuinely breaks a concurrent reader, and the argument for it is easy to make and easy to
# get wrong: a compiler that emitted its output by writing a temporary and renaming it over the
# target would make the whole exposure imaginary, since a rename is atomic and a reader would see
# either the old file or the new one and never a half of either.
#
# SO IT IS MEASURED HERE RATHER THAN ASSUMED. Read `20260912` on this pier, against
# `vendor/zig-toolchain/zig`: a rebuild leaves the output file's INODE UNCHANGED, which is a write
# THROUGH the existing file rather than a replacement of it. Everything below follows from that one
# fact, and if a future toolchain starts renaming, this probe is where that shows.
#
# THE LOCK THAT EXISTS IS ON THE OTHER AXIS, AND THE READINGS SAY SO. `rye build` holds
# `.rye-build.lock` from the first shadow write to the last delete -- REDS %281, held by
# tools/r/rye_build_lock_reach_witness.rish -- so builds launched from one working directory
# serialize. The `three_writers` phase therefore does not race; the three go in turn. `one_writer`,
# where no build race exists at all, is the worse reading of the two, because one uninterrupted
# build holds the output open longer than three taking turns. Nothing serializes a build against a
# RUN, and that is the gap these numbers price.
#
# IT REPORTS AND IS NOT ROSTERED, ON PURPOSE. The reading is timing-dependent, and a
# timing-dependent guard on the roster is a guard that answers differently on one unchanged tree --
# which is REDS %700, the very fault this family was opened for. Adding a flapping guard to measure
# flapping would be the joke writing itself. A hand runs this when the question comes up, and the
# ratchets in the scan are what stand.
#
# FOUR READINGS, EACH A COUNT OF FAILED EXECUTIONS OUT OF `ROUNDS`:
#   untouched  -- the reader's own path is written by nobody, while three builds write three others
#   one_writer -- one build writes the reader's path
#   three_writers -- three builds write the reader's path
# and `inode_stable`, which says whether the emit wrote through the file or replaced it.
set -u

ROUNDS=${BUILD_TARGET_ROUNDS:-400}
ZIG=${RYE_ZIG:-vendor/zig-toolchain/zig}
RYE=${BUILD_TARGET_RYE:-rye/bin/rye}

[ -x "$RYE" ] || { echo "detail: no rye at $RYE" >&2; echo "probe_verdict=no_rye"; exit 2; }
[ -x "$ZIG" ] || { echo "detail: no zig at $ZIG" >&2; echo "probe_verdict=no_zig"; exit 2; }
root=$(pwd)

pen=$(mktemp -d) || { echo "probe_verdict=no_pen"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

# ONE TINY PROGRAM, FOUR SPELLINGS. Each prints a different line, so a reader can tell which build
# won a shared target -- and the sources differ, so the compiler's cache cannot short-circuit a
# rebuild and quietly turn a race into a no-op.
make_src() {
  cat > "$pen/$1.rye" <<EOF
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() void {
    // invariant: exactly one known line is printed, so a truncated binary is legible as a failure.
    print("$1\n", .{});
    // invariant: the program always reaches its end, so a nonzero exit means the FILE was wrong.
    assert(true);
}
EOF
}

build() { ( cd "$root" && env RYE_ZIG="$ZIG" "$RYE" build "$pen/$1.rye" -femit-bin="$2" ) >/dev/null 2>&1; }

read_loop() {
  # read_loop <binary> <out>; execute it ROUNDS times and count the executions that failed
  i=0
  fails=0
  while [ "$i" -lt "$ROUNDS" ]; do
    "$1" >/dev/null 2>&1 || fails=$((fails + 1))
    i=$((i + 1))
  done
  echo "$fails" > "$2"
}

# EVERY PHASE GETS ITS OWN SOURCE, BUILT ONCE AND NEVER BEFORE. A warm compiler cache turns a
# rebuild into a fast copy, and a fast copy shrinks the window a reader can fall into -- which read
# `one_writer=0` on the probe's first draft while a hand's run of the same shape read 360. A cache
# hit is a real thing that happens, and it is not the thing being measured here.
for n in reader sep_a sep_b sep_c solo tri_a tri_b tri_c; do make_src "$n"; done

build reader "$pen/reader"
[ -x "$pen/reader" ] || { echo "detail: the probe's own build failed" >&2; echo "probe_verdict=no_build"; exit 2; }

# THE INODE READING, FIRST, BECAUSE EVERY OTHER READING RESTS ON IT.
before=$(ls -i "$pen/reader" | awk '{print $1}')
build reader "$pen/reader"
after=$(ls -i "$pen/reader" | awk '{print $1}')
if [ "$before" = "$after" ]; then inode_stable=yes; else inode_stable=no; fi

# A -- the reader's own path is written by nobody.
for n in sep_a sep_b sep_c; do build "$n" "$pen/out_$n" & done
read_loop "$pen/reader" "$pen/untouched"
wait
untouched=$(cat "$pen/untouched")

# B -- one build writes the reader's path.
read_loop "$pen/reader" "$pen/one_writer" &
rd=$!
build solo "$pen/reader"
wait $rd
one_writer=$(cat "$pen/one_writer")

build reader "$pen/reader"

# C -- three builds write the reader's path.
read_loop "$pen/reader" "$pen/three_writers" &
rd=$!
for n in tri_a tri_b tri_c; do build "$n" "$pen/reader" & done
wait $rd
wait
three_writers=$(cat "$pen/three_writers")

echo "rounds=$ROUNDS"
echo "inode_stable=$inode_stable"
echo "untouched=$untouched"
echo "one_writer=$one_writer"
echo "three_writers=$three_writers"

# THE VERDICT NAMES WHAT WAS SEEN, AND NEITHER ANSWER IS A FAILURE OF THE PROBE. `hazard_real` is
# the state this tree stands in today. `hazard_absent` would be good news -- a toolchain that
# emits atomically -- and it is worth hearing rather than hiding.
if [ "$untouched" -ne 0 ]; then
  echo "probe_verdict=noisy"
elif [ "$one_writer" -gt 0 ] || [ "$three_writers" -gt 0 ]; then
  echo "probe_verdict=hazard_real"
else
  echo "probe_verdict=hazard_absent"
fi
exit 0
