#!/usr/bin/env sh
# cellar_ring1_witness.sh — welcome and unwelcome paths for cellar_first_ring.rish
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
GOLDEN=151b9c6d7efd9d7240368acf7eb81f4a75a4099f62e09ad7610e0658dc2d4fea
SRC="$ROOT/tools/fixtures/cellar_ring1_tree"
tmpdir=$(mktemp -d)
restore=$(mktemp -d)
trap 'rm -rf "$tmpdir" "$restore"' EXIT

sh "$ROOT/tools/fixtures/cellar_ring1_export_legacy.sh" "$SRC" "$tmpdir"
sh "$ROOT/tools/fixtures/cellar_ring1_verify.sh" "$tmpdir" "$GOLDEN"
sh "$ROOT/tools/fixtures/cellar_ring1_restore.sh" "$tmpdir" "$restore"
diff -r "$SRC" "$restore" >/dev/null

# unwelcome — one resin byte tampered must fail verify
first_resin=$(ls "$tmpdir/resins" | head -n1)
printf 'X' >> "$tmpdir/resins/$first_resin"
if sh "$ROOT/tools/fixtures/cellar_ring1_verify.sh" "$tmpdir" 2>/dev/null; then
  echo "FAIL tampered resin should not verify"
  exit 1
fi

echo "GREEN: cellar first ring — export, golden, restore, tamper refused"
