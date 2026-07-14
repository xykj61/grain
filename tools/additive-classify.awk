# additive-classify.awk — classify diff lines for the additive gate.
#
# Reads a unified diff of rye/lib/ and prints only the lines that are
# NOT purely additive (not blank, not comment, not assertion, not maybe).
# If the output is empty, the pass is purely additive.

/^\+\+\+/ || /^---/ { next }
/^[+-]/ {
    sign = substr($0, 1, 1)
    body = substr($0, 2)
    t = body
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    if (t == "") next
    if (t ~ /^\/\//) next
    if (t ~ /^\*/ || t ~ /^\/\*/ || t ~ /\*\/$/) next
    sub(/^defer[ \t]+/, "", t)
    sub(/^comptime[ \t]+/, "", t)
    if (t ~ /^(std\.debug\.)?assert\(/) next
    if (t ~ /^(std\.debug\.)?maybe\(/) next
    printf("  %s %s\n", sign, body)
}
