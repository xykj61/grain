# Kumara lap 8 — Aurora posted migration

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.014659

**Prompt:** `kg` — migrate `aurora/src/posted.rye` (bare-metal sealed datagram between two harts).

## Thinking trace

1. Added `aurora/src/kumara.rye` symlink → `tally/kumara.rye` so freestanding Aurora can import the seam.
2. Migrated `posted.rye` mirroring `wire_format`: `keypair_from_seed`, `kumara.sign`, `verify_bytes`, `signature_length` offsets; updated comments to avoid false ratchet hits.
3. Four `fromEd25519` X25519 bridge lines remain — expected, same as hosted wire_format.
4. Ratchet **290 → 281** application sites.
5. Verified: freestanding build GREEN; QEMU SMP=2 run — attestation verified, message opened; `tame_style_scan_advise_selftest` GREEN.

## Observations

- Kumara works on freestanding riscv64 — crypto seam is portable across hosted and Aurora.
- `aurora/src/sealed.rye` (single-hart) is the natural next lap — same symlink home.
- Laps 2–8 uncommitted; lap 1 at `dc9ebd8`.

## Files

| File | Why |
|------|-----|
| `aurora/src/kumara.rye` | Symlink → tally |
| `aurora/src/posted.rye` | Kumara migration on two-hart posted stage |
| `tools/tame_style_scan_advise_selftest.rish` | Pin ratchet at 281 |
| `context/TAME_GUIDANCE.md` | Ratchet count |
| `work-in-progress/TASKS.md` | Lap 8 row |

**Recommend:** keep going to `aurora/src/sealed.rye` next — same symlink, single-hart twin; say `go` to commit laps 2–8.
