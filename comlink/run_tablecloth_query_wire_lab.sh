#!/bin/sh
# comlink/run_tablecloth_query_wire_lab.sh -- Tablecloth query device wire over virtio-net.
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" tablecloth_query
