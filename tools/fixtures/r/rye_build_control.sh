#!/bin/sh
# rye_build_control.sh -- the per-module build lock, shown answering every way it can.
#
#   sh tools/fixtures/r/rye_build_control.sh
#
# Every refusal is planted and then LIFTED, because a refusal proven only in the failing direction
# cannot be told from a wrapper that always refuses.
#
# THE LEG THAT CARRIES THE WEIGHT is `two_modules_concurrent`. A lock that serialized EVERY build
# would pass a naive "no collision" test while costing the tree its parallelism, so the control
# proves the lock is per MODULE by holding one room shut and watching a build in another walk
# straight through.
set -eu

root=$(cd "$(dirname "$0")/../../.." && pwd -P)
cd "$root"
wrap=tools/fixtures/r/rye_build.sh
legs=0
faults=0
note() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then echo "leg $1=ok"
  else echo "leg $1=FAULT want=$2 got=$3"; faults=$((faults + 1)); fi
}

pen=$(mktemp -d)
trap 'rm -rf "$pen" lotus/.rye-build.lock image/.rye-build.lock dimeroll/.rye-build.lock pond/apps/.rye-build.lock' EXIT

# ---- a non-.rye first argument refuses rather than building something unexpected
sh "$wrap" lotus/pan.zig >/dev/null 2>&1 && c=0 || c=$?
note rejects_non_rye 2 "$c"

# ---- a source that does not exist refuses by name
sh "$wrap" lotus/no_such_module_here.rye >/dev/null 2>&1 && c=0 || c=$?
note rejects_absent 2 "$c"

# ---- no argument at all refuses
sh "$wrap" >/dev/null 2>&1 && c=0 || c=$?
note rejects_empty 2 "$c"

# ---- an ordinary build succeeds and leaves no lock behind
env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" lotus/pan.rye -femit-bin="$pen/pan" >/dev/null 2>&1 && c=0 || c=$?
note builds_ok 0 "$c"
note binary_made yes "$( [ -s "$pen/pan" ] && echo yes || echo no )"
note lock_released none "$( [ -d lotus/.rye-build.lock ] && echo held || echo none )"

# ---- A HELD LOCK MAKES THE NEXT BUILD WAIT, and the bound refuses rather than hanging forever.
# The lock is planted by hand with a LIVE owner, so the helper cannot reap it as abandoned.
mkdir -p lotus/.rye-build.lock
sh -c 'sleep 30' & holder=$!
printf '%s\n' "$holder" > lotus/.rye-build.lock/pid
RYE_BUILD_LOCK_WAIT=2 env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" lotus/pan.rye -femit-bin="$pen/p2" >/dev/null 2>&1 && c=0 || c=$?
note held_lock_refuses 3 "$c"

# ---- THE LOCK IS PER MODULE: another room builds while lotus stays shut
env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" image/qoi.rye -femit-bin="$pen/qoi" >/dev/null 2>&1 && c=0 || c=$?
note two_modules_concurrent 0 "$c"

kill "$holder" 2>/dev/null || :
wait "$holder" 2>/dev/null || :
rm -rf lotus/.rye-build.lock

# ---- the refusal LIFTS once the room is free again
env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" lotus/pan.rye -femit-bin="$pen/p3" >/dev/null 2>&1 && c=0 || c=$?
note refusal_lifts 0 "$c"

# ---- A LOCK WHOSE OWNER HAS DIED IS REAPED, never waited out forever
mkdir -p lotus/.rye-build.lock
printf '%s\n' 999999 > lotus/.rye-build.lock/pid
RYE_BUILD_LOCK_WAIT=5 env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" lotus/pan.rye -femit-bin="$pen/p4" >/dev/null 2>&1 && c=0 || c=$?
note dead_owner_reaped 0 "$c"
rm -rf lotus/.rye-build.lock

# ---- THE IMPORTED ROOM IS COVERED, which is the whole point of the walk. A source that imports
# across a room writes a shadow beside the IMPORTED file, so holding that other room must stop the
# build even though the source's own room is free.
cross=pond/apps/commerce_trade.rye
if [ -f "$cross" ]; then
  mkdir -p dimeroll/.rye-build.lock
  sh -c 'sleep 25' & xholder=$!
  printf '%s\n' "$xholder" > dimeroll/.rye-build.lock/pid
  RYE_BUILD_LOCK_WAIT=2 env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" "$cross" -femit-bin="$pen/x1" >/dev/null 2>&1 && c=0 || c=$?
  note imported_room_covered 3 "$c"
  note source_room_free none "$( [ -d pond/apps/.rye-build.lock ] && echo held || echo none )"
  kill "$xholder" 2>/dev/null || :
  wait "$xholder" 2>/dev/null || :
  rm -rf dimeroll/.rye-build.lock
  env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" "$cross" -femit-bin="$pen/x2" >/dev/null 2>&1 && c=0 || c=$?
  note cross_refusal_lifts 0 "$c"
  note cross_locks_released none "$( [ -d dimeroll/.rye-build.lock ] || [ -d pond/apps/.rye-build.lock ] && echo held || echo none )"
fi

# ---- the room bound refuses rather than truncating in silence
RYE_BUILD_MAX_ROOMS=0 env RYE_ZIG=vendor/zig-toolchain/zig sh "$wrap" lotus/pan.rye -femit-bin="$pen/p5" >/dev/null 2>&1 && c=0 || c=$?
note room_bound_refuses 4 "$c"

echo "legs=$legs"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=fault"; fi
