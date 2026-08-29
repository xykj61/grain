#!/usr/bin/env sh
# cellar_manifest_tilak_witness.sh -- I6: Tilak three-field manifest + legacy still reads.
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
LEGACY_GOLDEN=fdca5dfde2bd63212322248a8f95e351c087bd6b0b14016de66a55d69cc090a4
TILAK_GOLDEN=a0ddfe504f39d04b44a35cb1b43ac4220ca93abf8bea02df9ed0040e44d41978
SRC="$ROOT/tools/fixtures/cellar_ring1_tree"
tmpdir=$(mktemp -d)
restore=$(mktemp -d)
trap 'rm -rf "$tmpdir" "$restore"' EXIT

# Legacy export still verifies against elder golden.
legacy=$(mktemp -d)
sh "$ROOT/tools/fixtures/c/cellar_ring1_export_legacy.sh" "$SRC" "$legacy"
sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$legacy" "$LEGACY_GOLDEN"

# New writer emits Tilak lines; restore round-trips.
sh "$ROOT/tools/fixtures/c/cellar_ring1_export.sh" "$SRC" "$tmpdir"
sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$tmpdir" "$TILAK_GOLDEN"
sh "$ROOT/tools/fixtures/c/cellar_ring1_restore.sh" "$tmpdir" "$restore"
diff -r "$SRC" "$restore" >/dev/null

# Unwelcome -- tampered resin refuses whole.
first_resin=$(ls "$tmpdir/resins" | head -n1)
printf 'X' >> "$tmpdir/resins/$first_resin"
if sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$tmpdir" 2>/dev/null; then
  echo "FAIL tampered resin should not verify"
  exit 1
fi

# Unwelcome -- unknown mark refuses whole.
bad=$(mktemp -d)
cp -r "$tmpdir/resins" "$bad/"
cp "$tmpdir/manifest.bron" "$bad/manifest.bron"
printf 'entry bogus-mark %s nested/leaf.txt\n' "$first_resin" >> "$bad/manifest.bron"
if sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$bad" 2>/dev/null; then
  echo "FAIL unknown mark should not verify"
  exit 1
fi

echo "GREEN: cellar manifest Tilak — legacy golden, tilak golden, tamper and unknown mark refused"
