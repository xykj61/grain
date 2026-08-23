#!/bin/sh
# tools/fixtures/standing_equipment_run.sh -- run every rostered guard and record when each ran.
#
# WHY. crux/standing-equipment.kyri names what stands. This runs it, and writes one line per
# guard into the run card, so the question "when did this last run?" has an answer on disk
# rather than in a memory of a round. REDS %149 taught the sentence this exists to make
# checkable: a bound is only a bound on the laps someone runs it.
#
# WHAT IT WRITES. crux/standing-equipment-runs.kyri, one `ran <name> <stamp> <verdict>` line
# per guard, rewritten whole on each run rather than appended, so the card stays bounded at
# the roster's own size. The card is untracked by design -- it measures THIS pier's history,
# and a fresh clone that has run nothing should say so.
#
# USAGE
#   sh tools/fixtures/standing_equipment_run.sh            # run every rostered guard
#   sh tools/fixtures/standing_equipment_run.sh banner_room # run one, updating only its line
#
# Run from the repository root. Slow by nature -- it runs the whole roster.

set -eu

roster="crux/standing-equipment.kyri"
card="crux/standing-equipment-runs.kyri"
only="${1:-}"

[ -f "$roster" ] || { echo "refused: no roster at $roster" >&2; exit 1; }

stamp=$(TZ=America/New_York date +%Y%m%d.%H%M%S)

fresh=$(mktemp)
trap 'rm -f "$fresh"' EXIT

# Keep every card line whose guard is not being re-run this pass.
if [ -f "$card" ]; then
  while IFS= read -r line; do
    case "$line" in
      ran\ *)
        name=$(printf '%s' "$line" | awk '{print $2}')
        if [ -n "$only" ] && [ "$name" != "$only" ]; then printf '%s\n' "$line" >> "$fresh"; fi
        ;;
      *) ;;
    esac
  done < "$card"
fi

ran=0
green=0
red=0

name=""
while IFS= read -r line; do
  case "$line" in
    guard\ *) name=$(printf '%s' "$line" | awk '{print $2}') ;;
    path\ *)
      path=$(printf '%s' "$line" | awk '{print $2}')
      [ -n "$name" ] || continue
      if [ -n "$only" ] && [ "$name" != "$only" ]; then name=""; continue; fi
      if [ -f "$path" ]; then
        if rishi/bin/rishi run "$path" >/dev/null 2>&1; then
          verdict=green
          green=$((green + 1))
        else
          verdict=red
          red=$((red + 1))
        fi
      else
        verdict=absent
        red=$((red + 1))
      fi
      echo "ran $name $stamp $verdict" >> "$fresh"
      echo "$name $verdict"
      ran=$((ran + 1))
      name=""
      ;;
    *) ;;
  esac
done < "$roster"

{
  echo "# crux/standing-equipment-runs.kyri -- when each standing guard last ran on THIS pier."
  echo "# Written by tools/fixtures/standing_equipment_run.sh; untracked on purpose, so a fresh"
  echo "# clone reads 'never run here' rather than inheriting another machine's memory."
  echo "format standing-equipment-runs-v1"
  sort "$fresh"
} > "$card"

echo "guards_run=$ran"
echo "guards_green=$green"
echo "guards_red=$red"

if [ "$red" -eq 0 ]; then echo "run_verdict=ok"; exit 0; fi
echo "run_verdict=guard_red"
echo "refused: a rostered guard answered red -- read its own line" >&2
exit 1
