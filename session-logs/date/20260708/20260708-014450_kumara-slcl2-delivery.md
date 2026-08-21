# Kumara lap 7 — SLC-L2 delivery migration

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.014450

**Prompt:** `kg` — migrate `linengrow/delivery.rye` (SLC-L2 sealed delivery).

## Thinking trace

1. Migrated SLC-L2 delivery: `slcl1_keypair()` helper via `kumara.keypair_from_seed(&rc.slcl1_seed)` — aligns with receipt cluster lap 1.
2. `kumara.sign`, `kumara.PublicKey`, `kumara.signature_length` through load/verify/recv paths.
3. Ratchet **297 → 290** application sites; **29 → 28** files.
4. Verified GREEN: `linengrow/bin/delivery selftest`, `slcl2_receipt.rish` (hosted + device), `tame_style_scan_advise_selftest`.

## Observations

- SLC-L2 now shares the same Kumara seam as SLC-L1 receipt_core — witness-pinned `slcl1_seed` unchanged.
- Laps 2–7 uncommitted; lap 1 at `dc9ebd8`.

## Files

| File | Why |
|------|-----|
| `linengrow/delivery.rye` | SLC-L2 kumara migration + `slcl1_keypair()` |
| `tools/tame_style_scan_advise_selftest.rish` | Pin ratchet at 290 |
| `context/TAME_GUIDANCE.md` | Ratchet count |
| `work-in-progress/TASKS.md` | Lap 7 row |

**Recommend:** keep going to `mantra/recall_batch_wire.rye` is done — next: `aurora/src/posted.rye` or guest virtio cluster; say `go` to commit laps 2–7.
