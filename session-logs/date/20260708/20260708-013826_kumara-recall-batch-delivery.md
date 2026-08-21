# Kumara lap 4 — recall_batch_delivery migration

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.013826

**Prompt:** `kg` — next mechanical Kumara cluster.

## Thinking trace

1. Compared `wire_format.rye` (X25519 coupling) vs `recall_batch_delivery.rye` (9 straightforward Ed25519 sites) — chose delivery for a clean single-file lap.
2. Migrated: `kumara` import, `batch_signer_seed` via `kumara.seed_length`, `batch_signer()` helper calling `keypair_from_seed`; replaced seven `generateDeterministic` call sites.
3. Ratchet **319 → 310** application sites; **32 → 31** files.
4. Verified GREEN: `recall-batch-delivery selftest` (3w-4 seal, chunk, beaded), `mantra_recall_batch_wire.rish`, `tame_style_scan_advise_selftest`.

## Observations

- `recall_batch_wire.rye` still names `Ed25519.PublicKey` in one signature — stays for a future lap; delivery lap behavior-preserving.
- Laps 2–4 remain uncommitted on disk with lap 1 at `dc9ebd8`.

## Files

| File | Why |
|------|-----|
| `mantra/recall_batch_delivery.rye` | Kumara migration + `batch_signer()` helper |
| `tools/tame_style_scan_advise_selftest.rish` | Pin ratchet at 310 |
| `context/TAME_GUIDANCE.md` | Ratchet count |
| `work-in-progress/TASKS.md` | Lap 4 row |

**Recommend:** keep going to `comlink/wire_format.rye` next — X25519 bridge stays on `kumara.KeyPair`; say `go` to commit laps 2–4.
