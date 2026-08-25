#!/bin/sh
# one_clock_zone_scan.sh -- host zone equals declared canonical zone by NAME.
# Compare IANA path names, never numeric offsets (DST-safe).
set -eu
want=$(head -1 tools/fixtures/one_clock_canonical_zone.txt)
test -n "$want"

# Prefer /etc/localtime target; also accept TZ env when it names the zone.
link=$(readlink -f /etc/localtime 2>/dev/null || true)
tz_env=${TZ:-}

echo "ZONE_WANT $want"
echo "ZONE_LOCALTIME $link"
echo "ZONE_TZ ${tz_env:-empty}"

ok=0
case "$link" in
  */"$want") ok=1 ;;
esac
if test "$tz_env" = "$want"; then
  ok=1
fi

if test "$ok" = "1"; then
  echo ZONE_OK
else
  echo "ZONE_BAD host does not name $want"
fi
exit 0
