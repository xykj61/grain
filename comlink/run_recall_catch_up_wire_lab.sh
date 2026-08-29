#!/bin/sh
# comlink/run_recall_catch_up_wire_lab.sh -- catch-up device wire over virtio-net.
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" recall_catch_up
