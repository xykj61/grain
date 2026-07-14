#!/bin/sh
# comlink/run_open_asks_escrow_wire_lab.sh — OA-L3 lap 2 device wire (hold + release hops).
#
# Orchestration lives in tools/comlink_open_asks_escrow_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_open_asks_escrow_wire_lab.rish
