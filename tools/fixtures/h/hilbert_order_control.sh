#!/bin/sh
# tools/fixtures/h/hilbert_order_control.sh -- proves hilbert_order_scan.sh's two load-bearing
# walks actually carry the reading, rather than trusting the arithmetic by inspection alone.
#
# The scan makes two claims no later reading can see past if either walk breaks silently:
#   1. a torus hop wraps around the grid edge, so TORUS distance can only ever be <= MESH distance
#   2. a Hilbert curve's own rotation step is what keeps consecutive integers grid-adjacent --
#      drop it and the "always 1.0" invariant the essay leans on stops holding
#
# Each mutation is planted into a COPY of the scan (never the scan itself) and proven to bite: the
# reading changes exactly where the broken walk should show it, and nowhere else. A refusal proven
# only in the passing direction cannot be told from a bypass, so the baseline runs clean first.
#
# Bounds named at the top. Exit 0 always; failures are reported in the summary line.
set -u

MAX_LEGS=32     # legs this control may assert; grows only with a planted mutation

SRC="tools/fixtures/h/hilbert_order_scan.sh"
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
cd "$ROOT" || exit 0

if [ ! -f "$SRC" ]; then
  echo "control_verdict=refused reason=scan_absent"
  exit 0
fi

pen=$(mktemp -d) || { echo "control_verdict=refused reason=no_pen"; exit 0; }
trap 'rm -rf "$pen"' EXIT INT TERM HUP

legs=0
failures=0
leg() {
  legs=$((legs + 1))
  if [ "$legs" -gt "$MAX_LEGS" ]; then
    echo "leg over_bound red"
    failures=$((failures + 1))
    return
  fi
  if [ "$2" = "yes" ]; then
    echo "leg $1 ok"
  else
    echo "leg $1 RED -- $3"
    failures=$((failures + 1))
  fi
}

# ---- baseline: the unmutated scan reads clean and matches the essay's own table ----------------
cp "$SRC" "$pen/baseline.sh"
base=$(sh "$pen/baseline.sh")
case "$base" in
  *"verdict=read"*) ok=yes ;;
  *) ok=no ;;
esac
leg baseline_reads "$ok"

case "$base" in
  *"grid k=2 pairs=3 rowmajor_mesh_mean=1.3333 rowmajor_torus_mean=1.3333 hilbert_mesh_mean=1.0000 hilbert_torus_mean=1.0000"*) ok=yes ;;
  *) ok=no ;;
esac
leg baseline_k2_matches_essay "$ok" "k=2 row read $(echo "$base" | grep '^grid k=2')"

case "$base" in
  *"grid k=4 pairs=15 rowmajor_mesh_mean=1.6000 rowmajor_torus_mean=1.2000 hilbert_mesh_mean=1.0000 hilbert_torus_mean=1.0000"*) ok=yes ;;
  *) ok=no ;;
esac
leg baseline_k4_matches_essay "$ok" "k=4 row read $(echo "$base" | grep '^grid k=4')"

case "$base" in
  *"grid k=8 pairs=63 rowmajor_mesh_mean=1.7778 rowmajor_torus_mean=1.1111 hilbert_mesh_mean=1.0000 hilbert_torus_mean=1.0000"*) ok=yes ;;
  *) ok=no ;;
esac
leg baseline_k8_matches_essay "$ok" "k=8 row read $(echo "$base" | grep '^grid k=8')"

case "$base" in
  *"hilbert_always_one=yes"*) ok=yes ;;
  *) ok=no ;;
esac
case "$base" in
  *"hilbert_always_one=no"*) ok=no ;;
esac
leg baseline_hilbert_always_one "$ok"

case "$base" in
  *"mesh_advantage_ever_below_torus=no"*) ok=yes ;;
  *) ok=no ;;
esac
leg baseline_mesh_advantage_never_below_torus "$ok"

# ---- m1: drop the torus wraparound (both readings fall back to plain mesh distance) ------------
# a torus hop should only ever match or beat a mesh hop; collapsing the wrap removes that
# property, and the k=4 torus_advantage should move from the essay's 0.1667 onto the mesh figure
# 0.3750, since torus and mesh become one measurement.
sed '
  s/rwx = k - rdx; if (rwx < rdx) rtdx = rwx; else rtdx = rdx/rtdx = rdx/
  s/rwy = k - rdy; if (rwy < rdy) rtdy = rwy; else rtdy = rdy/rtdy = rdy/
  s/hwx = k - hdx; if (hwx < hdx) htdx = hwx; else htdx = hdx/htdx = hdx/
  s/hwy = k - hdy; if (hwy < hdy) htdy = hwy; else htdy = hdy/htdy = hdy/
' "$SRC" > "$pen/m1.sh"
m1=$(sh "$pen/m1.sh")
case "$m1" in
  *"grid k=4 pairs=15 rowmajor_mesh_mean=1.6000 rowmajor_torus_mean=1.6000"*"torus_advantage=0.3750"*) ok=yes ;;
  *) ok=no ;;
esac
leg m1_torus_collapse_bites "$ok" "k=4 row read $(echo "$m1" | grep '^grid k=4')"

# ---- m2: drop the Hilbert rotation step (the curve stops visiting grid-adjacent cells in order) --
sed '
  /if (ry == 0) {/,/^      }/d
' "$SRC" > "$pen/m2.sh"
m2=$(sh "$pen/m2.sh")
case "$m2" in
  *"hilbert_always_one=no"*) ok=yes ;;
  *) ok=no ;;
esac
leg m2_rotation_removal_bites "$ok" "$(echo "$m2" | grep hilbert_always_one | tr '\n' ' ')"

# ---- m3: let a non-power-of-two grid through unrefused ------------------------------------------
sed 's/if (!is_pow2(k)) { notpow2++; next }/ /' "$SRC" | sed 's/GRIDS="2 4 8"/GRIDS="2 4 8 3"/' > "$pen/m3.sh"
m3=$(sh "$pen/m3.sh")
case "$m3" in
  *"grid k=3"*) ok=yes ;;
  *) ok=no ;;
esac
leg m3_power_of_two_guard_bites "$ok" "expected a k=3 row to slip through once the guard is removed"

echo "legs=$legs"
echo "failures=$failures"
if [ "$failures" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=red"
fi
