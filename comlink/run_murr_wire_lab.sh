#!/bin/sh
# comlink/run_murr_wire_lab.sh -- MUR M2b device wire over virtio-net (mint + receipt hops; was MALA).
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" murr
