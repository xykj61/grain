#!/bin/sh
# comlink/run_recall_subscribe_poll_wire_lab.sh -- poll wire device: one cycle body = catch-up rev 2.
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" recall_subscribe_poll
