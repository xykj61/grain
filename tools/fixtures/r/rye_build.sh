#!/bin/sh
# rye_build.sh -- one `rye build` at a time per module directory.
#
#   sh tools/fixtures/r/rye_build.sh <source.rye> [rye build args...]
#
# WHY (REDS %734, cause captured `20260915.195922`). `rye/src/main.rye` bridges each `.rye` to an
# ADJACENT `.zig` in the source directory, then, in its own words, "clears them all away" when the
# build ends. Two builds running over one module therefore generate the same shadow names, and the
# first to finish deletes them while the second is still compiling -- which the compiler reports as
# `unable to load 'timeline.zig'`. The file is a real source that existed a moment earlier.
#
# The shadows are the build's INPUT, which is why moving its OUTPUT into a pen could not reach this:
# a pen gives each run its own binary and leaves the source namespace shared by every module in the
# room. `lotus/timeline.rye` is imported by 211 modules, so one build of any of them writes a name
# 210 others also write.
#
# THE LOCK IS PER MODULE, never global, because the hazard is the shared directory. Two builds in
# DIFFERENT rooms share no shadow name and run side by side untouched; two in one room take turns.
#
# THE WAIT IS BOUNDED AND REFUSES BY NAME. A build that cannot get its turn inside the bound exits
# non-zero saying so, rather than proceeding into the collision it was built to avoid. The helper
# reaps a lock whose owner has died, so a killed build leaves no lock nobody will release.
set -eu

[ $# -ge 1 ] || { echo "rye_build: want a .rye source path" >&2; exit 2; }
src=$1

root=$(cd "$(dirname "$0")/../../.." && pwd -P)
. "$root/tools/fixtures/s/shell_portable.sh"
cd "$root"

case "$src" in
  *.rye) : ;;
  *) echo "rye_build: first argument must be a .rye source, got '$src'" >&2; exit 2 ;;
esac
[ -f "$src" ] || { echo "rye_build: no such source: $src" >&2; exit 2; }

# THE LOCK COVERS EVERY ROOM THIS BUILD WRITES INTO, never only the source's own. A cross-room
# import bridges to a shadow BESIDE THE IMPORTED FILE, so building `pond/apps/thing.rye` writes
# `mantra/beading.zig` as surely as it writes its own room -- and `pond/apps` carries 149 such
# imports. A lock on the root directory alone would serialize two pond builds correctly and leave
# a pond build racing a mantra build exactly as exposed as before.
#
# The walk is a bounded breadth-first pass over `@import("<room>/<file>.rye")`, because an imported
# room may import further: `pond/apps` reaches `brushstroke`, which reaches rooms of its own.
# DEPTH AND WIDTH ARE BOUNDED and the bound refuses rather than truncating in silence.
max_rooms=${RYE_BUILD_MAX_ROOMS:-24}
max_depth=${RYE_BUILD_MAX_DEPTH:-8}

rooms=$(dirname "$src")
frontier=$src
depth=0
while [ -n "$frontier" ] && [ "$depth" -lt "$max_depth" ]; do
  next=""
  for f in $frontier; do
    [ -f "$f" ] || continue
    for imp in $(grep -ohE '@import\("[a-z_]+/[^"]*\.rye"\)' "$f" 2>/dev/null \
                 | sed -E 's|@import\("||; s|"\)||'); do
      [ -f "$imp" ] || continue
      d=$(dirname "$imp")
      case " $rooms " in *" $d "*) : ;; *) rooms="$rooms $d"; next="$next $imp" ;; esac
    done
  done
  frontier=$next
  depth=$((depth + 1))
done

# ONE ORDER FOR EVERY CALLER, which is what keeps two builds from deadlocking on each other. Two
# processes taking the same rooms in sorted order can never each hold what the other wants next.
rooms=$(printf '%s\n' $rooms | sort -u)
count=$(printf '%s\n' $rooms | grep -c .)
[ "$count" -le "$max_rooms" ] || {
  echo "rye_build: refused -- $src reaches $count rooms, past the bound of $max_rooms" >&2
  exit 4
}

wait_max=${RYE_BUILD_LOCK_WAIT:-900}
held=""
# Every lock taken is released on any exit, including an interrupt, so a build killed mid-compile
# never leaves a room shut. A room that cannot be taken releases the ones already held first.
release_all() { for l in $held; do lock_release "$l"; done; }
trap 'release_all' EXIT INT TERM

for d in $rooms; do
  lock="$d/.rye-build.lock"
  lock_acquire "$lock" "$wait_max" || {
    echo "rye_build: refused -- waited ${wait_max}s for $lock and it stayed held" >&2
    exit 3
  }
  held="$held $lock"
done

"$root/rye/bin/rye" build "$@"
