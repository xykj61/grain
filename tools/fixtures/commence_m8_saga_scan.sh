#!/bin/sh
# Commence M8 saga scan -- control gate, then measured commence-arc saga.
# Exit 0 only when control reads and every saga limb honors.
# No backtick characters in patterns.
#
#   sh tools/fixtures/commence_m8_saga_scan.sh
#
# Law: no duty reports a total until its planted control reads correctly.
# Saga != see != weave: M8 eyes the ordered story of movements already on disk.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
SAGA_HOME=saga/README.md

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

# --- saga shelf home (lasting close narratives door) ---
git ls-files --error-unmatch "$SAGA_HOME" >/dev/null 2>&1 || {
  echo "saga_home=failed"
  echo "verdict=misread"
  echo "detail=saga_readme_untracked"
  exit 1
}
rg -q 'Season Close Narratives' "$SAGA_HOME" || {
  echo "saga_home=failed"
  echo "verdict=misread"
  echo "detail=saga_readme_shape"
  exit 1
}
echo "saga_home=honored"

# --- commence arc waymark chain (ordered saga beats) ---
# beat label - waymark path
BEATS_OK=0
BEATS_WANT=8
while IFS='|' read -r label path; do
  test -n "$label" || continue
  if git ls-files --error-unmatch "$path" >/dev/null 2>&1; then
    echo "saga_beat_${label}=present"
    BEATS_OK=$((BEATS_OK + 1))
  else
    echo "saga_beat_${label}=ABSENT"
    echo "saga_chain=failed"
    echo "verdict=misread"
    echo "detail=missing_${path}"
    exit 1
  fi
done <<'BEATS'
M1|waymarks/date/20260731/20260731-014410_commence-m1-census-green.md
M2|waymarks/date/20260731/20260731-020306_commence-m2-glow-rune-census-green.md
e93|waymarks/date/20260731/20260731-114927_e93-ironbeetle-ep044-ch7-open-green.md
e94|waymarks/date/20260731/20260731-115725_e94-ironbeetle-ep045-green.md
M4b|waymarks/date/20260731/20260731-120704_e95-census-control-ch7-green.md
M5|waymarks/date/20260731/20260731-122009_e96-commence-m5-recut-green.md
M6|waymarks/date/20260731/20260731-124325_e97-commence-m6-see-green.md
M7|waymarks/date/20260731/20260731-124815_e98-commence-m7-shed-weave-green.md
BEATS

if test "$BEATS_OK" -ne "$BEATS_WANT"; then
  echo "saga_chain=failed"
  echo "verdict=misread"
  echo "detail=want_${BEATS_WANT}_beats"
  exit 1
fi
echo "saga_chain=honored"
echo "saga_beats=${BEATS_OK}"

# --- almanac seats 97-102 - ch7 at least 6/16 ---
if ! test -f "$ALMANAC"; then
  echo "saga_almanac=failed"
  echo "verdict=absent"
  exit 1
fi
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*)
    echo "saga_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_saga_edge"
    echo "detail_line=$CH7_LINE"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "saga_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_ch7_header"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "saga_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "saga_almanac=honored"
echo "saga_ch7_line=$CH7_LINE"
echo "saga_seats=97-102"

# --- IronBeetle shelf end (invent none) ---
EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "saga_shelf=failed"
  echo "verdict=misread"
  echo "detail=ep045_absent"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "saga_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "saga_shelf=honored"
echo "saga_shelf_end=ep045"
echo "saga_ep046=absent"

# --- inventory behind control ---
MD=$(git ls-files '*.md' | wc -l | tr -d ' ')
CACHE=$(git ls-files 'glow/.cache/*' | wc -l | tr -d ' ')
echo "inv_md=$MD"
echo "inv_glow_cache_tracked=$CACHE"
if test "$CACHE" -ne 0 || test "$MD" -lt 1; then
  echo "inventory=failed"
  echo "verdict=misread"
  exit 1
fi
echo "inventory=honored"

# Ordered saga line (measured presence only -- not invention)
echo "saga_story=M1-census>M2-rune>e93-ep044>e94-ep045>M4b-control>M5-run>M6-see>M7-weave"
echo "m8_saga=ok"
echo "verdict=ok"
