#!/bin/sh
# tools/fixtures/t/torus_offset_generic_search_control.sh -- proves
# torus_offset_generic_search_scan.sh's own arithmetic on planted grids, since the scan reads no
# external population (it is pure arithmetic over four integers) and needs no digest fixture the
# way torus_place_control.sh does.
#
# Run from the repository root:
#   sh tools/fixtures/t/torus_offset_generic_search_control.sh

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
SCAN="$ROOT/tools/fixtures/t/torus_offset_generic_search_scan.sh"

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

# --- leg group 1: a hand-checkable tiny grid (g=3, C=9) -------------------------------------------
# Ceiling = 9 - ceil(9/5) + 1 = 9 - 2 + 1 = 8. Points {0,1,3,5,7} split 9 cells into gaps
# 1,2,2,2,2 (the wrap from 7 to 9-then-0 is 2) -- widest gap 2, span 9-2+1=8, checkable by hand.
out3=$(sh "$SCAN" --grid 3)
[ "$(printf '%s\n' "$out3" | awk -F= '/^candidate_subsets=/{print $2}')" = "70" ]
leg $? "g=3: candidate_subsets is C(8,4)=70, named ahead of the sweep"
[ "$(printf '%s\n' "$out3" | awk -F= '/^best_run_kill=/{print $2}')" = "8" ]
leg $? "g=3: the exhaustive best matches the hand-checkable arithmetic, 8"
[ "$(printf '%s\n' "$out3" | awk -F= '/^theoretical_ceiling=/{print $2}')" = "8" ]
leg $? "g=3: the ceiling is 9 - ceil(9/5) + 1 = 8"
[ "$(printf '%s\n' "$out3" | awk -F= '/^reaches_ceiling=/{print $2}')" = "yes" ]
leg $? "g=3: the generic best reaches the ceiling exactly on the smallest checkable grid"
[ "$(printf '%s\n' "$out3" | awk -F= '/^verdict=/{print $2}')" = "ok" ]
leg $? "g=3: the instrument passes its own gate on the smallest checkable grid"

# --- leg group 2: round one's founding grid (g=8), where the constrained search already lives ----
out8=$(sh "$SCAN" --grid 8)
[ "$(printf '%s\n' "$out8" | awk -F= '/^best_run_kill=/{print $2}')" = "52" ]
leg $? "g=8: the generic best equals the constrained family's own best, 52"
[ "$(printf '%s\n' "$out8" | awk -F= '/^theoretical_ceiling=/{print $2}')" = "52" ]
leg $? "g=8: the ceiling at C=64 is unchanged by dropping the symmetric shape, 52"
[ "$(printf '%s\n' "$out8" | awk -F= '/^reaches_ceiling=/{print $2}')" = "yes" ]
leg $? "g=8: the generic search reaches the founding grid's own ceiling, settling the conjecture the elder essay named"
[ "$(printf '%s\n' "$out8" | awk -F= '/^verdict=/{print $2}')" = "ok" ]
leg $? "g=8: the instrument passes at the founding grid, 595,665 candidates wide"

# --- leg group 3: too small refuses honestly, too large refuses honestly, named rather than hung -
out2=$(sh "$SCAN" --grid 2)
[ "$(printf '%s\n' "$out2" | awk -F= '/^verdict=/{print $2}')" = "unreadable" ]
leg $? "g=2: four cells cannot hold five distinct points and refuses by name"

out32=$(sh "$SCAN" --grid 32)
[ "$(printf '%s\n' "$out32" | awk -F= '/^verdict=/{print $2}')" = "too_large" ]
leg $? "g=32: 45 billion candidates exceeds the named budget and refuses rather than hangs"
[ "$(printf '%s\n' "$out32" | awk -F= '/^candidate_subsets=/{print $2}')" = "45367119105" ]
leg $? "g=32: the refusal names the exact count it would have had to search"

# --- leg group 4: the bound gate is load-bearing, proven by a planted mutation --------------------
# best_run_kill can never truthfully exceed theoretical_ceiling -- the ceiling is a proven upper
# bound on any five-point split of a ring, so bound_holds=no should never fire on real input. To
# show the comparison is a real check rather than a constant, the plant shrinks the CEILING
# formula so it prints a value the real (unmutated) exhaustive search already exceeds -- turning
# an always-true gate into one that must catch a genuine inconsistency.
MUT="$ROOT/.lap/torus_offset_generic_search_scan_mutant.sh"
mkdir -p "$ROOT/.lap"
sed 's/ceil5 = int((cells + 4) \/ 5)/ceil5 = int(cells * 0.9)/' "$SCAN" > "$MUT"
chmod +x "$MUT"
cmp -s "$SCAN" "$MUT" && { echo "FAIL: mutation applied no change -- the substitution did not match"; fail=$((fail + 1)); } || echo "m_gate: the mutation applied"
legs=$((legs + 1))
mut_out=$(sh "$MUT" --grid 3)
mut_ceiling=$(printf '%s\n' "$mut_out" | awk -F= '/^theoretical_ceiling=/{print $2}')
[ "$mut_ceiling" -lt 8 ]
leg $? "m_gate: the planted ceiling formula prints a value below the real best (8), the deliberate lie"
[ "$(printf '%s\n' "$mut_out" | awk -F= '/^bound_holds=/{print $2}')" = "no" ]
leg $? "m_gate: with the real best exceeding the lied-about ceiling, the unchanged comparison catches it -- the gate is load-bearing"
[ "$(printf '%s\n' "$mut_out" | awk -F= '/^verdict=/{print $2}')" = "refused" ]
leg $? "m_gate: the mutant's own verdict reads refused, proving the gate is not a constant"

rm -f "$MUT"

echo "legs_expected=$legs"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=refused"
fi
