#!/bin/sh
# Commence M5 re-cut scan -- control gate, then advisory-11 + inventory.
# Exit 0 only when control reads and every re-cut limb honors.
# No backtick characters in patterns.
#
#   sh tools/fixtures/commence_m5_recut_scan.sh
#
# Law: no duty reports a total until its planted control reads correctly.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh

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

# --- advisory-11 re-touch (present + mold signal) ---
PRESENT=0
DRIFT=0
ABSENT=0
for m in \
  glow/rune_bartis.rye \
  glow/rune_barket.rye \
  glow/lower_bartis.rye \
  glow/lower_barket.rye \
  glow/lower_named_cast.rye \
  glow/rune_cast.rye \
  glow/rune_face.rye \
  glow/lower_face.rye \
  glow/expr.rye \
  glow/glow_run.rye \
  glow/tokens.rye
do
  if git ls-files --error-unmatch "$m" >/dev/null 2>&1; then
    PRESENT=$((PRESENT + 1))
    if rg -q 'mold' "$m"; then
      DRIFT=$((DRIFT + 1))
    fi
  else
    ABSENT=$((ABSENT + 1))
  fi
done

echo "advisory_present=$PRESENT"
echo "advisory_drift=$DRIFT"
echo "advisory_absent=$ABSENT"

if test "$PRESENT" -ne 11 || test "$DRIFT" -ne 11 || test "$ABSENT" -ne 0; then
  echo "advisory=failed"
  echo "verdict=misread"
  echo "detail=advisory_11_not_holding"
  exit 1
fi
echo "advisory=honored"

# --- tracked inventory (only after control) ---
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

echo "m5_scan=ok"
echo "verdict=ok"
