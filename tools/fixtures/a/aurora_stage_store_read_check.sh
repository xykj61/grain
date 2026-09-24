#!/bin/sh
# Learn seed's resin, then read the store with that hex alone.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"

sh tools/fixtures/a/aurora_stage_store_lasting.sh >/dev/null
resin=$(sh tools/fixtures/s/sha3.sh 512 aurora/src/seed.rye)
tmp=$(mktemp)
sh tools/fixtures/a/aurora_stage_store_read.sh "$resin" > "$tmp"
cmp -s "$tmp" aurora/src/seed.rye
rm -f "$tmp"

missing=$(printf '0%.0s' $(seq 1 128))
if sh tools/fixtures/a/aurora_stage_store_read.sh "$missing" >/dev/null 2>&1; then
  exit 1
fi
if grep -q 'aurora/src' tools/fixtures/a/aurora_stage_store_read.sh; then
  exit 1
fi

echo "stage-store-read resin-only=yes same=yes missing=nothing"
echo GREEN
