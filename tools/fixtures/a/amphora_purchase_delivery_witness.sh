#!/usr/bin/env sh
# amphora_purchase_delivery_witness.sh -- pour work -> delivery slip -> scrub -> verify bind.
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

sh "$ROOT/tools/fixtures/a/amphora_pour.sh" "$SRC" "$home" "$STAMP"
parent=$(awk '/^parent / {print $2; exit}' "$home/vessel.kyri")
test -n "$parent"

# Fixture payment digest -- stands for a MALA receipt name (commerce coin already seated).
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
} > "$home/delivery.kyri"

"$BIN" sign "$home/delivery.kyri" >/dev/null
grep -q '^stamp_sig ' "$home/delivery.kyri"

sh "$ROOT/tools/fixtures/a/amphora_carry.sh" "$home" "$far"
# Carry also needs the delivery slip.
cp "$home/delivery.kyri" "$far/delivery.kyri"

sh "$ROOT/tools/fixtures/a/amphora_scrub_arrival.sh" "$far" "$SRC"
"$BIN" verify "$far/delivery.kyri" "$far/vessel.kyri" >/dev/null
echo "DELIVERY ok slip bound to vessel parent"

# Unwelcome: flip payment nibble -- verify must refuse.
pay_line=$(grep '^payment ' "$far/delivery.kyri")
first=$(printf '%s' "$pay_line" | awk '{print substr($2,1,1)}')
rest=$(printf '%s' "$pay_line" | awk '{print substr($2,2)}')
case "$first" in
  a) bad=b ;;
  *) bad=a ;;
esac
{
  grep -v '^payment ' "$far/delivery.kyri"
  printf 'payment %s%s\n' "$bad" "$rest"
} > "$far/delivery.kyri.bad"
mv "$far/delivery.kyri.bad" "$far/delivery.kyri"

if "$BIN" verify "$far/delivery.kyri" "$far/vessel.kyri" 2>/dev/null; then
  echo "FAIL tampered payment should not verify"
  exit 1
fi
echo "TAMPER refused"

echo "GREEN: Amphora purchase delivery — slip signed, scrubbed, bound, tamper refused"
