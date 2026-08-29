#!/bin/sh
# Closed sample of the living Tally caller map -- paths must exist.
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

missing=0
for p in \
  caravan/tally_copy.rye \
  caravan/parse_int.rye \
  mantra/tally_copy.rye \
  mantra/parse_int.rye \
  comlink/tally_copy.rye \
  comlink/parse_int.rye \
  amphora/tally_copy.rye \
  amphora/kumara.rye \
  granary/tally_copy.rye \
  granary/parse_int.rye \
  linengrow/tally_copy.rye \
  linengrow/parse_int.rye \
  linengrow/kumara.rye \
  glow/tally_copy.rye \
  brushstroke/tally_copy.rye \
  rishi/src/tally_copy.rye \
  rishi/src/parse_int.rye \
  mandi/tally_copy.rye \
  tools/rye/kumara.rye
do
  if [ ! -e "$p" ]; then
    echo "$p"
    missing=1
  fi
done

exit "$missing"
