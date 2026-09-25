#!/bin/sh
# Land a second sentence beside the quiet store's first write.
# A repeat of the second sentence adds nothing.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
mkdir -p tools/.build

quiet="$root/aurora/.build/stage-resin-store-quiet"
empty="$root/aurora/.build/stage-resin-store-quiet-empty"
mkdir -p "$quiet"
payload=tools/.build/stage-store-quiet-second-payload
printf '%s\n' 'a second sentence' > "$payload"

STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-quiet-second-once
STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-quiet-second-twice
grep -q 'added=0' tools/.build/stage-store-quiet-second-twice

resin=$(sed -n 's/^stage-store-put resin=\([^ ]*\).*/\1/p' tools/.build/stage-store-quiet-second-twice)
tmp=$(mktemp)
STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_read.sh "$resin" > "$tmp"
cmp -s "$tmp" "$payload"
rm -f "$tmp"

first=tools/.build/stage-store-quiet-payload
printf '%s\n' 'a quiet directory' > "$first"
first_resin=$(sh tools/fixtures/s/sha3.sh 512 "$first")
tmp=$(mktemp)
STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_read.sh "$first_resin" > "$tmp"
cmp -s "$tmp" "$first"
rm -f "$tmp"

STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_list.sh > tools/.build/stage-store-quiet-second-list.out
grep -q 'count=2' tools/.build/stage-store-quiet-second-list.out
test "$resin" != "$first_resin"

empty_files=0
if [ -d "$empty" ]; then
  empty_files=$(find "$empty" -type f | wc -l | tr -d ' ')
fi
test "$empty_files" = 0
test -d "$quiet"

echo "stage-store-quiet-second count=2 first=held second=unchanged remains=yes"
echo GREEN
