#!/bin/sh
# rye_key_control.sh -- `rye key` proven from both sides, in a throwaway pen.
#
# WHAT IT STANDS OVER. `rye key <file.rye> -femit-bin=<path>` answers whether the
# binary standing at that path is current, and builds nothing to find out. It
# prints `verdict=hit|miss|unkeyable` with the key these sources speak and the
# key standing on disk, and exits 0 on a hit and 1 on anything that means build.
#
# THE LOAD-BEARING LEG IS LEG 3, and every other leg is scaffolding around it:
# the key `rye key` prints BEFORE a build must equal, character for character,
# the key that build then writes into its receipt. Two computations that agree
# today drift the first time one is edited alone, and a key reading that drifts
# is worse than none -- it reports `hit` on a binary nobody would ship. The one
# structural answer is ONE computation, so `key` walks the identical path
# `build` walks and stops at the seam where reading becomes writing. This leg is
# what proves it stayed one path.
#
# THE SECOND CLAIM IS ABSENCE, which needs its own reading: `key` must leave the
# tree exactly as it found it. A `.zig` shadow beside a source, a deleted stamp,
# a spawned toolchain -- each would make the reading a small build, and a caller
# reaching for a cheap predicate would be paying for one. Leg 2 counts the pen
# before and after.
#
# A VERDICT PROVEN ONLY ONE WAY CANNOT BE TOLD FROM A CONSTANT. `hit` is planted
# and then lifted six times over: an edited root, an edited dependency, a
# tampered binary, a removed receipt, a moved output, and a changed flag each
# turn a proven hit into a miss and back. `unkeyable` is proven apart from
# `miss` in four causes, because they mean different things to a caller -- one
# says build now, the other says this build will never be spared -- and each
# names its own reason rather than sharing one word.
#
# THE BINARY CAN PREDATE THE VERB. `rye/bin/rye` is untracked, so a pier carries
# whatever it last built, and one built before this verb landed answers `unknown
# command`. That is a MACHINE FACT, named and skipped at exit 0, never a red:
# nothing in the tree is wrong and `sh rye/bootstrap.sh` fixes it. The version
# is asked at the door rather than inferred from a failed leg four legs later --
# the lesson REDS %219 and %258 already paid for one control over.
#
# Run from the repository root:
#   sh tools/fixtures/r/rye_key_control.sh [path-to-rye-binary]
#
# Exit 0 with CONTROL_GREEN on the last line; exit 1 naming the first leg that
# failed. Nothing outside the pen is written; the pen is removed on exit.

set -u

# Root by upward walk: the letter fold moves this script's depth, and fixed
# ../.. arithmetic is what breaks. Git-free, so a pen copy outside a repository
# still resolves. Bounded at 8 steps, loud past the bound.
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
[ -x "$RYE_BIN" ] || { echo "rye-key-control: no rye binary at $RYE_BIN"; exit 1; }
[ -x "$ZIG" ] || { echo "rye-key-control: no toolchain at $ZIG"; exit 1; }

LEGS=0
PEN=""
cleanup() { [ -n "$PEN" ] && rm -rf "$PEN"; }
trap cleanup EXIT INT TERM
fail() { echo "rye-key-control: FAILED -- $1" >&2; echo "rye_key_verdict=red"; exit 1; }
leg() { LEGS=$((LEGS + 1)); }

# --- the door: does this binary know the verb at all? ----------------------------------------
# Asked by BEHAVIOR rather than by version string. A version compare answers
# what a binary CLAIMS; running the verb answers what it DOES, and those part
# whenever a binary is rebuilt from an elder source under a newer stamp.
probe=$(env RYE_ZIG="$ZIG" "$RYE_BIN" key 2>&1)
case "$probe" in
  *"unknown command"*)
    echo "rye-key-control: this pier's rye binary has no 'key' verb -- built before it landed."
    echo "rye-key-control: run  sh rye/bootstrap.sh  to build one that does."
    echo "rye_key_verdict=machine_fact"
    exit 0 ;;
esac

PEN=$(mktemp -d) || fail "could not make a pen"
BIN="$PEN/out"
KEY="$PEN/out.ryekey"
SRC="$PEN/main.rye"
DEP="$PEN/dep.rye"

cat > "$DEP" <<'EOF'
const std = @import("std");
pub fn greet() void {
    std.debug.print("dep\n", .{});
}
EOF
cat > "$SRC" <<'EOF'
const std = @import("std");
const dep = @import("dep.rye");
pub fn main() void {
    dep.greet();
}
EOF

# Every reading of the verb goes through one door, so no leg can quietly use a
# different toolchain or forget the emit flag and pass for the wrong reason.
ask() { env RYE_ZIG="$ZIG" "$RYE_BIN" key "$SRC" "-femit-bin=$BIN" "$@" 2>&1; }
ask_code() { ask "$@" >/dev/null 2>&1; echo $?; }
verdict_of() { printf '%s\n' "$1" | sed -n 's/^verdict=//p'; }
key_of() { printf '%s\n' "$1" | sed -n 's/^key=//p'; }
standing_of() { printf '%s\n' "$1" | sed -n 's/^standing=//p'; }
reason_of() { printf '%s\n' "$1" | sed -n 's/^reason=//p'; }
build() { env RYE_ZIG="$ZIG" "$RYE_BIN" build "$SRC" "-femit-bin=$BIN" "$@" >/dev/null 2>&1; }

# --- leg 1: no receipt, no binary -- the verdict is miss, and the exit says build -------------
leg
out=$(ask)
[ "$(verdict_of "$out")" = "miss" ] || fail "leg 1: a cold pen answered '$(verdict_of "$out")' rather than miss"
[ "$(ask_code)" = "1" ] || fail "leg 1: a miss must exit 1, so a shell can branch on it"
cold_key=$(key_of "$out")
case "$cold_key" in
  ????????????????????????????????????????????????????????????????) : ;;
  *) fail "leg 1: a cold reading printed no 64-character key, got '$cold_key'" ;;
esac
leg
[ "$(standing_of "$out")" = "-" ] || fail "leg 1: an absent receipt must print '-' rather than an empty field"

# --- leg 2: asking writes nothing ------------------------------------------------------------
# The whole point of the verb. Counted rather than eyeballed: a shadow beside a
# source is exactly what a staging walk leaves, and it is invisible unless
# somebody looks for it by name.
leg
before=$(ls -A "$PEN" | sort)
ask >/dev/null 2>&1
after=$(ls -A "$PEN" | sort)
[ "$before" = "$after" ] || fail "leg 2: asking changed the pen -- before [$before] after [$after]"
leg
[ ! -f "$PEN/main.zig" ] || fail "leg 2: asking staged a .zig shadow beside the root source"
leg
[ ! -f "$PEN/dep.zig" ] || fail "leg 2: asking staged a .zig shadow beside a dependency"

# --- leg 2b: a READ-ONLY tree still answers ------------------------------------------------------
# THE LISTING ABOVE PROVES THE WRONG CLAIM ON ITS OWN, and a mutation is what
# said so. Staging is followed by a defer that deletes every shadow, so a
# reading that stages and cleans up leaves the pen byte for byte as it found it
# -- the before/after comparison reads identical and calls it absence. Planted
# by making the key reading stage after all, legs 1 through 16 all stood green.
#
# That state is not cosmetic. Shadows are written BESIDE THE SOURCE, which is
# the shared namespace REDS %734 booked: one module's shadow name is written by
# every build that imports it, and a reading holding no lock would delete a
# concurrent build's inputs mid-compile. So the claim has to be `writes nothing
# AT ALL`, and only a tree that refuses writes can tell that from `tidies up
# after itself`.
#
# Root bypasses file permissions, so the detector is PROVEN TO BE ARMED before
# it is trusted: if a probe file can still be created, the leg is skipped out
# loud rather than passing for a reason that has nothing to do with the code.
leg
chmod -R a-w "$PEN" 2>/dev/null
if (set -C; : > "$PEN/.writable-probe") 2>/dev/null; then
  rm -f "$PEN/.writable-probe"
  chmod -R u+w "$PEN" 2>/dev/null
  echo "rye-key-control: SKIP leg 2b -- this user writes through a read-only directory (root?), so the detector is not armed here"
else
  ro=$(ask)
  ro_verdict=$(verdict_of "$ro")
  chmod -R u+w "$PEN" 2>/dev/null
  [ "$ro_verdict" = "miss" ] || fail "leg 2b: a read-only tree answered '$ro_verdict' rather than miss -- asking wrote something and the defers hid it"
fi

# --- leg 3: THE LOAD-BEARING ONE -- the asked key is the built key ----------------------------
# Taken in this order on purpose: the key is read BEFORE the build exists, so it
# cannot have been copied from a receipt. If the two computations ever part,
# this is the leg that says so.
leg
build || fail "leg 3: the build under test failed"
[ -f "$KEY" ] || fail "leg 3: the build wrote no receipt"
built_key=$(head -1 "$KEY")
[ "$cold_key" = "$built_key" ] || fail "leg 3: the key asked before the build ($cold_key) is not the key the build wrote ($built_key) -- the two computations have drifted"

# --- leg 4: with the receipt standing, the verdict is hit and the exit says current -----------
leg
out=$(ask)
[ "$(verdict_of "$out")" = "hit" ] || fail "leg 4: a fresh build answered '$(verdict_of "$out")' rather than hit"
[ "$(ask_code)" = "0" ] || fail "leg 4: a hit must exit 0"
leg
[ "$(key_of "$out")" = "$(standing_of "$out")" ] || fail "leg 4: a hit printed two different keys"
leg
[ "$(standing_of "$out")" = "$built_key" ] || fail "leg 4: the standing key printed is not the receipt's own first line"

# --- leg 5: asking twice does not move the answer ---------------------------------------------
# A reading with a side effect would show up here as a hit that becomes a miss.
leg
[ "$(verdict_of "$(ask)")" = "hit" ] || fail "leg 5: a second reading of an unchanged tree stopped hitting"
leg
[ -f "$KEY" ] || fail "leg 5: asking removed the standing receipt"

# --- leg 6: an edited ROOT source misses, and returns when restored ----------------------------
leg
cp "$SRC" "$PEN/root.bak"
printf '// planted\n' >> "$SRC"
[ "$(verdict_of "$(ask)")" = "miss" ] || fail "leg 6: an edited root source still read hit"
leg
cp "$PEN/root.bak" "$SRC"
[ "$(verdict_of "$(ask)")" = "hit" ] || fail "leg 6: restoring the root source did not restore the hit -- the plant proves nothing"

# --- leg 7: an edited DEPENDENCY misses, and returns when restored -----------------------------
# Apart from leg 6 on purpose: a walk that hashes only the root passes leg 6 and
# fails here, which is the whole reason the closure is walked at all.
leg
cp "$DEP" "$PEN/dep.bak"
printf '// planted\n' >> "$DEP"
[ "$(verdict_of "$(ask)")" = "miss" ] || fail "leg 7: an edited dependency still read hit -- the walk is reading the root alone"
leg
cp "$PEN/dep.bak" "$DEP"
[ "$(verdict_of "$(ask)")" = "hit" ] || fail "leg 7: restoring the dependency did not restore the hit"

# --- leg 8: a tampered BINARY misses, though the key still matches ------------------------------
# The receipt's second line answers for the emitted bytes, so a hand-replaced
# binary must miss even while every source is untouched.
leg
cp "$BIN" "$PEN/bin.bak"
printf 'tamper' >> "$BIN"
[ "$(verdict_of "$(ask)")" = "miss" ] || fail "leg 8: a tampered binary still read hit -- the emitted bytes are not being checked"
leg
cp "$PEN/bin.bak" "$BIN"
[ "$(verdict_of "$(ask)")" = "hit" ] || fail "leg 8: restoring the binary did not restore the hit"

# --- leg 9: a removed receipt misses -------------------------------------------------------------
leg
cp "$KEY" "$PEN/key.bak"
rm -f "$KEY"
out=$(ask)
[ "$(verdict_of "$out")" = "miss" ] || fail "leg 9: a removed receipt still read hit"
leg
[ "$(standing_of "$out")" = "-" ] || fail "leg 9: a removed receipt printed a standing key out of nowhere"
leg
cp "$PEN/key.bak" "$KEY"
[ "$(verdict_of "$(ask)")" = "hit" ] || fail "leg 9: restoring the receipt did not restore the hit"

# --- leg 10: a changed FLAG misses ----------------------------------------------------------------
# Flags join the key whole, so asking about a different build is a different
# question and must not be answered with this build's receipt.
leg
[ "$(verdict_of "$(ask -OReleaseSmall)")" = "miss" ] || fail "leg 10: an added optimization flag still read hit"
leg
[ "$(verdict_of "$(ask)")" = "hit" ] || fail "leg 10: dropping the flag again did not restore the hit"

# --- leg 11: the output's PATH is not the question, and its bytes are ------------------------------
# A binary moved WITH its receipt keeps it -- the move every ship makes to
# replace a running tool. The key must follow the pair rather than the spelling.
leg
mv "$BIN" "$PEN/moved"
mv "$KEY" "$PEN/moved.ryekey"
moved=$(env RYE_ZIG="$ZIG" "$RYE_BIN" key "$SRC" "-femit-bin=$PEN/moved" 2>&1)
[ "$(verdict_of "$moved")" = "hit" ] || fail "leg 11: a binary moved with its receipt stopped hitting"
leg
[ "$(verdict_of "$(ask)")" = "miss" ] || fail "leg 11: the vacated path still read hit with no binary standing there"
leg
mv "$PEN/moved" "$BIN"
mv "$PEN/moved.ryekey" "$KEY"
[ "$(verdict_of "$(ask)")" = "hit" ] || fail "leg 11: moving the pair back did not restore the hit"

# --- leg 12: unkeyable is its own verdict, and names its own cause ---------------------------------
# Four causes, four sentences. A caller meeting unkeyable has to change
# something about the build to earn a receipt at all, and one shared word would
# leave them guessing which thing.
leg
noemit=$(env RYE_ZIG="$ZIG" "$RYE_BIN" key "$SRC" 2>&1)
[ "$(verdict_of "$noemit")" = "unkeyable" ] || fail "leg 12: a build naming no output read '$(verdict_of "$noemit")' rather than unkeyable"
leg
[ "$(env RYE_ZIG="$ZIG" "$RYE_BIN" key "$SRC" >/dev/null 2>&1; echo $?)" = "1" ] || fail "leg 12: unkeyable must exit 1 -- it means build, the same as a miss"
leg
case "$(reason_of "$noemit")" in
  *-femit-bin*) : ;;
  *) fail "leg 12: an unnamed output's reason never mentions -femit-bin: '$(reason_of "$noemit")'" ;;
esac
leg
[ "$(key_of "$noemit")" = "-" ] || fail "leg 12: an unkeyable reading printed a key it cannot stand behind"

# --- leg 13: an unreadable toolchain is unkeyable, and says which ------------------------------------
leg
absent=$(env RYE_ZIG="$PEN/no-such-zig" "$RYE_BIN" key "$SRC" "-femit-bin=$BIN" 2>&1)
[ "$(verdict_of "$absent")" = "unkeyable" ] || fail "leg 13: an unreadable toolchain read '$(verdict_of "$absent")' rather than unkeyable"
leg
case "$(reason_of "$absent")" in
  *toolchain*) : ;;
  *) fail "leg 13: an unreadable toolchain blamed something else: '$(reason_of "$absent")'" ;;
esac

# --- leg 14: an unkeyable FLAG is told apart from an unkeyable build ----------------------------------
leg
flagged=$(ask "-I$PEN")
[ "$(verdict_of "$flagged")" = "unkeyable" ] || fail "leg 14: an include-path flag read '$(verdict_of "$flagged")' rather than unkeyable"
leg
case "$(reason_of "$flagged")" in
  *flag*) : ;;
  *) fail "leg 14: an unkeyable flag blamed something else: '$(reason_of "$flagged")'" ;;
esac

# --- leg 15: every reading carries all four fields -----------------------------------------------------
# A field that goes missing turns a machine reader into a guesser, and the three
# verdicts are printed from one place precisely so they cannot drift apart.
for reading in "$(ask)" "$(env RYE_ZIG="$ZIG" "$RYE_BIN" key "$SRC" 2>&1)"; do
  leg
  for field in verdict key standing reason; do
    printf '%s\n' "$reading" | grep -q "^$field=" || fail "leg 15: a reading printed no $field= line"
  done
done

# --- leg 16: asking builds nothing, even when it must answer miss ----------------------------------------
# The cold pen proved absence with nothing to rebuild. This proves it where the
# temptation is real: a miss is exactly the state a build would act on.
leg
rm -f "$KEY"
before=$(ls -A "$PEN" | sort)
[ "$(verdict_of "$(ask)")" = "miss" ] || fail "leg 16: the setup for the absence reading did not miss"
[ "$(ls -A "$PEN" | sort)" = "$before" ] || fail "leg 16: a miss reading changed the pen -- asking is building after all"
leg
[ ! -f "$KEY" ] || fail "leg 16: a miss reading wrote a receipt it had not earned"

# --- leg 17: asking takes no build lock ------------------------------------------------------------
# A predicate that blocks for the length of somebody else's build is a predicate
# callers stop reaching for, and `rye build` waits on `.rye-build.lock` in the
# working directory. The lock is planted here held by a process that genuinely
# exists -- this shell -- so the reaper cannot decide it is stale and clear it,
# which would prove nothing. The reading must answer at once and answer the same.
# Leg 16 left the receipt removed on purpose, so the hit is earned back here
# before the lock is planted -- otherwise this leg would read the miss leg 16
# arranged and blame the lock for it.
build || fail "leg 17: could not rebuild the receipt leg 16 removed"
leg
mkdir -p "$PEN/work" && cd "$PEN/work" || fail "leg 17: could not make a working directory"
mkdir -p "$PEN/work/.rye-build.lock" || fail "leg 17: could not plant the lock"
printf '%s\n' "$$" > "$PEN/work/.rye-build.lock/pid" || fail "leg 17: could not write the lock's pid"
locked=$(env RYE_ZIG="$ZIG" "$RYE_BIN" key "$SRC" "-femit-bin=$BIN" 2>&1)
cd "$REPO" || fail "leg 17: could not return to the repository root"
[ "$(verdict_of "$locked")" = "hit" ] || fail "leg 17: a held build lock changed the reading to '$(verdict_of "$locked")' -- asking is waiting on builds"
leg
[ -f "$PEN/work/.rye-build.lock/pid" ] || fail "leg 17: the reading released a lock it never took"

echo "legs=$LEGS all proven -- the key asked before a build equals the key that build writes; asking stages no shadow even transiently -- proven against a read-only tree, since the defers hide a staging walk from a listing -- takes no build lock, spawns nothing, and writes no receipt on hit or miss; six plants turned hit to miss and were lifted again, among them an edited dependency and a tampered binary; a pair moved together kept its receipt; unkeyable stands apart from miss in four causes, each naming its own"
echo "CONTROL_GREEN: rye key answers the receipt question by reading, and its answer is the build's own"
echo "rye_key_verdict=green"
