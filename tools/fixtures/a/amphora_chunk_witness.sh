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

. "$ROOT/tools/fixtures/s/shell_portable.sh"

# THE TWO LONG-LIVED PROCESSES ARE BOUNDED, because an unbounded one stalls a roster pass rather
# than failing it. The source and the fetcher each speak UDP on a fixed port pair, and until
# `20260906` a lost datagram left this fixture waiting forever -- measured that day at one run in
# six to eight, alone on a quiet pier. The module carries the real repair now (it binds before it
# sends, holds one socket across an exchange, and bounds every receive by name), and this bound is
# the floor beneath it: whatever slips past, the fixture reds in a minute instead of stopping.
#
# THE PORT LOCK IS NOT TAKEN HERE. It belongs at every port-using step of the witness, and the
# witness holds it around this whole script -- `tools/fixtures/a/amphora_vessel_port_lock.sh`. A
# second acquire inside the first would deadlock against itself.
#
# `timeout` IS USED WHERE IT EXISTS AND NAMED WHERE IT DOES NOT. It is coreutils, so this pier has
# it and a BSD bench may not. A host without it is a host running one tree, where the collision
# this bounds cannot arise -- a reasoned exemption rather than a fallback that forgives a failure.
if have_tool timeout; then bound="timeout 60"; else bound=""; echo "note: no timeout(1) here -- the port lock stands alone"; fi
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

$bound "$BIN" source "$source" &
src_pid=$!
sleep 0.05
if ! $bound "$BIN" fetcher "$far"; then
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
