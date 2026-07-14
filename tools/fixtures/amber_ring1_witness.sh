#!/usr/bin/env sh
# amber_ring1_witness.sh — welcome and unwelcome paths for amber_first_ring.rish
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
GOLDEN=97e0d0cd92e27cb4c8dd31d2af87c8940e7c6aed859ccca94c869383d482d96f
SRC="$ROOT/tools/fixtures/amber_ring1_tree"
tmpdir=$(mktemp -d)
restore=$(mktemp -d)
trap 'rm -rf "$tmpdir" "$restore"' EXIT

sh "$ROOT/tools/fixtures/amber_ring1_export_legacy.sh" "$SRC" "$tmpdir"
sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$tmpdir" "$GOLDEN"
sh "$ROOT/tools/fixtures/amber_ring1_restore.sh" "$tmpdir" "$restore"
diff -r "$SRC" "$restore" >/dev/null

# unwelcome — one resin byte tampered must fail verify
first_resin=$(ls "$tmpdir/resins" | head -n1)
printf 'X' >> "$tmpdir/resins/$first_resin"
if sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$tmpdir" 2>/dev/null; then
  echo "FAIL tampered resin should not verify"
  exit 1
fi

echo "GREEN: amber first ring — export, golden, restore, tamper refused"
