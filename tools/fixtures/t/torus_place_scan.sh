#!/bin/sh
# tools/fixtures/t/torus_place_scan.sh -- does the SECOND AXIS of a torus fold buy anything for
# PLACEMENT? The one question row 5 of active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md
# has left, and the one its elder names as the claim it does not touch.
#
# WHERE THIS PICKS UP. tools/fixtures/t/torus_fold_scan.sh read row 5's own falsifier and killed
# its adjacency half: a cryptographic digest avalanches, so two documents differing in one byte
# land as far apart as two strangers. That scan's header then names what it leaves open in plain
# words -- "whether a torus is a good PLACEMENT scheme, which is a different claim and is not
# touched here". The row's erratum kept the row alive on exactly that remainder: even shards at any
# grid, and a bounded four-neighbour replica set uniform at every cell.
#
# THE QUESTION THIS ASKS. Both halves of that remainder are compared against a RING of the same
# cell count -- one axis instead of two -- because a property a ring also has is not a property the
# second axis supplies. A torus buys its keep only where the ring cannot follow.
#
#   READING 1 -- EVENNESS, AGAINST A RING OF EQUAL CELL COUNT. The same digests are folded twice
#   onto C = g * g cells: the torus takes the high k bits of two digest bytes as (x, y) and stores
#   at y * g + x; the ring takes the high 2k bits of the leading byte pair as one index. Pearson
#   chi-squared is computed for each against the same expectation. A reading near df is even. If
#   both read even, evenness belongs to the digest rather than to either shape.
#
#   READING 2 -- TWO DIFFERENT FUNCTIONS, ONE EVENNESS. The torus fold and the ring fold read
#   DIFFERENT bits of the same digest, so they place a given name in different cells. How often
#   they agree is counted against the n/C agreements chance alone would give. The point of the
#   counter is the contrast with reading 1: two folds that disagree name by name read equally
#   even, which is what it looks like when evenness belongs to the digest rather than to a shape.
#
#   READING 3 -- THE REPLICA SET UNDER A CONTIGUOUS FAILURE RUN. Uniformity is where row 5's
#   remainder is weakest, and the reason is geometry rather than measurement: every vertex of a
#   torus has four neighbours and every vertex of a ring has two at distance one and four within
#   distance two, so BOTH are vertex-transitive and both give a replica set uniform at every cell.
#   What distinguishes a placement rule is where its replicas SIT in the linear storage order, so
#   this reading measures the shortest contiguous run of storage indices whose loss destroys every
#   copy of some cell. Four rules are compared on one C:
#
#     torus4     -- the grid's own neighbours, offsets {+1, -1, +g, -g}
#     ring4adj   -- a ring taking its nearest four, offsets {+1, -1, +2, -2}
#     ring4wide  -- a ring free to choose, offsets {+g, -g, +2g, -2g}
#     evenspread -- a ring spacing its five copies as evenly as the ring allows,
#                   offsets {round(C/5), round(2C/5), round(3C/5), round(4C/5)}
#
#   Each holds five copies and each is uniform at every cell. The run lengths are computed over
#   every cell rather than argued: 2g+1, 5, 4g+1, and C-ceil(C/5)+1 are what the arithmetic gives,
#   and a reading that disagrees with those closed forms is the finding rather than a rounding
#   error. `evenspread` is the fourth rule named in
#   active-designing/20260918-043308_evenly-spaced-offsets-close-opening-one.md: minimizing the
#   largest gap between five points on a ring of C cells beats every fixed-offset rule above it,
#   and an even split reaches the pigeonhole bound C-ceil(C/5)+1 exactly.
#
#   READING 4 -- EVENNESS UNDER GROWTH. The erratum's own recommendation: max-over-mean cell load
#   at four prefixes of the population, so a reader sees whether imbalance falls as names arrive.
#
# WHAT WOULD FALSIFY THE READING. Either fold reading far above its critical value would mean the
# digest clusters, which is the elder scan's own falsifier arriving again. A run-kill length for
# ring4wide at or below torus4's would mean the second axis genuinely supplies spread a line
# cannot. An imbalance that fails to fall with the population would mean the fold clusters under
# growth.
#
# WHAT THIS DOES NOT READ. Any real store -- this scan opens none. Whether a non-cryptographic key
# would carry locality, which is row 5's only surviving door and wants a key nobody has proposed.
# Whether contiguous-run loss is the failure model a given medium actually has; it is the model
# named here, and a different one wants its own reading.
#
# USAGE
#   sh tools/fixtures/t/torus_place_scan.sh                 # the reading
#   sh tools/fixtures/t/torus_place_scan.sh --grid G        # cells per axis (default derived)
#   sh tools/fixtures/t/torus_place_scan.sh --names N       # lower the sample bound
#   sh tools/fixtures/t/torus_place_scan.sh --paths F       # read the name list from F
#   sh tools/fixtures/t/torus_place_scan.sh --digests D     # read digests directly, no hashing
#
# THE DIGEST DOOR IS THE CONTROL PATH, as it is for the elder scan: a clustered population of real
# names would have to be mined, and the point is to prove the READING. --digests takes one
# 128-character lowercase hex digest per line.
#
# Run from anywhere; this script finds the tree from its own location.

set -eu

MAX_NAMES=512      # bounded: each name costs one SHA3-512 over a whole file
MIN_NAMES=8        # below this no reading is taken at all
MIN_PER_CELL=5     # Pearson wants about this many expected per cell
GRID=0             # 0 means derive from the sample size
MAX_GRID=16        # bounded: the largest grid this scan will choose for itself
Z_CRITICAL=30902   # 3.0902 in ten-thousandths -- the p=0.001 one-sided normal deviate

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

PATHS_FILE=""
DIGESTS_FILE=""
while [ $# -gt 0 ]; do
  case "$1" in
    --paths) PATHS_FILE="${2:?--paths wants a file}"; shift 2 ;;
    --digests) DIGESTS_FILE="${2:?--digests wants a file}"; shift 2 ;;
    --names) MAX_NAMES="${2:?--names wants a count}"; shift 2 ;;
    --grid) GRID="${2:?--grid wants a count}"; shift 2 ;;
    *) echo "$0: unknown flag $1" >&2; exit 2 ;;
  esac
done

echo "instrument=torus_place"

PEN=$(mktemp -d)
trap 'rm -rf "$PEN"' EXIT INT TERM

if [ -n "$DIGESTS_FILE" ]; then
  [ -f "$DIGESTS_FILE" ] || { echo "$0: no such digests file: $DIGESTS_FILE" >&2; exit 2; }
  awk 'NF { print $1 }' "$DIGESTS_FILE" > "$PEN/names"
  SOURCE=digests_file
else
  DIGEST="$ROOT/crypto/bin/sha3-digest"
  if [ ! -x "$DIGEST" ]; then
    # The shim builds it from crypto/sha3_digest.rye on first call; one file owns that build.
    sh "$ROOT/tools/fixtures/s/sha3.sh" 512 "$ROOT/README.md" >/dev/null 2>&1 || true
  fi
  if [ ! -x "$DIGEST" ]; then
    echo "detail: no SHA3-512 digest binary -- run: sh tools/fixtures/s/sha3.sh 512 README.md"
    echo "verdict=unreadable"
    exit 0
  fi
  if [ -n "$PATHS_FILE" ]; then
    [ -f "$PATHS_FILE" ] || { echo "$0: no such paths file: $PATHS_FILE" >&2; exit 2; }
    cp "$PATHS_FILE" "$PEN/all"
    SOURCE=file
  else
    ( cd "$ROOT" && git ls-files ) > "$PEN/all"
    SOURCE=git_ls_files
  fi
  TRACKED=$(wc -l < "$PEN/all" | tr -d ' ')
  [ "$TRACKED" -gt 0 ] || { echo "detail: empty population"; echo "verdict=unreadable"; exit 0; }
  STRIDE=$(( TRACKED / MAX_NAMES ))
  [ "$STRIDE" -ge 1 ] || STRIDE=1
  awk -v s="$STRIDE" -v m="$MAX_NAMES" 'NR % s == 1 || s == 1 { if (k++ < m) print }' "$PEN/all" > "$PEN/sample"
  : > "$PEN/names"
  while IFS= read -r p; do
    [ -f "$ROOT/$p" ] || continue
    h=$("$DIGEST" 512 "$ROOT/$p") || continue
    [ ${#h} -eq 128 ] || continue
    printf '%s\n' "$h" >> "$PEN/names"
  done < "$PEN/sample"
fi

NAMES=$(wc -l < "$PEN/names" | tr -d ' ')
echo "source=$SOURCE"
echo "names=$NAMES"
if [ "$NAMES" -lt "$MIN_NAMES" ]; then
  echo "detail: $NAMES names is too few to read"
  echo "verdict=unreadable"
  exit 0
fi

# The grid is chosen from the sample size rather than fixed, so Pearson's approximation holds:
# the largest power-of-two g at or under MAX_GRID keeping names/(g*g) at or above MIN_PER_CELL.
if [ "$GRID" -eq 0 ]; then
  GRID=2
  g=4
  while [ "$g" -le "$MAX_GRID" ]; do
    if [ $(( NAMES / (g * g) )) -ge "$MIN_PER_CELL" ]; then GRID=$g; fi
    g=$(( g * 2 ))
  done
fi
CELLS=$(( GRID * GRID ))
echo "grid=$GRID"
echo "cells=$CELLS"

awk -v g="$GRID" -v z="$Z_CRITICAL" '
  function hexval(c) { return index("0123456789abcdef", tolower(c)) - 1 }
  function byte(s, i) { return hexval(substr(s, i * 2 + 1, 1)) * 16 + hexval(substr(s, i * 2 + 2, 1)) }
  # Wilson-Hilferty: the p=0.001 upper critical value of chi-squared at df degrees of freedom,
  # derived rather than read from a table, since the grid is chosen from the sample.
  function critical(df,   a, b) {
    a = 1 - 2 / (9 * df)
    b = (z / 10000) * sqrt(2 / (9 * df))
    return df * (a + b) ^ 3
  }
  {
    n++
    b0 = byte($1, 0); b1 = byte($1, 1)
    x = int(b0 / (256 / g)); y = int(b1 / (256 / g))
    tc = y * g + x                                       # torus cell, row-major storage index
    rc = int((b0 * 256 + b1) / (65536 / (g * g)))        # ring cell from the same leading pair
    if (rc == tc) same++                                 # two different functions agreeing
    torus[tc]++; ring[rc]++
    order[n] = tc
  }
  END {
    cells = g * g
    df = cells - 1
    e = n / cells
    for (i = 0; i < cells; i++) {
      d = torus[i] - e; ct += d * d / e
      d = ring[i] - e;  cr += d * d / e
    }
    crit = critical(df)
    printf "folds_agree=%d\n", same
    printf "folds_agree_expected=%.2f\n", n / cells
    printf "chi_df=%d\n", df
    printf "chi_critical=%.2f\n", crit
    printf "chi_torus=%.2f\n", ct
    printf "chi_ring=%.2f\n", cr
    printf "torus_even=%s\n", (ct <= crit ? "yes" : "no")
    printf "ring_even=%s\n", (cr <= crit ? "yes" : "no")
    # Reading 4 -- imbalance at four growth prefixes of the same arrival order.
    split("", load)
    q = int(n / 4); if (q < 1) q = 1
    step = 1
    for (i = 1; i <= n; i++) {
      load[order[i]]++
      if (i == q * step && step <= 4) {
        mx = 0
        for (c = 0; c < cells; c++) if (load[c] > mx) mx = load[c]
        printf "growth_prefix_%d names=%d imbalance=%.3f\n", step, i, mx / (i / cells)
        step++
      }
    }
  }
' "$PEN/names" > "$PEN/out"

# Reading 3 -- the contiguous run that destroys every copy of some cell, computed over every cell
# for four placement rules on one cell count. Each rule holds five copies and is uniform.
awk -v g="$GRID" '
  function runkill(rule,   c, x, y, i, lo, hi, best, o, idx, span, off) {
    best = -1
    cells = g * g
    for (c = 0; c < cells; c++) {
      x = c % g; y = int(c / g)
      delete at
      at[0] = c
      if (rule == "torus4") {
        at[1] = y * g + (x + 1) % g
        at[2] = y * g + (x - 1 + g) % g
        at[3] = ((y + 1) % g) * g + x
        at[4] = ((y - 1 + g) % g) * g + x
      } else if (rule == "ring4adj") {
        at[1] = (c + 1) % cells; at[2] = (c - 1 + cells) % cells
        at[3] = (c + 2) % cells; at[4] = (c - 2 + cells) % cells
      } else if (rule == "ring4wide") {
        at[1] = (c + g) % cells;     at[2] = (c - g + cells) % cells
        at[3] = (c + 2 * g) % cells; at[4] = (c - 2 * g + cells) % cells
      } else {
        # evenspread: five offsets (including 0) spaced at round(i*cells/5), i = 0..4.
        for (i = 1; i <= 4; i++) {
          off = int(i * cells / 5 + 0.5)
          at[i] = (c + off) % cells
        }
      }
      # The shortest circular run covering all five copies is the cell count minus the widest
      # gap between consecutive copies in index order.
      n = 0
      for (i = 0; i < 5; i++) v[n++] = at[i]
      for (i = 1; i < n; i++) { key = v[i]; j = i - 1; while (j >= 0 && v[j] > key) { v[j+1] = v[j]; j-- } v[j+1] = key }
      widest = v[0] + cells - v[n-1]
      for (i = 1; i < n; i++) { gap = v[i] - v[i-1]; if (gap > widest) widest = gap }
      span = cells - widest + 1
      if (best < 0 || span < best) best = span
    }
    return best
  }
  END {
    printf "runkill_torus4=%d\n", runkill("torus4")
    printf "runkill_ring4adj=%d\n", runkill("ring4adj")
    printf "runkill_ring4wide=%d\n", runkill("ring4wide")
    printf "runkill_evenspread=%d\n", runkill("evenspread")
    # A closed form holds only where the five copies of a rule are DISTINCT cells. Below those
    # grids the offsets alias around the ring and the measured length is the truth; saying so is
    # the difference between a precondition and a refusal.
    printf "runkill_torus4_closed=%s\n",    (g >= 3 ? sprintf("%d", 2 * g + 1) : "na")
    printf "runkill_ring4adj_closed=%s\n",  (g * g >= 5 ? "5" : "na")
    printf "runkill_ring4wide_closed=%s\n", (4 * g < g * g ? sprintf("%d", 4 * g + 1) : "na")
    # the evenspread pigeonhole bound: the largest of five gaps summing to C is at least ceil(C/5),
    # and an even split reaches it exactly (active-designing/20260918-043308, checked at four
    # (C,k) pairs beyond this one by brute force over every offset subset).
    cc = g * g
    printf "runkill_evenspread_closed=%s\n", (cc >= 5 ? sprintf("%d", cc - int((cc + 4) / 5) + 1) : "na")
  }
' < /dev/null >> "$PEN/out"

cat "$PEN/out"

# --- the verdict --------------------------------------------------------------------------------
# GATED: the instrument's own arithmetic. Each measured run-kill length must equal the closed form
# its rule gives, both folds must read even, and imbalance must fall as the population grows. The
# COMPARISON between the rules is reported rather than gated, since it is a fact about geometry
# that no lap can repair.
read_field() { awk -v k="$1" -F= '$1 == k { print $2 }' "$PEN/out"; }

closed_ok=yes
for rule in torus4 ring4adj ring4wide evenspread; do
  m=$(read_field "runkill_$rule")
  c=$(read_field "runkill_${rule}_closed")
  [ "$c" = "na" ] && continue
  [ "$m" = "$c" ] || closed_ok=no
done
echo "runkill_closed_forms_hold=$closed_ok"

even_ok=no
if [ "$(read_field torus_even)" = "yes" ] && [ "$(read_field ring_even)" = "yes" ]; then even_ok=yes; fi

first=$(awk '/^growth_prefix_1 /{ for (i=1;i<=NF;i++) if ($i ~ /^imbalance=/) { sub(/imbalance=/, "", $i); print $i } }' "$PEN/out")
last=$(awk '/^growth_prefix_4 /{ for (i=1;i<=NF;i++) if ($i ~ /^imbalance=/) { sub(/imbalance=/, "", $i); print $i } }' "$PEN/out")
fell=$(awk -v a="$first" -v b="$last" 'BEGIN { print (b <= a) ? "yes" : "no" }')
echo "imbalance_fell=$fell"

tw=$(read_field runkill_torus4)
rw=$(read_field runkill_ring4wide)
if [ "$rw" -gt "$tw" ]; then
  echo "second_axis_buys_spread=no"
else
  echo "second_axis_buys_spread=yes"
fi

if [ "$closed_ok" = yes ] && [ "$even_ok" = yes ] && [ "$fell" = yes ]; then
  echo "verdict=ok"
else
  echo "verdict=refused"
fi
