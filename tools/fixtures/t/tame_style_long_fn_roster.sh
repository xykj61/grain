#!/bin/sh
# tame_style_long_fn_roster.sh -- authored .rye roster for >70-line ledger.
# THE ROOMS COME FROM ONE FILE, from 20260908 -- tools/fixtures/t/tame_style_rooms.txt. This was
# the fifth inline copy of one list, and it named five glow FILES where the bans half named the
# whole room, so the >70-line ledger measured a population no other TAME reading shared.
find $(grep -v '^#' tools/fixtures/t/tame_style_rooms.txt | grep -v '^$') \
    -name "*.rye" ! -type l ! -path '*/.cache/*' ! -path '*/bin/*' 2>/dev/null
