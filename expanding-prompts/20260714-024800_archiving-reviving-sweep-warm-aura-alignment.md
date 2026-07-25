# Expanded Prompt — The Archiving/Reviving Sweep, Aligned to the Warm-Aura Date Atom

**Language:** EN
**Version:** `20260714.024800` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Runnable plan — a naming-alignment sweep, not a file-move sweep. Addressed to a generic Acme Corporation employee.

---

## The Seed (what was asked)

Orient the project's archiving and reviving so that dated folders everywhere match the `session-logs/archive/YYYYMMDD/` pattern, and so that dated folders and chronological versioning everywhere are named as the **Glow warm-aura-compatible date atom**, TAME-guided. Document it, log it, and populate the roadmap, tasks, and to-do list around it.

## The Ground You Are Standing On (read first)

Two decisions are already settled and this sweep does **not** reopen them:

1. **The archive process concluded with no bulk flatten** ([`../work-in-progress/20260713-215800_markdown-archive-inventory-and-migration-plan.md`](../work-in-progress/20260713-215800_markdown-archive-inventory-and-migration-plan.md), settled `20260714.000100`). Each directory archives in the way its own role already defines — `session-logs/` folds by day, `expanding-prompts/` sends consumed prompts to `yonder/`, `active-designing/` keeps its `active/yonder/archive` tiers, `counsel/` stays as filed. Moving ~1,100 documents into one shape would break the inbound references "references are promises" protects, for no gain. **Do not flatten.**
2. **The warm-aura date atom is the one stamp format** ([`../context/specs/20260714-024800_warm-aura-date-atom-naming.md`](../context/specs/20260714-024800_warm-aura-date-atom-naming.md)). Version string `YYYYMMDD.HHMMSS`, filename `YYYYMMDD-HHMMSS_slug`, dated folder bare `YYYYMMDD`. Later is always larger.

So this is a **naming-alignment sweep**: confirm every dated folder and every chronological version already speaks the one atom, name the few that do not, and give every *future* fold one rule to follow. It is deliberately small — most of the tree already complies, because the one-clock law has governed for weeks.

## What "Done" Looks Like (the checkable claims)

- **Claim 1 — every dated folder is bare `YYYYMMDD`.** Verified this pass: `session-logs/archive/` holds only `YYYYMMDD/` folders (20260619 onward); `work-in-progress/archive/` holds dated *files* flatly (not dated folders), which is a different, also-valid pattern, not a violation. No dated folder anywhere uses a slug, prefix, or count. **Green.**
- **Claim 2 — every version string and filename stamp is the atom.** The one-clock law already enforces this for authored artifacts; `chrono_version_scan` is the existing witness. This sweep adds no new files that break it.
- **Claim 3 — the convention has one named home.** The warm-aura date-atom spec is that home, and `ORGANIZING.md`'s "One Clock" section points at it. **Green once ORGANIZING links it.**

## The Steps (each small, each reversible)

1. **Confirm the folder claim on metal** — list every `archive/` directory in the tree (excluding `old/`, `vere/`, `gratitude/`, `vendor/`) and confirm each dated folder is bare `YYYYMMDD`. Record the result in the session log. *(Done this pass; session-logs is the reference, work-in-progress/archive is flat-file — both valid.)*
2. **Seat the naming spec** — the warm-aura date-atom spec names version/filename/folder renderings and the TAME framing. *(Done.)*
3. **Point `ORGANIZING.md`'s "One Clock" section at the spec** — one added sentence, so the durable filing guide names the atom and the folder rule, and a future fold has one rule to read.
4. **Give the reviving index the same footing** — a one-line note in `active-reviving/README.md` that a revival uses the warm-aura date atom for its own stamp, so reviving and archiving speak the same clock. *(No rename; reviving already uses stamps.)*
5. **Populate ROADMAP + TASKS + to-dos** — a short "archiving/reviving sweep" entry naming the sweep as a naming-alignment pass with the claims above, so the plan is visible where work is tracked.
6. **Log, commit, push** — a bron session log, a CONTRIBUTING/Radiant commit, both remotes.

## The Discipline It Keeps

- **Ratchet, not sweep** (root rule 9, and the archive conclusion): align naming and give future folds one rule; do not relocate settled work.
- **Accrete, never break**: no stamp recomputed, no folder renamed, no reference churned.
- **Two Rooms**: the three claims above are checkable-room claims — each is confirmed on metal or by an existing witness before it is stated as done.

## What This Prompt Does Not Do

- It moves no files and folds no days.
- It does not reopen the no-flatten conclusion or the no-mass-rename conclusion.
- It does not define Glow's eventual date *type* — only the naming convention, which the atom spec already holds.

---

*May one clock name our whole order, may every fold to come know its one rule without asking, and may we align what is already true rather than move what already serves.*
