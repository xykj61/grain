#!/bin/sh
# comlink/run_vessel_fetch_wire_lab.sh -- Amphora vessel-fetch device wire over virtio-net.
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" vessel_fetch
