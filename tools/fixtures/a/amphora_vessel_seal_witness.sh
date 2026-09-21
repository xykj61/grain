#!/usr/bin/env sh
# amphora_vessel_seal_witness.sh -- pour sealed+stamped vessel; scrub opens seal; tamper refuses.
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
STAMP=20260710.153745

home=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$far"' EXIT

sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$SRC" "$home" "$STAMP"
grep -q '^seal_nonce ' "$home/vessel.kyri"
grep -q '^seal_tag ' "$home/vessel.kyri"
grep -q '^seal_cargo ' "$home/vessel.kyri"
grep -q '^stamp_sig ' "$home/vessel.kyri"
# Clear cargo must be gone after seal.
if grep -q '^cargo ' "$home/vessel.kyri"; then
  echo "FAIL clear cargo still present after seal"
  exit 1
fi
"$ROOT/amphora/bin/vessel-core" verify "$home/vessel.kyri" >/dev/null
"$ROOT/amphora/bin/vessel-seal" open-check "$home/vessel.kyri" >/dev/null

sh "$ROOT/tools/fixtures/a/amphora_carry.sh" "$home" "$far"
sh "$ROOT/tools/fixtures/a/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome: flip one seal_cargo hex nibble -- open-check must refuse.
cargo_line=$(grep '^seal_cargo ' "$far/vessel.kyri")
first=$(printf '%s' "$cargo_line" | awk '{print substr($2,1,1)}')
rest=$(printf '%s' "$cargo_line" | awk '{print substr($2,2)}')
case "$first" in
  a) bad=b ;;
  *) bad=a ;;
esac
{
  grep -v '^seal_cargo ' "$far/vessel.kyri"
  printf 'seal_cargo %s%s\n' "$bad" "$rest"
} > "$far/vessel.kyri.bad"
mv "$far/vessel.kyri.bad" "$far/vessel.kyri"

if "$ROOT/amphora/bin/vessel-seal" open-check "$far/vessel.kyri" 2>/dev/null; then
  echo "FAIL tampered seal_cargo should not open"
  exit 1
fi
echo "TAMPER refused"

echo "GREEN: Amphora vessel seal — pour sealed, scrub opened, tamper refused"
