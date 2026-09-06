#!/bin/sh
# tools/fixtures/t/topology_revocation_control.sh -- proving the revocation census refuses.
#
# WHY. A census proven only in the passing direction cannot be told from a bypass. This
# builds a pen, plants a wrong answer in it six ways, and asserts that each one is bitten
# BY NAME -- then asserts the unplanted census still passes in the same pen, so the pen
# itself is proven innocent of the refusals.
#
# THE SIX PLANTS, each breaking a different leg:
#
#   geometry   -- a topology source naming a different sky. The sibling-bound edge and
#                 isolated counts must refuse rather than confidently measuring a sky
#                 nobody runs.
#   lowlink    -- the second cut-point algorithm loses its root rule, so it undercounts.
#                 The two algorithms must disagree and the census must refuse.
#   sweep      -- the removal sweep returns zero for every point, so it finds no cut point
#                 at all. The disagreement must fire from the OTHER side.
#   both       -- both algorithms broken the same way. They agree with each other and are
#                 both wrong, and the sibling bound is what catches it. This is the plant
#                 that proves the bound leg earns its keep beside the agreement leg.
#   pointsponsor -- the point metric loses its star tier: every planet is sponsored by its
#                 galaxy directly. Edges, isolated and max_stranded are ALL unmoved and both
#                 cut algorithms agree, so only the shape binds -- degree_max and the cut
#                 count -- are left to bite. This is the plant that proves a size reading
#                 cannot stand in for a shape reading.
#   bridge     -- the one hop between galaxy roots goes, so the complete graph on the roots
#                 vanishes and the ladder falls into a component per galaxy. This proves the
#                 point legs own edge bound does work rather than riding on the sponsor legs.
#
# Instrument: `sh` and `awk`, POSIX-granted. The pen is made with a fixed name under the
# hosts temporary directory and removed on exit; no `mktemp`, which is not POSIX.
#
# Read against: active-designing/20260906-034951_the-revocation-and-the-fault-ride-one-edge.md
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

CENSUS="$ROOT/tools/fixtures/t/topology_revocation_census.sh"
SRC="$ROOT/comlink/topology.rye"
[ -f "$CENSUS" ] || { echo "control: the census is missing at $CENSUS" >&2; exit 2; }
[ -f "$SRC" ]    || { echo "control: the topology source is missing at $SRC" >&2; exit 2; }

PEN="${TMPDIR:-/tmp}/topology_revocation_control_pen"
rm -rf "$PEN"
mkdir -p "$PEN"
# REDS %487: a handler that cleans up without exiting does not stop the script -- POSIX runs
# it and RESUMES where the signal landed, so the run carries on against the pen it just
# deleted. EXIT cleans once; INT and TERM exit with the signal numbers they carry.
trap 'rm -rf "$PEN"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

faults=0

# `note` prints one asserted line. `want` is what this control expects to see.
note() {
  if [ "$2" = "$3" ]; then
    printf "  %s %s ok\n" "$1" "$2"
  else
    printf "  %s %s wanted=%s MISMATCH\n" "$1" "$2" "$3"
    faults=$((faults + 1))
  fi
}

run_pen() {
  # $1 census path, $2 source path. Prints nothing; sets PEN_OUT and PEN_CODE.
  set +e
  PEN_OUT=$(TOPOLOGY_SRC="$2" sh "$1" 2>&1)
  PEN_CODE=$?
  set -e
}

verdict_of() { printf '%s\n' "$PEN_OUT" | awk -F= '/^verdict=/ {print $2; exit}'; }
field_of()   { printf '%s\n' "$PEN_OUT" | awk -v k="$1" '$0 ~ k {print; exit}'; }

echo "pen $PEN"

# --- clean: the pen is innocent ----------------------------------------------
run_pen "$CENSUS" "$SRC"
note "clean_verdict"  "$(verdict_of)" "ok"
note "clean_exit"     "$PEN_CODE"     "0"

# --- plant one: a different geometry -----------------------------------------
# 12-5-12 becomes 6-5-12, so every sibling-bound count moves.
sed -e 's/^pub const galaxies_per_universe: u32 = 12;/pub const galaxies_per_universe: u32 = 6;/' \
    "$SRC" > "$PEN/geometry.rye"
run_pen "$CENSUS" "$PEN/geometry.rye"
note "geometry_verdict" "$(verdict_of)" "refused"
note "geometry_exit"    "$PEN_CODE"     "1"
note "geometry_bites_edges" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_sponsor_edges=.*MISMATCH')" "1"

# --- plant two: the lowlink pass loses its root rule --------------------------
sed -e 's/^    if (kids >= 2) artic\[root\] = 1$/    if (kids >= 999) artic[root] = 1/' \
    "$CENSUS" > "$PEN/lowlink.sh"
run_pen "$PEN/lowlink.sh" "$SRC"
note "lowlink_verdict" "$(verdict_of)" "refused"
# FOUR rather than two since the point legs joined: both skies now carry a sponsor leg AND a
# point leg with cut points in them, and the torus legs have none to disagree about.
note "lowlink_disagrees" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'cut_agreement.*same_set=NO')" "4"

# --- plant three: the removal sweep finds nothing -----------------------------
sed -e 's/^  if (cs <= 2) return 0 /  if (cs >= 0) return 0 /' \
    "$CENSUS" > "$PEN/sweep.sh"
run_pen "$PEN/sweep.sh" "$SRC"
note "sweep_verdict" "$(verdict_of)" "refused"
note "sweep_finds_no_cut_point" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'compass sponsor cascade points=0')" "1"
note "sweep_finds_no_cut_point_on_point_leg" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'compass point cascade points=0')" "1"

# --- plant four: both algorithms wrong, and agreeing with each other ----------
# Both plants applied to one copy. The two cut-point passes now find zero and AGREE, so the
# agreement leg goes quiet and only the sibling bound is left to bite. This is the plant
# that proves the bound leg earns its keep beside the agreement leg rather than duplicating it.
sed -e 's/^    if (kids >= 2) artic\[root\] = 1$/    if (kids >= 999) artic[root] = 1/' \
    -e 's/if (a != root \&\& low\[u\] >= disc\[a\]) artic\[a\] = 1/if (a != root \&\& low[u] >= 999999) artic[a] = 1/' \
    "$PEN/sweep.sh" > "$PEN/both.sh"
run_pen "$PEN/both.sh" "$SRC"
note "both_verdict"          "$(verdict_of)" "refused"
note "both_algorithms_agree" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'cut_agreement.*same_set=NO')" "0"
note "both_bound_still_bites" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_sponsor_max_stranded=0 wanted=48 MISMATCH')" "1"
note "both_bound_still_bites_on_point_leg" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_point_max_stranded=0 wanted=59 MISMATCH')" "1"

# --- plant five: the point sponsor loses the star tier ------------------------
# Every planet is sponsored by its galaxy directly, so the star tier vanishes from the graph
# the point metric defines. This plant is the reason the SHAPE binds exist, and it earns its
# place by what it leaves alone: edges stay 774, isolated stays 0, and max_stranded stays 59,
# because the same 59 points are stranded however the tier beneath them is wired. Both
# cut-point algorithms agree on the wrong answer too, so the agreement leg stays quiet.
# What moves is degree_max, 26 to 70, and the cut count, 60 to 12.
#
# THE THREE ASSERTIONS BELOW ARE WRITTEN FROM THE MEASUREMENT RATHER THAN FROM THE GUESS.
# The first draft asserted that max_stranded would bite; it does not, and the pen said so.
# Asserting the MISS as hard as the bite is what proves the shape binds are load-bearing
# rather than decorative -- without them this plant walks through.
sed -e 's/^  if (d\[n\] == 2) return gal\[n\] + st\[n\] \* RG$/  if (d[n] == 99) return gal[n] + st[n] * RG/' \
    "$CENSUS" > "$PEN/pointsponsor.sh"
run_pen "$PEN/pointsponsor.sh" "$SRC"
note "point_sponsor_verdict" "$(verdict_of)" "refused"
note "point_sponsor_size_binds_stay_blind" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_point_max_stranded=59 ok')" "1"
note "point_sponsor_agreement_leg_stays_quiet" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'compass point cut_agreement.*same_set=yes')" "1"
note "point_sponsor_bites_degree_max" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_point_degree_max=70 wanted=26 MISMATCH')" "1"
note "point_sponsor_bites_cut_points" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_point_cut_points=12 wanted=60 MISMATCH')" "1"
note "point_sponsor_leaves_sponsor_leg_clean" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_sponsor_max_stranded=48 ok')" "1"

# --- plant six: the bridge between galaxy roots goes --------------------------
# Two galaxies stop being one hop apart, so the complete graph on the roots vanishes and the
# ladder falls into one component per galaxy. This is the plant that proves the point legs
# EDGE bound is doing work rather than riding on the sponsor legs.
sed -e 's/^  return point_depth_of(a) + point_depth_of(b) + 1$/  return point_depth_of(a) + point_depth_of(b) + 9/' \
    "$CENSUS" > "$PEN/bridge.sh"
run_pen "$PEN/bridge.sh" "$SRC"
note "bridge_verdict" "$(verdict_of)" "refused"
note "bridge_bites_edges" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_point_edges=.*wanted=774 MISMATCH')" "1"
note "bridge_leaves_sponsor_edges_clean" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'bound compass_sponsor_edges=642 ok')" "1"

printf "faults=%d\n" "$faults"
printf "verdict=%s\n" "$([ "$faults" -eq 0 ] && echo proven || echo failed)"
[ "$faults" -eq 0 ]
