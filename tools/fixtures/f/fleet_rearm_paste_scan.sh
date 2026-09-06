#!/bin/sh
# fleet_rearm_paste_scan.sh -- count the seats whose RELAUNCH heading is followed by no command.
#
# WHY THIS READING EXISTS. tools/f/fleet_rearm.sh prints a `RELAUNCH:` heading for every seat that
# is not the field and not gated, and then a `case` decides the paste beneath it. When that case
# spelled seat names by hand it grew stale against construction/fleet-roster.kyri, and five of the
# eight LIVE ships printed the heading with nothing under it -- the one output whose whole purpose
# is a line a hand can paste. Nothing measured it, because every assertion in the witness named a
# seat the stale list happened to carry.
#
# THE READING is deliberately shape-based rather than name-based: it asks whether the line AFTER
# each heading starts a command, so it stays true for a seat added tomorrow and for the two codex
# supervisor pastes that begin `cd ~/grain-mind`. A name-based check would be the seventh copy of
# the seat table, which is the fault itself.
#
#   sh tools/fixtures/f/fleet_rearm_paste_scan.sh              # read $HOME's seats
#   FLEET_HOME=<pen> sh tools/fixtures/f/fleet_rearm_paste_scan.sh
#
# Prints one line: `empty_pastes=N`. N is the gate; zero is the only passing reading.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

FLEET_HOME=${FLEET_HOME:-$HOME}
export FLEET_HOME

sh tools/f/fleet_rearm.sh 2>/dev/null \
  | awk '/RELAUNCH:/ { getline nxt; if (nxt !~ /cd /) empty++ } END { printf "empty_pastes=%d\n", empty + 0 }'
