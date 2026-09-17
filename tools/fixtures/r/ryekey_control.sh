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
# THE HIT SIDE EARNS THE SAME READING from `ryekey-v6` on. A key that misses on
# everything is as useless as one that hits on everything. So a same-content
# input reached by ANOTHER PATH must hit. One pinned toolchain and one standard
# library each get two spellings here, and each leaves the key and the binary
# alone. The row is stamped `20260916.023136`; `rye/src/main.rye` carries the
# reason beside the key itself.
#
# Legs are counted by section. The labels below repeat 9 and 10 from an elder
# lap, and they stay as written.
#
# Detectors, chosen for what they cannot confuse:
#   built    = the stamp's bytes changed (a rebuild writes the new key), or for
#              same-key legs, the binary's fractional mtime moved
#   skipped  = stamp bytes identical AND binary fractional mtime identical
#
# Run from the repository root:
#   sh tools/fixtures/r/ryekey_control.sh [path-to-rye-binary]
#
# Exit 0 with CONTROL_GREEN on the last line; exit 1 naming the first leg that
# failed. Source modes are flipped without changing bytes, once at the root
# and once in a dependency, so a root-only implementation cannot pass. Nothing
# outside the pen is written; the pen is removed on exit.

set -u

# The dialect answers live in one place, so this control reads the same mtime on both piers.
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
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

# --- leg 5: the ROOT source executable bit misses without changing its bytes -----------------
chmod +x "$PEN/main.rye"
build || fail "root-mode-flip build failed"
k5=$(stamp)
[ "$k5" != "$k4" ] || fail "the root source executable bit did not change the key"

# --- leg 6: a DEP source executable bit misses without changing its bytes --------------------
chmod +x "$PEN/dep.rye"
build || fail "dep-mode-flip build failed"
k6=$(stamp)
[ "$k6" != "$k5" ] || fail "a dependency source executable bit did not change the key"

# --- leg 7: a forwarded flag misses ----------------------------------------------------------
env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" -OReleaseSmall \
    || fail "flag-flip build failed"
k7=$(stamp); t7=$(btime)
[ "$k7" != "$k6" ] || fail "a forwarded flag did not change the key"

# --- leg 8: the same toolchain reached by another path stays a HIT ---------------------------
# The key holds the compiler's BYTES and never the path that reached it, so one pinned toolchain
# wears as many spellings as its callers like and buys one build between them. Before `ryekey-v6`
# this leg asserted the opposite, and four spellings of one compiler spoke four keys (%754).
ln -s "$ZIG" "$PEN/zigalt"
env RYE_ZIG="$PEN/zigalt" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" -OReleaseSmall \
    || fail "zig-path build failed"
k8=$(stamp)
[ "$k8" = "$k7" ] || fail "another spelling of one toolchain changed the key"
[ "$(btime)" = "$t7" ] || fail "another spelling of one toolchain rebuilt the binary"

# --- leg 8b: the same library reached by another path stays a HIT ----------------------------
# A pen directory whose entries point at the real library's resolved targets: identical content,
# a different directory name. The key reads the sorted tree's bytes, so the build skips.
mkdir "$PEN/libspell"
for entry in "$REPO/rye/lib"/*; do
    name=$(basename "$entry")
    tgt=$(resolve_path "$entry") || fail "could not resolve rye/lib/$name"
    ln -s "$tgt" "$PEN/libspell/$name"
done
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/libspell" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" \
    -OReleaseSmall || fail "library-spelling build failed"
[ "$(stamp)" = "$k7" ] || fail "another spelling of one library changed the key"
[ "$(btime)" = "$t7" ] || fail "another spelling of one library rebuilt the binary"

# --- leg 9: same path and size, different toolchain bytes miss -------------------------------
printf '#!/bin/sh\n# compiler-key-a\nexec "%s" "$@"\n' "$ZIG" > "$PEN/zigbytes"
chmod +x "$PEN/zigbytes"
env RYE_ZIG="$PEN/zigbytes" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" -OReleaseSmall \
    || fail "zig-bytes baseline build failed"
k8a=$(stamp)
sed 's/compiler-key-a/compiler-key-b/' "$PEN/zigbytes" > "$PEN/zigbytes.next"
mv "$PEN/zigbytes.next" "$PEN/zigbytes"
chmod +x "$PEN/zigbytes"
[ "$(wc -c < "$PEN/zigbytes" | tr -d ' ')" = "$(printf '#!/bin/sh\n# compiler-key-a\nexec "%s" "$@"\n' "$ZIG" | wc -c | tr -d ' ')" ] \
    || fail "the same-size toolchain plant changed size"
env RYE_ZIG="$PEN/zigbytes" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" -OReleaseSmall \
    || fail "zig-bytes flip build failed"
k8b=$(stamp)
[ "$k8b" != "$k8a" ] || fail "same-path same-size toolchain bytes did not change the key"

# --- leg 9: an equivalent spelling of the same library content remains a hit ----------------
# A pen lib whose every entry points at the real library's resolved targets; the
# std entry is then re-seated to an equivalent path with a different SPELLING,
# so the build still succeeds while the link's target string moves.
mkdir "$PEN/lib2"
for entry in "$REPO/rye/lib"/*; do
    name=$(basename "$entry")
    tgt=$(resolve_path "$entry") || fail "could not resolve rye/lib/$name"
    ln -s "$tgt" "$PEN/lib2/$name"
done
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "pen-lib build failed"
k9a=$(stamp)
std_tgt=$(readlink "$PEN/lib2/std")
rm "$PEN/lib2/std"
ln -s "${std_tgt%/}/." "$PEN/lib2/std"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "retargeted-std build failed"
k9b=$(stamp)
[ "$k9b" = "$k9a" ] || fail "equivalent library bytes changed the content key"

# --- leg 10: same path and size, different standard-library bytes miss ----------------------
cp -RL "$REPO/rye/lib/std" "$PEN/std-copy"
rm "$PEN/lib2/std"
ln -s "$PEN/std-copy" "$PEN/lib2/std"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "copied-std baseline build failed"
k9c=$(stamp)
sed '0,/^pub const AutoHashMap =/s//pub  const AutoHashMap=/' "$PEN/std-copy/std.zig" > "$PEN/std-copy/std.zig.next"
[ "$(wc -c < "$PEN/std-copy/std.zig.next" | tr -d ' ')" = "$(wc -c < "$PEN/std-copy/std.zig" | tr -d ' ')" ] \
    || fail "the same-size library plant changed size"
mv "$PEN/std-copy/std.zig.next" "$PEN/std-copy/std.zig"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "same-size std-byte flip build failed"
k9d=$(stamp)
[ "$k9d" != "$k9c" ] || fail "same-path same-size standard-library bytes did not change the key"

# --- leg 10: the rye binary's own bytes miss -------------------------------------------------
cp "$RYE_BIN" "$PEN/ryeflip"
printf 'x' >> "$PEN/ryeflip"
chmod +x "$PEN/ryeflip"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "flipped-rye build failed"
k10=$(stamp)
[ "$k10" != "$k9b" ] || fail "the rye binary's own bytes did not change the key"
k_base=$k10; t_base=$(btime)

# --- leg 11: RYE_BUILD_FRESH rebuilds past a standing receipt --------------------------------
sleep 1
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" RYE_BUILD_FRESH=1 "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "fresh-bypass build failed"
[ "$(stamp)" = "$k_base" ] || fail "the bypass rewrote the stamp it exists to ignore"
[ "$(btime)" != "$t_base" ] || fail "RYE_BUILD_FRESH did not rebuild"

# --- leg 12: determinism -- two fresh builds of one tree speak one key -----------------------
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

# --- leg 13: a build naming no output earns no receipt ---------------------------------------
rm -f "$KEY" "$PEN/main"
( cd "$PEN" && env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" ) \
    || fail "no-emit build failed"
[ ! -f "$KEY" ] || fail "a no-emit build left a receipt"

# --- leg 14: run never consults or writes a receipt ------------------------------------------
out=$(env RYE_ZIG="$ZIG" "$RYE_BIN" run "$PEN/main.rye" 2>&1) || fail "run failed"
[ "$out" = "42" ] || fail "run answered '$out' rather than 42"
[ ! -f "$PEN/main.rye.ryekey" ] || fail "run left a receipt"

# --- leg 15: one byte in an @embedFile target misses -----------------------------------------
build || fail "embed-baseline build failed"
k13a=$(stamp)
printf 'second seed\n' > "$PEN/seed.txt"
build || fail "embed-flip build failed"
k13b=$(stamp)
[ "$k13b" != "$k13a" ] || fail "an embedded byte did not change the key"

# --- leg 16: a tampered output misses its own hash and rebuilds ------------------------------
printf 'torn' > "$BIN"
t14a=$(btime)
sleep 1
build || fail "tamper-recovery build failed"
[ "$(btime)" != "$t14a" ] || fail "a tampered output was served instead of rebuilt"
sz=$(wc -c < "$BIN" | tr -d ' ')
[ "$sz" -gt 1000 ] || fail "the rebuild left a torn binary ($sz bytes)"

# --- leg 18: the OUTPUT'S PATH leaves the key, so a rename keeps its receipt -----------------
# A running binary refuses to be written over, so every ship rebuilds `rishi` by emitting to
# `rishi/bin/rishi.new` and renaming. Where the output lands names how a caller filed the result
# rather than what compiled, so the path joins the key as the bare fact `-femit-bin=` from
# `ryekey-v7` on. Move the binary and its receipt together and the next build HITS.
#
# Before v7 this same move missed: measured `20260916.064500` in a pen, one source emitted to two
# paths spoke two keys and produced byte-identical binaries, and five of the pier's eight ships
# carried a receipt speaking for a binary no longer there.
rm -f "$KEY" "$BIN" "$PEN/moved" "$PEN/moved.ryekey"
build || fail "rename baseline build failed"
k18=$(stamp | head -1); t18=$(btime)
mv "$BIN" "$PEN/moved"
mv "$KEY" "$PEN/moved.ryekey"
env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$PEN/moved" \
    || fail "renamed-output build failed"
[ "$(head -1 "$PEN/moved.ryekey")" = "$k18" ] || fail "the output's path changed the key"
[ "$(file_mtime "$PEN/moved")" = "$t18" ] || fail "a renamed output with its receipt rebuilt"

# --- leg 19: a SIBLING emit flag's value still misses ----------------------------------------
# The exemption reaches `-femit-bin=` alone, because that is the one artifact a receipt verifies
# on every hit. `-femit-asm=` names a file no hash checks, so two spellings must miss rather than
# serve a hit that quietly emits nothing.
rm -f "$KEY" "$BIN"
env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" "-femit-asm=$PEN/one.s" \
    -OReleaseSmall || fail "asm-one build failed"
k19a=$(stamp | head -1)
env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" "-femit-asm=$PEN/two.s" \
    -OReleaseSmall || fail "asm-two build failed"
[ "$(stamp | head -1)" != "$k19a" ] || fail "a sibling emit flag's value did not change the key"

# --- leg 17: a positional argument earns no receipt ------------------------------------------
printf 'int nothing_here;\n' > "$PEN/extra.c"
rm -f "$KEY"
env RYE_ZIG="$ZIG" "$RYE_BIN" build "$PEN/main.rye" "-femit-bin=$BIN" "$PEN/extra.c" \
    || fail "positional-arg build failed"
[ ! -f "$KEY" ] || fail "a positional argument still earned a receipt"

# --- leg 20: RYE_BUILD_FRESH names ITSELF in the refusal --------------------------------------
# A bypass is a choice the caller made, and until `20260916.191733` it was the one refusal with no
# sentence of its own: the walk fell past all four readings and blamed this binary's own path -- a
# path that had resolved perfectly well. Measured at HEAD before the repair, that exact command
# answered `this binary's own path could not be resolved`, false in every part.
#
# Proven from both sides: the true cause must be named, and the false one must be gone.
fresh_reason=$(env RYE_ZIG="$ZIG" RYE_BUILD_FRESH=1 "$RYE_BIN" key "$PEN/main.rye" \
    "-femit-bin=$BIN" 2>&1 | grep '^reason=')
case "$fresh_reason" in
    *RYE_BUILD_FRESH*) : ;;
    *) fail "a forced-fresh key did not name RYE_BUILD_FRESH: $fresh_reason" ;;
esac
case "$fresh_reason" in
    *"own path could not be resolved"*)
        fail "a forced-fresh key still blamed this binary's path: $fresh_reason" ;;
    *) : ;;
esac

# --- leg 21: an unkeyable FLAG is still blamed on the flag, never on an unread file ------------
# THE LEG THAT PRICES THE SKIP. From `20260916.191733` the toolchain and library are read only
# where a key is wanted, so on a refusal neither has been opened. Both readability flags mean *no
# unreadable input refused the key*, and a skipped read therefore leaves them TRUE: nothing was
# read, so nothing refused. Had the skip left them FALSE instead, this refusal would blame the
# toolchain's bytes -- a file this build never opened -- and the caller would chase a healthy
# compiler. The mutation is exact and it bites: flipping either `else true` to `else false` in
# `rye/src/main.rye` turns this leg's answer into the toolchain sentence, proven by hand on the
# lap that wrote it.
flag_reason=$(env RYE_ZIG="$ZIG" "$RYE_BIN" key "$PEN/main.rye" "-femit-bin=$BIN" -lcurl 2>&1 \
    | grep '^reason=')
case "$flag_reason" in
    *"a flag names a path or a library"*) : ;;
    *) fail "an unkeyable flag was not blamed on the flag: $flag_reason" ;;
esac
case "$flag_reason" in
    *"could not be read"*)
        fail "an unkeyable flag blamed a file this build never opened: $flag_reason" ;;
    *) : ;;
esac

# --- leg 22: run NAMING AN OUTPUT is still exempt, and still runs -----------------------------
# LEG 14 COULD NOT SEE THE RUN EXCLUSION. It invokes `run` with no emit flag, so the no-output
# condition refuses the receipt first and the `run` clause beside it is never the reading under
# test -- two conditions, one leg, and the leg exercising the other one. Proven by planting
# `20260916.191733`: deleting the run exclusion outright left all 24 legs GREEN.
#
# WHAT THAT MISSES, shown on metal before this leg was written. With the exclusion gone,
# `rye run <file> -femit-bin=<out>` earns a receipt on its first call and HITS on its second --
# and a hit emits nothing and spawns nothing, so the second invocation printed NOTHING and exited
# 0. A `run` that does not run, reporting success, is the worst shape this family can fail in:
# every other miss rebuilds, where this one silently declines to work and says it is fine.
rm -f "$PEN/ran.bin" "$PEN/ran.bin.ryekey"
out22a=$(env RYE_ZIG="$ZIG" "$RYE_BIN" run "$PEN/main.rye" "-femit-bin=$PEN/ran.bin" 2>&1) \
    || fail "run naming an output failed"
[ "$out22a" = "42" ] || fail "run naming an output answered '$out22a' rather than 42"
[ ! -f "$PEN/ran.bin.ryekey" ] || fail "run naming an output left a receipt"
out22b=$(env RYE_ZIG="$ZIG" "$RYE_BIN" run "$PEN/main.rye" "-femit-bin=$PEN/ran.bin" 2>&1) \
    || fail "a second run naming an output failed"
[ "$out22b" = "42" ] || fail "a second run naming an output answered '$out22b' rather than 42 -- a run served by a receipt does not run at all"

# --- leg 26: the compiler's digest is remembered beside the binary that read it --------------
# The record is the whole mechanism: without one, every build re-reads 172 MB to
# learn what no hand has changed. It must exist, and it must say which file it
# speaks for, or a later build could answer for a compiler it never opened.
rm -f "$PEN"/rye-key-cache.*.kyri "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "record-baseline build failed"
# The KEY line is the claim in every leg below; the output line may honestly
# differ between two rebuilds, exactly as leg 12 already states.
k26=$(stamp | head -1)
record=$(grep -l "^path $ZIG$" "$PEN"/rye-key-cache.*.kyri 2>/dev/null | head -1)
[ -n "$record" ] || fail "the build left no remembered record naming the compiler"
grep -q '^format rye-key-cache-v1$' "$record" || fail "the record carries no format line"
grep -q '^sha256 [0-9a-f]\{64\}$' "$record" || fail "the record carries no 64-hex digest"
grep -q '^inode [0-9]\{1,\}$' "$record" || fail "the record carries no inode"
grep -q '^ctime [0-9]\{1,\}$' "$record" || fail "the record carries no status-change time"

# --- leg 27: the record is CONSULTED -- a wrong digest under a true identity moves the key ----
# A cache nobody reads passes every other leg in this file. So the record's own
# digest is flipped while its five other readings stay true, and the key must
# move: that can only happen if the key took its compiler digest from here.
# A PLANT MUST DIFFER FROM THE TRUTH, or the assertion beside it proves nothing.
# Flipping the first character to `0` is a no-op on a digest that already begins
# with `0`, which happens one run in sixteen -- and there this leg red on a
# healthy tree while leg 28 below passed having tested nothing. Sixty-four zeros
# can never be a SHA-256 of anything, and the plant is compared against the true
# record before it is trusted to be a plant at all. Booked `20260916.213500`.
ZERO_DIGEST=0000000000000000000000000000000000000000000000000000000000000000
cp "$record" "$PEN/record.true"
sed "s|^sha256 .*|sha256 $ZERO_DIGEST|" "$PEN/record.true" > "$PEN/record.next"
cmp -s "$PEN/record.next" "$PEN/record.true" && fail "the planted compiler digest matched the true one"
[ "$(wc -c < "$PEN/record.next" | tr -d ' ')" = "$(wc -c < "$PEN/record.true" | tr -d ' ')" ] \
    || fail "the planted record changed size"
cat "$PEN/record.next" > "$record"
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "planted-record build failed"
k27=$(stamp | head -1)
[ "$k27" != "$k26" ] || fail "a planted compiler digest did not reach the key -- the record is never read"
cat "$PEN/record.true" > "$record"
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "restored-record build failed"
[ "$(stamp | head -1)" = "$k26" ] || fail "restoring the record did not restore the key"

# --- leg 28: EACH of the five identity readings is compared, one plant apiece ----------------
# A LEG OVER A CONJUNCTION PROVES ONLY THE FIRST CLAUSE THAT REFUSES. Five
# readings must all agree before a remembered digest is used -- path, inode,
# size, mtime, ctime -- and one plant that trips several of them at once says
# nothing about the rest. So each field is corrupted ALONE, and beside it the
# digest, which is what makes the assertion sharp: a compared field refuses the
# record, the bytes answer, and the key returns to its baseline. Delete any one
# comparison from `digest_record_read` in `rye/src/main.rye` and that field's
# plant is trusted, the wrong digest reaches the key, and this leg reds.
for field in path inode size mtime ctime; do
    case "$field" in
        path) sed "s|^path .*|path /nowhere/at/all|; s|^sha256 .*|sha256 $ZERO_DIGEST|" "$PEN/record.true" > "$record" ;;
        *)    sed "s|^$field .*|$field 1|; s|^sha256 .*|sha256 $ZERO_DIGEST|" "$PEN/record.true" > "$record" ;;
    esac
    grep -q "^sha256 $ZERO_DIGEST$" "$record" || fail "the $field plant did not also move the digest"
    rm -f "$KEY"
    env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
        || fail "$field-plant build failed"
    [ "$(stamp | head -1)" = "$k26" ] \
        || fail "a record whose $field disagreed with the file was trusted"
done
cat "$PEN/record.true" > "$record"

# --- leg 29: a same-size rewrite in place, with its mtime restored, still misses -------------
# The identity's fourth reading earns its place on a real file rather than in a
# doctored record. inode, size and mtime all stand still across this flip; only
# the status-change time moves, and no ordinary call sets that backward. Without
# ctime the key would serve a digest for bytes that had changed underneath it.
printf '#!/bin/sh\n# ct-a\nexec "%s" "$@"\n' "$ZIG" > "$PEN/zigct"
chmod +x "$PEN/zigct"
rm -f "$KEY" "$PEN"/rye-key-cache.*.kyri
env RYE_ZIG="$PEN/zigct" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "ctime-baseline build failed"
k29a=$(stamp | head -1)
cp -p "$PEN/zigct" "$PEN/zigct.ref"
before_size=$(wc -c < "$PEN/zigct" | tr -d ' ')
printf '#!/bin/sh\n# ct-b\nexec "%s" "$@"\n' "$ZIG" | dd of="$PEN/zigct" conv=notrunc 2>/dev/null
touch -r "$PEN/zigct.ref" "$PEN/zigct"
[ "$(wc -c < "$PEN/zigct" | tr -d ' ')" = "$before_size" ] || fail "the in-place plant changed size"
[ "$(file_mtime "$PEN/zigct")" = "$(file_mtime "$PEN/zigct.ref")" ] \
    || fail "the in-place plant left the modification time moved"
rm -f "$KEY"
env RYE_ZIG="$PEN/zigct" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "ctime-flip build failed"
[ "$(stamp | head -1)" != "$k29a" ] || fail "a same-inode same-size same-mtime rewrite did not change the key"

# --- leg 30: a build that can earn no receipt remembers nothing ------------------------------
# The reorder this family rides on -- decide first, read second -- leaves one
# mark a shell can read: a build with no receipt to consult opens no compiler,
# so it writes no record either.
rm -f "$PEN"/rye-key-cache.*.kyri "$KEY"
( cd "$PEN" && env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" build "$PEN/main.rye" ) \
    || fail "no-emit record build failed"
[ -z "$(ls "$PEN"/rye-key-cache.*.kyri 2>/dev/null)" ] || fail "a no-emit build wrote a record"
env RYE_ZIG="$ZIG" RYE_LIB="$REPO/rye/lib" "$PEN/ryeflip" run "$PEN/main.rye" >/dev/null 2>&1 \
    || fail "run record leg failed"
[ -z "$(ls "$PEN"/rye-key-cache.*.kyri 2>/dev/null)" ] || fail "a run wrote a record"

# --- leg 31: the library tree's digest is remembered beside the binary that read it ----------
# The tree is 552 files and 16,416,628 bytes on this pier, and reading them was
# about four fifths of a warm receipt reading: a hit of 225-236 ms fell to
# 111-132 when this record landed. So the record is the whole mechanism here
# too, and it must say which ROOT it speaks for -- a record answering for a
# tree it never walked is the fault the compiler's own record booked at
# `20260916.203519`.
rm -f "$PEN"/rye-key-library.*.kyri "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "library-record baseline build failed"
k31=$(stamp | head -1)
lib_record=$(grep -l "^root $PEN/lib2/std$" "$PEN"/rye-key-library.*.kyri 2>/dev/null | head -1)
[ -n "$lib_record" ] || fail "the build left no remembered record naming the library root"
grep -q '^format rye-key-library-v1$' "$lib_record" || fail "the library record carries no format line"
grep -q '^identity [0-9a-f]\{64\}$' "$lib_record" || fail "the library record carries no 64-hex identity"
grep -q '^sha256 [0-9a-f]\{64\}$' "$lib_record" || fail "the library record carries no 64-hex content digest"

# THE SAME PLANT DISCIPLINE LEG 27 NOW CARRIES, reached through one constant:
# a planted digest must be one no file can honestly speak, and it is compared
# against the truth before it is trusted to be a plant.
plant_lib_digest() { # plant_lib_digest <true-record>
    sed "s|^sha256 .*|sha256 $ZERO_DIGEST|" "$1" > "$PEN/lib-record.planted"
    cmp -s "$PEN/lib-record.planted" "$1" && fail "the planted library digest matched the true one"
    cat "$PEN/lib-record.planted" > "$lib_record"
}

# --- leg 32: the library record is CONSULTED -- a wrong digest under a true identity moves it -
# A cache nobody reads passes every other leg in this file. The content digest is
# replaced while the identity stays true, and the key must move: that can only
# happen if the key took the library's digest from here rather than from 16 MB.
cp "$lib_record" "$PEN/lib-record.true"
plant_lib_digest "$PEN/lib-record.true"
[ "$(wc -c < "$PEN/lib-record.planted" | tr -d ' ')" = "$(wc -c < "$PEN/lib-record.true" | tr -d ' ')" ] \
    || fail "the planted library record changed size"
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "planted-library-record build failed"
[ "$(stamp | head -1)" != "$k31" ] \
    || fail "a planted library digest did not reach the key -- the record is never read"
cat "$PEN/lib-record.true" > "$lib_record"
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "restored-library-record build failed"
[ "$(stamp | head -1)" = "$k31" ] || fail "restoring the library record did not restore the key"

# --- leg 33: each COMPARED FIELD of the library record is refused by its own plant ------------
# A LEG OVER A CONJUNCTION PROVES ONLY THE FIRST CLAUSE THAT REFUSES, which this
# family learned at REDS %779. The record carries exactly three compared fields
# beside its digest -- format, root, identity -- so each is corrupted ALONE with
# the digest replaced beside it. A compared field refuses the record, the tree's
# bytes answer, and the key returns to its baseline. Delete any one comparison
# from `library_record_read` in `rye/src/main.rye` and that plant is trusted,
# the wrong digest reaches the key, and this leg reds.
for field in format root identity; do
    case "$field" in
        format)   sed "s|^format .*|format rye-key-library-v0|; s|^sha256 .*|sha256 $ZERO_DIGEST|" "$PEN/lib-record.true" > "$lib_record" ;;
        root)     sed "s|^root .*|root /nowhere/at/all|; s|^sha256 .*|sha256 $ZERO_DIGEST|" "$PEN/lib-record.true" > "$lib_record" ;;
        identity) sed "s|^identity .*|identity $ZERO_DIGEST|; s|^sha256 .*|sha256 $ZERO_DIGEST|" "$PEN/lib-record.true" > "$lib_record" ;;
    esac
    grep -q "^sha256 $ZERO_DIGEST$" "$lib_record" || fail "the library $field plant did not also move the digest"
    rm -f "$KEY"
    env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
        || fail "library $field-plant build failed"
    [ "$(stamp | head -1)" = "$k31" ] \
        || fail "a library record whose $field disagreed was trusted"
done
cat "$PEN/lib-record.true" > "$lib_record"

# --- legs 34 and 35: the tree's MEMBERSHIP is inside the identity, both directions ------------
# ONE STAT CANNOT STAND FOR A TREE, and these two legs are why. Adding a file
# moves no existing file's size, inode, modification time or status-change time
# -- the walk's own count and sorted path stream are the only readings that can
# explain a refusal, so the plant is isolated to membership by construction.
# Removing one proves the same door from the other side, since a record built
# over the larger tree must not answer for the smaller.
#
# THE DETECTOR IS THE RECORD RATHER THAN THE KEY. A refused identity sends the
# build back to the bytes and a rewritten record lands; a trusted one leaves the
# plant exactly where it stood. So the surviving record is compared against the
# planted bytes, which is exact where a grep for one character is not.
printf 'pub const pen_extra: u32 = 7;\n' > "$PEN/std-copy/zz-pen-extra.zig"
plant_lib_digest "$PEN/lib-record.true"
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "added-library-file build failed"
cmp -s "$lib_record" "$PEN/lib-record.planted" \
    && fail "a file added to the library tree left the remembered digest trusted"
cp "$lib_record" "$PEN/lib-record.wider"

rm -f "$PEN/std-copy/zz-pen-extra.zig"
plant_lib_digest "$PEN/lib-record.wider"
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "removed-library-file build failed"
cmp -s "$lib_record" "$PEN/lib-record.planted" \
    && fail "a file removed from the library tree left the remembered digest trusted"

# --- leg 36: the status-change time earns its place on a real file ----------------------------
# `chmod` moves ctime and nothing else a reader can see: the path, the size, the
# inode and the modification time all stand still across it. So this is the one
# reading of the four that a filesystem lets a control isolate, and it is the
# one that catches a same-size rewrite whose modification time was restored --
# leg 29's own subject, one input over.
#
# THE THREE THAT CANNOT BE ISOLATED SAY SO. A size change moves mtime with it; a
# rename and a replacement each move ctime; and no ordinary call sets ctime
# backward, so ctime shadows them all. Their presence in the stream is proven by
# deleting an update from `library_identity_update` in `rye/src/main.rye` and
# watching a leg object, rather than by a plant this control can write.
cp "$lib_record" "$PEN/lib-record.mode"
plant_lib_digest "$PEN/lib-record.mode"
before_mode_mtime=$(file_mtime "$PEN/std-copy/ascii.zig")
before_mode_size=$(wc -c < "$PEN/std-copy/ascii.zig" | tr -d ' ')
chmod g+w "$PEN/std-copy/ascii.zig"
[ "$(file_mtime "$PEN/std-copy/ascii.zig")" = "$before_mode_mtime" ] \
    || fail "the mode plant moved the modification time"
[ "$(wc -c < "$PEN/std-copy/ascii.zig" | tr -d ' ')" = "$before_mode_size" ] \
    || fail "the mode plant changed the size"
rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "library mode-flip build failed"
cmp -s "$lib_record" "$PEN/lib-record.planted" \
    && fail "a library file whose status-change time moved left the remembered digest trusted"

# --- leg 37: a build that can earn no receipt remembers no library either ---------------------
# The same mark leg 30 reads, one input over: decide first, read second. A build
# with no receipt to consult never walks the library, so it writes no record.
rm -f "$PEN"/rye-key-library.*.kyri "$KEY"
( cd "$PEN" && env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" ) \
    || fail "no-emit library-record build failed"
[ -z "$(ls "$PEN"/rye-key-library.*.kyri 2>/dev/null)" ] || fail "a no-emit build wrote a library record"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" run "$PEN/main.rye" >/dev/null 2>&1 \
    || fail "run library-record leg failed"
[ -z "$(ls "$PEN"/rye-key-library.*.kyri 2>/dev/null)" ] || fail "a run wrote a library record"
# --- legs 38 to 44: a memo family is held to a ceiling, oldest evicted first --------------------
# WHY THESE LEGS. A record is reached by the digest of its subject's PATH, so a
# new path means a new file rather than a replaced one, and until `20260916`
# nothing ever removed one -- this control's own pens leave a record apiece, each
# naming a root deleted the moment its pen closed (REDS %790). `rye/bin/` is
# gitignored, so no meter in the tree can see the room; the only bound is the one
# `rye/src/main.rye` states, and a stated bound proven by nobody is a comment.
#
# THE PLANT IS FORTY RECORDS WITH ASCENDING MODIFICATION TIMES, so the eviction
# order is readable from the names alone rather than from a timestamp a reader
# would have to trust. Beside them stand three things the pass must NOT touch: a
# peer's half-written `.writing` temporary, a same-prefix name of the wrong
# width, and the other family's records. Delete the `record_family_evict` call
# from either writer in `rye/src/main.rye` and leg 38 reds on the count.
EVICT_CEILING=32
EVICT_PLANTED=40
rm -f "$PEN"/rye-key-cache.*.kyri "$PEN"/rye-key-library.*.kyri "$KEY"
# One ordinary build first, so the library family stands at its real population
# before the file family is crowded -- leg 43 compares that count across the pass.
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "eviction baseline build failed"
lib_before=$(ls "$PEN"/rye-key-library.*.kyri 2>/dev/null | wc -l | tr -d ' ')
[ "$lib_before" -ge 1 ] || fail "the eviction baseline build wrote no library record"

# THE ROOM IS MEASURED AT THE ONE MOMENT IT CAN ONLY HAVE GROWN -- a record
# landing -- so the crowded build must MISS rather than hit. Clearing the file
# family is what forces that miss; leaving the baseline's records in place would
# let every subject answer from memory, write nothing, and evict nothing, which
# is the behavior working rather than failing.
rm -f "$PEN"/rye-key-cache.*.kyri

evict_name() { printf '%s/rye-key-cache.%016x.kyri' "$PEN" "$1"; }
i=1
while [ "$i" -le "$EVICT_PLANTED" ]; do
    f=$(evict_name "$i")
    printf 'format rye-key-cache-v1\npath /nowhere/pen/%s\n' "$i" > "$f"
    # 2026-01-01 00:00 plus one minute per record: distinct, ascending, and far
    # enough back that every planted record is older than anything this pen wrote.
    touch -t "$(printf '202601010%03d.00' "$i")" "$f" 2>/dev/null \
        || fail "could not age planted record $i"
    i=$((i + 1))
done
# The three bystanders, each a different reason the pass must pass it over.
printf 'half\n' > "$PEN/rye-key-cache.00000000000000ff.kyri.writing"
printf 'wrong width\n' > "$PEN/rye-key-cache.dead.kyri"
touch -t 202601010001.00 "$PEN/rye-key-cache.00000000000000ff.kyri.writing" \
    "$PEN/rye-key-cache.dead.kyri" 2>/dev/null \
    || fail "could not age the eviction bystanders"

rm -f "$KEY"
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "eviction build failed"

# --- leg 38: the family stands at exactly its ceiling ------------------------------------------
# THE COUNT SPELLS THE RECORD SHAPE, since `rye-key-cache.*.kyri` also matches
# the wrong-width bystander leg 42 plants -- which is the point of that bystander
# and would otherwise read as one record too many.
after=$(ls "$PEN"/rye-key-cache.????????????????.kyri 2>/dev/null | wc -l | tr -d ' ')
[ "$after" = "$EVICT_CEILING" ] \
    || fail "the file record family stands at $after records, not its ceiling of $EVICT_CEILING"

# --- leg 39: the oldest planted record is gone, the newest still stands ------------------------
[ -e "$(evict_name 1)" ] && fail "the oldest planted record survived the eviction"
[ -e "$(evict_name "$EVICT_PLANTED")" ] || fail "the newest planted record was evicted"

# --- leg 40: eviction ran OLDEST FIRST, with no survivor older than a victim -------------------
# Read from the names rather than from a count, so the leg holds whatever number
# of records one build happens to write. Every missing plant must sort before
# every surviving plant; one inversion is an eviction picking by something other
# than age, which is exactly the fault a stable order exists to refuse.
evict_missing_max=0
evict_present_min=0
i=1
while [ "$i" -le "$EVICT_PLANTED" ]; do
    if [ -e "$(evict_name "$i")" ]; then
        [ "$evict_present_min" = 0 ] && evict_present_min=$i
    else
        evict_missing_max=$i
    fi
    i=$((i + 1))
done
[ "$evict_present_min" != 0 ] || fail "the eviction removed every planted record"
[ "$evict_missing_max" -lt "$evict_present_min" ] \
    || fail "a planted record older than a survivor stood after the eviction (missing up to $evict_missing_max, present from $evict_present_min)"

# --- leg 41: a peer's half-written temporary is never the victim -------------------------------
# It carries the family's own prefix and five characters more. Deleting one
# mid-rename loses a record a second build is in the middle of landing, which is
# why the name test is an exact width rather than a prefix match.
[ -e "$PEN/rye-key-cache.00000000000000ff.kyri.writing" ] \
    || fail "the eviction deleted a peer's half-written temporary"

# --- leg 42: a same-prefix name of the wrong width is not this family's to delete --------------
[ -e "$PEN/rye-key-cache.dead.kyri" ] \
    || fail "the eviction deleted a same-prefix name that is not a record"

# --- leg 43: one family can never evict the other ----------------------------------------------
# The ceiling is per family on purpose, keeping both single-stranded: forty file
# records crowding the room left the library family exactly where it stood.
lib_after=$(ls "$PEN"/rye-key-library.*.kyri 2>/dev/null | wc -l | tr -d ' ')
[ "$lib_after" = "$lib_before" ] \
    || fail "crowding the file family moved the library family from $lib_before to $lib_after"

# --- leg 44: the ceiling holds across a second build, and the memo still answers ---------------
# A ceiling that only bites once is a one-time tidy. The build after it must sit
# at the same number AND still skip, since eviction may never cost a hit that
# was already earned.
k44=$(stamp | head -1)
env RYE_ZIG="$ZIG" RYE_LIB="$PEN/lib2" "$PEN/ryeflip" build "$PEN/main.rye" "-femit-bin=$BIN" \
    || fail "post-eviction build failed"
[ "$(stamp | head -1)" = "$k44" ] || fail "a build after an eviction stopped skipping"
steady=$(ls "$PEN"/rye-key-cache.????????????????.kyri 2>/dev/null | wc -l | tr -d ' ')
[ "$steady" -le "$EVICT_CEILING" ] \
    || fail "the family rose to $steady records on the build after an eviction"

echo "legs=44 all proven -- twelve flips missed, including same-size compiler and library bytes, root and dependency source modes, and a sibling emit flag's value; five hits held, among them one toolchain and one library reached by another path and one output renamed with its receipt; the bypass rebuilt and now names itself rather than this binary's path, an unkeyable flag is blamed on the flag rather than on a file the skip never opened, two fresh builds agreed, run stayed exempt twice over, once with no output named and once naming one; the compiler's remembered digest was shown consulted by planting one, each of its five identity readings refused by its own plant, a same-size rewrite with its mtime restored still missed, and no record was written where no receipt could be earned; and the same seven readings taken of the LIBRARY TREE's record -- it exists and names its root, it was shown consulted by planting a digest into it, each of its three compared fields refused its own plant, a file added and a file removed each refused the remembered digest with no existing file's stat moved, a mode change that moved only the status-change time refused it too, and a build earning no receipt walked no library and wrote no record; and each memo family held to a named ceiling of thirty-two records -- forty planted records crowded the file family and the room came back to exactly thirty-two, the oldest planted record gone and the newest standing, with no survivor older than a victim, while a peer's half-written .writing temporary and a same-prefix name of the wrong width were both passed over, the library family stood exactly where it had, and the build after the eviction still skipped"
echo "CONTROL_GREEN: the receipt misses on every flipped input and skips only byte-identical builds"
echo "ryekey_verdict=green"
