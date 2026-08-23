#!/bin/sh
# tools/fixtures/tool_path_control.sh -- prove the fold-shape scan from both sides.
#
# WHY. `tools/fixtures/tool_path_scan.sh` reads a room's fold shape and reports `rooms_over_bound`
# and `collisions` at zero. A reading that has only ever been zero is a reading nobody has seen
# work. This tree already seats the strand: a guard that cannot red guards nothing (REDS row 59,
# where five custody bars of the enclosure witness passed vacuously for their whole lives). So
# each reading is proven here by building a room that genuinely fails it.
#
# WHAT IT BUILDS, each in its own throwaway room under a mktemp root, swept on exit.
#
#   clean       a small room under bound, no symlinks, no collision -- every reading rests
#   overflow    one letter over bound whose two-letter split is ALSO over bound, so the chosen
#               shape genuinely fails and `rooms_over_bound` must rise
#   collision   a subdirectory named `c` beside flat files starting with `c`, so the computed
#               room lands on something already standing and `collisions` must rise
#   reaching    a flat symlink whose target opens with `../`, so `symlinks_up` must rise
#
# The bound is passed as 4 rather than 256, so the pens stay small enough to build in a moment
# and read in a glance. The shape being tested is the same at either size.
#
# USAGE
#   sh tools/fixtures/tool_path_control.sh
#
# Prints one `key=value` line per proven behavior and `control_verdict=ok` on the tail. Exit is
# non-zero the moment a behavior fails, so the witness gates on the run itself.
#
# Kin: tools/tool_path_witness.rish (the rung that runs this) and tools/fixtures/tool_path_scan.sh
# (the scan under test).
#
# Run from the repository root.

set -eu

scan="tools/fixtures/tool_path_scan.sh"
[ -f "$scan" ] || { echo "refused: no scan at $scan" >&2; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

bound=4
proven=0

# Read one key out of a scan run.
reading() {
  sh "$scan" "$1" "$bound" | grep "^$2=" | cut -d= -f2
}

# ---- clean: a room the chosen shape handles, so every gated reading rests at zero -------------
mkdir -p "$pen/clean"
for n in alpha beta gamma delta; do : > "$pen/clean/${n}_probe.rish"; done

[ "$(reading "$pen/clean" rooms_over_bound)" = "0" ] || { echo "control: a clean room must read rooms_over_bound=0" >&2; exit 1; }
[ "$(reading "$pen/clean" collisions)" = "0" ] || { echo "control: a clean room must read collisions=0" >&2; exit 1; }
[ "$(reading "$pen/clean" symlinks_up)" = "0" ] || { echo "control: a clean room must read symlinks_up=0" >&2; exit 1; }
[ "$(reading "$pen/clean" flat_files)" = "4" ] || { echo "control: a clean room must count its own four entries" >&2; exit 1; }
echo "clean_room=rests"
proven=$((proven + 1))

# ---- overflow: one letter over bound whose two-letter split is over bound too -----------------
# Every name opens `ca`, so splitting `c` one letter deeper yields a single room of the same size
# and the shape genuinely fails. This is the case the `tools/` numbers do NOT hit, which is
# exactly why it needs planting.
mkdir -p "$pen/overflow"
for n in 1 2 3 4 5 6; do : > "$pen/overflow/caravan_probe_${n}.rish"; done

over=$(reading "$pen/overflow" rooms_over_bound)
[ "$over" -ge 1 ] || { echo "control: a letter over bound at both depths must read rooms_over_bound>=1, read $over" >&2; exit 1; }
echo "overflow_room=reds"
proven=$((proven + 1))

# ---- collision: a computed room name already standing as a subdirectory ----------------------
mkdir -p "$pen/collision/c"
for n in 1 2; do : > "$pen/collision/caravan_probe_${n}.rish"; done

hits=$(reading "$pen/collision" collisions)
[ "$hits" -ge 1 ] || { echo "control: a computed room landing on an existing subdirectory must read collisions>=1, read $hits" >&2; exit 1; }
echo "collision_room=reds"
proven=$((proven + 1))

# ---- reaching: a flat symlink whose target opens with ../ ------------------------------------
# The shape that dangles when moved one level deeper, which is the whole reason the reading
# exists. The target is deliberately left absent: `symlinks_up` counts the SHAPE of the target,
# never whether it currently resolves, because a fold breaks resolving links rather than broken
# ones.
mkdir -p "$pen/reaching"
: > "$pen/reaching/alpha_probe.rish"
ln -s ../elsewhere/beta_probe.rye "$pen/reaching/beta_probe.rye"

up=$(reading "$pen/reaching" symlinks_up)
[ "$up" = "1" ] || { echo "control: one up-reaching symlink must read symlinks_up=1, read $up" >&2; exit 1; }
links=$(reading "$pen/reaching" flat_symlinks)
[ "$links" = "1" ] || { echo "control: the symlink must be counted as a flat entry, read $links" >&2; exit 1; }
entries=$(reading "$pen/reaching" flat_files)
[ "$entries" = "2" ] || { echo "control: flat_files must count the symlink beside the file, read $entries" >&2; exit 1; }
echo "reaching_room=reds"
proven=$((proven + 1))

# ---- folded: a room with nothing flat left, whose STANDING rooms are what can still fail --------
# The reading that keeps meaning something the day after a fold. `tools/` has no flat entries now,
# so every flat reading sits at zero and a gate resting on those alone would pass by having nothing
# to measure. Here one standing letter room is built over bound and one under, so the standing gate
# is proven to rise while the flat gate correctly rests.
mkdir -p "$pen/folded/c" "$pen/folded/m"
for n in 1 2 3 4 5; do : > "$pen/folded/c/caravan_probe_${n}.rish"; done
: > "$pen/folded/m/mycelium_probe.rish"

[ "$(reading "$pen/folded" flat_files)" = "0" ] || { echo "control: a folded room must hold no flat entries" >&2; exit 1; }
[ "$(reading "$pen/folded" flat_shape_gate)" = "ok" ] || { echo "control: a folded room has no flat question left to answer, so its flat gate must rest at ok" >&2; exit 1; }
[ "$(reading "$pen/folded" standing_rooms)" = "2" ] || { echo "control: both letter rooms must be counted as standing rooms" >&2; exit 1; }
[ "$(reading "$pen/folded" standing_max_room)" = "5" ] || { echo "control: the largest standing room must be measured, not guessed" >&2; exit 1; }
[ "$(reading "$pen/folded" standing_rooms_over_bound)" = "1" ] || { echo "control: a standing room over bound must raise standing_rooms_over_bound" >&2; exit 1; }
echo "folded_room=reds_on_the_standing_reading"
proven=$((proven + 1))

# The overflow room proves the other side of the same verdict: flat entries that cannot be folded
# under bound must read `flat_shape_gate=red`, so `ok` is never merely the absence of a reading.
[ "$(reading "$pen/overflow" flat_shape_gate)" = "red" ] || { echo "control: a room whose chosen shape fails must read flat_shape_gate=red" >&2; exit 1; }
[ "$(reading "$pen/clean" flat_shape_gate)" = "ok" ] || { echo "control: a room the chosen shape handles must read flat_shape_gate=ok" >&2; exit 1; }
echo "flat_shape_gate=proven_both_ways"
proven=$((proven + 1))

# ---- the scan's own refusal -------------------------------------------------------------------
if sh "$scan" "$pen/no-such-room" "$bound" >/dev/null 2>&1; then
  echo "control: the scan must refuse a room that is not there" >&2
  exit 1
fi
echo "absent_room=refuses"
proven=$((proven + 1))

echo "behaviors_proven=$proven"
echo "control_verdict=ok"
