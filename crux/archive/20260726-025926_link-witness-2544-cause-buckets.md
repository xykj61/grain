# Link-witness dangling cause buckets

**Language:** EN  
**Stamp:** `20260726.025926`  
**Voice:** Quin  
**Status:** Reading-only survey — Y · fix nothing  
**Ground:** counsel `20260726.025120` · ROUND MODE GREEN · snapshot via `LINK_WITNESS_SNAPSHOT`  
**Measured set:** **2374** unique dangling keys on this tree (counsel's earlier **2544** was the T0 count before unique-key normalization in ROUND MODE; both name the same debt)

## Method

Capture the sorted dangling set with `LINK_WITNESS_SNAPSHOT`, then classify each `source:href` by where the resolved target points and by rename/relocation signals. No links were edited.

## Ranked causes

| Rank | Count | Cause | One example |
|---:|---:|---|---|
| 1 | **1178** | Target under or via `archive/` (often `session-logs/archive/…` after fold; path written before or beside the move) | `active-designing/20260708-194500_slcl4-selective-disclosure.md` → `../session-logs/archive/20260706/20260706-232812_open-asks-lap4-reputation-fold.md` |
| 2 | **516** | Target under `active-designing/` missing at the written path | `context/TAME_GUIDANCE.md` → `../active-designing/20260721-170403_stoa179-seva-event-shape-desk.md` |
| 3 | **2150** overlap | Same basename exists elsewhere in the tree (relocation / yonder / archive without inbound re-point) — cross-cuts the rows above | `…/20260629-004912_slc-1-step-2-version.md` → `../expanding-prompts/20260629-004912_…` while file lives at `expanding-prompts/yonder/20260629-004912_…` |
| 4 | **180** | Outbound from `work-in-progress/` (incl. its archive) to a missing path | `work-in-progress/archive/20260724-132812_roadmap-season-ledger.md` → `../active-reviving/20260717-172832_…` |
| 5 | **178** | Other / unclassified (mixed depth errors, sibling-tree escapes) | `classical-vedic-astrology/readings/alice-sample-reading.md` → `../context/RADIANT_STYLE.md` (resolves under the astrology tree, not pier `context/`) |
| 6 | **64** | Target under `tools/` missing (often moved to `tools/fixtures/yonder/`) | `active-designing/20260630-030312_slc-2a-the-drawn-terminal.md` → `../tools/fixtures/pond_metal_close_preflight.sh` |
| 7 | **60** | Target under `linengrow/` missing | `active-designing/20260721-165342_stoa178-sala-b0-glow-thin-face.md` → `../linengrow/sala_b0_fold.rye` |
| 8 | **51** | Target under `context/specs/` missing | `active-designing/20260628-071012_slc-1-rishi-mantra-shell.md` → `../context/specs/20260629-031512_slc1-lap-closed-handoff.md` |
| 9 | **35** | Target under `counsel/` missing | `context/specs/20260707-021512_snapshot-export-lap1.md` → `../counsel/20260704-181612_zero-copy-resins-counsel-answers.md` |
| 10 | **29** | Target under or via `yonder/` | `active-designing/yonder/20260628-120912_brix-the-composer.md` → `../expanding-prompts/yonder/20260620-043812_tablecloth-brix-split.md` |
| 11 | **25** | Glow gen / `.glow` source missing | `active-designing/20260720-145814_stoa108-nest-type-tag-nest.md` → `../glow/gen/mold-kind.glow` |
| 12 | **24** | Target under `expanding-prompts/` missing at written path | `active-designing/20260629-004912_slc-1-step-2-version.md` → `../expanding-prompts/20260629-004912_cursor-pass-slc1-version-recall-and-tame.md` |
| 13 | **22** | Flat `session-logs/` path missing (file often under `session-logs/archive/YYYYMMDD/`) | `active-designing/20260710-234004_assist-sight-glass-composition-hammock.md` → `../session-logs/20260710-192018_assist-sight-composition-journal-plain.md` |
| 14 | **1** | Target under elder `old/` path | `CONTRIBUTING.md` → `old/urbit/CONTRIBUTING.md` |
| 15 | **0** | Target under elder `vere/` path (href text) | — none in this snapshot |

Rows 1–2 and 6–13 are a partition of the 2374 keys. Row 3 is a **cross-cut**: **2150** dangling keys have a same-basename file elsewhere — the dominant systematic shape is “moved without turning inbound refs,” not thousands of independent typos.

## Counsel suspects — tested

| Suspect | Finding |
|---|---|
| Links into untracked `old/` and `vere/` | **Almost absent** as href targets (1 × `old/`, 0 × `vere/`). Both directories exist on this host; the named `old/urbit/CONTRIBUTING.md` path does **not**. Elder trees are not the bulk of the 2374. |
| Links into `archive/` and `yonder/` written before those moves | **Confirmed bulk** — archive alone **1178**; yonder **29**; plus many “flat session-logs” that now live under archive. |
| Depth-relative paths broken by earlier relocations | **Present** in the unclassified bucket (wrong `../` depth; sibling-package escapes). |
| Module renames whose inbound refs were never turned | **Confirmed dominant** — basename-elsewhere **2150** / 2374. |

## What this report does not do

It does not fix links, lower the baseline, or change ROUND MODE. Reduction laps, if seated, would target the top buckets (archive re-points · active-designing moves · tools/fixtures yonder · linengrow), not a 2374-line chore list.
