#!/usr/bin/env sh
# amber_ring1_export.sh — export with three-field Tilak manifest lines (I6).
#     entry plain-bytes <sha3-256-hex> <name>
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC=${1:-"$ROOT/tools/fixtures/amber_ring1_tree"}
OUT=${2:?usage: amber_ring1_export.sh [source] outdir}
STAMP=${3:-20260707.031812}

rm -rf "$OUT"
mkdir -p "$OUT/resins"
MANIFEST="$OUT/manifest.bron"

{
  printf '%s\n' '# amber ring-1 export manifest'
  printf 'format amber-ring1-v2-tilak\n'
  printf 'stamp %s\n' "$STAMP"
  printf 'source %s\n' "$(basename "$SRC")"
} > "$MANIFEST"

cd "$SRC"
find . -type f | LC_ALL=C sort | while IFS= read -r path; do
  rel=${path#./}
  digest=$(openssl dgst -sha3-256 -r "$rel" | awk '{print $1}')
  cp "$rel" "$OUT/resins/$digest"
  printf 'entry plain-bytes %s %s\n' "$digest" "$rel" >> "$MANIFEST"
done

echo "EXPORT ok manifest=$MANIFEST"
