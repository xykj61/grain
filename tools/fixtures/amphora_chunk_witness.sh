#!/usr/bin/env sh
# amphora_chunk_witness.sh — pour season with 400 B resin → Comlink chunked fetch → scrub.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC="$ROOT/tools/fixtures/amphora_chunk_tree"
STAMP=20260710.154300
BIN="$ROOT/amphora/bin/vessel-fetch-delivery"

test -x "$BIN" || { echo "FAIL missing $BIN — build amphora chunk lap first"; exit 1; }
test "$(wc -c < "$SRC/big.txt")" -eq 400 || { echo "FAIL big.txt must be 400 bytes"; exit 1; }

source=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$source" "$far"' EXIT

sh "$ROOT/tools/fixtures/amphora_pour.sh" "$SRC" "$source" "$STAMP"
test -f "$source/vessel.bron"
grep -q '^seal_cargo ' "$source/vessel.bron"

cp "$source/vessel.bron" "$source/manifest.bron" "$far/"
mkdir -p "$far/resins"
rm -f "$far/resins/"*

"$BIN" source "$source" &
src_pid=$!
sleep 0.05
if ! "$BIN" fetcher "$far"; then
  kill "$src_pid" 2>/dev/null || true
  wait "$src_pid" 2>/dev/null || true
  echo "FAIL fetcher"
  exit 1
fi
wait "$src_pid"

# Far resins must include the 400-byte body bit-faithful.
big_digest=$(openssl dgst -sha3-256 -r "$SRC/big.txt" | awk '{print $1}')
test -f "$far/resins/$big_digest"
test "$(wc -c < "$far/resins/$big_digest")" -eq 400
cmp -s "$SRC/big.txt" "$far/resins/$big_digest"

sh "$ROOT/tools/fixtures/amphora_scrub_arrival.sh" "$far" "$SRC"

echo "GREEN: Amphora resin chunk — 400 B cargo fetched in chunks, scrubbed cold"
