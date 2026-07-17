# Glow OS — Overview

**Language:** EN
**Version:** `20260717.162114` (Eastern)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Scaffold — conceptual overview; implementation status noted per claim

---

**Navigation:**
[Hub](README.md) · **Overview** · [Get Started](get-started.md) · [The Five Variants](variants/README.md)

---

## The Shape, Top to Bottom

| Layer | Name | What it is | Status |
|---|---|---|---|
| Language | **Glow** | the fused Rye-Hoon language, keeping Hoon's runes over TAME-bounded semantics | desk hops emit GREEN; full language still growing |
| Interpreter | **Nock interpreter** | runs Glow's compiled forms | scoped (Nock 4K), not built |
| Umbrella | **Glow OS** | the whole system, by Keaton Dunsford / `xykj61` | named; was Rye OS |
| Variants | **Reya · Riyo · Trey · Triz · Quin** | five switchable OS builds, all in Glow | **five confirmed** (pairs `20260714.035600`; Quin fifth `20260717.162114`) |
| Kernel spine | state as a pure fold over an append-only log of signed facts | the transition-function model | already this fork's stated spine |
| Modules | Rishi, Mantra, Comlink, Caravan, Tally, Brix, Bron, Aurora, Pond, Scribble, and the rest | the running seeds | many green today under the prior name |

## Why Five Variants

The five variants are not five different systems — they are **one design, built more than once, on purpose.** Four form **two diverse-redundant pairs** — Riyo/Reya and Trey/Triz — where each pair is the same intent implemented independently, so a single implementation mistake cannot take down the only copy. **Quin** is the fifth bootable image; a diverse-redundant twin for Quin stays open until named. This is safety-first, TAME's own first value, expressed at the whole-OS scale. Registry: [`../../context/specs/20260713-235600_names-awaiting-confirmation.md`](../../context/specs/20260713-235600_names-awaiting-confirmation.md).

## Glow, the Language Beneath

Glow keeps Hoon's rune tradition as *surface syntax* while compiling to TAME-bounded semantics underneath — so a reader gets Hoon's directness without inheriting Hoon's unbounded-recursion habit. Its type surface (auras, cold and warm atoms, structs as molds over nouns) and its linting are scoped in the Glow supplement ([`../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md)).

## Honest Status

Most of what runs today runs under the prior name (Rye OS) and is being carried forward into Glow OS by decision, not yet by mass rename. The language desk already emits; the Nock interpreter and the five variants are **named and scoped, not yet bootable as whole OS images.** These docs describe the direction plainly and mark, per page, what is real. Nothing here claims a feature the witnesses do not show.

---

**Navigation:**
[Hub](README.md) · **Overview** · [Get Started](get-started.md) · [The Five Variants](variants/README.md)
