#!/bin/sh
# Zero-view scan -- a zero names the instrument's VIEW, never the world.
#
#   sh tools/fixtures/zero_view_scan.sh           # living green
#   sh tools/fixtures/zero_view_scan.sh prove-red # must exit 1
#
# Planted pair:
#   tools/fixtures/zero_view_control/view.tsv          -- empty view (window_n=0)
#   tools/fixtures/zero_view_control/view.tsv.pre_seed -- archived fall (85)
#
# Law: look where the thing would be before calling it gone.
# No backtick characters in patterns.
set -eu

VIEW=tools/fixtures/zero_view_control/view.tsv
ARCHIVE=tools/fixtures/zero_view_control/view.tsv.pre_seed
MODE=${1:-}

if ! test -f "$VIEW"; then
  echo "CONTROL=ABSENT"
  echo "duty=view_fixture"
  echo "verdict=absent"
  exit 1
fi
if ! test -f "$ARCHIVE"; then
  echo "CONTROL=ABSENT"
  echo "duty=archive_fixture"
  echo "verdict=absent"
  exit 1
fi

VIEW_N=$(awk -F'\t' 'NF >= 2 && $2 ~ /^[0-9]+$/ { n++ } END { print n+0 }' "$VIEW")
echo "view_n=${VIEW_N}"

ARCHIVE_N=$(awk -F'\t' 'NF >= 2 && $2 ~ /^[0-9]+$/ { n++ } END { print n+0 }' "$ARCHIVE")
echo "archive_n=${ARCHIVE_N}"
ARCHIVE_HAS_85=0
awk -F'\t' 'NF >= 2 && $2 == 85 { found = 1 } END { exit !found }' "$ARCHIVE" && ARCHIVE_HAS_85=1 || true
echo "archive_has_85=${ARCHIVE_HAS_85}"

# prove-red: treat view_n=0 as "the world cleared" without opening the archive
if test "$MODE" = "prove-red"; then
  echo "mode=view_zero_as_world_gone"
  echo "verdict=misread"
  echo "detail=zero_is_view_not_world"
  exit 1
fi

if test "$VIEW_N" != "0"; then
  echo "verdict=misread"
  echo "detail=want_empty_view_control"
  exit 1
fi
if test "$ARCHIVE_N" -lt 1; then
  echo "verdict=misread"
  echo "detail=want_archive_rows"
  exit 1
fi
if test "$ARCHIVE_HAS_85" != "1"; then
  echo "verdict=misread"
  echo "detail=want_archived_fall_85"
  exit 1
fi

echo "view_zero=honored"
echo "archive_open=honored"
echo "law=zero_is_instrument_view_never_world"
echo "zero_view=ok"
echo "verdict=ok"
