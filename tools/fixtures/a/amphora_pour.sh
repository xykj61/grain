#!/usr/bin/env sh
# amphora_pour.sh -- pour a cellar ring-1 season into an Amphora vessel bundle.
#
# Layout (cellar + vessel at one dock):
#   outdir/manifest.bron
#   outdir/resins/<digest>
#   outdir/vessel.bron
#
# Usage: amphora_pour.sh [source_tree] outdir [stamp]
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
SRC=${1:-"$ROOT/tools/fixtures/cellar_ring1_tree"}
OUT=${2:?usage: amphora_pour.sh [source] outdir [stamp]}
STAMP=${3:-20260710.143726}

sh "$ROOT/tools/fixtures/c/cellar_ring1_export.sh" "$SRC" "$OUT" "$STAMP"

MANIFEST="$OUT/manifest.bron"
VESSEL="$OUT/vessel.bron"
PARENT=$(sh "$ROOT/tools/fixtures/s/sha3_256.sh" "$MANIFEST")

{
  printf '%s\n' '# amphora vessel — Cellar season poured for crossing'
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

# Kumara vessel stamp -- Cellar seal first, then sign canonical sealed body.
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
