# Cursor Pass — Fresh Session: Orient, Set the Name Right, Carry the Roadmap Forward

*A starting letter for a new Reya 2 session. The first ring is whole and resting; this pass opens the TAME-hardening milestone by setting the discipline's name right across the living tree, then carries the well-mapped bench forward — with an explicit practice for keeping the roadmap, the threads, and the tasks granular as the work moves.*

**Stamp:** `20260629.032712`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (after this pass, `context/TAME_GUIDANCE.md`) · SLC · Gall
**For:** Cursor Composer 2.5, in the ai-jail sandbox — continuing as Reya 2
**Bridge:** Kaeden carries this in, runs the metal, and rules every open question.

*Written together by Kaeden and Reya 2.*

---

## You Are Reya 2 — Start Here

Read your home before you build, in this order, and let the memory fill the rest.

1. **The handoff letter** — `context/specs/20260629-031512_slc1-ring-closed-handoff.md`. This is the door: what is true, what landed, what waits, the bench order, the pitfalls already proved, and the start signal. Read it first and whole.
2. **Identity and disciplines** — `context/REYA2.md`, then `context/RADIANT_STYLE.md` (voice), the TAME guidance (code — renamed in Phase 1), `context/CIVIC_STYLE.md` (public benefit), `context/SIMPLE_LOVABLE_COMPLETE.md` (scope).
3. **The bench** — `work-in-progress/ROADMAP.md` (why and order) and `work-in-progress/TASKS.md` (what-now). Both are current and granular; trust them as the live plan.
4. **The filing law** — `ORGANIZING.md` at the root.

Trust those as the source of truth. This letter adds the live texture: the rename, the working discipline, and the sequencing.

---

## How We Work

Propose, then apply — one phase at a time, in the order below, each diff shown and confirmed before it lands. Hold an honest definition of done: a change is **verified-by-running** only when it truly runs, and anything needing the `rye` wrapper or the built `rishi`/`mantra` binaries runs on Kaeden's metal — the sandbox panics on `rye`'s DWARF limit. You can typecheck `.rye` against pristine std with the pinned toolchain, and you run every non-`rye` gate you can. Mark each item **[sandbox-verifiable]** or **[metal-gated]** plainly. Build in TAME order — safety, then performance, then the joy of the craft.

---

## How We Keep the Bench Granular

This is the practice that keeps the roadmap, the threads, and the tasks clear as the work moves. Follow it throughout.

1. **Decompose before building.** Every ring or milestone breaks into lettered substeps in `TASKS.md` *before* code is written — the way SLC-1 became 2a–2f and 3a–3c — each with a named witness. The substep is the unit of work and the unit of done.
2. **Edit `TASKS.md` in place.** `[ ]` to do becomes `[~]` in flight becomes `[x]` done. Keep the whole substep tree visible while a ring is open.
3. **Sweep when a section grows heavy.** Move piled `[x]` items into a one-clock session log — the durable record of *how* they landed — and prune `TASKS.md` to what is open and next. What happened lives in `session-logs/`; what is next lives in `TASKS.md`.
4. **`ROADMAP.md` is the map; `TASKS.md` is the bench.** The roadmap holds ring-level why and order and a status column; bump its **Last updated** when a ring closes or a milestone opens. Keep substep granularity out of the roadmap.
5. **Open questions in one place.** `TASKS.md`'s Open Questions holds them; each is resolved by a ruling recorded in a session log, then cleared.
6. **Open-threads graduate into history.** Stop accreting a "what just landed" stack in a dated open-threads file; archiving `work-in-progress/20260623-033012_open-threads.md` into `session-logs/` is itself a Next-tier task on the bench.
7. **One clock, honest history.** Dated artifacts are `YYYYMMDD-HHMMSS_slug.md` (Kaeden supplies the stamp verbatim — never compute one). Living docs evolve in place with **Last updated**. Rename with `git mv`; never silently rewrite, and never falsify what history recorded.
8. **Credit and commits.** Dated collaborative artifacts carry *Written together by Kaeden and Reya 2*; permanent context files omit it. Ship the session log in the same commit as its work; one logical change per commit.

---

## The Bench, in Order

The roadmap already holds this; here it is at a glance, with the rename as the milestone's opener:

1. **Phase 1 — Set the name right** (this pass): TAME Style → TAME Guidance, living surfaces only. **[sandbox-verifiable]**
2. **Phase 2 — TAME hardening, keystone first**: width-check refinement (ruling #1) → `tame-check` lints + Mantra compliance → `mantra/*` Phase 1b → `.brix` mend → `rishi/*` width pass.
3. **Phase 3 — Rishi script arguments** + the launcher graduation.
4. **Phase 4 — Aurora**: name the `catch unreachable` invariants (optional, parallel).
5. **Beyond** — SLC-2, the Pond GUI, when Skate text rendering is ready.

Phases 2–4 are already spec'd in detail; this pass points to those specs rather than repeating them, and re-verifies each against the current tree before acting.

---

## Phase 1 — Set the Name Right: TAME Style → TAME Guidance

A naming pass, fully **[sandbox-verifiable]** — `git mv`, text edits, and `git grep` verification, no metal needed. The craft is in the scope: **rename the living surfaces, and leave honest history as it was written.**

### Rename (git mv) — the living discipline files and rules

- `context/TAME_STYLE.md` → `context/TAME_GUIDANCE.md` — title to *# TAME Guidance — Operational Supplement*; update the doc-stack table and any self-references.
- `external-research/TAME_STYLE.md` → `external-research/TAME_GUIDANCE.md` — title and self-references. *(Its location in `external-research/` is a separate question — flag it for Kaeden, change nothing about the folder this pass.)*
- `.cursor/rules/tame-style.mdc` → `.cursor/rules/tame-guidance.mdc`
- `.claude/rules/tame-style.md` → `.claude/rules/tame-guidance.md`
- `context/specs/tame-style.md` (the "Moved" stub) → `context/specs/tame-guidance.md`, pointer updated to `../TAME_GUIDANCE.md`.

Inside each, the discipline's full name becomes **TAME Guidance**. The **bare name "TAME" does not change** — "TAME hardening," "Lens: TAME," "TAME lints," "the TAME Editor" all stay; only *TAME Style* → *TAME Guidance* and the `TAME_STYLE.md` path → `TAME_GUIDANCE.md`.

### Bring the rules current while you are in them

The agent rules still instruct `const garden = init.garden.allocator()`, yet the seeds migrated to `init.arena` in the harvest. Update that guidance to reality, so a fresh agent is not misled: `init.arena` is the season allocator at the std seam; `garden` lives as a warm local name and as Tally's future concept. *(This touches the open garden-vs-arena lexicon question — note it for Kaeden; the migration itself is settled and in the code.)*

### Update references — the living surfaces only

Use `git grep -l "TAME_STYLE"` and `git grep -l "TAME Style"`, then update **only the living surfaces**: the discipline docs and rules above; `context/README.md`, `context/CIVIC_STYLE.md`, `context/RADIANT_STYLE.md`, `context/SIMPLE_LOVABLE_COMPLETE.md`; `context/specs/civic-style.md`, `context/specs/inherited-names.md`, `context/specs/rye-as-its-own-language.md`, and the handoff `context/specs/20260629-031512_slc1-ring-closed-handoff.md`; the living module and process docs `rye/README.md`, `aurora/README.md`, `gratitude/README.md`, `external-research/README.md`, `rye-learning-process/README.md`, `rye-learning-process/ALMANAC.md`; the living design brief `active-designing/yonder/20260618-184912_growing-a-language.md`; the width tooling `tools/width-check.rish` and `tools/tame_usize_audit.rye`; and the code comment in `aurora/src/seed.rye`.

### Leave honest history untouched

Do **not** edit these — they recorded "TAME Style" when it was true, and that record stays honest:

- `session-logs/*` — what happened, as it happened
- `strengthening-compiler/*` — the completed chronicle
- `external-research/*` dated studies (everything except the renamed `TAME_GUIDANCE.md` and the README ref)
- `work-in-progress/archive/*`, and the dated WIP artifacts (`20260620-212126_usize-width-baseline.md`, `20260623-033012_open-threads.md`)
- already-executed `expanding-prompts/*` (records of plans that ran)

### Verify

After the pass, `git grep "TAME_STYLE"` across the living set returns nothing, and no living document carries a dangling link to the old path. A whole-tree grep still finding "TAME Style" in `session-logs/`, `strengthening-compiler/`, and the dated studies is **expected and correct** — that is history kept honest. Show both: the living set clean, the history intact.

---

## Phase 2 — TAME Hardening, Keystone First

The detailed, gated specs already exist in `expanding-prompts/20260629-004912_cursor-pass-slc1-version-recall-and-tame.md`, Phases 4–6 — never executed, because Steps 2–3 were driven straight through. **Resume them there, re-verified against the current tree** (note: Steps 2–3 added a few honest `usize` seam casts in `rishi/src/main.rye`, so its count grew). Order:

1. **Width-check refinement (ruling #1, approved).** Refine `tools/width-check.rish` to flag authored `usize` while blessing the sanctioned `@intCast` / `@as(usize` seam casts that Tally itself uses. The keystone — without it, the migration cannot complete and the gate stays red on Tally's own exemplar.
2. **First `tame-check` lints + Mantra compliance.** Create `tools/tame-check.rish` (unqualified-assert, no `Self = @This()`, no tabs/trailing whitespace), informational at first; bring `mantra/*` to the bare `assert`.
3. **`mantra/*` Phase 1b width migration**, now completable under the refined lint, mirroring Tally's `bufLenU32` seam.
4. **`.brix` dead-path mend** — replace `work-in-progress/995_open_threads.md` and `996_roadmap.md` with `ROADMAP.md` and `TASKS.md`; Kaeden supplies the version stamp.
5. **`rishi/*` width pass** — the larger migration, following the same seam discipline.

Decompose each into TASKS substeps with witnesses as you go, per the granular practice above.

---

## Phase 3 — Rishi Script Arguments + Launcher Graduation

Spec'd in `expanding-prompts/20260629-030912_cursor-rishi-args-and-dev-loop.md`, Section C. The capability: pass `args[3..]` from `rishi run <file> …` through the interpreter and expose them to the script as an `args` value (today `runFile` reads only `args[2]`); assert the count bound; witness with a small flag-reading `.rish`; then a `--flag value` parse helper. The first beneficiary: `launch-cursor.rish` reads `--appimage PATH`, and `tools/cursor-jail.sh`'s flag layer graduates out of POSIX shell. **[sandbox-verifiable to typecheck; metal-gated to run]**

---

## Phase 4 — Aurora: Name the Invariants (optional, parallel)

Spec'd in the same `20260629-004912` runbook, Phase 7. Aurora is freestanding — **do not** convert its bare-metal `assert`, touch its widths, or add it to the assert lint. The honest touch is *say-why*: a short rationale per function or block naming the invariant that makes each `catch unreachable` safe (fixed-seed determinism, a length the format guarantees). **[sandbox-verifiable]**

---

## The Gates

- **`parity.rish`** — 120 witnesses (the four SLC-1 verbs sealed). **[metal-gated]**
- **`parity-selftest.rish`** — the pristine-std symlink guard. **[metal-gated]**
- **`additive-gate.rish`** — the structural gate. **[metal-gated]**
- **`width-check.rish`** — refined in Phase 2; green on migrated files. **[metal-gated to run]**
- **`tame-check.rish`** — new in Phase 2; informational. **[metal-gated to run]**

State plainly at each phase's end which gates ran by running and which await metal.

---

## Commit, Push, Session Log

Per the granular practice: commit each phase as one honest unit with its session log in the same commit; push over HTTPS to the four remotes from the host; Berry on the tip if it pleases Kaeden. Write the rename's log at `session-logs/<filing-stamp>_tame-guidance-rename.md`, coauthored — what was renamed, what was left as history, the rule-currency fix, and the verification.

*(Kaeden: supply the filing stamp verbatim; `20260629.032712` is this pass's mark.)*

---

## The Rulings to Surface

1. **Rename scope** — living surfaces renamed, history left honest, as drawn above. *Recommended as written.*
2. **Garden-vs-arena lexicon** — the standing question: `arena` at the std seam, `garden` as Tally's future concept; a short `context/` lexicon note once ruled.
3. **The voiced canon's home** — `external-research/TAME_GUIDANCE.md` is a living discipline doc in a study folder; it may belong in `context/` beside the others. *A later move, not this pass — flag only.*

---

## Definition of Done (this pass)

- [ ] The two discipline docs, the two rules, and the stub are renamed; the discipline reads *TAME Guidance* throughout the living tree
- [ ] The rule files name `init.arena` at the seam, no longer `init.garden`
- [ ] Living references updated; `git grep "TAME_STYLE"` is clean across the living set; history is intact and shown so
- [ ] The rename's session log is written and committed; pushed to the four remotes
- [ ] Phases 2–4 are queued in `TASKS.md` with substeps and witnesses, ready to build in order

---

*May the fresh session open with the door already lit and the map already true. May the name we give our discipline fit the discipline it names. And may the bench stay granular and honest, season after session, so that whoever sits down next finds exactly the next small thing worth finishing.*
