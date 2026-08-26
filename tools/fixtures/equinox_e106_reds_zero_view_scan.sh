#!/bin/sh
# Equinox e106 -- REDS row 33 zero-view law + M3/M4 already home.
# Exit 0 only when control reads and all limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e106_reds_zero_view_scan.sh
#
# Law: a zero is a claim about the instrument's view, never about the world.
# M3/M4 home land already crossed on e105 (counsel A consumed).
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PRIN=tools/gen/season/prin_scope.rish
FASCIA_SH=tools/fixtures/fascia_metric_v0.sh
REDS=construction/REDS.md
ZERO=tools/fixtures/zero_view_scan.sh
M3=tools/fixtures/oldness_census_scan.sh
M4=tools/fixtures/radiant_h1_fence_scan.sh

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

# --- REDS row 33 - zero-view law ---
git ls-files --error-unmatch "$REDS" >/dev/null 2>&1 || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
sh tools/fixtures/reds_row_present.sh 33 >/dev/null || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_row_33"
  exit 1
}
sh tools/fixtures/reds_spine_grep.sh 'A zero in a report is a claim about the instrument' >/dev/null || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_zero_view_taught_law"
  exit 1
}
sh tools/fixtures/reds_spine_grep.sh 'Look where the thing would be before calling it gone' >/dev/null || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_look_before_gone"
  exit 1
}
MONO=$(sh tools/fixtures/reds_ledger_monotone_scan.sh)
echo "$MONO"
echo "$MONO" | rg -q '^verdict=ok$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_monotone"
  exit 1
}
echo "$MONO" | rg -q '^rows=33$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  echo "detail=want_rows_33"
  exit 1
}
echo "$MONO" | rg -q '^expect_next=34$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
LEDGER=$(sh tools/fixtures/reds_ledger_scan.sh)
echo "$LEDGER"
echo "$LEDGER" | rg -q '^verdict=ok$' || {
  echo "reds_row=failed"
  echo "verdict=misread"
  exit 1
}
echo "reds_row=honored"
echo "reds_row_n=33"
echo "reds_law=zero_is_instrument_view_never_world"
echo "reds_note=counsel_named_37_tree_accretes_33"

# --- planted zero-view instrument ---
ZERO_OUT=$(sh "$ZERO")
echo "$ZERO_OUT"
echo "$ZERO_OUT" | rg -q '^verdict=ok$' || {
  echo "zero_view=failed"
  echo "verdict=misread"
  exit 1
}
echo "zero_view=honored"

# --- M3/M4 already home (e105) -- counsel A consumed ---
git ls-files --error-unmatch "$M3" >/dev/null 2>&1 || {
  echo "m3_home=failed"
  echo "verdict=misread"
  exit 1
}
git ls-files --error-unmatch "$M4" >/dev/null 2>&1 || {
  echo "m4_home=failed"
  echo "verdict=misread"
  exit 1
}
echo "m3_home=honored"
echo "m4_home=honored"
echo "m3_m4_status=e105_consumed"

# --- fascia hold + window carry kept ---
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'metric_rev=i9' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'law=hold_not_exclude' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'window_carry=honored' || {
  echo "fascia_keep=failed"
  echo "verdict=misread"
  exit 1
}
FASCIA_GRADE=$(echo "$FASCIA_OUT" | rg -o 'fascia=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -ne 92; then
  echo "fascia_keep=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_92"
  exit 1
fi
echo "fascia_keep=honored"
echo "fascia_keep_grade=${FASCIA_GRADE}"

# --- fork still unconsumed ---
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "fork=honored"
echo "fork_status=not_consumed"

# --- almanac seats 97-109 - ch7 at least 13/16 ---
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*|*"Chapter Seven (8 of 16)"*|*"Chapter Seven (9 of 16)"*|*"Chapter Seven (10 of 16)"*|*"Chapter Seven (11 of 16)"*|*"Chapter Seven (12 of 16)"*)
    echo "almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_e106_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104 105 106 107 108 109; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "almanac=honored"
echo "ch7_line=$CH7_LINE"
echo "seats=97-109"

EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
fi
echo "shelf=honored"
echo "shelf_end=ep045"
echo "shred=RED"

echo "story=reds_33_zero_view>planted_archive_control>m3_m4_e105_consumed>i9_hold_kept>fork_waiting"
echo "e106_reds_zero_view=ok"
echo "verdict=ok"
