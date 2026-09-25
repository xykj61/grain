#!/bin/sh
# Write one sentence into the quiet stage store and leave it there.
# A second write adds nothing. The empty sibling directory stays empty.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
mkdir -p tools/.build

quiet="$root/aurora/.build/stage-resin-store-quiet"
mkdir -p "$quiet"
payload=tools/.build/stage-store-quiet-payload
printf '%s\n' 'a quiet directory' > "$payload"

STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-quiet-put-once
STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-quiet-put-twice
grep -q 'added=0' tools/.build/stage-store-quiet-put-twice

resin=$(sed -n 's/^stage-store-put resin=\([^ ]*\).*/\1/p' tools/.build/stage-store-quiet-put-twice)
tmp=$(mktemp)
STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_read.sh "$resin" > "$tmp"
cmp -s "$tmp" "$payload"
rm -f "$tmp"

STAGE_STORE="$quiet" sh tools/fixtures/a/aurora_stage_store_list.sh > tools/.build/stage-store-quiet-put-list.out
grep -q 'count=1' tools/.build/stage-store-quiet-put-list.out
test -d "$quiet"

echo "stage-store-quiet-put count=1 second=unchanged remains=yes"
echo GREEN
