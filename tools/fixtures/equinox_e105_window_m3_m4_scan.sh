#!/bin/sh
# Equinox e105 -- window carry across revisions + M3/M4 home land.
# Exit 0 only when control reads and all limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e105_window_m3_m4_scan.sh
#
# Law: a metric revision carries its window forward, marked by metric_rev.
# Keep i8 hold disclosed. Land M3 oldness + M4 radiant H1 fence.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
FASCIA_SH=tools/fixtures/fascia_metric_v0.sh
OLDNESS=tools/fixtures/oldness_census_scan.sh
H1=tools/fixtures/radiant_h1_fence_scan.sh

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
  exit 1
}
echo "control_gate=honored"

# --- i9 fascia: hold kept - window carry - arc fall restored ---
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'metric_rev=i9' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_metric_rev_i9"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'signal:target_class_a=4' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'law=hold_not_exclude' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'baseline_kind=window_min' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'window_carry=honored' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_window_carry"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'window_arc_fall=-15' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_arc_fall_named"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'window_min=85' || {
  echo "home_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_window_min_85_remembered_fall"
  exit 1
}
FASCIA_GRADE=$(echo "$FASCIA_OUT" | rg -o 'fascia=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -ne 92; then
  echo "home_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_92_hold_residual"
  exit 1
fi
echo "home_fascia=honored"
echo "home_fascia_grade=${FASCIA_GRADE}"
echo "home_metric_rev=i9"
echo "home_window_carry=honored"
echo "home_window_min=85"
echo "home_class_a_law=hold_not_exclude"

# --- M3 oldness ---
OLD_OUT=$(sh "$OLDNESS")
echo "$OLD_OUT"
echo "$OLD_OUT" | rg -q '^verdict=ok$' || {
  echo "home_m3=failed"
  echo "verdict=misread"
  exit 1
}
echo "$OLD_OUT" | rg -q -F 'tier2_band=four_fifths' || {
  echo "home_m3=failed"
  echo "verdict=misread"
  exit 1
}
echo "home_m3=honored"
echo "home_m3_name=oldness_census"

# --- M4 radiant H1 fence ---
H1_OUT=$(sh "$H1")
echo "$H1_OUT"
echo "$H1_OUT" | rg -q '^verdict=ok$' || {
  echo "home_m4=failed"
  echo "verdict=misread"
  exit 1
}
echo "$H1_OUT" | rg -q -F 'governing_template=yes' || {
  echo "home_m4=failed"
  echo "verdict=misread"
  exit 1
}
echo "home_m4=honored"
echo "home_m4_name=radiant_h1_fence"

# --- fork still unconsumed ---
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "home_fork=failed"
  echo "verdict=misread"
  echo "detail=nested_handback_must_stay_unconsumed"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "home_fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "home_fork=honored"
echo "home_fork_status=not_consumed"

# --- almanac seats 97-108 - ch7 at least 12/16 (elder floor; later seats may grow) ---
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*|*"Chapter Seven (8 of 16)"*|*"Chapter Seven (9 of 16)"*|*"Chapter Seven (10 of 16)"*|*"Chapter Seven (11 of 16)"*)
    echo "home_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_home_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "home_almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104 105 106 107 108; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "home_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "home_almanac=honored"
echo "home_ch7_line=$CH7_LINE"
echo "home_seats=97-108"

EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "home_shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "home_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "home_shelf=honored"
echo "home_shelf_end=ep045"
echo "shred=RED"

echo "home_story=i9_window_carry>arc_fall_-15>i8_hold_kept>m3_oldness>m4_h1_fence>fork_waiting"
echo "e105_window_m3_m4=ok"
echo "verdict=ok"
