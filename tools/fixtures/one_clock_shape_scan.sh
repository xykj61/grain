#!/bin/sh
# one_clock_shape_scan.sh — living dated filenames must match ^YYYYMMDD-HHMMSS_
set -eu
bad=0
for d in session-logs waymarks counsel foundations counsel/replies; do
  test -d "$d" || continue
  for f in "$d"/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-*; do
    test -e "$f" || continue
    base=$(basename "$f")
    echo "$base" | grep -Eq '^[0-9]{8}-[0-9]{6}_' && continue
    echo "SHAPE_BAD $base"
    bad=1
  done
done
if test "$bad" = "0"; then
  echo SHAPE_OK
fi
exit 0
