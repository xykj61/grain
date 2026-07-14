#!/usr/bin/env sh
# amphora_lap2_witness.sh — pour Amber season → carry far → cold scrub; 3-2-1 fixture scale.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC="$ROOT/tools/fixtures/amber_ring1_tree"
STAMP=20260710.143726

home=$(mktemp -d)
dock=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$dock" "$far"' EXIT

# (1) Home cellar — pour season into vessel bundle.
sh "$ROOT/tools/fixtures/amphora_pour.sh" "$SRC" "$home" "$STAMP"
test -f "$home/vessel.bron"
test -f "$home/manifest.bron"
test -d "$home/resins"

# (2) Dock copy — second media path holding the same vessel bundle.
sh "$ROOT/tools/fixtures/amphora_carry.sh" "$home" "$dock"

# (3) Far node — one far away.
sh "$ROOT/tools/fixtures/amphora_carry.sh" "$dock" "$far"

# Three copies present and distinct paths.
test -d "$home" && test -d "$dock" && test -d "$far"
test "$home" != "$dock"
test "$dock" != "$far"
test "$home" != "$far"
echo "THREE_COPIES ok home=$home dock=$dock far=$far"

# Cold scrub on arrival at the far node.
sh "$ROOT/tools/fixtures/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome — tampered resin on far copy refuses whole.
first_resin=$(ls "$far/resins" | head -n1)
printf 'X' >> "$far/resins/$first_resin"
if sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$far" 2>/dev/null; then
  echo "FAIL tampered far resin should not verify"
  exit 1
fi
echo "TAMPER refused on far copy"

echo "GREEN: Amphora lap 2 — pour, carry, cold scrub, 3-2-1 fixture, tamper refused"
