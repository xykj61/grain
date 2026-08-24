#!/bin/sh
# one_clock_shape_scan.sh -- a living dated filename opens with a whole stamp: YYYYMMDD-HHMMSS,
# then either an underscore and a sprig or the extension directly. The session-logs law makes the
# sprig OPTIONAL -- it is added when two logs share a second -- and 237 tracked logs carry none,
# so a pattern requiring the underscore reads every one of them as a shape fault (REDS %175).
set -eu
bad=0
for d in session-logs waymarks counsel foundations counsel/replies; do
  test -d "$d" || continue
  for f in "$d"/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-*; do
    test -e "$f" || continue
    base=$(basename "$f")
    echo "$base" | grep -Eq '^[0-9]{8}-[0-9]{6}(_|\.)' && continue
    echo "SHAPE_BAD $base"
    bad=1
  done
done
if test "$bad" = "0"; then
  echo SHAPE_OK
fi
exit 0
