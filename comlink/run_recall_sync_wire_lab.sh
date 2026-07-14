#!/bin/sh
# comlink/run_recall_sync_wire_lab.sh — NS-L3 wire lap 2 device wire over virtio-net.
#
# Orchestration lives in tools/comlink_recall_sync_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_recall_sync_wire_lab.rish
