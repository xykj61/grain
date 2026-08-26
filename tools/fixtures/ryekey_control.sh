#!/bin/sh
# ryekey_control.sh -- the build receipt proven from both sides, in a throwaway pen.
#
# WHY THIS CONTROL. rye build now skips spawning the toolchain when a receipt
# (<emit>.ryekey) speaks the exact key of every input. A cache proven only in
# the hit direction cannot be told from a bypass -- the tree's own exec-bit and
# ascii controls already state this both-sides rule -- so this control proves
# the MISS side leg by leg: every input the key claims to cover is flipped once,
# alone, and the flip must rebuild. The hit, the RYE_BUILD_FRESH bypass, the
# no-emit and run exemptions, and two-build determinism are proven beside them.
#
# Detectors, chosen for what they cannot confuse:
#   built    = the stamp's bytes changed (a rebuild writes the new key), or for
#              same-key legs, the binary's fractional mtime moved
#   skipped  = stamp bytes identical AND binary fractional mtime identical
#
# Run from the repository root:
#   sh tools/fixtures/ryekey_control.sh [path-to-rye-binary]
#
# Exit 0 with CONTROL_GREEN on the last line; exit 1 naming the first leg that
# failed. Nothing outside the pen is written; the pen is removed on exit.

set -u

# The dialect answers live in one place, so this control reads the same mtime on both piers.
. "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"
REPO=$(pwd)
RYE_BIN="${1:-$REPO/rye/bin/rye}"
# A relative binary path breaks the moment a leg changes directory; seat it absolute once.
case "$RYE_BIN" in /*) ;; *) RYE_BIN="$REPO/$RYE_BIN" ;; esac
ZIG="$REPO/vendor/zig-toolchain/zig"
[ -x "$RYE_BIN" ] || { echo "ryekey-control: no rye binary at $RYE_BIN"; exit 1; }
[ -x "$ZIG" ] || { echo "ryekey-control: no toolchain at $ZIG"; exit 1; }

# THE BINARY IS THIS PIER'S, AND IT CAN BE OLDER THAN THE SOURCE IT CAME FROM. `rye/bin/rye` is
# untracked and gitignored, so a fresh clone has none and a working pier has whichever one it last
# built. Measured `20260826.090745`: this pier's binary was built `20260821` and the receipt
# feature landed in `rye/src/main.rye` on `20260825`, so every leg below reported RED -- and RED
# read exactly like "the receipt is broken" when the truth was "your binary predates it."
#
# So the version is asked at the door rather than inferred from a failure four legs later. Rye
# stamps its version on the one clock (`YYYYMMDD.HHMMSS`, later is larger), which string-compares
# correctly, so the running binary must declare at least what its own source declares. A binary
# that does not is a MACHINE FACT, named and skipped at exit 0 -- never a red, because nothing in
# the tree is wrong. `sh rye/bootstrap.sh` builds it in about a second.
src_version=$(sed -n 's/^const rye_version = "\([0-9.]*\)";$/\1/p' "$REPO/rye/src/main.rye" | head -1)
# `rye version` reports through std.debug.print, which is stderr -- the opening-triad idiom this
# tree writes everywhere -- so the read follows the stream the tool actually uses rather than the
# one a reader would assume.
bin_version=$("$RYE_BIN" version 2>&1 >/dev/null | sed -n 's/^rye \([0-9][0-9.]*\).*$/\1/p' | head -1)
if [ -z "$src_version" ] || [ -z "$bin_version" ]; then
    echo "ryekey-control SKIPPED: could not read a version from the source (${src_version:-none}) or the binary (${bin_version:-none})"
    echo "ryekey_verdict=machine_fact"
    exit 0
fi
if [ "$bin_version" \< "$src_version" ]; then
    echo "ryekey-control SKIPPED: machine fact -- the binary declares $bin_version and its source declares $src_version."
    echo "ryekey-control SKIPPED: rebuild with 'sh rye/bootstrap.sh' and run this again; nothing in the tree is wrong."
    echo "ryekey_verdict=machine_fact"
    exit 0
fi
echo "ryekey-control: binary $bin_version stands at or past its source $src_version"

PEN=$(mktemp -d) || exit 1
trap 'rm -rf "$PEN"' EXIT INT TERM

fail() { echo "ryekey-control RED: $1"; exit 1; }

# A two-file project: root imports dep, so both the root leg and the dep leg
# of the closure can be flipped independently.
cat > "$PEN/dep.rye" <<'EOF'
pub const answer: u32 = 41;
pub const seed = @embedFile("seed.txt");
EOF
printf 'first seed\n' > "$PEN/seed.txt"
cat > "$PEN/main.rye" <<'EOF'
const std = @import("std");
const dep = @import("dep.rye");
pub fn main() !void {
    std.debug.print("{d}\n", .{dep.answer + 1});
}
EOF

BIN="$PEN/out"
KEY="$BIN.ryekey"

build() { # build [extra-env ...]; returns rye's own exit code
    env RYE_ZIG="$ZIG" "$@" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN"
}
stamp() { cat "$KEY" 2>/dev/null || echo absent; }
# A file's mtime is a dialect question, and the BSD-first spelling this line once carried
# concatenated a five-line filesystem report onto every GNU reading (REDS %260). One call now.
btime() { file_mtime "$BIN"; }

# --- leg 1: a fresh build writes a receipt ---------------------------------------------------
build || fail "fresh build failed"
[ -s "$KEY" ] || fail "fresh build left no receipt"
k1=$(stamp); t1=$(btime)
[ "${#k1}" = "129" ] || fail "receipt is not two 64-hex lines (${#k1} bytes)"

# --- leg 2: nothing moved -- the hit leaves both stamp and binary untouched ------------------
build || fail "hit build failed"
[ "$(stamp)" = "$k1" ] || fail "hit rewrote the stamp"
[ "$(btime)" = "$t1" ] || fail "hit rebuilt the binary"

# --- leg 3: one byte in the ROOT source misses -----------------------------------------------
printf '// moved\n' >> "$PEN/main.rye"
build || fail "root-flip build failed"
k3=$(stamp)
[ "$k3" != "$k1" ] || fail "a root source byte did not change the key"

# --- leg 4: one byte in a DEP source misses --------------------------------------------------
printf '// moved\n' >> "$PEN/dep.rye"
build || fail "dep-flip build failed"
k4=$(stamp)
[ "$k4" != "$k3" ] || fail "a dep source byte did not change the key"

# --- leg 5: a forwarded flag misses ----------------------------------------------------------
env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" -OReleaseSmall \
    || fail "flag-flip build failed"
k5=$(stamp)
[ "$k5" != "$k4" ] || fail "a forwarded flag did not change the key"

# --- leg 6: the toolchain PATH misses (same bytes, different name) ---------------------------
ln -s "$ZIG" "$PEN/zigalt"
env RYE_ZIG="$PEN/zigalt" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" -OReleaseSmall \
    || fail "zig-path build failed"
k6=$(stamp)
[ "$k6" != "$k5" ] || fail "the toolchain path did not change the key"

# --- leg 7: the library's std link target misses ---------------------------------------------
# A pen lib whose every entry points at the real library's resolved targets; the
# std entry is then re-seated to an equivalent path with a different SPELLING,
# so the build still succeeds while the link's target string moves.
mkdir "$PEN/lib2"
for entry in "$REPO/rye/lib"/*; do
    name=$(basename "$entry")
    tgt=$(readlink -f "$entry") || fail "could not resolve rye/lib/$name"
    ln -s "$tgt" "$PEN/lib2/$name"
done
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "pen-lib build failed"
k7a=$(stamp)
std_tgt=$(readlink "$PEN/lib2/std")
rm "$PEN/lib2/std"
ln -s "${std_tgt%/}/." "$PEN/lib2/std"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "retargeted-std build failed"
k7b=$(stamp)
[ "$k7b" != "$k7a" ] || fail "a re-seated std link did not change the key"

# --- leg 8: the rye binary's own bytes miss --------------------------------------------------
cp "$RYE_BIN" "$PEN/ryeflip"
printf 'x' >> "$PEN/ryeflip"
chmod +x "$PEN/ryeflip"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "flipped-rye build failed"
k8=$(stamp)
[ "$k8" != "$k7b" ] || fail "the rye binary's own bytes did not change the key"
k_base=$k8; t_base=$(btime)

# --- leg 9: RYE_BUILD_FRESH rebuilds past a standing receipt ---------------------------------
sleep 1
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" RYE_BUILD_FRESH=1 "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "fresh-bypass build failed"
[ "$(stamp)" = "$k_base" ] || fail "the bypass rewrote the stamp it exists to ignore"
[ "$(btime)" != "$t_base" ] || fail "RYE_BUILD_FRESH did not rebuild"

# --- leg 10: determinism -- two fresh builds of one tree speak one key -----------------------
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "determinism build one failed"
kd1=$(stamp | head -1)
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "determinism build two failed"
# The KEY line is the determinism claim; the output line may honestly differ,
# since a Mach-O link stamps a fresh UUID into byte-identical inputs' output.
[ "$(stamp | head -1)" = "$kd1" ] || fail "two fresh builds of one tree spoke two keys"

# --- leg 11: a build naming no output earns no receipt ---------------------------------------
rm -f "$KEY" "$PEN/main"
( cd "$PEN" && env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" ) \
    || fail "no-emit build failed"
[ ! -f "$KEY" ] || fail "a no-emit build left a receipt"

# --- leg 12: run never consults or writes a receipt ------------------------------------------
out=$(env RYE_ZIG="$ZIG" "$RYE_BIN" run "$PEN/main.rye" 2>&1) || fail "run failed"
[ "$out" = "42" ] || fail "run answered '$out' rather than 42"
[ ! -f "$PEN/main.rye.ryekey" ] || fail "run left a receipt"

# --- leg 13: one byte in an @embedFile target misses -----------------------------------------
build || fail "embed-baseline build failed"
k13a=$(stamp)
printf 'second seed\n' > "$PEN/seed.txt"
build || fail "embed-flip build failed"
k13b=$(stamp)
[ "$k13b" != "$k13a" ] || fail "an embedded byte did not change the key"

# --- leg 14: a tampered output misses its own hash and rebuilds ------------------------------
printf 'torn' > "$BIN"
t14a=$(btime)
sleep 1
build || fail "tamper-recovery build failed"
[ "$(btime)" != "$t14a" ] || fail "a tampered output was served instead of rebuilt"
sz=$(wc -c < "$BIN" | tr -d ' ')
[ "$sz" -gt 1000 ] || fail "the rebuild left a torn binary ($sz bytes)"

# --- leg 15: a positional argument earns no receipt ------------------------------------------
printf 'int nothing_here;\n' > "$PEN/extra.c"
rm -f "$KEY"
env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" "$PEN/extra.c" \
    || fail "positional-arg build failed"
[ ! -f "$KEY" ] || fail "a positional argument still earned a receipt"

echo "legs=15 all proven -- six flips missed, the hit held, the bypass rebuilt, two fresh builds agreed, run and no-emit stayed exempt"
echo "CONTROL_GREEN: the receipt misses on every flipped input and skips only byte-identical builds"
echo "ryekey_verdict=green"
