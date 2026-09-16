#!/bin/sh
# tools/fixtures/r/rye_build_lock_holder_control.sh -- can a live holder's build lock be taken from it?
#
# WHAT THE LOCK IS FOR. `rye/src/main.rye` takes one tree-wide lock before it bridges any `.rye`
# source to the `.zig` shadow the toolchain reads, because two builds staging one shadow delete each
# other's files mid-compile and the loser reports RED about correct code (REDS %281). The lock is a
# directory, since mkdir is atomic; the pid written inside it is how a waiter tells a live holder
# from a corpse and clears only the corpse.
#
# THE GAP THIS READS. The elder protocol created the directory and wrote the pid in two separate
# calls, so between them the lock stood with NOTHING inside. A waiter meeting that state twice, one
# 50ms poll apart, called it a corpse and cleared it -- out from under a live holder, which then
# bridged beside the waiter that took it. Two readings make that worse than the "two-line window"
# the elder comment priced it at: the pid write's refusal was swallowed on purpose, so a failed write
# left the lock anonymous forever with no timing luck at all; and under the eight parallel builds
# this pier actually runs, a stall of one poll between two syscalls is ordinary.
#
# THE REPAIR IS THAT THE ANONYMOUS STATE NO LONGER EXISTS. `build_lock_claim` assembles a complete
# lock -- pid already inside -- in a staging directory, then `rename`s it into place. `rename` onto a
# directory that already holds a pid refuses with `DirNotEmpty`, so the move is both the claim and
# the test of it, and no observer ever sees a lock without its holder's name in it.
#
# THE ANSWER THAT DID NOT WORK, recorded because it reads convincing. Reading the pid back after
# writing it cannot detect the theft: a holder robbed during the gap writes its own pid OVER the
# thief's and reads back exactly what it just wrote. That was this lap's first repair, and writing
# this control is what found it.
#
# HOW THE WINDOW IS OPENED ON DEMAND. `RYE_BUILD_LOCK_STALL_MS` holds a claim still inside its one
# window so a second process can look through it. A race proven only by running many builds and
# counting failures is a race nobody can show twice.
#
# WHAT THIS DOES NOT REACH, named rather than implied. The elder compiler carries no stall hook, so
# its window cannot be widened here and its fault is shown the other way -- by planting the anonymous
# state its own protocol creates and watching the elder walk into it. The elder's window WIDTH is
# therefore read off its source rather than timed on metal.
#
# Run from the repository root:
#   sh tools/fixtures/r/rye_build_lock_holder_control.sh
set -u

root=$(pwd)
pen=$(mktemp -d 2>/dev/null || echo "$root/.lap/lock-holder-pen-$$")
trap 'rm -rf "$pen"' EXIT

legs=0
fails=0

leg() {
  legs=$((legs + 1))
  name=$1
  want=$2
  got=$3
  if [ "$want" = "$got" ]; then
    echo "leg=$name want=$want got=$got ok"
  else
    fails=$((fails + 1))
    echo "leg=$name want=$want got=$got FAILED"
  fi
}

give_up() {
  cd "$root" 2>/dev/null || true
  echo "control_legs=$legs control_fail=$fails"
  echo "verdict=$1"
  exit 0
}

zig=${RYE_ZIG:-$root/vendor/zig-toolchain/zig}
[ -x "$zig" ] || zig=$(command -v zig 2>/dev/null || echo "")
{ [ -n "$zig" ] && [ -x "$zig" ]; } || give_up skipped_no_toolchain
[ -x "$root/rye/bin/rye" ] || give_up skipped_no_compiler

# --- the two compilers ---------------------------------------------------------------------------
# The repaired one is the working tree's source. The elder is the last commit before this lap's
# repair, named here rather than taken from a binary somebody kept -- and CHECKED, because a ref that
# quietly resolved to the repair would compare it with itself and every leg below would pass for the
# wrong reason.
mkdir -p "$pen/new/src" "$pen/old/src"
cp "$root/rye/src/main.rye" "$pen/new/src/main.rye"
elder_ref=${RYE_LOCK_ELDER_REF:-c6b715a92d}
git -C "$root" show "$elder_ref:rye/src/main.rye" > "$pen/old/src/main.rye" 2>/dev/null || give_up skipped_no_elder_source

leg repaired_claims_by_rename 1 "$(grep -c 'fn build_lock_claim' "$pen/new/src/main.rye")"
leg elder_has_no_claim 0 "$(grep -c 'fn build_lock_claim' "$pen/old/src/main.rye")"
leg elder_creates_lock_directly 1 "$(grep -c 'dir.createDir(io, build_lock_dir' "$pen/old/src/main.rye")"
leg repaired_never_creates_lock_directly 0 "$(grep -c 'dir.createDir(io, build_lock_dir' "$pen/new/src/main.rye")"
[ "$fails" -eq 0 ] || give_up control_failed

# `-lc` is not optional and not a flourish: the lock reads `c.getpid()`, and Zig 0.16 refuses a
# libc symbol unless the build command says so. `rye/bootstrap.sh` carries the same flag for the
# same reason, so a compiler built here is built the way the tree builds its own.
build_compiler() {
  env RYE_ZIG="$zig" "$root/rye/bin/rye" build "$1" -femit-bin="$2" --zig-lib-dir "$root/rye/lib" -lc \
    > "$2.buildlog" 2>&1
}
build_compiler "$pen/new/src/main.rye" "$pen/rye-new" || give_up skipped_repaired_build_failed
build_compiler "$pen/old/src/main.rye" "$pen/rye-old" || give_up skipped_elder_build_failed

# --- the pen tree a build runs in ----------------------------------------------------------------
new_tree() {
  rm -rf "$pen/tree"
  mkdir -p "$pen/tree/mod" "$pen/tree/out"
  cat > "$pen/tree/mod/leaf.rye" <<'RYE'
const std = @import("std");
pub fn value() u32 {
    return 7;
}
RYE
  cat > "$pen/tree/mod/thing.rye" <<'RYE'
const std = @import("std");
const leaf = @import("leaf.rye");
pub fn main() !void {
    std.debug.print("{d}\n", .{leaf.value()});
}
RYE
}

run_build() {
  compiler=$1
  tag=$2
  shift 2
  ( cd "$pen/tree" && env RYE_ZIG="$zig" RYE_LIB="$root/rye/lib" "$@" "$compiler" build mod/thing.rye \
      -femit-bin="out/$tag" ) > "$pen/$tag.out" 2>&1
  echo $?
}

lock_state() {
  if [ ! -d "$pen/tree/.rye-build.lock" ]; then
    echo none
  elif [ -f "$pen/tree/.rye-build.lock/pid" ]; then
    echo named
  else
    echo anonymous
  fi
}

staging_count() {
  find "$pen/tree" -maxdepth 1 -name '.rye-build.lock.staging.*' 2>/dev/null | wc -l | tr -d ' '
}

# --- the ordinary build ---------------------------------------------------------------------------
new_tree
leg clean_build_ok 0 "$(run_build "$pen/rye-new" clean)"
leg clean_lock_released none "$(lock_state)"
leg clean_no_staging_litter 0 "$(staging_count)"

# --- THE SUBJECT: what an observer sees while a claim is held open --------------------------------
# The repaired compiler stalls between staging its complete lock and moving it into place. Throughout
# that stall the lock is either absent or already named -- never anonymous, which is the one state
# the elder protocol published and the whole reason a live holder could be robbed.
new_tree
( cd "$pen/tree" && env RYE_ZIG="$zig" RYE_LIB="$root/rye/lib" RYE_BUILD_LOCK_STALL_MS=2000 \
    "$pen/rye-new" build mod/thing.rye -femit-bin=out/stalled ) > "$pen/stalled.out" 2>&1 &
stalled=$!
anonymous_looks=0
staging_looks=0
looks=0
while [ "$looks" -lt 16 ]; do
  [ "$(lock_state)" = anonymous ] && anonymous_looks=$((anonymous_looks + 1))
  [ "$(staging_count)" -gt 0 ] && staging_looks=$((staging_looks + 1))
  looks=$((looks + 1))
  sleep 0.1
done
leg stalled_never_anonymous 0 "$anonymous_looks"
# The stall must actually have been inside the window, or the leg above watched nothing at all --
# a reading of nothing is indistinguishable from a healthy one.
leg stalled_window_observed yes "$( [ "$staging_looks" -gt 0 ] && echo yes || echo no )"
wait "$stalled" 2>/dev/null
leg stalled_build_finishes 0 "$?"
leg stalled_lock_released none "$(lock_state)"

# --- a second build arriving inside that window ---------------------------------------------------
# The waiter meets either no lock or a named one, so it never mistakes the holder for a corpse. Both
# builds finish and neither loses a shadow to the other.
new_tree
( cd "$pen/tree" && env RYE_ZIG="$zig" RYE_LIB="$root/rye/lib" RYE_BUILD_LOCK_STALL_MS=1500 \
    "$pen/rye-new" build mod/thing.rye -femit-bin=out/pair-a ) > "$pen/pair-a.out" 2>&1 &
pa=$!
sleep 1
( cd "$pen/tree" && env RYE_ZIG="$zig" RYE_LIB="$root/rye/lib" \
    "$pen/rye-new" build mod/thing.rye -femit-bin=out/pair-b ) > "$pen/pair-b.out" 2>&1 &
pb=$!
wait "$pa" 2>/dev/null; leg paired_holder_finishes 0 "$?"
wait "$pb" 2>/dev/null; leg paired_waiter_finishes 0 "$?"
leg paired_no_shadow_loss 0 "$( (cat "$pen/pair-a.out" "$pen/pair-b.out" 2>/dev/null || true) | grep -c 'unable to load' )"
leg paired_lock_released none "$(lock_state)"

# --- THE RED, SHOWN. The elder walks into the anonymous state its own protocol publishes ----------
# The elder carries no stall hook, so the state is planted instead: an anonymous lock is exactly what
# the elder leaves behind between its own two calls. It clears it and builds, which is the theft.
new_tree
mkdir -p "$pen/tree/.rye-build.lock"
leg elder_enters_anonymous_lock 0 "$(run_build "$pen/rye-old" elder_anon)"
leg elder_cleared_it none "$(lock_state)"

# --- and the waiter half is deliberately UNCHANGED ------------------------------------------------
# Under the repaired protocol an anonymous lock can only be a corpse -- a leftover from a killed
# elder build or a hand -- so clearing it stays correct, and the repaired compiler does exactly what
# the elder did. This leg passing is the point: the repair moved the holder, never the waiter.
new_tree
mkdir -p "$pen/tree/.rye-build.lock"
leg repaired_also_clears_anonymous 0 "$(run_build "$pen/rye-new" new_anon)"
leg repaired_cleared_it none "$(lock_state)"

# --- a corpse with a name is still cleared ---------------------------------------------------------
new_tree
mkdir -p "$pen/tree/.rye-build.lock"
# A pid no live process holds, so `kill -0` on it fails and the lock reads as a corpse.
printf '2147483646\n' > "$pen/tree/.rye-build.lock/pid"
leg named_corpse_reaped 0 "$(run_build "$pen/rye-new" corpse)"

# --- a LIVE holder is waited on, never stolen from --------------------------------------------------
new_tree
mkdir -p "$pen/tree/.rye-build.lock"
sh -c 'sleep 8' &
holder=$!
printf '%s\n' "$holder" > "$pen/tree/.rye-build.lock/pid"
start=$(date +%s)
( cd "$pen/tree" && env RYE_ZIG="$zig" RYE_LIB="$root/rye/lib" "$pen/rye-new" build mod/thing.rye \
    -femit-bin=out/waited ) > "$pen/waited.out" 2>&1 &
waiter=$!
sleep 3
leg live_holder_not_stolen named "$(lock_state)"
leg live_holder_pid_intact "$holder" "$(tr -d ' \n' < "$pen/tree/.rye-build.lock/pid" 2>/dev/null)"
leg live_holder_no_staging_litter 0 "$(staging_count)"
# Reaped as well as killed: `kill -0` succeeds on a zombie, so an unreaped holder would read alive
# and the waiter would sit out its whole 600s bound over a process that is already gone.
kill "$holder" 2>/dev/null
wait "$holder" 2>/dev/null
wait "$waiter" 2>/dev/null; rc=$?
end=$(date +%s)
leg waiter_finished_once_free 0 "$rc"
leg waiter_actually_waited yes "$( [ $((end - start)) -ge 3 ] && echo yes || echo no )"

# --- the stall hook is bounded and off by default --------------------------------------------------
new_tree
start=$(date +%s)
rc=$(run_build "$pen/rye-new" clamped env RYE_BUILD_LOCK_STALL_MS=99999999)
end=$(date +%s)
leg absurd_stall_still_builds 0 "$rc"
leg absurd_stall_clamped yes "$( [ $((end - start)) -lt 120 ] && echo yes || echo no )"
new_tree
leg no_stall_by_default 0 "$(run_build "$pen/rye-new" nostall)"

cd "$root" || exit 1
echo "control_legs=$legs control_fail=$fails"
if [ "$fails" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=control_failed"; fi
