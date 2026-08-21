#!/bin/sh
# tools/fixtures/room_bound_control.sh -- a room built to break the bound, so the gate is proven.
#
# WHY. tools/fixtures/room_bound_scan.sh refuses a room over its bound. A gate that has never
# closed is a gate nobody has tested, so this builds a throwaway `session-logs` holding three
# dated files, runs the scan against a bound of two, and expects a refusal by name.
#
# EXPECTED: verdict=over, enforced_over=1, exit non-zero.
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
sh "$root/tools/fixtures/room_bound_scan.sh" 2
