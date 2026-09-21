#!/usr/bin/env sh
# forge_view_pour.sh -- pour amphora_lap3_tree into a fixed forge-view bundle.
#
# Witnesses call this before forgeviewtest so Skate folds a live pour, not a
# hand-curated static manifest. Bundle path is gitignored.
#
# Usage: forge_view_pour.sh
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
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
OUT="$ROOT/tools/fixtures/.forge_view_bundle"
STAMP=20260710.145313

rm -rf "$OUT"
sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$SRC" "$OUT" "$STAMP"
test -f "$OUT/manifest.kyri"
test -f "$OUT/vessel.kyri"
test -d "$OUT/resins"
grep -q '^seal_nonce ' "$OUT/vessel.kyri"
grep -q '^seal_cargo ' "$OUT/vessel.kyri"
grep -q '^stamp_sig ' "$OUT/vessel.kyri"
entries=$(grep -c '^entry ' "$OUT/manifest.kyri")
test "$entries" -eq 2

echo "FORGE_POUR ok bundle=$OUT stamp=$STAMP sealed entries=$entries"
