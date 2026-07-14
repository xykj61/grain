# Context Home

**Language:** EN
**Last updated:** 2026-07-13 (docs shelf · living_docs_lint keeper · compass align)
**Style:** Radiant (see `RADIANT_STYLE.md`)

---

This directory is the memory and compass for work in `~/veganreyklah2`. It gathers the durable guidance — how we write, who Rio 3 is this season, and the plain-English specs that record each decision — in one calm, local place.

Everything here lives inside the persistent project directory, so it survives every sandbox reset. The ai-jail wrapper keeps only the project directory across runs; this `context/` home rests safely within it.

---

## What Lives Here

- **`RADIANT_STYLE.md`** — the canonical voice. How we write and speak so every piece reads clearly, lands warmly, and carries well aloud.
- **`TAME_GUIDANCE.md`** — the operational code supplement (root + Rye / Brix / Rishi). Named like TigerBeetle's `docs/TIGER_STYLE.md`; pairs with `external-research/TAME_GUIDANCE.md` and `gratitude/TIGER_STYLE.md`.
- **`SIMPLE_LOVABLE_COMPLETE.md`** — how we ship. Simple, lovable, complete at every lap; our distillation of Jason Cohen's method, bound to how Rye OS grows. Source essay in `gratitude/`.
- **`CIVIC_STYLE.md`** — how we design public benefit. Name the outcome you want, name what the reward measures, keep the two aligned — the civic companion to TAME, Radiant, and SLC.
- **`REYA2.md`** — the prior identity note (Reya 2). **`RIO3.md`** — **Rio 3**, active voice this season until Kaeden restores Reya 2.
- **`SILO_TECHNIQUE.md`** — the siloing technique: how an outside idea becomes an owned, understood concept in our own voice, with gratitude kept apart and honored. Portable, and meant to travel beside the voice guide and the identity note.
- **`LEXICON.md`** — module names and one-line meanings; Weave, Dexter, Kumara, Bookie, the open horizons, the **preservation pair** (Amber = cellar software, Amphora = vessel software), and **Kitchen twin** (plain companion to a hard canon). **Nib** vocabulary for landed edges (product · suite · git) — retired *tip* in new prose only.

- **`specs/`** — plain-English radiant specs. … **`20260702-035018_graduation-rule.md`** — when an aspect earns a module home (second consumer). **`20260701-221512_amber-functional-spec.md`** — Amber preservation module; first lap green (parity **144**); later laps wait. **`20260709-200443_wov-exit-honesty.md`** — WOV safety spec (root facts + exit bundles). **`20260709-204026_wov-tb-client-seam.md`** — TigerBeetle client seam; seam A host landed (parity **204**); seam B later. **`20260709-224325_slcl4-lap2-width.md`** — SLC-L4 width after fixed-tier (W0 cleared; W1/W2 gated). **`20260709-224531_wov-dual-monarch.md`** — dual monarch; D1 twin-lines landed (parity **205**); D2 later. **`20260709-225159_mala-kind-field.md`** — MALA kind; K0 cleared; K1 gated. **`20260709-225343_thin-view-dexter-exception.md`** — thin view is not Dexter's second consumer. Plain stories: [`../external-research/20260709-200022_pedersen-and-sigma-plainly.md`](../external-research/20260709-200022_pedersen-and-sigma-plainly.md) · [`../external-research/20260709-230414_twin-keys-and-the-exit-bundle.md`](../external-research/20260709-230414_twin-keys-and-the-exit-bundle.md) · [`../external-research/20260709-231011_graduation-rule-plainly.md`](../external-research/20260709-231011_graduation-rule-plainly.md) · [`../external-research/20260709-235921_one-clock-plainly.md`](../external-research/20260709-235921_one-clock-plainly.md) · [`../external-research/20260709-235931_resins-cellar-vessel-plainly.md`](../external-research/20260709-235931_resins-cellar-vessel-plainly.md) · [`../external-research/20260710-000725_learning-chapter-plainly.md`](../external-research/20260710-000725_learning-chapter-plainly.md) · [`../external-research/20260710-001249_settlement-seat-plainly.md`](../external-research/20260710-001249_settlement-seat-plainly.md) · [`../external-research/20260710-002017_metalsmoke-plainly.md`](../external-research/20260710-002017_metalsmoke-plainly.md) · [`../external-research/20260710-002422_amber-seasons-plainly.md`](../external-research/20260710-002422_amber-seasons-plainly.md) · [`../external-research/20260710-002544_first-lap-goes-green-plainly.md`](../external-research/20260710-002544_first-lap-goes-green-plainly.md) · [`../external-research/20260710-002952_sealed-crossing-plainly.md`](../external-research/20260710-002952_sealed-crossing-plainly.md).

Hand new sessions and collaborators the **voice guide**, the **identity note** (`RIO3.md` this season), and the **silo guide** together by default.

A Cursor rule at `.cursor/rules/rio3.mdc` points every new session back here (Reya 2 rule resting at `reya2.mdc`).

---

## How To Use It

Read the style guide before writing anything meant to be shared or heard. Read the identity note to remember the tone and the purpose. Add a new spec whenever a decision deserves a durable home — one file, one decision, written so it reads aloud well.

When a chat or a file stops serving the project, name it gently and let it go. Pruning keeps this home clear.

---

## The Shape of the Workspace

```
~/veganreyklah2/
  ORGANIZING.md   <- filing guide: tree shape, placement test, one-clock law
  context/        <- this home: disciplines, identity, specs
    RADIANT_STYLE.md
    TAME_GUIDANCE.md
    SIMPLE_LOVABLE_COMPLETE.md
    CIVIC_STYLE.md
    REYA2.md
    SILO_TECHNIQUE.md
    LEXICON.md
    specs/
  foundations/    <- why beneath the work: briefs, essays, weave, civic visions
  docs/           <- compression shelf (operator guides; no load-bearing pins)
  linengrow/      <- civic-application track on the Rye OS spine
  work-in-progress/ <- workbench: ROADMAP, TASKS, open threads
  external-research/ <- study of the world with attribution
  active-designing/  <- our design in motion
  expanding-prompts/ <- runnable plans (from 10000)
  session-logs/   <- reasoning traces; newest-first index
  gratitude/      <- works we honor, kept whole
  vendor/         <- third-party source, unmodified
  rye/ rishi/ …   <- module homes
  tools/          <- gates and witnesses
```

Full tree: `ORGANIZING.md` at the repository root.

---

*May this home stay clear. May each file earn its place. May the next reader find exactly what they came for.*
