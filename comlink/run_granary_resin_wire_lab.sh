#!/bin/sh
# comlink/run_granary_resin_wire_lab.sh -- Granary resin-serve device wire over virtio-net.
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" granary_resin
