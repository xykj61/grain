# Expanding Prompts

*A place where a request becomes a plan. When you hand me a seed of intent, I bring it here, read it closely through every lens we have built, and craft from it a fuller, clearer prompt for myself -- one I can then run. The seed stays yours; the expansion is how I make sure I have understood it, sharpened it, and lost none of it.*

**Language:** EN
**Last updated:** `20260811.211431` (AHOY front-door season - **ty every1** closing gesture seated)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Seasons roster:** [`SEASONS.md`](SEASONS.md)

---

## Why This Stack Exists

A prompt is a seed. It carries intent -- often more than its words say outright, and sometimes a little less than it means. The other stacks here grow outward from decisions already made; this one grows *inward* first. It takes what you asked and expands it into a working specification before any of it is built.

The practice is simple, and I mean it kindly: I restate your intent in full, I name the deliverables plainly, I apply our active-designing principles, our TAME lens, and the radiant voice, and I add the questions and structure that will make the work good. Then I run that expanded prompt. Nothing of yours is dropped; what I add is scaffolding, never substitution.

Why keep them at all? Because a prompt well understood is half the work, and a prompt misunderstood is the most expensive mistake there is. Writing the expansion down lets you see how I heard you -- and correct me before, not after.

## The closing gesture -- **ty every1**

Every expanded prompt ends on the same warm note the request that seeded it carries: **ty every1** -- thank you, everyone. It is a small, sincere gratitude to every hand and mind the work leans on -- the reader who asked, the teachers in [`../gratitude/`](../gratitude/README.md) whose ideas we studied in the clean room, the prior seasons whose fossils we build atop, and whoever will run what we wrote. An expansion is a shared act; the closing line says so plainly. Where a prompt carries an earned radiant wish (`../.claude/rules/radiant-wishes-ending.md`), **ty every1** rides just before it, so the benediction stays the last word. It is never an alarm or a flourish -- only the honest, glad thanks that closes a good handoff.

## One clock, one order

Dated prompts carry `YYYYMMDD-HHMMSS_short-sprig.md`; this README is the living foundation. Full naming law: [`../context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

**Consumed prompts** -- including executed `cursor-*` bench passes and legacy `cursor-prompt_*` files from the one-clock reorg -- rest in [`yonder/`](yonder/) when the work they drove has landed. Session logs record the outcome; the prompt stays as an honest record of how the request was expanded.

## Redirects and retired patterns

**Executed prompts** become redirect stubs at the stub-event stamp `20260621-051612` with distinct `-redirect` sprigs. See also [`../external-research/README.md`](../external-research/README.md).

**Current tooling (use these):**

| Role | Path |
|------|------|
| Parity gate | `tools/p/parity.rish` |
| Additive gate | `tools/ad/additive-gate.rish` |
| Strengthening enricher | `tools/rye/enrich_strengthening_docs.rye` |
| Session log aligner | `tools/rye/align_session_logs.rye` |
| Width audit (hosted gate) | `tools/w/width-check.rish` in `tools/p/parity.rish`; charter [`20260620-210812_explicit-width-audit.md`](date/20260620/20260620-210812_explicit-width-audit.md) |


### Topic routing (from retired `10010_reserved`)

| Topic | Lives in |
|-------|----------|
| Tablecloth + Brix compose | [`20260620-043812_tablecloth-brix-split.md`](yonder/20260620-043812_tablecloth-brix-split.md) through [`20260620-044112_tablecloth-v1-seed.md`](yonder/20260620-044112_tablecloth-v1-seed.md) |
| Main track (Rye - Rishi - strengthening - width fork) | [`yonder/20260621-051612_main-track-rye-rishi-strengthening.md`](yonder/20260621-051612_main-track-rye-rishi-strengthening.md) (consumed), [`20260620-210812_explicit-width-audit.md`](date/20260620/20260620-210812_explicit-width-audit.md), [`../construction/ROADMAP.md`](../construction/ROADMAP.md), [`../construction/TASKS.md`](../construction/TASKS.md) |
| Strengthening doc + width enricher | [`yonder/20260621-051612_strengthening-stdlib-doc-width-pass-redirect.md`](yonder/20260621-051612_strengthening-stdlib-doc-width-pass-redirect.md) -> [`../tools/rye/enrich_strengthening_docs.rye`](../tools/rye/enrich_strengthening_docs.rye) |
| Literal `usize` ban / language fork | [`../external-research/20260621-051312_literal-usize-ban-language-fork.md`](../external-research/20260621-051312_literal-usize-ban-language-fork.md), [`../active-designing/yonder/20260621-051312_explicit-width-in-rye.md`](../active-designing/yonder/20260621-051312_explicit-width-in-rye.md), [`../external-research/20260621-050312_usize-boundary-not-design.md`](../external-research/20260621-050312_usize-boundary-not-design.md) |

**Retired in new prompts:** `tools/parity.sh`, `enrich_strengthening_docs.py`, `align_session_logs.py`, `parity.rye` as gate target, `init.arena`, authored `ArenaAllocator`, "`usize` only at seam" as **permanent** policy (interim only -- see width fork links above).

**Width:** charter [`20260620-210812_explicit-width-audit.md`](date/20260620/20260620-210812_explicit-width-audit.md); baseline [`../construction/20260620-212126_usize-width-baseline.md`](../construction/20260620-212126_usize-width-baseline.md); fork research [`../external-research/20260621-051312_literal-usize-ban-language-fork.md`](../external-research/20260621-051312_literal-usize-ban-language-fork.md); design [`../active-designing/yonder/20260621-051312_explicit-width-in-rye.md`](../active-designing/yonder/20260621-051312_explicit-width-in-rye.md); interim seam [`../external-research/20260621-050312_usize-boundary-not-design.md`](../external-research/20260621-050312_usize-boundary-not-design.md).

## What Belongs Here

- The expanded prompt itself: my improved, structured reading of a request.
- A faithful echo of the original intent, so the seed is never lost.
- The lens applied: which principles and filters shaped the expansion.
- The plan I will run, and the deliverables it should produce.

What does *not* belong here is the work itself -- that lands in the research, design, and code stacks. This is only where intent is sharpened into a plan.

## Expanded prompts -- where they are

Every day this index carried has folded onto its own dated shelf, on `20260824.171500`, and the
[seasons roster](SEASONS.md) lists all 21 with their counts. A shelf reads exactly as this page
read before the fold -- stamp, prompt, and one line of what it asked for -- so the way in is the
same, one day at a time:

| Day | Prompts | Shelf |
|---|---:|---|
| `20260618` | 3 | [`date/README-index-20260618.md`](date/README-index-20260618.md) |
| `20260619` | 7 | [`date/README-index-20260619.md`](date/README-index-20260619.md) |
| `20260620` | 11 | [`date/README-index-20260620.md`](date/README-index-20260620.md) |
| `20260621` | 4 | [`date/README-index-20260621.md`](date/README-index-20260621.md) |
| `20260628` | 1 | [`date/README-index-20260628.md`](date/README-index-20260628.md) |
| `20260701` | 2 | [`date/README-index-20260701.md`](date/README-index-20260701.md) |
| `20260702` | 2 | [`date/README-index-20260702.md`](date/README-index-20260702.md) |
| `20260703` | 1 | [`date/README-index-20260703.md`](date/README-index-20260703.md) |
| `20260704` | 3 | [`date/README-index-20260704.md`](date/README-index-20260704.md) |
| `20260705` | 10 | [`date/README-index-20260705.md`](date/README-index-20260705.md) |
| `20260706` | 2 | [`date/README-index-20260706.md`](date/README-index-20260706.md) |
| `20260709` | 11 | [`date/README-index-20260709.md`](date/README-index-20260709.md) |
| `20260710` | 4 | [`date/README-index-20260710.md`](date/README-index-20260710.md) |
| `20260711` | 1 | [`date/README-index-20260711.md`](date/README-index-20260711.md) |
| `20260715` | 4 | [`date/README-index-20260715.md`](date/README-index-20260715.md) |
| `20260716` | 1 | [`date/README-index-20260716.md`](date/README-index-20260716.md) |
| `20260718` | 1 | [`date/README-index-20260718.md`](date/README-index-20260718.md) |
| `20260724` | 2 | [`date/README-index-20260724.md`](date/README-index-20260724.md) |
| `20260725` | 1 | [`date/README-index-20260725.md`](date/README-index-20260725.md) |
| `20260727` | 2 | [`date/README-index-20260727.md`](date/README-index-20260727.md) |
| `20260728` | 5 | [`date/README-index-20260728.md`](date/README-index-20260728.md) |

That is **78 indexed prompts** across 21 days. **The room is living, so new rows arrive here**:
an expansion written today is listed below until its day closes and folds, which keeps this page
and the room describing one set. The room holds **564** dated files in all, so a prompt the index
never carried is still found the way any dated file is --
`rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>` computes its home from the stamp
in its own name.

| Stamp | Prompt | Meaning |
|-------|--------|---------|
| `20260823.124407` | [The Ranked Remainder](20260823-124407_the-ranked-remainder.md) | The whole outstanding vision ordered Lindy-first and crux-first, each item carrying its cost, gate, and falsifier. |
| `20260823.045448` | [The Gauge Standfast](20260823-045448_the-gauge-standfast.md) | Name the register, measure it, then sweep on a word -- the pass that seated Gauge Style. |

---

*May every seed be heard in full. May what I add only clarify, never crowd. And may the prompt I write for myself stay truer to your meaning than the bare words could carry alone.*

