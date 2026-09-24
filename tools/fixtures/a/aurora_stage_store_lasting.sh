#!/bin/sh
# Keep each living stage under its SHA3-512 resin in a directory that remains.
# A missing resin is added. A resin already held is left unchanged.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
store="$root/aurora/.build/stage-resin-store"
mkdir -p "$store"

added=0
held=0
seed_resin=""

for stage in seed relay named sealed wire posted; do
  file="$root/aurora/src/${stage}.rye"
  test -f "$file"
  resin=$(sh "$root/tools/fixtures/s/sha3.sh" 512 "$file")
  printf '%s\n' "$resin" | grep -Eq '^[0-9a-f]{128}$'
  dest="$store/$resin"
  if [ -f "$dest" ]; then
    cmp -s "$file" "$dest"
    held=$((held + 1))
  else
    cp "$file" "$dest"
    added=$((added + 1))
  fi
  if [ "$stage" = seed ]; then
    seed_resin=$resin
  fi
done

cmp -s "$root/aurora/src/seed.rye" "$store/$seed_resin"
files=$(find "$store" -type f | wc -l | tr -d ' ')
test -d "$store"

echo "stage-store-lasting added=${added} held=${held} stages=6 files=${files} read=seed same=yes remains=yes"
echo GREEN
