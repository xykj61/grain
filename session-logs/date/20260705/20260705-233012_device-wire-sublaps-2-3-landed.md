# Device wire sub-laps 2–3 landed — Claude ruling applied

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260705.233012

## Prompt

Kaeden delivered Claude's anchor `233012` proposal bundle (`files (19).zip`): virtio ruling, corrected driver, `aurora/layout.ld` boot fix, sealed guests, witness.

## Thinking trace

Extracted `veganreyklah2-20260705-233012-device-wire-sublap2-sublap3-proposed.zip` from the bundle. Applied ruling, `layout.ld`, `virtio_net.rye`, guests, lab script, witness. Fixed `.rye` header typo and `device_wire` selftest negotiation assert. Verified on metal: sub-lap 1 selftest GREEN, lab pattern + sealed GREEN, Aurora seed exit 0, `comlink_device_wire.rish` GREEN. Updated lap brief, counsel handoff, TASKS. Parity **154** not wired — ruling waits on Kaeden red-then-green.

## Root cause (from ruling)

Hang was boot layout, not virtio poll: `ReleaseFast` placed `.eh_frame` at reset address; fix discards unwind sections and folds small-data into parents. Virtio fixes: modern MMIO offsets, `force-legacy=false`, VERSION_1 + MAC, 12-byte header, per-queue volatile rings.

## Files

| File | Why |
|------|-----|
| `active-designing/20260705-233012_virtio-tx-ruling.md` | Claude ruling seated |
| `aurora/layout.ld` | Shared freestanding boot fix |
| `comlink/virtio_net.rye` | Corrected driver |
| `comlink/guest_*` | Pattern + sealed guests |
| `comlink/run_device_wire_lab.sh` | Both laps |
| `tools/comlink_device_wire.rish` | Witness sub-laps 2+3 |
| Briefs, TASKS, counsel handoff | Status updates |

**Recommend:** keep going to wire `comlink_device_wire.rish` into `parity.rish` when Kaeden gives the word — mechanical red-then-green → **154**; then SLC-L2 carriage is unblocked.
