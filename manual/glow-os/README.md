# Glow OS — Documentation

**Language:** EN
**Version:** `20260713.235900` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Scaffold — mirrors the shape of Urbit's own docs for the Glow OS direction; each page marks what runs today versus what is proposed

---

**Navigation:** you are at the Glow OS docs hub.
[Overview](overview.md) · [Get Started](get-started.md) · [The Four Variants](variants/README.md) · [Manual home](../README.md)

---

## What Glow OS Is

**Glow OS** is Keaton Dunsford's fork of Urbit — the project formerly named Rye OS — written in **Glow**, the fused Rye-Hoon language. One language, one value model, one law (TAME Guidance), and **four switchable OS variants** — Reya, Riyo, Trey, and Triz — that a person can dual/tri/quad-boot between. The naming hierarchy is settled in [`../../context/specs/20260713-235455_keaton-name-and-glow-os-umbrella.md`](../../context/specs/20260713-235455_keaton-name-and-glow-os-umbrella.md).

These docs deliberately mirror the shape of Urbit's own documentation — an overview, a getting-started path, and per-variant reference — adapted to Glow OS's new direction. Where Urbit's docs teach one system, ours teach one system with four interchangeable variants, so the per-variant pages are generated from a single shared template.

## The Rooms

- **[Overview](overview.md)** — what Glow OS is, the four variants, and how Glow the language sits beneath them.
- **[Get Started](get-started.md)** — the honest getting-started path; marks what boots today versus what is scaffold.
- **[The Four Variants](variants/README.md)** — one shared template ([`variants/_variant-template.md`](variants/_variant-template.md)) filled once per variant, so all four stay in lockstep.

## How This Relates to the Existing Manual

This sits inside the existing four-room manual (`../README.md`) as the Glow OS onboarding surface. It does not replace the reference specs (Rishi language, Caravan capabilities, Tally gardens); it is the front door a newcomer to Glow OS reads first. In time, the doc pipeline that *builds* these pages is the Scribble/Brix/Mantra fusion designed in [`../../external-research/20260713-235700_glow-doc-fusion-scribble-brix-mantra.md`](../../external-research/20260713-235700_glow-doc-fusion-scribble-brix-mantra.md).

## A Note on Examples

Every ship-name example in these docs is a deliberately invalid placeholder (never a real `@p`), per the placeholder-ship-names rule — so no command a newcomer copies can ever reach a real point on the live network.

---

*May the front door be plain, and may all four variants read as one system seen four ways.*
