#!/bin/sh
# Fold supply parity helper for door 15 wire lab -- two independent runs, equal supply.
# Kept as shell so rish $digit expansion never touches the sed groups.
set -eu
export RYE_ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"
out_a=$(rye/bin/rye run mycelium/fold.rye 2>&1)
out_b=$(rye/bin/rye run mycelium/fold.rye 2>&1)
printf '%s\n' "$out_a" | grep -q 'GREEN: myc fold' || { echo "fold A not GREEN"; exit 1; }
printf '%s\n' "$out_b" | grep -q 'GREEN: myc fold' || { echo "fold B not GREEN"; exit 1; }
sup_a=$(printf '%s\n' "$out_a" | sed -n 's/.*supply=\([0-9][0-9]*\).*/\1/p' | head -n 1)
sup_b=$(printf '%s\n' "$out_b" | sed -n 's/.*supply=\([0-9][0-9]*\).*/\1/p' | head -n 1)
test -n "$sup_a" || { echo "supply A empty"; exit 1; }
test "$sup_a" = "$sup_b" || { echo "supply mismatch $sup_a vs $sup_b"; exit 1; }
echo "fold_supply_parity=${sup_a}"
echo "GREEN"
