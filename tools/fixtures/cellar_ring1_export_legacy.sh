#!/usr/bin/env sh
# cellar_ring1_export_legacy.sh — ring-1 export with legacy entry lines (relpath + digest).
# Preserved for the elder golden at parity 144; new exports use cellar_ring1_export.sh.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC=${1:-"$ROOT/tools/fixtures/cellar_ring1_tree"}
OUT=${2:?usage: cellar_ring1_export_legacy.sh [source] outdir}
STAMP=${3:-20260703.051812}

rm -rf "$OUT"
mkdir -p "$OUT/resins"
MANIFEST="$OUT/manifest.bron"

{
  printf '%s\n' '# cellar ring-1 export manifest'
  printf 'format amber-ring1-v1\n'
  printf 'stamp %s\n' "$STAMP"
  printf 'source %s\n' "$(basename "$SRC")"
} > "$MANIFEST"

# Resolved BEFORE the cd, since everything after it is relative to the source tree rather than
# to this repository.
SHA3_ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
cd "$SRC"
find . -type f | LC_ALL=C sort | while IFS= read -r path; do
  rel=${path#./}
  digest=$(sh "$SHA3_ROOT/tools/fixtures/sha3_256.sh" "$rel")
  cp "$rel" "$OUT/resins/$digest"
  printf 'entry %s %s\n' "$rel" "$digest" >> "$MANIFEST"
done

echo "EXPORT ok manifest=$MANIFEST"
