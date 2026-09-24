#!/bin/sh
# Put one fixed byte string, put it again, and read it back by resin.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
mkdir -p tools/.build

payload=tools/.build/stage-store-put-payload
printf '%s\n' 'any bytes may land' > "$payload"

sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-put-once
sh tools/fixtures/a/aurora_stage_store_put.sh < "$payload" > tools/.build/stage-store-put-twice

resin=$(sed -n 's/^stage-store-put resin=\([^ ]*\).*/\1/p' tools/.build/stage-store-put-twice)
tmp=$(mktemp)
sh tools/fixtures/a/aurora_stage_store_read.sh "$resin" > "$tmp"
cmp -s "$tmp" "$payload"
rm -f "$tmp"

grep -q 'added=0' tools/.build/stage-store-put-twice
cat tools/.build/stage-store-put-once
cat tools/.build/stage-store-put-twice
echo "stage-store-put read=yes"
echo GREEN
