#!/bin/sh
# Read one file from the lasting stage store. The only argument is the resin.

set -eu

resin="${1:?name the SHA3-512 resin}"
printf '%s\n' "$resin" | grep -Eq '^[0-9a-f]{128}$'

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
file="$root/aurora/.build/stage-resin-store/$resin"

if [ -f "$file" ]; then
  cat "$file"
  exit 0
fi

echo "stage-store-read missing" >&2
exit 1
