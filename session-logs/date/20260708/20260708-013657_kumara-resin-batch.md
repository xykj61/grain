# Kumara lap 3 — resin_batch migration

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.013657

**Prompt:** `kg` — next mechanical Kumara cluster on touch.

## Thinking trace

1. Confirmed lap 2 (`snapshot_export` + Ed25519 ratchet) still uncommitted on disk alongside lap 1 (`dc9ebd8`).
2. Chose `mantra/resin_batch.rye` — NS-L3 frame, 7 Ed25519 sites, `comlink/resin_batch.rye` is symlink (one edit).
3. Migrated: `kumara.KeyPair`/`PublicKey`, `kumara.sign`, `kumara.verify_bytes`, `kumara.keypair_from_seed` in selftest.
4. Ratchet dropped **326 → 319** application sites; **33 → 32** files; updated selftest pin and TAME_GUIDANCE.
5. Verified GREEN: `mantra/bin/resin-batch selftest`, `mantra_resin_batch.rish`, `tame_style_scan_advise_selftest`, `snapshot-export selftest`.

## Observations

- `build_batch` sign path now routes through `kumara.sign` — behavior unchanged, unwelcome paths still GREEN.
- `apply_batch` uses `verify_bytes` rather than manual `fromBytes` + `verify` — cleaner seam.

## Files

| File | Why |
|------|-----|
| `mantra/resin_batch.rye` | Full kumara migration |
| `tools/tame_style_scan_advise_selftest.rish` | Pin ratchet at 319 |
| `context/TAME_GUIDANCE.md` | Ratchet count update |
| `work-in-progress/TASKS.md` | Lap 3 row |

**Recommend:** keep going to `mantra/recall_batch_delivery.rye` or `wire_format.rye` next — single-module, on-touch policy; say `go` to commit laps 2–3 together.
