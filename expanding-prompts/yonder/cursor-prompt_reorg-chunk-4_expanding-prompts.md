# Cursor Composer 2.5 Prompt — Reorg Chunk 4: `expanding-prompts/`, Fully and Alone

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
git log --oneline -5             # expect 6bed1c6 (chunk 3) and the earlier reorg commits in view
ls active-designing/README.md external-research/TAME_STYLE.md   # both must exist
```

Proceed only on `reorg/one-clock` with chunks 1–3 already landed. **If `active-designing/` or `external-research/` still show old numbered files, you are on `main` — stop and tell Kaeden.** Strengthening stays paused, so `main` holds still and the fast-forward is preserved.

---

## The shape of this folder, already surveyed

`expanding-prompts/` holds 27 markdown files: the foundation `9999_EXPANDING.md`, twenty-three dated briefs, one reserved-number marker `10010_reserved.md`, and three redirect stubs `10013`, `10015`, `10025`. It is the one folder that counted *up* from `10000`, so its stamps largely confirm the existing order — yet the tail re-sorts to true authoring time, and that is honest, not a problem. There is no standing charter; propose no `STRATEGY.md`.

---

## Step 1 — Propose the full mapping (change nothing; print for approval)

```bash
cd /home/xy/veganreyklah2/expanding-prompts
git ls-files | sort
```

Build and print a complete old→new mapping, the `10010` resolution, the collision note, and the stub renames. Run no `git mv` until Kaeden confirms. Search with `git grep` / `git ls-files`, never plain `grep -r`.

### The foundation

- `9999_EXPANDING.md` → `README.md` (living, no stamp). Carry its content forward, including its **"Redirects and retired patterns"** section, drop any count-up convention language, and add the reverse-chronological index built in Step 2.

### The dated briefs (23 with header stamps)

For each brief carrying `**Version:** YYYYMMDD.HHMMSS`, propose `YYYYMMDD-HHMMSS_<existing-slug>.md`, keeping the slug it already holds. The head (`10000`–`10017`) is monotonic and simply confirms order. The tail re-sorts to true authoring time — surface this plainly so Kaeden sees it is the law correcting a small mis-numbering, not a flip:

- **Tablecloth cluster** by stamp becomes split → build → ladder-index → value-model → v1-seed:
  - `10018_tablecloth_ladder_index.md` → `20260620-044012_tablecloth-ladder-index.md`
  - `10019_tablecloth_brix_split.md` → `20260620-043812_tablecloth-brix-split.md`
  - `10020_tablecloth_brix_build.md` → `20260620-043912_tablecloth-brix-build.md`
  - `10021_tablecloth_value_model.md` → `20260620-044012_tablecloth-value-model.md`
  - `10022_tablecloth_v1_seed.md` → `20260620-044112_tablecloth-v1-seed.md`
- **Collision:** `10018` and `10021` share `20260620-044012`; the distinct slugs above resolve it. No other action.
- **Inversion:** `10024_explicit_width_audit.md` (`20260620-210812`) sorts *before* `10023_main_track_rye_rishi_strengthening.md` (`20260621-051612`). Both map straight from their headers; the order simply corrects.

### The reserved-number marker — retire it into the README

`10010_reserved.md` declares `**Status:** Number held open (051612)`. A held-open *number* has no meaning once stamps replace numbers, so this file's reason to exist dissolves — and git history preserves it whole for anyone who ever wants the record. Retire it: fold its still-useful cross-folder routing into the new `README.md`'s "Redirects and retired patterns" section, translating the old numbers it cites to their current stamped names, then remove the file:

```bash
git rm 10010_reserved.md
```

Print the routing you intend to fold before removing, so Kaeden can confirm nothing useful is lost.

### The redirect stubs (rename only, create nothing)

`10013`, `10015`, `10025` each declare `Executed (…) · stub (051612)` and already point at where the work landed. Rename each into one-clock form using the stub-event moment, distinct `-redirect` slugs:

```
10013_what_we_mean_by_seed.md            → 20260621-051612_what-we-mean-by-seed-redirect.md
10015_documentation_and_almanac_sync.md  → 20260621-051612_documentation-and-almanac-sync-redirect.md
10025_strengthening_stdlib_doc_width_pass.md → 20260621-051612_strengthening-stdlib-doc-width-pass-redirect.md
```

Confirm the `20260621` date against each stub's first-add commit before applying; surface any contradiction rather than guessing:

```bash
git log --diff-filter=A --follow --date=format:%Y%m%d-%H%M%S --format=%ad -- <stub> | tail -1
```

Note that `9999`, `10023`, and the three stubs all carry the `051612` second — distinct slugs (and the README, which takes no stamp) keep them all unique.

Print the full old→new mapping, the `10010` routing to be folded, the collision and inversion notes, the stub renames, and any derived stamps with their source.

---

## Step 2 — Apply (only after Kaeden confirms)

On Kaeden's word, apply with history-preserving renames:

```bash
git mv "<old>" "<new>"        # every approved rename
```

Then build `expanding-prompts/README.md` as a **living document** (no stamp): a short Radiant header carrying the anchor's purpose and its "Redirects and retired patterns" section, then a **reverse-chronological table, newest first** — one row per dated brief with stamp, title, and a single line of meaning. Include the three redirect renames in the table, marked as redirects. Apply the `10010` ruling.

---

## Step 3 — Link hygiene, repo-wide (show the diff first)

Renaming this folder dangles every reference to `expanding-prompts/9999_*` and `expanding-prompts/100*`, so updating those links is the honest repair even where they live in other folders — a dangling pointer is the worse harm, and rewriting a link is hygiene, not reorganizing those folders.

```bash
git grep -n "expanding-prompts/9999\|expanding-prompts/100" -- '*.md' '*.rye' '*.rish' '*.zig' '*.zon'
```

Additionally, **re-verify this folder's own outbound links.** Several briefs here point at `active-designing/` and `external-research/` targets that chunks 2–3 already renamed; the repo-wide passes most likely caught them, yet confirm none still point at a retired `9xx_` name:

```bash
git grep -n "active-designing/9\|external-research/9" -- 'expanding-prompts/*.md'
```

Rewrite live references to the new stamped names. **Skip `vendor/`.** Keep historical narration at its old names where a file *describes a past move* — session logs and the versioning transcript should not be falsified. Show Kaeden the diff before it commits.

---

## Step 4 — Confirm the allow-list still welcomes the folder

```bash
cd /home/xy/veganreyklah2
git check-ignore expanding-prompts/README.md || echo "tracked — good"
git status
```

If anything new sits ignored, add it back by name in `.gitignore`.

---

## Step 5 — Commit the folder work in Radiant voice

```bash
git add -A
git commit -m "Reorganize expanding-prompts under one clock.

Anchor the foundation to README, stamp every dated brief from its header, let the tail re-sort to true authoring time, rename the redirect stubs into one-clock form, and retire the held-open number into the index. Repo-wide links follow the renames; historical narration keeps its old names."
```

---

## Step 6 — Write a stamped session log of this chunk

Add `session-logs/<STAMP>_reorg-chunk-4-expanding-prompts.md`, where `<STAMP>` is the exact time Kaeden supplies in `YYYYMMDD-HHMMSS` form, in the one-clock shape — no countdown prefix. Write it in Radiant voice: what this chunk settled (the count-up folder reconciled to the clock, the tail re-sorted honestly, the held-open number released), what waits next (`work-in-progress/` and `rye-learning-process/`, each fully and alone, then `strengthening-compiler/` when the pause lifts), and a three-clause benediction. Prepend its newest-first row to `session-logs/README.md`, then commit it.

---

## Step 7 — Push, only on Kaeden's word

```bash
git push github reorg/one-clock                 # GitHub, works now
git push -u origin reorg/one-clock              # Codeberg, when status.codeberg.org is green
```

Never force-push. The branch merges to `main` later by ordinary fast-forward.

---

## Hold to these throughout

- **This folder only.** `expanding-prompts/` complete before any other folder opens — aparigraha at the folder level. The only reach outside it is repo-wide link hygiene, which serves correct references rather than new scope.
- **`main` stays still.** Strengthening is paused, so the fast-forward holds.
- **Every rename uses `git mv`** — history and blame carry forward intact.
- **Rename the existing redirects; create no new ones.** The supersession already happened.
- **Check before you change.** Print the full mapping, the routing to be folded from `10010`, and the collision and inversion notes, and wait for Kaeden's word before any `git mv` or `git rm`.
- **No force-push, ever.**

---

*May the clock confirm what the count had right, and gently correct what it did not. May each brief find its true place in time, each redirect point home, and the held-open number rest now that the order needs no holding. May the next folder wait on firm ground.*

---

*Written together by Kaeden and Reya 2.*
