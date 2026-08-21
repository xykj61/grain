#!/bin/sh
# caravan_untyped_control.sh -- plant a broken untyped region in a COPY of the module, build it with the same
# compiler, and report whether its own self-test refuses it.
#
# WHY A SCRIPT. The plants' sed patterns carry `<`, `>`, and `.`, and an unquoted `<` or `>` inside a Rishi
# `run` string is read by the shell as a redirect -- the quoting fact the `20260821.044032` round learned the
# hard way, and the shape REDS %85 built a loom to forbid. The logic belongs in a fixture where the shell owns
# its own quoting, and the witness reads back a small report.
#
# WHY A COPY, AND WHY IT CARRIES ITS NEIGHBOUR. `untyped.rye` imports `refusals.rye` by a path relative to its
# own directory, so the copy takes a copy of that neighbour with it. The living tree is never touched and
# nothing is left behind.
#
# THE THREE PLANTS, each removing one thing the region exists to guarantee:
#
#   padding    `retype` seats the carve at the raw watermark rather than at the aligned start, so the climb to
#              the object's own boundary is never spent. The third movement carves a slot and then a page and
#              names where the page must land, so a healthy module must refuse this copy.
#
#   spend      a refused carve eats the region instead of leaving it alone. The second movement reads the
#              watermark after a refusal and expects it exactly where it stood.
#
#   misalign   `open` stops refusing an origin that does not stand on a boundary of the region's own size.
#              This is the sharpest of the three: natural alignment is precisely what makes the aligned floor
#              and the plain remainder agree, so the refusal at `open` is load-bearing for a claim proven two
#              movements later by sweep. The first movement names the refusal directly.
#
# Usage: sh tools/fixtures/caravan_untyped_control.sh <zig> <build-dir> <padding|spend|misalign>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
mode="$3"
src="caravan/untyped.rye"
copy="$build_dir/broken.rye"

mkdir -p "$build_dir"
cp caravan/refusals.rye "$build_dir/refusals.rye"

case "$mode" in
    padding)
        sed 's/self\.watermark = start + each \* @as(u64, count);/self.watermark = before + each * @as(u64, count); \/\/ plant: the climb is never spent/' "$src" > "$copy"
        needle='plant: the climb is never spent'
        ;;
    spend)
        sed 's/assert(self\.watermark == before);/self.watermark = self.bytes(); \/\/ plant: a refusal eats the region/' "$src" > "$copy"
        needle='plant: a refusal eats the region'
        ;;
    misalign)
        sed 's/if (!aligned_to(origin, size_bits)) return UntypedError\.RegionMisaligned;/\/\/ plant: a misaligned region is welcomed/' "$src" > "$copy"
        needle='plant: a misaligned region is welcomed'
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

rm -f "$copy" "$build_dir/broken" "$build_dir/broken.build" "$build_dir/broken.out" "$build_dir/refusals.rye"
echo "planted=$planted selftest_exit=$selftest_exit verdict=$verdict"
