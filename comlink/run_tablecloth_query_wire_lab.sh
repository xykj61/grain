#!/bin/sh
# comlink/run_tablecloth_query_wire_lab.sh — Tablecloth query device wire over virtio-net.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_tablecloth_query_wire_lab.rish
