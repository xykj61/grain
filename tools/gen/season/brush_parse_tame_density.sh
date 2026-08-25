#!/bin/sh
# brush_parse_tame_density.sh -- Surface p24 - living floor ≥20 invariant markers
# Kept as a tiny shell hand so rishi need not interpolate $vars inside sh -c.
set -eu
c=$(grep -c 'invariant:' brushstroke/brush_parse.rye)
if [ "$c" -ge 20 ]; then
  echo "INV_OK $c"
  exit 0
fi
echo "INV_LOW $c" >&2
exit 1
