# I2 snapshot lap 3 device wire — virtio leg complete

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.051512

## Thinking trace

Counsel `044112` ring 3: snapshot device wire finishes lap 3 on virtio — same batch exchange per revision group, not lap 4 territory. Four virtio guests (`guest_snapshot_*`) prove one revision-batch hop with `held_count=0` matching `snapshot_export_delivery.rye`. Lab `comlink/run_snapshot_export_wire_lab.sh` on ports **15567**/**15568**. Extended `tools/mantra_snapshot_wire.rish` (hosted selftest + device lab); parity **187** unchanged (witness extended).

## Observations

Lap 3 is now complete on both substrates — hosted **38490**/**38491** and device **15567**/**15568**. Next in seated order: host-mirror under supervision, then TASKS sweep.

## Files

- `comlink/guest_snapshot_{fetcher_tx,source_rx,source_tx,fetcher_rx}.rye` — device guests
- `comlink/run_snapshot_export_wire_lab.sh` — virtio lab
- `tools/mantra_snapshot_wire.rish` — hosted + device
- `mantra/README.md` · `context/specs/20260707-042512_snapshot-export-lap3.md` · `TASKS.md` · `ROADMAP.md`

**Recommend:** keep going to host-mirror under supervision — Caravan ring 4 in counsel order; mechanical once mirror pair-list + supervisor shape is clear.
