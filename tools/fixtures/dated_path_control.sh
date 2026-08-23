#!/bin/sh
# tools/fixtures/dated_path_control.sh -- a throwaway corpus whose right answer is known.
#
# WHY. tools/fixtures/dated_path_scan.sh reports how many dated references across the field
# still land. A walker like that is easy to believe and hard to check, because the tree's own
# answer is exactly what the walker is for. So the walker is run here on a corpus built to have
# one obvious answer: two dated references cited from one file, one naming a file that is there
# and one naming a file that is not. A walker that cannot tell those apart cannot be believed
# on nineteen thousand.
#
# EXPECTED OUTPUT: refs_total=2, refs_home=1, refs_broken=1, broken_gone=1, verdict=ok.
#
# Driven by tools/d/dated_path_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/room"
: > "$work/room/20260101-000000_real.md"
printf 'cites room/20260101-000000_real.md and room/20260101-000000_ghost.md\n' \
  > "$work/room/citer.md"

cd "$work"
git init -q
git add -A

sh "$root/tools/fixtures/dated_path_scan.sh"
