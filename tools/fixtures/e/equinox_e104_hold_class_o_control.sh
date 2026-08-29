#!/bin/sh
# Prove e104 keeps its seated hold without freezing the living meter.
# The welcome carries current Class A 5 and fascia 51. The refusals plant an
# impossible current grade and remove the historical Class A 4, fascia 92 seat.
set -eu

SCAN=tools/fixtures/e/equinox_e104_hold_class_o_scan.sh
SOURCE_ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PEN=$(mktemp -d "${TMPDIR:-/tmp}/grain-e104-hold.XXXXXX")
trap 'rm -rf "$PEN"' EXIT HUP INT TERM

write_metric() {
  file=$1
  grade=$2
  {
    echo '#!/bin/sh'
    echo 'echo "metric_rev=i9"'
    echo 'echo "signal:target_class_a=5 penalty=10 weight=2"'
    echo 'echo "signal:class_a_held_disclosed=4 law=hold_not_exclude"'
    echo 'echo "baseline_kind=window_min"'
    echo "echo \"fascia=${grade}\""
    echo 'echo "GREEN: fascia-metric-v0 -- planted current reading"'
  } >"$file"
}

write_metric "$PEN/metric-51.sh" 51
write_metric "$PEN/metric-101.sh" 101
cp "$SOURCE_ALMANAC" "$PEN/almanac-good.md"
sed '/^### 108[.] Equinox e104 hold Class A disclosed/s/fascia 100.*$/fascia history removed./' \
  "$SOURCE_ALMANAC" >"$PEN/almanac-no-history.md"
cp construction/SHRED_PREP.md "$PEN/shred-prep-good.md"
sed 's/class\/rooms, not per-path/scope removed/' \
  construction/SHRED_PREP.md >"$PEN/shred-prep-no-scope.md"

ALMANAC="$PEN/almanac-good.md" FASCIA_SH="$PEN/metric-51.sh" \
  SHRED_PREP="$PEN/shred-prep-good.md" sh "$SCAN" >"$PEN/welcome.out"
rg -q '^hold_class_a_current=5$' "$PEN/welcome.out"
rg -q '^hold_class_a_seated=4$' "$PEN/welcome.out"
rg -q '^hold_fascia_grade_current=51$' "$PEN/welcome.out"
rg -q '^hold_fascia_grade_seated=92$' "$PEN/welcome.out"
rg -q '^hold_fascia_history=honored$' "$PEN/welcome.out"
rg -q '^verdict=ok$' "$PEN/welcome.out"

if ALMANAC="$PEN/almanac-good.md" FASCIA_SH="$PEN/metric-101.sh" \
  SHRED_PREP="$PEN/shred-prep-good.md" sh "$SCAN" >"$PEN/range-red.out" 2>&1; then
  echo "control: out-of-range current fascia was welcomed" >&2
  exit 1
fi
rg -q '^detail=want_one_fascia_in_range_0_100$' "$PEN/range-red.out"

if ALMANAC="$PEN/almanac-no-history.md" FASCIA_SH="$PEN/metric-51.sh" \
  SHRED_PREP="$PEN/shred-prep-good.md" sh "$SCAN" >"$PEN/history-red.out" 2>&1; then
  echo "control: missing e104 history was welcomed" >&2
  exit 1
fi
rg -q '^detail=want_e104_hold_100_to_92_seat$' "$PEN/history-red.out"

if ALMANAC="$PEN/almanac-good.md" FASCIA_SH="$PEN/metric-51.sh" \
  SHRED_PREP="$PEN/shred-prep-no-scope.md" sh "$SCAN" >"$PEN/scope-red.out" 2>&1; then
  echo "control: missing current Class O room scope was welcomed" >&2
  exit 1
fi
rg -q '^detail=want_class_o_room_scope$' "$PEN/scope-red.out"

echo "GREEN: e104-hold-class-o control -- current Class A 5 and fascia 51 welcomed; current 101, missing seated hold, and missing Class O room scope refused."
