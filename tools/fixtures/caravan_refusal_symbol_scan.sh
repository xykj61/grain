#!/bin/sh
# caravan_refusal_symbol_scan.sh -- read seL4's refusal vocabulary out of its own header, in order,
# and diff it against the vocabulary caravan/refusals.rye prints.
#
# WHY A SCAN RATHER THAN A GREP IN THE WITNESS. Comparing two ordered lists wants a loop, and a loop
# that interpolates captured output into a shell-quoted word is exactly the fragile shape REDS %85
# built a loom to forbid. So the comparison lives here, where the shell owns its own variables, and the
# witness reads only a small integer report back.
#
# Usage: sh tools/fixtures/caravan_refusal_symbol_scan.sh <errors.h> <table-output-file>
# Prints: header_count=<n> table_count=<n> mismatch=<n> verdict=ok|drift

set -eu

header="$1"
table="$2"

if [ ! -f "$header" ]; then
    echo "header_count=0 table_count=0 mismatch=0 verdict=missing-header"
    exit 0
fi
if [ ! -f "$table" ]; then
    echo "header_count=0 table_count=0 mismatch=0 verdict=missing-table"
    exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# The header's own enum, in declaration order, with the trailing count sentinel dropped -- seL4_NumErrors
# is the count of the errors rather than one of them, exactly as the header's own comment says.
grep -oE 'seL4_[A-Za-z]+' "$header" | grep -v '^seL4_NumErrors$' | grep -v '^seL4_Error$' > "$work/header.txt"

# What the module prints, in the order it prints it.
grep -oE 'seL4_[A-Za-z]+' "$table" > "$work/table.txt"

header_count=$(wc -l < "$work/header.txt" | tr -d ' ')
table_count=$(wc -l < "$work/table.txt" | tr -d ' ')

mismatch=$(diff "$work/header.txt" "$work/table.txt" | grep -c '^[<>]' || true)

verdict=drift
if [ "$header_count" = "$table_count" ] && [ "$mismatch" = "0" ] && [ "$header_count" != "0" ]; then
    verdict=ok
fi

echo "header_count=$header_count table_count=$table_count mismatch=$mismatch verdict=$verdict"
