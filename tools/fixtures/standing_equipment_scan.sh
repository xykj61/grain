#!/bin/sh
# tools/fixtures/standing_equipment_scan.sh -- the roster is real, and it says when each guard ran.
#
# WHY. The standing-equipment roster lived in one paragraph of crux/REMEMBER.md. A paragraph
# can be trusted; it cannot be run, counted, or dated. REDS %147 found eight standing witnesses
# each holding a count its source had moved past, and REDS %149 found the living-pin bound guard
# unrun for four laps while the pin it measures sat 2,050 bytes over its bound. Both were found
# by a hand that happened to run something, which is a lantern rather than a loom.
#
# WHAT IS GATED, hard.
#   Every `path` in crux/standing-equipment.kyri names a file that exists on disk.
#   Every `guard` record carries exactly one `path`, so no row is half-written.
#   Every `ran` line in the run card names a guard the roster actually seats.
#   No run-card line records a red or an absent guard.
#
# WHAT IS REPORTED, as a ratchet rather than a gate. How many rostered guards have never run
# on this pier, and how many hours since the oldest recorded run. A fresh clone has genuinely
# run nothing, so `never run here` is an honest reading rather than a defect, and gating it
# would red every clone on the day it lands. The number is printed so a lap can see the drift
# it could not see when the roster was prose.
#
# USAGE
#   sh tools/fixtures/standing_equipment_scan.sh
#
# Driven by tools/standing_equipment_witness.rish. Run from the repository root.

set -eu

roster="${STANDING_ROSTER:-crux/standing-equipment.kyri}"
card="${STANDING_CARD:-crux/standing-equipment-runs.kyri}"

[ -f "$roster" ] || { echo "verdict=no_roster"; echo "refused: no roster at $roster" >&2; exit 1; }

names=$(mktemp); paths_missing=$(mktemp); halfrows=$(mktemp)
unrostered=$(mktemp); reds=$(mktemp); ranlist=$(mktemp)
trap 'rm -f "$names" "$paths_missing" "$halfrows" "$unrostered" "$reds" "$ranlist"' EXIT

rostered=0
missing=0
half=0

name=""
while IFS= read -r line; do
  case "$line" in
    guard\ *)
      # A guard record still open when the next one opens never got its path.
      if [ -n "$name" ]; then half=$((half + 1)); echo "$name" >> "$halfrows"; fi
      name=$(printf '%s' "$line" | awk '{print $2}')
      rostered=$((rostered + 1))
      echo "$name" >> "$names"
      ;;
    path\ *)
      path=$(printf '%s' "$line" | awk '{print $2}')
      [ -n "$name" ] || continue
      if [ ! -f "$path" ]; then
        missing=$((missing + 1))
        echo "$name -> $path" >> "$paths_missing"
      fi
      name=""
      ;;
    *) ;;
  esac
done < "$roster"
if [ -n "$name" ]; then half=$((half + 1)); echo "$name" >> "$halfrows"; fi

recorded=0
stray=0
red=0
newest=""
oldest=""

if [ -f "$card" ]; then
  while IFS= read -r line; do
    case "$line" in
      ran\ *)
        rname=$(printf '%s' "$line" | awk '{print $2}')
        rstamp=$(printf '%s' "$line" | awk '{print $3}')
        rverdict=$(printf '%s' "$line" | awk '{print $4}')
        recorded=$((recorded + 1))
        echo "$rname" >> "$ranlist"
        if ! grep -qx "$rname" "$names"; then
          stray=$((stray + 1))
          echo "$rname" >> "$unrostered"
        fi
        if [ "$rverdict" != "green" ]; then
          red=$((red + 1))
          echo "$rname $rverdict" >> "$reds"
        fi
        if [ -z "$newest" ] || [ "$rstamp" \> "$newest" ]; then newest="$rstamp"; fi
        if [ -z "$oldest" ] || [ "$rstamp" \< "$oldest" ]; then oldest="$rstamp"; fi
        ;;
      *) ;;
    esac
  done < "$card"
fi

never=0
while IFS= read -r n; do
  if [ ! -f "$ranlist" ] || ! grep -qx "$n" "$ranlist" 2>/dev/null; then never=$((never + 1)); fi
done < "$names"

echo "guards_rostered=$rostered"
echo "guards_path_missing=$missing"
echo "guards_half_written=$half"
echo "runs_recorded=$recorded"
echo "runs_unrostered=$stray"
echo "runs_red=$red"
echo "guards_never_run_here=$never"
echo "oldest_run=${oldest:-none}"
echo "newest_run=${newest:-none}"

[ "$missing" -eq 0 ] || sed 's/^/missing: /' "$paths_missing"
[ "$half" -eq 0 ] || sed 's/^/half_written: /' "$halfrows"
[ "$stray" -eq 0 ] || sed 's/^/unrostered: /' "$unrostered"
[ "$red" -eq 0 ] || sed 's/^/red: /' "$reds"

if [ "$missing" -eq 0 ] && [ "$half" -eq 0 ] && [ "$stray" -eq 0 ] && [ "$red" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=roster_broken"
echo "refused: the standing roster names something the tree cannot honor -- read the lines above" >&2
exit 1
