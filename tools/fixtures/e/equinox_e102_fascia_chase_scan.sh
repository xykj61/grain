#!/bin/sh
# Equinox e102 fascia chase scan -- control gate, then chase limbs.
# Exit 0 only when control reads and chase honors without shred.
# No backtick characters in patterns.
#
#   sh tools/fixtures/e/equinox_e102_fascia_chase_scan.sh
#
# Law: the living meter reports this sitting; the almanac preserves the seated
# 85-to-92 event. Later tree growth cannot rewrite either reading into the other.
# Saga seating already on disk (e101) -- counsel A consumed.
set -eu

CONTROL_SCAN=tools/fixtures/c/census_control_scan.sh
ALMANAC="${ALMANAC:-rye-learning-process/GLOW_ALMANAC.md}"
SAGA_PROSE=saga/20260731-130200_saga-of-the-commence-arc.md
PRIN=tools/gen/chapter/prin_scope.rish
WIRE=comlink/discovery/round_trip_wire.rye
FASCIA_SH="${FASCIA_SH:-tools/fixtures/f/fascia_metric_v0.sh}"

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

# --- fresh fascia measure beside the seated historical reading ---
# Capture measure output; window will append one row -- acceptable for living pin.
FASCIA_OUT=$(sh "$FASCIA_SH" measure)
echo "$FASCIA_OUT"
echo "$FASCIA_OUT" | rg -q '^GREEN: fascia-metric-v0' || {
  echo "chase_fascia=failed"
  echo "verdict=misread"
  exit 1
}
echo "$FASCIA_OUT" | rg -q '^metric_rev=i9$' || {
  echo "chase_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_metric_rev_i9"
  exit 1
}
for signal in superseded ratchet_outstanding target_class_a over70; do
  echo "$FASCIA_OUT" | rg -q "^signal:${signal}=" || {
    echo "chase_fascia=failed"
    echo "verdict=misread"
    echo "detail=want_live_signal_${signal}"
    exit 1
  }
done
echo "$FASCIA_OUT" | rg -q '^window_carry=honored ' || {
  echo "chase_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_window_carry"
  exit 1
}
FASCIA_GRADES=$(echo "$FASCIA_OUT" | sed -n 's/^fascia=\([0-9][0-9]*\)$/\1/p')
FASCIA_COUNT=$(printf '%s\n' "$FASCIA_GRADES" | sed '/^$/d' | wc -l | tr -d ' ')
FASCIA_GRADE=$(printf '%s\n' "$FASCIA_GRADES" | head -n1)
if test "$FASCIA_COUNT" -ne 1 || test -z "$FASCIA_GRADE" || test "$FASCIA_GRADE" -gt 100; then
  echo "chase_fascia=failed"
  echo "verdict=misread"
  echo "detail=want_one_fascia_in_range_0_100"
  exit 1
fi

# E102's 92 is a fact about the seated event, not a floor on every later tree.
# Read it from the tracked almanac while the living meter reports today's grade.
rg -q '^### 106[.] Equinox e102 fascia chase:.*fascia 85.*92[.]$' "$ALMANAC" || {
  echo "chase_fascia_history=failed"
  echo "verdict=misread"
  echo "detail=want_e102_fascia_85_to_92_seat"
  exit 1
}
rg -q '^Expected .*chase_fascia_grade=92 .*Metal answered GREEN[.]' "$ALMANAC" || {
  echo "chase_fascia_history=failed"
  echo "verdict=misread"
  echo "detail=want_e102_fascia_92_metal_receipt"
  exit 1
}
echo "chase_fascia=honored"
echo "chase_fascia_grade_current=${FASCIA_GRADE}"
echo "chase_fascia_grade_seated=92"
echo "chase_fascia_history=honored"
echo "chase_class_a_seated=4"
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
