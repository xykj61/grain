#!/bin/sh
# comlink/run_recall_batch_wire_lab.sh -- NS-L3 batch wire device (request + batch hops).
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" recall_batch
