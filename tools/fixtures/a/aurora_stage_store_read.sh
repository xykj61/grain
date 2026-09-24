#!/bin/sh
# Read one file from the lasting stage store. The only argument is the resin.

set -eu

resin="${1:?name the SHA3-512 resin}"
printf '%s\n' "$resin" | grep -Eq '^[0-9a-f]{128}$'

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
file="$root/aurora/.build/stage-resin-store/$resin"

if [ -f "$file" ]; then
  have=$(sh "$root/tools/fixtures/s/sha3.sh" 512 "$file")
  if [ "$have" = "$resin" ]; then
    cat "$file"
    exit 0
  fi
fi

echo "stage-store-read missing" >&2
exit 1
