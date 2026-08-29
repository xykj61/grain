#!/bin/sh
# one_clock_zone_scan.sh -- host zone equals declared canonical zone by NAME.
# Compare IANA path names, never numeric offsets (DST-safe).
set -eu
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

want=$(head -1 tools/fixtures/o/one_clock_canonical_zone.txt)
test -n "$want"

# Prefer /etc/localtime target; also accept TZ env when it names the zone. The target is resolved
# through `resolve_path` rather than `readlink -f`, because this guard stands on both piers and BSD
# readlink carried no `-f` for most of its life -- an unresolved link reads as an empty zone, and an
# empty zone compares unequal to every real one, so the guard would refuse on the second bench for a
# reason having nothing to do with the clock (the family REDS %234 and %250 booked).
link=$(resolve_path /etc/localtime 2>/dev/null || true)
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
