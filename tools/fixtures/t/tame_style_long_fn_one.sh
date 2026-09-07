#!/bin/sh
# tame_style_long_fn_one.sh -- >70-line fn ledger for one .rye file (awk seam).
#
# A function runs from its `fn` line to the line whose closing brace returns the brace depth to the
# depth that line opened at. Depth is read from CODE alone: a brace inside a line comment, a string
# literal, a char literal, or a Zig multiline-string line never moves it.
#
# WHY DEPTH RATHER THAN A CLOSING-BRACE PATTERN (REDS %519). The elder awk ended a function at the
# first line matching `^}$` or `^    }$`. The second alternative was written for a struct method,
# whose own body closes at four spaces -- yet applied to a free function it matches the closing
# brace of that function's FIRST `if` block, which sits at exactly four spaces too. Its start
# pattern `^( *)?(pub )?fn ` matched any INDENTED `fn ` as well, so an inline comparator or a nested
# struct method zeroed the enclosing count. Both holes fail OPEN: the ledger reads clean.
#
# Measured over the roster's 611 authored files on `20260906.173013`: the elder awk reported **15**
# functions past 70 lines and **321** stand; its longest read 180 lines where the true extent of
# `caravan/farewell.rye:check_suffice_runs` is **809** (line 10768 to 11576, counted by hand). Every
# function it did find is still found here, each at a longer and truer count.
#
# Output format is unchanged, because `tame_style_long_fn.rish` ranks it with `sort -t= -k2 -rn`.
f="$1"
[ -n "${f:-}" ] && [ -f "$f" ] || exit 0
awk -v F="$f" -v MAX_FN_LINES=4096 '
# strip -- return the line with every comment, string, and char literal removed, so only code
# braces reach the depth. A character scan rather than a regex sweep: `"{"` and `'"'"'}'"'"' are both
# common in this tree and a regex that handles one mishandles the other.
function strip(s,   out, i, c, n, inq, inc) {
    out = ""; n = length(s); inq = 0; inc = 0
    for (i = 1; i <= n; i++) {
        c = substr(s, i, 1)
        if (inq == 0 && inc == 0) {
            if (c == "/" && substr(s, i + 1, 1) == "/") break
            if (c == "\"") { inq = 1; continue }
            if (c == "'"'"'") { inc = 1; continue }
            out = out c
        } else if (inq == 1) {
            if (c == "\\") { i++; continue }
            if (c == "\"") inq = 0
        } else {
            if (c == "\\") { i++; continue }
            if (c == "'"'"'") inc = 0
        }
    }
    return out
}
{
    # a Zig multiline-string line is string content whole, braces and all
    if ($0 ~ /^[ \t]*\\\\/) code = ""; else code = strip($0)
    opens = gsub(/\{/, "{", code)
    closes = gsub(/\}/, "}", code)

    # a function starts only when no function is already open, so a nested `fn` counts inside its
    # parent rather than replacing it
    if (!infn && !pending && code ~ /(^|[^A-Za-z0-9_])fn[ \t]+[A-Za-z_]/) {
        pending = 1; n = 0; start = depth
        name = code; sub(/\(.*/, "", name); sub(/.*fn[ \t]+/, "", name)
        gsub(/^[ \t]+|[ \t]+$/, "", name)
    }
    if (pending || infn) n++
    depth += opens - closes

    if (pending) {
        # the body opened, so the count is real
        if (depth > start) { pending = 0; infn = 1 }
        # a declaration with no body -- `extern fn read(...) usize;` -- counts nothing
        else if (code ~ /;[ \t]*$/) { pending = 0; n = 0 }
    } else if (infn && depth <= start && closes > 0) {
        if (n > 70) printf "  %s: %s = %d lines\n", F, name, n
        infn = 0
    }

    # bound: no function in this tree runs past 4096 lines -- five times the longest measured (809),
    # rounded to a power of two -- so a file whose braces never balance says so rather than counting
    # silently to its end
    if (infn && n > MAX_FN_LINES) { printf "  %s: %s = OVER-BOUND at %d lines\n", F, name, n; infn = 0 }
}
' "$f" 2>/dev/null
