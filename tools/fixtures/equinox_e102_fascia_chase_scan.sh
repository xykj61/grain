#!/bin/sh
# Equinox e102 fascia chase scan -- control gate, then chase limbs.
# Exit 0 only when control reads and chase honors without shred.
# No backtick characters in patterns.
#
#   sh tools/fixtures/equinox_e102_fascia_chase_scan.sh
#
# Law: re-cut meters this sitting; Class A paper lean held (u89).
# Saga seating already on disk (e101) -- counsel A consumed.
set -eu

CONTROL_SCAN=tools/fixtures/census_control_scan.sh
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
SAGA_PROSE=saga/20260731-130200_saga-of-the-commence-arc.md
PRIN=tools/gen/season/prin_scope.rish
WIRE=comlink/discovery/round_trip_wire.rye
FASCIA_SH=tools/fixtures/fascia_metric_v0.sh

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

# --- saga already Seated (fuse: counsel A consumed on Framework e101) ---
git ls-files --error-unmatch "$SAGA_PROSE" >/dev/null 2>&1 || {
  echo "chase_saga=failed"
  echo "verdict=misread"
  exit 1
}
rg -q '\*\*Seated\*\* `20260731.131240`' "$SAGA_PROSE" || {
  echo "chase_saga=failed"
  echo "verdict=misread"
  echo "detail=want_saga_seated"
  exit 1
}
echo "chase_saga=honored"
echo "chase_saga_status=SEATED"
echo "chase_saga_note=counsel_A_consumed_e101"

# --- memcpy app site migrated ---
rg -q 'tally_copy.copy_disjoint\(u8, buf\[0\.\.joined\.len\], joined\)' "$WIRE" || {
  echo "chase_memcpy=failed"
  echo "verdict=misread"
  echo "detail=want_copy_disjoint_own_path"
  exit 1
}
if rg -q '@memcpy\(' "$WIRE"; then
  echo "chase_memcpy=failed"
  echo "verdict=misread"
  echo "detail=bare_memcpy_remains_in_wire"
  exit 1
fi
echo "chase_memcpy=honored"

# --- fresh fascia measure (must not append-only trust; re-run instrument) ---
# Capture measure output; window will append one row -- acceptable for living pin.
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "chase_fascia=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'memcpy_app=0' || {
  echo "chase_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_memcpy_app_0"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'signal:superseded=0' || {
  echo "chase_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_signal1_zero"
  exit 1
}
echo "$FASCIA_OUT" | rg -q -F 'signal:ratchet_outstanding=0' || {
  echo "chase_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_ratchet_zero"
  exit 1
}
# e102 chase floor: fascia >= 92. Later i7 may raise grade further (elder stays green).
FASCIA_GRADE=$(echo "$FASCIA_OUT" | rg -o 'fascia=[0-9]+' | head -n1 | cut -d= -f2)
if test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -lt 92; then
  echo "chase_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_fascia_at_least_92"
  exit 1
fi
echo "chase_fascia=honored"
echo "chase_fascia_grade=${FASCIA_GRADE}"
echo "chase_class_a_floor=held_or_refined"
echo "chase_class_a_law=u89_paper_then_hold_or_refine"

# --- fork still unconsumed ---
if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "chase_fork=failed"
  echo "verdict=misread"
  echo "detail=nested_handback_must_stay_unconsumed"
  exit 1
fi
rg -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "chase_fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "chase_fork=honored"
echo "chase_fork_status=not_consumed"

# --- almanac seats 97-105 - ch7 at least 9/16 ---
CH7_LINE=$(rg -n '^## Chapter Seven \([0-9]+ of 16\)$' "$ALMANAC" | head -n1 || true)
case "$CH7_LINE" in
  *"Chapter Seven (1 of 16)"*|*"Chapter Seven (2 of 16)"*|*"Chapter Seven (3 of 16)"*|*"Chapter Seven (4 of 16)"*|*"Chapter Seven (5 of 16)"*|*"Chapter Seven (6 of 16)"*|*"Chapter Seven (7 of 16)"*|*"Chapter Seven (8 of 16)"*)
    echo "chase_almanac=failed"
    echo "verdict=misread"
    echo "detail=ch7_below_chase_edge"
    exit 1
    ;;
  *"Chapter Seven ("*)
    ;;
  *)
    echo "chase_almanac=failed"
    echo "verdict=misread"
    exit 1
    ;;
esac
for n in 97 98 99 100 101 102 103 104 105; do
  rg -q "^### ${n}\\." "$ALMANAC" || {
    echo "chase_almanac=failed"
    echo "verdict=misread"
    echo "detail=want_seat_${n}"
    exit 1
  }
done
echo "chase_almanac=honored"
echo "chase_ch7_line=$CH7_LINE"
echo "chase_seats=97-105"

# --- shelf end - shred ---
EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "chase_shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "chase_shelf=failed"
  echo "verdict=misread"
  echo "detail=invented_ep046_refused"
  exit 1
fi
echo "chase_shelf=honored"
echo "chase_shelf_end=ep045"
echo "shred=RED"

echo "chase_story=saga_SEATED>memcpy_cleared>signal1_cleared>class_a_paper_held>fascia_92>fork_waiting"
echo "e102_fascia_chase=ok"
echo "verdict=ok"
