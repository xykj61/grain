#!/bin/sh
# caravan_reply_control.sh -- plant a broken reading in a COPY of caravan/reply.rye, build it with the same
# compiler, and report whether its own self-test refuses it.
#
# WHY A SCRIPT. The plants' sed patterns carry `<`, `>`, `.`, and `|`, and an unquoted `<` or `>` inside a
# Rishi `run` string is read by the shell as a redirect. The logic belongs in a fixture where the shell owns
# its own quoting, and the witness reads back a small report -- the shape REDS %85 built a loom to require.
#
# WHY A COPY, AND WHY IT CARRIES ITS NEIGHBOURS. `reply.rye` imports six modules by paths relative to its own
# directory, and one of those imports a seventh. The copy takes copies of all of them with it, so the living
# tree is never touched and nothing is left behind.
#
# THE THREE PLANTS, each removing one thing the reply exists to guarantee:
#
#   order    the roster holding the reading order is reversed. Caravan's order is a design judgement -- each
#            stage depends only on facts the stages before it established -- so it lives in exactly one list.
#            Reversed, an ask that is bad at every stage is answered by the deed rather than by the edge, and
#            the caller is told to fix the last thing wrong with it instead of the first.
#
#   collapse the seam carrying the table's own outcomes into the kernel's vocabulary maps two of them onto
#            one, so a resource that was never granted and a dependent nobody has heard of give the same
#            sentence. A capability system that collapses its refusals cannot audit itself, which is the
#            fault the refusal vocabulary was built to make impossible one floor down.
#
#   mute     the table stage answers nothing at all, welcoming every ask through to the deed. This is the
#            precise fault the rung exists to fix, planted in reverse: with the table silent the measured
#            reach falls from eleven to eight, because three of the corpus asks stop earning what they were
#            written to earn. A reach credited by proximity would not have noticed.
#
# Usage: sh tools/fixtures/caravan_reply_control.sh <zig> <build-dir> <order|collapse|mute>
# Prints: planted=<n> selftest_exit=<n> verdict=refused|accepted|not-planted

set -eu

zig="$1"
build_dir="$2"
mode="$3"
src="caravan/reply.rye"
copy="$build_dir/broken.rye"

mkdir -p "$build_dir"
for neighbour in refusals capabilities edge ipc_buffer derivation untyped tally_copy; do
    cp "caravan/$neighbour.rye" "$build_dir/$neighbour.rye"
done

case "$mode" in
    order)
        sed 's/^pub const all_stages = \[_\]Stage{ \.edge, \.message, \.table, \.deed };/pub const all_stages = [_]Stage{ .deed, .table, .message, .edge }; \/\/ plant: the reading order is reversed/' "$src" > "$copy"
        needle='plant: the reading order is reversed'
        ;;
    collapse)
        sed 's/^        \.no_such_resource => \.no_such_resource,/        .no_such_resource => .no_such_dependent, \/\/ plant: two outcomes answer as one/' "$src" > "$copy"
        needle='plant: two outcomes answer as one'
        ;;
    mute)
        sed 's/^            const own = bench\.table\.refusal_reason(ask\.dependent, ask\.resource, ask\.need);/            const own = capabilities.Refusal.allowed; \/\/ plant: the table answers nothing/' "$src" > "$copy"
        needle='plant: the table answers nothing'
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

rm -f "$copy" "$build_dir/broken" "$build_dir/broken.build" "$build_dir/broken.out"
for neighbour in refusals capabilities edge ipc_buffer derivation untyped tally_copy; do
    rm -f "$build_dir/$neighbour.rye"
done
echo "planted=$planted selftest_exit=$selftest_exit verdict=$verdict"
