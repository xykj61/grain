#!/bin/sh
# Equinox e104 hold Class A disclosed + Class O room home scan.
# Exit 0 only when control reads and i8 + Class O limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e104_hold_class_o_scan.sh
#
# Law: exclusion hides; holding discloses. Class O propose-never-seat rooms.
# Counsel A (window_min) already consumed on e103.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
FASCIA_SH=tools/fixtures/fascia_metric_v0.sh
SHRED_PREP=construction/SHRED_PREP.md

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

# --- i8 fascia: hold disclosed · window_min kept ---
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "hold_fascia=failed"
  echo "verdict=misread"
  exit 1
}
# e104 landed i8 hold. Later i9 may carry the window — elder accepts i8 or i9.
if ! echo "$FASCIA_OUT" | rg -q -F 'metric_rev=i8' && ! echo "$FASCIA_OUT" | rg -q -F 'metric_rev=i9'; then
  echo "hold_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_metric_rev_i8_or_i9"
  exit 1
fi
echo "$FASCIA_OUT" | rg -q -F 'signal:target_class_a=4' || {
  echo "hold_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_class_a_held_count_4"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'signal:class_a_held_disclosed=4' || {
  echo "hold_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_held_disclosed_4"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'law=hold_not_exclude' || {
  echo "hold_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_hold_not_exclude_law"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'baseline_kind=window_min' || {
  echo "hold_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_window_min_kept"
  exit 1
}
FASCIA_GRADE=$(echo "$FASCIA_OUT" | rg -o 'fascia=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -ne 92; then
  echo "hold_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_92_held_residual"
  exit 1
fi
# Refuse silence: i8 must not report honest-exclude zeroing.
if echo "$FASCIA_OUT" | rg -q 'class_a_honest_excluded='; then
  echo "hold_fascia=failed"
  echo "verdict=misread"
  echo "detail=exclude_line_must_stay_absent"
  exit 1
fi
echo "hold_fascia=honored"
echo "hold_fascia_grade=${FASCIA_GRADE}"
echo "hold_class_a=4"
echo "hold_class_a_law=hold_not_exclude"
echo "hold_baseline_kind=window_min"
echo "hold_window_note=counsel_A_consumed_e103"

# --- Class O room home in SHRED_PREP ---
git ls-files --error-unmatch "$SHRED_PREP" >/dev/null 2>&1 || {
  echo "hold_class_o=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'Class O — rooms' "$SHRED_PREP" || {
  echo "hold_class_o=failed"
  echo "verdict=misread"
  echo "detail=want_class_o_rooms_section"
  exit 1
}
rg -q 'propose-never-seat' "$SHRED_PREP" || {
  echo "hold_class_o=failed"
  echo "verdict=misread"
  exit 1
}
rg -q 'session-logs' "$SHRED_PREP" || {
  echo "hold_class_o=failed"
  echo "verdict=misread"
  echo "detail=want_session_logs_room"
  exit 1
}
rg -q 'counsel' "$SHRED_PREP" || {
  echo "hold_class_o=failed"
  echo "verdict=misread"
  echo "detail=want_counsel_room"
  exit 1
}
rg -q 'waymarks' "$SHRED_PREP" || {
  echo "hold_class_o=failed"
  echo "verdict=misread"
  echo "detail=want_waymarks_room"
  exit 1
}
rg -q 'none — propose only · never seat' "$SHRED_PREP" || {
  echo "hold_class_o=failed"
  echo "verdict=misread"
  echo "detail=want_no_paths_seated"
  exit 1
}
echo "hold_class_o=honored"
echo "hold_class_o_status=rooms_home_propose_never_seat"

# --- fork still unconsumed ---
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "hold_fork=failed"
  echo "verdict=misread"
  echo "detail=nested_handback_must_stay_unconsumed"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "hold_fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "hold_fork=honored"
echo "hold_fork_status=not_consumed"

# --- almanac seats 97-107 · ch7 at least 11/16 ---
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*|*"Chapter Seven (8 of 16)"*|*"Chapter Seven (9 of 16)"*|*"Chapter Seven (10 of 16)"*)
    echo "hold_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_hold_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "hold_almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104 105 106 107; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "hold_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "hold_almanac=honored"
echo "hold_ch7_line=$CH7_LINE"
echo "hold_seats=97-107"

EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "hold_shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "hold_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "hold_shelf=honored"
echo "hold_shelf_end=ep045"
echo "shred=RED"

echo "hold_story=window_min_kept>i8_hold_disclosed>class_a_4>fascia_92>class_o_rooms_home>fork_waiting"
echo "e104_hold_class_o=ok"
echo "verdict=ok"
