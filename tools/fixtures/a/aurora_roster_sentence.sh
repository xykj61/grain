#!/bin/sh
# The roster speaks four pairs. The sealed sentence the virtio guests open
# is the same sentence aurora/src/posted.rye seals. No second virtio driver.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$root"
sentence='Meet me where the rye grows.'

mkdir -p tools/.build
env RYE_ZIG=vendor/zig-toolchain/zig sh tools/fixtures/r/rye_build.sh \
  caravan/channels.rye -femit-bin=tools/.build/aurora_roster_sentence >/dev/null
pairs=$(tools/.build/aurora_roster_sentence selftest 2>&1)
printf '%s\n' "$pairs" | grep -q "pair serial_driver serial_virt" || {
  echo "roster-sentence missing serial_driver serial_virt"
  exit 1
}
printf '%s\n' "$pairs" | grep -q "pair serial_virt client_a" || exit 1
printf '%s\n' "$pairs" | grep -q "pair serial_virt client_b" || exit 1
printf '%s\n' "$pairs" | grep -q "pair client_a timer_driver" || exit 1
count=$(printf '%s\n' "$pairs" | grep -c "channels: pair " || true)
if [ "$count" -ne 4 ]; then
  echo "roster-sentence pair count was $count"
  exit 1
fi

grep -F "$sentence" comlink/wire_format.rye >/dev/null
grep -F "$sentence" aurora/src/posted.rye >/dev/null
grep -F "expected_message" comlink/guest_sealed_rx.rye >/dev/null
grep -F "expected_message" comlink/guest_sealed_tx.rye >/dev/null || grep -F "seal_datagram" comlink/guest_sealed_tx.rye >/dev/null

echo "roster-sentence pairs=4 sentence=shared"
echo "GREEN"
