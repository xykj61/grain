# Kumara lap 9 — Aurora sealed migration

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.014700

**Prompt:** `kg` — migrate `aurora/src/sealed.rye` (single-hart sealed datagram).

## Thinking trace

1. Migrated `sealed.rye` using existing `aurora/src/kumara.rye` symlink — `keypair_from_seed`, `kumara.sign`, `kumara.verify`.
2. Pinned witness seeds via `kumara.seed_length`; refreshed module doc comments to Kumara vocabulary.
3. Ratchet **281 → 276** application sites.
4. Verified: freestanding build GREEN; QEMU run — attestation verified, message opened; `tame_style_scan_advise_selftest` GREEN.

## Observations

- Aurora hosted twin (`sealed_message_test`) and bare-metal `sealed`/`posted` now share Kumara seam discipline.
- Remaining bulk: virtio guests + `open_asks` cluster — tiered on touch.
- Laps 2–9 uncommitted; lap 1 at `dc9ebd8`.

## Files

| File | Why |
|------|-----|
| `aurora/src/sealed.rye` | Single-hart kumara migration |
| `tools/tame_style_scan_advise_selftest.rish` | Pin ratchet at 276 |
| `context/TAME_GUIDANCE.md` | Ratchet count |
| `work-in-progress/TASKS.md` | Lap 9 row |

**Recommend:** say `go` to commit laps 2–9 — substantial arc ready to ship; next kg can target virtio guest cluster or `open_asks` on touch.
