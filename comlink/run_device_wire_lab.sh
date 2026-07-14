#!/bin/sh
# comlink/run_device_wire_lab.sh — device-wire lab on two QEMU virt guests.
#
# Orchestration lives in tools/comlink_device_wire_lab.rish (spawn / wait-for).
# This entry point keeps the stable path named in design docs and guest headers.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
repo="$(cd "$here/.." && pwd)"
cd "$repo"

exec rishi/bin/rishi run tools/comlink_device_wire_lab.rish
