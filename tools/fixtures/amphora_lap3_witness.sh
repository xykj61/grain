#!/usr/bin/env sh
# amphora_lap3_witness.sh — pour small season → Comlink fetch resins → cold scrub.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
STAMP=20260710.144309
BIN="$ROOT/amphora/bin/vessel-fetch-delivery"

test -x "$BIN" || { echo "FAIL missing $BIN — build amphora lap 3 first"; exit 1; }

source=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$source" "$far"' EXIT

# Source holds the full poured bundle.
sh "$ROOT/tools/fixtures/amphora_pour.sh" "$SRC" "$source" "$STAMP"
test -f "$source/vessel.bron"
test -d "$source/resins"
grep -q '^seal_cargo ' "$source/vessel.bron"
grep -q '^stamp_sig ' "$source/vessel.bron"

# Far peer receives vessel + manifest only — resins cross by Comlink fetch.
cp "$source/vessel.bron" "$source/manifest.bron" "$far/"
mkdir -p "$far/resins"
test ! -f "$far/resins/"* 2>/dev/null || {
  # ensure empty resins dir
  rm -f "$far/resins/"*
}

# Hosted UDP: source serves, fetcher fills far/resins.
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

# Cold scrub on arrival at the far peer.
sh "$ROOT/tools/fixtures/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome: wipe a resin and prove verify fails without re-fetch.
first=$(ls "$far/resins" | head -n1)
printf 'X' >> "$far/resins/$first"
if sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$far" 2>/dev/null; then
  echo "FAIL tampered far resin should not verify"
  exit 1
fi

echo "GREEN: Amphora lap 3 — Comlink fetch-by-digest, cold scrub, tamper refused"
