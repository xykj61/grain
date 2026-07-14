#!/bin/sh
# comlink/run_mala_wire_lab.sh — MALA M2b device wire over virtio-net (mint + receipt hops).
#
# Orchestration lives in tools/comlink_mala_wire_lab.rish (spawn / wait-for).
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_mala_wire_lab.rish
