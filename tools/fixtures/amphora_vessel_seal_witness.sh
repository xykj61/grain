#!/usr/bin/env sh
# amphora_vessel_seal_witness.sh — pour sealed+stamped vessel; scrub opens seal; tamper refuses.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
STAMP=20260710.153745

home=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$far"' EXIT

sh "$ROOT/tools/fixtures/amphora_pour.sh" "$SRC" "$home" "$STAMP"
grep -q '^seal_nonce ' "$home/vessel.bron"
grep -q '^seal_tag ' "$home/vessel.bron"
grep -q '^seal_cargo ' "$home/vessel.bron"
grep -q '^stamp_sig ' "$home/vessel.bron"
# Clear cargo must be gone after seal.
if grep -q '^cargo ' "$home/vessel.bron"; then
  echo "FAIL clear cargo still present after seal"
  exit 1
fi
"$ROOT/amphora/bin/vessel-core" verify "$home/vessel.bron" >/dev/null
"$ROOT/amphora/bin/vessel-seal" open-check "$home/vessel.bron" >/dev/null

sh "$ROOT/tools/fixtures/amphora_carry.sh" "$home" "$far"
sh "$ROOT/tools/fixtures/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome: flip one seal_cargo hex nibble — open-check must refuse.
cargo_line=$(grep '^seal_cargo ' "$far/vessel.bron")
first=$(printf '%s' "$cargo_line" | awk '{print substr($2,1,1)}')
rest=$(printf '%s' "$cargo_line" | awk '{print substr($2,2)}')
case "$first" in
  a) bad=b ;;
  *) bad=a ;;
esac
{
  grep -v '^seal_cargo ' "$far/vessel.bron"
  printf 'seal_cargo %s%s\n' "$bad" "$rest"
} > "$far/vessel.bron.bad"
mv "$far/vessel.bron.bad" "$far/vessel.bron"

if "$ROOT/amphora/bin/vessel-seal" open-check "$far/vessel.bron" 2>/dev/null; then
  echo "FAIL tampered seal_cargo should not open"
  exit 1
fi
echo "TAMPER refused"

echo "GREEN: Amphora vessel seal — pour sealed, scrub opened, tamper refused"
