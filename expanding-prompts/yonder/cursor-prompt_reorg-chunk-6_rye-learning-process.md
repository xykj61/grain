# Cursor Composer 2.5 Prompt — Reorg Chunk 6: `rye-learning-process/`, the Last Design Folder

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
git log --oneline -6             # expect 469cfa3 (chunk 5) and the earlier reorg commits in view
ls active-designing/README.md external-research/TAME_STYLE.md expanding-prompts/README.md work-in-progress/README.md   # all must exist
```

Proceed only on `reorg/one-clock` with chunks 1–5 already landed. **If any of those READMEs is missing, you may be on `main` — stop and tell Kaeden.** Strengthening stays paused, so `main` holds still and the fast-forward is preserved.

---

## The shape of this folder, already surveyed

`rye-learning-process/` is the builder's workshop, and it holds exactly two files: the foundation `999_RYE.md` and `998_ALMANAC.md`. No dated findings have accrued yet — the foundation's convention reserves the descending numbers for future findings, of which there are none. Both files are living documents, so this pass has no stamps, no collisions, no stubs, and no archive. It is the lightest chunk.

---

## Step 1 — Propose the mapping (change nothing; print for approval)

```bash
cd /home/xy/veganreyklah2/rye-learning-process
git ls-files | sort
```

Print the proposed mapping. Run no `git mv` until Kaeden confirms.

| Old | New | Why |
|-----|-----|-----|
| `999_RYE.md` | `README.md` | Foundation (living). Rewrite "The Counting-Down Convention" for the clock. |
| `998_ALMANAC.md` | `ALMANAC.md` | `**Status:** Living` — a growing reference, not a dated note. No stamp. |

Both are living documents taking plain names; neither takes a stamp. There are no dated artifacts to map.

---

## Step 2 — Apply (only after Kaeden confirms)

On Kaeden's word, apply with history-preserving renames:

```bash
git mv 999_RYE.md README.md
git mv 998_ALMANAC.md ALMANAC.md
```

Then edit `README.md` (the former foundation) so it reads true under the clock:

- Replace the "The Counting-Down Convention" section with a clock-aware one: future findings are dated artifacts named `YYYYMMDD-HHMMSS_<slug>.md`, ascending and self-dating, with the newest surfaced by a reverse-chronological index here; the **almanac remains the living aggregate** those findings feed, revised in place.
- Add a short **reverse-chronological index** section. It currently lists the living documents — `ALMANAC.md` as the growing reference — and notes that dated findings will appear here as they are recorded, newest first. (No dated rows exist yet.)
- Keep the "What This Folder Is," "What Sets It Apart," and "How To Add a Finding" prose intact, adjusting only the wording that assumed descending numbers.

Leave `ALMANAC.md`'s body unchanged except for any self-reference to its own old `998_` name.

---

## Step 3 — Link hygiene, repo-wide (show the diff first)

Renaming these two files dangles references to `rye-learning-process/999_RYE.md` and `rye-learning-process/998_ALMANAC.md`. Update the live ones; leave historical narration honest.

```bash
git grep -n "rye-learning-process/99" -- '*.md' '*.rye' '*.rish' '*.zig' '*.zon'
```

Expect a small set. **Update the live references** — the almanac-sync redirect stub in `expanding-prompts/`, and `rishi/README.md` and `rye/README.md` — rewriting `998_ALMANAC.md` → `ALMANAC.md` and `999_RYE.md` → `README.md`. **Keep historical narration at its old names** where a file *describes a past move* — the `session-logs/` entries that mention these files recount history and should not be falsified. **Skip `vendor/`.** Show Kaeden the diff before it commits.

---

## Step 4 — Confirm the allow-list still welcomes the folder

```bash
cd /home/xy/veganreyklah2
git check-ignore rye-learning-process/README.md || echo "tracked — good"
git status
```

If anything new sits ignored, add it back by name in `.gitignore`.

---

## Step 5 — Commit the folder work in Radiant voice

```bash
git add -A
git commit -m "Reorganize rye-learning-process under one clock.

Anchor the foundation to README and keep the almanac living as ALMANAC, with the counting convention rewritten so future findings take stamps. Live links follow the renames; historical narration keeps its old names. The design surface now rests fully under one clock."
```

---

## Step 6 — Write a stamped session log of this chunk

Add `session-logs/<STAMP>_reorg-chunk-6-rye-learning-process.md`, where `<STAMP>` is the exact time Kaeden supplies in `YYYYMMDD-HHMMSS` form, in the one-clock shape — no countdown prefix. Write it in Radiant voice: what this chunk settled (the last design folder reconciled, the almanac kept living), that the design surface is now wholly under one clock, and what remains (`strengthening-compiler/`, waiting on pass 9886, with the merge-timing choice — fast-forward now and reorganize that folder later, or hold the merge until it joins the same pass). Close with a three-clause benediction. Prepend its newest-first row to `session-logs/README.md`, then commit it.

---

## Step 7 — Push, only on Kaeden's word

```bash
git push github reorg/one-clock                 # GitHub, works now
git push -u origin reorg/one-clock              # Codeberg, when status.codeberg.org is green
```

Never force-push. The branch merges to `main` later by ordinary fast-forward.

---

## Hold to these throughout

- **This folder only.** `rye-learning-process/` complete; the only reach outside it is the small repo-wide link hygiene.
- **`main` stays still.** Strengthening is paused, so the fast-forward holds.
- **Both files are living** — plain names, no stamps. There is nothing dated to stamp in this folder yet.
- **Every rename uses `git mv`** — history and blame carry forward intact.
- **Check before you change.** Print the mapping and the link-hygiene diff, and wait for Kaeden's word before any `git mv`.
- **No force-push, ever.**

---

*May the workshop keep its hard-won lessons, and the almanac grow on as Rye grows. May the last design folder come to rest under the one clock, and the whole surface read true at a glance. May the next builder find the path already lit.*

---

*Written together by Kaeden and Reya 2.*
