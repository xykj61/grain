#!/bin/sh
# tools_py_ban_scan.sh -- blocking tools/*.py count (Python-at-seam law).
#
# Exit 0 + TOOLS_PY_OK when every tools/*.py under SCAN_ROOT is either absent
# or listed in tools/fixtures/t/tools_py_exempt.txt.
# Exit 1 + TOOLS_PY_BAD listing offenders otherwise.
#
# TOOLS_PY_SCAN_ROOT -- override root (default: repository root). The negative
# selftest points this at context/fixtures/tools_py_ban_tree so a planted .py
# FAILS without polluting the living tools/*.py census.
set -eu

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
HERE=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$HERE/rishi/bin" ] || [ ! -d "$HERE/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$HERE" = "/" ] || [ -z "$HERE" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  HERE=$(dirname "$HERE")
done
SCAN_ROOT=${TOOLS_PY_SCAN_ROOT:-$HERE}
cd "$SCAN_ROOT"

EXEMPT="$HERE/tools/fixtures/t/tools_py_exempt.txt"
TMP=$(mktemp)
trap 'rm -f "$TMP" "$TMP.all" "$TMP.walk" "$TMP.ign"' EXIT

# A PATH GIT IGNORES IS NOT TREE EVIDENCE, AND THIS WALK ASKS GIT RATHER THAN SPELLING TWO NAMES.
# The elder line pruned `tools/.cache` (the HAWM Android SDK) and `tools/.build` by name, with the
# reason written beside it: both stay gitignored, and counting them false-REDs the living tree on
# Framework. So this guard had already PAID for the fault, and paid it in the one direction a guard
# must never be wrong in -- a red on every ship for a file no clone holds is how a gate gets turned
# off. What the elder line could not do is cover the room nobody had opened yet: a third ignored
# directory under `tools/`, or a `git worktree` parked there, carries a `.py` past a list of two.
# REDS %722 booked exactly that class after `.lap/verify` reddened a no-slack ceiling one guard over.
#
# The ignore rules are the tree's own statement of what it disowns, kept current by whichever hand
# opens a room, so they are asked instead. The two names stay as the fallback for the pen this
# script is built to run in: the root walk above is deliberately git-free, and a copy running outside
# a repository must still refuse a planted `.py` rather than read every path as ignored. Which
# branch ran is printed, since a silent fallback is the same shape of fault this repair closes.
if git rev-parse --git-dir >/dev/null 2>&1; then
  TOOLS_PY_FILTER=git
  find tools -name '*.py' -type f -print 2>/dev/null | sort >"$TMP.walk" || : >"$TMP.walk"
  : >"$TMP.all"
  if [ -s "$TMP.walk" ]; then
    # One batched call rather than one per path: `--stdin` answers for the whole walk at once.
    git check-ignore --stdin <"$TMP.walk" 2>/dev/null | sort >"$TMP.ign" || : >"$TMP.ign"
    comm -23 "$TMP.walk" "$TMP.ign" >"$TMP.all" || : >"$TMP.all"
  fi
else
  TOOLS_PY_FILTER=spelled
  find tools \( -path 'tools/.cache' -o -path 'tools/.build' \) -prune -o \
    -name '*.py' -type f -print 2>/dev/null | sort >"$TMP.all" || : >"$TMP.all"
fi
echo "TOOLS_PY_FILTER=$TOOLS_PY_FILTER"
: >"$TMP"

while IFS= read -r path; do
  [ -n "$path" ] || continue
  skip=0
  if [ -f "$EXEMPT" ]; then
    while IFS= read -r line; do
      case "$line" in ''|\#*) continue ;; esac
      if [ "$line" = "$path" ]; then
        skip=1
        break
      fi
    done <"$EXEMPT"
  fi
  if [ "$skip" -eq 0 ]; then
    echo "$path" >>"$TMP"
  fi
done <"$TMP.all"

if [ -s "$TMP" ]; then
  echo "TOOLS_PY_BAD"
  cat "$TMP"
  exit 1
fi
echo "TOOLS_PY_OK"
exit 0
