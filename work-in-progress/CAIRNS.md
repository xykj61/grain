# Cairns — the walk-back markers before every debride

**Language:** EN
**Status:** Living ledger — append-only
**Voice:** Kyri
**Rule:** [`../.claude/rules/cairn.md`](../.claude/rules/cairn.md) · [`../.cursor/rules/cairn.mdc`](../.cursor/rules/cairn.mdc)
**Kin:** **debride** removes; a **cairn** marks the way back before it does.

---

A **cairn** is a stacked-stone trail marker. In this tree it is one row recorded **before a seated debride sweeps a living card** — the git nib and the live stamp at that moment, plus one honest line naming what stood there. Where **remember** reprints the *current* card, a cairn pins the *departing* one, so a good idea folded into an old REMEMBER, THREADS, or work-in-progress file is never truly lost — it waits at a named commit, one `git show` away.

**How to walk back to a cairn:**

```
git show <nib>:work-in-progress/REMEMBER.md      # read the whole departing card
git show <nib>:work-in-progress/THREADS.md
git log --oneline <nib>                          # browse the tree as it stood
```

The nib is the HEAD **before** the debride's own commit — so the old files live at that commit and every commit before it.

---

## The ledger (newest first)

### `20260810.160511` — Expanding-prompts archive-fold (Option B, safe subset)

**Walk-back nib:** `663b778b38`
**Swept:** moved the **67 zero-inbound-reference** spent recursion-prompts and fusion-batons from `expanding-prompts/` (top level) into `expanding-prompts/archive/`. This is an **accrete-safe move, not a debride** — every byte stays in the tree and in git history; nothing is deleted. Only files with zero external citations moved, so no dated testimony's links break and no dated file is edited. The 169 still-referenced spent files stay in place (their citations are load-bearing history).
**What waits there, worth recalling:** the moved files are per-round recursion-prompts and closed-arc fusion-batons — spent working prompts, superseded by their rounds' landed work and session logs. Walk back with `git show 663b778b38:expanding-prompts/<name>` or read them at the new `archive/` path.

### `20260809.024851` — The Compass Season living-card debride

**Walk-back nib:** `bc90f7fdb0`
**Swept:** `work-in-progress/REMEMBER.md` (471 → ~75 lines), `THREADS.md`, `TASKS.md`, `ROADMAP.md` — all rewritten from the elder Equinox-season e-number ladder to the four-equinox Compass Season.
**What waits there, worth recalling:** the full e-number GREEN ladder (e7–e302), the Amphora CLI log (e140–e177), the twelve RESTED nested seasons with their pointers (Equinox · Fascia · Voice · Nona · Kiln · Surface · Generator · MUR · Inner Scope · Constellation · Keeh), the guide 0–2 walk detail, and the old Open-Doors GREEN table. Every green also stands in the code and in the dated counsel; this cairn is the fast path to the *shape* of the old cards.

### The Haunted Mound deep debride (recorded after the fact)

**Walk-back nib:** *not preserved on the branch* — this deep debride rewrote all 37,264 commits with `git-filter-repo` and force-pushed, so no pre-debride commit is reachable. **This is the lesson that seated the cairn pattern:** a deep debride that rewrites history must drop a cairn *first*, or the walk-back is gone. The tribute content itself was intentionally removed at Keaton's word; what a future cairn would have preserved is the surrounding season's card state, now readable only from local reflog if it survived (`git reflog` · dangling commits), not from the shared remotes.

---

*Leave a stone before you cut. The trail you mark today is the one you can walk back tomorrow.*
