#!/bin/sh
# tame_style_scan_bans_legacy.sh -- original grep ban loop (parity diff only).
set -u
# THE ROOMS COME FROM ONE FILE, from 20260908 -- tools/fixtures/t/tame_style_rooms.txt, so this
# parity copy and the native half it checks can no longer read different populations. They already
# did: this list held eighteen rooms where the native half held twenty, missing `image/` and
# `mikrophone/` entirely, and the selftest stayed green because both answered zero.
FILES=$(find $(grep -v '^#' tools/fixtures/t/tame_style_rooms.txt | grep -v '^$') \
    -name "*.rye" ! -type l ! -path "*/.cache/*" ! -path "*/bin/*" 2>/dev/null)
fail=0
for pat in ") == error." ") != error." "std.debug.assert(" "Self = @This()" \
           "usingnamespace" "!comptime" "copyForwards" "copyBackwards" \
           "FIXME" "dbg("; do
    hits=$(grep -Hn -F "$pat" $FILES 2>/dev/null)
    if [ -n "$hits" ]; then
        echo "BAN [$pat]:"
        echo "$hits" | head -8
        fail=1
    fi
done
# The compound-assert check keeps the elder roster, and from 20260908 the reason is the PREDICATE
# rather than the population. Native deleted its second roster once every room reached zero; what
# stands apart here is the naive text grep below, which reads a string literal holding
# `pair.p == 5 and pair.q == 3` as a compound assert. Native blanks quoted content first (REDS
# %304), so widening this list would report false positives native correctly does not have. The
# elder claim that the seven rooms carry 104 compound asserts is superseded: native reads them as
# zero, over code rather than text.
COMPOUND_FILES=$(find mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke rye/src \
    glow/tokens.rye glow/lower_named_cast.rye \
    -name "*.rye" ! -type l 2>/dev/null)
compound=$(grep -Hn "assert(.* and .*)" $COMPOUND_FILES 2>/dev/null)
if [ -n "$compound" ]; then
    echo "BAN [compound assert — split so the failing half is named]:"
    echo "$compound" | head -8
    fail=1
fi
exit $fail
