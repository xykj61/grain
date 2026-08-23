# Glow's Value Model

**Language:** EN  
**Stamp:** `20260726.041100`  
**Voice:** Quin  
**Status:** Design — Mixed · **Checkable** where it cites TAME root rule 5 and the Glow→Rye→Zig path · **Vision** where RISC-V lowering detail still widens  
**Room:** Design (hot shelf) — graduates to [`docs/`](../../../docs/) when witnesses bind the claims below as compressors  
**Ground:** [`../../../context/TAME_GUIDANCE.md`](../../../context/TAME_GUIDANCE.md) §5 · [`../../../glow/README.md`](../../../glow/README.md) · counsel [`../../../counsel/date/20260726/20260726-020825_the-cheap-hour.md`](../../../counsel/date/20260726/20260726-020825_the-cheap-hour.md)

---

## What a value is

Grain's law is already seated, and Glow inherits it rather than inventing a second model:

> A value is: a **string**, an **integer**, a **boolean**, a **list** of values, a **record** of named values — or a **composite** of these.

Values are **composed** (placed side by side). They are never **tangled** (woven so that reading one requires holding the others). That sentence is TAME root rule 5, not a Glow-only flourish.

This is **not** "everything is an atom or a cell." Atom and cell name Nock's noun law. Glow may *speak* that law at an interop door; it does not live inside it. The companion page [`nock-interop-seam.md`](nock-interop-seam.md) keeps that door narrow.

## How Glow carries the model today

| Layer | What you meet | Register |
|-------|----------------|----------|
| Glow source | Faces, shapes, gates, cells-as-syntax (`:-` · `:+` · …) over ordinary values | Working pin [`glow/README.md`](../../../glow/README.md) |
| Ambient truth | Zig / Rye `bool` · POSIX exits (0 success) | Checkable — [`glow-truth` seat](../../../context/specs/20260717-154943_glow-truth-zig-ambient-nock-loobean-seam.md) |
| Lowering | Glow → ordinary `.rye` → Zig | Checkable path; desks and witnesses on the pin |
| Metal | Zig → RISC-V | Checkable where [`glow_riscv_target_witness`](../../../tools/g/glow_riscv_target_witness.rish) binds; wider surface still Design |

**Cells in Glow syntax** (pair, triple, list heads) are **composition forms** for values already in the one model — named faces side by side — not a redefinition of Grain values as Nock nouns.

## RISC-V lowering (honest horizon)

The primary path is **Glow → Rye → Zig → RISC-V**. That is seated intent and, for named keystones, green metal. This page does **not** claim that every Glow shape already has a published RISC-V lowering table. What earns the proven shelf later is a compressor that only repeats what witnesses have shown: each value kind's representation, bounds, and the refuse paths TAME demands.

Until then, treat lowering detail as **Design**: follow the working pin, grow desks witness-first, and refuse any prose that borrows Nock's atom/cell story as Glow's ambient ontology.

## What this page refuses

- Titling Glow's model "atoms and cells"
- Silent loobean polarity in ambient Glow (0 = yes) — that stays at the Nock seam
- Graduating this page into `docs/` before witnesses compress it

## Gratitude (Silo)

Hoon and Nock taught this tree that a single data story can carry a whole OS — lineage we honor without reproducing their noun law as ours. Urbit's teachings live under [`gratitude/`](../../../gratitude/); this page silos the *idea* of one value model, then seats Grain's own six-shaped law.

---

*May every Glow value stay one of six shapes, and may the metal path earn the shelf only after a witness speaks.*
