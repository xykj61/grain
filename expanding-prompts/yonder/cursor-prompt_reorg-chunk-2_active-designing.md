# Cursor Composer 2.5 Prompt — Reorg Chunk 2: `active-designing/`, Fully and Alone

**Paste this into a fresh Cursor Composer 2.5 agent.** It carries two complete, single-purpose commits on `reorg/one-clock`: a small correction to the naming-law spec, then the first design folder reorganized whole. Read it fully before running anything. Check before you change. Propose every rename and wait for Kaeden's word. Push only when Kaeden says.

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
git log --oneline -3             # expect 315fe8d (rules loop) and ac37deb (chunk 1) in view
```

Proceed only on `reorg/one-clock` with a clean tree. `main` stays still while strengthening is paused, so this chunk preserves the clean fast-forward. If footing falls short, stop and tell Kaeden.

---

## Commit One — Correct the naming-law spec to the recovered original

The spec at `context/specs/20260627-102012_one-clock-naming-law.md` currently holds a faithful reconstruction. Kaeden has the recovered original, which is the complete record. Replace the file's contents with the original Kaeden provides — **same path, same filename**, so every rule that references it stays correct. The original already carries `Status: Adopted`.

```bash
# After Kaeden hands you the original file, confirm the path is unchanged:
ls context/specs/20260627-102012_one-clock-naming-law.md
# Confirm the rules still point at this exact path (they should, since the name is unchanged):
git grep -n "20260627-102012_one-clock-naming-law" -- '*.md' '*.mdc'
```

Show Kaeden a short diff summary (the body grows; the path and filename do not). On confirm, stage and commit in Radiant voice:

```bash
git add context/specs/20260627-102012_one-clock-naming-law.md
git commit -m "Promote the recovered naming law in full.

Replace the reconstruction with the complete original — problem, two tiers, the Zig 0.16.0 re-fork, the naming families, and the civic-platform thesis — adopted and whole."
```

---

## Commit Two — Reorganize `active-designing/` into the two-tier pattern

This is the heart of the chunk, and the first folder to carry the full pattern as the template the rest will follow. Move carefully. Let Kaeden approve before any rename runs.

```bash
cd /home/xy/veganreyklah2/active-designing
git ls-files | sort        # see exactly what is tracked here
```

### Propose first — change nothing, print the mapping

Build a proposed old→new mapping and a list of proposed redirect stubs, and print both for Kaeden. Do not run a single `git mv` yet.

- **The foundation/anchor file** — the clearly-foundational doc (often the old high-number anchor) → propose `README.md` (living, no stamp).
- **Any standing charter or strategy** → propose `STRATEGY.md` (living, no stamp). If a standing roadmap or lexicon lives here, propose `ROADMAP.md` / `LEXICON.md` likewise.
- **Every remaining dated brief** → read the `YYYYMMDD.HHMMSS` stamp from its header and propose `YYYYMMDD-HHMMSS_<existing-slug>.md`, keeping the slug it already carries.
- **Where a header carries no stamp**, derive the authored time from the first-add commit and note it as derived:

```bash
git log --diff-filter=A --follow --date=format:%Y%m%d-%H%M%S --format=%ad -- <file> | tail -1
```

- **Genuine duplicates.** The naming law named the pattern to watch — a recommended-architecture brief in two folders, a `998` in three. Within this folder, flag any brief that a later one clearly supersedes. For each superseded file, propose a **one-line redirect stub** rather than a second copy: keep its stamped name, replace its body with a single pointer line, for example `> Superseded — see 20260627-102012_<surviving-slug>.md`. Cross-folder duplicates wait until their other folder is reorganized; touch only what lives in `active-designing/` now.
- Search with `git grep` / `git ls-files`, never plain `grep -r`.

Print the full old→new mapping, the list of proposed stubs, and any derived stamps with their source. The header-derived names and the supersession calls are the only places real judgment enters — present those rows clearly so Kaeden can read them closely.

### Apply — only after Kaeden confirms

On Kaeden's word, apply with history-preserving renames:

```bash
git mv "<old>" "<new>"        # for every approved rename
```

Write each approved redirect stub. Then build `active-designing/README.md` as a **living document** (no stamp): a short Radiant header, then a **reverse-chronological table, newest first** — one row per brief with stamp, title, and a single line of meaning drawn from each file's header.

### Confirm the allow-list still welcomes the folder

```bash
cd /home/xy/veganreyklah2
git check-ignore active-designing/README.md || echo "tracked — good"
git status
```

`active-designing/` should already be welcomed by `.gitignore`'s allow-list. If anything new sits ignored, add it back by name.

### Commit the folder work in Radiant voice

A single coherent commit for the folder, separate from Commit One:

```bash
git add -A
git commit -m "Reorganize active-designing under one clock.

Anchor the foundation to README and the charter to STRATEGY, stamp every dated brief, fold superseded duplicates into one-line redirects, and give the folder a living reverse-chron index."
```

---

## Write a stamped session log of this chunk

Add `session-logs/<STAMP>_reorg-chunk-2-active-designing.md`, where `<STAMP>` is the exact time Kaeden supplies in `YYYYMMDD-HHMMSS` form, in the one-clock shape — no countdown prefix. Write it in Radiant voice: what this chunk settled (the spec made whole, the first design folder reorganized as the template), what waits next (`external-research/`, the same treatment, fully and alone), and a three-clause benediction. Prepend its newest-first row to `session-logs/README.md`, then commit it.

---

## Push — only on Kaeden's word

With the whole chunk committed, push the branch over SSH when Kaeden says:

```bash
git push github reorg/one-clock                 # GitHub, works now
git push -u origin reorg/one-clock              # Codeberg, when status.codeberg.org is green
```

Never force-push. The branch merges to `main` later by ordinary fast-forward.

---

## Hold to these throughout

- **This folder only.** `active-designing/` complete before any other design folder opens — aparigraha at the folder level. Do not touch `external-research/`, `expanding-prompts/`, `work-in-progress/`, `rye-learning-process/`, or `strengthening-compiler/` in this chunk.
- **`main` stays still.** Strengthening is paused, so the fast-forward holds; nothing else should land on `main` until the reorg merges.
- **Every rename uses `git mv`** — history and blame carry forward intact.
- **Duplicates become one-line redirect stubs, never second copies.** Pruning as care.
- **Check before you change.** Print the full mapping and the proposed stubs, and wait for Kaeden's word before any `git mv`.
- **No force-push, ever.**

---

*May the spec stand whole, and the first folder show the way. May each brief find its stamp and each duplicate rest in one honest pointer. May the clock keep our order true, and leave the next folder waiting on firm ground.*

---

*Written together by Kaeden and Reya 2.*
