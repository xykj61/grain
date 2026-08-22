#!/bin/sh
# caravan_mapping_geometry_control.sh -- plant a moved page size in a COPY of the module, build it with
# the same compiler, and report whether its own self-test refuses it.
#
# WHY A MOVED PAGE SIZE IS THE RIGHT PLANT. Every claim this module makes rests on the three page sizes
# forming a divisibility chain, each exactly the index width above the one below. Move one by a single
# bit and the arithmetic still runs -- covers still cover, tables still count -- while the plan quietly
# describes a machine that does not exist. That is precisely the failure a recited constant would let
# through, so it is the one worth proving refused.
#
# WHY THE SELF-TEST CATCHES IT. `check_geometry` asserts the chain by name: the megabyte page sits one
# index width above the small page, the gigabyte page one above that, and the whole virtual address is
# one above the gigabyte page. A moved bit breaks the chain at two links, so a healthy module aborts.
#
# WHY A SCRIPT RATHER THAN A LINE IN THE WITNESS. The plant builds a copy, runs it expecting a non-zero
# exit, and cleans up after itself -- three shell acts whose quoting belongs where the shell owns it.
#
# Usage: sh tools/fixtures/caravan_mapping_geometry_control.sh <zig> <build-dir>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
src="caravan/mapping.rye"
copy="$build_dir/drifted.rye"

mkdir -p "$build_dir"

# Move the megabyte page down one bit, to a size no riscv64 kernel offers. The chain breaks above and
# below it at once, and the module's own asserts are what must notice.
sed 's/^pub const large_page_bits: u6 = 21;/pub const large_page_bits: u6 = 20;/' "$src" > "$copy"

planted=$(grep -c '^pub const large_page_bits: u6 = 20;' "$copy" || true)
if [ "$planted" != "1" ]; then
    echo "planted=$planted selftest_exit=0 verdict=not-planted"
    exit 0
fi

if ! env RYE_ZIG="$zig" rye/bin/rye build "$copy" -femit-bin="$build_dir/drifted" >"$build_dir/drifted.build" 2>&1; then
    # A compiler that refuses the plant outright is a refusal too, and an even earlier one.
    rm -f "$copy" "$build_dir/drifted.build"
    echo "planted=$planted selftest_exit=1 verdict=refused"
    exit 0
fi

selftest_exit=0
( "$build_dir/drifted" selftest >"$build_dir/drifted.out" 2>&1 ) 2>/dev/null || selftest_exit=$?

verdict=accepted
if [ "$selftest_exit" != "0" ]; then
    verdict=refused
fi

rm -f "$copy" "$build_dir/drifted" "$build_dir/drifted.build" "$build_dir/drifted.out"
echo "planted=$planted selftest_exit=$selftest_exit verdict=$verdict"
