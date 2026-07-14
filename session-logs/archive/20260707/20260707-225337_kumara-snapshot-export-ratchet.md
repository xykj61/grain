# Kumara lap 2 — snapshot_export + Ed25519 ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.225337

**Prompt:** Claude Code bundle handoff — verify state, migrate `mantra/snapshot_export.rye`, add tracked Ed25519 ratchet (326 sites / 33 files).

## Thinking trace

1. Confirmed first lap already landed (`dc9ebd8`): `tally/kumara.rye`, receipt cluster, `kumara_seed` witness.
2. `snapshot_export.rye` still had 13 direct `Ed25519` sites — migrated to `kumara` types and `keypair_from_seed`.
3. Added Ed25519 ratchet to `tame_style_scan_advise.rish` and legacy `tame_style_scan.sh` advise-legacy — map+join pattern matching `@memcpy` and `parseInt`.
4. Pinned selftest at **326** application sites (348 total − 9 canonical in `tally/kumara.rye` − 13 migrated from snapshot_export).
5. Documented seam in `context/TAME_GUIDANCE.md`; updated `work-in-progress/TASKS.md`.
6. Verified GREEN: `mantra/bin/snapshot-export selftest`, `tame_style_scan_advise_selftest`, `kumara_seed`.

## Observations

- Zip bundle not present on disk — implemented from Claude report verbatim; counts match empirically.
- `snapshot_export` uses kumara types only — no direct sign calls in that file; behavior-preserving migration.
- Remaining 33 files (guest virtio, open_asks, wire_format, resin_batch, etc.) stay on touch — tiered care per counsel.

## Files

| File | Why |
|------|-----|
| `mantra/snapshot_export.rye` | Full kumara migration — types + `keypair_from_seed` |
| `tools/tame_style_scan_advise.rish` | Ed25519 ratchet (native) |
| `tools/fixtures/tame_style_scan.sh` | Ed25519 ratchet (legacy advise) |
| `tools/tame_style_scan_advise_selftest.rish` | Pin 326 application sites |
| `context/TAME_GUIDANCE.md` | Kumara seam section + ratchet table row |
| `work-in-progress/TASKS.md` | Lap 2 status |

**Recommend:** keep going to repoint Ed25519 sites on touch within one module at a time (e.g. `resin_batch.rye` next) — mechanical, follows written policy; say `go` when ready to commit.
