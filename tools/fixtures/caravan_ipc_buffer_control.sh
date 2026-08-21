#!/bin/sh
# caravan_ipc_buffer_control.sh -- plant a broken IPC buffer in a COPY of the module, build it with the same
# compiler, and report whether its own self-test refuses it.
#
# WHY A SCRIPT. The plants' sed patterns carry `<`, `>`, and `.`, and an unquoted `<` or `>` inside a Rishi
# `run` string is read by the shell as a redirect -- the quoting fact the `20260821.044032` round learned the
# hard way, and the shape REDS %85 built a loom to forbid. The logic belongs in a fixture where the shell owns
# its own quoting, and the witness reads back a small report.
#
# WHY A COPY, AND WHY IT CARRIES ITS NEIGHBOUR. `ipc_buffer.rye` imports `refusals.rye` by a path relative to
# its own directory, so the copy takes a copy of that neighbour with it. The living tree is never touched and
# nothing is left behind.
#
# THE TWO PLANTS, each removing one thing the buffer exists to guarantee:
#
#   truncation  `read` stops comparing the declared length against the method's named minimum, so a short
#               message reads as satisfied. The self-test sends one word and expects three of the four methods
#               to answer truncated, so a healthy module must refuse this copy.
#
#   residue     `send` stops clearing the tail, so a word from a longer message survives a shorter one. The
#               postcondition inside `send` and the third movement of the self-test both name it.
#
# Usage: sh tools/fixtures/caravan_ipc_buffer_control.sh <zig> <build-dir> <truncation|residue>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
mode="$3"
src="caravan/ipc_buffer.rye"
copy="$build_dir/broken.rye"

mkdir -p "$build_dir"
cp caravan/refusals.rye "$build_dir/refusals.rye"

case "$mode" in
    truncation)
        sed -e 's/if (self\.tag\.length < needs) return \.truncated_message;/_ = self.tag.length; \/\/ plant: the truncation check removed/' \
            -e 's/assert(needs <= self\.tag\.length);/\/\/ plant: and its postcondition with it/' "$src" > "$copy"
        needle='plant: the truncation check removed'
        ;;
    residue)
        sed 's/self\.words\[@intCast(index)\] = 0;/if (false) self.words[@intCast(index)] = 0; \/\/ plant: the tail is left standing/' "$src" > "$copy"
        needle='plant: the tail is left standing'
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
