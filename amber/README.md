# Amber — Cellar Software

**Language:** EN
**Last updated:** 2026-07-10 (Radiant Style pass round 2 · cellar · vessel pairing)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)

**Amber is cellar software** — preservation **in place** at home. It seals bit-faithful snapshots as content-addressed **resins** and a signed manifest, then sets them on deep storage that disconnects from every running system. Mantra holds the living history; Amber seals the moment cold.

**Amphora** is the traveling sibling — **vessel software** for preservation **in motion** across a crossing. Lap two pours an Amber season into a vessel and carries it to a second dock; the cellar and the vessel share the resins law and Kumara's stamp.

The functional spec lives at [`context/specs/20260701-221512_amber-functional-spec.md`](../context/specs/20260701-221512_amber-functional-spec.md). Archive law: [`context/specs/20260703-191112_resins-and-hash-tiers.md`](../context/specs/20260703-191112_resins-and-hash-tiers.md). Vessel vocabulary: [`external-research/20260703-201612_the-amphora-and-the-crossing.md`](../external-research/20260703-201612_the-amphora-and-the-crossing.md).

## First lap (parity **144**)

| Piece | Path |
|-------|------|
| Manifest shape | [`ring1_manifest_shape.bron`](ring1_manifest_shape.bron) |
| Fixture tree | [`../tools/fixtures/amber_ring1_tree/`](../tools/fixtures/amber_ring1_tree/) |
| Export / verify / restore | [`../tools/fixtures/amber_ring1_export.sh`](../tools/fixtures/amber_ring1_export.sh) · verify · restore |
| Witness | [`../tools/amber_first_ring.rish`](../tools/amber_first_ring.rish) |

Lap one uses `openssl dgst -sha3-256` as the independent host oracle; export paths use **`resins/`** per ratified law (`20260703.191312`, path hygiene `20260706.235812`). Kumara signing waits for a later lap.
