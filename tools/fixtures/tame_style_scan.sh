#!/bin/sh
# tame_style_scan.sh — textual TAME lint over authored .rye (mode router).
#
# Bans fail; advisories print ratchet counts. Native router:
#   rishi/bin/rishi run tools/tame_style_scan.rish [bans|advise|bans-legacy|advise-legacy]
#
# Scan roster: mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke rye/src.
# Law detail: tools/tame_style_scan_bans.rish · tools/tame_style_scan_advise.rish · context/TAME_GUIDANCE.md

MODE="${1:-bans}"
exec "$(dirname "$0")/../../rishi/bin/rishi" run tools/tame_style_scan.rish "$MODE"
