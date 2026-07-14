#!/bin/sh
# comlink/run_vessel_fetch_wire_lab.sh — Amphora vessel-fetch device wire over virtio-net.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_vessel_fetch_wire_lab.rish
