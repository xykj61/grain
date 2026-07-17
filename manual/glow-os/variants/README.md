# Glow OS — The Five Variants

**Language:** EN
**Version:** `20260717.162114` (Eastern)
**Style:** Radiant (see `../../../context/RADIANT_STYLE.md`)
**Status:** Scaffold — one shared template, filled once per variant

---

**Navigation:**
[Hub](../README.md) · [Overview](../overview.md) · [Get Started](../get-started.md) · **The Five Variants**

---

## One Template, Five Fills

The five variants — **Reya, Riyo, Trey, Triz, Quin** — are one design seen five ways, so their docs are one template seen five ways. Rather than five hand-written pages that drift apart, there is a single shared template, [`_variant-template.md`](_variant-template.md), with a `{{VARIANT}}` token. Each variant's page is that template filled once. When the template changes, every variant page changes with it — the dual-description discipline (one source, many faithful views) applied to documentation itself.

## The Variants

| Variant | Role | Confirm status |
|---|---|---|
| **Reya** | OS variant; Riyo's diverse-redundant twin | **Confirmed** `20260714.002123` — double collision (ReyaChain + retired Reya 2 voice) seen and accepted |
| **Riyo** | OS variant; Reya's diverse-redundant twin | **Confirmed** `20260714.035600` — quiet in collision research |
| **Trey** | OS variant; Triz's diverse-redundant twin | **Confirmed** `20260714.035600` — quiet in collision research |
| **Triz** | OS variant; Trey's diverse-redundant twin | **Confirmed** `20260714.035600` — soft TRIZ collision seen and accepted |
| **Quin** | OS variant; fifth boot image (unpaired twin for now) | **Confirmed** `20260717.162114` — also standing writing voice + Q-vane name |

Four of the five form two diverse-redundant pairs: **Riyo/Reya** and **Trey/Triz**. **Quin** is the fifth bootable image; a diverse-redundant twin for Quin stays open until named. Redundancy *shape* for each pair (one codebase, two independently-verified paths) is tracked in [`../../../context/specs/20260713-235600_names-awaiting-confirmation.md`](../../../context/specs/20260713-235600_names-awaiting-confirmation.md). Per-variant pages (`reya.md`, `riyo.md`, `trey.md`, `triz.md`, `quin.md`) are generated from the template once the doc-fusion machinery exists (Scribble/Brix/Mantra), not hand-written now.

## Why Generated, Not Hand-Written

The Scribble/Brix/Mantra doc-fusion ([`../../../external-research/20260713-235700_glow-doc-fusion-scribble-brix-mantra.md`](../../../external-research/20260713-235700_glow-doc-fusion-scribble-brix-mantra.md)) is exactly the machinery that will fill this template per variant: the template is a Scribble mark, Brix declares the five fills, Mantra stores each as a desk-like namespace. Until that machinery is built, the template stands alone and the per-variant pages wait — honestly scaffold, not pretend-complete.

---

**Navigation:**
[Hub](../README.md) · [Overview](../overview.md) · [Get Started](../get-started.md) · **The Five Variants**
