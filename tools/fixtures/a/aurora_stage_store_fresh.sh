#!/bin/sh
# A fresh directory lists nothing. One write, and the list speaks.
# The lasting store is left alone.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
mkdir -p tools/.build

lasting="$root/aurora/.build/stage-resin-store"
before=0
if [ -d "$lasting" ]; then
  before=$(find "$lasting" -type f | wc -l | tr -d ' ')
fi

fresh=$(mktemp -d)
trap 'rm -rf "$fresh"' EXIT

if STAGE_STORE="$fresh" sh tools/fixtures/a/aurora_stage_store_list.sh > tools/.build/stage-store-fresh-empty.out 2>/dev/null; then
  exit 1
fi
grep -q 'count=0' tools/.build/stage-store-fresh-empty.out
if grep -q GREEN tools/.build/stage-store-fresh-empty.out; then
  exit 1
fi

mkdir -p tools/.build
printf '%s\n' 'a fresh directory' | STAGE_STORE="$fresh" sh tools/fixtures/a/aurora_stage_store_put.sh >/dev/null
STAGE_STORE="$fresh" sh tools/fixtures/a/aurora_stage_store_list.sh > tools/.build/stage-store-fresh-filled.out
grep -q 'count=1' tools/.build/stage-store-fresh-filled.out
grep -q GREEN tools/.build/stage-store-fresh-filled.out

after=0
if [ -d "$lasting" ]; then
  after=$(find "$lasting" -type f | wc -l | tr -d ' ')
fi
test "$before" = "$after"

echo "stage-store-fresh empty=quiet filled=1 lasting=${after}"
echo GREEN
