# Grain Lineage — Siloed for Plain Use

**Language:** EN
**Version:** `20260713.232506` (Pacific)
**Style:** Radiant (see `../../context/RADIANT_STYLE.md`)
**Status:** Living — siloed adaptations; originals held whole at `../../gratitude/grain-lineage/`

---

## What Siloing Does Here

The six documents in [`gratitude/grain-lineage/`](../../gratitude/grain-lineage/README.md) carry real engineering ideas wrapped in a visionary, devotional, and aether-theoretic register. Siloing separates the two: it keeps the load-bearing, checkable engineering and restates it in secular, common English with this fork's own module names, in a form a general reader — a colleague at Acme Corporation, a reviewer of an Urbit Galaxy PR proposal — can weigh on its merits. The originals stay untouched in gratitude; these siloed versions are the ones any Acme-facing guide or proposal cites.

This mirrors the silo technique this fork already uses for the astrology library (placeholder names, private originals) and for the IronBeetle episode notes (own-voice understanding, source never quoted). The discipline is the same: **carry the substance, leave the register at the door, name the source in gratitude.**

## The Translation Table

Where a source used another project's vocabulary, the silo uses this fork's own, so a reader is never asked to learn two naming systems at once:

| Source term | Siloed term (this fork) |
|---|---|
| Grain OS | Rye OS |
| Grain Style | TAME Guidance |
| Arvo (kernel transition function) | the kernel variants (Riyo / Reya / Trey / Triz), all written in Glow |
| Hoon | Glow |
| Nock | the Nock interpreter (scoped in `../20260713-214400_nock-interpreter-and-rye-hoon-fusion-scoping.md`) |
| the Loom (Urbit's allocator) | Tally (named gardens / roads) |
| the grain point | the state-at-center: the transition function's single updated state, held as Mantra's fold head |
| sheaf / topos value model | Bron (one value model) folded by Mantra |
| Langlands / mirror-symmetry duality | the dual-description design principle (two faces of one system) |
| aether / field-theoretic claims | labeled plainly as contested physics, separated from the geometry that stands without them |

## The Siloed Set

- [`silicon-torus-hardware.md`](silicon-torus-hardware.md) — the toroidal hardware proposal, secular: what the geometry buys, what the aether framing costs, what is testable.
- [`toroidal-bounded-optimization.md`](toroidal-bounded-optimization.md) — natural-gradient descent on compact (toroidal) parameter spaces, as a bounded, single-threaded, TAME-shaped optimizer.
- [`the-state-at-center.md`](the-state-at-center.md) — "The Grain Point," siloed: the pure transition function and static-allocation kernel, mapped onto this fork's Glow kernel variants, Mantra, Tally, and Caravan.
- [`one-carrier-many-flows.md`](one-carrier-many-flows.md) — "Silken Ground," siloed: one shared carrier for several utility flows, with the speculative materials science labeled as such.
- [`dual-description-design-principle.md`](dual-description-design-principle.md) — the Langlands/mirror-symmetry material, siloed into a plain, reusable design rule this fork already half-practices.
- [`whole-in-every-part.md`](whole-in-every-part.md) — the topos/sheaf convergence essay, siloed to its one engineering claim (local data that agrees glues into a global whole) and its tie to Bron and Mantra, with the devotional register set aside.

## How This Informs Designs, Foundations, and Context

Each siloed doc ends with a short, honest "What this actually gives this fork" section pointing at the specific design surface it touches — the Glow kernel variants, the Nock interpreter, Tally's allocator, Comlink's dual physical/governance descriptions, Bron's value model. None of it is adopted as a decision here; siloing produces citable understanding, and Kaeden's word seats any of it into `context/specs/` or a module home.

---

*The vision stays sung where it was sung. Here it speaks plainly, so the work can weigh it clearly.*
