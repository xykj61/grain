#!/bin/sh
# Census control scan -- thin POSIX entry (e126 climb - start rung sh->rish).
#
# Prefer Rishi orchestration when the binary is present; otherwise drive the
# same seams from shell so Cloud benches without zig/rye stay green.
#
#   sh tools/fixtures/c/census_control_scan.sh
#   sh tools/fixtures/c/census_control_scan.sh prove-red
#
# Law: POSIX seams -- keep .sh entry points, orchestration in .rish.
# Law: one duty, one implementation -- duty bodies live in the seams.
set -eu

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"

if test -x "$ROOT/rishi/bin/rishi"; then
  exec "$ROOT/rishi/bin/rishi" run tools/fixtures/c/census_control_scan.rish "$@"
fi

exec sh tools/fixtures/c/census_control_scan_drive.sh "$@"
