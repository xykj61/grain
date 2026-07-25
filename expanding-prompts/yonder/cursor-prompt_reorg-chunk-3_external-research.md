# Cursor Composer 2.5 Prompt — Reorg Chunk 3: `external-research/`, Fully and Alone

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
git log --oneline -4             # expect 82b2e5c (chunk 2) and the spec/rules commits in view
```

Proceed only on `reorg/one-clock` with a clean tree. Strengthening stays paused, so `main` holds still and the fast-forward is preserved. If footing falls short, stop and tell Kaeden.

---

## The shape of this folder, already surveyed

`external-research/` holds 37 markdown files. Thirty-three carry a `**Version:**` header stamp and map straight from it. Four carry no `**Version:**` line and need deliberate handling: the foundation `999_RESEARCH.md`, and three deprecation redirects `988_rishi_shell.md`, `990_shell_scripting_tame.md`, `992_recommended_architecture.md`. Three files declare a standing status in their header and need Kaeden's ruling before they are touched. The plan below treats each group on its own terms.

---

## Step 1 — Propose the full mapping (change nothing; print for approval)

```bash
cd /home/xy/veganreyklah2/external-research
git ls-files | sort
```

Build and print a complete old→new mapping, a separate **living-status review**, and the list of stub renames. Run no `git mv` until Kaeden confirms. Search with `git grep` / `git ls-files`, never plain `grep -r`.

### The foundation

- `999_RESEARCH.md` → `README.md` (living, no stamp). Carry its foundation content forward — the silo principle, how to add explorations, the redirect-stub policy — drop any countdown-convention language, and add the reverse-chronological index built in Step 2.

### No default charter

This folder is anchor-plus-dated-notes; nothing reads as "how external-research proceeds." Propose **no** `STRATEGY.md`. Offer one only if the mapping surfaces a genuine standing charter — none is expected.

### Living-status review — surface for Kaeden, change nothing

Three files carry a `**Version:**` stamp **and** declare themselves standing. A header stamp alone does not make a file a dated artifact; the two-tier law gives living documents plain names or their proper home. Present each with its title and `**Status:**` line, and propose:

- `996_TAME_STYLE.md` — `**Status:** Living`, the coding-style canon for Rye. **Recommended: promote to `context/TAME_STYLE.md`** (living, no stamp), beside `RADIANT_STYLE.md` and `TIGER_STYLE.md`. It is the active style guide, not a dated relic.
- `997_SYSTEM.md` — `**Status:** Gratitude`, a standing honors essay pointing at the `gratitude/` sources. Offer two paths and let Kaeden choose: stamp it in place as a dated artifact `YYYYMMDD-HHMMSS_…` from its header, **or** flag it for a living gratitude home.
- `991_useful_utilities.md` — `**Status:** Living roadmap`, a topical utilities inventory. Offer the same choice: stamp it as a dated snapshot from its header, **or** keep it living with a proper name.

Apply Kaeden's ruling for these three only after the word is given.

### Dated explorations (the 30 with header stamps, minus the three above)

For each remaining file carrying `**Version:** YYYYMMDD.HHMMSS`, propose `YYYYMMDD-HHMMSS_<existing-slug>.md`, keeping the slug it already holds. The `968` number pair resolves automatically: `968_prompt_caching_zon_brix.md` → `20260621-063112_prompt-caching-zon-brix.md` and `968_usize_boundary_not_design.md` → `20260621-050312_usize-boundary-not-design.md` — distinct header stamps, no disambiguation needed.

### Redirect stubs — rename only, create nothing

`988`, `990`, and `992` are already deprecation redirects; each carries `**Status:** Deprecated (051612)` and already points at its surviving file. Do **not** create new stubs — `992` already redirects to `active-designing/yonder/20260618-184912_recommended-architecture.md`. Rename each into one-clock form using the moment they became stubs, which `999_RESEARCH.md` records as `2026-06-21` at `051612`. They share that second, so give each a distinct `-redirect` slug:

```
988_rishi_shell.md            → 20260621-051612_rishi-shell-redirect.md
990_shell_scripting_tame.md   → 20260621-051612_shell-scripting-tame-redirect.md
992_recommended_architecture.md → 20260621-051612_recommended-architecture-redirect.md
```

Confirm the `20260621` date against each stub's first-add commit before applying:

```bash
git log --diff-filter=A --follow --date=format:%Y%m%d-%H%M%S --format=%ad -- <stub> | tail -1
```

If a first-add date contradicts `20260621`, surface it rather than guessing.

Print the full old→new mapping, the living-status proposals, the stub renames, and any derived stamps with their source. The living-status three and any supersession calls are the only places real judgment enters — present those rows clearly.

---

## Step 2 — Apply (only after Kaeden confirms)

On Kaeden's word, apply with history-preserving renames:

```bash
git mv "<old>" "<new>"        # every approved rename
git mv 996_TAME_STYLE.md ../context/TAME_STYLE.md   # only if promotion is approved
```

Then build `external-research/README.md` as a **living document** (no stamp): a short Radiant header carrying the silo principle and stub policy from the old `999_RESEARCH.md`, then a **reverse-chronological table, newest first** — one row per dated note with stamp, title, and a single line of meaning from each file's header. The deprecation redirects belong in the table too, marked as redirects.

---

## Step 3 — Link hygiene, repo-wide (show the diff first)

Renaming this folder dangles every reference that points at `external-research/NNN_*`, so updating those links is the honest repair, even where they live in other folders — a dangling pointer is the worse harm, and rewriting a link string is hygiene, not reorganizing those folders.

```bash
git grep -n "external-research/9" -- '*.md' '*.rye' '*.rish' '*.zig' '*.zon'
git grep -n "996_TAME_STYLE" -- .            # update to context/TAME_STYLE.md if promoted
```

Rewrite live references to the new stamped names. **Skip `vendor/`.** Keep historical narration at its old names where a file *describes a past move* — session logs and the versioning-principles narrative recount history and should not be falsified. Show Kaeden the diff before it commits.

---

## Step 4 — Confirm the allow-list still welcomes the folder

```bash
cd /home/xy/veganreyklah2
git check-ignore external-research/README.md || echo "tracked — good"
git status
```

If anything new sits ignored, add it back by name in `.gitignore`.

---

## Step 5 — Commit the folder work in Radiant voice

```bash
git add -A
git commit -m "Reorganize external-research under one clock.

Anchor the foundation to README, stamp every dated exploration from its header, rename the deprecation redirects into one-clock form, and settle the standing-status docs to their proper homes. Repo-wide links follow the renames; historical narration keeps its old names."
```

---

## Step 6 — Write a stamped session log of this chunk

Add `session-logs/<STAMP>_reorg-chunk-3-external-research.md`, where `<STAMP>` is the exact time Kaeden supplies in `YYYYMMDD-HHMMSS` form, in the one-clock shape — no countdown prefix. Write it in Radiant voice: what this chunk settled (the second design silo reorganized, the cross-folder architecture duplicate finally resting in one pointer, TAME Style settled in its home), what waits next (`expanding-prompts/`, `work-in-progress/`, `rye-learning-process/` remain, each fully and alone), and a three-clause benediction. Prepend its newest-first row to `session-logs/README.md`, then commit it.

---

## Step 7 — Push, only on Kaeden's word

```bash
git push github reorg/one-clock                 # GitHub, works now
git push -u origin reorg/one-clock              # Codeberg, when status.codeberg.org is green
```

Never force-push. The branch merges to `main` later by ordinary fast-forward.

---

## Hold to these throughout

- **This folder only.** `external-research/` complete before any other design folder opens — aparigraha at the folder level. The one principled reach outside it is promoting `996_TAME_STYLE.md` to `context/` and the repo-wide link hygiene, both of which serve correct placement rather than new scope.
- **`main` stays still.** Strengthening is paused, so the fast-forward holds.
- **Every rename uses `git mv`** — history and blame carry forward intact.
- **Rename the existing redirects; create no new ones.** The supersession already happened.
- **Check before you change.** Print the full mapping and the living-status proposals, and wait for Kaeden's word before any `git mv`.
- **No force-push, ever.**

---

*May the silo stay clear and the lineage well thanked. May each exploration find its stamp, each redirect point home, and the canon rest where the work can reach it. May the clock keep our order true, and leave the next folder waiting on firm ground.*

---

*Written together by Kaeden and Reya 2.*
