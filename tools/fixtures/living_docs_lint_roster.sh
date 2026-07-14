#!/usr/bin/env sh
# docs/ compression shelf
for f in docs/*.md; do
  [ -f "$f" ] || continue
  echo "$f"
done
# four living hammocks (product · suite · proven-seat · seam)
echo "active-designing/proven-seat-guest-hammock.md"
echo "active-designing/seam-season-hammock.md"
echo "active-designing/20260712-063558_receipt-verify-wasm-hammock.md"
echo "active-designing/20260712-063213_door3-consumer-edge-pass-hammock.md"
# module READMEs (core bench)
for f in rye/README.md rishi/README.md tally/README.md caravan/README.md mantra/README.md comlink/README.md pond/README.md aurora/README.md; do
  [ -f "$f" ] && echo "$f"
done
