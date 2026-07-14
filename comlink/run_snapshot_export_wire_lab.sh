#!/bin/sh
# comlink/run_snapshot_export_wire_lab.sh — I2 snapshot lap 3 device wire (one revision batch hop).
#
# Orchestration lives in tools/comlink_snapshot_export_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_snapshot_export_wire_lab.rish
