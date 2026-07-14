#!/usr/bin/env sh
# pond_customs_witness.sh — Pond customs: admit plain-bytes; hold await-word; refuse stranger.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
BIN="$ROOT/pond/bin/customs"

if ! test -x "$BIN"; then
  mkdir -p "$ROOT/pond/bin"
  env RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}" \
    "$ROOT/rye/bin/rye" build "$ROOT/pond/customs.rye" -femit-bin="$BIN"
fi

"$BIN" selftest >/dev/null

# Welcome
out=$("$BIN" inspect "$ROOT/tools/fixtures/pond_customs_welcome.bron" 2>&1)
echo "$out" | grep -q 'verdict=place' || { echo "FAIL welcome not place"; echo "$out"; exit 1; }
echo "$out" | grep -q 'GREEN' || { echo "FAIL welcome missing GREEN"; exit 1; }
echo "ADMIT ok plain-bytes"

# Hold — exit 1
set +e
hold_out=$("$BIN" inspect "$ROOT/tools/fixtures/pond_customs_hold.bron" 2>&1)
hold_code=$?
set -e
test "$hold_code" -eq 1 || { echo "FAIL hold exit want 1 got $hold_code"; echo "$hold_out"; exit 1; }
echo "$hold_out" | grep -q 'HOLD' || { echo "FAIL hold missing HOLD"; exit 1; }
echo "HOLD ok await-word"

# Refuse — exit 2
set +e
refuse_out=$("$BIN" inspect "$ROOT/tools/fixtures/pond_customs_refuse.bron" 2>&1)
refuse_code=$?
set -e
test "$refuse_code" -eq 2 || { echo "FAIL refuse exit want 2 got $refuse_code"; echo "$refuse_out"; exit 1; }
echo "$refuse_out" | grep -q 'REFUSE' || { echo "FAIL refuse missing REFUSE"; exit 1; }
echo "REFUSE ok stranger-mark"

# Amphora receipt path: pour + scrub must pass customs on live manifest.
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
STAMP=20260710.161125
home=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$far"' EXIT
sh "$ROOT/tools/fixtures/amphora_pour.sh" "$SRC" "$home" "$STAMP"
sh "$ROOT/tools/fixtures/amphora_carry.sh" "$home" "$far"
sh "$ROOT/tools/fixtures/amphora_scrub_arrival.sh" "$far" "$SRC"
echo "RECEIPT ok Amphora scrub passed Pond customs"

echo "GREEN: Pond customs — place, hold, refuse; Amphora receipt gated"
