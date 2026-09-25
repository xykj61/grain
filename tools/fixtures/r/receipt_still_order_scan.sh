#!/bin/sh
# Read the published receipt fields, Still rows, and accessibility mapping together.
# This is a source check for hosts without Swift; the XCTest remains the runtime proof.
set -eu

python3 - <<'PY'
import os
import re
import sys
from pathlib import Path


def source(name, default):
    path = Path(os.environ.get(name, default))
    try:
        return path.read_text(encoding="utf-8")
    except OSError as error:
        print(f"unreadable={path}: {error}")
        print("verdict=unreadable")
        sys.exit(1)


def block(text, start, end, name):
    match = re.search(re.escape(start) + r"(.*?)" + re.escape(end), text, re.S)
    if match is None:
        print(f"missing_block={name}")
        print("verdict=order_drift")
        sys.exit(1)
    return match.group(1)


rye = source("RECEIPT_RYE", "linengrow/receipt_offer.rye")
card = source("RECEIPT_CARD", "skate/Sources/SkateCore/ReceiptCard.swift")
snapshot = source("RECEIPT_SNAPSHOT", "skate/Sources/SkateCore/ReceiptAccessibilitySnapshot.swift")
test = source("RECEIPT_TEST", "skate/Tests/SkateCoreTests/ReceiptAccessibilitySnapshotTests.swift")

receipt = block(rye, "pub const LinengrowReceipt = struct {", "};", "LinengrowReceipt")
fields = re.findall(r"^\s+([a-z_]+):", receipt, re.M)
swift_to_rye = {
    "receiptID": "receipt_id",
    "productID": "product_id",
    "purpose": "purpose",
    "recipientID": "recipient_id",
    "offeredValue": "offered_value",
    "valueUnit": "value_unit",
    "valueBasis": "value_basis",
    "promisedReturn": "promised_return",
    "issuedAt": "issued_at",
    "expiresAt": "expires_at",
    "status": "status",
}
card_rows = block(card, "let lines = [", "\n    ]", "Still rows")
rows = []
for line in card_rows.splitlines():
    match = re.match(r'\s*"([^"\n]*)"\s*,?$', line)
    if match:
        rows.append(match.group(1))
row_fields = []
for row in rows:
    for variable in re.findall(r"\\\(([A-Za-z][A-Za-z0-9]*)\)", row):
        row_fields.append(swift_to_rye.get(variable, f"unknown:{variable}"))

label_block = block(snapshot, "let labels = [", "\n    ]", "accessibility labels")
labels = re.findall(r'\("([a-z_]+)",\s*"([^"\n]+)"\)', label_block)
names = [name for name, _ in labels]
failures = []
if len(fields) != 11 or len(set(fields)) != 11:
    failures.append("published_fields")
if fields != row_fields:
    failures.append("still_field_order")
if fields != names:
    failures.append("accessibility_field_order")
if len(rows) != 12:
    failures.append("still_row_count")
if len(labels) == 11 and len(rows) == 12:
    expected_rows = [1, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10]
    for index, (_, prefix) in enumerate(labels):
        if not rows[expected_rows[index]].startswith(prefix):
            failures.append(f"label_prefix_{index}")
if re.search(r"^\s*let row = index < 4 \? index \+ 1 : index < 6 \? 5 : index\s*$", snapshot, re.M) is None:
    failures.append("accessibility_row_map")
for name, fragment in [
    ("snapshot_still_source", "lines = card.stillFrame()"),
    ("snapshot_entries_source", "entries = Self.entries(from: lines)"),
    ("still_semantic_source", "lines.append(accessibilityLine(row: row) ?? [])"),
    ("deciding_count", "public static let decidingFieldCount = 11"),
    ("runtime_test", "testStillAndAccessibilitySnapshotKeepAllDecidingFieldsInOneOrder"),
]:
    if fragment not in (card if name == "still_semantic_source" else test if name == "runtime_test" else snapshot):
        failures.append(name)

print(f"published_fields={len(fields)}")
print(f"still_rows={len(rows)}")
print(f"accessibility_labels={len(labels)}")
print("swift_runtime=unverified_on_this_host")
for failure in failures:
    print(f"drift={failure}")
print("verdict=" + ("order_drift" if failures else "source_order_agrees"))
sys.exit(bool(failures))
PY
