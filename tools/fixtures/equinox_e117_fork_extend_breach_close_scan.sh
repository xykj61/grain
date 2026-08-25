#!/bin/sh
# Equinox e117 -- fork EXTEND +128 - census breach closed unspent.
# Exit 0 only when control reads and decision limbs honor.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e117_fork_extend_breach_close_scan.sh
#   sh tools/fixtures/equinox_e117_fork_extend_breach_close_scan.sh prove-red
#
# Law: approve-all seats recommended yes/no leans; hard lines still refuse shred.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
MUSEUM=tools/fixtures/baton_museum_census_scan.sh
COUNSEL=counsel/date/20260731/20260731-170354_e117-fork-extend-breach-let-close.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
ELDER=tools/gen/season/equinox_e116_dated_one_definition_witness.rish
CLASSIFY=tools/fixtures/dated_classify.py

if test "$MODE" = "prove-red"; then
  echo "fork=EXTEND"
  echo "breach=closed_unspent"
  echo "handback=CONSUMED"
  echo "detail=RED_approve_all_consumed_handback"
  echo "census=withheld"
  echo "verdict=misread"
  exit 1
fi

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

for p in "$COUNSEL" "$MAP" "$ITINERARY" "$PRIN" "$ELDER" "$CLASSIFY"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    if test -f "$p"; then
      echo "instrument=failed"
      echo "verdict=misread"
      echo "detail=on_disk_is_not_in_the_tree"
      echo "detail_path=$p"
      exit 1
    fi
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=control_absent"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

MUSEUM_OUT=$(sh "$MUSEUM")
echo "$MUSEUM_OUT" | sed 's/^/museum_/'
echo "$MUSEUM_OUT" | rg -q '^verdict=ok$' || {
  echo "museum=failed"
  echo "verdict=misread"
  exit 1
}
echo "$MUSEUM_OUT" | rg -q '^census_breach_count=0$' || {
  echo "museum=failed"
  echo "verdict=misread"
  echo "detail=want_breach_count_0"
  exit 1
}
echo "museum=honored"
echo "census_breach_count=0"

rg -qi 'THE FORK.*EXTEND|fork.*EXTEND \+128|Fork EXTEND' "$COUNSEL" || {
  echo "fork=failed"
  echo "verdict=misread"
  echo "detail=want_fork_extend_in_counsel"
  exit 1
}
rg -qi 'not consumed|not_consumed|held · not consumed' "$COUNSEL" || {
  echo "fork=failed"
  echo "verdict=misread"
  echo "detail=want_handback_not_consumed"
  exit 1
}
if rg -qi 'return_surface_p59 CONSUMED' "$COUNSEL"; then
  echo "fork=failed"
  echo "verdict=misread"
  echo "detail=handback_must_not_be_consumed_on_extend"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
rg -qi 'fork EXTEND|EXTEND \+128 seated|fork \*\*EXTEND' "$ITINERARY" "$MAP" "$PRIN" || {
  echo "fork=failed"
  echo "verdict=misread"
  echo "detail=want_extend_in_living_pins"
  exit 1
}
echo "fork=honored"
echo "fork_word=EXTEND"
echo "fork_extend=+128"
echo "handback_status=not_consumed"

rg -qi 'let close|closed unspent|closed_unspent' "$COUNSEL" || {
  echo "breach=failed"
  echo "verdict=misread"
  echo "detail=want_let_close_in_counsel"
  exit 1
}
rg -qi 'closed unspent|breach.*let.close|census breach.*closed' "$ITINERARY" "$MAP" || {
  echo "breach=failed"
  echo "verdict=misread"
  echo "detail=want_closed_unspent_in_pins"
  exit 1
}
echo "breach=honored"
echo "breach_word=let_close"
echo "breach_status=closed_unspent"

rg -qi 'APPROVED.*GATED|GATED' "$COUNSEL" "$ITINERARY" || {
  echo "geode=failed"
  echo "verdict=misread"
  exit 1
}
if rg -qi 'geode expedition.*BEGUN|expedition BEGIN' "$COUNSEL" "$ITINERARY"; then
  echo "geode=failed"
  echo "verdict=misread"
  echo "detail=geode_must_stay_gated"
  exit 1
fi
echo "geode=honored"
echo "geode_status=APPROVED_GATED"

rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

# surface census six (e119 ch5+ch6 tools; elder four is historical)
COUNT=$(git ls-files 'tools/gen/season/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$COUNT" -ne 6; then
  echo "surface_keep=failed"
  echo "verdict=misread"
  echo "detail=want_surface_count_6"
  echo "surface_count=${COUNT}"
  exit 1
fi
echo "surface_keep=honored"
echo "surface_count=6"

git ls-files --error-unmatch "$ELDER" >/dev/null 2>&1 || {
  echo "elder=failed"
  echo "verdict=misread"
  exit 1
}
git ls-files --error-unmatch "$CLASSIFY" >/dev/null 2>&1 || {
  echo "roof_reco=failed"
  echo "verdict=misread"
  exit 1
}
echo "elder=honored"
echo "elder_seat=e116"
echo "roof_recommendation=honored"
echo "roof_note=e116_one_dated_definition_already_green"

rg -q '^### 120\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=120"

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

rg -qi 'shred \*\*RED\*\*|shred \| RED \||shred=RED|shred RED' "$COUNSEL" || {
  echo "shred=failed"
  echo "verdict=misread"
  echo "detail=want_shred_RED_in_counsel"
  exit 1
}
# Refuse if counsel claims shred was performed (fixed strings; no soft yes-match)
if rg -F 'shred lap PERFORMED' "$COUNSEL" \
  || rg -F 'Class O path rows SEATED' "$COUNSEL" \
  || rg -F 'shred: YES' "$COUNSEL"; then
  echo "shred=failed"
  echo "verdict=misread"
  echo "detail=approve_all_must_not_shred"
  exit 1
fi
echo "shred=RED"
echo "shred_status=refused_despite_approve_all"

echo "story=fork_EXTEND>breach_closed_unspent>roofs_e116>128_reserved>geode_gated>shred_RED"
echo "e117_fork_extend_breach_close=ok"
echo "verdict=ok"
