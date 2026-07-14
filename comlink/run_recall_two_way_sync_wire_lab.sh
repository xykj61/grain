#!/bin/sh
# comlink/run_recall_two_way_sync_wire_lab.sh — two-way sync device wire over virtio-net.
#
# Orchestration lives in tools/comlink_recall_two_way_sync_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_recall_two_way_sync_wire_lab.rish
