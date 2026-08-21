#!/bin/sh
# caravan_edge_order_scan.sh -- does seL4 publish a CHECK order for a method's errors, or only a reading order?
#
# WHY THIS SCAN EXISTS. `caravan/edge.rye` asks three questions of a request -- argument, then range, then alignment --
# and answers the earliest that fails. That order is a design judgement, and a design judgement must know whether it is
# choosing freely or contradicting an upstream sequence. seL4 publishes a per-method error block in its interface XML,
# and the honest question is what that block's ORDER means.
#
# The answer, measured rather than assumed: Retype's errors stand in strict ALPHABETICAL order -- DeleteFirst,
# FailedLookup, IllegalOperation, InvalidArgument, InvalidCapability, NotEnoughMemory, RangeError. Alphabetical is a
# reading order for a manual, never a checking order for a kernel. So Caravan chooses its own and says so.
#
# This scan re-asks the question every run. The day seL4 publishes its errors in some other order, that order may well
# be a real sequence worth weighing ours against, and this rung reds and asks for the reading rather than keeping our
# order by default.
#
# WHY A SCRIPT. The extraction needs quoted XML attributes and a redirect, and an unquoted `<` or `>` inside a Rishi
# `run` string is read by the shell as a redirect -- the quoting fact the `20260821.044032` round learned the hard way
# and the shape REDS %85 built a loom to forbid. The shell owns its own quoting here.
#
# Usage: sh tools/fixtures/caravan_edge_order_scan.sh [interface-xml] [method-name]
# Prints: errors=<n> verdict=alphabetical|sequenced  (and the block's order, one name per line, prefixed EDGE_ORDER)

set -eu

api="${1:-vendor/sel4/libsel4/include/interfaces/object-api.xml}"
method="${2:-Retype}"

if [ ! -f "$api" ]; then
    echo "errors=0 verdict=missing"
    exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

sed -n "/name=\"$method\"/,/<\/method>/p" "$api" \
    | grep -o 'error name="seL4_[A-Za-z]*"' \
    | sed 's/.*seL4_//; s/"//' > "$work/order.txt"

count=$(wc -l < "$work/order.txt" | tr -d ' ')

if [ "$count" = "0" ]; then
    echo "errors=0 verdict=missing"
    exit 1
fi

while IFS= read -r name; do
    echo "EDGE_ORDER $name"
done < "$work/order.txt"

LC_ALL=C sort "$work/order.txt" > "$work/sorted.txt"

if cmp -s "$work/order.txt" "$work/sorted.txt"; then
    echo "errors=$count verdict=alphabetical"
    exit 0
fi

echo "errors=$count verdict=sequenced"
exit 0
