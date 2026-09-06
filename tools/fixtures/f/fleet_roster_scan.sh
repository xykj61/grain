#!/usr/bin/env sh
# fleet_roster_scan.sh -- read construction/fleet-roster.kyri, the fleet's one seat table.
#
# WHY A READER RATHER THAN A GREP. The binding seat -> tree -> engine stood in six places across
# two executables and two of them had already drifted (REDS %409). Seating the table once only
# helps if every instrument reads it the same way, so the parse lives here and the callers ask
# questions instead of matching lines. One parse for sh, for Rishi, and for the launcher prose.
#
# WHY sh AND awk. This fleet spans a Mac and a Linux pier, and fleet-loop.sh already carries the
# scar of that in its own epoch arithmetic -- `date -v` is BSD-only, `date -d` GNU-only. POSIX awk
# is the one text tool that reads the same on both.
#
#   sh tools/fixtures/f/fleet_roster_scan.sh                 # one line per seat: name tree engine status
#   sh tools/fixtures/f/fleet_roster_scan.sh --seats         # every seat name, live and parked
#   sh tools/fixtures/f/fleet_roster_scan.sh --live          # the seats sailing today
#   sh tools/fixtures/f/fleet_roster_scan.sh --tree SEAT     # that seat's tree basename
#   sh tools/fixtures/f/fleet_roster_scan.sh --engine SEAT   # claude | codex | field
#   sh tools/fixtures/f/fleet_roster_scan.sh --lane SEAT     # the lane sentence
#   sh tools/fixtures/f/fleet_roster_scan.sh --status SEAT   # live | parked
#   sh tools/fixtures/f/fleet_roster_scan.sh --resolve NAME  # an elder name -> its seat; else itself
#   sh tools/fixtures/f/fleet_roster_scan.sh --recipe [SEAT]  # the loop lines, per seat
#
# A QUESTION ABOUT A SEAT THE TABLE DOES NOT HOLD EXITS 2 AND PRINTS NOTHING, so a caller that
# forgets to check cannot mistake an empty answer for a real one -- which is the same reason the
# standing roster refuses a tier word it does not know rather than running past it.
set -eu

# the first ancestor holding construction/ -- git-free so a pen copy outside a repository still
# resolves -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -f "$ROOT/construction/fleet-roster.kyri" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs construction/fleet-roster.kyri)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
roster="${FLEET_ROSTER:-$ROOT/construction/fleet-roster.kyri}"
[ -f "$roster" ] || { echo "$0: no fleet roster at $roster" >&2; exit 2; }

# One awk pass, one record shape. A field's value is everything after the first space, so a lane
# sentence keeps its commas and its parentheses without quoting -- Kyri notation's own rule.
read_field() {
  awk -v want="$1" -v field="$2" '
    # The record is cleared BEFORE exit, because awk-s own exit jumps to END and END flushes again --
    # a match printed twice on the first draft, which is exactly the shape a caller reading one
    # line would never notice and a caller reading all of them would trip over.
    function flush() {
      if (seat != "" && seat == want) { print value; found = 1; seat = ""; exit }
      seat = ""; value = ""
    }
    $1 == "seat" { flush(); seat = $2; next }
    $1 == field  { if (seat != "") { $1 = ""; sub(/^ /, ""); value = $0 } next }
    END { flush(); if (!found) exit 3 }
  ' "$roster"
}

case "${1:-}" in
  "")
    awk '
      function flush() {
        if (seat != "") printf "%s %s %s %s\n", seat, tree, engine, status
        seat = ""; tree = "-"; engine = "-"; status = "-"
      }
      BEGIN { tree = "-"; engine = "-"; status = "-" }
      $1 == "seat"   { flush(); seat = $2; next }
      $1 == "tree"   { if (seat != "") tree = $2; next }
      $1 == "engine" { if (seat != "") engine = $2; next }
      $1 == "status" { if (seat != "") status = $2; next }
      END { flush() }
    ' "$roster"
    ;;
  --seats) awk '$1 == "seat" { print $2 }' "$roster" ;;
  --live)
    awk '
      function flush() { if (seat != "" && status == "live") print seat; seat = ""; status = "" }
      $1 == "seat"   { flush(); seat = $2; next }
      $1 == "status" { if (seat != "") status = $2; next }
      END { flush() }
    ' "$roster"
    ;;
  --resolve)
    # An elder name answers with its living seat; anything else answers with itself, so a caller
    # can pipe every seat word through this without asking first whether it needed translating.
    [ $# -ge 2 ] || { echo "$0: --resolve wants a name" >&2; exit 2; }
    awk -v n="$2" '
      function flush() { if (seat != "" && elder == n) { print seat; found = 1; seat = ""; exit }
                         seat = ""; elder = "" }
      $1 == "seat"  { flush(); seat = $2; next }
      $1 == "elder" { if (seat != "") elder = $2; next }
      END { flush(); if (!found) print n }
    ' "$roster"
    ;;
  --recipe)
    # THE PER-SEAT RECIPE LIVES HERE rather than in the launcher that prints it, because Rishi's
    # for-each takes one statement over a list literal and has no string split -- so a launcher
    # looping over seats would have to spell the seat list again, which is the seventh copy this
    # whole table exists to prevent. The launcher asserts and says; the text work is awk's.
    # No seat named prints every LIVE seat, so the page stays useful as the fleet's whole card.
    #
    # This branch is the one that calls ITSELF, so the roster pin has to be exported or a pen
    # asking for a recipe against its own table would silently get the tree's instead -- the
    # quietest kind of wrong answer, since it looks exactly like a right one.
    export FLEET_ROSTER="$roster"
    want=${2:-}
    if [ -n "$want" ]; then
      sh "$0" --status "$want" >/dev/null 2>&1 || { echo "$0: no seat named $want" >&2; exit 2; }
      seats=$want
    else
      seats=$(sh "$0" --live)
    fi
    for _s in $seats; do
      _tree=$(sh "$0" --tree "$_s")
      _status=$(sh "$0" --status "$_s")
      _lane=$(sh "$0" --lane "$_s")
      printf -- '-- %s (%s) -- %s\n' "$_s" "$_status" "$_lane"
      printf 'cd ~/%s && FLEET_DRY=1 sh tools/f/fleet-loop.sh %s   # print the command, run nothing\n' "$_tree" "$_s"
      printf 'cd ~/%s && LOOP_LAPS=1 sh tools/f/fleet-loop.sh %s   # one lap\n' "$_tree" "$_s"
      printf 'cd ~/%s && sh tools/f/fleet-loop.sh %s               # the loop; LOOP_HOURS bounds it\n' "$_tree" "$_s"
      printf '\n'
    done
    ;;
  --tree | --engine | --lane | --status)
    [ $# -ge 2 ] || { echo "$0: ${1} wants a seat name" >&2; exit 2; }
    field=${1#--}
    read_field "$2" "$field" || { echo "$0: no seat named $2 in $roster" >&2; exit 2; }
    ;;
  *) echo "$0: unknown argument: $1" >&2; exit 2 ;;
esac
