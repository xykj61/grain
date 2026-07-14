# Glow OS — Overview

**Language:** EN
**Version:** `20260713.235900` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Scaffold — conceptual overview; implementation status noted per claim

---

**Navigation:**
[Hub](README.md) · **Overview** · [Get Started](get-started.md) · [The Four Variants](variants/README.md)

---

## The Shape, Top to Bottom

| Layer | Name | What it is | Status |
|---|---|---|---|
| Language | **Glow** | the fused Rye-Hoon language, keeping Hoon's runes over TAME-bounded semantics | proposed; scoped, not built |
| Interpreter | **Nock interpreter** | runs Glow's compiled forms | scoped (Nock 4K), not built |
| Umbrella | **Glow OS** | the whole system, by Keaton Dunsford / `xykj61` | named; was Rye OS |
| Variants | **Reya · Riyo · Trey · Triz** | four switchable OS builds, all in Glow | named; awaiting confirm |
| Kernel spine | state as a pure fold over an append-only log of signed facts | the transition-function model | already this fork's stated spine |
| Modules | Rishi, Mantra, Comlink, Caravan, Tally, Brix, Bron, Aurora, Pond, Scribble, and the rest | the running seeds | many green today under the prior name |

## Why Four Variants

The four variants are not four different systems — they are **one design, built more than once, on purpose.** Riyo and Reya are a diverse-redundant pair: the same intent implemented independently, so a single implementation mistake cannot take down the only copy. This is safety-first, TAME's own first value, expressed at the whole-OS scale. Whether Trey and Triz mirror that pairing is still open ([`../../context/specs/20260713-235600_names-awaiting-confirmation.md`](../../context/specs/20260713-235600_names-awaiting-confirmation.md)).

## Glow, the Language Beneath

Glow keeps Hoon's rune tradition as *surface syntax* while compiling to TAME-bounded semantics underneath — so a reader gets Hoon's directness without inheriting Hoon's unbounded-recursion habit. Its type surface (auras, cold and warm atoms, structs as molds over nouns) and its linting are scoped in the Glow supplement ([`../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md)).

## Honest Status

Most of what runs today runs under the prior name (Rye OS) and is being carried forward into Glow OS by decision, not yet by mass rename. The language, the interpreter, and the four variants are **named and scoped, not built.** These docs describe the direction plainly and mark, per page, what is real. Nothing here claims a feature the witnesses do not show.

---

**Navigation:**
[Hub](README.md) · **Overview** · [Get Started](get-started.md) · [The Four Variants](variants/README.md)
