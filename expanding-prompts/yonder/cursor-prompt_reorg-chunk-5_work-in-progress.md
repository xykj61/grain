# Cursor Composer 2.5 Prompt — Reorg Chunk 5: `work-in-progress/`, Fully and Alone

**Paste this into a fresh Cursor Composer 2.5 agent.** It reorganizes one folder whole, on `reorg/one-clock`. Read it fully before running anything. Check before you change. Propose every rename and wait for Kaeden's word. Push only when Kaeden says.

---

## Environment — set this first, every run

```bash
export HOME=/home/xy
cd /home/xy/veganreyklah2
```

Two truths, true throughout:

- Only `/home/xy/veganreyklah2` persists across resets. Keep every change inside it.
- The jail reaches the forges over SSH; the `.ssh` keys and config live inside the project, so commits, fetches, and pushes all work from here. `HOME=/home/xy` is the jail's own default; we set it explicitly to start from a known shell.

Confirm footing and report — change nothing yet:

```bash
git branch --show-current        # expect reorg/one-clock
git status                        # expect clean
git log --oneline -6             # expect 4ec9426 (chunk 4) and the earlier reorg commits in view
ls active-designing/README.md external-research/TAME_STYLE.md expanding-prompts/README.md   # all must exist
```

Proceed only on `reorg/one-clock` with chunks 1–4 already landed. **If any of those READMEs is missing or `work-in-progress/` still shows only old numbered files elsewhere, you may be on `main` — stop and tell Kaeden.** Strengthening stays paused, so `main` holds still and the fast-forward is preserved.

---

## The shape of this folder, already surveyed

`work-in-progress/` is the workbench, and its own `999_WORK.md` describes the convention: it counts down from `999`, each stock-taking writes a new open-threads snapshot at the next number down, and superseded snapshots graduate into `archive/`. The reorg keeps that archive convention and replaces only the count-down with the clock.

It holds, at the top level, the foundation `999_WORK.md`, a living roadmap `996_roadmap.md`, the current snapshot `995_open_threads.md`, three real briefs (`992_usize_width_baseline.md`, `993_strengthening_width_crosswalk.md`, `994_style_audit.md`), and the reorg's own three rename-mapping files (`992`/`993`/`994` `*-rename-mapping.md`) — which collide on numbers with the real briefs, the very disease the reorg cures. Inside `archive/` sit two older snapshots, `997_open_threads.md` and `998_open_threads.md`. The allow-list already welcomes the whole tree (`.gitignore` carries `!/work-in-progress/`), so `archive/` needs no new entry.

---

## Step 1 — Propose the full mapping (change nothing; print for approval)

```bash
cd /home/xy/veganreyklah2/work-in-progress
git ls-files | sort
```

Build and print the complete old→new mapping for the top level and for `archive/`, the list of files to move into `archive/`, and any derived stamps with their source. Run no `git mv`, `git rm`, or file writes until Kaeden confirms. Search with `git grep` / `git ls-files`, never plain `grep -r`.

### The foundation

- `999_WORK.md` → `README.md` (living, no stamp). Carry its content forward, and **rewrite the "How It Counts" section for the clock**: stamps name dated artifacts, the reverse-chronological index gives the newest-first view, and superseded snapshots still graduate into `archive/`. Keep the "what belongs here / what does not" discipline intact.

### The living roadmap

- `996_roadmap.md` declares `**Status:** Living roadmap` and is the standing roadmap. → `ROADMAP.md` (living, no stamp), a name the naming law names outright. Do not stamp it.

### The open-threads snapshots (dated, archive convention preserved)

- `995_open_threads.md` (`**Version:** 20260623.033012`) → `20260623-033012_open-threads.md` — the current snapshot, stays live in the folder.
- `archive/998_open_threads.md` (`20260618.155212`) → `archive/20260618-155212_open-threads.md`
- `archive/997_open_threads.md` (`20260618.171512`) → `archive/20260618-171512_open-threads.md`

### The real briefs (no header stamp — derive from first-commit)

Each carries no `**Version:**`; derive the authored time from the first-add commit and note it as derived:

```bash
git log --diff-filter=A --follow --date=format:%Y%m%d-%H%M%S --format=%ad -- <file> | tail -1
```

- `992_usize_width_baseline.md` → `<derived>_usize-width-baseline.md`
- `993_strengthening_width_crosswalk.md` → `<derived>_strengthening-width-crosswalk.md`
- `994_style_audit.md` → `<derived>_style-audit.md`

### The reorg's own scaffolding — stamp and move into `archive/`

The three rename-mapping files are completed records of the reorg's own work; the folder's rule sends finished, superseded records into `archive/`, kept whole. Stamp each from its first-add commit (same command above) and `git mv` it into `archive/`:

- `994_session-log-rename-mapping.md` → `archive/<derived>_session-log-rename-mapping.md`
- `993_active-designing-rename-mapping.md` → `archive/<derived>_active-designing-rename-mapping.md`
- `992_external-research-rename-mapping.md` → `archive/<derived>_external-research-rename-mapping.md`

(There is no chunk-4 mapping file — that preview was print-only. Expect exactly these three.)

Print the full mapping, the archive moves, and every derived stamp with its first-add source.

---

## Step 2 — Apply (only after Kaeden confirms)

On Kaeden's word, apply with history-preserving renames and moves:

```bash
git mv "<old>" "<new>"        # every approved rename, including the archive moves
```

Then:

- Build `work-in-progress/README.md` as a **living document** (no stamp): the workbench purpose and the clock-aware "How It Counts," then a **reverse-chronological table, newest first** of the live dated artifacts (the current open-threads snapshot and the three briefs), with `ROADMAP.md` noted as the standing roadmap.
- Build `work-in-progress/archive/README.md` as a small **living index** of the archived lineage — the two open-threads snapshots and the three rename-mapping records, newest first, each a stamp, a title, and one line.
- Write this chunk's own mapping, as approved, into `archive/<STAMP>_work-in-progress-rename-mapping.md` (where `<STAMP>` is the exact time Kaeden supplies), so the full reorg audit trail rests together in `archive/` rather than as a fresh file on the live workbench.

---

## Step 3 — Link hygiene, repo-wide (show the diff first)

Renaming this folder dangles every reference to `work-in-progress/99x_*`, so updating those links is the honest repair even where they live in other folders — a dangling pointer is the worse harm.

```bash
git grep -n "work-in-progress/99" -- '*.md' '*.rye' '*.rish' '*.zig' '*.zon'
```

**One scope note, recommended as decided:** roughly thirty `strengthening-compiler/` pass-documents link to `work-in-progress/` numbers. Updating those is **link strings only — never the strengthening code, never pass 9886's work** — and it keeps nothing dangling, consistent with every prior chunk. Apply it, with the diff shown. *(If Kaeden would rather keep the paused `strengthening-compiler/` folder pristine and repair its links when that folder's own chunk runs, scope `strengthening-compiler/` out of this pass and leave those links for later — Kaeden's single call.)*

Rewrite live references to the new stamped names. **Skip `vendor/`.** Keep historical narration at its old names where a file *describes a past move* — session logs and the versioning transcript should not be falsified. Show Kaeden the diff before it commits.

---

## Step 4 — Confirm the allow-list still welcomes the folder

```bash
cd /home/xy/veganreyklah2
git check-ignore work-in-progress/README.md work-in-progress/archive/README.md || echo "tracked — good"
git status
```

`.gitignore` already welcomes `/work-in-progress/` and its `archive/` subtree. If anything new sits ignored, add it back by name.

---

## Step 5 — Commit the folder work in Radiant voice

```bash
git add -A
git commit -m "Reorganize work-in-progress under one clock.

Anchor the foundation to README and the roadmap to ROADMAP, stamp the open-threads snapshots and the live briefs from their times, and graduate the reorg's own rename-mapping records into archive where finished work belongs. Repo-wide links follow the renames; historical narration keeps its old names."
```

---

## Step 6 — Write a stamped session log of this chunk

Add `session-logs/<STAMP>_reorg-chunk-5-work-in-progress.md`, where `<STAMP>` is the exact time Kaeden supplies in `YYYYMMDD-HHMMSS` form, in the one-clock shape — no countdown prefix. Write it in Radiant voice: what this chunk settled (the workbench reconciled to the clock, the archive convention preserved, the reorg's own scaffolding gathered into archive), what waits next (`rye-learning-process/` as the last design folder, then `strengthening-compiler/` when the pause lifts), and a three-clause benediction. Prepend its newest-first row to `session-logs/README.md`, then commit it.

---

## Step 7 — Push, only on Kaeden's word

```bash
git push github reorg/one-clock                 # GitHub, works now
git push -u origin reorg/one-clock              # Codeberg, when status.codeberg.org is green
```

Never force-push. The branch merges to `main` later by ordinary fast-forward.

---

## Hold to these throughout

- **This folder only.** `work-in-progress/` (with its `archive/`) complete before any other folder opens — aparigraha at the folder level. The only reach outside it is repo-wide link hygiene, which serves correct references rather than new scope.
- **`main` stays still.** Strengthening is paused, so the fast-forward holds. Link hygiene may touch `strengthening-compiler/` link strings, yet never its strengthening work.
- **Every rename uses `git mv`** — history and blame carry forward intact, including the moves into `archive/`.
- **Finished scaffolding graduates to `archive/`** — the folder's own rule, applied to the reorg's own records.
- **Check before you change.** Print the full mapping, the archive moves, and the derived stamps, and wait for Kaeden's word before any `git mv`, `git rm`, or file write.
- **No force-push, ever.**

---

*May the workbench stay clear and the archive keep the lineage whole. May each open thread find its stamp, the roadmap rest in its living name, and the records of this very work graduate gently to where finished things belong. May the last folder wait on firm ground.*

---

*Written together by Kaeden and Reya 2.*
