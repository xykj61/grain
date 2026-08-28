#!/bin/sh
# tools/fixtures/room_bound_control.sh -- a room built to break the bound, so the gate is proven.
#
# WHY. tools/fixtures/room_bound_scan.sh refuses a room over its bound. A gate that has never
# closed is a gate nobody has tested, so this builds a throwaway `session-logs` holding three
# dated files, runs the scan against a bound of two, and expects a refusal by name.
#
# THREE PHASES, because the gate can fail in two directions and the sweep in two more.
#   over    -- a room holding more than its bound must be refused
#   missing -- an ENFORCED room that is not in the tree at all must ALSO be refused, since a room
#              that vanishes from a meter is not a room that passed it. `counsel` and
#              `expanding-prompts` reached zero flat files on the lap they folded, dropped off a
#              discovery-only report, and taught this.
#   sweep   -- a DAY SHELF over the bound must read `terminal_shelf=` and an ordinary nested room
#              must read `undated_room=`, each kept off the other's list, neither moving the gate.
#              Added `20260828` (REDS %315), and it is the first proof the undated sweep has ever
#              had: the two pens above are plain directories, the sweep asks `git ls-files`, so in
#              a non-repository it read nothing and every line it prints went untested.
#
# EXPECTED: phase one verdict=over with enforced_over=1; phase two every enforced room absent;
# phase three both readings named, both silent once their plants are removed.
#
# Driven by tools/r/room_bound_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/session-logs"
: > "$work/session-logs/20260101-000000_one.kyri"
: > "$work/session-logs/20260101-000100_two.kyri"
: > "$work/session-logs/20260101-000200_three.kyri"

# The letter-folded room, counted by EVERY flat entry rather than by dated basenames. None of
# these names carries a stamp, which is exactly the shape that read zero for `tools/` while the
# real room stood 7.4x over bound. One of the three is a symlink, because the fold moves those too.
mkdir -p "$work/tools"
: > "$work/tools/alpha_witness.rish"
: > "$work/tools/beta_witness.rish"
ln -s alpha_witness.rish "$work/tools/gamma_witness.rish"

cd "$work"
over_out="$(sh "$root/tools/fixtures/room_bound_scan.sh" 2 2>&1 || true)"
over_code=0
sh "$root/tools/fixtures/room_bound_scan.sh" 2 >/dev/null 2>&1 || over_code=$?

# Phase two: a tree with no rooms at all. Every enforced room must be named absent and refused,
# rather than passing quietly because discovery found nothing to report.
empty="$(mktemp -d)"
cd "$empty"
missing_out="$(sh "$root/tools/fixtures/room_bound_scan.sh" 2 2>&1 || true)"
missing_code=0
sh "$root/tools/fixtures/room_bound_scan.sh" 2 >/dev/null 2>&1 || missing_code=$?
cd /
rm -rf "$empty"

echo "phase=over"
printf '%s\n' "$over_out" | grep -E 'room=session-logs|enforced_over=|^verdict=' || true
echo "over_refused=$([ "$over_code" -ne 0 ] && echo yes || echo no)"

echo "phase=missing"
printf '%s\n' "$missing_out" | grep -cE 'verdict=missing roster=enforce' | sed 's/^/enforced_rooms_named_absent=/'
echo "missing_refused=$([ "$missing_code" -ne 0 ] && echo yes || echo no)"

over_named=no
printf '%s\n' "$over_out" | grep -q 'room=session-logs flat=3 verdict=over roster=enforce' && over_named=yes
echo "over_named_by_room=$over_named"

# The letter-folded room must red on its own counting rule, and say which rule it used.
all_named=no
printf '%s\n' "$over_out" | grep -q 'room=tools flat=3 verdict=over roster=enforce counts=all' && all_named=yes
echo "all_counted_room_named=$all_named"

# PHASE THREE -- the undated sweep, in a real git repository, with the two shapes planted side by
# side: a DAY SHELF, which the mark law has no deeper fold for, and an ordinary nested room, which
# folds by first sprig letter. Both are proven from BOTH sides -- planted, then removed -- because
# a reading proven only in the firing direction cannot be told from a line that always prints.
pen="$(mktemp -d)"
cd "$pen"
git init -q . >/dev/null 2>&1

# The enforced roster, every room under the bound, so the gate reads ok before the plants land and
# any movement in enforced_over below is the plants' doing rather than the pen's.
for r in session-logs counsel active-designing active-development expanding-prompts waymarks; do
  mkdir -p "$r"
  : > "$r/20260101-000000_seed.kyri"
done
mkdir -p tools glow/gen
: > tools/alpha_witness.rish
: > glow/gen/alpha.glow

mkdir -p alpha/date/20260101 beta/gen
: > alpha/date/20260101/20260101-000000_one.md
: > alpha/date/20260101/20260101-000100_two.md
: > alpha/date/20260101/20260101-000200_three.md
: > beta/gen/one_witness.rish
: > beta/gen/two_witness.rish
: > beta/gen/three_witness.rish
git add -A >/dev/null 2>&1

sweep_out="$(sh "$root/tools/fixtures/room_bound_scan.sh" 2 2>&1 || true)"
sweep_code=0
sh "$root/tools/fixtures/room_bound_scan.sh" 2 >/dev/null 2>&1 || sweep_code=$?

# The other side. Remove both plants and both readings must fall silent.
rm -rf alpha beta
git add -A >/dev/null 2>&1
bare_out="$(sh "$root/tools/fixtures/room_bound_scan.sh" 2 2>&1 || true)"
cd /
rm -rf "$pen"

echo "phase=sweep"

shelf_named=no
printf '%s\n' "$sweep_out" | grep -q 'terminal_shelf=alpha/date/20260101 flat=3 verdict=over shape=day_fold_terminal cap_headroom=997' && shelf_named=yes
echo "day_shelf_named_terminal=$shelf_named"

shelf_off_fold=yes
printf '%s\n' "$sweep_out" | grep -q 'undated_room=alpha/date/20260101' && shelf_off_fold=no
echo "day_shelf_kept_off_fold_list=$shelf_off_fold"

room_named=no
printf '%s\n' "$sweep_out" | grep -q 'undated_room=beta/gen flat=3 verdict=over roster=advise' && room_named=yes
echo "foldable_room_named=$room_named"

room_off_shelf=yes
printf '%s\n' "$sweep_out" | grep -q 'terminal_shelf=beta/gen' && room_off_shelf=no
echo "foldable_room_kept_off_shelf_list=$room_off_shelf"

split=no
printf '%s\n' "$sweep_out" | grep -q 'terminal_shelves=1' &&
  printf '%s\n' "$sweep_out" | grep -q 'undated_over=1' && split=yes
echo "sweep_counts_split=$split"

# Neither advisory shape may move the gate. This is the reading that keeps the sweep honest: it
# reports, and reporting is all it does.
gate_still=no
printf '%s\n' "$sweep_out" | grep -q 'enforced_over=0' && [ "$sweep_code" -eq 0 ] && gate_still=yes
echo "sweep_moved_no_gate=$gate_still"

silent=no
printf '%s\n' "$bare_out" | grep -q 'terminal_shelves=0' &&
  printf '%s\n' "$bare_out" | grep -q 'undated_over=0' && silent=yes
echo "both_readings_silent_when_removed=$silent"

if [ "$over_code" -ne 0 ] && [ "$missing_code" -ne 0 ] && [ "$over_named" = yes ] && [ "$all_named" = yes ] &&
   [ "$shelf_named" = yes ] && [ "$shelf_off_fold" = yes ] && [ "$room_named" = yes ] &&
   [ "$room_off_shelf" = yes ] && [ "$split" = yes ] && [ "$gate_still" = yes ] && [ "$silent" = yes ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
