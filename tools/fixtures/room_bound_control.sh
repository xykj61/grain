#!/bin/sh
# tools/fixtures/room_bound_control.sh -- a room built to break the bound, so the gate is proven.
#
# WHY. tools/fixtures/room_bound_scan.sh refuses a room over its bound. A gate that has never
# closed is a gate nobody has tested, so this builds a throwaway `session-logs` holding three
# dated files, runs the scan against a bound of two, and expects a refusal by name.
#
# TWO PHASES, because the gate can fail in two directions.
#   over    -- a room holding more than its bound must be refused
#   missing -- an ENFORCED room that is not in the tree at all must ALSO be refused, since a room
#              that vanishes from a meter is not a room that passed it. `counsel` and
#              `expanding-prompts` reached zero flat files on the lap they folded, dropped off a
#              discovery-only report, and taught this.
#
# EXPECTED: phase one verdict=over with enforced_over=1; phase two every enforced room absent.
#
# Driven by tools/room_bound_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/session-logs"
: > "$work/session-logs/20260101-000000_one.kyri"
: > "$work/session-logs/20260101-000100_two.kyri"
: > "$work/session-logs/20260101-000200_three.kyri"

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

if [ "$over_code" -ne 0 ] && [ "$missing_code" -ne 0 ] && [ "$over_named" = yes ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
