#!/usr/bin/env sh
# amber_manifest_tilak_witness.sh — I6: Tilak three-field manifest + legacy still reads.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
LEGACY_GOLDEN=97e0d0cd92e27cb4c8dd31d2af87c8940e7c6aed859ccca94c869383d482d96f
TILAK_GOLDEN=4cb2ad29bbdfd0acf84b10ee5d70f05996682d76e4cb7fe581178659b4cb81c8
SRC="$ROOT/tools/fixtures/amber_ring1_tree"
tmpdir=$(mktemp -d)
restore=$(mktemp -d)
trap 'rm -rf "$tmpdir" "$restore"' EXIT

# Legacy export still verifies against elder golden.
legacy=$(mktemp -d)
sh "$ROOT/tools/fixtures/amber_ring1_export_legacy.sh" "$SRC" "$legacy"
sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$legacy" "$LEGACY_GOLDEN"

# New writer emits Tilak lines; restore round-trips.
sh "$ROOT/tools/fixtures/amber_ring1_export.sh" "$SRC" "$tmpdir"
sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$tmpdir" "$TILAK_GOLDEN"
sh "$ROOT/tools/fixtures/amber_ring1_restore.sh" "$tmpdir" "$restore"
diff -r "$SRC" "$restore" >/dev/null

# Unwelcome — tampered resin refuses whole.
first_resin=$(ls "$tmpdir/resins" | head -n1)
printf 'X' >> "$tmpdir/resins/$first_resin"
if sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$tmpdir" 2>/dev/null; then
  echo "FAIL tampered resin should not verify"
  exit 1
fi

# Unwelcome — unknown mark refuses whole.
bad=$(mktemp -d)
cp -r "$tmpdir/resins" "$bad/"
cp "$tmpdir/manifest.bron" "$bad/manifest.bron"
printf 'entry bogus-mark %s nested/leaf.txt\n' "$first_resin" >> "$bad/manifest.bron"
if sh "$ROOT/tools/fixtures/amber_ring1_verify.sh" "$bad" 2>/dev/null; then
  echo "FAIL unknown mark should not verify"
  exit 1
fi

echo "GREEN: amber manifest Tilak — legacy golden, tilak golden, tamper and unknown mark refused"
