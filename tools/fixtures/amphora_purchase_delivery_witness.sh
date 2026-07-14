#!/usr/bin/env sh
# amphora_purchase_delivery_witness.sh — pour work → delivery slip → scrub → verify bind.
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
SRC="$ROOT/tools/fixtures/amphora_lap3_tree"
STAMP=20260710.161358
BIN="$ROOT/amphora/bin/purchase-delivery"

if ! test -x "$BIN"; then
  mkdir -p "$ROOT/amphora/bin"
  env RYE_ZIG="${RYE_ZIG:-$ROOT/vendor/zig-toolchain/zig}" \
    "$ROOT/rye/bin/rye" build "$ROOT/amphora/purchase_delivery.rye" -femit-bin="$BIN"
fi

home=$(mktemp -d)
far=$(mktemp -d)
trap 'rm -rf "$home" "$far"' EXIT

sh "$ROOT/tools/fixtures/amphora_pour.sh" "$SRC" "$home" "$STAMP"
parent=$(awk '/^parent / {print $2; exit}' "$home/vessel.bron")
test -n "$parent"

# Fixture payment digest — stands for a MALA receipt name (commerce coin already seated).
payment=cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

{
  printf '%s\n' '# commerce delivery slip — purchased work'
  printf 'format commerce-delivery-v1\n'
  printf 'stamp %s\n' "$STAMP"
  printf 'shoulder purchased-work\n'
  printf 'vessel_parent %s\n' "$parent"
  printf 'payment %s\n' "$payment"
  printf 'buyer alice\n'
  printf 'seller bob\n'
} > "$home/delivery.bron"

"$BIN" sign "$home/delivery.bron" >/dev/null
grep -q '^stamp_sig ' "$home/delivery.bron"

sh "$ROOT/tools/fixtures/amphora_carry.sh" "$home" "$far"
# Carry also needs the delivery slip.
cp "$home/delivery.bron" "$far/delivery.bron"

sh "$ROOT/tools/fixtures/amphora_scrub_arrival.sh" "$far" "$SRC"
"$BIN" verify "$far/delivery.bron" "$far/vessel.bron" >/dev/null
echo "DELIVERY ok slip bound to vessel parent"

# Unwelcome: flip payment nibble — verify must refuse.
pay_line=$(grep '^payment ' "$far/delivery.bron")
first=$(printf '%s' "$pay_line" | awk '{print substr($2,1,1)}')
rest=$(printf '%s' "$pay_line" | awk '{print substr($2,2)}')
case "$first" in
  a) bad=b ;;
  *) bad=a ;;
esac
{
  grep -v '^payment ' "$far/delivery.bron"
  printf 'payment %s%s\n' "$bad" "$rest"
} > "$far/delivery.bron.bad"
mv "$far/delivery.bron.bad" "$far/delivery.bron"

if "$BIN" verify "$far/delivery.bron" "$far/vessel.bron" 2>/dev/null; then
  echo "FAIL tampered payment should not verify"
  exit 1
fi
echo "TAMPER refused"

echo "GREEN: Amphora purchase delivery — slip signed, scrubbed, bound, tamper refused"
