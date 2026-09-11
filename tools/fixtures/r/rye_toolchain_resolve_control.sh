#!/bin/sh
# tools/fixtures/r/rye_toolchain_resolve_control.sh -- proves how `rye` finds its toolchain.
#
# THE SUBJECT. `rye build` spawns a Zig toolchain, and until `20260911` it looked in two places:
# an explicit RYE_ZIG, else a bare `zig` for PATH to answer. This tree fetches its own pinned
# toolchain to `vendor/zig-toolchain/zig` -- `tools/f/fetch-toolchain.sh` is the second command a
# newcomer runs -- and `rye` could not see it. So on a host with no `zig` on PATH, the tree's own
# compiler refused to build the tree, naming two doors and never the one the tree had just walked
# through. `rye/bootstrap.sh` had read `${RYE_ZIG:-../vendor/zig-toolchain/zig}` the whole time:
# one question, two answers, in one directory.
#
# WHAT IS PROVEN HERE. The three readings in order, each from both sides -- the reading answers
# when it should, and the next one answers when it should not. Every refusal is planted and then
# lifted, and three mutations of the resolver itself are rebuilt and shown to bite, since a leg
# that has never failed cannot be told from a leg that cannot fail.
#
#   sh tools/fixtures/r/rye_toolchain_resolve_control.sh [rye-binary]
#
# Run from the repository root. Exit 0 green, 1 red, 0 with a named machine fact when this pier's
# `rye` binary predates the source it is asked to speak for.
set -eu

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
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

REPO=$(pwd)
RYE_BIN="${1:-$REPO/rye/bin/rye}"
# A relative binary path breaks the moment a leg changes directory; seat it absolute once.
case "$RYE_BIN" in /*) ;; *) RYE_BIN="$REPO/$RYE_BIN" ;; esac
ZIG="$REPO/vendor/zig-toolchain/zig"
SRC="$REPO/rye/src/main.rye"
LIB="$REPO/rye/lib"
[ -x "$RYE_BIN" ] || { echo "rye-toolchain-resolve: no rye binary at $RYE_BIN"; exit 1; }
[ -x "$ZIG" ] || { echo "rye-toolchain-resolve: no toolchain at $ZIG"; exit 1; }
[ -r "$SRC" ] || { echo "rye-toolchain-resolve: no source at $SRC"; exit 1; }

# THE BINARY CAN BE OLDER THAN THE SOURCE IT CAME FROM -- `rye/bin/rye` is gitignored, so a fresh
# clone has none and a working pier has whichever one it last built. A binary predating this
# resolver would red every leg below while nothing in the tree was wrong, so the version is asked
# at the door, exactly as `ryekey_control.sh` asks it. Rye stamps its version on the one clock,
# which string-compares correctly.
src_version=$(sed -n 's/^const rye_version = "\([0-9.]*\)";$/\1/p' "$SRC" | head -1)
bin_version=$("$RYE_BIN" version 2>&1 >/dev/null | sed -n 's/^rye \([0-9][0-9.]*\).*$/\1/p' | head -1)
if [ -z "$src_version" ] || [ -z "$bin_version" ]; then
    echo "rye-toolchain-resolve SKIPPED: could not read a version from the source (${src_version:-none}) or the binary (${bin_version:-none})"
    echo "resolve_verdict=machine_fact"
    exit 0
fi
if [ "$bin_version" \< "$src_version" ]; then
    echo "rye-toolchain-resolve SKIPPED: machine fact -- the binary declares $bin_version and its source declares $src_version."
    echo "rye-toolchain-resolve SKIPPED: rebuild with 'sh rye/bootstrap.sh' and run this again; nothing in the tree is wrong."
    echo "resolve_verdict=machine_fact"
    exit 0
fi
echo "rye-toolchain-resolve: binary $bin_version stands at or past its source $src_version"

PEN=$(mktemp -d) || exit 1
trap 'rm -rf "$PEN"' EXIT INT TERM

legs=0
fail() { echo "rye-toolchain-resolve RED: $1"; exit 1; }
leg() { legs=$((legs + 1)); }

# A pen ROOT in the shape a clone takes: the binary two steps under it, the toolchain beneath
# `vendor/`. Nothing here reaches the real toolchain except by symlink, and no leg ever changes a
# mode through one -- a chmod follows a symlink to its target, which is the tree's own toolchain.
ROOT="$PEN/root"
mkdir -p "$ROOT/rye/bin" "$ROOT/vendor/zig-toolchain" "$ROOT/src" "$ROOT/stub"
cp "$RYE_BIN" "$ROOT/rye/bin/rye"
ln -s "$LIB" "$ROOT/rye/lib"
ln -s "$ZIG" "$ROOT/vendor/zig-toolchain/zig"

cat > "$ROOT/src/hello.rye" <<'EOF'
const std = @import("std");
pub fn main(_: std.process.Init) !u8 {
    std.debug.print("pen: hello\n", .{});
    return 0;
}
EOF

# Two stubs that answer loudly and compile nothing, so a leg reads WHICH toolchain was reached
# rather than whether a build happened to succeed.
printf '#!/bin/sh\necho "STUB-EXPLICIT"\nexit 7\n' > "$ROOT/stub/zig_explicit"
printf '#!/bin/sh\necho "STUB-PATH"\nexit 9\n' > "$ROOT/stub/zig"
chmod +x "$ROOT/stub/zig_explicit" "$ROOT/stub/zig"

BARE_PATH=/usr/bin:/bin
OUT="$ROOT/src/hello"

clear_out() { rm -f "$OUT" "$OUT.ryekey"; }

# build_with <rye-binary> <path> [env-assignments...] -- always with RYE_ZIG unset unless named.
run_rye() { # run_rye <bin> <PATH> [RYE_ZIG value or empty]
    _bin=$1; _path=$2; _zig=${3:-}
    clear_out
    if [ -n "$_zig" ]; then
        ( cd "$ROOT" && env RYE_ZIG="$_zig" PATH="$_path" "$_bin" build src/hello.rye -femit-bin=src/hello 2>&1 ) || true
    else
        ( cd "$ROOT" && env -u RYE_ZIG PATH="$_path" "$_bin" build src/hello.rye -femit-bin=src/hello 2>&1 ) || true
    fi
}

RYE="$ROOT/rye/bin/rye"

# --- leg 1: no RYE_ZIG and no zig on PATH -- the tree's own toolchain answers -----------------
out=$(run_rye "$RYE" "$BARE_PATH")
[ -x "$OUT" ] || fail "the vendored toolchain did not build: $out"
# The pen program speaks through std.debug.print, which is stderr -- the opening-triad idiom
# this tree writes everywhere -- so the read follows the stream the program actually uses.
[ "$("$OUT" 2>&1)" = "pen: hello" ] || fail "the vendored build produced a binary that does not run"
leg

# --- leg 2: the same, from a working directory that is not the root --------------------------
clear_out
# The pen itself, rather than `/`: `rye` takes its build lock by creating a directory in the
# working directory (one tree, one toolchain spawn), so an unwritable cwd refuses for a reason
# that has nothing to do with which toolchain was found.
out=$( cd "$PEN" && env -u RYE_ZIG PATH="$BARE_PATH" "$RYE" build "$ROOT/src/hello.rye" -femit-bin="$OUT" 2>&1 ) || true
[ -x "$OUT" ] || fail "the reading is cwd-bound rather than binary-bound: $out"
leg

# --- leg 3: an explicit RYE_ZIG still wins over a present vendored toolchain ------------------
out=$(run_rye "$RYE" "$BARE_PATH" "$ROOT/stub/zig_explicit")
case "$out" in *STUB-EXPLICIT*) ;; *) fail "RYE_ZIG lost to the vendored reading: $out" ;; esac
leg

# --- leg 4: with no vendored toolchain, PATH answers last ------------------------------------
mv "$ROOT/vendor/zig-toolchain/zig" "$ROOT/vendor/zig-toolchain/zig.parked"
out=$(run_rye "$RYE" "$ROOT/stub:$BARE_PATH")
case "$out" in *STUB-PATH*) ;; *) fail "PATH did not answer when the vendored toolchain was absent: $out" ;; esac
leg

# --- leg 5: neither -- the refusal names all three places and the command that fixes it -------
out=$(run_rye "$RYE" "$BARE_PATH")
case "$out" in *RYE_ZIG*) ;; *) fail "the refusal does not name RYE_ZIG: $out" ;; esac
case "$out" in *vendor/zig-toolchain/zig*) ;; *) fail "the refusal does not name the vendored path: $out" ;; esac
case "$out" in *PATH*) ;; *) fail "the refusal does not name PATH: $out" ;; esac
case "$out" in *fetch-toolchain*) ;; *) fail "the refusal does not name the command that installs it: $out" ;; esac
leg

# --- leg 6: a vendored path that is present and NOT executable falls through to PATH ----------
# A regular file rather than a symlink, on purpose: chmod follows a symlink to its target, and the
# target here would be the tree's own toolchain.
printf '#!/bin/sh\necho "STUB-VENDORED"\n' > "$ROOT/vendor/zig-toolchain/zig"
chmod -x "$ROOT/vendor/zig-toolchain/zig"
out=$(run_rye "$RYE" "$ROOT/stub:$BARE_PATH")
case "$out" in *STUB-PATH*) ;; *) fail "an unexecutable vendored path was reached anyway: $out" ;; esac
leg

# --- leg 7: a vendored path that IS executable is reached ahead of PATH -----------------------
chmod +x "$ROOT/vendor/zig-toolchain/zig"
out=$(run_rye "$RYE" "$ROOT/stub:$BARE_PATH")
case "$out" in *STUB-VENDORED*) ;; *) fail "the vendored toolchain lost to PATH: $out" ;; esac
leg
rm -f "$ROOT/vendor/zig-toolchain/zig"
mv "$ROOT/vendor/zig-toolchain/zig.parked" "$ROOT/vendor/zig-toolchain/zig"

# --- leg 8: a build through the vendored reading earns a receipt ------------------------------
# A bare `zig` is not a path, so `statFile` on it refuses and `wants_receipt` turns receipts OFF
# for the whole build (`rye/src/main.rye`). Resolving the toolchain by path turns them back on, so
# this reading buys build caching as well as a build. Measured both ways in the pen.
out=$(run_rye "$RYE" "$BARE_PATH")
[ -x "$OUT" ] || fail "the receipt leg could not build: $out"
[ -s "$OUT.ryekey" ] || fail "a vendored build left no receipt, so caching is still off"
leg

# --- leg 9: the cold start and the compiler name one destination ------------------------------
# `bootstrap.sh` runs from `rye/`, so its template is one `../` shorter than the compiler's, which
# resolves beside `rye/bin/rye`. What must agree is the tail: the same directory under the root.
boot_tail=$(sed -n 's|.*RYE_ZIG:-\.\./\(vendor/[A-Za-z0-9_/.-]*\)}.*|\1|p' "$REPO/rye/bootstrap.sh" | head -1)
src_tail=$(sed -n 's|^const zig_relative_to_exe = "\.\./\.\./\(vendor/[A-Za-z0-9_/.-]*\)";$|\1|p' "$SRC" | head -1)
[ -n "$boot_tail" ] || fail "bootstrap.sh names no vendored toolchain destination"
[ -n "$src_tail" ] || fail "the compiler names no vendored toolchain destination"
[ "$boot_tail" = "$src_tail" ] || fail "bootstrap says '$boot_tail' and the compiler says '$src_tail'"
echo "rye-toolchain-resolve: bootstrap and compiler agree on $src_tail"
leg

# --- mutations: rebuild the resolver wrong and watch a named leg fall -------------------------
# Each mutation is one substitution in a copy of the source, built through the pinned toolchain
# directly -- the cold-start recipe, so a broken resolver cannot be needed to build itself.
MUT="$PEN/mut"
mkdir -p "$MUT"
build_mutant() { # build_mutant <name> <sed-expression>
    _name=$1; _expr=$2
    sed "$_expr" "$SRC" > "$MUT/$_name.rye.zig"
    cmp -s "$SRC" "$MUT/$_name.rye.zig" && fail "mutation '$_name' changed nothing"
    "$ZIG" build-exe "$MUT/$_name.rye.zig" -femit-bin="$MUT/$_name" --zig-lib-dir "$LIB" -lc >/dev/null 2>&1 \
        || fail "mutation '$_name' did not build"
    echo "rye-toolchain-resolve: mutation $_name rebuilt" >&2
    echo "$MUT/$_name"
}

# M1: drop the vendored reading entirely -- leg 1 must fall.
m1=$(build_mutant m1 's|const zig = resolve_zig(init, garden);|const zig = init.environ_map.get("RYE_ZIG") orelse zig_fallback;|')
out=$(run_rye "$m1" "$BARE_PATH")
[ -x "$OUT" ] && fail "M1: leg 1 passed with the vendored reading removed"
leg

# M2: put the vendored reading ahead of RYE_ZIG -- leg 3 must fall.
m2=$(build_mutant m2 '\|if (init.environ_map.get("RYE_ZIG")) |d')
out=$(run_rye "$m2" "$BARE_PATH" "$ROOT/stub/zig_explicit")
case "$out" in *STUB-EXPLICIT*) fail "M2: leg 3 passed with RYE_ZIG no longer first" ;; *) ;; esac
leg

# M3: drop the executable check -- leg 6 must fall.
m3=$(build_mutant m3 's|    std.Io.Dir.cwd().access(init.io, vendored, .{ .execute = true }) catch return zig_fallback;||')
printf '#!/bin/sh\necho "STUB-VENDORED"\n' > "$ROOT/vendor/zig-toolchain/zig.file"
rm -f "$ROOT/vendor/zig-toolchain/zig"
mv "$ROOT/vendor/zig-toolchain/zig.file" "$ROOT/vendor/zig-toolchain/zig"
chmod -x "$ROOT/vendor/zig-toolchain/zig"
out=$(run_rye "$m3" "$ROOT/stub:$BARE_PATH")
case "$out" in *STUB-PATH*) fail "M3: leg 6 passed with the executable check removed" ;; *) ;; esac
leg

echo "legs=$legs all proven -- three readings in order, each shown from both sides; three mutations bitten"
echo "CONTROL_GREEN: rye finds RYE_ZIG, then the toolchain this tree ships, then PATH"
echo "resolve_verdict=green"
