#!/bin/sh
# tools/fixtures/f/fleet_claim_scan.sh -- is a peer already building this?
#
#   sh tools/fixtures/f/fleet_claim_scan.sh                      # the live board
#   sh tools/fixtures/f/fleet_claim_scan.sh --check <path> ...   # the board, plus an overlap reading
#   sh tools/fixtures/f/fleet_claim_scan.sh --seat               # this tree's seat name
#
# WHY THIS EXISTS. Absence is checkable and intent is not. `path_absence_scan.sh` (REDS %457)
# answers whether a path stands here and upstream -- and it answers about the remote AS IT STOOD
# WHEN ASKED. A ship that reads `absent`, builds for two hours and returns finds a peer's strictly
# wider instrument already landed, with every word of its own reading still true.
#
# THAT FIRED TWICE IN ONE DAY, ON TWO SHIPS. On `20260911` incense built `port_registry` -- 35
# constants, 21 files, 44 pen legs, GREEN on metal -- and withdrew it whole, because `%715` had
# landed `port_band` two hours earlier. Bakery built a port census with a 29-leg pen the same day,
# rebased it into `port_band_scan.sh`, and wrote the sentence this reader answers: *Nothing said
# the work was in flight.*
#
# IT FETCHES, AND IT READS THE REMOTE'S COPY RATHER THAN THIS TREE'S. A claim board read from local
# bytes is the %457 fault one layer down -- the local copy is stale by exactly the minutes that
# matter. `board=local` appears only when the remote cannot be reached, and it says so.
#
# TWO READINGS, AND THE SHARPER ONE IS NOT THE AUTOMATED ONE. **Path overlap** is exact: a claimed
# path and a queried path collide when they are equal or one contains the other, compared at a
# directory boundary, so a claim naming a directory stays clear of a sibling file whose name
# merely begins with the same characters. **The `what`
# sentence is the reading that would have caught this file's own founding case** -- `port_registry`
# and `port_band` share no path at all, and a person reading two plain sentences catches them in
# seconds. So a `--check` prints the whole live board beside its overlap count, and the hand reads
# it. Naming that limit is the point: the exact half is narrow, and the board is what makes it work.
#
# IT REPORTS AND NEVER GATES. Two ships may deliberately build one thing, and a reading that
# refused would be a reading somebody turns off. A nonzero exit means *there is something here to
# read*, exactly as the absence scan's does.
#
# AGE COMES FROM `epoch`, NEVER FROM `stamp`. The stamp is the one-clock human record and this
# fleet's clocks are named per host -- Eastern on the pier, Pacific on the macOS clone -- so stamp
# arithmetic would read three hours wrong for a claim written on the other door. The writer records
# UTC seconds beside the stamp, and the two fields answer two questions rather than one field
# answering both badly.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
REMOTE=${ANOINTED_REMOTE:-xy}
BOARD=${FLEET_CLAIM_BOARD:-construction/fleet-claims.kyri}
STALE_HOURS=${FLEET_CLAIM_STALE_HOURS:-6}
MAX_LIVE=${FLEET_CLAIM_MAX:-64}

# This tree's own seat, asked of the roster rather than spelled here -- a second seat table is the
# fault `fleet-roster.kyri` was seated to end (REDS %409).
seat_here() {
  base=$(basename "$ROOT")
  sh tools/fixtures/f/fleet_roster_scan.sh 2>/dev/null \
    | awk -v b="$base" '$2 == b { print $1; found = 1; exit } END { if (!found) print "unknown" }'
}

case "${1:-}" in
  --seat) seat_here; exit 0 ;;
esac

mode=board
if [ "${1:-}" = "--check" ]; then
  mode=check
  shift
  [ $# -ge 1 ] || { echo "detail: --check wants at least one path"; echo "verdict=no_path"; exit 2; }
  # The queries reach awk as one space-joined string, so a path carrying a space would split into
  # two and read as a collision with neither. Refused rather than answered wrongly -- a false
  # `clear` is the one answer this reader must never give.
  for q in "$@"; do
    case "$q" in
      *" "*) echo "detail: a queried path carries a space: $q"; echo "verdict=bad_path"; exit 2 ;;
    esac
  done
fi

if git fetch -q "$REMOTE" 2>/dev/null; then
  echo "fetched=$REMOTE"
else
  echo "fetched=no"
  echo "detail: could not reach $REMOTE -- the board below may be stale, which is the one fault this reader exists to prevent"
fi
echo "commits_behind=$(git rev-list --count "HEAD..$REMOTE/main" 2>/dev/null || echo unknown)"

# The remote's copy is the board. Falling back to local is named out loud, never assumed.
board_text=$(git show "$REMOTE/main:$BOARD" 2>/dev/null || true)
if [ -n "$board_text" ]; then
  echo "board=upstream"
elif [ -f "$BOARD" ]; then
  echo "board=local"
  echo "detail: $BOARD is absent upstream -- reading this tree's copy, which no peer can have read"
  board_text=$(cat "$BOARD")
else
  echo "board=absent"
  echo "claims_live=0"
  echo "verdict=clear"
  exit 0
fi

now=$(date -u +%s)
me=$(seat_here)

printf '%s\n' "$board_text" | awk \
  -v now="$now" -v stale_hours="$STALE_HOURS" -v me="$me" -v mode="$mode" \
  -v maxlive="$MAX_LIVE" -v queries="$*" '
function flush(   age, status, hit, i, j, qn, qs) {
  if (name == "") { reset(); return }
  live++
  age = (epoch == "" ? -1 : int((now - epoch) / 3600))
  status = (age < 0 ? "undated" : (age >= stale_hours ? "stale" : "building"))
  hit = 0
  if (mode == "check") {
    qn = split(queries, qs, " ")
    for (i = 1; i <= np; i++)
      for (j = 1; j <= qn; j++)
        if (overlaps(paths[i], qs[j])) { hit = 1; hits[++nh] = paths[i] " <-> " qs[j] }
  }
  printf "claim %s seat=%s stamp=%s age_hours=%s status=%s%s\n",
    name, (seat == "" ? "-" : seat), (stamp == "" ? "-" : stamp),
    (age < 0 ? "-" : age), status, (seat == me ? " mine" : "")
  printf "  what %s\n", (what == "" ? "-" : what)
  if (hit) {
    for (i = 1; i <= nh; i++) printf "  overlap %s\n", hits[i]
    if (seat == me) mine_overlap++
    else if (status == "stale") stale_overlap++
    else peer_overlap++
  }
  nh = 0
  reset()
}
function reset() { name = ""; seat = ""; stamp = ""; epoch = ""; what = ""; np = 0 }
function overlaps(a, b) {
  if (a == b) return 1
  if (substr(b, 1, length(a) + 1) == a "/") return 1
  if (substr(a, 1, length(b) + 1) == b "/") return 1
  return 0
}
function rest(   v) { v = $0; sub(/^[^ ]+ +/, "", v); return v }
BEGIN { reset() }
/^[ \t]*#/ { next }
$1 == "claim" { flush(); name = $2; next }
$1 == "seat"  { if (name != "") seat  = $2;     next }
$1 == "stamp" { if (name != "") stamp = $2;     next }
$1 == "epoch" { if (name != "") epoch = $2 + 0; next }
$1 == "what"  { if (name != "") what  = rest(); next }
$1 == "paths" { if (name != "") np = split(rest(), paths, " "); next }
END {
  flush()
  print "claims_live=" live + 0
  if (live > maxlive) print "detail: the board holds more live claims than " maxlive " -- a board nobody clears is a board nobody reads"
  if (mode == "check") {
    print "overlap_peer=" peer_overlap + 0
    print "overlap_stale=" stale_overlap + 0
    print "overlap_mine=" mine_overlap + 0
    if (peer_overlap > 0) { print "verdict=claimed"; exit 1 }
    if (stale_overlap > 0) { print "verdict=stale_claim"; exit 1 }
    print "verdict=clear"
  } else {
    print "verdict=board"
  }
}
'
