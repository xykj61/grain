#!/usr/bin/env sh
# cellar_ring1_export.sh -- export with three-field Tilak manifest lines (I6).
#     entry plain-bytes <sha3-256-hex> <name>
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
OUT=${2:?usage: cellar_ring1_export.sh [source] outdir}
STAMP=${3:-20260707.031812}

rm -rf "$OUT"
mkdir -p "$OUT/resins"
MANIFEST="$OUT/manifest.bron"

{
  printf '%s\n' '# cellar ring-1 export manifest'
  printf 'format amber-ring1-v2-tilak\n'
  printf 'stamp %s\n' "$STAMP"
  printf 'source %s\n' "$(basename "$SRC")"
} > "$MANIFEST"

cd "$SRC"
find . -type f | LC_ALL=C sort | while IFS= read -r path; do
  rel=${path#./}
  digest=$(sh "$ROOT/tools/fixtures/s/sha3_256.sh" "$rel")
  cp "$rel" "$OUT/resins/$digest"
  printf 'entry plain-bytes %s %s\n' "$digest" "$rel" >> "$MANIFEST"
done

echo "EXPORT ok manifest=$MANIFEST"
