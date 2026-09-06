#!/bin/sh
# tools/fixtures/p/path_absence_scan.sh -- is this path absent, or is this checkout behind?
#
#   sh tools/fixtures/p/path_absence_scan.sh <path> [<path> ...]
#
# WHY THIS EXISTS (REDS %457). A seat was asked to run `tools/fixtures/f/fleet_login_scan.sh`,
# could not find it, and reported: *no file, no reference to that name anywhere in the tree,
# tracked or untracked*. Every word was true of the bytes it could see, and the conclusion was
# false -- the file had landed three commits earlier and that checkout had not fetched. A
# whole-tree grep is the most convincing evidence a seat can gather, and at a stale HEAD it is
# evidence about a tree nobody else is standing in.
#
# ON A FLEET THIS IS THE ORDINARY CASE RATHER THAN THE EDGE. Eight ships push to one remote, so a
# checkout is behind within minutes of opening; the round-open pulls at lap START and a grep
# happens mid-lap. So absence is the one reading a seat must never take from local bytes alone.
#
# WHAT IT ANSWERS, per path: whether the working tree holds it, whether the anointed remote's head
# holds it, and how far behind this checkout stands. `verdict=absent` requires BOTH to say no.
#
# IT FETCHES, and that is the point rather than a side effect: an answer about upstream drawn from
# a stale remote-tracking ref is the same fault one layer down.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
REMOTE=${ANOINTED_REMOTE:-xy}

[ $# -ge 1 ] || { echo "detail: name at least one path"; echo "verdict=no_path"; exit 2; }

if git fetch -q "$REMOTE" 2>/dev/null; then
  echo "fetched=$REMOTE"
else
  echo "fetched=no"
  echo "detail: could not reach $REMOTE -- an upstream reading below is from a possibly stale ref"
fi
behind=$(git rev-list --count "HEAD..$REMOTE/main" 2>/dev/null || echo unknown)
echo "commits_behind=$behind"

missing=0; stale_only=0
for p in "$@"; do
  here=no; there=no
  [ -e "$p" ] && here=yes
  git cat-file -e "$REMOTE/main:$p" 2>/dev/null && there=yes
  echo "path $p here=$here upstream=$there"
  if [ "$here" = no ] && [ "$there" = yes ]; then
    stale_only=$((stale_only + 1))
    echo "detail: $p exists upstream and not here -- this checkout is behind, the path is not absent"
  elif [ "$here" = no ]; then
    missing=$((missing + 1))
  fi
done
echo "absent_here_only=$stale_only"
echo "absent_both=$missing"

[ "$stale_only" -eq 0 ] || { echo "verdict=behind"; exit 1; }
[ "$missing" -eq 0 ] || { echo "verdict=absent"; exit 1; }
echo "verdict=present"
