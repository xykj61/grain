#!/bin/sh
# tools/fixtures/t/topology_metric_census.sh -- what the sky's routing metric actually
# distinguishes, measured over every ordered pair of points rather than argued.
#
# WHY. `comlink/topology.rye` gives each point three coordinates: a galaxy index (the number
# modulo the galaxy count), a star index, and a planet index. Its `route_hops` reads two of
# them and reads both only for EQUALITY -- same star? same planet? -- so a hop count cannot
# depend on WHICH stars two points sit under. That is a design choice, and until this census
# it was a choice nobody had priced. This script prices it: it reproduces `decode` and
# `route_hops` in awk, enumerates every ordered pair, and prints what the metric separates.
#
# WHAT IT PRINTS, per sky:
#   points, pairs, diameter, mean_hops
#   the hop histogram, one line per value, with each value's share of all ordered pairs
#   entropy_bits    -- Shannon entropy of the hop distribution, base 2
#   ceiling_bits    -- log2(distinct hop values): the most a metric of this range could carry
#   cross_star_planet_pairs / distinct_hop_values_among_them -- the angle reading. How many
#                      same-galaxy, different-star planet pairs exist, and how many DIFFERENT
#                      hop counts they take between them. One means the metric is angle-blind.
#   zero_hop_distinct -- distinct points the metric calls zero hops apart. Must be 0, or
#                      routing cannot tell two points apart. This is the one real invariant.
#   consecutive_at_diameter -- numerically adjacent point numbers sitting at the diameter.
#
# PROVING THE INSTRUMENT, because a census that reproduces a function is making a claim about
# that function. Two legs run before any number is reported:
#   `derived_counts` binds the constants THIS SCRIPT READ to the ones the module proves -- its
#     selftest reds unless star_count is 60 and universe_points is 720 -- so a source whose
#     fan-outs were misread reports a fault rather than a confident census of a sky nobody runs.
#   `selftest_pair` runs the five pairs the module asserts, against the answers it asserts.
#   Both were proven able to red: a wrong hop model answered 3 where the module says 5, and a
#   planted sky answered star_count=84 where the module proves 60.
#
# WHAT THE SELFTEST TAUGHT THIS SCRIPT, kept here because it is the sharpest thing in the file.
# `Address.of_planet(8, 0, 0)` encodes to number 8, and `decode(8)` answers tier `galaxy` --
# the spaces nest inclusively, so number 8 is PRIMARILY a galaxy and WEARS the planet outfit.
# `route_hops` reads `tier` through `depth()`, so a distance depends on which outfit each end
# wears rather than on the two points alone. The census enumerates by NUMBER, which is the
# primary-role reading a network routes between; the agreement leg therefore builds its five
# addresses at the explicit tiers the selftest gives them, or it would be comparing two
# different questions and calling the difference a fault. It did, once, before this note.
#
# A CENSUS GATES NOTHING ELSE. It reports; a paper cites it; a witness may later bind one of
# its readings. `verdict=ok` unless an instrument leg fails or the zero-hop invariant breaks.
#
# Instrument: `awk` alone (POSIX-granted). No temporary files, no `mktemp`.
#
# Read against: active-designing/20260905-224714_the-angle-the-sky-computes-and-never-subtracts.md
set -eu

# TOPOLOGY_SRC lets a control point this census at a pen copy; without it the source is found
# by walking up from this script's own location, so the caller's working directory never matters.
if [ -n "${TOPOLOGY_SRC:-}" ]; then
  SRC="$TOPOLOGY_SRC"
else
  ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
  _steps=0
  while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
    _steps=$((_steps + 1))
    if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
      echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
      exit 2
    fi
    ROOT=$(dirname "$ROOT")
  done
  SRC="$ROOT/comlink/topology.rye"
fi

if [ ! -f "$SRC" ]; then
  echo "topology_metric_census: the topology source is missing at $SRC" >&2
  exit 2
fi

command -v awk >/dev/null 2>&1 || {
  echo "topology_metric_census: needs awk, and this host has none" >&2
  exit 2
}

G=$(awk -F'= *' '/^pub const galaxies_per_universe/ {gsub(/;.*/,"",$2); print $2; exit}' "$SRC")
S=$(awk -F'= *' '/^pub const stars_per_galaxy/     {gsub(/;.*/,"",$2); print $2; exit}' "$SRC")
P=$(awk -F'= *' '/^pub const planets_per_star/     {gsub(/;.*/,"",$2); print $2; exit}' "$SRC")
CG=$(awk '/^pub const council_sky/ {match($0,/\.galaxies = [0-9]+/); print substr($0,RSTART+12,RLENGTH-12); exit}' "$SRC")
CS=$(awk '/^pub const council_sky/ {match($0,/\.stars = [0-9]+/);    print substr($0,RSTART+9,RLENGTH-9);   exit}' "$SRC")
CP=$(awk '/^pub const council_sky/ {match($0,/\.planets = [0-9]+/);  print substr($0,RSTART+11,RLENGTH-11); exit}' "$SRC")

for v in G S P CG CS CP; do
  eval "val=\$$v"
  case "$val" in
    ''|*[!0-9]*)
      echo "topology_metric_census: could not read $v from $SRC -- refusing rather than assuming a geometry" >&2
      exit 2 ;;
  esac
done

echo "source $SRC"
echo "compass_sky galaxies=$G stars=$S planets=$P"
echo "council_sky galaxies=$CG stars=$CS planets=$CP"

# NOTE TO A FUTURE EDITOR: the awk program below is single-quoted, so an apostrophe anywhere
# inside it -- in a comment as readily as in a string -- ends the program. Its comments are
# written without them on purpose.
awk -v g1="$G" -v s1="$S" -v p1="$P" -v g2="$CG" -v s2="$CS" -v p2="$CP" '
# route_hops, as the module computes it: walk up to the deepest shared level and back down,
# or cross one honest bridge between galaxies.
function hops(a, b,   sh) {
  if (gal[a] != gal[b]) return d[a] + d[b] + 1
  sh = 0
  if (d[a] >= 1 && d[b] >= 1 && st[a] == st[b]) {
    sh = 1
    if (d[a] >= 2 && d[b] >= 2 && pl[a] == pl[b]) sh = 2
  }
  return (d[a] - sh) + (d[b] - sh)
}

# decode, as the module computes it: a point number to three coordinates and a depth.
function load(G, S, P,   SC, PC, n) {
  SC = G * S; PC = SC * P
  delete gal; delete st; delete pl; delete d
  for (n = 0; n < PC; n++) {
    gal[n] = n % G
    st[n]  = int((n % SC) / G)
    pl[n]  = int(n / SC)
    d[n]   = (n < G) ? 0 : ((n < SC) ? 1 : 2)
  }
  return PC
}

# One address built at an explicit tier, the way of_galaxy, of_star and of_planet build them.
function put(i, g, s, p, t) { gal[i] = g; st[i] = s; pl[i] = p; d[i] = t; return i }

function check(name, a, b, want,   got) {
  got = hops(a, b)
  if (got == want) { printf "  selftest_pair %s hops=%d ok\n", name, got; return 0 }
  printf "  selftest_pair %s hops=%d wanted=%d MISMATCH\n", name, got, want
  return 1
}

function agree(G, S, P,   bad, pt, sp, sib, cou, far) {
  bad = 0
  if (G * S == 60 && G * S * P == 720)
    printf "  derived_counts star_count=60 universe_points=720 ok\n"
  else {
    printf "  derived_counts star_count=%d universe_points=%d wanted=60,720 MISMATCH\n", G*S, G*S*P
    bad = 1
  }
  delete gal; delete st; delete pl; delete d
  pt  = put(1, 3, 2, 7, 2)   # Address.of_planet(3, 2, 7)
  sp  = put(2, 3, 2, 0, 1)   # its sponsor, Address.of_star(3, 2)
  sib = put(3, 3, 2, 9, 2)   # same star, different planet
  cou = put(4, 3, 4, 1, 2)   # same galaxy, different star
  far = put(5, 8, 0, 0, 2)   # of_planet(8, 0, 0) -- a galaxy wearing its planet outfit
  bad += check("self", pt, pt, 0)
  bad += check("planet_to_its_star", pt, sp, 1)
  bad += check("siblings", pt, sib, 2)
  bad += check("cousins", pt, cou, 4)
  bad += check("across_galaxies", pt, far, 5)
  return bad
}

function census(name, G, S, P,   PC, a, b, h, T, sum, H, p, k, maxh, cross, zero, consec) {
  PC = load(G, S, P)
  delete hist; delete v
  T = 0; sum = 0; maxh = 0; zero = 0
  for (a = 0; a < PC; a++) for (b = 0; b < PC; b++) {
    h = hops(a, b); hist[h]++; T++; sum += h
    if (h > maxh) maxh = h
    if (h == 0 && a != b) zero++
  }
  H = 0
  for (k in hist) { p = hist[k] / T; H -= p * log(p) / log(2) }
  cross = 0
  for (a = 0; a < PC; a++) for (b = 0; b < PC; b++) {
    if (d[a] != 2 || d[b] != 2) continue
    if (gal[a] != gal[b]) continue
    if (st[a] == st[b]) continue
    v[hops(a, b)]++; cross++
  }
  consec = 0
  for (a = 0; a < PC - 1; a++) if (hops(a, a + 1) == maxh) consec++
  printf "sky %s points=%d pairs=%d diameter=%d mean_hops=%.4f\n", name, PC, T, maxh, sum / T
  for (k = 0; k <= maxh; k++) if (k in hist)
    printf "  %s hops=%d pairs=%d share=%.4f\n", name, k, hist[k], hist[k] / T
  printf "  %s entropy_bits=%.4f ceiling_bits=%.4f distinct_hop_values=%d\n",
    name, H, log(length(hist)) / log(2), length(hist)
  printf "  %s cross_star_planet_pairs=%d distinct_hop_values_among_them=%d\n", name, cross, length(v)
  printf "  %s zero_hop_distinct=%d\n", name, zero
  printf "  %s consecutive_at_diameter=%d of %d share=%.4f\n", name, consec, PC - 1, consec / (PC - 1)
  return zero
}

BEGIN {
  faults = 0
  printf "model_agreement compass\n"
  faults += agree(g1, s1, p1)
  faults += census("compass", g1, s1, p1)
  faults += census("council", g2, s2, p2)
  printf "faults=%d\n", faults
  printf "verdict=%s\n", (faults == 0 ? "ok" : "instrument_or_alias_fault")
  exit (faults == 0 ? 0 : 1)
}'
