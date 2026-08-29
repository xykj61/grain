#!/bin/sh
# comlink/run_device_wire_lab.sh -- device-wire lab on two QEMU virt guests.
# One body for all labs lives beside this file: run_wire_lab.sh (since 20260829).
exec sh "$(cd "$(dirname "$0")" && pwd)/run_wire_lab.sh" device
