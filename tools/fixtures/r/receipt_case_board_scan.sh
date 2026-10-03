#!/bin/sh
# tools/fixtures/r/receipt_case_board_scan.sh -- the eight receipt cases, one reading.
#
# Each case runs through the witness that already holds it. Cases 1, 2, 3, and 5
# share the snapshot runner. Cases 6 and 7 share the refusal runner. Case 8 needs
# the source braid, the build, and the one-file import, all three. Case 4 records
# the source-order witness. This scan has no stamp verb: milestone=unstamped on
# every reading, including a short one.
#
# BOARD_BIN, when set, is a directory of stub runners named snapshot, still,
# refusal, braid, build, and third. Each is executed as sh "$BOARD_BIN/<name>".
#
#   sh tools/fixtures/r/receipt_case_board_scan.sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT HUP INT TERM

run_named() {
  key=$1
  needle=$2
  real=$3
  out="$work/$key.out"
  if [ -n "${BOARD_BIN:-}" ]; then
    sh "$BOARD_BIN/$key" >"$out" 2>&1
  else
    rishi/bin/rishi run "$real" >"$out" 2>&1
  fi
  rc=$?
  if [ "$rc" -eq 0 ] && grep -F -q "$needle" "$out"; then
    printf '%s\n' green
  else
    echo "detail: $key refused" >&2
    tail -n 12 "$out" >&2 || true
    printf '%s\n' red
  fi
}

set +e
snap=$(run_named snapshot "GREEN: receipt-snapshot runner" tools/m/mantra_receipt_offer_snapshot_witness.rish)
still=$(run_named still "GREEN: receipt-still-order" tools/r/receipt_still_order_witness.rish)
refusal=$(run_named refusal "GREEN: receipt-refusal-chain runner" tools/m/mantra_receipt_offer_refusal_chain_witness.rish)
braid=$(run_named braid "GREEN: product-braid" tools/r/receipt_product_braid_witness.rish)
build=$(run_named build "GREEN: braid-build" tools/r/receipt_braid_build_witness.rish)
third=$(run_named third "GREEN: third-import" tools/r/receipt_third_import_witness.rish)
set -e

mark() {
  if [ "$1" = green ]; then
    printf '%s\n' green
  else
    printf '%s\n' red
  fi
}

echo "case1=$(mark "$snap")"
echo "case2=$(mark "$snap")"
echo "case3=$(mark "$snap")"
if [ "$still" = green ]; then
  echo "case4=source_order"
else
  echo "case4=red"
fi
echo "case5=$(mark "$snap")"
echo "case6=$(mark "$refusal")"
echo "case7=$(mark "$refusal")"
if [ "$braid" = green ] && [ "$build" = green ] && [ "$third" = green ]; then
  echo "case8=green"
else
  echo "case8=red"
fi

if command -v swift >/dev/null 2>&1; then
  echo "swift_runtime=present"
else
  echo "swift_runtime=unverified"
fi
echo "milestone=unstamped"

short=0
[ "$snap" = green ] || short=1
[ "$still" = green ] || short=1
[ "$refusal" = green ] || short=1
[ "$braid" = green ] || short=1
[ "$build" = green ] || short=1
[ "$third" = green ] || short=1

if [ "$short" -eq 0 ]; then
  echo "verdict=unstamped"
  exit 0
fi
echo "verdict=short"
exit 1
