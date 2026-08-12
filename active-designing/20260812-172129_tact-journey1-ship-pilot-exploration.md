# TACT Journey 1 — Ship-Pilot: the guided first-run (exploration)

**Stamp:** `20260812.172129` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens the 1,024-itinerary's **Season 1 (The World, TACT), Journey 1**
**Kin:** [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`../pond/README.md`](../pond/README.md) · [`../foundations/20260810-011514_pond-the-application-module.md`](../foundations/20260810-011514_pond-the-application-module.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the road stands

BUHR closed the surface-and-intelligence equinox: the voices, the Realidream graph, the MCP surface, and Tablecloth all stand witnessed on metal. The intelligence and the surface met over one append-only graph. What no rung has done yet is let **a person** cross that whole floor from nothing — the itinerary's Season 1 durable promise: *a stranger reaches a working, signed, publishable instance without the maintainer's hand on each step.* The graph met the intelligence; now the graph meets a keeper.

Season 1 threads the **TACT** waymark (Compass Equinox 4, The World), already seated on the ladder. Its four journeys are Ship-Pilot · Publishing · Grainphone · Commerce. This round opens the first — **Ship-Pilot** — the guided first-run.

## The crux

**A guided first-run pilots a new keeper from zero to a running Pond, the whole arc witnessed — and the arc cannot be walked out of order or with a step unproven.**

The durable artifact is not any single onboarding step; each of those already has a module (identity in `settlement/constellation.rye`, receipt policy in `pond/customs.rye`, a runnable app in `pond/apps/`). The durable artifact is the **ordered, enforced arc itself** — the pilot that knows which steps a keeper takes, in what order, and refuses to report *ready* until every one has genuinely passed. A checklist that cannot be cheated is worth more than any one item on it, because it is read every first-run for as long as the tree onboards anyone.

## Lindy-first, crux-first ordering of the four rounds

- **r1 — The pilot spine (the crux).** A bounded, ordered state machine of named onboarding steps (`identity · place · customs · app · ready`). The pilot advances one step at a time and only when the current step's precondition holds; it refuses an out-of-order jump (`OutOfOrder`) and refuses to advance a step whose precondition is unmet (`StepNotReady`); it reports `PILOT READY` only when every step has passed in order. In r1 each precondition is a supplied signal, so the *enforcement* is proven pure before any module is wired — the spine is the keystone that opens the rest.
- **r2 — Real identity genesis.** Wire the `identity` step to `settlement/constellation.rye` `open` — the step passes only when a real Deed opens and verifies against the constellation; from zero (no deed) the pilot refuses to advance. Demo keeper seed only; generating the maintainer's own Kumara instance stays custody gate #4.
- **r3 — Customs consent.** Wire the `customs` step to `pond/customs.rye` — the keeper's first mark is inspected; the step passes on a `place` verdict, holds on `await-word` (surfaces, never auto-crosses), refuses whole on an unknown mark.
- **r4 — Ready-to-run report.** The `app` and `ready` steps compose the settled identity, the assigned place, and the placing customs into a readiness report that names the runnable Pond app and confirms the whole arc green end to end.

## What stays a gate

Ship-Pilot's own arc is agent-doable — a bounded pilot over demo seeds, reading no network and holding no real key. The journey's **serve/publish** reach belongs to Journey 2 (Publishing), which meets the Comlink-served custody gate and surfaces there for the maintainer's word. Provisioning a real Pond host stays custody gate #2. This journey pilots the *arc*; it never crosses a gate to do it.

---

*May the first-run stay honest — every step proven before the next, and the keeper met with a plain, glad door.*
