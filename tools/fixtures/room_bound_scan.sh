#!/bin/sh
# tools/fixtures/room_bound_scan.sh -- how many dated files stand flat in each room.
#
# WHY. A room that grows without a bound eventually stops being readable. GitHub's web listing
# stops at 1,000 entries, and `session-logs/` held 1,492 flat files on `20260821` -- genuinely
# unopenable in a browser. The fold to `date/YYYYMMDD/` fixed that room; this scan is what keeps
# it fixed, and what notices the next room before it crosses.
#
# THE BOUND IS 256, not 1,000. A bound placed AT the cliff is a bound that fails on the day it
# matters, and two hundred fifty-six is already past what a person scrolls. It is a power of two,
# which is this tree's own idiom for a named maximum.
#
# ROOMS ARE DISCOVERED, NOT LISTED. Every top-level directory holding at least one dated file at
# its own level is reported, so a room created tomorrow cannot escape the meter by not being
# named here. The roster then decides what happens:
#
#   ENFORCE -- over the bound is a RED. `session-logs` earned this on `20260821` by folding.
#   ADVISE  -- over the bound prints and books nothing. Every other room starts here, because a
#              ratchet turns on touch and a sweep nobody asked for is not a fix.
#
# `foundations/` is deliberately small and the most-cited room in the tree; folding it would
# break the most references for the least relief. It stays flat and stays advisory.
#
# USAGE
#   sh tools/fixtures/room_bound_scan.sh          # the roster, at the seated bound
#   sh tools/fixtures/room_bound_scan.sh 2        # a smaller bound, for proving the RED path
#
# Driven by tools/room_bound_witness.rish. Run from the repository root.

set -eu

BOUND="${1:-256}"
ENFORCE="session-logs"

echo "bound=$BOUND"

enforced_over=0
advised_over=0

for dir in */; do
  room="${dir%/}"
  case "$room" in .*|seed|vendor) continue ;; esac
  [ -d "$room" ] || continue

  flat=$(find "$room" -maxdepth 1 -type f -name '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]_*' 2>/dev/null | wc -l | tr -d ' ')
  [ "$flat" -gt 0 ] || continue

  roster=advise
  for e in $ENFORCE; do
    [ "$room" = "$e" ] && roster=enforce
  done

  if [ "$flat" -le "$BOUND" ]; then
    verdict=under
  else
    verdict=over
    if [ "$roster" = enforce ]; then
      enforced_over=$((enforced_over + 1))
    else
      advised_over=$((advised_over + 1))
    fi
  fi

  echo "room=$room flat=$flat verdict=$verdict roster=$roster"
done

echo "enforced_over=$enforced_over"
echo "advised_over=$advised_over"

if [ "$enforced_over" -eq 0 ]; then
  echo "verdict=ok"
else
  echo "verdict=over"
  exit 1
fi
