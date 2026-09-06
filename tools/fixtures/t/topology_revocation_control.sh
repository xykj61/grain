#!/bin/sh
# tools/fixtures/t/topology_revocation_control.sh -- proving the revocation census refuses.
#
# WHY. A census proven only in the passing direction cannot be told from a bypass. This
# builds a pen, plants a wrong answer in it four ways, and asserts that each one is bitten
# BY NAME -- then asserts the unplanted census still passes in the same pen, so the pen
# itself is proven innocent of the refusals.
#
# THE FOUR PLANTS, each breaking a different leg:
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
trap 'rm -rf "$PEN"' EXIT INT TERM

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
note "lowlink_disagrees" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'cut_agreement.*same_set=NO')" "2"

# --- plant three: the removal sweep finds nothing -----------------------------
sed -e 's/^  if (cs <= 2) return 0 /  if (cs >= 0) return 0 /' \
    "$CENSUS" > "$PEN/sweep.sh"
run_pen "$PEN/sweep.sh" "$SRC"
note "sweep_verdict" "$(verdict_of)" "refused"
note "sweep_finds_no_cut_point" \
     "$(printf '%s\n' "$PEN_OUT" | grep -c 'compass sponsor cascade points=0')" "1"

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

printf "faults=%d\n" "$faults"
printf "verdict=%s\n" "$([ "$faults" -eq 0 ] && echo proven || echo failed)"
[ "$faults" -eq 0 ]
