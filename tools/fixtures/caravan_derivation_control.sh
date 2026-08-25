#!/bin/sh
# caravan_derivation_control.sh -- plant a broken derivation tree in a COPY of the module, build it with
# the same compiler, and report whether its own self-test refuses it.
#
# WHY A SCRIPT. The plants' sed patterns carry `=>`, `>`, and `!`, and an unquoted `>` inside a Rishi `run`
# string is read by the shell as a redirect (the quoting fact the `20260821.044032` round learned the hard
# way, and the shape REDS %85 built a loom to forbid). The logic belongs in a fixture where the shell owns
# its own quoting, and the witness reads back a small report.
#
# WHY A COPY, AND WHY IT CARRIES ITS NEIGHBOUR. `derivation.rye` imports `refusals.rye` by a path relative
# to its own directory, so the copy takes a copy of that neighbour with it. The living tree is never touched
# and nothing is left behind.
#
# THE TWO PLANTS, each removing one thing the tree exists to guarantee:
#
#   attenuation  `derive` stops checking that a child's rights are a subset of its parent's, so reach could
#                WIDEN as it is handed on. The self-test asks for a widening derivation and expects the
#                illegal-operation answer, so a healthy module must refuse this copy.
#
#   revoke       `revoke` sweeps only DIRECT children rather than the whole lineage, so a grandchild
#                survives its grandparent's revocation as reach nobody granted. The postcondition assert
#                inside `revoke` names that the moment it happens.
#
# Usage: sh tools/fixtures/caravan_derivation_control.sh <zig> <build-dir> <attenuation|revoke>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
mode="$3"
src="caravan/derivation.rye"
copy="$build_dir/broken.rye"

mkdir -p "$build_dir"
cp caravan/refusals.rye "$build_dir/refusals.rye"
cp caravan/study_door.rye "$build_dir/study_door.rye"

case "$mode" in
    attenuation)
        sed 's/if (!carries(self.slots\[parent_index\].rights, rights)) return .illegal_operation;/\/\/ plant: the attenuation check removed/' "$src" > "$copy"
        needle='plant: the attenuation check removed'
        ;;
    revoke)
        sed 's/if (view.descends_from(walker, slot)) self.slots\[@intCast(walker)\] = .{};/if (view.descends_from(walker, slot) and before[@intCast(walker)].parent == slot) self.slots[@intCast(walker)] = .{}; \/\/ plant: direct children only/' "$src" > "$copy"
        needle='plant: direct children only'
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
