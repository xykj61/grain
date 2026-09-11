#!/bin/sh
# one_clock_population_control.sh -- does the false-future gate REACH a folded shelf?
#
# Duty 5 (tools/fixtures/o/one_clock_head_scan.sh) refuses a stamp written ahead
# of the live clock, and its two fixtures pass the stamp in through
# ONE_CLOCK_HEAD_STAMPS. That environment variable bypasses the population walk
# entirely, so both fixtures proved the PREDICATE and neither proved the REACH --
# which is how a flat glob came to read 247 of 7,344 dated artifacts (3.4%,
# measured 20260911.020039) under a green witness. A session log is born on its
# day shelf from 20260827.171500, so the room the gate was built for contributed
# nothing at all.
#
# This control plants a real file in a real directory and runs the real scans
# over it, so the population is what is on trial rather than the comparison.
#
# Legs, each proven from both sides:
#   1  a clean pen reads green
#   2  a four-hours-ahead log BORN ON ITS DAY SHELF reds duty 5
#   3  the same log SPRIGLESS on the shelf reds duty 5 (the sprig is optional --
#      237 dated files carry a stamp and none, the REDS %175 shape)
#   4  a folded shelf under another room -- counsel/date -- reds duty 5
#   5  removing the plant returns the pen to green, so the red was the plant
#   6  the head the gate names is the NEWEST stamp, shelf included
set -eu

_root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

mkdir -p "$pen/rishi/bin" "$pen/tools/fixtures/o" "$pen/tools/fixtures/s" \
         "$pen/session-logs/date/20260911" "$pen/counsel/date/20260911" "$pen/foundations"
cp "$_root/tools/fixtures/o/one_clock_mono_scan.sh" "$pen/tools/fixtures/o/"
cp "$_root/tools/fixtures/o/one_clock_head_scan.sh" "$pen/tools/fixtures/o/"
cp "$_root/tools/fixtures/s/shell_portable.sh" "$pen/tools/fixtures/s/"
# The tree's own portable clock arithmetic, rather than GNU `date -d`: this pen must build the
# same two stamps on a BSD host, and shell_dialect gates a bare `date -d` at zero for that reason.
. "$_root/tools/fixtures/s/shell_portable.sh"
: > "$pen/tools/fixtures/o/one_clock_drift_erratum.txt"
: > "$pen/tools/fixtures/o/one_clock_head_erratum.txt"

# An honest past page, so the pen has a lawful head when nothing is planted.
past=$(TZ=America/New_York stamp_ahead -7200 | tr '.' '-')
touch "$pen/foundations/${past}_a-past-page.md"
ahead=$(TZ=America/New_York stamp_ahead 14400 | tr '.' '-')

legs=0
fails=0
leg() {
  legs=$((legs + 1))
  if [ "$1" = "$2" ]; then
    echo "leg_ok $3"
  else
    echo "leg_bad $3 -- wanted $2, read $1"
    fails=$((fails + 1))
  fi
}

head_verdict() {
  if ( cd "$pen" && sh tools/fixtures/o/one_clock_head_scan.sh >/dev/null 2>&1 ); then
    echo green
  else
    echo red
  fi
}
named_head() {
  ( cd "$pen" && sh tools/fixtures/o/one_clock_mono_scan.sh ) | sed -n 's/^TRUE_HEAD //p' | head -1
}

leg "$(head_verdict)" green "clean_pen_green"

shelf="$pen/session-logs/date/20260911/${ahead}_a-stamp-somebody-wrote.kyri"
touch "$shelf"
leg "$(head_verdict)" red "future_on_day_shelf_reds"
leg "$(named_head)" "$(printf '%s' "$ahead" | tr '-' '.')" "head_names_the_shelf_stamp"
rm -f "$shelf"

sprigless="$pen/session-logs/date/20260911/${ahead}.kyri"
touch "$sprigless"
leg "$(head_verdict)" red "sprigless_future_on_shelf_reds"
rm -f "$sprigless"

other="$pen/counsel/date/20260911/${ahead}_a-counsel-note.md"
touch "$other"
leg "$(head_verdict)" red "future_on_counsel_shelf_reds"
rm -f "$other"

leg "$(head_verdict)" green "plant_removed_returns_green"
leg "$(named_head)" "$(printf '%s' "$past" | tr '-' '.')" "head_falls_back_to_the_past_page"

echo "legs=$legs fails=$fails"
if [ "$fails" -ne 0 ]; then
  echo "control_verdict=fail"
  exit 1
fi
echo "control_verdict=ok"
