# Grain — Overview

**Language:** EN  
**Version:** `20260717.162114` (Eastern)  
**Last updated:** `20260730.153549` (SUNN10 — Livermore living face)  
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)  
**Voice:** Kyri  
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
| Umbrella | **Grain** | the whole system, by **Keaton Dunsford** / `xykj61` (dated Dunsford filing stays in elder stamps) | named; was Rye OS |
| Variants | **Reya · Riyo · Trey · Triz · Quin** | five switchable OS builds, all in Glow | **five confirmed** (pairs `20260714.035600`; Quin fifth `20260717.162114`) |
| Kernel spine | state as a pure fold over an append-only log of signed facts | the transition-function model | already this fork's stated spine |
| Modules | Rishi, Mantra, Comlink, Caravan, Tally, Brix, Bron, Aurora, Pond, Scribble, and the rest | the running seeds | many green today under the prior name |

**Names, plainly.** The standing writing voice is **Kyri** ([`../../context/KYRI.md`](../../context/KYRI.md), molted from Riyo `20260810`). **Quin** remains the fifth OS variant and the inference Q-vane ([`../../context/QUIN.md`](../../context/QUIN.md)) — the OS-variant name **Riyo** in the table above is a boot image, not the writing companion.

## Why Five Variants

The five variants are **one design, built more than once, on purpose** — rather than five different systems. Four form **two diverse-redundant pairs** — Riyo/Reya and Trey/Triz — where each pair implements the same intent independently, so a single implementation mistake can never take down the only copy. **Quin** is the fifth bootable image, **intentionally unpaired** (`20260717.162620`) — five total, settled. This is safety-first, TAME's own first value, expressed at the whole-OS scale. Registry: [`../../context/specs/20260713-235600_names-awaiting-confirmation.md`](../../context/specs/20260713-235600_names-awaiting-confirmation.md).

## Glow, the Language Beneath

Glow keeps Hoon's rune tradition as *surface syntax* while compiling to TAME-bounded semantics underneath — so a reader gets Hoon's directness while leaving Hoon's unbounded-recursion habit behind. Its type surface (auras, cold and warm atoms, structs as molds over nouns) and its linting are scoped in the Glow supplement ([`../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md)).

## Honest Status

Most of what runs today runs under the prior name (Rye OS), carried forward into Grain by decision rather than by mass rename. The language desk already emits; the Nock interpreter and the five variants stand **named and scoped, still short of bootable as whole OS images.** These docs describe the direction plainly and mark, per page, what is real. Nothing here claims a feature the witnesses do not show.

---

**Navigation:**
[Hub](README.md) · **Overview** · [Get Started](get-started.md) · [The Five Variants](variants/README.md)
