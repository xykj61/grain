# 10011 · Display Frontier, Flow of Values, and Garden Vocabulary — Autonomous Milestone Run

*Expanded at `021212` from the active-designing lens review: priorities align with Gall's Law, single-stranded composition, recommended architecture, and correctness by construction — yet the display layer has no pixels yet, the Language of the System gift is distributed across briefs without one foundation stone, and the garden vocabulary sweep remains half-done. This prompt orders autonomous work toward the next great milestones without braiding them into one tangled push.*

**Language:** EN
**Version:** `20260620.021212` (Rye chronological stamp)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Reya 2
**Lens:** TAME — safety, performance, joy; Gall's Law; `995` single-stranded; `997` recommended path; `990` correctness by construction

---

## The Seed

> Expand a prompt to work autonomously towards a next great milestone or several and run in, reya 2 radiant tame. time 021212

## The Mission

Grow the **display frontier** from design into running code, **complete the garden vocabulary** so Tally's metaphor reads honestly in our programs and docs, and **silo the flow-of-values foundation** that Hickey's *Language of the System* taught us — distilled on our own ground, beside `993_bounded_network` which already carries the network slice.

Three milestones, one session, composed not braided:

| Track | Milestone | Gall's test |
|-------|-----------|-------------|
| **A** | **Brushstroke seed** — one hosted program draws a frame from values | Smallest thing that draws |
| **B** | **Garden vocabulary sweep** — `init.garden` locals and docs aligned | Phase 2 of open thread |
| **C** | **`977_flow_of_values.md`** — system-wide flow brief siloed | Ideas cross boundary clean |

**Defer to next autonomous run** (named, not started here unless time remains):

| Track | Milestone | Why wait |
|-------|-----------|----------|
| **D** | **Caravan multi-child** — two children, separate gardens | After bounded seed pattern is copied |
| **E** | **Device wire** — virtio-net datagram | Needs close-reading beside it (`10007` Thread D) |
| **F** | **Roadmap refresh** — `996`/`983` 16 witnesses, `978` horizon | After A–C land |

## What Already Runs

- Tally seed + gardens, Caravan seed + bounded, Mantra weave + chain, Rishi gate trio, Aurora deciding, 16 witnesses (`995`).
- Design: `988` Brushstroke, `986` living desktop, `978` Scribble/Lantern/Lattice horizon, `983` whole system.
- Open threads: Brushstroke seed (build), garden vocabulary (near), flow foundation gap (`021112` review).

## Track A — Brushstroke Seed

**Deliverable:** `brushstroke/seed.rye` + `brushstroke/bin/` (gitignored build output).

**Behavior:**

1. Define a **Frame** value — a bounded list of text lines (immediate-mode: no retained widget tree).
2. **Redraw** = pure function from values → output (hosted: stdout via `std.Io`; no Wayland yet).
3. Allocate frame strings from `init.garden`; prove season ends clean.
4. Print `brushstroke seed: frame drawn from values` on success.
5. Assertions: frame line count bounded; empty frame is valid.

**Not in scope:** Wayland, Vulkan, GPU, Skate grid, Pond enclosure. The seed proves **values → frame → surface** on the hosted path. Wayland is study (`985`, `986`).

**Prove:** `rye build` + run binary; optional `rye/tests/brushstroke_seed_test.rye` if a witness test earns its place.

**Allow-list:** add `!/brushstroke/` to `.gitignore`.

## Track B — Garden Vocabulary Sweep

**Deliverable:** phase 2 of `995` open thread — complete.

| Location | Change |
|----------|--------|
| `rye/src/main.rye` | `const garden = init.garden.allocator()`; params `garden` |
| `rishi/src/main.rye` | same |
| `rye/lib/std/*/benchmark.zig` (3 files) | local `garden` |
| `rye/lib/std/start.zig` | `garden_allocator` / `garden_backing_allocator` internals |
| `rye/README.md`, `998_ALMANAC.md` | `init.garden`, not `init.arena` |
| `strengthening-compiler/9989_tally_gardens.md` | `tally/heap-garden.rye` future name |
| `context/specs/inherited-names.md` | already reconciled — verify |

**Out of scope:** `ArenaAllocator` type name, bulk `rye/lib/std/**` locals.

**Prove:** `tools/parity.rish` GREEN if available; else build rye + rishi.

## Track C — Flow of Values (silo)

**Deliverable:** `active-designing/yonder/20260620-021212_flow-of-values.md`

**Contents (no borrowed names):**

- Four operations kept apart: **transform**, **move**, **route**, **remember**
- **Simple services** — one job, tiny surface, few verbs; map each `983` module to a flow role
- **Values with enduring names** — content-addressing, accretion; Tablecloth slice in `20260620-044012_tablecloth-value-model.md`
- **Systems failure model** — partial failure normal; timeouts, idempotency, exactly-once by name (Comlink)
- Cross-link: `993` (network), `995` (single-stranded), `997` (architecture), `990` (no seams)
- Gratitude pointer in external-research only: `997_SYSTEM.md`, `gratitude/LanguageSystem.md`

## Track D — Caravan Multi-Child (Next Run)

**Sketch for the following session:**

- `caravan/twin.rye` — one parent, two children, each with its own stack garden; parent restarts either on fall; assertions on independent budgets.
- Grows `984` toward chain-loading without kernel.

## Discipline

- **Gall:** each track delivers a running or complete artifact; no whole Pond GUI in one pass.
- **Single-stranded:** Brushstroke draws; Tally bounds; Caravan watches — do not merge into one binary.
- **Gates:** run parity after std-touching changes.
- **Radiant prose** in `977` and this prompt.
- **Session log** `99930_20260620-021212.md`; update `995` What Just Landed when A–C complete.
- **Commit** when all three tracks green; push only if asked.

## Deliverables Checklist

- [ ] `expanding-prompts/20260620-021212_display-flow-gardens-and-next-milestones.md` (this file)
- [ ] `brushstroke/seed.rye` + `.gitignore` allow-list
- [ ] Garden vocabulary sweep (code + docs)
- [ ] `active-designing/yonder/20260620-021212_flow-of-values.md`
- [ ] `work-in-progress/20260623-033012_open-threads.md` updated
- [ ] `session-logs/99930_20260620-021212.md`
- [ ] Parity or build proof recorded in session log

---

*May the first frame draw from values alone. May the garden vocabulary read true in every program we write. May the flow of values find one foundation stone on our own ground — and may the display frontier open, one honest pixel at a time.*
