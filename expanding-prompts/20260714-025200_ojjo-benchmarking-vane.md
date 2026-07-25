# Expanded Prompt — Ojjo, the Benchmarking Vane

**Language:** EN
**Version:** `20260714.025200` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Runnable plan — gated on Glow running a program; correctness-first, timing-second. Addressed to a generic Acme Corporation employee.

---

## The Seed (what was asked)

Propose a new O-vane, **Ojjo** (a palindrome), a TAME-guidance safety/performance benchmarking vane that proves parity between Hoon programs and Glow programs — scripting Dojo/Arvo versus scripting Rish/Glow — by having each system's own timer record compilation and runtime statistics, so we Measure What Matters. Document it with a gratitude to the book, referencing High Output Management, TAME Guidance, and TigerBeetle.

## Done This Pass (design, gratitude, name)

- **Gratitude** — [`../gratitude/MeasureWhatMatters.md`](../gratitude/MeasureWhatMatters.md): Doerr's *Measure What Matters* and Grove's *High Output Management*, IP-safe principles summaries (measure output not activity; name the objective before the metric; a few honest, transparent measures), grounding Ojjo.
- **Design** — [`../external-research/20260714-025200_ojjo-benchmarking-vane-design.md`](../external-research/20260714-025200_ojjo-benchmarking-vane-design.md): what Ojjo is, the parity claim (correctness first, performance second), what it measures and with whose clock, the four teachers, an honest opinion (like it; build correctness-first; timer as a host seam; guard against Goodhart), and open questions.
- **Name** — added to [`../context/specs/20260713-235600_names-awaiting-confirmation.md`](../context/specs/20260713-235600_names-awaiting-confirmation.md) as the O-vane, awaiting confirm.

## The Build Ladder (when Glow can run a program)

Nothing here is built — Ojjo has nothing to measure until a Glow program exists. When it does, the smallest-first ladder:

1. **Lap 1 — conformance, no timing.** A witness that runs task T two ways (Hoon/Dojo, Glow/Rish) and asserts **byte-identical output**. This alone is valuable — a conformance suite proving Glow matches Hoon — and it is unfakeable. No clock yet.
2. **Lap 2 — timing, host-stamped.** Add each system's own compile-time and runtime measurement, reported side by side, stamped with the warm-aura date atom and the host (`GLOW_PROFILE.bron`). Correctness from lap 1 stays the hard gate — a fast-but-wrong result is red, not a near-miss.
3. **Lap 3 — steadiness.** Best-of-N and variance over repeated runs, in TigerBeetle's spirit that a distribution beats a single sample.
4. **Lap 4 — the task set.** Grow the benchmark corpus honestly and broadly, so no single task can be gamed into a misleading headline number.

## The Discipline It Keeps

- **Safety before performance** (TAME): correctness parity gates every timing.
- **Measure output, not activity; few honest measures** (HOM/MWM): compile time and runtime, not runs launched.
- **Prove on metal, report the distribution** (TigerBeetle): a green run is a fact; a single number lies.
- **Two Rooms**: every number is a checkable-room fact, host-stamped and recomputable; "Glow feels fast" is never stated as parity.
- **Measure to learn, never to win** (the reframe): Ojjo informs decisions; it is not a competition scoreboard (Goodhart guard).

## What This Prompt Does Not Do

- It writes no vane code — Glow must run a program first.
- It does not confirm the name — that is Keaton's word.
- It reports no performance number — there is nothing yet to measure.

---

*May the yardstick read the same both ways, and may we build the honest half — same task, same output — before we ever start the clock.*
