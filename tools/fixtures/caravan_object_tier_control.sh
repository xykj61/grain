#!/bin/sh
# caravan_object_tier_control.sh -- plant a tier boundary that opens a gap in a COPY of the module,
# build it with the same compiler, and report whether its own self-test refuses it.
#
# WHY A GAP IS THE RIGHT PLANT. The whole claim of the three-tier reading is that seL4's mode enum
# begins exactly where the portable enum ended and the architecture enum begins exactly where the mode
# enum ended, so the nine compose into one numbering. Move a boundary by one and the numbering still
# looks orderly while an object silently changes tier. That is the failure worth proving refused.
#
# WHY A SCRIPT. The plant's sed carries `=>` in neighbouring lines and the witness's own quoting rules
# forbid an unquoted `>` inside a Rishi `run` string, so the logic belongs where the shell owns it.
#
# Usage: sh tools/fixtures/caravan_object_tier_control.sh <zig> <build-dir>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
src="caravan/objects.rye"
copy="$build_dir/gapped.rye"

mkdir -p "$build_dir"

# The mutated copy is built beside its imports, and caravan/study_door.rye is one of them:
# every study rung reaches its entry point through that body rather than writing it out.
cp caravan/study_door.rye "$build_dir/study_door.rye"

# Move the mode tier's floor up by one, so the giga page falls back into the portable tier and the
# widths stop summing to nine. The module's own self-test asserts both, so a healthy module refuses it.
sed 's/^pub const non_arch_object_type_count: u32 = 5;/pub const non_arch_object_type_count: u32 = 6;/' "$src" > "$copy"

planted=$(grep -c '^pub const non_arch_object_type_count: u32 = 6;' "$copy" || true)
if [ "$planted" != "1" ]; then
    echo "planted=$planted selftest_exit=0 verdict=not-planted"
    exit 0
fi

if ! env RYE_ZIG="$zig" rye/bin/rye build "$copy" -femit-bin="$build_dir/gapped" >"$build_dir/gapped.build" 2>&1; then
    echo "planted=$planted selftest_exit=0 verdict=not-planted"
    exit 0
fi

selftest_exit=0
( "$build_dir/gapped" selftest >"$build_dir/gapped.out" 2>&1 ) 2>/dev/null || selftest_exit=$?

verdict=accepted
if [ "$selftest_exit" != "0" ]; then
    verdict=refused
fi

rm -f "$copy" "$build_dir/gapped" "$build_dir/gapped.build" "$build_dir/gapped.out"
echo "planted=$planted selftest_exit=$selftest_exit verdict=$verdict"
