#!/bin/sh
# tools/fixtures/a/aurora_energy_crossover_calc.sh -- the first witness Proposal 2 of
# active-designing/date/20260918/20260918-054803_two-first-principles-proposals-caravan-lattice-hop-aurora-energy-crossover.md
# named and left unbuilt: a calculator for the crossover traffic volume where Aurora's torus wrap
# earns back its static link cost.
#
# THE MODEL, taken from the proposal rather than re-derived here. Communication energy per unit
# time is M * H * e for a topology whose mean hop count is H; the torus spends an extra L * s on
# its wrap links whether or not a message ever uses them. The torus wins once:
#
#   M * (Hm - Ht) * e  >  L * s        i.e.        M*  =  L * s / ((Hm - Ht) * e)
#
# THE THREE MEASURED TERMS -- Hm, Ht, L -- are read from tools/fixtures/a/aurora_placement_scan.sh's
# own "grid k=..." lines, one crossover per grid the placement scan already grades. e and s are the
# two terms row 6 of the moonshots page found unmeasurable on every pier this fleet holds (every
# joule-reading door closed by one hypervisor's passthrough choice); they are named parameters here,
# defaulting to 1.0 so the formula prints a dimensionless ratio rather than refusing to run. Pass
# real values with --e and --s the day any pier answers verdict=facility_available.
#
# WHAT THIS DOES NOT REACH. Whether e or s hold the same value across topologies (the Falsifier
# section of the proposal names the wrap-length confound this script cannot see), and whether the
# per-hop model itself is accurate. It computes the formula's own arithmetic correctly and nothing
# beyond that.
#
# Emits key=value lines and a verdict. Bounds are named at the top. Exit 0 always; the witness
# reads the keys.
set -u

MAX_GRIDS=8          # grids graded per run, matching the placement scan's own bound
E_DEFAULT=1.0        # per-hop energy unit, a placeholder until a pier reads a real joule
S_DEFAULT=1.0        # per-link static energy unit, the same placeholder

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
cd "$ROOT" || exit 0

E=$E_DEFAULT
S=$S_DEFAULT
while [ $# -gt 0 ]; do
  case "$1" in
    --e) E=$2; shift 2 ;;
    --s) S=$2; shift 2 ;;
    *) shift ;;
  esac
done

echo "scan=aurora_energy_crossover"
echo "proposal=active-designing/date/20260918/20260918-054803_two-first-principles-proposals-caravan-lattice-hop-aurora-energy-crossover.md"
echo "max_grids=$MAX_GRIDS"
echo "e=$E"
echo "s=$S"

e_ok=$(awk -v e="$E" 'BEGIN { print (e + 0 > 0) ? "yes" : "no" }')
s_ok=$(awk -v s="$S" 'BEGIN { print (s + 0 >= 0) ? "yes" : "no" }')
echo "e_positive=$e_ok"
echo "s_nonnegative=$s_ok"
if [ "$e_ok" != "yes" ] || [ "$s_ok" != "yes" ]; then
  echo "verdict=refused_input"
  exit 0
fi

PLACEMENT=$(sh tools/fixtures/a/aurora_placement_scan.sh 2>/dev/null) || PLACEMENT=""
if [ -z "$PLACEMENT" ]; then
  echo "verdict=refused_no_placement"
  exit 0
fi

echo "$PLACEMENT" | grep '^grid ' | awk -v maxg="$MAX_GRIDS" -v e="$E" -v s="$S" '
  BEGIN { graded = 0 }
  {
    k = ""; torus_links = ""; mesh_links = ""; torus_mean = ""; mesh_mean = ""
    for (i = 1; i <= NF; i++) {
      split($i, kv, "=")
      if (kv[1] == "k") k = kv[2]
      if (kv[1] == "torus_links") torus_links = kv[2]
      if (kv[1] == "mesh_links") mesh_links = kv[2]
      if (kv[1] == "torus_mean") torus_mean = kv[2]
      if (kv[1] == "mesh_mean") mesh_mean = kv[2]
    }
    if (k == "") next
    if (graded >= maxg) { over++; next }
    graded++

    L = torus_links - mesh_links
    diff = mesh_mean - torus_mean
    printf "grid k=%s Hm=%s Ht=%s L=%d diff=%.4f", k, mesh_mean, torus_mean, L, diff

    if (diff <= 0) {
      printf " crossover_messages=undefined reason=no_hop_saving\n"
    } else {
      mstar = (L * s) / (diff * e)
      printf " crossover_messages=%.4f\n", mstar
    }
  }
  END {
    print "grids_graded=" graded
    print "grids_over_bound=" (over + 0)
  }
'

echo "verdict=computed"
