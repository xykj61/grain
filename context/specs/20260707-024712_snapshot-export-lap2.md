# Snapshot export — lap 2 (horizon bundles)

**Stamp:** `20260707.024712 UDT` (Kaeden's clock)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Seated — lap 2 on metal; lap 1 grammar retained

*Written by Kaeden and Rio 3.*

---

## Purpose

Extend I2 snapshot export with counsel's horizon bundles: `catalog/` and `trust/` name prefixes, a SHA3-512 **head record**, and a continuity fact sketch (I7). Import verifies the head record before the replay stands.

Lap 1 (`20260707.021512`) remains the batch-frame substrate; lap 2 stages a prefixed catalog and meta leaves before calling the same `exportCatalog` / `importCatalog` path.

## Bundle prefixes

| Prefix | Role |
|--------|------|
| `catalog/` | Every exported leaf from the source catalog |
| `catalog/HEAD` | Manifest-marked head record (meta peer `_snap` / bolt `_meta`) |
| `trust/export-signer.pk` | Export signer's Ed25519 public key (32 bytes, plain-bytes) |

## Head record

Line-oriented manifest resin (`tilak: manifest`). Fields:

- `head-digest-sha3-512` — SHA3-512 over concatenated SHA3-256 leaf digests (catalog leaves only; head and trust excluded)
- `export-stamp` — `snapshot_export_version`
- `identity-epoch` — `u64`
- `parity-claim` — checkable sentence (e.g. `witnesses=182`)
- `continuity-*` — I7 sketch: identity (pubkey hex), epoch, kind (`export` | `boot`), parent (64 hex zero at genesis), stamp

Import's first act after batches apply: parse `catalog/HEAD`, recompute HEAD digest, verify continuity identity matches the batch signer.

## API

| Function | Role |
|----------|------|
| `stageHorizonCatalog` | Build prefixed catalog + head + trust |
| `exportCatalogHorizon` | Stage then export |
| `importCatalogHorizon` | Import then `verifyHeadRecord` (rolls back on failure) |
| `computeCatalogHead512` | HEAD digest helper |
| `verifyHeadRecord` | Post-import head + continuity check |

## Witness

`tools/mantra_snapshot_horizon.rish` — parity **182**

## Horizon (not lap 2)

Per counsel [`20260707-025212`](../counsel/20260707-025212_claude-counsel-weave-brix-pond-customs.md) and Kaeden's ruling [`20260707-030412`](../context/specs/20260707-030412_weave-slice-ruling.md):

- **`weave/` bundle** — **closed** — sovereign "Weave slice" is the `catalog/` export (every leaf, every revision, HEAD record); no separate bundle
- **`brix/` bundle** — held; no closure code exists; Brix earns its own first lap
- **Pond customs** — held; no policy concept in `pond/` yet
- **Live-instance continuity refusal** — Kaeden gate (I7); lap 2 only checks epoch ≠ 0 and identity matches signer
- **Thin-edge boot replay** — per counsel I3–I4 horizon

**Lap 3 (hosted Comlink crossing)** — landed parity **185** · [`context/specs/20260707-042512_snapshot-export-lap3.md`](../context/specs/20260707-042512_snapshot-export-lap3.md)
