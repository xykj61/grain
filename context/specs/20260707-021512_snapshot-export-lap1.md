# Snapshot Export — Lap 1 (I2)

**Stamp:** `20260707.021512 UDT` (Kaeden's clock)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Seated — lap 1 on metal; lap 2 horizon bundles seated `20260707.024712`

*Written by Kaeden and Rio 3.*

---

## Purpose

Export a in-memory `BoltCatalog` as a portable snapshot and replay it on a host with **identical recall** on every leaf. Lap 1 proves the manifest grammar reuse counsel ordered; weave slice, Brix closure, and continuity facts remain horizon.

## Grammar (no new manifest line shape)

The snapshot is a **concatenation of proven resin-batch frames** (`kind 0x03`, see [`20260707-011412_mantra-referential-namespace-reference.md`](20260707-011412_mantra-referential-namespace-reference.md) §9), one batch per distinct `(peer, bolt, revision)` group, wrapped by a small header:

| Field | Meaning |
|-------|---------|
| `kind` | `0x06` — snapshot container (distinct from batch `0x03`) |
| `version` | `snapshot_export_version` string |
| `leaf_count` | HEAD claim — import **must** match after all batches apply |
| `batch_count` | Number of following batches |
| `batch[i]` | `u32 len` + `len` bytes of one signed resin-batch |

Import applies each batch with `resin_batch.applyBatch`; any refusal leaves the destination empty.

## Implementation

| Surface | Home |
|---------|------|
| Export / import | `mantra/snapshot_export.rye` |
| Witness | `tools/mantra_snapshot_replay.rish` |

## Horizon (not lap 1)

Bundle prefixes (`trust/`, `weave/`, `catalog/`), SHA3-512 head record, continuity fact, Pond customs, and thin-edge boot replay — per [`counsel/20260704-181612_zero-copy-resins-counsel-answers.md`](../counsel/20260704-181612_zero-copy-resins-counsel-answers.md) I2–I4.
