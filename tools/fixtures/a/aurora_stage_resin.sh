#!/bin/sh
# Print one SHA3-512 resin for each of the six living Aurora stages.
# The store that would keep those resins stays unbuilt.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
count=0

for stage in seed relay named sealed wire posted; do
  file="$root/aurora/src/${stage}.rye"
  test -f "$file"
  resin=$(sh "$root/tools/fixtures/s/sha3.sh" 512 "$file")
  printf '%s\n' "$resin" | grep -Eq '^[0-9a-f]{128}$'
  echo "stage-resin ${stage} ${resin}"
  count=$((count + 1))
done

echo "stage-resin count=${count} width=512 store=unbuilt"
echo GREEN
