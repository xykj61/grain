#!/bin/sh
# Plant source drift in the receipt Still/accessibility mapping and require refusal.
set -eu

root=$(pwd)
scan=$root/tools/fixtures/r/receipt_still_order_scan.sh
mkdir -p .lap
work=$(mktemp -d .lap/receipt-still-order.XXXXXX)
trap 'rm -rf "$work"' EXIT HUP INT TERM

copy_sources() {
  cp linengrow/receipt_offer.rye "$work/receipt.rye"
  cp skate/Sources/SkateCore/ReceiptCard.swift "$work/card.swift"
  cp skate/Sources/SkateCore/ReceiptAccessibilitySnapshot.swift "$work/snapshot.swift"
  cp skate/Tests/SkateCoreTests/ReceiptAccessibilitySnapshotTests.swift "$work/test.swift"
}

read_scan() {
  RECEIPT_RYE=$work/receipt.rye RECEIPT_CARD=$work/card.swift \
    RECEIPT_SNAPSHOT=$work/snapshot.swift RECEIPT_TEST=$work/test.swift sh "$scan"
}

mutate() {
  source_file=$1
  from=$2
  to=$3
  python3 - "$source_file" "$from" "$to" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
body = path.read_text()
assert body.count(sys.argv[2]) == 1, "plant must name exactly one source site"
path.write_text(body.replace(sys.argv[2], sys.argv[3], 1))
PY
}

copy_sources
healthy=$(read_scan)
printf '%s\n' "$healthy" | grep -q 'verdict=source_order_agrees'
echo 'leg_ok: healthy_source'

copy_sources
mutate "$work/snapshot.swift" 'index < 6 ? 5 : index' 'index < 6 ? 5 : index + 1'
if output=$(read_scan); then echo 'leg_failed: elder_row_map'; exit 1; fi
printf '%s\n' "$output" | grep -q 'drift=accessibility_row_map'
echo 'leg_ok: elder_row_map_refused'

copy_sources
mutate "$work/card.swift" 'basis    \(valueBasis)' 'basis    \(purpose)'
if output=$(read_scan); then echo 'leg_failed: still_field'; exit 1; fi
printf '%s\n' "$output" | grep -q 'drift=still_field_order'
echo 'leg_ok: still_field_refused'

copy_sources
mutate "$work/snapshot.swift" '("status", "status   ")' '("status", "issued   ")'
if output=$(read_scan); then echo 'leg_failed: accessibility_prefix'; exit 1; fi
printf '%s\n' "$output" | grep -q 'drift=label_prefix_10'
echo 'leg_ok: accessibility_prefix_refused'

copy_sources
mutate "$work/snapshot.swift" 'entries = Self.entries(from: lines)' 'entries = Self.entries(from: [])'
if output=$(read_scan); then echo 'leg_failed: detached_entries'; exit 1; fi
printf '%s\n' "$output" | grep -q 'drift=snapshot_entries_source'
echo 'leg_ok: detached_entries_refused'

copy_sources
healed=$(read_scan)
printf '%s\n' "$healed" | grep -q 'verdict=source_order_agrees'
echo 'leg_ok: restored_source'
echo 'control_legs=6'
echo 'control_failed=0'
echo 'control_verdict=ok'
