# Comlink device wire — sub-lap 1 opened

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260705.225412

## Prompt

Kaeden gave the word on the Linengrow-via-Comlink season climb. Claude counseled the device wire lap; Cursor seated the brief and opened sub-lap 1.

## Trace

Seated `active-designing/20260705-225412_comlink-device-wire.md`. Extracted `comlink/wire_format.rye` from hosted wire (no format fork). Added `comlink/device_wire.rye` with `WireSubject`, virtio descriptor fixture validation, and wire_format round-trip. Added `tools/comlink_device_wire.rish` (not wired to parity until sub-lap 3). Refactored `hosted_wire.rye` to import wire_format — hosted witness still GREEN. Parity **153** holds.

## Observations

Sub-laps 2–3 (two QEMU guests, sealed payload on wire) remain open. Edit-5 slot untouched.

## Files

- `active-designing/20260705-225412_comlink-device-wire.md` — seated lap brief
- `comlink/wire_format.rye` — shared datagram letter
- `comlink/device_wire.rye` — sub-lap 1 core
- `comlink/hosted_wire.rye` — refactored to wire_format
- `tools/comlink_device_wire.rish` — sub-lap 1 witness
- `tools/fixtures/opening_lines_scan.sh` · `tools/width-check.rish` — corpus rows
- `work-in-progress/TASKS.md` — device wire in flight
- `session-logs/20260705-225412_comlink-device-wire-sub-lap1.md` — this log
- `session-logs/20260705-224612_full-summary-commits-pushes.md` — prior summary (landed same commit)
- `session-logs/README.md` — index rows

**Recommend:** keep going to sub-lap 2 — two `virt` guests on QEMU hub netdev — mechanical once lab script lands; check in with Claude if virtio MMIO map needs close reading of gratitude before freestanding driver grows.
