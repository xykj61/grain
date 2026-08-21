#!/bin/sh
# Commence M6 see scan — control gate, then eyes census of the finishing edge.
# Exit 0 only when control reads and every see limb honors.
# No backtick characters in patterns.
#
#   sh tools/fixtures/commence_m6_see_scan.sh
#
# Law: no duty reports a total until its planted control reads correctly.
# See != run: M5 re-cuts greens; M6 eyes-verifies what already sits on disk.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

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
echo "$CONTROL_OUT" | rg -q '^duties_honored=3$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  echo "detail=control_want_3_of_3"
  exit 1
}
echo "control_gate=honored"

# --- see almanac ch7 finishing edge ---
if ! test -f "$ALMANAC"; then
  echo "see_almanac=failed"
  echo "verdict=absent"
  echo "detail=almanac_missing"
  exit 1
fi
# Accept ch7 at 4/16 (pre-seat) or 5+/16 (after M6 and later fills).
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*|*"Chapter Seven (8 of 16)"*|*"Chapter Seven (9 of 16)"*|*"Chapter Seven (10 of 16)"*|*"Chapter Seven (11 of 16)"*|*"Chapter Seven (12 of 16)"*|*"Chapter Seven (13 of 16)"*|*"Chapter Seven (14 of 16)"*|*"Chapter Seven (15 of 16)"*|*"Chapter Seven (16 of 16)"*)
    ;;
  *)
    echo "see_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_ch7_at_least_4_of_16"
    echo "detail_line=$CH7_LINE"
    exit 1
    ;;
esac
# Reject still-open-at-3 or earlier.
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*)
    echo "see_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_seen_edge"
    exit 1
    ;;
esac
for n in 97 98 99 100; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "see_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "see_almanac=honored"
echo "see_ch7_line=$CH7_LINE"
echo "see_seats=97-100"

# --- see waymarks e93-e96 ---
for wm in \
  waymarks/date/20260731/20260731-114927_e93-ironbeetle-ep044-ch7-open-green.md \
  waymarks/date/20260731/20260731-115725_e94-ironbeetle-ep045-green.md \
  waymarks/date/20260731/20260731-120704_e95-census-control-ch7-green.md \
  waymarks/date/20260731/20260731-122009_e96-commence-m5-recut-green.md
do
  git ls-files --error-unmatch "$wm" >/dev/null 2>&1 || {
    echo "see_waymarks=failed"
    echo "verdict=misread"
    echo "detail=missing_${wm}"
    exit 1
  }
done
echo "see_waymarks=honored"
echo "see_waymarks_count=4"

# --- see IronBeetle written shelf end (ep045 present · ep046 invent none) ---
EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "see_shelf=failed"
  echo "verdict=misread"
  echo "detail=ep045_absent"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "see_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "see_shelf=honored"
echo "see_shelf_end=ep045"
echo "see_ep046=absent"

# --- tracked inventory only after control ---
MD=$(git ls-files '*.md' | wc -l | tr -d ' ')
RISH=$(git ls-files '*.rish' | wc -l | tr -d ' ')
RYE=$(git ls-files '*.rye' | wc -l | tr -d ' ')
GLOW=$(git ls-files '*.glow' | wc -l | tr -d ' ')
CACHE=$(git ls-files 'glow/.cache/*' | wc -l | tr -d ' ')

echo "inv_md=$MD"
echo "inv_rish=$RISH"
echo "inv_rye=$RYE"
echo "inv_glow=$GLOW"
echo "inv_glow_cache_tracked=$CACHE"

if test "$CACHE" -ne 0; then
  echo "inventory=failed"
  echo "verdict=misread"
  echo "detail=glow_cache_must_stay_untracked"
  exit 1
fi
if test "$MD" -lt 1 || test "$RISH" -lt 1 || test "$RYE" -lt 1 || test "$GLOW" -lt 1; then
  echo "inventory=failed"
  echo "verdict=misread"
  echo "detail=inventory_empty"
  exit 1
fi
echo "inventory=honored"

echo "m6_see=ok"
echo "verdict=ok"
