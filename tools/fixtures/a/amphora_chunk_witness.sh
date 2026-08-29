#!/usr/bin/env sh
# amphora_chunk_witness.sh -- pour season with 400 B resin -> Comlink chunked fetch -> scrub.
set -eu
# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
SRC="$ROOT/tools/fixtures/amphora_chunk_tree"
STAMP=20260710.154300
BIN="$ROOT/amphora/bin/vessel-fetch-delivery"

test -x "$BIN" || { echo "FAIL missing $BIN — build amphora chunk lap first"; exit 1; }
test "$(wc -c < "$SRC/big.txt")" -eq 400 || { echo "FAIL big.txt must be 400 bytes"; exit 1; }

source=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$source" "$far"' EXIT

sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$SRC" "$source" "$STAMP"
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
big_digest=$(sh "$ROOT/tools/fixtures/s/sha3_256.sh" "$SRC/big.txt")
test -f "$far/resins/$big_digest"
test "$(wc -c < "$far/resins/$big_digest")" -eq 400
cmp -s "$SRC/big.txt" "$far/resins/$big_digest"

sh "$ROOT/tools/fixtures/a/amphora_scrub_arrival.sh" "$far" "$SRC"

echo "GREEN: Amphora resin chunk — 400 B cargo fetched in chunks, scrubbed cold"
