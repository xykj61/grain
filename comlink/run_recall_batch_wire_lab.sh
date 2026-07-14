#!/bin/sh
# comlink/run_recall_batch_wire_lab.sh — NS-L3 batch wire device (request + batch hops).
#
# Orchestration lives in tools/comlink_recall_batch_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_recall_batch_wire_lab.rish
