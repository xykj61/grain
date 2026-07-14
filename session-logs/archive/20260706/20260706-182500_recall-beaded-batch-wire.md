# NS-L3 recall_beaded + batch wire — files (27) and Rio build round

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260706.182500

**Prompt:** Kaeden supplied `files (27).zip`, asked to continue without Claude — apply bundle, answer open questions, build recommended expansion.

## Rulings (Rio, no Claude check-in)

| Question | Recommendation | Built |
|----------|----------------|-------|
| Derived bead paths | `{path}.b{ordinal}` under `plain-bytes` | yes — `appendLeafBeaded` |
| `bead-index` in batch allowlist | add to `known_tilaks` | yes — `resin_batch.rye` |
| Batch wire hosted ports | **38480/38481** (after sync 38478/79) | yes |
| Witness bolt size | 2-leaf bolt (alpha+beta) so batch fits 340 B (~263 B measured) | yes |
| Device batch wire | horizon — same pattern as prior laps | parked |

## What landed

- Bundle 27: `recall_beaded.rye`, witness, parity 165
- `recall_batch_wire.rye` + `recall_batch_delivery.rye`, witness, parity 166
- Doorway fix: Status line keeps `checkable-room`

Full parity **166** GREEN (~85s).

**Recommend:** keep going to device batch wire on **15563/15564** — mechanical virtio hop; multi-frame chunking when a batch exceeds 340 B is a follow-on bench item.
