# Kumara lap 5 — wire_format migration

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260708.013951

**Prompt:** `kg` — migrate `comlink/wire_format.rye` (X25519 bridge on kumara.KeyPair).

## Thinking trace

1. Migrated sealed-datagram layout: `kumara.keypair_from_seed`, `kumara.sign`, `kumara.verify_bytes`, `kumara.signature_length` for offsets.
2. X25519 bridge unchanged in shape — `fromEd25519` / `publicKeyFromEd25519` still name Ed25519 in API strings (four lines remain in ratchet grep; expected).
3. Symlinks `mantra/wire_format.rye` and `linengrow/wire_format.rye` follow automatically.
4. Ratchet **310 → 303** application sites (seven crypto call sites removed).
5. Verified GREEN: `comlink_hosted_wire.rish`, `mantra_recall_batch_wire.rish`, `tame_style_scan_advise_selftest`.

## Observations

- `wire_format` still appears in file grep because X25519 method names contain `Ed25519` — honest ratchet, not a missed migration.
- Laps 2–5 remain uncommitted with lap 1 at `dc9ebd8`.

## Files

| File | Why |
|------|-----|
| `comlink/wire_format.rye` | Kumara migration at Comlink seal seam |
| `tools/tame_style_scan_advise_selftest.rish` | Pin ratchet at 303 |
| `context/TAME_GUIDANCE.md` | Ratchet count |
| `work-in-progress/TASKS.md` | Lap 5 row |

**Recommend:** keep going to `mantra/recall_batch_wire.rye` (one `Ed25519.PublicKey` type site) or `aurora/src/sealed.rye` next — single-module; say `go` to commit laps 2–5.
