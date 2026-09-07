#!/bin/sh
# tools/fixtures/s/scope_trace_control.sh -- the trace-and-compare, proven on a pen tree whose read
# set is known before the tracer runs.
#
# WHY A CONTROL. This scan's whole value is that it can say "your row misses this file", and a
# reading like that has one dangerous failure mode: going quietly to zero. A scan whose path
# extraction stops matching prints `read_files=0 gaps=0 verdict=ok`, which is byte for byte what a
# perfectly-mapped guard prints. So the load-bearing leg here is a BLINDED COPY -- the real scan
# with its resolution step removed -- shown reading zero on the same pen where the real scan reads
# one. Every refusal is planted and then LIFTED, since a refusal proven only in the failing
# direction cannot be told from a scan stuck shut.
#
# THE PEN IS A MINI TREE rather than a copy of this repository, because the scan resolves its root
# by upward walk and filters observed paths to that root. A pen holding `rishi/bin`, the real
# `scope_match.sh`, and the real `scope_trace.sh` gives the scan the same root discipline it has at
# home while keeping the guard's read set small enough to state in full. The MATCHER is the real
# file on purpose: it is the piece three programs share, and a copy here would let this control
# bless a matcher the runner never uses.
#
# EXPECTED: every behavior satisfied, faults=0, exit 0.
#
# Driven by tools/s/scope_trace_witness.rish. Run from anywhere.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/p/plant.sh"

behaviors=0
faults=0
note() {
  _label=$1; _got=$2; _want=$3
  behaviors=$((behaviors + 1))
  if [ "$_got" = "$_want" ]; then echo "OK   $_label ($_got)"
  else echo "FAULT $_label -- got '$_got', owed '$_want'"; faults=$((faults + 1)); fi
}

if ! command -v strace >/dev/null 2>&1; then
  # A control that cannot run its instrument says so and refuses, rather than printing faults=0
  # over legs that never ran. The witness reads this word and reports a named skip.
  echo "control_verdict=no_instrument"
  echo "behaviors=0"
  echo "faults=0"
  exit 0
fi

PEN=$(mktemp -d "${TMPDIR:-/tmp}/scope_trace_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

mkdir -p "$PEN/rishi/bin" "$PEN/tools/fixtures/s" "$PEN/watched" "$PEN/unwatched" "$PEN/room"
cp "$_fd_root/tools/fixtures/s/scope_match.sh" "$PEN/tools/fixtures/s/scope_match.sh"
cp "$_fd_root/tools/fixtures/s/scope_trace.sh" "$PEN/tools/fixtures/s/scope_trace.sh"
printf 'watched\n'   > "$PEN/watched/a.txt"
printf 'unwatched\n' > "$PEN/unwatched/b.txt"
printf 'in a room\n' > "$PEN/room/c.txt"

# THE GUARD WHOSE READ SET IS KNOWN. It reads one watched file, one unwatched file, LISTS a
# directory (which opens it), and opens a path that is not there. Four kinds in one guard, so each
# reading below is about a behavior rather than about a guard.
cat > "$PEN/tools/fixtures/s/pen_guard.sh" <<'GUARD'
#!/bin/sh
cat watched/a.txt > /dev/null
cat unwatched/b.txt > /dev/null
ls room > /dev/null
cat unwatched/absent.txt > /dev/null 2>&1 || true
exit 0
GUARD

cat > "$PEN/roster.kyri" <<'ROSTER'
guard pen_guard
path tools/fixtures/s/pen_guard.sh
seated 20260907.081500

guard unmapped_guard
path tools/fixtures/s/pen_guard.sh
seated 20260907.081500
ROSTER

write_map() { # write_map <watchwords for pen_guard>
  cat > "$PEN/map.sh" <<MAP
#!/bin/sh
cat <<'ROWS'
pen_guard $1
ROWS
MAP
}

run_trace() { # run_trace <guard> [extra args...] ; echoes stdout, exit code in $trace_exit
  _g=$1; shift
  STANDING_ROSTER="$PEN/roster.kyri" STANDING_SCOPE_MAP="$PEN/map.sh" \
    sh "$PEN/tools/fixtures/s/scope_trace.sh" "$_g" "$@" 2>/dev/null
}
field() { # field <key> <output>
  printf '%s\n' "$2" | sed -n "s/^$1=//p" | head -1
}
exit_of() {
  _g=$1; shift
  STANDING_ROSTER="$PEN/roster.kyri" STANDING_SCOPE_MAP="$PEN/map.sh" \
    sh "$PEN/tools/fixtures/s/scope_trace.sh" "$_g" "$@" >/dev/null 2>&1
  echo $?
}

echo "== 1. the read set is observed, and its four kinds are told apart =="
write_map 'tools/fixtures/s/pen_guard.sh watched/'
out=$(run_trace pen_guard --paths)
note "the watched file and the guard's own source are covered" "$(field covered "$out")" "2"
note "an unwatched file is a gap"       "$(field gaps "$out")"        "1"
note "the gap is named, not just counted" \
  "$(printf '%s\n' "$out" | sed -n 's/^gap //p')" "unwatched/b.txt"
# THREE, because a guard reads its own source -- which is why every row in the real map
# names its guard's path as its first watch word.
note "three files read"                 "$(field read_files "$out")"  "3"
# A changed path in a git diff is always a file, so a bare directory can never be the thing a row
# must reach. Counting one as a gap would invent work no edit can ever cause.
note "a listed room is a dir, never a gap" \
  "$(printf '%s\n' "$out" | sed -n 's/^dir //p' | grep -c '^room$')" "1"
note "an in-tree failed open is counted apart" "$(field read_enoent "$out")" "1"
note "and the absent path is named"     \
  "$(printf '%s\n' "$out" | sed -n 's/^enoent //p')" "unwatched/absent.txt"
note "an under-named row says so"       "$(field verdict "$out")"     "under_named"

echo "== 2. the gap is LIFTED by a union, so no bypass exists =="
write_map 'tools/fixtures/s/pen_guard.sh watched/ unwatched/'
out=$(run_trace pen_guard)
note "unioning the word closes the gap" "$(field gaps "$out")"    "0"
note "and every file is covered"        "$(field covered "$out")" "3"
note "and the verdict returns to ok"    "$(field verdict "$out")" "ok"

echo "== 3. a row is never asked to reach an absence or a room =="
# The union above names neither `room/` nor the ENOENT path, and the reading is still ok. This is
# the same fact as leg 1's dir and enoent lines, asserted from the side that matters: a hand
# unioning every gap must reach zero WITHOUT inventing a watch word for either.
note "ok without a word for the room"   "$(field verdict "$out")" "ok"
note "the room is still observed"       "$(field read_dirs "$out")" "1"

echo "== 4. an unmapped guard is named as unmapped, never as clean =="
out=$(run_trace unmapped_guard)
note "no row reads unmapped"            "$(field mapped "$out")"  "no"
note "and gaps stay zero rather than false" "$(field gaps "$out")" "0"
note "and the verdict says which"       "$(field verdict "$out")" "unmapped"

echo "== 5. refusals, each planted and then lifted =="
note "an unseated guard refuses"        "$(exit_of no_such_guard)" "1"
note "a seated guard does not"          "$(exit_of pen_guard)"     "0"
note "a second guard name refuses"      "$(exit_of pen_guard unmapped_guard)" "2"
note "an unknown flag refuses"          "$(exit_of pen_guard --nope)"         "2"
note "a timeout that is not a number refuses" "$(exit_of pen_guard --timeout x)" "2"
note "a timeout past the bound refuses" "$(exit_of pen_guard --timeout 3601)"    "2"
note "a timeout at the bound is taken"  "$(exit_of pen_guard --timeout 3600)"    "0"
note "a timeout of zero refuses"        "$(exit_of pen_guard --timeout 0)"       "2"

echo "== 6. a guard the roster points nowhere refuses rather than tracing nothing =="
cat >> "$PEN/roster.kyri" <<'ROSTER'

guard gone_guard
path tools/fixtures/s/absent_guard.sh
seated 20260907.081500
ROSTER
note "an absent guard file refuses"     "$(exit_of gone_guard)" "1"

echo "== 7. THE LOAD-BEARING LEG: a blinded copy reads zero where the real scan reads one =="
# The scan's one irreplaceable step is reading the resolved path out of strace's fd annotation.
# Remove it and every reading goes quietly to zero -- which prints exactly like a perfectly mapped
# guard. plant_write proves the removal landed, so this leg can never be a plant that planted
# nothing (REDS %519).
BLIND="$PEN/tools/fixtures/s/blind_trace.sh"
write_map 'tools/fixtures/s/pen_guard.sh watched/'
if plant_write "$PEN/tools/fixtures/s/scope_trace.sh" "$BLIND" \
     's|^sed -n .s/\.\*= \[0-9\].*|sed -n "s/NEVERMATCHES/&/p" "$pen/trace" \\|' blind_copy 2>/dev/null; then
  echo "OK   blind copy planted"
  behaviors=$((behaviors + 1))
  blind=$(STANDING_ROSTER="$PEN/roster.kyri" STANDING_SCOPE_MAP="$PEN/map.sh" \
    sh "$BLIND" pen_guard 2>/dev/null)
  real=$(run_trace pen_guard)
  note "the blind copy reads no files"  "$(field read_files "$blind")" "0"
  note "the blind copy reads no gaps"   "$(field gaps "$blind")"       "0"
  note "and calls an under-named row ok" "$(field verdict "$blind")"   "ok"
  note "while the real scan reads its files" "$(field read_files "$real")" "3"
  note "and the real scan still reds"    "$(field verdict "$real")"    "under_named"
else
  echo "FAULT blind copy matched nothing -- the resolution line moved, so this leg tests nothing"
  behaviors=$((behaviors + 1))
  faults=$((faults + 1))
fi

echo "behaviors=$behaviors"
echo "faults=$faults"
if [ "$faults" -ne 0 ]; then echo "control_verdict=control_failed"; exit 1; fi
echo "control_verdict=ok"
