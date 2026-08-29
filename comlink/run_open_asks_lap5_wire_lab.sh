#!/bin/sh
# comlink/run_open_asks_lap5_wire_lab.sh -- OA-L5 device wire (acceptance + completion + consent hops).
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" open_asks_lap5
