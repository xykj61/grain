#!/bin/sh
# tools/fixtures/t/tlb_reach_control.sh -- proves that tlb_reach_census.sh refuses what it says
# it refuses, and welcomes what it says it welcomes.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a
# bypass: a leg that never fires and a leg that was deleted read exactly alike from outside. So
# every plant below is asserted from the failing side, and the unplanted baseline is asserted
# from the passing side, which is what proves the pen itself innocent.
#
# WHY SYNTHESIZED READINGS RATHER THAN THE PROBE. This control tests the CENSUS -- its parsing,
# its seven legs, and its arithmetic. Building the probe would add a toolchain dependency and
# several minutes to a check whose subject is a shell script, and it would still not let a plant
# reach the census's own comparisons, since a real board cannot be asked for a wrong page size.
# The probe's own correctness is held elsewhere: by its internal asserts, by the census's
# page_size_bind and line_size_bind legs on metal, and by the huge-page falsifier it runs.
#
# WHAT A PLANT MAY NOT DO, learned one lap earlier at cost. A plant that silently fails to take
# effect leaves a control reporting itself proven while testing nothing -- this tree published
# exactly that shape on 20260906, where a stride plant failed to build and the control printed
# "skip" beside a verdict of proven. So every plant here is checked to have CHANGED the reading
# it was applied to, and a plant that changed nothing is a FAULT rather than a skip.
#
# Usage: sh tools/fixtures/t/tlb_reach_control.sh
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

CENSUS="$ROOT/tools/fixtures/t/tlb_reach_census.sh"
[ -f "$CENSUS" ] || { echo "refused: no census at $CENSUS" >&2; exit 2; }

PEN="${TMPDIR:-/tmp}/tlb_reach_control_pen"
rm -rf "$PEN"; mkdir -p "$PEN"
trap 'rm -rf "$PEN"' EXIT INT TERM

behaviors=0
faults=0

note() { echo "  $*"; }

expect_refuse() {
  _label=$1; _want=$2; shift 2
  behaviors=$((behaviors + 1))
  if out=$(sh "$CENSUS" "$@" 2>&1); then
    echo "FAULT $_label -- the census PASSED a reading that plants $_want"
    faults=$((faults + 1))
  else
    if printf '%s' "$out" | grep -q "$_want"; then
      note "refused $_label ($_want)"
    else
      echo "FAULT $_label -- refused, yet not for $_want:"
      printf '%s\n' "$out" | tail -3 | sed 's/^/      /'
      faults=$((faults + 1))
    fi
  fi
}

expect_pass() {
  _label=$1; shift
  behaviors=$((behaviors + 1))
  if out=$(sh "$CENSUS" "$@" 2>&1); then
    if printf '%s' "$out" | grep -q '^verdict ok$'; then
      note "welcomed $_label"
    else
      echo "FAULT $_label -- exited zero without verdict ok"
      faults=$((faults + 1))
    fi
  else
    echo "FAULT $_label -- the census REFUSED a reading it should welcome:"
    printf '%s\n' "$out" | tail -3 | sed 's/^/      /'
    faults=$((faults + 1))
  fi
}

# A plant that changed nothing tests nothing. Every mutation runs through here.
planted() {
  _label=$1; _before=$2; _after=$3
  behaviors=$((behaviors + 1))
  if cmp -s "$_before" "$_after"; then
    echo "FAULT $_label -- the plant left the reading byte-identical, so it planted nothing"
    faults=$((faults + 1))
  else
    note "plant took effect: $_label"
  fi
}

# ---- a fake kernel report, so line_size_bind has something to disagree with -------------------
mkdir -p "$PEN/sysfs/index0"
printf '1\n'    > "$PEN/sysfs/index0/level"
printf 'Data\n' > "$PEN/sysfs/index0/type"
printf '32K\n'  > "$PEN/sysfs/index0/size"
printf '64\n'   > "$PEN/sysfs/index0/coherency_line_size"

mkdir -p "$PEN/sysfs128/index0"
printf '1\n'    > "$PEN/sysfs128/index0/level"
printf 'Data\n' > "$PEN/sysfs128/index0/type"
printf '32K\n'  > "$PEN/sysfs128/index0/size"
printf '128\n'  > "$PEN/sysfs128/index0/coherency_line_size"

mkdir -p "$PEN/sysfs_empty"

# ---- synthesized readings ---------------------------------------------------------------------
# A curve shaped like the real one: flat to 64 pages, a step at 65, a plateau after. The huge-page
# curve is flat throughout, which is what the falsifier expects when the step is translation.
#
# ns figures are hundredths, matching the probe's own unit. packed holds at 165 (1.65 ns); spread
# holds at 165 below the knee and 396 (3.96 ns) above it.
emit_reading() {
  _out=$1; _huge=$2; _anon=$3
  {
    echo "probe_version 1"
    echo "line_bytes 64"
    echo "page_bytes 4096"
    echo "huge_bytes 2097152"
    echo "steps_per_rep 2000000"
    echo "reps 4"
    echo "max_span_bytes 67108864"
    echo "exact_pair_max_nodes 512"
    echo "huge_requested $_huge"
    echo "huge_advised $_huge"
    for n in 8 16 32 48 64 65 72 96 128 256 512; do
      packed_pages=$(( (n + 63) / 64 ))
      if [ "$_huge" = yes ]; then
        spread_ns=165
      elif [ "$n" -le 64 ]; then
        spread_ns=165
      else
        spread_ns=396
      fi
      echo "reading layout=packed n=$n pages=$packed_pages touched_bytes=$((n * 64)) ns_hundredths=165 spread_pct=2"
      echo "reading layout=spread n=$n pages=$n touched_bytes=$((n * 64)) ns_hundredths=$spread_ns spread_pct=2"
    done
    # The elder arm: the elder study's own packed layout at its own three sizes. Shapes rather
    # than copied numbers -- under small pages the cost climbs once the page count passes a
    # second-level reach, and under large pages it climbs only with the bytes.
    for kib in 4096 8192 32768; do
      nodes=$((kib * 1024 / 64))
      pages=$((kib * 1024 / 4096))
      if [ "$_huge" = yes ]; then
        case "$kib" in
          4096)  elder_ns=1800 ;;
          8192)  elder_ns=1900 ;;
          *)     elder_ns=10900 ;;
        esac
      else
        case "$kib" in
          4096)  elder_ns=1840 ;;
          8192)  elder_ns=3800 ;;
          *)     elder_ns=15300 ;;
        esac
      fi
      echo "elder kib=$kib nodes=$nodes pages=$pages ns_hundredths=$elder_ns spread_pct=3"
    done
    echo "anon_huge_kib $_anon"
    echo "checksum 1"
    echo "probe_done"
  } > "$_out"
}

emit_reading "$PEN/plain.txt" no 0
emit_reading "$PEN/huge.txt"  yes 32768

echo "tlb-reach-control: the pen, and what it plants"

# ---- the baseline, from the passing side ------------------------------------------------------
expect_pass "clean baseline" --from "$PEN/plain.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- leg 1: page_size_bind --------------------------------------------------------------------
expect_refuse "page_size_bind" "every reach in pages is wrong" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 16384

# ---- leg 2: line_size_bind --------------------------------------------------------------------
expect_refuse "line_size_bind" "the kernel reports a 128-byte line" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs128" --page-size 4096

# ---- leg 3: pair_matched ----------------------------------------------------------------------
sed 's/layout=spread n=128 pages=128 touched_bytes=8192/layout=spread n=128 pages=128 touched_bytes=9999/' \
  "$PEN/plain.txt" > "$PEN/unmatched.txt"
planted "pair_matched" "$PEN/plain.txt" "$PEN/unmatched.txt"
expect_refuse "pair_matched" "they are not a pair" \
  --from "$PEN/unmatched.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- leg 4: spread_differs, two shapes --------------------------------------------------------
sed 's/layout=spread n=256 pages=256/layout=spread n=256 pages=4/' "$PEN/plain.txt" > "$PEN/notspread.txt"
planted "spread_differs/one_page_per_node" "$PEN/plain.txt" "$PEN/notspread.txt"
expect_refuse "spread_differs/one_page_per_node" "does not occupy one page per node" \
  --from "$PEN/notspread.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

sed 's/layout=packed n=256 pages=4 /layout=packed n=256 pages=256 /' "$PEN/plain.txt" > "$PEN/packedwide.txt"
planted "spread_differs/packed_spans_as_many" "$PEN/plain.txt" "$PEN/packedwide.txt"
expect_refuse "spread_differs/packed_spans_as_many" "the pair varies nothing" \
  --from "$PEN/packedwide.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- leg 5: flat_below_knee -------------------------------------------------------------------
# A pair that already differs by half below the knee is a pair with a confound, and the step
# above it would then be measuring that confound as well as translation.
sed 's/layout=spread n=32 pages=32 touched_bytes=2048 ns_hundredths=165/layout=spread n=32 pages=32 touched_bytes=2048 ns_hundredths=248/' \
  "$PEN/plain.txt" > "$PEN/confounded.txt"
planted "flat_below_knee" "$PEN/plain.txt" "$PEN/confounded.txt"
expect_refuse "flat_below_knee" "the pair carries a confound" \
  --from "$PEN/confounded.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- leg 6: knee_located ----------------------------------------------------------------------
sed 's/ns_hundredths=396/ns_hundredths=165/' "$PEN/plain.txt" > "$PEN/noknee.txt"
planted "knee_located" "$PEN/plain.txt" "$PEN/noknee.txt"
expect_refuse "knee_located" "locates no translation boundary" \
  --from "$PEN/noknee.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- leg 7: huge_collapses, three shapes ------------------------------------------------------
sed 's/^huge_advised yes$/huge_advised no/' "$PEN/huge.txt" > "$PEN/huge_refused.txt"
planted "huge_collapses/advice_refused" "$PEN/huge.txt" "$PEN/huge_refused.txt"
expect_refuse "huge_collapses/advice_refused" "the falsifier did not run" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge_refused.txt" --sysfs "$PEN/sysfs" --page-size 4096

sed 's/^anon_huge_kib 32768$/anon_huge_kib 0/' "$PEN/huge.txt" > "$PEN/huge_ungranted.txt"
planted "huge_collapses/no_grant" "$PEN/huge.txt" "$PEN/huge_ungranted.txt"
expect_refuse "huge_collapses/no_grant" "a plant that did not run is not evidence" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge_ungranted.txt" --sysfs "$PEN/sysfs" --page-size 4096

# The step survives huge pages: then it was never translation, or not only translation, and the
# census must say so rather than crediting the conclusion it set out to reach.
sed 's/layout=spread n=65 pages=65 touched_bytes=4160 ns_hundredths=165/layout=spread n=65 pages=65 touched_bytes=4160 ns_hundredths=520/' \
  "$PEN/huge.txt" > "$PEN/huge_persists.txt"
planted "huge_collapses/step_survives" "$PEN/huge.txt" "$PEN/huge_persists.txt"
expect_refuse "huge_collapses/step_survives" "the step is not translation" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge_persists.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- leg 8: elder_arm_ran, in three shapes -----------------------------------------------------
#
# The arm speaks about another paper's published sentence, so its ABSENCE is the failure worth
# proving. An arm that did not run prints no attribution and reads exactly like an arm that ran and
# found nothing.
grep -v '^elder ' "$PEN/plain.txt" > "$PEN/no_elder_small.txt"
planted "elder_arm_ran/absent_small" "$PEN/plain.txt" "$PEN/no_elder_small.txt"
expect_refuse "elder_arm_ran/absent_small" "silence wearing agreement" \
  --from "$PEN/no_elder_small.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

grep -v '^elder ' "$PEN/huge.txt" > "$PEN/no_elder_huge.txt"
planted "elder_arm_ran/absent_huge" "$PEN/huge.txt" "$PEN/no_elder_huge.txt"
expect_refuse "elder_arm_ran/absent_huge" "silence wearing agreement" \
  --from "$PEN/plain.txt" --huge-from "$PEN/no_elder_huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# Unequal counts: the pairs below would not be pairs, and one size would be compared against
# whichever other size happened to survive.
grep -v '^elder kib=8192 ' "$PEN/huge.txt" > "$PEN/short_elder_huge.txt"
planted "elder_arm_ran/unequal" "$PEN/huge.txt" "$PEN/short_elder_huge.txt"
expect_refuse "elder_arm_ran/unequal" "would not be pairs" \
  --from "$PEN/plain.txt" --huge-from "$PEN/short_elder_huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- the readings themselves ------------------------------------------------------------------
grep -v '^probe_done$' "$PEN/plain.txt" > "$PEN/truncated.txt"
planted "truncated_reading" "$PEN/plain.txt" "$PEN/truncated.txt"
expect_refuse "truncated_reading" "no probe_done line" \
  --from "$PEN/truncated.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

sed 's/^checksum 1$/refused kib=64 cycle_length=3 wanted=64/' "$PEN/plain.txt" > "$PEN/selfrefused.txt"
planted "probe_self_refusal" "$PEN/plain.txt" "$PEN/selfrefused.txt"
expect_refuse "probe_self_refusal" "the probe refused its own chase" \
  --from "$PEN/selfrefused.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# Too few points to locate anything. Six is the floor the census names.
{ sed -n '1,9p' "$PEN/plain.txt"; grep -m4 '^reading ' "$PEN/plain.txt"; echo "anon_huge_kib 0"; echo "probe_done"; } > "$PEN/thin.txt"
planted "too_few_points" "$PEN/plain.txt" "$PEN/thin.txt"
expect_refuse "too_few_points" "too few to locate a step" \
  --from "$PEN/thin.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

# ---- the arguments themselves -----------------------------------------------------------------
expect_refuse "from_without_huge_from" "leaves the falsifier unread" \
  --from "$PEN/plain.txt" --sysfs "$PEN/sysfs" --page-size 4096

expect_refuse "missing_reading" "no reading at" \
  --from "$PEN/absent.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

expect_refuse "missing_huge_reading" "no huge-page reading at" \
  --from "$PEN/plain.txt" --huge-from "$PEN/absent.txt" --sysfs "$PEN/sysfs" --page-size 4096

expect_refuse "unknown_argument" "unknown argument" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge.txt" --colour

expect_refuse "no_topology" "no cache topology at" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs_absent" --page-size 4096

expect_refuse "unusable_topology" "no usable topology" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs_empty" --page-size 4096

# ---- the baseline again, after every plant ----------------------------------------------------
# The pen is proven innocent from both ends: nothing above left a mutation behind in the readings
# the clean legs read, so a refusal above is the plant rather than the pen.
expect_pass "clean baseline, after every plant" \
  --from "$PEN/plain.txt" --huge-from "$PEN/huge.txt" --sysfs "$PEN/sysfs" --page-size 4096

echo "behaviors $behaviors"
echo "faults $faults"
if [ "$faults" -eq 0 ]; then
  echo "control_verdict proven"
  exit 0
fi
echo "control_verdict broken"
exit 1
