#!/usr/bin/env sh
# cellar_ring1_witness.sh -- welcome and unwelcome paths for cellar_first_ring.rish
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
GOLDEN=fdca5dfde2bd63212322248a8f95e351c087bd6b0b14016de66a55d69cc090a4
SRC="$ROOT/tools/fixtures/cellar_ring1_tree"
tmpdir=$(mktemp -d)
restore=$(mktemp -d)
trap 'rm -rf "$tmpdir" "$restore"' EXIT

sh "$ROOT/tools/fixtures/c/cellar_ring1_export_legacy.sh" "$SRC" "$tmpdir"
sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$tmpdir" "$GOLDEN"
sh "$ROOT/tools/fixtures/c/cellar_ring1_restore.sh" "$tmpdir" "$restore"
diff -r "$SRC" "$restore" >/dev/null

# unwelcome -- one resin byte tampered must fail verify
first_resin=$(ls "$tmpdir/resins" | head -n1)
printf 'X' >> "$tmpdir/resins/$first_resin"
if sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$tmpdir" 2>/dev/null; then
  echo "FAIL tampered resin should not verify"
  exit 1
fi

echo "GREEN: cellar first ring — export, golden, restore, tamper refused"
