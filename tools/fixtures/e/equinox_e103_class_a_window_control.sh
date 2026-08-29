#!/bin/sh
# Prove e103 keeps its seated refinement without freezing the living meter.
# The welcome carries later clutter at grade 51. The two refusals plant an
# impossible current grade and remove the historical 92-to-100 receipt.
set -eu

SCAN=tools/fixtures/e/equinox_e103_class_a_window_scan.sh
SOURCE_ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PEN=$(mktemp -d "${TMPDIR:-/tmp}/grain-e103-fascia.XXXXXX")
trap 'rm -rf "$PEN"' EXIT HUP INT TERM

write_metric() {
  file=$1
  grade=$2
  {
    echo '#!/bin/sh'
    echo 'echo "baseline_kind=window_min"'
    echo 'echo "delta_vs_mean=-31"'
    echo "echo \"fascia=${grade}\""
    echo 'echo "GREEN: fascia-metric-v0 -- planted current reading"'
  } >"$file"
}

write_metric "$PEN/metric-51.sh" 51
write_metric "$PEN/metric-101.sh" 101
cp "$SOURCE_ALMANAC" "$PEN/almanac-good.md"
sed '/^### 107[.] Equinox e103 Class A refine/s/fascia 92.*$/fascia history removed./' \
  "$SOURCE_ALMANAC" >"$PEN/almanac-no-history.md"

ALMANAC="$PEN/almanac-good.md" FASCIA_SH="$PEN/metric-51.sh" \
  sh "$SCAN" >"$PEN/welcome.out"
rg -q '^refine_fascia_grade_current=51$' "$PEN/welcome.out"
rg -q '^refine_fascia_grade_seated=100$' "$PEN/welcome.out"
rg -q '^refine_fascia_history=honored$' "$PEN/welcome.out"
rg -q '^verdict=ok$' "$PEN/welcome.out"

if ALMANAC="$PEN/almanac-good.md" FASCIA_SH="$PEN/metric-101.sh" \
  sh "$SCAN" >"$PEN/range-red.out" 2>&1; then
  echo "control: out-of-range current fascia was welcomed" >&2
  exit 1
fi
rg -q '^detail=want_one_fascia_in_range_0_100$' "$PEN/range-red.out"

if ALMANAC="$PEN/almanac-no-history.md" FASCIA_SH="$PEN/metric-51.sh" \
  sh "$SCAN" >"$PEN/history-red.out" 2>&1; then
  echo "control: missing e103 history was welcomed" >&2
  exit 1
fi
rg -q '^detail=want_e103_fascia_92_to_100_seat$' "$PEN/history-red.out"

echo "GREEN: e103-class-a-window control -- current 51 welcomed; current 101 and missing seated 100 refused."
