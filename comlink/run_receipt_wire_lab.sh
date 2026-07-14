#!/bin/sh
# comlink/run_receipt_wire_lab.sh — SLC-L2 sealed receipt over virtio-net (device wire variant).
#
# Orchestration lives in tools/comlink_receipt_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_receipt_wire_lab.rish
