#!/bin/sh
# Read every resin the store lists. Each read's bytes must hash to that name.
# No stage path is named.

set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
mkdir -p tools/.build

list=$(sh tools/fixtures/a/aurora_stage_store_list.sh)
names=tools/.build/stage-store-list-names.txt
out=tools/.build/stage-store-list-read-all.out
: > "$out"
printf '%s\n' "$list" | sed -n 's/^stage-store-list \([0-9a-f]\{128\}\)$/\1/p' > "$names"

read_count=0
while read -r resin; do
  [ -n "$resin" ] || continue
  tmp=$(mktemp)
  sh tools/fixtures/a/aurora_stage_store_read.sh "$resin" > "$tmp"
  have=$(sh tools/fixtures/s/sha3.sh 512 "$tmp")
  rm -f "$tmp"
  test "$have" = "$resin"
  echo "stage-store-list-read-all ${resin}" >> "$out"
  read_count=$((read_count + 1))
done < "$names"

list_count=$(printf '%s\n' "$list" | sed -n 's/^stage-store-list count=//p')
test "$read_count" = "$list_count"
test "$read_count" -ge 6
cat "$out"
echo "stage-store-list-read-all count=${read_count} same=yes"
echo GREEN
