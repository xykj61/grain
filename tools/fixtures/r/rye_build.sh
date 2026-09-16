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

module=$(dirname "$src")
lock="$module/.rye-build.lock"
wait_max=${RYE_BUILD_LOCK_WAIT:-900}

lock_acquire "$lock" "$wait_max" || {
  echo "rye_build: refused -- waited ${wait_max}s for $lock and it stayed held" >&2
  exit 3
}
# The lock is released on every exit, including an interrupt, so a build killed mid-compile never
# leaves the room shut. `trap` fires before the shell ends whatever ended it.
trap 'lock_release "$lock"' EXIT INT TERM

"$root/rye/bin/rye" build "$@"
