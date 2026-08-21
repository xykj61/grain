#!/bin/sh
# caravan_refusal_meaning_scan.sh -- bind what our refusal names MEAN against what seL4 itself publishes.
#
# WHY THIS SCAN EXISTS. `caravan_refusal_symbol_scan.sh` proves the eleven symbols and their order against
# seL4's own `errors.h`. That header carries names and nothing else, so it can never say whether our plain
# English beside each name is true -- and for one lap it was not: `seL4_DeleteFirst` was written as though it
# meant `seL4_RevokeFirst`, and a GREEN rung carried the wrong sentence (REDS %107). A parity check that binds
# a name proves nothing about what the name means.
#
# WHERE THE MEANINGS LIVE. seL4 publishes a description for each refusal in its own BSD-2-Clause interface
# files, `libsel4/include/interfaces/*.xml` and the arch-specific ones beside them. Those descriptions are
# per-method and numerous, so this scan binds two-sidedly and explicitly rather than guessing at prose:
#
#   for each binding  symbol | kernel-phrase | our-phrase
#     the kernel phrase must still appear somewhere in the vendored XML   (seL4 reworded -> RED)
#     our phrase must still appear in the meaning our module prints        (our prose drifted -> RED)
#
# A binding therefore fails on either side moving, which is the whole point: it holds our sentence and the
# kernel's sentence to each other rather than to a memory of either.
#
# WHAT IS HONESTLY UNBOUND. Only refusals whose published description carries one unambiguous, load-bearing
# sentence are bound. The rest are COUNTED AND REPORTED as unbound rather than passed over, because a scan
# that quietly narrows its subject is the fault it exists to prevent.
#
# Usage: sh tools/fixtures/caravan_refusal_meaning_scan.sh <libsel4-dir> <table-output-file> [bindings-file]
# Prints: bound=<n> unbound=<n> kernel_missing=<n> ours_missing=<n> verdict=ok|drift

set -eu

libsel4="$1"
table="$2"
bindings="${3:-}"

if [ ! -d "$libsel4" ]; then
    echo "bound=0 unbound=0 kernel_missing=0 ours_missing=0 verdict=missing-libsel4"
    exit 0
fi
if [ ! -f "$table" ]; then
    echo "bound=0 unbound=0 kernel_missing=0 ours_missing=0 verdict=missing-table"
    exit 0
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# Every published interface description, flattened to one stream. seL4 writes them two ways -- as a
# `description="..."` ATTRIBUTE on a self-closing error tag, and as a nested `<description>` ELEMENT -- so both
# are gathered before tags are stripped. Stripping first would delete the attribute form along with its tag,
# which would read as "seL4 no longer publishes this" when seL4 publishes it plainly.
find "$libsel4" -name '*.xml' -type f -exec cat {} + > "$work/all.xml"

{
    grep -oh 'description="[^"]*"' "$work/all.xml" || true
    sed -e 's/<[^>]*>/ /g' "$work/all.xml"
} | tr '\n' ' ' | tr -s ' ' > "$work/published.txt"

# The default bindings. Held here rather than in the witness so the shell owns its own quoting (REDS %85).
if [ -z "$bindings" ] || [ ! -f "$bindings" ]; then
    bindings="$work/bindings.txt"
    cat > "$bindings" <<'BINDINGS'
seL4_DeleteFirst|destination slot contains a capability|destination slot already holds a capability
seL4_RevokeFirst|source capability cannot be derived|stand derived from this one
seL4_NotEnoughMemory|exceeds the space available|holds too little to retype
BINDINGS
fi

# How many of the eleven the module prints, so the unbound count is measured rather than recited.
printed=$(grep -oE 'seL4_[A-Za-z]+' "$table" | sort -u | wc -l | tr -d ' ')

bound=0
kernel_missing=0
ours_missing=0

while IFS='|' read -r symbol kernel_phrase our_phrase; do
    [ -n "$symbol" ] || continue

    if grep -qF "$kernel_phrase" "$work/published.txt"; then
        :
    else
        kernel_missing=$((kernel_missing + 1))
        echo "meaning: $symbol -- seL4 no longer publishes: $kernel_phrase"
        continue
    fi

    if grep -F "$symbol" "$table" | grep -qF "$our_phrase"; then
        bound=$((bound + 1))
    else
        ours_missing=$((ours_missing + 1))
        echo "meaning: $symbol -- our meaning no longer carries: $our_phrase"
    fi
done < "$bindings"

declared=$(grep -c '|' "$bindings" | tr -d ' ')
unbound=$((printed - declared))
[ "$unbound" -ge 0 ] || unbound=0

verdict=drift
if [ "$kernel_missing" = "0" ] && [ "$ours_missing" = "0" ] && [ "$bound" = "$declared" ] && [ "$bound" != "0" ]; then
    verdict=ok
fi

echo "bound=$bound unbound=$unbound kernel_missing=$kernel_missing ours_missing=$ours_missing verdict=$verdict"
