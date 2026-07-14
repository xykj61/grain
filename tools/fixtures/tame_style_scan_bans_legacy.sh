#!/bin/sh
# tame_style_scan_bans_legacy.sh — original grep ban loop (parity diff only).
set -u
FILES=$(find mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke rye/src \
    -name "*.rye" ! -type l 2>/dev/null)
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
compound=$(grep -Hn "assert(.* and .*)" $FILES 2>/dev/null)
if [ -n "$compound" ]; then
    echo "BAN [compound assert — split so the failing half is named]:"
    echo "$compound" | head -8
    fail=1
fi
exit $fail
