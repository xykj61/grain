#!/usr/bin/env sh
# amphora_pour.sh — pour an Amber ring-1 season into an Amphora vessel bundle.
#
# Layout (cellar + vessel at one dock):
#   outdir/manifest.bron
#   outdir/resins/<digest>
#   outdir/vessel.bron
#
# Usage: amphora_pour.sh [source_tree] outdir [stamp]
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC=${1:-"$ROOT/tools/fixtures/amber_ring1_tree"}
OUT=${2:?usage: amphora_pour.sh [source] outdir [stamp]}
STAMP=${3:-20260710.143726}

sh "$ROOT/tools/fixtures/amber_ring1_export.sh" "$SRC" "$OUT" "$STAMP"

MANIFEST="$OUT/manifest.bron"
VESSEL="$OUT/vessel.bron"
PARENT=$(openssl dgst -sha3-256 -r "$MANIFEST" | awk '{print $1}')

{
  printf '%s\n' '# amphora vessel — Amber season poured for crossing'
  printf 'format amphora-v1\n'
  printf 'stamp %s\n' "$STAMP"
  printf 'shoulder amber-ring1-season\n'
  printf 'parent %s\n' "$PARENT"
  while read -r line; do
    case "$line" in
      entry\ *)
        set -- $line
        shift
        # Tilak: mark digest name
        printf 'cargo %s %s %s\n' "$1" "$2" "$3"
        ;;
    esac
  done < "$MANIFEST"
} > "$VESSEL"

cargo_count=$(grep -c '^cargo ' "$VESSEL" || true)
test "$cargo_count" -ge 1 || { echo "FAIL pour produced no cargo"; exit 1; }

# Kumara vessel stamp — Amber seal first, then sign canonical sealed body.
vessel_bin="$ROOT/amphora/bin/vessel-core"
seal_bin="$ROOT/amphora/bin/vessel-seal"
if ! test -x "$vessel_bin"; then
  mkdir -p "$ROOT/amphora/bin"
  env RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}" \
    "$ROOT/rye/bin/rye" build "$ROOT/amphora/vessel_core.rye" -femit-bin="$vessel_bin"
fi
if ! test -x "$seal_bin"; then
  mkdir -p "$ROOT/amphora/bin"
  env RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}" \
    "$ROOT/rye/bin/rye" build "$ROOT/amphora/vessel_seal.rye" -femit-bin="$seal_bin"
fi
"$seal_bin" seal "$VESSEL" >/dev/null
grep -q '^seal_nonce ' "$VESSEL" || { echo "FAIL missing seal_nonce after seal"; exit 1; }
grep -q '^seal_cargo ' "$VESSEL" || { echo "FAIL missing seal_cargo after seal"; exit 1; }
"$vessel_bin" sign "$VESSEL" >/dev/null
grep -q '^stamp_sig ' "$VESSEL" || { echo "FAIL missing stamp_sig after sign"; exit 1; }

echo "POUR ok vessel=$VESSEL parent=$PARENT cargo=$cargo_count sealed stamped"
