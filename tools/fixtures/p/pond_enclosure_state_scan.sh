#!/usr/bin/env sh
# pond_enclosure_state_scan.sh -- the enclosure's state room, read from both sides of its seam.
#
# WHAT THIS READS. tools/ag/agent-jail.sh is the ANSWERER: it seats the loop-state room
# (`loops/<body>/`), moves each elder directory into it once with adopt_state_dir, and binds the
# result over the agent's HOME. tools/e/enclosure.conf.example is the ASKER: a per-host file every
# pier copies, sourced by the script BEFORE its own defaults, so any path the example names wins
# over the room the script seated. Two files, one contract, and until 20260828 nothing compared
# them.
#
# WHY IT IS ONE GATE. The example pinning an elder path is the whole fault: adopt_state_dir moves
# the elder into the room, the pinned variable still names the elder, `mkdir -p` recreates it
# empty, and the jail binds an empty directory over a HOME whose login the script's own comment
# promises is done once per pier. Measured on this pier 20260828: loops/claude held 22 entries
# including .credentials.json while .claude-state held 0.
#
# THE READINGS
#   pinned_elders        the tracked example naming a path adopt_state_dir moves   ZERO, ENFORCED
#   agreeing_pins        the example naming the seated room                        reported
#   absent_pins          the example leaving the default to win                    reported
#   host_pinned_elders   this host's own gitignored conf, same reading             reported, never gated
#   stranded_rooms       an elder holding fewer files than the room beside it     reported, never gated
#
# The last two are reported rather than gated because tools/e/enclosure.conf is gitignored and a
# host's own file is not the tree's to fail on -- a guard that reds on somebody else's machine is
# a guard someone turns off.
#
#   sh tools/fixtures/p/pond_enclosure_state_scan.sh [--root DIR]
#
# ACCRETE-ONLY. This reads the ai-jail launcher and its shipped example. It rewrites neither, and
# it flips nothing: the ENCLOSURE selector stays ai-jail until the switchover round lands behind
# its audit.
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
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT=$2; shift 2 ;;
    *) echo "pond_enclosure_state_scan: unknown argument: $1" >&2; exit 2 ;;
  esac
done

JAIL="$ROOT/tools/ag/agent-jail.sh"
EXAMPLE="$ROOT/tools/e/enclosure.conf.example"
HOSTCONF="$ROOT/tools/e/enclosure.conf"

# invariant: both halves of the seam must exist before a comparison means anything.
if [ ! -f "$JAIL" ]; then echo "scan=absent detail=no_launcher"; exit 1; fi
if [ ! -f "$EXAMPLE" ]; then echo "scan=absent detail=no_example"; exit 1; fi

# max_pairs bounds the adopt roster. Three stand today; sixteen leaves room for a body per seat
# on the six-body constellation and still refuses a runaway generated file.
max_pairs=16

# max_room_files bounds the disk reading. `loops/claude` held 5,229 files on this pier on
# 20260828, mostly caches, and a state room is free to grow; counting every file each roster run
# would put an unbounded walk inside a guard that runs twice a lap. Twenty thousand is far above
# any state room measured here and cheap to reach; a count that lands on the cap prints `>=`, so
# the reading stays honest rather than merely small.
max_room_files=20000

# count_files <dir> -- regular files at any depth, capped, printed with a >= when the cap is hit.
count_files() {
  _n=$(find "$1" -type f 2>/dev/null | head -n "$max_room_files" | wc -l | tr -d ' ')
  echo "$_n"
}
say_count() {
  if [ "$1" -ge "$max_room_files" ]; then echo ">=$1"; else echo "$1"; fi
}

# The answerer's own two tables, read out of the script rather than restated here.
#   pairs:  <elder-relative-path> <room-name>     from adopt_state_dir
#   vars:   <VAR_NAME> <room-name>                from VAR="${VAR:-$LOOPS/room}"
pairs=$(awk '
  /^[ \t]*adopt_state_dir[ \t]+"/ {
    n = split($0, q, "\"")
    elder = q[2]; room = q[4]
    sub(/^\$REPO\//, "", elder)
    sub(/^\$LOOPS\//, "", room)
    print elder, room
  }
' "$JAIL")

vars=$(awk '
  match($0, /^[A-Z_]+="\$\{[A-Z_]+:-\$LOOPS\/[A-Za-z0-9_-]+\}"$/) {
    eq = index($0, "=")
    name = substr($0, 1, eq - 1)
    room = $0
    sub(/^.*\$LOOPS\//, "", room)
    sub(/\}"$/, "", room)
    print name, room
  }
' "$JAIL")

pair_count=$(printf '%s' "$pairs" | grep -c . || true)
var_count=$(printf '%s' "$vars" | grep -c . || true)

echo "pond_enclosure_state_scan v1"
echo "answerer=tools/ag/agent-jail.sh"
echo "asker=tools/e/enclosure.conf.example"
echo "adopt_pairs=$pair_count"
echo "room_vars=$var_count"

if [ "$pair_count" -gt "$max_pairs" ]; then
  echo "detail: adopt roster $pair_count exceeds max_pairs $max_pairs"
  echo "verdict=unbounded"
  exit 1
fi

# read_pin <conf> <VAR> -- the value the conf assigns, or empty when it assigns none.
read_pin() {
  _conf=$1
  _var=$2
  [ -f "$_conf" ] || return 0
  sed -n "s/^${_var}=\"\{0,1\}\([^\"]*\)\"\{0,1\}[ \t]*\(#.*\)\{0,1\}$/\1/p" "$_conf" | tail -1
}

# elder_for_room <room> -- the elder path adopt_state_dir moves into that room.
elder_for_room() {
  printf '%s\n' "$pairs" | while read -r _elder _room; do
    [ "$_room" = "$1" ] && { printf '%s' "$_elder"; return 0; }
  done
}

pinned_elders=0
agreeing_pins=0
absent_pins=0
host_pinned_elders=0
stranded_rooms=0

# One pass per variable. A `while read` in a pipeline runs in a subshell, so the counters are
# accumulated in a file rather than in shell variables -- the portable answer, and the reason is
# that POSIX sh gives no lastpipe.
tally=$(mktemp)
trap 'rm -f "$tally"' EXIT INT TERM
: >"$tally"

printf '%s\n' "$vars" | while read -r var room; do
  [ -n "${var:-}" ] || continue
  elder=$(elder_for_room "$room")
  pin=$(read_pin "$EXAMPLE" "$var")
  if [ -z "$pin" ]; then
    echo "absent_pins" >>"$tally"
    echo "detail: $var unset in the example -- the seated room loops/$room wins"
  elif [ -n "$elder" ] && [ "${pin#*"$elder"}" != "$pin" ]; then
    echo "pinned_elders" >>"$tally"
    echo "detail: $var pinned to $pin, which adopt_state_dir moves to loops/$room -- the bind lands on an empty directory"
  elif [ "${pin#*"loops/$room"}" != "$pin" ]; then
    echo "agreeing_pins" >>"$tally"
    echo "detail: $var pinned to $pin, which names the seated room"
  else
    echo "agreeing_pins" >>"$tally"
    echo "detail: $var pinned to $pin -- neither the elder nor the room, so it is a deliberate host path"
  fi

  hostpin=$(read_pin "$HOSTCONF" "$var")
  if [ -n "$hostpin" ] && [ -n "$elder" ] && [ "${hostpin#*"$elder"}" != "$hostpin" ]; then
    echo "host_pinned_elders" >>"$tally"
    echo "detail: this host's tools/e/enclosure.conf pins $var to $hostpin"
  fi
done

# The disk reading, on whatever machine runs the scan.
printf '%s\n' "$pairs" | while read -r elder room; do
  [ -n "${elder:-}" ] || continue
  eldir="$ROOT/$elder"
  roomdir="$ROOT/loops/$room"
  [ -d "$roomdir" ] || continue
  # invariant: the room must hold a real file before an elder beside it can read as stranded.
  room_files=$(count_files "$roomdir")
  [ "$room_files" -gt 0 ] || continue
  [ -d "$eldir" ] || continue
  # Files at any depth, rather than top-level entries: `mkdir -p` recreates the parent AND its
  # xdg-config child, so an entry count reads one directory as occupied when it holds nothing.
  # The comparison is strictly-fewer rather than zero, because the launcher reseeds a couple of
  # files into the pinned path on its own -- a partial reseed strands the rest just as surely, and
  # the two counts in the detail line say which case a reader is looking at.
  elder_files=$(count_files "$eldir")
  if [ "$elder_files" -lt "$room_files" ]; then
    echo "stranded_rooms" >>"$tally"
    echo "detail: $elder holds $(say_count "$elder_files") files while loops/$room holds $(say_count "$room_files")"
  fi
done

count_of() { grep -c "^$1\$" "$tally" 2>/dev/null || true; }
pinned_elders=$(count_of pinned_elders)
agreeing_pins=$(count_of agreeing_pins)
absent_pins=$(count_of absent_pins)
host_pinned_elders=$(count_of host_pinned_elders)
stranded_rooms=$(count_of stranded_rooms)

echo "pinned_elders=$pinned_elders"
echo "agreeing_pins=$agreeing_pins"
echo "absent_pins=$absent_pins"
echo "host_conf=$([ -f "$HOSTCONF" ] && echo present || echo absent)"
echo "host_pinned_elders=$host_pinned_elders"
echo "stranded_rooms=$stranded_rooms"

if [ "$pinned_elders" -ne 0 ]; then
  echo "verdict=pinned_elder"
  exit 1
fi
echo "verdict=green"
