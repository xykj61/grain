#!/bin/sh
# tools/fixtures/t/tlb_reach_census.sh -- how many pages a hot table may span before every
# lookup pays for translation, measured against a control that holds everything else equal.
#
# WHY. The elder study in this tree measured a table's cost against its FOOTPRINT and named the
# boundary worth designing to: external-research/20260906-042838_the-table-that-fits.md reads
# 1.65 ns for a dependent load inside L1d against 161.84 ns from 64 MiB. That reading is sound
# and it is one axis. A load's address is translated before any cache is asked, translations are
# cached in a structure with a capacity of its own, and that capacity is counted in PAGES rather
# than bytes -- so a table can fit the first cache exactly and still miss on every access. This
# census measures the second boundary and reports it as a page count a designer can act on.
#
# WHAT IT PRINTS.
#
#   topology    -- page size and cache line size, read from the kernel's own report.
#   readings    -- ns per dependent read for each layout at each page count, and their ratio.
#   knee        -- the page count where the ratio steps, bracketed between two adjacent counts.
#   huge        -- the same curve on 2 MiB pages: the falsifier, run rather than named.
#   budgets     -- table entries that fit inside the measured reach, at four entry sizes.
#
# THE CONTROL IS THE INSTRUMENT. Two walks touch the same number of cache lines, in the same
# order, with the same dependent-load instruction stream, differing only in how many pages those
# lines occupy -- packed puts 64 lines on a page, spread puts one. `pair_matched` proves the
# touched-byte counts are equal at every point, and `flat_below_knee` proves the two layouts read
# the same before any translation structure could be exceeded. A pair that differs there is a
# pair with a confound, and every ratio built on it would be worthless.
#
# THE FALSIFIER IS A LEG RATHER THAN A SENTENCE. If the step is translation, then handing the
# same walk 2 MiB pages must remove it. `huge_collapses` runs that walk and requires two things:
# the ratio at the knee returns to one, AND the kernel actually granted huge pages, read back
# from the probe's own /proc/self/smaps_rollup. A plant that did not run is not evidence -- this
# tree published a control one lap earlier whose plant silently failed to build and reported
# itself proven, and that is the shape this leg exists to refuse.
#
# THE SEVEN LEGS, each able to refuse by name:
#
#   page_size_bind    -- the probe counts pages using a page size the kernel must confirm.
#                        A probe assuming 4096 on a 16 KiB-page part counts pages wrong and
#                        every claim about reach is off by four.
#   line_size_bind    -- the probe compiled one node per cache line, using a line size the
#                        kernel must confirm. A wrong line size puts two nodes on a line and
#                        halves the working set under the name of the full one.
#   pair_matched      -- both layouts touch the same bytes at every point, or they are not a pair.
#   spread_differs    -- spread must occupy one page per node and packed far fewer, or there is
#                        no translation pressure to measure and the whole census is a tautology.
#   flat_below_knee   -- below the knee the two layouts must read alike. This is what makes the
#                        pair a control rather than two unrelated walks.
#   knee_located      -- the ratio must step from at or under 1.20 to at or over 2.00 across one
#                        adjacent pair, which is what locates the reach. No step, no reading.
#   huge_collapses    -- 2 MiB pages must remove the step, and must be proven to have arrived.
#
# Instrument: `sh` and `awk`, POSIX-granted, plus this tree's own vendored Zig toolchain to build
# the probe. The pen is a fixed name under the host temporary directory, removed on exit; no
# `mktemp`, which is not POSIX and has not been since 2008.
#
# Usage:
#   sh tools/fixtures/t/tlb_reach_census.sh                       # build, run both legs, report
#   sh tools/fixtures/t/tlb_reach_census.sh --from F --huge-from G # check saved readings
#   sh tools/fixtures/t/tlb_reach_census.sh --sysfs DIR           # read topology elsewhere
#   sh tools/fixtures/t/tlb_reach_census.sh --page-size N         # state the page size directly
#   sh tools/fixtures/t/tlb_reach_census.sh --build-only          # build the probe, run nothing
#
# WHY --build-only EXISTS. This census is unrostered on purpose: it measures a property of the
# BOARD rather than of the tree, so a guard running it would red on the day the pier changes, and
# a guard that reds on ordinary work is a guard someone turns off. Yet leaving it unrostered would
# leave `tlb_reach_probe.rye` among the authored Rye that nothing ever compiles -- the class REDS
# %449 and %463 measured on 20260906, where a module had not compiled since the toolchain moved
# while four guards read it every lap with grep. So the witness builds the probe through this flag
# and stops, which costs about nineteen seconds and catches exactly that rot.
#
# Read against: external-research/20260906-061229_the-address-that-does-not-fit.md
# Refusals proven by: tools/fixtures/t/tlb_reach_control.sh
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

PROBE_SRC="$ROOT/tools/fixtures/t/tlb_reach_probe.rye"
SYSFS="/sys/devices/system/cpu/cpu0/cache"
FROM=""
HUGE_FROM=""
PAGE_SIZE=""
BUILD_ONLY=no

while [ $# -gt 0 ]; do
  case "$1" in
    --from)       FROM="${2:-}"; shift 2 ;;
    --huge-from)  HUGE_FROM="${2:-}"; shift 2 ;;
    --sysfs)      SYSFS="${2:-}"; shift 2 ;;
    --page-size)  PAGE_SIZE="${2:-}"; shift 2 ;;
    --build-only) BUILD_ONLY=yes; shift ;;
    *) echo "refused: unknown argument '$1'" >&2; exit 2 ;;
  esac
done

# ---- build only, for the witness -------------------------------------------------------------
# Placed ahead of the topology read on purpose: whether this probe COMPILES is a question about
# the tree, and it must stay answerable on a board whose cache topology this census cannot read.
if [ "$BUILD_ONLY" = yes ]; then
  ZIG="$ROOT/vendor/zig-toolchain/zig"
  RYE="$ROOT/rye/bin/rye"
  [ -x "$ZIG" ] || { echo "refused: no vendored Zig toolchain at $ZIG -- run tools/fixtures/f/fetch_toolchain_scan.sh" >&2; exit 2; }
  [ -x "$RYE" ] || { echo "refused: no rye driver at $RYE" >&2; exit 2; }
  [ -f "$PROBE_SRC" ] || { echo "refused: no probe source at $PROBE_SRC" >&2; exit 2; }
  BPEN="${TMPDIR:-/tmp}/tlb_reach_build_pen"
  rm -rf "$BPEN"; mkdir -p "$BPEN"
  cp "$PROBE_SRC" "$BPEN/probe.rye"
  if ( cd "$BPEN" && RYE_ZIG="$ZIG" "$RYE" build probe.rye -OReleaseFast --cache-dir "$BPEN/cache" ) >"$BPEN/build.log" 2>&1; then
    if [ -x "$BPEN/probe" ]; then
      echo "build_only green $PROBE_SRC"
      rm -rf "$BPEN"
      exit 0
    fi
    echo "build_only RED reason=no_binary"
    echo "refused: the probe compiled and produced no binary" >&2
    rm -rf "$BPEN"
    exit 1
  fi
  echo "build_only RED reason=compile_failed"
  echo "refused: the probe did not build -- see $BPEN/build.log" >&2
  exit 1
fi

# ---- topology, from the kernel's own report -------------------------------------------------
# Read rather than assumed. A census that hardcodes a page size is a census that agrees with
# itself on a machine it has never met -- and page size is exactly the constant that varies:
# 4 KiB on this board, 16 KiB on an Apple arm64, and either on a Linux arm64.
if [ -z "$PAGE_SIZE" ]; then
  PAGE_SIZE=$(getconf PAGESIZE 2>/dev/null || getconf PAGE_SIZE 2>/dev/null || echo 0)
fi
case "$PAGE_SIZE" in
  ''|*[!0-9]*) PAGE_SIZE=0 ;;
esac

line_bytes_sys=0
l1d_kib=0
[ -d "$SYSFS" ] || { echo "refused: no cache topology at $SYSFS -- this census cannot say where the caches are" >&2; exit 2; }
for idx in "$SYSFS"/index*; do
  [ -d "$idx" ] || continue
  lvl=$(cat "$idx/level" 2>/dev/null || echo 0)
  typ=$(cat "$idx/type" 2>/dev/null || echo unknown)
  siz=$(cat "$idx/size" 2>/dev/null || echo 0K)
  lin=$(cat "$idx/coherency_line_size" 2>/dev/null || echo 0)
  kib=$(echo "$siz" | awk '{ v=$0; sub(/[Kk]$/,"",v); if (v ~ /[Mm]$/) { sub(/[Mm]$/,"",v); v = v * 1024 } print v+0 }')
  [ "$lin" -gt 0 ] 2>/dev/null && line_bytes_sys=$lin
  case "$lvl:$typ" in
    1:Data) l1d_kib=$kib ;;
  esac
done

echo "topology_source $SYSFS"
echo "page_bytes_sys $PAGE_SIZE"
echo "line_bytes_sys $line_bytes_sys"
echo "l1d_kib $l1d_kib"

if [ "$PAGE_SIZE" -le 0 ] || [ "$line_bytes_sys" -le 0 ] || [ "$l1d_kib" -le 0 ]; then
  echo "refused: the host reported no usable topology (page=$PAGE_SIZE line=$line_bytes_sys l1d=$l1d_kib)" >&2
  exit 1
fi

# ---- the readings ---------------------------------------------------------------------------
PEN="${TMPDIR:-/tmp}/tlb_reach_census_pen"
PLAIN="$PEN/plain.txt"
HUGE="$PEN/huge.txt"

if [ -n "$FROM" ] || [ -n "$HUGE_FROM" ]; then
  [ -n "$FROM" ] && [ -n "$HUGE_FROM" ] || {
    echo "refused: --from and --huge-from come as a pair; one alone leaves the falsifier unread" >&2; exit 2; }
  [ -f "$FROM" ] || { echo "refused: no reading at $FROM" >&2; exit 2; }
  [ -f "$HUGE_FROM" ] || { echo "refused: no huge-page reading at $HUGE_FROM" >&2; exit 2; }
  rm -rf "$PEN"; mkdir -p "$PEN"
  cat "$FROM" > "$PLAIN"
  cat "$HUGE_FROM" > "$HUGE"
  echo "reading_source $FROM"
else
  ZIG="$ROOT/vendor/zig-toolchain/zig"
  RYE="$ROOT/rye/bin/rye"
  [ -x "$ZIG" ] || { echo "refused: no vendored Zig toolchain at $ZIG -- run tools/fixtures/f/fetch_toolchain_scan.sh" >&2; exit 2; }
  [ -x "$RYE" ] || { echo "refused: no rye driver at $RYE" >&2; exit 2; }
  [ -f "$PROBE_SRC" ] || { echo "refused: no probe source at $PROBE_SRC" >&2; exit 2; }
  rm -rf "$PEN"; mkdir -p "$PEN"
  cp "$PROBE_SRC" "$PEN/probe.rye"
  ( cd "$PEN" && RYE_ZIG="$ZIG" "$RYE" build probe.rye -OReleaseFast --cache-dir "$PEN/cache" ) >"$PEN/build.log" 2>&1 || {
    echo "refused: the probe did not build -- see $PEN/build.log" >&2; exit 1; }
  [ -x "$PEN/probe" ] || { echo "refused: the probe built no binary" >&2; exit 1; }
  # Two processes on purpose, rather than two legs in one. MADV_HUGEPAGE steers a page FAULT, so
  # a region already faulted in small pages is not promoted by asking afterwards -- the advice
  # has to precede the arena's first touch, and the only way to have two first touches is to
  # have two processes.
  "$PEN/probe" > "$PLAIN" 2>&1 || { echo "refused: the probe did not run to completion" >&2; exit 1; }
  "$PEN/probe" --huge > "$HUGE" 2>&1 || { echo "refused: the huge-page probe did not run to completion" >&2; exit 1; }
  echo "reading_source probe_on_metal"
fi

for f in "$PLAIN" "$HUGE"; do
  grep -q '^probe_done$' "$f" || { echo "refused: a reading is truncated -- no probe_done line in $f" >&2; exit 1; }
  if grep -q '^refused ' "$f"; then
    echo "refused: the probe refused its own chase -- $(grep -m1 '^refused ' "$f")" >&2
    exit 1
  fi
done

page_bytes_probe=$(awk '$1=="page_bytes"{print $2; exit}' "$PLAIN")
line_bytes_probe=$(awk '$1=="line_bytes"{print $2; exit}' "$PLAIN")
exact_max=$(awk '$1=="exact_pair_max_nodes"{print $2; exit}' "$PLAIN")
anon_huge_kib=$(awk '$1=="anon_huge_kib"{print $2; exit}' "$HUGE")
huge_advised=$(awk '$1=="huge_advised"{print $2; exit}' "$HUGE")
: "${page_bytes_probe:=0}"; : "${line_bytes_probe:=0}"; : "${exact_max:=0}"
: "${anon_huge_kib:=0}"; : "${huge_advised:=no}"

echo "page_bytes_probe $page_bytes_probe"
echo "line_bytes_probe $line_bytes_probe"
echo "exact_pair_max_nodes $exact_max"
echo "huge_advised $huge_advised"
echo "anon_huge_kib $anon_huge_kib"

# ---- the curve, both legs, as one table ------------------------------------------------------
# Ratios are printed in hundredths throughout, so no leg needs floating point and every
# comparison below is integer arithmetic on the same units the probe already published.
curve() {
  awk -v want="$1" '
    /^reading /{
      layout=""; n=""; pages=""; touched=""; ns=""
      for (i = 2; i <= NF; i++) {
        split($i, kv, "=")
        if (kv[1] == "layout")       layout = kv[2]
        else if (kv[1] == "n")       n      = kv[2]
        else if (kv[1] == "pages")   pages  = kv[2]
        else if (kv[1] == "touched_bytes") touched = kv[2]
        else if (kv[1] == "ns_hundredths") ns = kv[2]
      }
      if (layout == "packed") { P[n]=ns; PP[n]=pages; PT[n]=touched; if (!(n in seen)) { seen[n]=1; order[++c]=n } }
      else if (layout == "spread") { S[n]=ns; SP[n]=pages; ST[n]=touched; if (!(n in seen)) { seen[n]=1; order[++c]=n } }
    }
    END {
      for (i = 1; i <= c; i++) {
        n = order[i]
        if (!(n in P) || !(n in S)) continue
        ratio = (P[n] > 0) ? int(S[n] * 100 / P[n]) : 0
        printf "%s %s %s %s %s %s %s %s %s\n", want, n, PP[n], SP[n], PT[n], ST[n], P[n], S[n], ratio
      }
    }' "$2"
}

curve plain "$PLAIN" > "$PEN/curve_plain.txt"
curve huge  "$HUGE"  > "$PEN/curve_huge.txt"

points=$(wc -l < "$PEN/curve_plain.txt" | tr -d ' ')
echo "points $points"
[ "$points" -ge 6 ] || { echo "refused: $points points is too few to locate a step" >&2; exit 1; }

while read -r leg n pp sp pt st pns sns ratio; do
  echo "curve leg=$leg pages_packed=$pp pages_spread=$sp touched=$st packed_hundredths=$pns spread_hundredths=$sns ratio_hundredths=$ratio nodes=$n"
done < "$PEN/curve_plain.txt"

# ---- leg 1: page_size_bind -------------------------------------------------------------------
if [ "$page_bytes_probe" -ne "$PAGE_SIZE" ]; then
  echo "page_size_bind RED probe=$page_bytes_probe host=$PAGE_SIZE"
  echo "refused: the probe counts pages of $page_bytes_probe bytes and this host hands out $PAGE_SIZE -- every reach in pages is wrong by their ratio" >&2
  exit 1
fi
echo "page_size_bind green $PAGE_SIZE"

# ---- leg 2: line_size_bind -------------------------------------------------------------------
if [ "$line_bytes_probe" -ne "$line_bytes_sys" ]; then
  echo "line_size_bind RED probe=$line_bytes_probe kernel=$line_bytes_sys"
  echo "refused: the probe placed one node per $line_bytes_probe bytes and the kernel reports a $line_bytes_sys-byte line" >&2
  exit 1
fi
echo "line_size_bind green $line_bytes_sys"

# ---- leg 3: pair_matched ---------------------------------------------------------------------
mismatch=$(awk '$5 != $6 { print $2; exit }' "$PEN/curve_plain.txt" || true)
if [ -n "$mismatch" ]; then
  echo "pair_matched RED at_nodes=$mismatch"
  echo "refused: at $mismatch nodes the two layouts touch different byte counts -- they are not a pair and every ratio here is meaningless" >&2
  exit 1
fi
echo "pair_matched green"

# ---- leg 4: spread_differs -------------------------------------------------------------------
# One page per node in the spread layout, and strictly fewer in the packed one. Without both
# there is no translation pressure to measure and the census would be reporting a tautology.
bad_spread=$(awk '$4 != $2 { print $2; exit }' "$PEN/curve_plain.txt" || true)
if [ -n "$bad_spread" ]; then
  echo "spread_differs RED at_nodes=$bad_spread reason=spread_not_one_page_per_node"
  echo "refused: at $bad_spread nodes the spread layout does not occupy one page per node" >&2
  exit 1
fi
bad_packed=$(awk '$2 >= 128 && $3 >= $4 { print $2; exit }' "$PEN/curve_plain.txt" || true)
if [ -n "$bad_packed" ]; then
  echo "spread_differs RED at_nodes=$bad_packed reason=packed_spans_as_many_pages"
  echo "refused: at $bad_packed nodes the packed layout spans as many pages as the spread one, so the pair varies nothing" >&2
  exit 1
fi
echo "spread_differs green"

# ---- leg 5 and 6: flat_below_knee, knee_located -----------------------------------------------
# The knee is the first adjacent pair where the ratio crosses from at or under 1.20 to at or over
# 2.00. Everything before it must be flat, which is the property that makes the pair a control.
knee=$(awk '
  { n[++c] = $2; r[c] = $9 }
  END {
    for (i = 2; i <= c; i++) {
      if (r[i-1] <= 120 && r[i] >= 200) { print n[i-1], n[i], r[i-1], r[i]; exit }
    }
  }' "$PEN/curve_plain.txt")

if [ -z "$knee" ]; then
  echo "knee_located RED reason=no_step"
  echo "refused: no adjacent pair steps from at or under 1.20 to at or over 2.00 -- this curve locates no translation boundary" >&2
  exit 1
fi
reach_pages=$(echo "$knee" | cut -d' ' -f1)
broke_at=$(echo "$knee" | cut -d' ' -f2)
ratio_before=$(echo "$knee" | cut -d' ' -f3)
ratio_after=$(echo "$knee" | cut -d' ' -f4)

flat_worst=$(awk -v knee="$reach_pages" '
  $2 <= knee { d = $9 - 100; if (d < 0) d = -d; if (d > worst) { worst = d; at = $2 } }
  END { print worst+0, at+0 }' "$PEN/curve_plain.txt")
flat_pct=$(echo "$flat_worst" | cut -d' ' -f1)
flat_at=$(echo "$flat_worst" | cut -d' ' -f2)
if [ "$flat_pct" -gt 20 ]; then
  echo "flat_below_knee RED worst_pct=$flat_pct at_nodes=$flat_at"
  echo "refused: below the knee the layouts differ by $flat_pct percent at $flat_at nodes -- the pair carries a confound, so the step above it measures something else too" >&2
  exit 1
fi
echo "flat_below_knee green worst_pct=$flat_pct"
echo "knee_located green reach_pages=$reach_pages broke_at=$broke_at ratio_before_hundredths=$ratio_before ratio_after_hundredths=$ratio_after"

# ---- leg 7: huge_collapses, the falsifier run ------------------------------------------------
# Two conditions, and the second is the one a hurried version would omit: the huge pages must be
# proven to have ARRIVED. A leg reporting the request rather than the grant is an instrument
# testifying about its own intention.
if [ "$huge_advised" != "yes" ]; then
  echo "huge_collapses RED reason=advice_refused"
  echo "refused: the kernel refused MADV_HUGEPAGE, so the falsifier did not run and proves nothing" >&2
  exit 1
fi
if [ "$anon_huge_kib" -le 0 ]; then
  echo "huge_collapses RED reason=no_huge_pages_granted anon_huge_kib=$anon_huge_kib"
  echo "refused: the advice was accepted and no huge page arrived (/proc/self/smaps_rollup reads $anon_huge_kib kB) -- a plant that did not run is not evidence" >&2
  exit 1
fi
huge_ratio=$(awk -v at="$broke_at" '$2 == at { print $9; exit }' "$PEN/curve_huge.txt")
: "${huge_ratio:=0}"
if [ "$huge_ratio" -le 0 ]; then
  echo "huge_collapses RED reason=no_reading at_nodes=$broke_at"
  echo "refused: the huge-page leg has no reading at $broke_at nodes, where the small-page leg stepped" >&2
  exit 1
fi
if [ "$huge_ratio" -gt 150 ]; then
  echo "huge_collapses RED at_nodes=$broke_at huge_ratio_hundredths=$huge_ratio small_ratio_hundredths=$ratio_after"
  echo "refused: 2 MiB pages left a ratio of $huge_ratio hundredths where small pages read $ratio_after -- the step is not translation, or not only translation" >&2
  exit 1
fi
echo "huge_collapses green at_nodes=$broke_at huge_ratio_hundredths=$huge_ratio small_ratio_hundredths=$ratio_after anon_huge_kib=$anon_huge_kib"

# ---- what a designer can act on ---------------------------------------------------------------
# The reach in bytes of ADDRESS SPAN, and how many entries fit inside it -- which is the number
# the elder study's footprint bound does not contain, because span and size are not the same
# quantity the moment a structure is allocated in pieces.
reach_bytes=$((reach_pages * PAGE_SIZE))
echo "reach_pages $reach_pages"
echo "reach_span_bytes $reach_bytes"
for entry in 4 8 16 64; do
  echo "budget entry_bytes=$entry entries_within_reach=$((reach_bytes / entry))"
done

# ---- leg 8: elder_arm_ran, and the attribution it carries -------------------------------------
#
# WHY THIS IS A LEG RATHER THAN ONLY A REPORT. The elder arm is the one piece of this census that
# speaks about ANOTHER paper's published sentence, and an arm that silently did not run would print
# no attribution lines at all -- which reads exactly like an arm that ran and found nothing. That is
# the green-because-it-cannot-see shape this tree keeps booking, so presence is gated even though
# the magnitudes below are only reported.
#
# WHY THE MAGNITUDES ARE NOT GATED. They belong to this board. A part with a larger second-level
# data TLB, or one where the kernel hands out 1 GiB pages, would answer differently and would not be
# wrong. What the legs above gate is the PROPERTY -- a step exists, and large pages remove it. What
# this reports is HOW MUCH, here, today, so a reader can size the effect rather than take it on
# faith.
elder_small=$(grep -c '^elder ' "$PLAIN" || true)
elder_huge=$(grep -c '^elder ' "$HUGE" || true)
if [ "$elder_small" -lt 2 ] || [ "$elder_huge" -lt 2 ]; then
  echo "elder_arm_ran RED small_readings=$elder_small huge_readings=$elder_huge"
  echo "refused: the elder arm did not run in both legs, so its attribution would be silence wearing agreement" >&2
  exit 1
fi
if [ "$elder_small" -ne "$elder_huge" ]; then
  echo "elder_arm_ran RED small_readings=$elder_small huge_readings=$elder_huge (unequal)"
  echo "refused: the elder arm read a different number of sizes in each leg, so the pairs below would not be pairs" >&2
  exit 1
fi
echo "elder_arm_ran green readings=$elder_small"

# The elder study measured a DENSE walk against working-set size and published: "Crossing the L3
# boundary, from 4 MiB to 32 MiB, costs 7.87x." That sweep moved bytes and pages together. These
# lines move only the page size, so each ratio is the share of that cost which is translation.
awk '
  FNR==NR { if ($1 == "elder") { for (i = 2; i <= NF; i++) { split($i, kv, "="); f[kv[1]] = kv[2] }
            small[f["kib"] + 0] = f["ns_hundredths"] + 0; pages[f["kib"] + 0] = f["pages"] + 0 }; next }
  { if ($1 == "elder") { for (i = 2; i <= NF; i++) { split($i, kv, "="); g[kv[1]] = kv[2] }
      huge[g["kib"] + 0] = g["ns_hundredths"] + 0 } }
  END {
    n = 0
    for (k in small) if (k in huge) { n++; keys[n] = k + 0 }
    for (i = 1; i < n; i++) for (j = i + 1; j <= n; j++) if (keys[j] < keys[i]) { t = keys[i]; keys[i] = keys[j]; keys[j] = t }
    for (i = 1; i <= n; i++) {
      k = keys[i]
      r = (huge[k] > 0) ? (small[k] * 100) / huge[k] : 0
      printf "elder_attribution kib=%d pages=%d small_hundredths=%d huge_hundredths=%d translation_ratio_hundredths=%d\n", k, pages[k], small[k], huge[k], r
    }
    lo = keys[1]; hi = keys[n]
    sspan = (small[lo] > 0) ? (small[hi] * 100) / small[lo] : 0
    hspan = (huge[lo] > 0) ? (huge[hi] * 100) / huge[lo] : 0
    printf "elder_span from_kib=%d to_kib=%d small_hundredths=%d huge_hundredths=%d\n", lo, hi, sspan, hspan
  }' "$PLAIN" "$HUGE"

echo "verdict ok"
