#!/bin/sh
# tools/fixtures/h/hilbert_order_scan.sh -- DOES HILBERT ORDER BEAT ROW-MAJOR FOR ID-ADJACENT
# TRAFFIC? Closes the arithmetic half of
# active-designing/date/20261001/20261001-125213_hilbert-order-beats-row-major-for-id-adjacent-traffic.md
# into the checkable room, as that essay's own "What Bakery could build" section names.
#
# THE QUESTION. Row 7 of active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md
# fixes a topology (mesh or torus) and leaves open HOW module IDs should land on grid nodes. This
# scan keeps the topology question outside its own scope -- aurora_placement_scan.sh grades that --
# and compares two ASSIGNMENT ORDERS under both topologies: row-major (`node(i) = (i mod k, i div
# k)`, the default aurora_placement_scan.sh already builds) against a Hilbert space-filling curve.
#
# THE METRIC. For every consecutive integer pair (i, i+1) on a k x k grid (k a power of two, since
# the classical Hilbert construction used here requires it), this scan measures the hop distance
# between where i and i+1 land, under both topologies, and reports the MEAN across all k^2 - 1
# pairs. A placement that keeps ID-adjacent modules grid-adjacent pays less for the traffic this
# essay's own working assumption predicts they carry.
#
# WHY HILBERT ALWAYS READS 1.0. A Hilbert curve visits every cell exactly once, and each step in
# its sequence moves to a grid-ADJACENT cell by construction -- not by measurement. So the mean hop
# distance between consecutive integers in Hilbert order is exactly 1.0 at every grid size the
# construction admits, on both mesh and torus (a torus can only ever match or beat a mesh's hop
# count, never exceed it, since every mesh link is also a torus link). This scan asserts that
# invariant on metal rather than trusting the construction's own proof.
#
# THE d2xy MAPPING is the classical public-domain Hilbert-curve algorithm (the one attributed to
# Wikipedia's own "Hilbert curve" article and reproduced in countless public-domain listings),
# reimplemented here in portable awk without bitwise operators -- POSIX awk carries none, so each
# bit this algorithm needs (`t/2 mod 2`, `t mod 2 XOR rx`) is read by integer division and modulo
# instead. gawk's `and`/`or`/`xor` extensions stay unused on purpose, so the scan runs under either
# awk dialect `shell_dialect` already holds this tree to.
#
# Emits key=value lines and a verdict. Bounds are named at the top. Exit 0 always; the witness
# reads the keys.
set -u

MAX_GRIDS=8          # grids graded per run; each costs O(k^2) pair readings
GRIDS="2 4 8"        # powers of two, matching the essay's own table

echo "scan=hilbert_order"
echo "page=active-designing/date/20261001/20261001-125213_hilbert-order-beats-row-major-for-id-adjacent-traffic.md"
echo "max_grids=$MAX_GRIDS"

echo "$GRIDS" | tr ' ' '\n' | awk -v maxg="$MAX_GRIDS" '
  function d2xy(gk, d, out,    rx, ry, s, t, tmp) {
    t = d
    out["x"] = 0; out["y"] = 0
    for (s = 1; s < gk; s *= 2) {
      rx = int(t / 2) % 2
      ry = (t % 2 != rx) ? 1 : 0
      if (ry == 0) {
        if (rx == 1) {
          out["x"] = s - 1 - out["x"]
          out["y"] = s - 1 - out["y"]
        }
        tmp = out["x"]; out["x"] = out["y"]; out["y"] = tmp
      }
      out["x"] += s * rx
      out["y"] += s * ry
      t = int(t / 4)
    }
  }
  function is_pow2(k,    m) {
    if (k < 1) return 0
    m = k
    while (m > 1) { if (m % 2 != 0) return 0; m = int(m / 2) }
    return 1
  }
  BEGIN { graded = 0 }
  NF == 0 { next }
  {
    k = $1 + 0
    if (k < 2) next
    if (graded >= maxg) { over++; next }
    if (!is_pow2(k)) { notpow2++; next }
    graded++
    n = k * k

    rm_mesh = 0; rm_torus = 0; hb_mesh = 0; hb_torus = 0
    for (i = 0; i < n - 1; i++) {
      # row-major: node(i) = (i mod k, i div k)
      rax = i % k; ray = int(i / k)
      rbx = (i + 1) % k; rby = int((i + 1) / k)
      rdx = rax > rbx ? rax - rbx : rbx - rax
      rdy = ray > rby ? ray - rby : rby - ray
      rm_mesh += rdx + rdy
      rwx = k - rdx; if (rwx < rdx) rtdx = rwx; else rtdx = rdx
      rwy = k - rdy; if (rwy < rdy) rtdy = rwy; else rtdy = rdy
      rm_torus += rtdx + rtdy

      d2xy(k, i, A); d2xy(k, i + 1, B)
      hdx = A["x"] > B["x"] ? A["x"] - B["x"] : B["x"] - A["x"]
      hdy = A["y"] > B["y"] ? A["y"] - B["y"] : B["y"] - A["y"]
      hb_mesh += hdx + hdy
      hwx = k - hdx; if (hwx < hdx) htdx = hwx; else htdx = hdx
      hwy = k - hdy; if (hwy < hdy) htdy = hwy; else htdy = hdy
      hb_torus += htdx + htdy
    }
    pairs = n - 1
    rmm = rm_mesh / pairs; rmt = rm_torus / pairs
    hbm = hb_mesh / pairs; hbt = hb_torus / pairs
    hilbert_one = (hbm == 1 && hbt == 1) ? "yes" : "no"
    mesh_adv = (rmm > 0) ? (rmm - hbm) / rmm : 0
    torus_adv = (rmt > 0) ? (rmt - hbt) / rmt : 0
    mesh_beats = (hbm < rmm) ? "yes" : (hbm == rmm ? "tie" : "no")
    torus_beats = (hbt < rmt) ? "yes" : (hbt == rmt ? "tie" : "no")
    printf "grid k=%d pairs=%d rowmajor_mesh_mean=%.4f rowmajor_torus_mean=%.4f hilbert_mesh_mean=%.4f hilbert_torus_mean=%.4f hilbert_always_one=%s mesh_advantage=%.4f torus_advantage=%.4f hilbert_beats_rowmajor_mesh=%s hilbert_beats_rowmajor_torus=%s\n", \
      k, pairs, rmm, rmt, hbm, hbt, hilbert_one, mesh_adv, torus_adv, mesh_beats, torus_beats
    if (mesh_adv + 0 < torus_adv - 0.00001) widens_bad++
  }
  END {
    printf "grids_graded=%d\n", graded
    printf "grids_over_bound=%d\n", over + 0
    printf "grids_not_power_of_two=%d\n", notpow2 + 0
    printf "mesh_advantage_ever_below_torus=%s\n", (widens_bad + 0 > 0) ? "yes" : "no"
  }'

echo "verdict=read"
