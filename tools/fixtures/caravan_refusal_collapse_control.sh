#!/bin/sh
# caravan_refusal_collapse_control.sh -- plant a collapsed refusal mapping in a COPY of the module,
# build it with the same compiler, and report whether its own self-test refuses it.
#
# WHY A SCRIPT. The plant's sed and grep both carry `=>`, and an unquoted `>` inside a Rishi `run`
# string is read by the shell as a redirect -- one of the three quoting facts the `20260821.044032`
# round learned the hard way. The logic belongs in a fixture where the shell owns its own quoting,
# and the witness reads back a small report.
#
# Usage: sh tools/fixtures/caravan_refusal_collapse_control.sh <zig> <build-dir>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
src="caravan/refusals.rye"
copy="$build_dir/collapsed.rye"

mkdir -p "$build_dir"

# The mutated copy is built beside its imports, and caravan/study_door.rye is one of them:
# every study rung reaches its entry point through that body rather than writing it out.
cp caravan/study_door.rye "$build_dir/study_door.rye"

# Collapse two distinct answers into one: an ungranted resource stops being an invalid capability and
# becomes the same failed lookup an unknown dependent already is. The module's own self-test asserts
# those three stay distinct, so a healthy module must refuse this copy.
sed 's/\.no_such_resource => \.invalid_capability,/.no_such_resource => .failed_lookup,/' "$src" > "$copy"

planted=$(grep -c 'no_such_resource => \.failed_lookup,' "$copy" || true)
if [ "$planted" != "1" ]; then
    echo "planted=$planted selftest_exit=0 verdict=not-planted"
    exit 0
fi

if ! env RYE_ZIG="$zig" rye/bin/rye build "$copy" -femit-bin="$build_dir/collapsed" >"$build_dir/collapsed.build" 2>&1; then
    echo "planted=$planted selftest_exit=0 verdict=not-planted"
    exit 0
fi

selftest_exit=0
( "$build_dir/collapsed" selftest >"$build_dir/collapsed.out" 2>&1 ) 2>/dev/null || selftest_exit=$?

verdict=accepted
if [ "$selftest_exit" != "0" ]; then
    verdict=refused
fi

rm -f "$copy" "$build_dir/collapsed" "$build_dir/collapsed.build" "$build_dir/collapsed.out"
echo "planted=$planted selftest_exit=$selftest_exit verdict=$verdict"
