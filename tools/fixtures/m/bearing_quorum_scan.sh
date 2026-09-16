#!/bin/sh
# tools/fixtures/m/bearing_quorum_scan.sh -- what does a POLAR BEARING scheme actually buy on a
# torus? Row 8 of active-designing/20260910-060204_the-bounded-torus-moonshots.md is the last
# measurable row of the twelve nobody had opened, and it makes two claims in one sentence:
# "Consensus routing travels on polar bearings. A node announces along a meridian and confirms
# along a parallel, so message count grows with the perimeter rather than the area."
#
# THE TWO CLAIMS COME APART, which is the whole reading. One is about COST and the other about
# what the scheme DELIVERS, and a sentence carrying both lets a true half vouch for a false one.
#
#   READING 1 -- COST. On a g x g torus of N = g*g nodes, one bearing operation is an announce
#   along the announcer's row and a query along the querier's column: 2g - 2 messages. The floor
#   for DISSEMINATION -- every node learning the value -- is N - 1, since every node but the
#   source must receive at least once, whatever the topology or the schedule. The exponent of
#   bearing cost against N is fitted across four grids. A reading near 0.5 says the cost half of
#   row 8 stands.
#
#   READING 2 -- WHAT IS DELIVERED. After one announce, the count of nodes holding the value is
#   measured directly rather than argued, and so is the intersection |row(a) AND col(q)| over
#   every ordered pair of nodes. If coverage is g of N while intersection is 1 for every pair,
#   the scheme is a QUORUM SYSTEM -- two operations are guaranteed to MEET -- and is not a
#   broadcast at all. Row 8's own word is "consensus routing", which a reader takes as everyone
#   learning; the measurement says a vanishing share does.
#
#   READING 3 -- THE WITHHELD PACKET, which is row 8's own falsifier: "The withheld packet leaves
#   two nodes agreeing on different states with both reporting success." One link on the announce
#   line is cut, at every position in turn, and two lines are compared at the same length g: a
#   CYCLE, which is what a torus row is, and a PATH, which is what a grid row is. For each cut,
#   coverage is walked from the announcer, and a SILENT WRONG ANSWER is counted for every querier
#   whose column meets the announce line at a cell the announce never reached -- the querier finds
#   nothing and has no way to tell "no value" from "the value did not arrive". The two-cut case is
#   walked too, because the bound a wrap buys is worth naming exactly.
#
# WHAT WOULD FALSIFY THE READING. An exponent far from 0.5 would break the cost half. An
# intersection other than 1 for some pair would mean the rendezvous guarantee needs a condition
# this scan has not named. A cycle losing coverage under a single cut would mean the wrap buys
# nothing, and a path holding coverage under every single cut would mean the wrap was never the
# cause.
#
# WHAT THIS DOES NOT READ. Any real network, any real Mycelium or Comlink code -- this scan opens
# none and simulates a topology in arithmetic. Node failure, which is a different fault from link
# withholding and wants its own reading. Whether a sequence number or a second quorum would let a
# querier DETECT the gap; that repair is named in the paper and is not measured here. Latency,
# which a hop count is a poor proxy for once a real link has a queue.
#
# USAGE
#   sh tools/fixtures/m/bearing_quorum_scan.sh              # the reading
#   sh tools/fixtures/m/bearing_quorum_scan.sh --grids "4 8"  # narrow the grid list
#
# This reading opens no file and reads no population: the topology is built in arithmetic, so
# the script needs no tree root and runs from anywhere, including a copy in a throwaway pen.

set -eu

GRIDS="4 8 16 32"   # bounded: reading 2 is all-pairs, so the largest grid costs N*N = 1,048,576
MAX_GRID=64         # bounded: refuse a grid past this, where all-pairs leaves the second
MIN_GRID=3          # below this a cut and a wrap are the same thing

while [ $# -gt 0 ]; do
  case "$1" in
    --grids) GRIDS="${2:?--grids wants a list}"; shift 2 ;;
    *) echo "$0: unknown flag $1" >&2; exit 2 ;;
  esac
done

echo "instrument=bearing_quorum"

for g in $GRIDS; do
  case "$g" in
    ''|*[!0-9]*) echo "$0: grid not a count: $g" >&2; exit 2 ;;
  esac
  if [ "$g" -lt "$MIN_GRID" ] || [ "$g" -gt "$MAX_GRID" ]; then
    echo "detail: grid $g outside [$MIN_GRID, $MAX_GRID]"
    echo "verdict=unreadable"
    exit 0
  fi
done

echo "grids=$GRIDS"
echo "max_grid=$MAX_GRID"

printf '%s\n' "$GRIDS" | tr ' ' '\n' | awk '
  NF { g[++n] = $1 }
  END {
    if (n < 2) { print "detail: fewer than two grids -- no exponent"; print "verdict=unreadable"; exit }

    cross_min = -1; cross_max = -1; cross_cases = 0
    cycle_cut1_loss = 0; path_cut1_loss = 0
    cycle_cut1_silent = 0; path_cut1_silent = 0
    cycle_cut2_split = 0; cycle_cut2_cases = 0
    closed_form_misses = 0; ratio_rises = 0; prev_ratio = -1

    for (i = 1; i <= n; i++) {
      G = g[i]; N = G * G

      # READING 1 -- cost, counted by walking the two lines rather than asserted.
      msgs = 0
      for (x = 1; x < G; x++) msgs++      # announce: one hop per further cell of the row
      for (y = 1; y < G; y++) msgs++      # query: one hop per further cell of the column
      floor_diss = N - 1                  # every node but the source must receive at least once
      if (msgs != 2 * G - 2) closed_form_misses++
      ratio = msgs / floor_diss
      if (prev_ratio >= 0 && ratio >= prev_ratio) ratio_rises++
      prev_ratio = ratio
      printf "grid=%d nodes=%d bearing_msgs=%d dissemination_floor=%d cost_ratio=%.6f\n",
        G, N, msgs, floor_diss, ratio
      lx[i] = log(N); ly[i] = log(msgs)

      # READING 2 -- coverage after one announce, walked cell by cell.
      cov = 0
      for (x = 0; x < G; x++) cov++
      printf "grid=%d announce_coverage=%d coverage_share=%.6f\n", G, cov, cov / N

      # READING 2b -- a REAL set intersection. The announcer at (ax, ay) covers row cells
      # ay*G + x; the querier at (qx, qy) reads column cells y*G + qx. The two lists are built
      # and intersected through a marker array, so the count is read rather than reasoned. Only
      # (ay, qx) decides the answer, so G*G distinct cases stand for all N*N ordered pairs.
      for (ay = 0; ay < G; ay++) {
        for (qx = 0; qx < G; qx++) {
          delete mark
          for (x = 0; x < G; x++) mark[ay * G + x] = 1
          c = 0
          for (y = 0; y < G; y++) if ((y * G + qx) in mark) c++
          cross_cases++
          if (cross_min < 0 || c < cross_min) cross_min = c
          if (c > cross_max) cross_max = c
        }
      }

      # READING 3 -- one withheld link, at every position, on a CYCLE (a torus row) and on a
      # PATH (a grid row) of the same length G. Link j joins cell j and (j+1) mod G.
      for (a = 0; a < G; a++) {
        for (j = 0; j < G; j++) {
          reach = 0
          for (k = 0; k < G; k++) {
            ok = 1
            for (s = 0; s < k; s++) if (((a + s) % G) == j) ok = 0
            fwd = ok
            ok = 1
            for (s = 1; s <= G - k; s++) if ((((a - s) % G) + G) % G == j) ok = 0
            bwd = ok
            if (fwd || bwd) reach++
          }
          if (reach < G) cycle_cut1_loss++
          cycle_cut1_silent += (G - reach) * G
        }
        for (j = 0; j <= G - 2; j++) {
          if (a <= j) reach = j + 1; else reach = G - 1 - j
          if (reach < G) path_cut1_loss++
          path_cut1_silent += (G - reach) * G
        }
      }

      # READING 3b -- two withheld links on a cycle, walked the same way. The bound a wrap buys
      # is worth naming exactly, so the split is counted rather than claimed.
      for (j = 0; j < G; j++) {
        for (k = j + 1; k < G; k++) {
          cycle_cut2_cases++
          a = 0
          reach = 0
          for (m = 0; m < G; m++) {
            ok = 1
            for (s = 0; s < m; s++) { l = (a + s) % G; if (l == j || l == k) ok = 0 }
            fwd = ok
            ok = 1
            for (s = 1; s <= G - m; s++) { l = (((a - s) % G) + G) % G; if (l == j || l == k) ok = 0 }
            bwd = ok
            if (fwd || bwd) reach++
          }
          if (reach < G) cycle_cut2_split++
        }
      }
    }

    # Fit the exponent of bearing cost against node count by least squares on the logs. The
    # closed form is 2g - 2 against g*g, so the exponent approaches 0.5 FROM ABOVE: the -2
    # constant is a larger share of the cost at a small grid. The tail fit over the two largest
    # grids is therefore the reading, and the all-grid fit is printed beside it so a reader sees
    # the finite-size bias rather than a single tuned number.
    sx = 0; sy = 0; sxx = 0; sxy = 0
    for (i = 1; i <= n; i++) { sx += lx[i]; sy += ly[i]; sxx += lx[i]*lx[i]; sxy += lx[i]*ly[i] }
    den = n * sxx - sx * sx
    if (den == 0) { print "detail: degenerate grid list -- no exponent"; print "verdict=unreadable"; exit }
    slope_all = (n * sxy - sx * sy) / den
    dx = lx[n] - lx[n-1]
    if (dx == 0) { print "detail: two grids of equal size -- no tail exponent"; print "verdict=unreadable"; exit }
    slope_tail = (ly[n] - ly[n-1]) / dx

    printf "cost_exponent_all=%.4f cost_exponent_tail=%.4f\n", slope_all, slope_tail
    printf "closed_form_misses=%d cost_ratio_rises=%d\n", closed_form_misses, ratio_rises
    printf "cross_cases=%d cross_min=%d cross_max=%d\n", cross_cases, cross_min, cross_max
    printf "cycle_cut1_coverage_losses=%d cycle_cut1_silent_answers=%d\n", cycle_cut1_loss, cycle_cut1_silent
    printf "path_cut1_coverage_losses=%d path_cut1_silent_answers=%d\n", path_cut1_loss, path_cut1_silent
    printf "cycle_cut2_cases=%d cycle_cut2_splits=%d\n", cycle_cut2_cases, cycle_cut2_split

    cost_ok = (closed_form_misses == 0 && ratio_rises == 0 && slope_tail > 0.45 && slope_tail < 0.55)
    meet_ok = (cross_min == 1 && cross_max == 1)
    wrap_ok = (cycle_cut1_loss == 0 && path_cut1_loss > 0 && cycle_cut2_split == cycle_cut2_cases)

    printf "cost_half=%s meet_guarantee=%s wrap_worth_one_cut=%s\n",
      (cost_ok ? "stands" : "fails"), (meet_ok ? "yes" : "no"), (wrap_ok ? "yes" : "no")

    if (!cost_ok)      { print "verdict=cost_fails" }
    else if (!meet_ok) { print "verdict=meet_fails" }
    else if (!wrap_ok) { print "verdict=wrap_fails" }
    else               { print "verdict=rendezvous" }
  }
'
