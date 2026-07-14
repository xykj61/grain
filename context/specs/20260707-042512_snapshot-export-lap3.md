# Snapshot export — lap 3 (hosted Comlink crossing)

**Stamp:** `20260707.042512 UDT` (Kaeden's clock)
**Language:** EN
**Style:** Radiant (see `../RADIANT_STYLE.md`)
**Status:** Seated — lap 3 on metal; laps 1–2 grammar retained

*Written by Kaeden and Rio 3.*

---

## Purpose

Lap 3 is the counsel-numbered *hosted Comlink crossing*: fetch each revision group's resin-batch over the existing batch wire exchange (`recall_batch_delivery.rye`), assemble the snapshot buffer the same way `exportCatalogHorizon` does locally, and hand the bundle to `importCatalogHorizon` unchanged.

Counsel: [`counsel/20260707-042512_claude-proposal-snapshot-lap3-and-caravan-hardening.md`](../counsel/20260707-042512_claude-proposal-snapshot-lap3-and-caravan-hardening.md) · original lap order [`counsel/20260704-181612_zero-copy-resins-counsel-answers.md`](../counsel/20260704-181612_zero-copy-resins-counsel-answers.md) part C.

## Shape

| Piece | Role |
|-------|------|
| `snapshot_export.rye` | `beginSnapshotAssembly`, `appendSnapshotBatch`, `witnessHorizonPlan` |
| `snapshot_export_delivery.rye` | Source-loop + fetcher over batch wire; ports **38490**/**38491**; device **15567**/**15568** |
| `importCatalogHorizon` | Unchanged — placeholder continuity check only (epoch ≠ 0, identity matches signer) |

No new wire mechanism, frame kind, or signature scheme.

## Witness

`tools/mantra_snapshot_wire.rish` — parity **187** (hosted selftest + device lab)

## Horizon (not lap 3)

- **Device wire crossing** — follows when virtio lab is warranted; lap 3 is hosted only per counsel
- **Live-instance continuity refusal** — Kaeden gate (I7); do not extend placeholder check while touching import
- **Laps 4–5** — Puddle boot · Aurora on real metal (thin-edge)
