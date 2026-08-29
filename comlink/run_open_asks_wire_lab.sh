#!/bin/sh
# comlink/run_open_asks_wire_lab.sh -- OA-L2 device wire over virtio-net (request + application hops).
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" open_asks
