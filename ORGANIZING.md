# Organizing the Repository

*A durable guide to where work lives, how new writing earns its place, and how the tree stays honest over time.*

**Language:** EN
**Last updated:** 2026-07-12 (docs compression layer design seated)
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**Voice:** Rio 3

---

## A Word First

This repository holds an operating system, a civic application built upon it, the research and design that feed both, and the disciplines that govern how we write code, prose, product, and public benefit. The tree is large on purpose. This guide names its shape so a person or an agent arriving fresh can orient in one calm read — without memorizing countdown conventions, count-up exceptions, or season-specific snapshots that go stale the moment they are written.

Read the sections below when you wonder where a new file belongs. When a season's placements are settled, record them in `session-logs/`; this guide stays evergreen.

---

## The Shape of the Tree

**`context/`** — memory and compass. The disciplines we keep across every track: Tiger and TAME for code rigor, Radiant for prose, Simple-Lovable-Complete for product scope, and Civic for designing public benefit so the reward points at the good. Identity (`RIO3.md` this season; `REYA2.md` resting), and `specs/` for plain-English decisions that deserve a durable home.

**`foundations/`** — the why beneath the work: foundation briefs, the distilled essays and the weave that composes them, and the civic visions. Dated artifacts rest beneath a living README.

**`classical-vedic-astrology/`** — the reading craft: a siloed study library in topic folders (`studies/nakshatras/`, `planets-in-signs/`, `planet-in-house/`, …), composable templates in `templates/`, demonstration readings in `readings/`, and the dual-zodiac caster. Names stay siloed to the placeholder **Alice** by consent and by design; the fuller originals rest in the private lane, and gratitude to teachers lives inside each study.

**`manual/`** — the four rooms that teach the system: tutorials by the hand, guides for the task, living reference specifications for stable surfaces, and pointers to the understanding essays. Every page teaches only what runs; the first reference open is the Rishi language, derived from the witness corpus.

**`linengrow/`** — the civic-application track: Linengrow's README, business model, and venture pitch, sharing the one spine with the operating system. It graduates to its own repository once its first lap runs.

**`work-in-progress/`** — the workbench. The living roadmap (`ROADMAP.md`), the granular plan (`TASKS.md`), open threads, and dated artifacts for work still in motion. Finished scaffolding graduates to `archive/`.

**`active-designing/`** — design in motion. Our own module names, RISC-V-first, siloed from gratitude sources. Dated briefs; living README index. **Raw layer** for the docs compression shelf — dated notes stay here; they are not yondered when `docs/` compresses them.

**`docs/`** — compression layer at the repo root (TigerBeetle `docs/` precedent). Living guides that compress many dated sources in `active-designing/`, counsel, and witnesses. Pages compress the record; they never replace it. Pin-strings point at witnesses — docs carry no load-bearing pins. Design law: [`active-designing/20260712-221600_docs-compression-layer-design.md`](active-designing/20260712-221600_docs-compression-layer-design.md).

**`external-research/`** — study of the world with attribution. Explorations, comparisons, voiced adaptations of gratitude sources. Living README. **Research for understanding — advice stays elsewhere:** surveys and memos here frame understanding only — they recommend no purchase, no treasury action, and no licensed professional course; policy and money choices belong to Kaeden in their own season. Say so in each file's status line; CIVIC stays policy-shaped in `context/`. Proposed register law: [`context/TWO_ROOMS.md`](context/TWO_ROOMS.md) (seats on Kaeden's word).

**`counsel/`** — the bench's answer to a pending project decision. Analysis, rulings, proposals, and recommendations from Claude (or the bench) in response to a specific question Kaeden asked — propose-never-seat. Each piece stays as filed; Kaeden's word seats decisions in `active-designing/`, `context/specs/`, or the module home. Living README at [`counsel/README.md`](counsel/README.md).

**`expanding-prompts/`** — intent expanded into runnable plans. Counts upward from `10000`; each prompt is a dated artifact that agents can execute.

**`session-logs/`** — reasoning traces as **Bron** (`.bron`); one-clock filenames; newest-first index in `README.md`. Historical Markdown logs live under `archive/YYYYMMDD/`. What happened lives here; what is next lives in `TASKS.md`.

**`rye-learning-process/`** — the almanac and learning record. How we grow capability in the open.

**`strengthening-compiler/`** — the strengthening chronicle. Analysis complete; record, not active product track.

**`gratitude/`** — works we honor, held whole for clean-room study. Never copy code or text into our modules.

**`vendor/`** — third-party source the build leans on, local and unmodified.

**Module homes** — [`rye/README.md`](rye/README.md) · [`rishi/README.md`](rishi/README.md) · [`tally/README.md`](tally/README.md) · [`caravan/README.md`](caravan/README.md) · [`mantra/README.md`](mantra/README.md) · [`comlink/README.md`](comlink/README.md) · [`pond/README.md`](pond/README.md) · [`aurora/README.md`](aurora/README.md) · [`brushstroke/`](brushstroke/) · [`linengrow/`](linengrow/) (vision until graduation), and the rest: each grows a seed toward a running whole.

**`tools/`** — gates, witnesses, launch scripts, and the strict checks that keep the tree honest. Some `.sh` scripts are POSIX seams (QEMU backgrounding, cold-start bootstrap, external interpreters) and stay `.sh` by design — see [`context/TAME_GUIDANCE.md`](context/TAME_GUIDANCE.md) · counsel [`counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md`](counsel/20260707-195912_claude-counsel-tools-census-and-sh-rish-boundary.md).

**Root** — `SOURCE.md`, `CLAUDE.md`, this guide, and a few allow-listed files that orient newcomers before they dive.

---

## The One Test for Placement

Read the piece aloud. Ask what it is *doing*:

- **Governing how we write or decide** → `context/` (discipline or spec).
- **Naming why the work means something** → `foundations/` (brief, essay, vision, or weave).
- **Reading a friend's sky** → `classical-vedic-astrology/` (study, template, reading, or caster).
- **Teaching or looking something up** → `manual/` (tutorial, guide, or reference — only what runs).
- **Carrying Linengrow's application vision** → `linengrow/`.
- **Deciding our own design** → `active-designing/`.
- **Compressing many dated design notes into one operator guide** → `docs/` (Checkable; cites witnesses).
- **Advising on a decision this project is about to make** → `counsel/` (analysis, ruling, proposal, or recommendation — awaiting Kaeden's word).
- **Studying an external work** → `external-research/`.
- **Expanding intent into a runnable plan** → `expanding-prompts/`.
- **Tracking what is open or next** → `work-in-progress/`.
- **Recording what a session settled** → `session-logs/`.
- **Implementing** → the module the code belongs to.

If two folders seem right, choose the one whose README you would update first. If still unsure, write a one-line note in `work-in-progress/TASKS.md` open questions and place the file where a future reader will look first.

---

## Season placements and the log

The placements for any given season are recorded in `session-logs/` — what moved, what stayed, what was confirmed without churn. The durable test above outlives any snapshot list. When this season placed the seven distilled essays, the weave, the foundation briefs, and the civic visions in `foundations/`, and the Linengrow pieces in `linengrow/`, that record lives in the logs, not here, so this guide does not pretend to be a catalog that expires.

---

## The One Clock

Every dated artifact names itself `YYYYMMDD-HHMMSS_short-slug.md`. Later is always larger. Living documents (`README.md`, `ROADMAP.md`, `TASKS.md`, the discipline files) carry **Last updated** and evolve in place. Full law: `context/specs/20260627-102012_one-clock-naming-law.md`.

---

## Sort as Priority: the `yonder/` Horizon

A folder's own alphabetical order carries its priority, so the listing itself shows what matters now. Presently active implementation — the specs, prompts, and strategies driving an SLC or a working product in progress — rests one level deep, where date-stamped names surface the recent first. Deferred yet alive work rests one level deeper, in a **`yonder/`** whose name sorts toward the bottom and points ahead: dormant strategies, horizon ideas, research whose module has since been built, prompts already consumed whose ideas still beckon.

Three tiers, each with a clear purpose:

- **Active** (one level deep) — what we are engaged with now.
- **`yonder/`** (two levels deep) — points *forward*; kept because the idea is alive and may return.
- **`archive/`** (two levels deep) — points *backward*; done or superseded, kept only for the honest record.

The distinction matters: `yonder/` is a horizon, not a graveyard. A truly finished or dead file goes to `archive/` rather than `yonder/`.

**The active test:** a document stays one level deep while it drives present implementation; it moves to `yonder/` when it becomes future, dormant, consumed, or realized-as-code. Move by `git mv` so history stays whole, and update any reference that points at the old path.

**Age is a hint, not the test.** What sends a file to `yonder/` is that it has become future, dormant, consumed, or realized-as-code — never its stamp alone. A document that is foundational to the design, or that is actively cited by other living files, stays where it is however old it reads. Relevance and inbound references outrank the date.

**Affirming a kept file does four small things in one touch:** strip its dead `NNN ·` number prefix (the timestamp filename is the true name now), re-date its `Last updated`, add the reviewed-and-kept line, and lightly freshen the Radiant voice where it has drifted. No rename, no reference change. Vibrancy rides on this touch and on writing Radiant by default — never on a sweeping restyle.

**Titles.** A title carries no legacy `NNN ·` number prefix; the timestamp filename is the identifier. The H1 leads with the concept its filename slug names, so file and title cohere at a glance, in the Radiant `Name — clause` form. Living documents use their plain spoken name as the H1.

**Affirm-in-place titling:** when affirming, also strip the number prefix and align the H1 with the slug's concept — all in the same touch, still with no rename and no reference change.

A re-stamp that bubbles a file to the bottom suits an *ordinary, lightly-cited* document, where the sort cue helps and the few references are cheap to move. A *canonical reference* — one many files cite — keeps its stable name and is affirmed in place: its `Last updated` and a short affirmation line carry the signal, and its citation density already tells anyone it is load-bearing. Renaming what a hundred files depend on, to gain a sort cue nobody needed, trades a real promise for a small convenience.

### Reviewed and kept (`2026-06-29`)

| File | Why kept |
|------|----------|
| `active-designing/yonder/20260618-182412_single-stranded.md` | Foundational one-value-model brief; widely cited |
| `active-designing/yonder/20260618-184912_growing-a-language.md` | Canonical TAME Guidance organization brief |
| `active-designing/yonder/20260618-184912_recommended-architecture.md` | Foundational clean-room architecture brief; third of the trio |
| `work-in-progress/20260620-212126_usize-width-baseline.md` | Canonical width inventory; cited from `TAME_GUIDANCE` |
| `expanding-prompts/20260620-210812_explicit-width-audit.md` | Width charter; heavily cited across strengthening docs |
| `external-research/20260618-180812_pond-foundation.md` | Pond lap foundation brief; cited; affirmed pass eight |

---

## The Identity Layer, and Tidy Days

The tree signs its work. The keeper's canonical fingerprints live in `context/PUBKEYS.md` (committed); a keeper may also place `PUBKEYS.md` at the repository root for local override. A fork begins from `PUBKEYS.template.md` and records its own four public lines, and `tools/identity_check.rish` proves the shape either way — template-only checkouts pass kindly, and when a pubkey file is present it must carry exactly two SSH and two OpenPGP fingerprints. The private halves never enter the tree.

Session logs keep the working day flat as **`.bron`** files and fold closed days beneath `session-logs/archive/YYYYMMDD/` (Markdown era fully folded; Bron days fold when that tool grows). **Preview** (read-only): `rishi/bin/rishi run tools/session_logs_archive_preview.rish`. **Fold** (mutate): `rishi/bin/rishi run tools/session_logs_archive.rish` — core logic in `tools/session_logs_archive.rye`; witness `tools/session_logs_archive_witness.rish`. Run fold on Kaeden's word. Living law: `.cursor/rules/session-logs.mdc` · `.claude/rules/session-logs.md`.

---

## Caretaking

- **Rename with history:** `git mv`, never silent rewrites.
- **Prune with care:** release what no longer serves; graduate finished work out of `work-in-progress/`.
- **Commit logs with work:** session logs ship in the same commit whenever possible.
- **Clean room:** study in `gratitude/` and `external-research/`; implement in our modules with our vocabulary.
- **Confirm before churn:** when a filing guide predates a folder that now exists, update the guide — do not move settled work to match an old plan.

---

*May each file rest with its own kind. May the guide stay true to the tree it describes. And may the next reader, agent or human, find exactly what they came for.*
