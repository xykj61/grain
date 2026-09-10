#!/bin/sh
# Read Rishi assertions whose evidence the TEST HARNESS supplies rather than the desk under test.
#
# `tools/g/glow_run_worker.sh` runs one Glow desk and then echoes a trailer line of its own,
# `EXIT:$?`. A witness reads the desk's answer out of that same stream, so a substring assertion
# whose needle also stands inside the trailer passes however the desk answers. The commonest form
# is a gate's REFUSING side: `assert over.out contains "0"` reads true off `EXIT:0` alone, so the
# leg proving a bound still refuses is the one leg that cannot make a sound.
#
# `assert x.out contains "EXIT:0"` is the honest exit read and passes free -- it asks about the
# trailer on purpose. Every shorter substring of the trailer is counted.
#
# Sibling: `tools/fixtures/s/self_matching_assert_scan.sh` reads the other source of borrowed
# evidence, a needle the COMMAND OPERAND handed the tool. It cannot see this family: its own
# `min_needle=3` passes over the one-character needle that carries almost all of these.
#
# Usage: sh tools/fixtures/s/silent_leg_scan.sh [--list silent|lane]
# Exit 0 within both ceilings, 1 over either, 2 for misuse or an unreadable corpus.
set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done

# invariant: the lane whose hand repaired this family is held at zero, so a new one reds here.
lane_ceiling=0
# invariant: the rest of the tree ratchets down as each room's own hand reaches it.
ceiling=28
# The trailer the worker echoes after every desk run, and the whole basis of the reading.
trailer='EXIT:0'
# Bound, named because a census over a growing tree needs one. Measured `20260910`: 2,470 tracked
# `.rish` runners. The next power of two above passes ordinary growth and refuses a tenfold jump.
max_runners=8192

list=
while [ $# -gt 0 ]; do
  case "$1" in
    --list) [ $# -ge 2 ] || { echo "detail: --list wants a set name"; echo "verdict=no_set"; exit 2; }
            list=$2; shift 2 ;;
    *) echo "detail: unknown argument $1"; echo "verdict=bad_argument"; exit 2 ;;
  esac
done
case "$list" in
  ''|silent|lane) ;;
  *) echo "detail: --list takes silent or lane"; echo "verdict=bad_set"; exit 2 ;;
esac

cd "$_fd_root"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
trap 'rm -rf "$work"; exit 130' INT
trap 'rm -rf "$work"; exit 143' TERM

git ls-files -- '*.rish' > "$work/runners.txt" 2>/dev/null || {
  echo "detail: git ls-files refused -- this is not a checkout"; echo "verdict=no_checkout"; exit 2; }
runners=$(wc -l < "$work/runners.txt" | tr -d ' ')
[ "$runners" -gt 0 ] || { echo "detail: no tracked .rish runners"; echo "verdict=empty_corpus"; exit 2; }
[ "$runners" -le "$max_runners" ] || {
  echo "detail: runners $runners over max_runners $max_runners -- raise the bound deliberately"
  echo "verdict=runners_over_bound"; exit 2; }

# THE READING. One awk pass per file, in source order, because a `let` binds the worker run before
# the `assert` that reads it, and that order is the whole of the resolution rule. A binding under a
# name already bound replaces it, so a later plain `run` clears an earlier worker run.
xargs_args=$(cat "$work/runners.txt")
# shellcheck disable=SC2086
awk -v trailer="$trailer" '
  FNR == 1 { delete worker }

  # A full-line comment executes nothing.
  /^[ \t]*#/ { next }

  # Any binding at all clears the name; a worker run then re-arms it. The line form is loose on
  # purpose: `if args.len == 2 then let gate = run [...]` binds `gate` past the leading keyword.
  match($0, /let[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]*=/) {
    n = substr($0, RSTART, RLENGTH); sub(/^let[ \t]+/, "", n); sub(/[ \t]*=$/, "", n)
    delete worker[n]
    if (index($0, "glow_run_worker.sh") > 0) worker[n] = 1
    next
  }

  # assert [(]var.out contains "needle"
  match($0, /^[ \t]*assert[ \t]+\(?[A-Za-z_][A-Za-z0-9_]*\.out[ \t]+contains[ \t]+"[^"]*"/) {
    s = substr($0, RSTART, RLENGTH)
    v = s; sub(/^[ \t]*assert[ \t]+\(?/, "", v); sub(/\..*$/, "", v)
    nd = s; sub(/^.*contains[ \t]+"/, "", nd); sub(/"$/, "", nd)
    if (!(v in worker)) next
    if (nd == "") next
    if (nd == trailer) next
    if (index(trailer, nd) == 0) next
    printf "%s:%d\t%s\n", FILENAME, FNR, nd
  }
' $xargs_args > "$work/hits.txt" || {
  echo "detail: corpus reader failed"; echo "verdict=reader_failed"; exit 2; }

sort -u "$work/hits.txt" > "$work/silent.txt"
grep -E '^(mantra|tally)/|^tools/(m|t)/' "$work/silent.txt" > "$work/lane.txt" || true
silent=$(wc -l < "$work/silent.txt" | tr -d ' ')
lane=$(wc -l < "$work/lane.txt" | tr -d ' ')

if [ -n "$list" ]; then
  case "$list" in
    silent) cat "$work/silent.txt" ;;
    lane)   cat "$work/lane.txt" ;;
  esac
fi

echo "runners=$runners"
echo "trailer=$trailer"
echo "silent=$silent"
echo "ceiling=$ceiling"
echo "lane_silent=$lane"
echo "lane_ceiling=$lane_ceiling"

if [ "$lane" -gt "$lane_ceiling" ]; then
  echo "detail: $lane mantra/tally legs read their needle off the worker's own trailer, over a ceiling of $lane_ceiling"
  sed 's/^/detail: silent lane leg -- /' "$work/lane.txt"
  echo "verdict=lane_over_ceiling"
  exit 1
fi
if [ "$silent" -gt "$ceiling" ]; then
  echo "detail: $silent legs read their needle off the worker's own trailer, over a ceiling of $ceiling"
  sed 's/^/detail: silent leg -- /' "$work/silent.txt"
  echo "verdict=silent_over_ceiling"
  exit 1
fi
echo "detail: the lane stands at zero and the tree ratchet is within its ceiling"
echo "verdict=ok"
exit 0
