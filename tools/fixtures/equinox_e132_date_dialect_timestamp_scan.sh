#!/bin/sh
# Equinox e132 -- compact Last updated accepts full stamps - suite green - shred held.
# Exit 0 when dialect pattern widened, suite 10/10, REDS 44, 128 reserved.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e132_date_dialect_timestamp_scan.sh
#   sh tools/fixtures/equinox_e132_date_dialect_timestamp_scan.sh prove-red
#
# Law: an instrument that hardcodes a format ages when the format improves.
# Law: seat the suite; do not manufacture meters.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260801/20260801-001244_e132-date-dialect-timestamp.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
REDS=construction/REDS.md
SAFE=SAFE.md
E111=tools/fixtures/equinox_e111_date_dialect_scan.sh
DD=tools/fixtures/date_dialect_scan.sh
SUITE=tools/fixtures/instrument_suite_scan.sh
PRIN=tools/gen/season/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md

if test "$MODE" = "prove-red"; then
  echo "detail=RED_compact_rejects_full_stamp"
  echo "verdict=misread"
  exit 1
fi

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$COUNSEL" "$LEXICON" "$MAP" "$ITINERARY" "$REDS" "$SAFE" "$E111" "$DD" "$SUITE" "$PRIN"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Widened pattern present in both scans (source carries \\. inside the sh string)
rg -Fq '[0-9]{8}(\\.[0-9]{6})?' "$E111" "$DD" || {
  echo "pattern=failed"
  echo "detail=want_optional_seconds_in_compact_re"
  echo "verdict=misread"
  exit 1
}
echo "pattern=honored"
echo "compact_accepts=date_or_stamp"

# Living e111 + standing dialect green
E111_OUT=$(sh "$E111")
echo "$E111_OUT" | rg -q '^verdict=ok$' || {
  echo "e111=failed"
  echo "verdict=misread"
  exit 1
}
echo "$E111_OUT" | rg -q '^surface_count=6$' || {
  echo "e111=failed"
  echo "detail=want_surface_6"
  echo "verdict=misread"
  exit 1
}
echo "e111=honored"

DD_OUT=$(sh "$DD")
echo "$DD_OUT" | rg -q '^verdict=ok$' || {
  echo "date_dialect=failed"
  echo "verdict=misread"
  exit 1
}
echo "date_dialect=honored"

# Suite must be green (the reason this seat exists)
SUITE_OUT=$(sh "$SUITE")
echo "$SUITE_OUT" | rg -q '^verdict=ok$' || {
  echo "suite=failed"
  echo "verdict=misread"
  exit 1
}
echo "$SUITE_OUT" | rg -q '^pass=10$' || {
  echo "suite=failed"
  echo "detail=want_pass_10"
  echo "verdict=misread"
  exit 1
}
echo "$SUITE_OUT" | rg -q '^fail=0$' || {
  echo "suite=failed"
  echo "detail=want_fail_0"
  echo "verdict=misread"
  exit 1
}
echo "suite=honored"
echo "suite_pass=10"
echo "suite_fail=0"

# REDS 44
rg -q '^\| 44 \|' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_row_44"
  echo "verdict=misread"
  exit 1
}
rg -qi 'compact|timestamp|instrument|format' "$REDS" || {
  echo "reds=failed"
  echo "detail=want_instrument_lesson"
  echo "verdict=misread"
  exit 1
}
echo "reds=honored"
echo "reds_note=row_44_instrument_format_aged"

# Lexicon / counsel name the law
rg -qi 'compact Last updated|date or full stamp|hardcodes a format' "$LEXICON" "$COUNSEL" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

# SAFE empty named as load-bearing
rg -qi '0 of 64|Rows:\*\* 0|rows 0 of 64' "$SAFE" "$COUNSEL" "$ITINERARY" || {
  echo "safe=failed"
  echo "detail=want_empty_safe_named"
  echo "verdict=misread"
  exit 1
}
rg -qi 'load-bearing|oldness census' "$COUNSEL" "$ITINERARY" || {
  echo "safe=failed"
  echo "detail=want_load_bearing_named"
  echo "verdict=misread"
  exit 1
}
echo "safe=honored"
echo "safe_rows=0"
echo "safe_note=empty_load_bearing_for_shred"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$ITINERARY" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"

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

if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "detail=seat_128_must_stay_unspent"
  echo "verdict=misread"
  exit 1
fi
echo "almanac=honored"
echo "no_content_seat_claimed=honored"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"

echo "story=dialect_stamp>suite_10>reds_44>safe_empty>shred_held>128_reserved"
echo "verdict=ok"
