#!/bin/sh
# comlink/run_recall_subscribe_poll_wire_lab.sh — poll wire device: one cycle body = catch-up rev 2.
#
# Orchestration lives in tools/comlink_recall_subscribe_poll_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_recall_subscribe_poll_wire_lab.rish
