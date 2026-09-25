#!/bin/sh
# List every resin the lasting stage store holds. Each name is checked
# against the bytes. No stage path is named.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
store=${STAGE_STORE:-$root/aurora/.build/stage-resin-store}
count=0

if [ -d "$store" ]; then
  for file in "$store"/*; do
    [ -f "$file" ] || continue
    resin=$(basename "$file")
    printf '%s\n' "$resin" | grep -Eq '^[0-9a-f]{128}$'
    have=$(sh "$root/tools/fixtures/s/sha3.sh" 512 "$file")
    test "$have" = "$resin"
    echo "stage-store-list ${resin}"
    count=$((count + 1))
  done
fi

echo "stage-store-list count=${count}"
if [ "$count" -eq 0 ]; then
  exit 1
fi
echo GREEN
