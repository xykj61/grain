#!/bin/sh
# tools/fixtures/b/build_lock_ignore_scan.sh -- every in-tree lock this tree takes is a lock
# `.gitignore` names.
#
# WHY THIS READING EXISTS (REDS %805's deferred half, priced on metal `20260917`).
#
# `lock_acquire` in tools/fixtures/s/shell_portable.sh holds a lock as the DIRECTORY -- `mkdir` is
# its atomic test-and-set -- and writes the holder's pid inside it. A lock is therefore an
# untracked directory standing in the working tree for exactly as long as its holder runs.
#
# `git stash push -u` sweeps UNTRACKED files and passes over IGNORED ones. `tools/f/fleet_round_open.sh`
# stashes that way at every lap open. So a lock `.gitignore` does not name is a lock a round-open
# REMOVES while its holder is still running, and the next acquirer `mkdir`s it successfully and
# enters the room the lock exists to serialize. That is correctness rather than hygiene: the build
# lock born at `%734` exists because two builds in one room write the same shadow `.zig` names.
#
# Measured on the seating lap: four in-tree locks, three named -- `/lotus/.sing.lock/` and
# `construction/standing-equipment-run.lock.d/` by name, `glow/.cache/.build.lock.d` incidentally
# by its parent `/glow/.cache/` -- and the build lock named by nothing, in whatever room a build
# writes.
#
# WHAT IT READS, AND WHAT IT DECLINES.
#
# A lock outside the tree -- the two port locks under `${TMPDIR:-/tmp}` -- is a lock git never sees,
# so it is counted and reported as `outside` and gates nothing. Only a path git could sweep is asked.
#
# A VARIABLE-ROOTED lock is probed at THREE DEPTHS rather than one. `$d/.rye-build.lock` takes
# whatever room a build writes, so a rule spelled `/amphora/.rye-build.lock/` would satisfy a
# depth-one probe and leave every deeper room swept. A lock counts as ignored only when git ignores
# it at every depth it can take.
#
# The argument is resolved through ONE same-file assignment hop, `${VAR:-default}` taking the
# default. A lock whose path this scan cannot resolve is reported `unresolved` and counted, never
# assumed free -- an instrument that cannot read a site says so.
#
#   sh tools/fixtures/b/build_lock_ignore_scan.sh [--list]
#
# BUILD_LOCK_IGNORE_ROOT names another tree, for the pen.

set -u

root=${BUILD_LOCK_IGNORE_ROOT:-.}
list=no
[ "${1:-}" = "--list" ] && list=yes

cd "$root" 2>/dev/null || { echo "verdict=no_root"; exit 1; }

# The roster: tracked runners taking a lock. A control, a scan ABOUT locks, and the portable
# helper's own header each name `lock_acquire` without taking one, so each is read past by name.
roster=$(git ls-files -- '*.sh' '*.rish' 2>/dev/null \
  | grep -v 'shell_portable\.sh$' \
  | grep -v '_control\.sh$' \
  | grep -v 'build_lock_ignore_scan\.sh$' \
  | grep -v 'concurrency_scan\.sh$')

# THE PROBE ROOMS ARE DERIVED, AND THE FIRST RUN OF THIS SCAN PROVED WHY THEY MUST BE.
# This tree's `.gitignore` denies the root with `/*` and allows project paths back one at a time,
# so a FICTIONAL probe root -- `a/`, `a/b/` -- is ignored by that blanket deny and every lock reads
# ignored. The probe rooms are therefore real rooms a build writes: the directories of tracked
# `.rye` sources, one at each of three depths, taken in sorted order so the reading is stable.
probe_rooms=""
probe_depths=0
_rye_dirs=$(git ls-files -- '*.rye' 2>/dev/null | sed 's|/[^/]*$||' | sort -u)
for _depth in 1 2 3; do
  _pick=$(printf '%s\n' $_rye_dirs | awk -F/ -v d="$_depth" 'NF == d { print; exit }')
  [ -n "$_pick" ] || continue
  probe_rooms="$probe_rooms $_pick"
  probe_depths=$((probe_depths + 1))
done
[ "$probe_depths" -gt 0 ] || { echo "verdict=no_probe_rooms"; exit 1; }

in_tree=0
ignored=0
unignored=0
outside=0
unresolved=0

for f in $roster; do
  [ -f "$f" ] || continue
  # Each call site's first argument, comments stepped past.
  args=$(sed -n 's/^[[:space:]]*lock_acquire[[:space:]]\{1,\}\("[^"]*"\|[^[:space:]]\{1,\}\).*/\1/p' "$f" | tr -d '"')
  [ -n "$args" ] || continue

  for a in $args; do
    path=$a
    # One assignment hop, same file. ${VAR:-default} takes the default.
    case $path in
      '$'*)
        var=$(printf '%s' "$path" | sed 's/^\$//; s/^{//; s/}$//')
        rhs=$(sed -n "s/^[[:space:]]*${var}=\(.*\)/\1/p" "$f" | head -1 | tr -d '"')
        [ -n "$rhs" ] && path=$rhs
        ;;
    esac
    # ${VAR:-default} anywhere in the resolved path takes its default.
    path=$(printf '%s' "$path" | sed 's/\${[A-Za-z_][A-Za-z0-9_]*:-\([^}]*\)}/\1/g')

    case $path in
      /*)
        outside=$((outside + 1))
        [ "$list" = yes ] && echo "outside $f $path"
        continue
        ;;
      *'$'*'/'*)
        # Variable-rooted: the literal tail after the last slash is the lock's own name, probed at
        # three depths, since a rule anchored to one room leaves every other room swept.
        tail=${path##*/}
        case $tail in
          *'$'*) unresolved=$((unresolved + 1)); [ "$list" = yes ] && echo "unresolved $f $path"; continue ;;
        esac
        in_tree=$((in_tree + 1))
        miss=0
        for base in $probe_rooms; do
          git check-ignore -q "$base/$tail/pid" 2>/dev/null || miss=$((miss + 1))
        done
        if [ "$miss" -eq 0 ]; then
          ignored=$((ignored + 1))
          [ "$list" = yes ] && echo "ignored $f $path (any room)"
        else
          unignored=$((unignored + 1))
          [ "$list" = yes ] && echo "UNIGNORED $f $path (swept in $miss of $probe_depths rooms)"
        fi
        ;;
      *'$'*)
        unresolved=$((unresolved + 1))
        [ "$list" = yes ] && echo "unresolved $f $path"
        ;;
      *)
        in_tree=$((in_tree + 1))
        if git check-ignore -q "$path/pid" 2>/dev/null; then
          ignored=$((ignored + 1))
          [ "$list" = yes ] && echo "ignored $f $path"
        else
          unignored=$((unignored + 1))
          [ "$list" = yes ] && echo "UNIGNORED $f $path"
        fi
        ;;
    esac
  done
done

echo "locks_in_tree=$in_tree"
echo "locks_ignored=$ignored"
echo "locks_unignored=$unignored"
echo "locks_outside=$outside"
echo "locks_unresolved=$unresolved"

if [ "$unignored" -eq 0 ] && [ "$unresolved" -eq 0 ]; then
  echo "verdict=named"
  exit 0
fi
echo "verdict=swept_by_a_round_open"
exit 1
