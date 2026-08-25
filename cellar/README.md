---

# Cellar -- Cellar Software

**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

**Language:** EN
**Last updated:** `20260801.033305` (e149 -- Class W wire tokens parked; module name Cellar)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)

**Cellar is cellar software** (product lane) -- preservation **in place** at home. It seals bit-faithful snapshots as content-addressed **resins** and a signed manifest, then sets them on deep storage that disconnects from every running system. Mantra holds the living history; Cellar seals the moment cold. Ring-1 **wire** format tokens (`amber-ring1-v2-tilak` - AEAD shoulder season) stay as format -- Class W parked e149.

**Amphora** is the traveling sibling -- **vessel software** for preservation **in motion** across a crossing. Lap two pours a cellar season into a vessel and carries it to a second dock; the cellar and the vessel share the resins law and Kumara's stamp.

The functional spec lives at [`context/specs/20260701-221512_cellar-functional-spec.md`](../context/specs/20260701-221512_cellar-functional-spec.md). Archive law: [`context/specs/20260703-191112_resins-and-hash-tiers.md`](../context/specs/20260703-191112_resins-and-hash-tiers.md). Vessel vocabulary: [`external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md).

## First lap (parity **144**)

| Piece | Path |
|-------|------|
| Manifest shape | [`ring1_manifest_shape.bron`](ring1_manifest_shape.bron) |
| Fixture tree | [`../tools/fixtures/cellar_ring1_tree/`](../tools/fixtures/cellar_ring1_tree/) |
| Export / verify / restore | [`../tools/fixtures/cellar_ring1_export.sh`](../tools/fixtures/cellar_ring1_export.sh) - verify - restore |
| Witness | [`../tools/ce/cellar_first_ring.rish`](../tools/ce/cellar_first_ring.rish) |
| Manifest Tilak | [`../tools/ce/cellar_manifest_tilak.rish`](../tools/ce/cellar_manifest_tilak.rish) -- legacy + Tilak goldens; unknown mark refused |

Lap one uses `openssl dgst -sha3-256` as the independent host oracle; export paths use **`resins/`** per ratified law (`20260703.191312`, path hygiene `20260706.235812`). Kumara signing waits for a later lap.

**Tensegral Arc I r2** (`20260728.000528`): first ring and manifest Tilak both **GREEN** -- cellar standing reaffirmed; no red to tighten this sitting. Next Arc I cable is Amphora.
