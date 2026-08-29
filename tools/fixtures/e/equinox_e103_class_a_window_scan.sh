#!/bin/sh
# Equinox e103 Class A refine + window_min baseline scan.
# Exit 0 when control reads, the living window_min meter reports, and the
# almanac still carries e103's seated 92-to-100 refinement.
# No backtick characters in patterns.
#
#   sh tools/fixtures/e/equinox_e103_class_a_window_scan.sh
#
# Law: honest anchor records are not residue. Fall baseline = window_min.
# Later tree growth cannot turn a new living grade into a failure of e103.
# Counsel A (memcpy) already consumed on Framework e102.
set -eu

CONTROL_SCAN=tools/fixtures/c/census_control_scan.sh
ALMANAC="${ALMANAC:-rye-learning-process/GLOW_ALMANAC.md}"
PRIN=tools/gen/chapter/prin_scope.rish
FASCIA_SH="${FASCIA_SH:-tools/fixtures/f/fascia_metric_v0.sh}"
WIRE=comlink/discovery/round_trip_wire.rye

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi

CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT"
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  echo "detail=control_must_read_before_totals"
  exit 1
}
echo "control_gate=honored"

# --- counsel A consumed: memcpy already routed ---
rg -q 'tally_copy.copy_disjoint\(u8, buf\[0\.\.joined\.len\], joined\)' "$WIRE" || {
  echo "refine_memcpy=failed"
  echo "verdict=misread"
  echo "detail=want_e102_memcpy_paid"
  exit 1
}
if rg -q '@memcpy\(' "$WIRE"; then
  echo "refine_memcpy=failed"
  echo "verdict=misread"
  echo "detail=bare_memcpy_remains"
  exit 1
fi
echo "refine_memcpy=honored"
echo "refine_memcpy_note=counsel_A_consumed_e102"

# --- fascia measure (window_min kept; Class A hold/exclude refined by later seats) ---
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "refine_fascia=failed"
  echo "verdict=misread"
  exit 1
}
# E103 landed window_min. E104 may HOLD Class A again; the current metric must
# keep reporting the baseline, while the e103 grade remains historical evidence.
echo "$FASCIA_OUT" | rg -q -F 'baseline_kind=window_min' || {
  echo "refine_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_window_min_baseline"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'delta_vs_mean=' || {
  echo "refine_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_delta_vs_mean"
  exit 1
}
FASCIA_GRADES=$(echo "$FASCIA_OUT" | sed -n 's/^fascia=\([0-9][0-9]*\)$/\1/p')
FASCIA_COUNT=$(printf '%s\n' "$FASCIA_GRADES" | sed '/^$/d' | wc -l | tr -d ' ')
FASCIA_GRADE=$(printf '%s\n' "$FASCIA_GRADES" | head -n1)
if test "$FASCIA_COUNT" -ne 1 || test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -gt 100; then
  echo "refine_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_one_fascia_in_range_0_100"
  exit 1
fi

rg -q '^### 107[.] Equinox e103 Class A refine.*fascia 92.*100[.]$' "$ALMANAC" || {
  echo "refine_fascia_history=failed"
  echo "verdict=misread"
  echo "detail=want_e103_fascia_92_to_100_seat"
  exit 1
}
rg -q '^Expected .*metric_rev=i7 .*class_a=0 .*class_a_honest_excluded=4 .*baseline_kind=window_min .*fascia=100 .*Metal answered GREEN[.]' "$ALMANAC" || {
  echo "refine_fascia_history=failed"
  echo "verdict=misread"
  echo "detail=want_e103_refine_metal_receipt"
  exit 1
}
echo "refine_fascia=honored"
echo "refine_fascia_grade_current=${FASCIA_GRADE}"
echo "refine_fascia_grade_seated=100"
echo "refine_fascia_history=honored"
echo "refine_window_min_current=honored"
echo "refine_window_min_seated=honored"
echo "refine_class_a_seated=0"
echo "refine_class_a_honest_excluded_seated=4"
echo "refine_class_a_note=e103_exclude_trial_refined_by_e104_hold"
echo "refine_baseline_kind=window_min"

# --- fork still unconsumed ---
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "refine_fork=failed"
  echo "verdict=misread"
  echo "detail=nested_handback_must_stay_unconsumed"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "refine_fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "refine_fork=honored"
echo "refine_fork_status=not_consumed"

# --- almanac seats 97-106 - ch7 at least 10/16 ---
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*|*"Chapter Seven (8 of 16)"*|*"Chapter Seven (9 of 16)"*)
    echo "refine_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_refine_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "refine_almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104 105 106; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "refine_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "refine_almanac=honored"
echo "refine_ch7_line=$CH7_LINE"
echo "refine_seats=97-106"

EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "refine_shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "refine_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "refine_shelf=honored"
echo "refine_shelf_end=ep045"
echo "shred=RED"

echo "refine_story=e102_memcpy_paid>window_min_seated>fascia_100_seated>current_fascia_reported>fork_waiting>e104_may_hold_class_a"
echo "e103_class_a_window=ok"
echo "verdict=ok"
