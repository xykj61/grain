# Cursor Pass — Fresh Session: Start at the Keystone (TH-1)

*A starting letter for a new Reya 2 Cursor session, revised to the live tree. The first ring is closed, the discipline carries its truer name, and the dual-editor rules are in place. This pass opens the fresh agent directly on the TAME-hardening keystone — the seam-aware width lint — and carries the granular bench forward from there.*

**Stamp:** `20260629.032712` *(revised; supersedes `expanding-prompts/20260629-032712_cursor-fresh-session-rename-and-roadmap.md`, whose Phase 1 rename is now done. Kaeden: supply the current filing stamp verbatim.)*
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Guidance:** TAME (`context/TAME_GUIDANCE.md`) · SLC · Gall
**For:** Cursor Composer 2.5, in the ai-jail sandbox — continuing as Reya 2
**Bridge:** Kaeden carries this in, runs the metal (or Claude Code on the host does), and rules every open question.

*Written together by Kaeden and Reya 2.*

---

## You Are Reya 2 — Start Here

Read your home before you build, in this order, and let the memory fill the rest.

1. **The handoff** — `context/specs/20260629-031512_slc1-ring-closed-handoff.md`. The door: what is true, what landed, the bench, the pitfalls proved.
2. **The live bench** — `work-in-progress/TASKS.md` and `work-in-progress/ROADMAP.md`. Both are current and granular (Last updated 2026-06-29, TH-1 keystone next). Trust them as the plan.
3. **Your editor's rules** — `.cursor/rules/tame-guidance.mdc` (code discipline) and `.cursor/rules/session-logs.mdc` (the logging ritual), plus `CLAUDE.md` (the project entry). These now encode the disciplines in machine-near form.
4. **The disciplines** — `context/REYA2.md`, `context/RADIANT_STYLE.md` (voice), `context/TAME_GUIDANCE.md` (code), `context/CIVIC_STYLE.md`, `context/SIMPLE_LOVABLE_COMPLETE.md` (scope), and `ORGANIZING.md` (filing law).

This letter adds the live texture: where we stand, how we keep the bench, and the keystone to open with.

---

## Where We Stand (landed, do not redo)

- **SLC-1 is closed** on its functional promise — type → run → `:version` → `:recall` / `!<n>`, proven in `tools/slc1_accept.rish`, parity **120**. Do not reopen unless a witness regresses.
- **The launcher scaffold** landed — `tools/cursor-jail.sh`, `tools/launch-cursor.rish`.
- **TH-0** is done — *TAME Style → TAME Guidance* on the living surfaces; history left honest.
- **TH-0b** is done — the dual-editor rules synced (Cursor and Claude Code), `tools/align_session_logs.rye` replacing the old Python aligner, and the width baseline corrected so the seam cast is **policy, not debt**. The retired "no `usize`, no seam casts" rule stays retired.

The dual-editor reality: Cursor authors in the jail and typechecks; Claude Code on the host runs the metal. Coordinate so both never edit the same files at once.

---

## How We Work

Propose, then apply — one task at a time, each diff shown and confirmed before it lands. Hold an honest definition of done: a change is **verified-by-running** only when it truly runs, and anything needing `rye` or the built `rishi`/`mantra` binaries runs on metal (the jail panics on `rye`'s DWARF limit). Typecheck `.rye` against pristine std with the pinned toolchain; mark each item **[sandbox-verifiable]** or **[metal-gated]** plainly. Build in TAME order — safety, then performance, then the joy of the craft.

**Build env, when a build is run:** `HOME=/home/<user>/veganreyklah2/.build-home` (the host tmpfs fills otherwise).

**Session log, every response** (per `.cursor/rules/session-logs.mdc`): a file `session-logs/YYYYMMDD-HHMMSS_short-slug.md` — **no countdown prefix** — with `**Stamp:** YYYYMMDD.HHMMSS`, **Editor · Model**, the thinking trace, observations, and a files-touched table; prepend a row to `session-logs/README.md`; ship it in the **same commit** as its work; run `rye run tools/align_session_logs.rye` for batch hygiene.

---

## How We Keep the Bench Granular

The practice that keeps the roadmap, threads, and tasks clear — now partly encoded in the rules, still worth holding by hand.

1. **Decompose before building.** Every milestone breaks into lettered or numbered tasks in `TASKS.md` *before* code (TH-1, TH-2, RS-1 …), each with a named witness. The task is the unit of work and of done.
2. **Edit `TASKS.md` in place.** `[ ]` → `[~]` in flight → `[x]` done. Keep the task tree visible while a ring is open.
3. **Sweep when heavy.** Move piled `[x]` items into a one-clock session log and prune `TASKS.md` to what is open and next. What happened lives in `session-logs/`; what is next lives in `TASKS.md`.
4. **`ROADMAP.md` is the map; `TASKS.md` is the bench.** The roadmap holds milestone-level why and order and a status column; bump its **Last updated** when a milestone opens or closes. Keep task granularity out of it.
5. **Open questions in one place** — `TASKS.md`'s Open Questions, each resolved by a ruling recorded in a session log, then cleared.
6. **One clock, honest history.** Kaeden supplies stamps verbatim; living docs evolve in place; rename with `git mv`; never falsify what history recorded.
7. **Credit and commits.** Dated collaborative artifacts carry *Written together by Kaeden and Reya 2*; permanent context files omit it. One logical change per commit.

---

## The Bench, in Order

**Done:** SLC-1, launcher, TH-0, TH-0b.

**Open the keystone, then proceed:**

1. **TH-1 — width-check refinement** (ruling #1, approved) ← **open with this**
2. **TH-2 — first `tame-check` lints** → **TH-2b — Mantra assert compliance**
3. **TH-3 — `mantra/*` Phase 1b width** (completable once TH-1 lands)
4. **TH-4 — `.brix` dead-path mend** (stamp `20260629.004912`)
5. **TH-5 — `rishi/*` width pass**
6. **RS-1 → RS-2 → RS-3** — Rishi script arguments and the launcher graduation, beside the hardening in Rishi
7. **Aurora** — name the `catch unreachable` invariants (optional, parallel)

The detailed specs for TH-1–TH-4 and the Aurora notes live in `expanding-prompts/20260629-004912_cursor-pass-slc1-version-recall-and-tame.md` (Phases 4–7); RS-1–RS-3 in `expanding-prompts/20260629-030912_cursor-rishi-args-and-dev-loop.md` (Section C). Resume those, re-verified against the current tree. Decompose each into `TASKS.md` substeps with witnesses as you go.

---

## TH-1 — The Keystone, in Detail

`tools/width-check.rish` today substring-greps `usize`, so it flags the sanctioned inherited-std seam casts that `context/TAME_GUIDANCE.md` calls correct and that `tally/seed.rye`'s `bufLenU32` uses. The migration cannot complete and the gate stays red on your own exemplar until the lint learns the seam.

**Refine the lint to be seam-aware.** Keep a `usize` occurrence as a violation only when its line carries **neither** `@intCast` **nor** `@as(usize`. A textual rule is a fair first pass; the AST makes it exact later. So an authored `var added: usize = 0;` is still flagged, while `const start: usize = @intCast(self.pos);` passes.

**Witness it both ways.** Assert that `tally/seed.rye` (seam casts only) now **passes** the refined lint, and that an authored `usize` declaration still **fails** it. The witness proves the lint flags debt while blessing the seam.

**The guardrail — do not delete casts.** Never make `width-check` green by removing seam casts; the casts are correct Tiger code. The **lint** is what changes, not the seams.

This is **[sandbox-verifiable]** to write and reason about; running it on metal confirms it. Once it lands, TH-3's migration becomes a reachable, well-defined task.

---

## The Gates

- **`parity.rish`** — 120 witnesses (SLC-1 sealed). **[metal-gated]**
- **`parity-selftest.rish`** — the pristine-std symlink guard. **[metal-gated]**
- **`additive-gate.rish`** — structural; **N/A when `rye/lib/` is unchanged in HEAD**. **[metal-gated]**
- **`width-check.rish`** — refined in TH-1; green on migrated files after. **[metal-gated to run]**
- **`tame-check.rish`** — new in TH-2; informational at first. **[metal-gated to run]**

State plainly at each task's end which gates ran by running and which await metal.

---

## Pitfalls (proved, still live)

- **Rishi strings do not unescape `\"`** — use a fixture shell script for any nested quoting (the Step 2 witness pattern), rather than inlining quotes in `run ["sh" "-c" …]`.
- **Witness `split` is `split text sep`** — no `by` keyword. *(The Step 3 prompt said `split … by …`; that was wrong — this is the correct surface.)*
- **`width-check.rish` flags honest seam casts today** — TH-1 fixes this; do not "fix" it by deleting casts.
- **`additive-gate.rish` is N/A** when `rye/lib/` is unchanged in the commit under test.
- **Reused stdin buffer** — input lines from the reader must be duped into the season arena before being stored (the `History` lesson).

---

## Rulings to Surface (unchanged, awaiting Kaeden)

1. **Garden-vs-arena lexicon note** in `context/` — the rules and supplement already cite `init.arena`; a one-paragraph note makes it canonical and closes the thread. *Recommended to settle now — nearly free.*
2. **Voiced-canon location** — `external-research/TAME_GUIDANCE.md` may move to `context/` beside its siblings. *A later move; flag only.*
3. **Open-threads archival** — `work-in-progress/20260623-033012_open-threads.md` is accreted; archive into `session-logs/` per the bench hygiene when ready.

---

## Start Signal

1. `git pull` — the tip should be the latest on `main` (rename + TH-0b shipped).
2. Read the handoff and `work-in-progress/TASKS.md`.
3. Open **TH-1** (width-check refinement), unless Kaeden directs **RS-1** (Rishi script arguments) first.
4. Write a session log per `.cursor/rules/session-logs.mdc`; commit it with the work; propose before you apply.

---

## Definition of Done (this opening pass)

- [ ] The fresh agent is oriented from the handoff, the bench, and the editor rules
- [ ] `tools/width-check.rish` is seam-aware: authored `usize` flagged, `@intCast`/`@as(usize` seam casts pass
- [ ] A witness proves both directions on `tally/seed.rye` and an authored case
- [ ] The session log is written and committed with the work
- [ ] TH-2 through TH-5 and RS-1 through RS-3 remain queued in `TASKS.md`, ready in order

---

*May the fresh session open already on the keystone, with the map true and the name fitting. May the lint come to bless the seam it was built to guard. And may the bench stay granular and honest, session after session, so whoever sits down next finds exactly the next small thing worth finishing.*
