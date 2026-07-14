#!/usr/bin/env sh
# amphora_vessel_stamp_witness.sh — pour signed vessel, scrub verifies, tamper refuses.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
STAMP=20260710.145843

home=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$far"' EXIT

sh "$ROOT/tools/fixtures/amphora_pour.sh" "$SRC" "$home" "$STAMP"
grep -q '^stamp_sig ' "$home/vessel.bron"
"$ROOT/amphora/bin/vessel-core" verify "$home/vessel.bron" >/dev/null

sh "$ROOT/tools/fixtures/amphora_carry.sh" "$home" "$far"
sh "$ROOT/tools/fixtures/amphora_scrub_arrival.sh" "$far" "$SRC"

# Unwelcome: flip one stamp_sig hex nibble — scrub/verify must refuse.
sig_line=$(grep '^stamp_sig ' "$far/vessel.bron")
# rewrite stamp_sig with a flipped first hex digit
first=$(printf '%s' "$sig_line" | awk '{print substr($2,1,1)}')
rest=$(printf '%s' "$sig_line" | awk '{print substr($2,2)}')
case "$first" in
  a) bad=b ;;
  *) bad=a ;;
esac
{
  grep -v '^stamp_sig ' "$far/vessel.bron"
  printf 'stamp_sig %s%s\n' "$bad" "$rest"
} > "$far/vessel.bron.bad"
mv "$far/vessel.bron.bad" "$far/vessel.bron"

if "$ROOT/amphora/bin/vessel-core" verify "$far/vessel.bron" 2>/dev/null; then
  echo "FAIL tampered stamp_sig should not verify"
  exit 1
fi
echo "TAMPER refused"

echo "GREEN: Amphora vessel stamp — pour signed, scrub verified, tamper refused"
