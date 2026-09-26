#!/bin/sh
# tools/fixtures/t/torus_offset_search_control.sh -- proves torus_offset_search_scan.sh's own
# arithmetic on planted grids, since the scan reads no external population (it is pure arithmetic
# over one integer d) and needs no digest fixture the way its elder torus_place_control.sh does.
#
# Run from the repository root:
#   sh tools/fixtures/t/torus_offset_search_control.sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/src" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SCAN="$ROOT/tools/fixtures/t/torus_offset_search_scan.sh"

legs=0
fail=0
leg() {
  legs=$((legs + 1))
  if [ "$1" = "0" ]; then
    echo "$2"
  else
    echo "FAIL: $2"
    fail=$((fail + 1))
  fi
}

# --- leg group 1: round one's own grid (g=8) reproduces its own two elder points -----------------
out8=$(sh "$SCAN" --grid 8)
[ "$(printf '%s\n' "$out8" | awk -F= '/^d1_run_kill=/{print $2}')" = "5" ]
leg $? "g=8: d=1 reproduces round one's ring4adj closed form, 5"
[ "$(printf '%s\n' "$out8" | awk -F= '/^dg_run_kill=/{print $2}')" = "33" ]
leg $? "g=8: d=g reproduces round one's ring4wide measurement, 33"
[ "$(printf '%s\n' "$out8" | awk -F= '/^best_run_kill=/{print $2}')" = "52" ]
leg $? "g=8: the search finds 52, the theoretical ceiling for five points on 64 cells"
[ "$(printf '%s\n' "$out8" | awk -F= '/^theoretical_ceiling=/{print $2}')" = "52" ]
leg $? "g=8: the search reaches the ceiling exactly rather than approaching it"
[ "$(printf '%s\n' "$out8" | awk -F= '/^search_beats_round_one=/{print $2}')" = "yes" ]
leg $? "g=8: the search beats round one's already-measured 33"
[ "$(printf '%s\n' "$out8" | awk -F= '/^verdict=/{print $2}')" = "ok" ]
leg $? "g=8: the instrument passes its own gate on the founding grid"

# --- leg group 2: a second grid (g=32), so the reading is not one lucky point --------------------
out32=$(sh "$SCAN" --grid 32)
[ "$(printf '%s\n' "$out32" | awk -F= '/^dg_run_kill=/{print $2}')" = "129" ]
leg $? "g=32: the elder closed form 4g+1 holds at a second grid"
[ "$(printf '%s\n' "$out32" | awk -F= '/^search_beats_round_one=/{print $2}')" = "yes" ]
leg $? "g=32: the search beats round one's number here too"
[ "$(printf '%s\n' "$out32" | awk -F= '/^verdict=/{print $2}')" = "ok" ]
leg $? "g=32: the instrument passes at a grid four times round one's own"

# --- leg group 3: a grid small enough to alias is a precondition, not a refusal ------------------
out3=$(sh "$SCAN" --grid 3)
[ "$(printf '%s\n' "$out3" | awk -F= '/^dg_run_kill=/{print $2}')" = "-1" ]
leg $? "g=3: d=g aliases into fewer than five distinct copies and reads -1, named rather than guessed"
[ "$(printf '%s\n' "$out3" | awk -F= '/^verdict=/{print $2}')" = "refused" ]
leg $? "g=3: an aliasing grid refuses honestly rather than reporting a false closed-form match"

# --- leg group 4: the gate is load-bearing, proven by a planted mutation -------------------------
MUT="$ROOT/.lap/torus_offset_search_scan_mutant.sh"
mkdir -p "$ROOT/.lap"
sed 's/echo "closed_forms_hold=\$closed_ok"/closed_ok=yes; echo "closed_forms_hold=\$closed_ok"/' "$SCAN" > "$MUT"
chmod +x "$MUT"
cmp -s "$SCAN" "$MUT" && { echo "FAIL: mutation applied no change -- the sed pattern did not match"; fail=$((fail + 1)); } || echo "m_gate: the mutation applied"
legs=$((legs + 1))
mut_out=$(sh "$MUT" --grid 3)
[ "$(printf '%s\n' "$mut_out" | awk -F= '/^closed_forms_hold=/{print $2}')" = "yes" ]
leg $? "m_gate: forcing closed_forms_hold=yes on an aliasing grid is the planted lie"
[ "$(printf '%s\n' "$mut_out" | awk -F= '/^verdict=/{print $2}')" = "ok" ]
leg $? "m_gate: without the real check, the mutant reads ok on a grid that should refuse -- the gate was load-bearing"
rm -f "$MUT"

echo "legs_expected=13"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=refused"
fi
