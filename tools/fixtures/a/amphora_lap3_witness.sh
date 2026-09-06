#!/usr/bin/env sh
# amphora_lap3_witness.sh -- pour small season -> Comlink fetch resins -> cold scrub.
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
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
STAMP=20260710.144309
BIN="$ROOT/amphora/bin/vessel-fetch-delivery"

test -x "$BIN" || { echo "FAIL missing $BIN — build amphora lap 3 first"; exit 1; }

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

source=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$source" "$far"' EXIT

# Source holds the full poured bundle.
sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$SRC" "$source" "$STAMP"
test -f "$source/vessel.bron"
test -d "$source/resins"
grep -q '^seal_cargo ' "$source/vessel.bron"
grep -q '^stamp_sig ' "$source/vessel.bron"

# Far peer receives vessel + manifest only -- resins cross by Comlink fetch.
cp "$source/vessel.bron" "$source/manifest.bron" "$far/"
mkdir -p "$far/resins"
test ! -f "$far/resins/"* 2>/dev/null || {
  # ensure empty resins dir
  rm -f "$far/resins/"*
}

# Hosted UDP: source serves, fetcher fills far/resins.
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

# Cold scrub on arrival at the far peer.
sh "$ROOT/tools/fixtures/a/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome: wipe a resin and prove verify fails without re-fetch.
first=$(ls "$far/resins" | head -n1)
printf 'X' >> "$far/resins/$first"
if sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$far" 2>/dev/null; then
  echo "FAIL tampered far resin should not verify"
  exit 1
fi

echo "GREEN: Amphora lap 3 — Comlink fetch-by-digest, cold scrub, tamper refused"
