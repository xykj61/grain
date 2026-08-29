#!/usr/bin/env sh
# amphora_lap2_witness.sh -- pour Cellar season -> carry far -> cold scrub; 3-2-1 fixture scale.
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
SRC="$ROOT/tools/fixtures/cellar_ring1_tree"
STAMP=20260710.143726

home=$(mktemp -d)
dock=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$dock" "$far"' EXIT

# (1) Home cellar -- pour season into vessel bundle.
sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$SRC" "$home" "$STAMP"
test -f "$home/vessel.bron"
test -f "$home/manifest.bron"
test -d "$home/resins"

# (2) Dock copy -- second media path holding the same vessel bundle.
sh "$ROOT/tools/fixtures/a/amphora_carry.sh" "$home" "$dock"

# (3) Far node -- one far away.
sh "$ROOT/tools/fixtures/a/amphora_carry.sh" "$dock" "$far"

# Three copies present and distinct paths.
test -d "$home" && test -d "$dock" && test -d "$far"
test "$home" != "$dock"
test "$dock" != "$far"
test "$home" != "$far"
echo "THREE_COPIES ok home=$home dock=$dock far=$far"

# Cold scrub on arrival at the far node.
sh "$ROOT/tools/fixtures/a/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome -- tampered resin on far copy refuses whole.
first_resin=$(ls "$far/resins" | head -n1)
printf 'X' >> "$far/resins/$first_resin"
if sh "$ROOT/tools/fixtures/c/cellar_ring1_verify.sh" "$far" 2>/dev/null; then
  echo "FAIL tampered far resin should not verify"
  exit 1
fi
echo "TAMPER refused on far copy"

echo "GREEN: Amphora lap 2 — pour, carry, cold scrub, 3-2-1 fixture, tamper refused"
