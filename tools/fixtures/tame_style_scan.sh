#!/bin/sh
# tame_style_scan.sh -- textual TAME lint over authored .rye (mode router).
#
# Bans fail; advisories print ratchet counts. Native router:
#   rishi/bin/rishi run tools/t/tame_style_scan.rish [bans|advise|bans-legacy|advise-legacy]
#
# Scan roster: mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke image mikrophone rye/src
# plus Glow TAME surfaces: tokens - lower_named_cast (STOA86-87) on the 256 roster;
# lower_shape (STOA96) - lower_shop_gate (STOA105) - lower_shop_nest (STOA117) ride one-file ban overflow seats + width-check.
# Law detail: tools/t/tame_style_scan_bans.rish - tools/t/tame_style_scan_advise.rish - context/TAME_GUIDANCE.md

MODE="${1:-bans}"
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
exec "$ROOT/rishi/bin/rishi" run tools/t/tame_style_scan.rish "$MODE"
