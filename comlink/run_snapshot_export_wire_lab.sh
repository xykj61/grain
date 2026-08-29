#!/bin/sh
# comlink/run_snapshot_export_wire_lab.sh -- I2 snapshot lap 3 device wire (one revision batch hop).
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" snapshot_export
