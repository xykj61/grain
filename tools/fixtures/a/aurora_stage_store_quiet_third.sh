#!/bin/sh
# Land a third sentence beside the quiet store's first two writes.
# A repeat of the third sentence adds nothing.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
mkdir -p tools/.build

quiet="$root/aurora/.build/stage-resin-store-quiet"
empty="$root/aurora/.build/stage-resin-store-quiet-empty"
mkdir -p "$quiet"
payload=tools/.build/stage-store-quiet-third-payload
printf '%s\n' 'a third sentence' > "$payload"

STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-quiet-third-once
STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-quiet-third-twice
grep -q 'added=0' tools/.build/stage-store-quiet-third-twice

resin=$(sed -n 's/^stage-store-put resin=\([^ ]*\).*/\1/p' tools/.build/stage-store-quiet-third-twice)
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

second=tools/.build/stage-store-quiet-second-payload
printf '%s\n' 'a second sentence' > "$second"
second_resin=$(sh tools/fixtures/s/sha3.sh 512 "$second")
tmp=$(mktemp)
STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_read.sh "$second_resin" > "$tmp"
cmp -s "$tmp" "$second"
rm -f "$tmp"

STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_list.sh > tools/.build/stage-store-quiet-third-list.out
grep -q 'count=3' tools/.build/stage-store-quiet-third-list.out
test "$resin" != "$first_resin"
test "$resin" != "$second_resin"
test "$first_resin" != "$second_resin"

empty_files=0
if [ -d "$empty" ]; then
  empty_files=$(find "$empty" -type f | wc -l | tr -d ' ')
fi
test "$empty_files" = 0
test -d "$quiet"

echo "stage-store-quiet-third count=3 first=held second=held third=unchanged remains=yes"
echo GREEN
