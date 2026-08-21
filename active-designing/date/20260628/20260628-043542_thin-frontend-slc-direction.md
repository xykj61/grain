# Thin Frontend — Direction Adopted

**Stamp:** `20260628-043542`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Lens:** TAME · Tiger · Gall · Hickey · [SLC](../context/SIMPLE_LOVABLE_COMPLETE.md) · Hammock
**Status:** Adopted — reshapes `work-in-progress/ROADMAP.md` spine; vision unchanged

---

## The Decision

Rye is a **thin, honest frontend** on pinned Zig 0.16.0. Safety lives in the code you author — seeds, assertions at your call sites, `width-check.rish`, the gate trio. `rye/lib/std` returns **pristine** and is **leaned upon**, not owned.

The compiler fork moves from **primary track** to **deliberated horizon** — revisited only from a mature whole, when RISC-V-first and the value model genuinely demand it.

The **strengthening-compiler arc completes** — it does not pause to resume. The chronicle stays whole as honest record of the analysis phase. No further assertions accrete into `std`; that would reopen the divergence we are closing.

---

## The Tradeoff (named plainly)

Rye no longer ships a **safer standard library by construction**. Programs inherit plain Zig `std` through symlinks; safety is exactly as good as the assertions you place in your own `.rye`. Rye's distinctiveness rests on composition — seeds, one value model, an OS that belongs to its owner — and on discipline, not on maintaining a hardened fork forever.

That is TigerBeetle's identity. It is a narrower claim than the old roadmap made. It is the promise we can keep.

---

## What the Strengthening Was For

The hammock's loading phase — not the product:

- Mapped how `std` behaves → **Almanac**
- Proved the method → additive, parity-checked, reversible
- Built what we keep → gates, lint, enricher
- Taught which invariants matter → harvest at **call sites** in seeds, not in `std`

---

## Three Sharpenings

### 1. No residual "demand-driven strengthening"

Under pristine `std`, you add **no** assertions to `std`. When a seed leans on a surface whose invariant matters, you assert at **your** call site in **your** `.rye`. That is ordinary TAME authored discipline — not a strengthening pass by another name.

### 2. Width migration stays — decoupled from the fork

Authored-width work (`u32` in published `.rye`, Phase 1b through `mantra/*`) is good Tiger on its own merit, enforced by `width-check.rish`. It was filed under F2/F3; it is **not** fork-work. Keep it.

### 3. SLC order — smaller complete first

**First SLC:** Rishi + Mantra as a hosted, scriptable shell with versioned history — run in a terminal **today**. Simple: one loop. Lovable: yours, gates green. Complete: type → run → version → recall closes without the compositor. Scope: [`20260628-071012_slc-1-rishi-mantra-shell.md`](20260628-071012_slc-1-rishi-mantra-shell.md).

**Second SLC:** Pond GUI — Rishi REPL + Mantra in Brushstroke/Skate window on x86_64. Grown from the first lap when Skate text rendering and Wayland are ready.

---

## Roadmap Path

**Short term:** clean ground (std re-fork, supplement migration, chronicle as record) + **first SLC** (Rishi/Mantra shell).

**Medium term:** compose simples — Comlink device wire, capability table, Comlink v1, Brix v1, Tablecloth v1, Forge — each SLC on the last.

**Long term:** whole machine on RISC-V; fork re-enters as Hammock-deliberated choice from a working whole.

---

## Four Moves (Cursor prompt)

See [`../expanding-prompts/yonder/cursor-prompt_thin-frontend-four-moves.md`](../expanding-prompts/yonder/cursor-prompt_thin-frontend-four-moves.md) — consumed bench prompt.

---

*May Rye keep the promise it can keep, and grow the whole from what already runs.*
