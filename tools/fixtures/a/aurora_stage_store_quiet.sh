#!/bin/sh
# Leave an empty directory on disk. The list stays quiet.
# The lasting store is not this directory.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
mkdir -p tools/.build

quiet="$root/aurora/.build/stage-resin-store-quiet"
mkdir -p "$quiet"

if STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_list.sh > tools/.build/stage-store-quiet.out 2>/dev/null; then
  exit 1
fi
grep -q 'count=0' tools/.build/stage-store-quiet.out
if grep -q GREEN tools/.build/stage-store-quiet.out; then
  exit 1
fi

files=$(find "$quiet" -type f | wc -l | tr -d ' ')
test "$files" = 0
test -d "$quiet"

echo "stage-store-quiet count=0 remains=yes"
echo GREEN
