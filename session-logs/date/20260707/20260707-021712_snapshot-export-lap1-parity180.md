# I2 snapshot export lap 1 — parity 180

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.021712

**Prompt:** Keep going — I2 snapshot export (next mechanical NS item on TASKS).

## Thinking trace

Graceful-stop arc closed at parity 179. TASKS named I2 snapshot export as the next mechanical item; ruling `20260706.232812` requires reusing `resin_batch.rye` grammar rather than inventing a second manifest.

Lap 1 exports a `BoltCatalog` as one signed resin-batch per `(peer, bolt, revision)`, wrapped in a `0x06` snapshot header with a `leaf_count` HEAD claim. Import applies each batch via `applyBatch`, rolls back to empty on any refusal, and `assertCatalogReplay` proves identical recall.

## Observations

Horizon items (bundle prefixes, SHA3-512 head record, continuity fact, weave/Brix closure) stay in the spec as deferred. Witness GREEN on metal.

## Files

| File | Why |
|------|-----|
| `mantra/snapshot_export.rye` | Export/import + selftest |
| `context/specs/20260707-021512_snapshot-export-lap1.md` | I2 lap 1 spec seated |
| `tools/mantra_snapshot_replay.rish` | Parity **180** witness |

**Recommend:** check in with Claude before MALA graduation at escrow's second consumer — crosses Linengrow economic seam; real clock in poll loop is mechanical Caravan/Mantra when counsel lands.
