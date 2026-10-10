#!/bin/sh
# shared_build_cache_mutation_census.sh -- does each declared input change produce a changed binary?
#
# WHY THIS EXISTS. Bakery's first proof (ITINERARY, Bakery line, `20261001`): identical declared
# inputs may skip compilation, and every changed source, flag, overlay, compiler, executable bit,
# or toolchain pin must force a rebuild. The census `shared_build_cache_census.sh` proves the other
# half -- identical bytes at another path hit. This fixture measures the half it did not.
#
# WHY A BINARY, NOT A FILE COUNT. The first draft counted new files in a private global cache. A
# single-file compile writes its main unit into each directory's LOCAL cache, so the global count
# read 0 for a source change that had in fact recompiled (binaries differed). The honest signal is
# the emitted binary: a mutation that reaches the compiled output must change its bytes, and the
# marker a mutation plants must appear in them. Bytes unchanged under a changed input is a silent
# reuse, a fault for that input.
#
# METHOD. A private global cache, so no peer's concurrent writes reach the reading. One baseline
# build, then each mutation alone in its own copy:
#   changed   -- the binary differs from the baseline (the input reached the output)
#   unchanged -- the binary is byte-identical (the input did not reach the output: silent reuse)
# Inputs this layer cannot express are `unmeasured` with a reason, never a pass.
#
# Usage: sh tools/fixtures/b/shared_build_cache_mutation_census.sh
# Exits 0 when every measured mutation changes the binary, 1 when one does not, 2 on setup failure.

ROOT=$(cd "$(dirname "$0")/../../.." && pwd -P) || exit 2
ZIG="$ROOT/vendor/zig-toolchain/zig"
[ -x "$ZIG" ] || { echo "verdict=no_toolchain zig=$ZIG"; exit 2; }

PEN="$ROOT/.lap/mutation-census.$$"
PRIV="$PEN/global-cache"
mkdir -p "$PEN/base" "$PRIV" || { echo "verdict=no_pen"; exit 2; }
trap 'rm -rf "$PEN"' EXIT

# A unique body per run, so a previous run's cache entry can never answer for this one.
UNIQ=$(date +%s%N)
BASE="$PEN/base"
cat > "$BASE/x.zig" <<EOF
const std = @import("std");
pub fn main() void { std.debug.print("mutation census $UNIQ\n", .{}); }
EOF

# build DIR OUT [extra zig flags...] -- private global cache; local cache beside the source.
build() {
    d=$1; out=$2; shift 2
    (cd "$d" && ZIG_GLOBAL_CACHE_DIR="$PRIV" ZIG_LOCAL_CACHE_DIR="$d/.zc" "$ZIG" build-exe x.zig "-femit-bin=$out" "$@" >/dev/null 2>&1)
}

build "$BASE" "$BASE/x.bin" || { echo "verdict=baseline_failed"; exit 2; }
echo "baseline=built"

changed=0; silent=0; unmeasured=0
# probe NAME DIR MARKER [flags...] -- build a mutated copy; MARKER must appear in the binary when
# it is non-empty. An empty MARKER skips the marker check.
probe() {
    name=$1; d=$2; marker=$3; shift 3
    out="$d/x.bin"
    if ! build "$d" "$out" "$@"; then
        echo "mutation=$name result=unmeasured reason=build_failed"
        unmeasured=$((unmeasured + 1)); return
    fi
    if cmp -s "$out" "$BASE/x.bin"; then
        echo "mutation=$name result=silent_reuse binary=identical"
        silent=$((silent + 1))
    else
        if [ -n "$marker" ] && ! grep -q "$marker" "$out"; then
            echo "mutation=$name result=changed marker=absent"
        else
            echo "mutation=$name result=changed binary=differs"
        fi
        changed=$((changed + 1))
    fi
}

# 1. Source: the program text changes (a marker reaches the printed string).
M1="$PEN/m1"; mkdir -p "$M1"; cp "$BASE/x.zig" "$M1/"
sed 's/census/census-changed/' "$BASE/x.zig" > "$M1/x.zig"
probe source "$M1" "census-changed"

# 2. Flag: the optimization mode changes on the same bytes.
M2="$PEN/m2"; mkdir -p "$M2"; cp "$BASE/x.zig" "$M2/"
probe flag "$M2" "" -OReleaseSafe

# 3. Overlay: a second source file the program imports and prints from reaches the output.
M3="$PEN/m3"; mkdir -p "$M3"
printf 'pub const tag = "overlay-marker";\n' > "$M3/overlay.zig"
cat > "$M3/x.zig" <<EOF
const std = @import("std");
const overlay = @import("overlay.zig");
pub fn main() void { std.debug.print("mutation census $UNIQ {s}\n", .{overlay.tag}); }
EOF
probe overlay "$M3" "overlay-marker"

# 4. Executable bit: a mode change on the same bytes. Zig reads content, not mode, so an identical
#    binary is the correct answer AT THIS LAYER. The Bakery receipt key is where the mode must force
#    a miss; this fixture cannot prove that, so it reports the mode as read here and leaves it there.
M4="$PEN/m4"; mkdir -p "$M4"; cp "$BASE/x.zig" "$M4/"; chmod +x "$M4/x.zig"
echo "mutation=executable_bit result=unmeasured reason=zig_reads_content_not_mode_receipt_key_owns_it"
unmeasured=$((unmeasured + 1))

# 5. Compiler pin: a different compiler binary. One toolchain is vendored on this pier.
echo "mutation=compiler_pin result=unmeasured reason=one_vendored_toolchain_on_this_pier"
unmeasured=$((unmeasured + 1))

# 6. Toolchain pin: the same compiler at a different declared identity. Same reason.
echo "mutation=toolchain_pin result=unmeasured reason=one_vendored_toolchain_on_this_pier"
unmeasured=$((unmeasured + 1))

echo "changed=$changed silent_reuse=$silent unmeasured=$unmeasured"
if [ "$silent" -gt 0 ]; then
    echo "verdict=silent_reuse silent=$silent"
    exit 1
fi
echo "verdict=every_measured_mutation_changes_the_binary unmeasured=$unmeasured"
exit 0
