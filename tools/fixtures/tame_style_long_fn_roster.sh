#!/bin/sh
# tame_style_long_fn_roster.sh — authored .rye roster for >70-line ledger.
find mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke rye/src \
    -name "*.rye" ! -type l 2>/dev/null
