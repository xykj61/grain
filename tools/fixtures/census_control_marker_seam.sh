#!/bin/sh
# Census control — marker stamp seam (POSIX). One duty body.
# No backtick characters in patterns.
#
#   sh tools/fixtures/census_control_marker_seam.sh
set -eu

MARKER=tools/fixtures/census_control_marker.md

if ! test -f "$MARKER"; then
  echo "CONTROL=ABSENT"
  echo "duty=marker_fixture"
  echo "verdict=absent"
  exit 1
fi

STAMP_VAL=$(sed -n 's/^current-as-of:[[:space:]]*//p' "$MARKER" | head -1 | tr -d '[:space:]')
if test -z "$STAMP_VAL"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=marker_stamp_missing"
  exit 1
fi
echo "duty2_stamp=${STAMP_VAL}"
case "$STAMP_VAL" in
  [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]) ;;
  *)
    echo "CONTROL=present"
    echo "verdict=misread"
    echo "detail=marker_stamp_shape"
    exit 1
    ;;
esac
echo "duty2=honored"
exit 0
