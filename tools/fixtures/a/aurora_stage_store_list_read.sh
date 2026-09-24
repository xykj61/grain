#!/bin/sh
# Take the first resin the store lists, and read those bytes back.
# No stage path is named.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"

list=$(sh tools/fixtures/a/aurora_stage_store_list.sh)
resin=$(printf '%s\n' "$list" | sed -n 's/^stage-store-list \([0-9a-f]\{128\}\)$/\1/p' | head -n 1)
test -n "$resin"

tmp=$(mktemp)
sh tools/fixtures/a/aurora_stage_store_read.sh "$resin" > "$tmp"
have=$(sh tools/fixtures/s/sha3.sh 512 "$tmp")
rm -f "$tmp"
test "$have" = "$resin"

echo "stage-store-list-read resin=${resin} same=yes"
echo GREEN
