#!/bin/sh
# comlink/run_murr_wire_lab.sh — MUR M2b device wire over virtio-net (mint + receipt hops; was MALA).
#
# Orchestration lives in tools/co/comlink_murr_wire_lab.rish (spawn / wait-for).
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/co/comlink_murr_wire_lab.rish
