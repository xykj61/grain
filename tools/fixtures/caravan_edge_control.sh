#!/bin/sh
# caravan_edge_control.sh -- plant a broken edge check in a COPY of the module, build it with the same
# compiler, and report whether its own self-test refuses it.
#
# WHY A SCRIPT. The plants' sed patterns carry `<`, `>`, and `.`, and an unquoted `<` or `>` inside a Rishi
# `run` string is read by the shell as a redirect -- the quoting fact the `20260821.044032` round learned the
# hard way, and the shape REDS %85 built a loom to forbid. The logic belongs in a fixture where the shell owns
# its own quoting, and the witness reads back a small report.
#
# WHY A COPY, AND WHY IT CARRIES ITS NEIGHBOURS. `edge.rye` imports `refusals.rye` and `untyped.rye` by paths
# relative to its own directory, so the copy takes copies of both with it. The living tree is never touched
# and nothing is left behind.
#
# THE THREE PLANTS, each removing one thing the edge exists to guarantee:
#
#   order      the roster that holds the checking order is reversed. Caravan's order is a design judgement
#              rather than something seL4 publishes, so it lives in exactly one list -- and a reversed list
#              means a request failing argument and alignment together is answered by the wrong one. The
#              first movement reads each check's position and the third builds requests failing two and
#              three at once, so a healthy module must refuse this copy.
#
#   collapse   two checks answer the same kernel refusal. An edge that collapses two of its three answers
#              tells a caller to fix the wrong argument, and the first movement asserts all three distinct.
#
#   alignment  the alignment check always passes, so an address off its own boundary is welcomed. The second
#              movement asks each check to refuse alone on a request that fails only it.
#
# Usage: sh tools/fixtures/caravan_edge_control.sh <zig> <build-dir> <order|collapse|alignment>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
mode="$3"
src="caravan/edge.rye"
copy="$build_dir/broken.rye"

mkdir -p "$build_dir"
cp caravan/refusals.rye "$build_dir/refusals.rye"
cp caravan/untyped.rye "$build_dir/untyped.rye"

case "$mode" in
    order)
        sed 's/pub const all_checks = \[_\]Check{ \.argument, \.range, \.alignment };/pub const all_checks = [_]Check{ .alignment, .range, .argument }; \/\/ plant: the order is reversed/' "$src" > "$copy"
        needle='plant: the order is reversed'
        ;;
    collapse)
        sed 's/        \.range => \.range_error,/        .range => .invalid_argument, \/\/ plant: two checks answer as one/' "$src" > "$copy"
        needle='plant: two checks answer as one'
        ;;
    alignment)
        sed 's/        \.alignment => untyped\.aligned_to(request\.address, untyped\.object_bits(request\.kind)),/        .alignment => true, \/\/ plant: every address is welcomed/' "$src" > "$copy"
        needle='plant: every address is welcomed'
        ;;
    *)
        echo "planted=0 selftest_exit=0 verdict=not-planted"
        exit 0
        ;;
esac

planted=$(grep -c "$needle" "$copy" || true)
if [ "$planted" != "1" ]; then
    echo "planted=$planted selftest_exit=0 verdict=not-planted"
    exit 0
fi

if ! env RYE_ZIG="$zig" rye/bin/rye build "$copy" -femit-bin="$build_dir/broken" >"$build_dir/broken.build" 2>&1; then
    echo "planted=$planted selftest_exit=0 verdict=not-planted"
    exit 0
fi

selftest_exit=0
( "$build_dir/broken" selftest >"$build_dir/broken.out" 2>&1 ) 2>/dev/null || selftest_exit=$?

verdict=accepted
if [ "$selftest_exit" != "0" ]; then
    verdict=refused
fi

rm -f "$copy" "$build_dir/broken" "$build_dir/broken.build" "$build_dir/broken.out" \
      "$build_dir/refusals.rye" "$build_dir/untyped.rye"
echo "planted=$planted selftest_exit=$selftest_exit verdict=$verdict"
