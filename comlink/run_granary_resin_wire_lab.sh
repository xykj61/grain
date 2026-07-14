#!/bin/sh
# comlink/run_granary_resin_wire_lab.sh — Granary resin-serve device wire over virtio-net.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_granary_resin_wire_lab.rish
