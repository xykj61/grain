# Kumara lap 6 — recall_batch_wire + snapshot_export_delivery

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.014118

**Prompt:** `kg` — next mechanical Kumara cluster.

## Thinking trace

1. Paired two small NS-L3 / I2 seams: `recall_batch_wire.rye` (one `PublicKey` type) and `snapshot_export_delivery.rye` (delivery pattern matching recall_batch_delivery).
2. Added `kumara` import + `batch_signer()` helper on snapshot export delivery; `apply_wire_batch` now names `kumara.PublicKey`.
3. Ratchet **303 → 297** application sites; **31 → 29** files.
4. Verified GREEN: `snapshot-export-delivery selftest`, `mantra_snapshot_wire.rish`, `mantra_recall_batch_wire.rish`, `tame_style_scan_advise_selftest`.

## Observations

- I2 lap 3 hosted crossing and NS-L3 batch wire share the same signer seed (`0x61`) — behavior preserved.
- Laps 2–6 uncommitted; lap 1 at `dc9ebd8`.

## Files

| File | Why |
|------|-----|
| `mantra/recall_batch_wire.rye` | `kumara.PublicKey` on `apply_wire_batch` |
| `mantra/snapshot_export_delivery.rye` | Full kumara migration + `batch_signer()` |
| `tools/tame_style_scan_advise_selftest.rish` | Pin ratchet at 297 |
| `context/TAME_GUIDANCE.md` | Ratchet count |
| `work-in-progress/TASKS.md` | Lap 6 row |

**Recommend:** keep going to `linengrow/delivery.rye` (SLC-L2, 7 sites) or guest virtio cluster on touch — say `go` to commit laps 2–6.
