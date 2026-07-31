#!/bin/sh
# Equinox e103 Class A refine + window_min baseline scan.
# Exit 0 only when control reads and i7 limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e103_class_a_window_scan.sh
#
# Law: honest anchor records are not residue. Fall baseline = window_min.
# Counsel A (memcpy) already consumed on Framework e102.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
FASCIA_SH=tools/fixtures/fascia_metric_v0.sh
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

# --- i7 fascia measure ---
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "refine_fascia=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'metric_rev=i7' || {
  echo "refine_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_metric_rev_i7"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'signal:target_class_a=0' || {
  echo "refine_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_class_a_residue_zero"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'signal:class_a_honest_excluded=4' || {
  echo "refine_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_four_honest_anchors_excluded"
  exit 1
}
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
FASCIA_GRADE=$(echo "$FASCIA_OUT" | rg -o 'fascia=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -lt 100; then
  echo "refine_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_100_after_honest_exclude"
  exit 1
fi
echo "refine_fascia=honored"
echo "refine_fascia_grade=${FASCIA_GRADE}"
echo "refine_class_a=0"
echo "refine_class_a_honest_excluded=4"
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

# --- almanac seats 97-106 · ch7 at least 10/16 ---
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

echo "refine_story=e102_memcpy_paid>i7_honest_anchors_excluded>class_a_0>fascia_100>window_min_baseline>fork_waiting"
echo "e103_class_a_window=ok"
echo "verdict=ok"
