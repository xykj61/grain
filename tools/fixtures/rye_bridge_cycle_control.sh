#!/bin/sh
# rye_bridge_cycle_control.sh -- the Rye build bridge, asked the two questions its
# own recursion could not answer, on a throwaway corpus whose answer is known by
# construction.
#
# WHY A CONTROL AND NOT THE TREE. The tree holds no mutual `.rye` import today,
# so a scan of it would prove the bridge correct by proving nothing reached the
# fault. A corpus written for the question is the only honest ground: two files
# that import each other, and a chain longer than the bound.
#
# WHAT IT PROVES, on metal.
#
#   GREEN LEG -- two `.rye` files importing each other bridge, compile, and run.
#   Before `REDS %125` this segfaulted: the visited set was appended AFTER the
#   walk into a file's imports, so while a cycle was being traversed nothing was
#   ever marked seen and the recursion ran until the stack died. It is marked on
#   entry now, which is what a visited set must do to terminate on a cyclic graph.
#
#   ROOT-NAME LEG -- the file the walk STARTS from is reachable by name from one
#   of its own dependencies. The root once bridged to `foo.rye.zig` while every
#   dependency bridged to `foo.zig`, so a module importing the root asked the
#   toolchain for a file the bridge had never written. One file, one bridged name.
#
#   RED LEG -- an import chain deeper than `max_bridge_depth` refuses by NAME
#   (`BridgeTooDeep`) rather than exhausting the stack, so a pathological graph
#   meets a named error. TAME root rule 1: no unbounded recursion.
#
#   SWEPT LEG -- every staged `.zig` is cleared away afterward, so a bridge run
#   leaves the corpus exactly as it found it.
#
# No network, no key, no funds, no device. Everything happens in a temp directory
# that is removed on exit.

set -u

root=$(pwd)
rye_bin="$root/rye/bin/rye"
rye_lib="$root/rye/lib"
zig="$root/vendor/zig-toolchain/zig"

for needed in "$rye_bin" "$rye_lib" "$zig"; do
    if [ ! -e "$needed" ]; then
        echo "verdict=missing_toolchain needed=$needed"
        exit 1
    fi
done

work=$(mktemp -d) || { echo "verdict=no_tempdir"; exit 1; }
trap 'rm -rf "$work"' EXIT

# The bound the compiler names. Read from source rather than recited, since a
# number written into a comment drifts the moment the source moves (REDS %110).
bound=$(sed -n 's/^const max_bridge_depth: u32 = \([0-9]*\);.*/\1/p' "$root/rye/src/main.rye")
if [ -z "$bound" ]; then
    echo "verdict=bound_unreadable"
    exit 1
fi
echo "BRIDGE_BOUND max_bridge_depth=$bound read_from=rye/src/main.rye"

# ---------------------------------------------------------------- the green leg
# `over.rye` is the root and imports `under.rye`; `under.rye` imports `over.rye`
# straight back. Both legs at once: the cycle, and the cycle reaching the ROOT.
cat > "$work/over.rye" <<'RYE'
const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const under = @import("under.rye");

pub const greeting: u8 = 7;

pub fn main(init: std.process.Init) !u8 {
    _ = init;
    // invariant: the value crosses the cycle and comes back unchanged
    assert(under.echoed() == greeting);
    print("MUTUAL_OK {d}\n", .{under.echoed()});
    return 0;
}
RYE

cat > "$work/under.rye" <<'RYE'
const std = @import("std");
const assert = std.debug.assert;
const over = @import("over.rye");

pub fn echoed() u8 {
    // invariant: the root is readable from the file the root imports
    assert(over.greeting > 0);
    return over.greeting;
}
RYE

cd "$work" || { echo "verdict=no_workdir"; exit 1; }

build_out=$(env RYE_ZIG="$zig" RYE_LIB="$rye_lib" "$rye_bin" build over.rye -femit-bin=over.bin 2>&1)
build_code=$?
if [ "$build_code" -ne 0 ]; then
    echo "CYCLE_BUILD refused code=$build_code"
    echo "$build_out" | head -5
    echo "verdict=cycle_refused"
    exit 1
fi
echo "CYCLE_BUILD ok two_files_importing_each_other=yes root_reached_from_dependency=yes"

run_out=$(./over.bin 2>&1)
run_code=$?
if [ "$run_code" -ne 0 ] || [ "${run_out#*MUTUAL_OK}" = "$run_out" ]; then
    echo "CYCLE_RUN unexpected code=$run_code out=$run_out"
    echo "verdict=cycle_run_wrong"
    exit 1
fi
echo "CYCLE_RUN ok out=$run_out"

# --------------------------------------------------------------- the swept leg
left=$(ls ./*.zig 2>/dev/null | wc -l | tr -d ' ')
echo "STAGED_LEFTOVERS count=$left expected=0"
if [ "$left" -ne 0 ]; then
    echo "verdict=staging_not_swept"
    exit 1
fi

# ------------------------------------------------------------------ the red leg
# A chain one longer than the bound. Each link imports the next; the last is a
# leaf. The walk therefore descends `bound + 2` before it can stop, which the
# bound must refuse by name.
deep="$work/deep"
mkdir -p "$deep" || { echo "verdict=no_deepdir"; exit 1; }
links=$((bound + 2))
i=0
while [ "$i" -lt "$links" ]; do
    next=$((i + 1))
    if [ "$next" -lt "$links" ]; then
        printf 'const next = @import("m%d.rye");\npub fn depth() u32 { return next.depth() + 1; }\n' "$next" > "$deep/m$i.rye"
    else
        printf 'pub fn depth() u32 { return 0; }\n' > "$deep/m$i.rye"
    fi
    i=$next
done

cat > "$deep/root.rye" <<'RYE'
const std = @import("std");
const chain = @import("m0.rye");

pub fn main(init: std.process.Init) !u8 {
    _ = init;
    return @intCast(chain.depth() % 200);
}
RYE

cd "$deep" || { echo "verdict=no_deepdir"; exit 1; }
deep_out=$(env RYE_ZIG="$zig" RYE_LIB="$rye_lib" "$rye_bin" build root.rye -femit-bin=deep.bin 2>&1)
deep_code=$?
if [ "$deep_code" -eq 0 ]; then
    echo "DEEP_REFUSAL absent -- a chain of $links bridged where the bound is $bound"
    echo "verdict=bound_not_enforced"
    exit 1
fi
if [ "${deep_out#*deeper than}" = "$deep_out" ]; then
    echo "DEEP_REFUSAL unnamed code=$deep_code"
    echo "$deep_out" | head -5
    echo "verdict=refusal_unnamed"
    exit 1
fi
echo "DEEP_REFUSAL named chain=$links bound=$bound code=$deep_code"
echo "DEEP_REFUSAL says: $(echo "$deep_out" | grep 'deeper than' | head -1)"

echo "verdict=ok"
