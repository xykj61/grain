#!/bin/sh
# Prove e102 keeps its seated fascia event without freezing the living meter.
# The welcome carries later clutter at grade 51. The two refusals plant an
# impossible current grade and remove the historical 85-to-92 receipt.
set -eu

SCAN=tools/fixtures/e/equinox_e102_fascia_chase_scan.sh
SOURCE_ALMANAC=rye-learning-process/GLOW_ALMANAC.md
PEN=$(mktemp -d "${TMPDIR:-/tmp}/grain-e102-fascia.XXXXXX")
trap 'rm -rf "$PEN"' EXIT HUP INT TERM

write_metric() {
  path=$1
  grade=$2
  {
    echo '#!/bin/sh'
    echo 'echo "metric_rev=i9"'
    echo 'echo "signal:superseded=34 penalty=17 weight=half"'
    echo 'echo "signal:ratchet_outstanding=2 penalty=8 weight=4"'
    echo 'echo "signal:target_class_a=5 penalty=10 weight=2"'
    echo 'echo "signal:over70=14 penalty=14 weight=1"'
    echo "echo \"fascia=${grade}\""
    echo 'echo "window_carry=honored window_seeded=0"'
    echo 'echo "GREEN: fascia-metric-v0 -- planted current reading"'
  } >"$path"
}

write_metric "$PEN/metric-51.sh" 51
write_metric "$PEN/metric-101.sh" 101
cp "$SOURCE_ALMANAC" "$PEN/almanac-good.md"
sed '/^### 106[.] Equinox e102 fascia chase:/s/fascia 85.*$/fascia history removed./' \
  "$SOURCE_ALMANAC" >"$PEN/almanac-no-history.md"

ALMANAC="$PEN/almanac-good.md" FASCIA_SH="$PEN/metric-51.sh" \
  sh "$SCAN" >"$PEN/welcome.out"
rg -q '^chase_fascia_grade_current=51$' "$PEN/welcome.out"
rg -q '^chase_fascia_grade_seated=92$' "$PEN/welcome.out"
rg -q '^chase_fascia_history=honored$' "$PEN/welcome.out"
rg -q '^verdict=ok$' "$PEN/welcome.out"

if ALMANAC="$PEN/almanac-good.md" FASCIA_SH="$PEN/metric-101.sh" \
  sh "$SCAN" >"$PEN/range-red.out" 2>&1; then
  echo "control: out-of-range current fascia was welcomed" >&2
  exit 1
fi
rg -q '^detail=want_one_fascia_in_range_0_100$' "$PEN/range-red.out"

if ALMANAC="$PEN/almanac-no-history.md" FASCIA_SH="$PEN/metric-51.sh" \
  sh "$SCAN" >"$PEN/history-red.out" 2>&1; then
  echo "control: missing e102 history was welcomed" >&2
  exit 1
fi
rg -q '^detail=want_e102_fascia_85_to_92_seat$' "$PEN/history-red.out"

echo "GREEN: e102-fascia-chase control -- current 51 welcomed; current 101 and missing seated 92 refused."
