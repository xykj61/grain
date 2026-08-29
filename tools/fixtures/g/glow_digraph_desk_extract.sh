#!/bin/sh
# Emit digraphs from glow/gen/s/sample-digraph-table.glow rows='...' cord -- one per line.
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
DESK="$ROOT/glow/gen/s/sample-digraph-table.glow"
line=$(grep -E "^rows='" "$DESK" | head -1)
# strip rows=' ... trailing '
inner=${line#rows=\'}
inner=${inner%\'}
# space-separated -> one digraph per line
printf '%s\n' $inner
