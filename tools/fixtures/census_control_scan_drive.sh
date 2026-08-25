#!/bin/sh
# Census control -- shell drive of shared seams (Cloud / no-rishi benches).
# Preferred orchestration lives in census_control_scan.rish.
# Entry: tools/fixtures/census_control_scan.sh
#
#   sh tools/fixtures/census_control_scan_drive.sh
#   sh tools/fixtures/census_control_scan_drive.sh prove-red
set -eu

MODE=${1:-}
H1=tools/fixtures/census_control_h1_seam.sh
MARKER=tools/fixtures/census_control_marker_seam.sh
TRACKED=tools/fixtures/census_control_tracked_seam.sh

set +e
H1_OUT=$(sh "$H1")
H1_RC=$?
set -e
printf '%s\n' "$H1_OUT"
if test "$H1_RC" -ne 0; then
  exit 1
fi

if test "$MODE" = "prove-red"; then
  echo "duty1_mode=naive_as_total"
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=naive_total_refused"
  exit 1
fi

TRUE=$(printf '%s\n' "$H1_OUT" | sed -n 's/^duty1_h1_true=//p' | head -1)
NAIVE=$(printf '%s\n' "$H1_OUT" | sed -n 's/^duty1_h1_naive=//p' | head -1)
if test "$TRUE" != "1"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=h1_true_want_1"
  exit 1
fi
if test "$NAIVE" != "4"; then
  echo "CONTROL=present"
  echo "verdict=misread"
  echo "detail=h1_naive_want_4"
  exit 1
fi
echo "duty1=honored"

set +e
MARKER_OUT=$(sh "$MARKER")
MARKER_RC=$?
set -e
printf '%s\n' "$MARKER_OUT"
if test "$MARKER_RC" -ne 0; then
  exit 1
fi

set +e
TRACKED_OUT=$(sh "$TRACKED")
TRACKED_RC=$?
set -e
printf '%s\n' "$TRACKED_OUT"
if test "$TRACKED_RC" -ne 0; then
  exit 1
fi

echo "CONTROL=present"
echo "duties_honored=3"
echo "verdict=ok"
echo "orchestration=drive_sh"
exit 0
