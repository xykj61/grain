#!/bin/sh
# Write each living stage under its SHA3-512 resin, then hand seed's bytes back.
# The directory lives for this run and is removed. A lasting store stays unbuilt.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
store=$(mktemp -d)
trap 'rm -rf "$store"' EXIT

seed_resin=""
wrote=0

for stage in seed relay named sealed wire posted; do
  file="$root/aurora/src/${stage}.rye"
  test -f "$file"
  resin=$(sh "$root/tools/fixtures/s/sha3.sh" 512 "$file")
  printf '%s\n' "$resin" | grep -Eq '^[0-9a-f]{128}$'
  cp "$file" "$store/$resin"
  if [ "$stage" = seed ]; then
    seed_resin=$resin
  fi
  wrote=$((wrote + 1))
done

cmp -s "$root/aurora/src/seed.rye" "$store/$seed_resin"
back=$(sh "$root/tools/fixtures/s/sha3.sh" 512 "$store/$seed_resin")
test "$back" = "$seed_resin"

missing=$(printf '0%.0s' $(seq 1 128))
test ! -e "$store/$missing"

before=$(wc -c < "$store/$seed_resin")
cp "$root/aurora/src/seed.rye" "$store/$seed_resin"
after=$(wc -c < "$store/$seed_resin")
test "$before" = "$after"
cmp -s "$root/aurora/src/seed.rye" "$store/$seed_resin"

echo "stage-store wrote=${wrote} read=seed same=yes missing=nothing second=unchanged lasting=unbuilt"
echo GREEN
