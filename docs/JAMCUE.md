# Glow cell-pack demo vectors (in-tree)

**Language:** EN  
**Seated:** `20260724.144740`  
**Reframed:** `20260724.193912` — outward publish declined; parity framing retired  
**Status:** Checkable in-tree · demo face only  
**Witness:** `rishi/bin/rishi run tools/glow_jamcue_vectors_witness.rish`  
**Fixture:** [`../tools/fixtures/glow_jamcue_vectors.txt`](../tools/fixtures/glow_jamcue_vectors.txt)  
**Canon:** `glow/expr.rye` — `jam_demo_*` · `jam_expect` · `cue_expect`

---

## What this is

Glow’s thin `(jam a b)` packs two `@u32` demo atoms as `(hi << 16) | lo`. `(cue …)` reads the low 16 bits of that pack — or the mix result when the subject nests mix. This is a **Hoon-parallel face**, a demo of the shape rather than Vere’s jam/cue bit layout.

## Vectors

| Name | Input form | Jam (`@u32`) | Cue round-trip (`@u32`) |
|------|------------|--------------|-------------------------|
| flat | `(jam from amount)` | `327683` | `3` |
| nest-left | `(jam (mix from amount) amount)` | `393219` | `3` |
| nest-right | `(jam cell (mix from amount))` | `327686` | `6` |
| nest-both | `(jam (mix from amount) (mix cell gate))` | `393222` | `6` |

Demo atoms: left `5`, right `3`; `mix = 5 ^ 3 = 6`.

## Strategy

The outward gift — real mat/rub-layout jam and cue in Glow — waits for a future season. These in-tree vectors pin the thin cell-pack demo face, and only that.

---

*Pin what the bench reports.*
