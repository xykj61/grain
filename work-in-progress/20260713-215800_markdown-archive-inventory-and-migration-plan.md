# Markdown Archive — Full Inventory and a Migration Plan (No Files Moved Yet)

**Language:** EN
**Version:** `20260713.215800`
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Plan — inventory only; zero files moved by this document

---

## What Kaeden Asked, and the Tension This Inventory Surfaces

Kaeden asked to archive essentially every project markdown file into a structure matching `session-logs/`'s own organization (living files at the top, historical files folded under `archive/YYYYMMDD/`), accepting the reference-repointing cost. Before proposing batches, this document names something the inventory itself makes plain: **[`ORGANIZING.md`](../ORGANIZING.md) already gives nearly every top-level directory its own deliberate role**, not just a chronological one — `counsel/` is explicitly "propose-never-seat" (a different epistemic status than a settled decision), `active-designing/` is "design in motion," `external-research/` is "study of the world with attribution," `docs/` is "a compression layer... pages compress the record; they never replace it." Flattening all of these into one session-logs-style archive would erase the distinction between *a proposal*, *a settled spec*, *a research memo*, and *a compressed summary* — a distinction this project's own docs-compression-layer design (`active-designing/20260712-221600_docs-compression-layer-design.md`) was built specifically to preserve.

**This document's recommendation, named plainly:** honor Kaeden's actual goal — nothing genuinely finished should sit cluttering a directory meant for *live* work — by extending the archival pattern **each directory already has**, rather than replacing all of them with one generic shape. `work-in-progress/` already "graduates" finished scaffolding to its own `archive/`; `session-logs/` already folds by day under `archive/YYYYMMDD/`. The gap this inventory closes is that **not every directory has an `archive/` yet**, and the ones that do have not been swept recently. That is a real, boundable piece of work; discarding `ORGANIZING.md`'s own categories is not something this document recommends, and Kaeden's word is needed either way before the broader version proceeds.

---

## Full Inventory, by Directory (excluding `old/`, `vere/`, `gratitude/`, `vendor/` — none of those are this project's own authored history)

| Directory | `.md` count | Current archive pattern (per `ORGANIZING.md`) | Recommended treatment |
|---|---|---|---|
| **`session-logs/`** | 1,105 | Already folds by day under `archive/YYYYMMDD/`; Markdown era already fully folded per the session-logs rule (`"Markdown era fully folded 20260712.120007"`) | **No change** — already exactly the target shape Kaeden described; this directory is the model, not a target |
| **`expanding-prompts/`** | 130 | Counts upward from `10000`; no stated archive subfolder | Needs its own `archive/` for prompts whose plan has fully executed — a real, previously-missing gap |
| **`external-research/`** | 123 | Living README, no archive subfolder named | Only research memos superseded by a later memo on the same question are archive candidates — most external-research here is still-current attribution/study, not "old" |
| **`strengthening-compiler/`** | 114 | "Analysis complete; record, not active product track" — already stated as closed-but-kept | **No change recommended** — this is already a deliberate closed record, not clutter; moving it would contradict its own stated status |
| **`active-designing/`** | 114 | Has a `yonder/` (forward-pointing, deferred-but-alive) and presumably an `archive/`-adjacent pattern per the collaboration rule ("Active work rests one level deep; deferred yet alive work moves to `yonder/`... finished-and-historical work moves to `archive/`") | Already has the exact three-tier shape (`active` / `yonder` / `archive`) this whole exercise is trying to generalize — worth studying as the reference pattern before extending it elsewhere |
| **`classical-vedic-astrology/`** | 90 | Siloed study library (`studies/`, `templates/`, `readings/`) — a different, non-chronological organizing principle entirely | **Explicitly out of scope** — this is reference material organized by topic, not by age; forcing a chronological archive shape here would make it harder to use, not easier |
| **`counsel/`** | 58 | "Propose-never-seat... each piece stays as filed" — explicitly meant to remain exactly as written, forever, as a record of what was asked and answered | **No change** — archiving here would violate the directory's own stated purpose |
| **`context/`** | 53 | Compass and specs — "plain-English decisions that deserve a durable home" | **No change** — these are the durable, load-bearing decisions; not archive candidates by nature |
| **`work-in-progress/`** | 33 | Already has its own `archive/` (seen directly this session: `20260628-*` files already folded there) | Already working as designed; a fresh sweep could catch anything that has quietly gone stale since the last fold |
| **`foundations/`** | 26 | "Dated artifacts rest beneath a living README" — its own stated shape | **No change** — already has a stated, working pattern |
| **`.claude/`** | 9 | Rule files, living | **No change** — these are the rules themselves, not historical record |
| **`tools/`, `scribble/`, `manual/`, `docs/`, `linengrow/`, `rye-learning-process/`, `granary/`, and the eleven single-`.md`-file module homes** | 1-7 each | Each is a module `README.md` or small fixture set | **No change** — too small to need an archive tier, and each `README.md` is a live, load-bearing entry point |

**Root-level singles** (`SOURCE.md`, `PUBKEYS.template.md`, `ORGANIZING.md`, `CLAUDE.md`) — explicitly named in `ORGANIZING.md` as "a few allow-listed files that orient newcomers before they dive." **No change.**

---

## What a Real, Bounded First Migration Batch Looks Like

Given the finding above, the actual gap is narrow: **`expanding-prompts/`** is the one directory with real candidates (fully-executed prompts, no longer live plans) and no archive subfolder yet. A first, small, reviewable batch:

1. Grep every `expanding-prompts/*.md` for whether its own status line or a citing session log marks it "done"/"landed"/"complete."
2. Create `expanding-prompts/archive/` (the one genuinely missing piece in this whole inventory).
3. Move only the confirmed-complete prompts there, repointing every inbound reference (this project's own "References are promises" rule) — likely a small number, given prompts are typically cited once, near their own execution.
4. Update `expanding-prompts/README.md`'s index to point at the new locations.

This is one Urbit-grants-sized PR: one directory, one new subfolder, a bounded and countable set of files, every reference repointed and verified.

## What This Document Does Not Do

- It does not move a single file.
- It does not recommend the broad "everything into one archive shape" version Kaeden originally described, because the inventory itself shows most directories already have a deliberate, working, *different* shape that predates this request and that a blanket move would erase.
- It leaves the actual decision — proceed with the narrow `expanding-prompts/` batch, or insist on the broader flatten despite the tension named above — to Kaeden.

---

## Conclusion — the archive process, settled `20260714.000100` (Pacific)

On review with Keaton, the archive process **concludes with the conventions the tree already keeps**, and makes no bulk pre-today move:

- **`session-logs/`** already folds closed days under `archive/YYYYMMDD/` (20260619 onward, folded). Working as designed.
- **`expanding-prompts/`** already sends consumed prompts to `yonder/` — 73 of them there today. That *is* this directory's archive, under its own name; it needs no separate `archive/`.
- **`active-designing/`** keeps its three-tier `active / yonder / archive` shape; **`counsel/`** stays "as filed" by its own law; **`context/`, `foundations/`, `strengthening-compiler/`** keep their deliberate roles.
- **No blanket flatten.** Moving the ~1,100 pre-today documents into one shape would break the inbound references that "references are promises" protects, for no gain the per-directory conventions do not already provide.

The archive process is therefore **complete** in the only form that does not damage the tree: each directory archives in its own established way, and the whole is held together by the naming-transition and new-journey markers rather than by relocation. Any future narrowing (a specific stale file to `yonder/`) is an on-touch move, not a sweep.

---

*May the tree keep the shape that already serves it, and may we archive only what has truly gone quiet, never what still has a role to play.*
