#!/bin/sh
# tools/fixtures/a/aurora_energy_crossover_control.sh -- does the crossover calculator compute the
# formula it claims, and does it refuse the inputs it says it refuses?
#
# WHY A CONTROL. tools/fixtures/a/aurora_energy_crossover_calc.sh is pure arithmetic over numbers
# tools/fixtures/a/aurora_placement_scan.sh already proves elsewhere (its own control covers the
# geometry); what this control proves is that THIS script applies the formula from the proposal
# correctly, refuses a non-positive per-hop energy, and does not silently divide by zero at the
# 2x2 grid where the torus adds no hop saving. Every hand-computed leg is checked against the
# formula worked by hand in the control's own comment, not against the script's own output.
#
# Run from anywhere:  sh tools/fixtures/a/aurora_energy_crossover_control.sh

set -eu

_root=$(CDPATH= cd -- "$(dirname "$0")" && git rev-parse --show-toplevel) || {
  echo "$0: not inside a git tree" >&2
  exit 2
}
calc="$_root/tools/fixtures/a/aurora_energy_crossover_calc.sh"
[ -f "$calc" ] || { echo "refused: no calc at $calc" >&2; exit 1; }
. "$_root/tools/fixtures/s/shell_portable.sh"

legs=0
faults=0
say() { printf '%s\n' "$*"; }
leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then say "leg $1 ok"
  else faults=$((faults + 1)); say "leg $1 FAULT expected=$2 actual=$3"; fi
}
approx() {
  # approx name expected actual tolerance
  legs=$((legs + 1))
  d=$(awk -v a="$2" -v b="$3" 'BEGIN { x = a - b; if (x < 0) x = -x; print x }')
  within=$(awk -v d="$d" -v tol="$4" 'BEGIN { print (d <= tol) ? "yes" : "no" }')
  if [ "$within" = "yes" ]; then say "leg $1 ok"
  else faults=$((faults + 1)); say "leg $1 FAULT expected=$2 actual=$3 tol=$4"; fi
}

# --- hand-computed legs, against the real calc (e=1, s=1 defaults) ----------
out1=$(sh "$calc")
k4_val=$(echo "$out1" | grep '^grid k=4' | sed -n 's/.*crossover_messages=\([0-9.]*\).*/\1/p')
# hand: L=8 s=1, Hm=2.6667 Ht=2.1333 diff=0.5334 e=1 -> M* = 8*1 / (0.5334*1) = 14.9981
approx k4_default_crossover "14.9981" "$k4_val" "0.01"

k2_reason=$(echo "$out1" | grep '^grid k=2' | sed -n 's/.*reason=\([a-z_]*\).*/\1/p')
leg k2_undefined "no_hop_saving" "$k2_reason"

# --- a second hand-computed leg, non-default e and s -------------------------
out2=$(sh "$calc" --e 2 --s 5)
k3_val=$(echo "$out2" | grep '^grid k=3' | sed -n 's/.*crossover_messages=\([0-9.]*\).*/\1/p')
# hand: L=6 s=5, Hm=2.0000 Ht=1.5000 diff=0.5000 e=2 -> M* = 6*5 / (0.5*2) = 30.0000
approx k3_nondefault_crossover "30.0000" "$k3_val" "0.01"

# --- s may be zero; e may not ------------------------------------------------
out3=$(sh "$calc" --e 1 --s 0)
k4_zero=$(echo "$out3" | grep '^grid k=4' | sed -n 's/.*crossover_messages=\([0-9.]*\).*/\1/p')
approx s_zero_allowed "0.0000" "$k4_zero" "0.0001"

out4=$(sh "$calc" --e 0 --s 1)
v4=$(echo "$out4" | sed -n 's/^verdict=//p')
leg e_zero_refused "refused_input" "$v4"

out5=$(sh "$calc" --e -3 --s 1)
v5=$(echo "$out5" | sed -n 's/^verdict=//p')
leg e_negative_refused "refused_input" "$v5"

out6=$(sh "$calc" --e 1 --s -2)
v6=$(echo "$out6" | sed -n 's/^verdict=//p')
leg s_negative_refused "refused_input" "$v6"

# --- bounds are named ---------------------------------------------------------
leg bound_named "1" "$(echo "$out1" | grep -c '^max_grids=')"
leg all_four_grids_graded "4" "$(echo "$out1" | sed -n 's/^grids_graded=//p')"

# --- mutations: a real copy of the calc, each bitten and proven to bite ------
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT
cp "$calc" "$pen/calc.sh"
mkdir -p "$pen/tools/fixtures/a" "$pen/rishi/bin"
cp "$_root/tools/fixtures/a/aurora_placement_scan.sh" "$pen/tools/fixtures/a/aurora_placement_scan.sh" 2>/dev/null || true
# the mutated copy needs a tree root with the same shape as aurora_placement_scan.sh's own
# upward walk expects; running it from inside the pen with ROOT forced to the real tree keeps
# the placement reading real while only the calc's own arithmetic is mutated.

# m1 -- break the diff<=0 guard so it never fires: the k=2 grid (diff=0) then falls into the
# division branch, which this tree's awk refuses with a fatal error on 0/0 rather than printing
# a false number.
cp "$calc" "$pen/m1.sh"
sed_inplace 's/if (diff <= 0) {/if (diff < -999) {/' "$pen/m1.sh"
chmod +x "$pen/m1.sh"
set +e
m1_out=$(cd "$_root" && sh "$pen/m1.sh" 2>&1)
m1_status=$?
set -e
m1_bites=$(printf '%s' "$m1_out" | grep -qi 'division by zero' && echo yes || echo no)
leg m1_bites "yes" "$m1_bites"
# invariant: a fatal mid-stream awk error still lets the script reach its own "exit 0 always"
# convention, so the bite is read from the error text rather than from the whole-script status.
leg m1_still_exits_clean "0" "$m1_status"

# m2 -- invert the formula (numerator and denominator swapped). The k=4 default reading would
# then read 0.5334/8 = 0.0667 rather than 14.9981, which the hand-computed leg above already
# fixes as the right answer, so comparing the mutant's own k=4 reading against that same
# constant proves the inversion is felt.
cp "$calc" "$pen/m2.sh"
sed_inplace 's#mstar = (L \* s) / (diff \* e)#mstar = (diff * e) / (L * s)#' "$pen/m2.sh"
chmod +x "$pen/m2.sh"
m2_out=$(cd "$_root" && sh "$pen/m2.sh")
m2_k4=$(echo "$m2_out" | grep '^grid k=4' | sed -n 's/.*crossover_messages=\([0-9.]*\).*/\1/p')
m2_differs=$(awk -v a="$m2_k4" 'BEGIN { print (a < 1.0) ? "yes" : "no" }')
leg m2_bites "yes" "$m2_differs"

echo "legs=$legs"
echo "failures=$faults"
if [ "$faults" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=fault"
fi
