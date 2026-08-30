#!/bin/sh
# The Caravan door publishes two living counts. Read each from the roster that owns it, then
# require the prose to carry the same answer so a dated tally cannot pose as current state.
set -eu

DIR=${CARAVAN_DIR:-caravan}
README=${CARAVAN_README:-$DIR/README.md}
TOOLS=${CARAVAN_TOOLS_DIR:-tools}
ROSTER=${CARAVAN_ROSTER_FILE:-tools/ca/caravan_suite_witness.rish}

module_out=$(sh tools/fixtures/c/caravan_ladder_roster_scan.sh census "$DIR")
roster_out=$(CARAVAN_TOOLS_DIR="$TOOLS" CARAVAN_ROSTER_FILE="$ROSTER" sh tools/fixtures/c/caravan_roster_bijection_scan.sh)
modules=$(printf '%s\n' "$module_out" | sed -n 's/^modules_on_disk=//p')
witnesses=$(printf '%s\n' "$roster_out" | sed -n 's/^ROSTER_DISK //p')
door_modules=$(sed -n 's/^\*\*Status:\*\* Checkable -- \([0-9][0-9]*\) modules.*/\1/p' "$README")
door_witnesses=$(sed -n 's/^\*\*Status:\*\*.*and \([0-9][0-9]*\) registered witnesses.*/\1/p' "$README")
ladder_modules=$(sed -n 's/^\*\*\[`LADDER.md`\].*all \([0-9][0-9]*\) modules.*/\1/p' "$README")

echo "modules_measured=$modules modules_declared=${door_modules:-unread}"
echo "witnesses_measured=$witnesses witnesses_declared=${door_witnesses:-unread}"
echo "ladder_modules_declared=${ladder_modules:-unread}"
if [ -n "$door_modules" ] && [ -n "$door_witnesses" ] && [ -n "$ladder_modules" ] && [ "$modules" = "$door_modules" ] && [ "$witnesses" = "$door_witnesses" ] && [ "$modules" = "$ladder_modules" ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=door_count_drift"
exit 1
