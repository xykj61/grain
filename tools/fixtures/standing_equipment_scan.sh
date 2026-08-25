#!/bin/sh
# tools/fixtures/standing_equipment_scan.sh -- the roster is real, it names a tier, and it says when each guard ran.
#
# WHY. The standing-equipment roster lived in one paragraph of construction/ITINERARY.md. A paragraph
# can be trusted; it cannot be run, counted, or dated. REDS %147 found eight standing witnesses
# each holding a count its source had moved past, and REDS %149 found the living-pin bound guard
# unrun for four laps while the pin it measures sat 2,050 bytes over its bound. Both were found
# by a hand that happened to run something, which is a lantern rather than a loom.
#
# WHAT IS GATED, hard.
#   Every `path` in construction/standing-equipment.kyri names a file that exists on disk.
#   Every `guard` record carries exactly one `path` -- a row with none, or with two, is refused
#     rather than half-read by a runner that would take only the first.
#   Every `tier` names one of the words the runner knows -- `lap` or `cadence`. A guard naming a
#     tier no runner honors would run on no lap at all, silently, which is REDS %219 wearing a
#     field name. Absent means `lap`, so the roster's own history needs no editing.
#   Every `ran` line in the run card names a guard the roster actually seats.
#   No run-card line records a red or an absent guard.
#
# WHAT IS REPORTED, as a ratchet rather than a gate. The count per tier; how many rostered guards
# have never run on this pier, in total and for the cadence tier alone; and the oldest recorded
# run. A fresh clone has genuinely run nothing, so `never run here` is an honest reading rather
# than a defect, and gating it would red every clone on the day it lands. The cadence figure is
# printed on its own because that tier is where a guard can go quiet without anyone noticing --
# the every-lap tier reports its own absence by simply not running.
#
# USAGE
#   sh tools/fixtures/standing_equipment_scan.sh
#
# Driven by tools/s/standing_equipment_witness.rish. Run from the repository root.

set -eu

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
card="${STANDING_CARD:-construction/standing-equipment-runs.kyri}"

[ -f "$roster" ] || { echo "verdict=no_roster"; echo "refused: no roster at $roster" >&2; exit 1; }

# The tiers the runner honors. A roster naming anything else is refused rather than run past.
known_tiers="lap cadence"

names=$(mktemp); paths_missing=$(mktemp); halfrows=$(mktemp)
unrostered=$(mktemp); reds=$(mktemp); ranlist=$(mktemp)
badtiers=$(mktemp); cadence_names=$(mktemp)
trap 'rm -f "$names" "$paths_missing" "$halfrows" "$unrostered" "$reds" "$ranlist" "$badtiers" "$cadence_names"' EXIT

rostered=0
missing=0
half=0
unknown_tier=0
tier_lap=0
tier_cadence=0

# One record at a time: a `guard` opens it, `path` and `tier` fill it, the next `guard` closes it.
name=""
sawpath=0
tier=""
close_record() {
  [ -n "$name" ] || return 0
  if [ "$sawpath" -ne 1 ]; then half=$((half + 1)); echo "$name" >> "$halfrows"; fi
  t="${tier:-lap}"
  case " $known_tiers " in
    *" $t "*) ;;
    *) unknown_tier=$((unknown_tier + 1)); echo "$name -> $t" >> "$badtiers" ;;
  esac
  if [ "$t" = cadence ]; then
    tier_cadence=$((tier_cadence + 1))
    echo "$name" >> "$cadence_names"
  elif [ "$t" = lap ]; then
    tier_lap=$((tier_lap + 1))
  fi
  name=""; sawpath=0; tier=""
}

while IFS= read -r line; do
  case "$line" in
    guard\ *)
      close_record
      name=$(printf '%s' "$line" | awk '{print $2}')
      rostered=$((rostered + 1))
      echo "$name" >> "$names"
      ;;
    path\ *)
      path=$(printf '%s' "$line" | awk '{print $2}')
      [ -n "$name" ] || continue
      sawpath=$((sawpath + 1))
      if [ ! -f "$path" ]; then
        missing=$((missing + 1))
        echo "$name -> $path" >> "$paths_missing"
      fi
      ;;
    tier\ *)
      [ -n "$name" ] || continue
      tier=$(printf '%s' "$line" | awk '{print $2}')
      ;;
    *) ;;
  esac
done < "$roster"
close_record

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
  if [ ! -s "$ranlist" ] || ! grep -qx "$n" "$ranlist" 2>/dev/null; then never=$((never + 1)); fi
done < "$names"

never_cadence=0
if [ -s "$cadence_names" ]; then
  while IFS= read -r n; do
    if [ ! -s "$ranlist" ] || ! grep -qx "$n" "$ranlist" 2>/dev/null; then never_cadence=$((never_cadence + 1)); fi
  done < "$cadence_names"
fi

echo "guards_rostered=$rostered"
echo "guards_path_missing=$missing"
echo "guards_half_written=$half"
echo "guards_unknown_tier=$unknown_tier"
echo "tier_lap=$tier_lap"
echo "tier_cadence=$tier_cadence"
echo "runs_recorded=$recorded"
echo "runs_unrostered=$stray"
echo "runs_red=$red"
echo "guards_never_run_here=$never"
echo "cadence_never_run_here=$never_cadence"
echo "oldest_run=${oldest:-none}"
echo "newest_run=${newest:-none}"

[ "$missing" -eq 0 ] || sed 's/^/missing: /' "$paths_missing"
[ "$half" -eq 0 ] || sed 's/^/half_written: /' "$halfrows"
[ "$unknown_tier" -eq 0 ] || sed 's/^/unknown_tier: /' "$badtiers"
[ "$stray" -eq 0 ] || sed 's/^/unrostered: /' "$unrostered"
[ "$red" -eq 0 ] || sed 's/^/red: /' "$reds"

if [ "$missing" -eq 0 ] && [ "$half" -eq 0 ] && [ "$unknown_tier" -eq 0 ] \
  && [ "$stray" -eq 0 ] && [ "$red" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=roster_broken"
echo "refused: the standing roster names something the tree cannot honor -- read the lines above" >&2
exit 1
