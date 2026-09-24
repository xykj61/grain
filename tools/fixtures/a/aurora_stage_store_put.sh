#!/bin/sh
# Write standard input into the lasting stage store under its SHA3-512 resin.
# A resin already held is left unchanged.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
store="$root/aurora/.build/stage-resin-store"
mkdir -p "$store"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
cat > "$tmp"

resin=$(sh "$root/tools/fixtures/s/sha3.sh" 512 "$tmp")
printf '%s\n' "$resin" | grep -Eq '^[0-9a-f]{128}$'
dest="$store/$resin"

if [ -f "$dest" ]; then
  cmp -s "$tmp" "$dest"
  added=0
else
  cp "$tmp" "$dest"
  added=1
fi

echo "stage-store-put resin=${resin} added=${added}"
echo GREEN
