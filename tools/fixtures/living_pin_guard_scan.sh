#!/bin/sh
# Living-pin content guard — generic instrument (counsel prove · pier land).
# C1 emptied must be caught · C2 whole must read whole · roster pins non-empty.
# Over-bound is ADVISORY by design — emptied is loss; over-bound is tidy debt.
# No backtick characters. No git history walks. Runs on shallow roots.
#
#   sh tools/fixtures/living_pin_guard_scan.sh
#   sh tools/fixtures/living_pin_guard_scan.sh prove-red
#
# Law: a living pin may not go quietly to zero.
# Law: a witness must not depend on one bench's tools or on full history.
set -eu

MODE=${1:-}
ROSTER=tools/fixtures/living_pin_guard_roster.txt
C1=tools/fixtures/living_pin_control/emptied_pin_control.md
C2=tools/fixtures/living_pin_control/whole_pin_control.md
MAX_BYTES=24576

if test "$MODE" = "prove-red"; then
  if ! test -f "$C1"; then
    echo "detail=RED_C1_absent"
    echo "verdict=misread"
    exit 1
  fi
  C1_BYTES=$(wc -c < "$C1" | tr -d ' ')
  if test "$C1_BYTES" -ge 200; then
    echo "detail=RED_C1_not_empty"
    echo "verdict=misread"
    exit 1
  fi
  echo "OK C1-emptied  planted empty pin CAUGHT"
  echo "detail=RED_living_pin_emptied_caught"
  echo "pins_lost=1"
  echo "verdict=pin_lost"
  exit 1
fi

for p in "$ROSTER" "$C1" "$C2"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done

C1_BYTES=$(wc -c < "$C1" | tr -d ' ')
if test "$C1_BYTES" -ge 200; then
  echo "C1=failed"
  echo "detail=emptied_fixture_contaminated"
  echo "verdict=misread"
  exit 1
fi
echo "OK C1-emptied  planted empty pin CAUGHT"
echo "C1_bytes=$C1_BYTES"

C2_BYTES=$(wc -c < "$C2" | tr -d ' ')
if test "$C2_BYTES" -lt 100; then
  echo "C2=failed"
  echo "detail=whole_control_thin"
  echo "verdict=misread"
  exit 1
fi
rg -q 'Living pin' "$C2" || {
  echo "C2=failed"
  echo "detail=whole_control_header_missing"
  echo "verdict=misread"
  exit 1
}
echo "OK C2-whole    planted whole pin reads whole"
echo "C2_bytes=$C2_BYTES"

PIN_COUNT=0
PINS_LOST=0
PINS_OVER=0
while IFS="$(printf '\t')" read -r path min_bytes header bound_mode || test -n "${path:-}"; do
  case "$path" in
    ''|\#*) continue ;;
  esac
  PIN_COUNT=$((PIN_COUNT + 1))
  git ls-files --error-unmatch "$path" >/dev/null 2>&1 || {
    echo "pin $path  untracked"
    PINS_LOST=$((PINS_LOST + 1))
    continue
  }
  if ! test -f "$path"; then
    echo "pin $path  absent"
    PINS_LOST=$((PINS_LOST + 1))
    continue
  fi
  BYTES=$(wc -c < "$path" | tr -d ' ')
  if test "$BYTES" -lt "$min_bytes"; then
    echo "pin $path  emptied  $BYTES bytes"
    PINS_LOST=$((PINS_LOST + 1))
    continue
  fi
  if ! rg -q -F "$header" "$path"; then
    echo "pin $path  header_missing"
    PINS_LOST=$((PINS_LOST + 1))
    continue
  fi
  if test "$BYTES" -gt "$MAX_BYTES"; then
    echo "pin $path  $BYTES whole over_bound"
    PINS_OVER=$((PINS_OVER + 1))
  else
    echo "pin $path  $BYTES whole"
  fi
done < "$ROSTER"

echo "pins_lost=$PINS_LOST"
echo "pins_over_bound=$PINS_OVER"
echo "pin_count=$PIN_COUNT"
echo "over_bound=advisory"
echo "living_pin_max_bytes=$MAX_BYTES"
echo "history_independence=honored"

if test "$PINS_LOST" -ne 0; then
  echo "verdict=pin_lost"
  exit 1
fi
echo "verdict=pins_whole"
