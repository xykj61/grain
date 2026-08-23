# The Nock Interop Seam

**Language:** EN  
**Stamp:** `20260726.041100`  
**Voice:** Quin  
**Status:** Design — Mixed · **Checkable** where it cites the Nock interpreter pin, truth seam, and loobean conversions · **Vision** where future noun codecs widen  
**Room:** Design (hot shelf) — graduates to [`docs/`](../../../docs/) when interop claims compress under witnesses  
**Ground:** [`../../../glow/nock/README.md`](../../../glow/nock/README.md) · [`../../../context/specs/20260717-154943_glow-truth-zig-ambient-nock-loobean-seam.md`](../../../context/specs/20260717-154943_glow-truth-zig-ambient-nock-loobean-seam.md) · counsel [`../../../counsel/date/20260726/20260726-020825_the-cheap-hour.md`](../../../counsel/date/20260726/20260726-020825_the-cheap-hour.md)

---

## Why this page is separate

Glow's value model is Grain's six shapes. Nock's world is **nouns**: every value is an **atom** or a **cell**. Mixing those stories in one ambient page quietly re-seats another system's ontology as Glow's own. So this page is only the **boundary** — where Grain values map to atoms and cells, and only there.

**Nock is the second backend** — interop and verification — never Glow's execution floor. The primary path stays Glow → Rye → Zig → RISC-V.

## What already crosses (Checkable)

| Crossing | Law | Witness / module |
|----------|-----|------------------|
| Truth polarity | Glow ambient = Zig `bool`; Nock loobean 0=yes / 1=no | [`truth_semantics.rye`](../../../glow/truth_semantics.rye) · [`glow_truth_semantics_witness`](../../../tools/g/glow_truth_semantics_witness.rish) |
| Interpreter | Opcodes 0–11, depth-bounded eval | [`glow/nock/`](../../../glow/nock/README.md) pin |
| Role | Second backend only | Seated in `glow/nock/README.md` and the RISC-V revival brief |
| eq mirror (firstborn) | desk and formula answer as one on 32·31·33; raw loobean read beside the product | [`nock_glow_mirror_witness`](../../../glow/nock/nock_glow_mirror_witness.rye) |

Conversion at the door: `loob_to_bool` / `bool_to_loob`. Never invert process exits to match loobeans. Never treat a raw `0` as Glow "yes" without that call.

## Mapping Grain values to nouns (Design)

The sketch below is **orientation**, not a seated codec. A future witness-backed compressor will pin exact encodings.

| Grain value (TAME §5) | Nock-world sketch at the seam |
|------------------------|-------------------------------|
| integer | atom (bounded width named at the door) |
| boolean | loobean atom **after** explicit conversion |
| string | atom or cell-of-atoms — **undecided**; name the choice when a witness lands |
| list | right-associated cell spine (Nock list convention) — Design until pinned |
| record | cell tree of `[name value]` pairs or a tagged nest — Design until pinned |
| composite | cell composition of the above |

Until those rows earn metal, Glow code stays in the six-shape model; Nock formulas stay inside `glow/nock/` or behind an explicit seam module.

## What this page refuses

- Ambient Glow written as if values *were* atoms and cells
- Silent loobean meaning in Glow conditionals or exits
- Expanding Nock from second backend into execution floor without a new seating word

## Gratitude (Silo)

Nock's noun law — atom and cell — is one of the cleanest small machines in computing history. We keep the teacher whole under [`gratitude/`](../../../gratitude/) and [`glow/nock/`](../../../glow/nock/), and we borrow only at a named door: convert, verify, return. Nothing from the Nock spec is reproduced here; the lineage is the thanks.

---

*May atoms and cells meet Glow only at the seam, and may every conversion stay louder than silence.*
