# Cursor prompt — Infuse Linengrow, lay the task list, reorient the roadmap

**Goal:** Bring Linengrow into the project as the first whole built on Rye OS, lay down the granular living task list, and reorient the roadmap to name the two tracks and the one spine. Then push, and bring the settled batch home to `main` when ready.

Work in Radiant Style. Gate every phase propose-then-confirm. Kaeden is the sole developer and permits amend and force-push on his own branches. The authored files for this pass are provided alongside this prompt; place each at the path named, and confirm each by its first line.

---

## Step 0 — Footing

Confirm, then stop:

- Current branch is `design/foundations-and-kernel-horizon`, working tree clean, level with `github/design/foundations-and-kernel-horizon`.
- `work-in-progress/ROADMAP.md` and `work-in-progress/20260623-033012_open-threads.md` exist; `session-logs/` exists; `linengrow/` does **not** yet exist; `work-in-progress/TASKS.md` does **not** yet exist.

---

## Phase A — Infuse Linengrow

Create `linengrow/` and place its README and the two vision documents:

| File | First line |
|------|-----------|
| `linengrow/README.md` | `# Linengrow` |
| `linengrow/20260628-124512_linengrow-business-model.md` | `# Transparent Social Commerce — The Business Model` |
| `linengrow/20260628-124512_linengrow-venture-pitch.md` | `# Transparent Social Commerce — A Venture Pitch` |

The two vision documents are dated artifacts; keep their `20260628.124512` content stamp intact, and note that the slug becomes `linengrow-*` because the folder names the design. If `.gitignore` needs a `!/linengrow/` allow line to mirror the other tracked folders, add it. Commit:

```
linengrow: infuse the first whole built on Rye OS

The vision — business model and venture pitch — with a README binding
Linengrow to the Rye OS spine: keypair, signed event, log, projection,
capability. Trust by construction grown the SLC way, verifiable
receipts first.

Written together by Kaeden and Reya 2.
```

---

## Phase B — Lay the task list

Place the granular living task list:

| File | First line |
|------|-----------|
| `work-in-progress/TASKS.md` | `# Tasks — The Granular Plan` |

This file is **edited in place** — a living plan, not an accreting record. (If Kaeden prefers the warmer name `WORKBENCH.md`, rename on confirmation; the content is identical.) Commit:

```
work-in-progress: lay TASKS.md — the granular living plan

The what-now layer beside ROADMAP's why-and-order. Edited in place;
history accretes in session-logs. Now / Next / Soon / Later across the
Rye OS and Linengrow tracks, with open questions.

Written together by Kaeden and Reya 2.
```

---

## Phase C — Reorient the roadmap

`ROADMAP.md` keeps its shape. **Propose** two additions and one small edit, show the diffs, and wait for confirmation.

First, after the "The Vision" section, add a new section:

````markdown
## Two Tracks, One Spine

Rye OS is the system. **Linengrow** is the first whole built upon it — a transparent civic and social-commerce platform for vegan musicians and activist creators. The two share one architectural spine: state as a pure fold over an append-only log of immutable signed facts, and five primitives beneath everything — keypair, signed event, log, projection, capability.

Correctness by construction in the kernel becomes trust by construction in the platform. The same capability that isolates a process in Caravan names ownership in Linengrow; the same Mantra log that versions a file records a verifiable receipt; the same Comlink that seals a datagram delivers a signed transaction identity to identity. Rye OS grows the infrastructure rings; Linengrow grows its application rings on the same modules. The full Linengrow vision lives in [`../linengrow/`](../linengrow/); this roadmap grows it the SLC way, smallest lovable complete first. The granular plan for both tracks lives in [`TASKS.md`](TASKS.md).
````

Second, after "The Primary Track" section, add the Linengrow ladder:

````markdown
## The Linengrow Track — Trust by Construction

Grown from the same modules Rye OS is already building, smallest lovable complete first.

| Ring | What | Grows from |
|------|------|-----------|
| **SLC-L1** | A verifiable receipt — sign a transaction fact, append it to the log, produce a receipt anyone can verify | keypair + Mantra log + projection |
| **SLC-L2** | Sealed delivery — a signed receipt sent identity to identity, under seal | Comlink |
| **SLC-L3** | Settlement — a transaction settled on Sui with USDsui, verifiable on the ledger | Sui / Mysticeti |
| **Horizon** | The data market, premium tiers, state-currency circulation, the PBC and its rounds | the business model in `../linengrow/` |

The first ring needs no ledger and no currency — only the primitives Rye OS already grows.
````

Third, in "The Vision" paragraph, add Linengrow to the one-line module census as the flagship application (one clause, lightly woven — propose the exact wording).

Commit:

```
roadmap: name the two tracks and the one spine

Rye OS the system, Linengrow the first whole built on it, sharing the
append-only-signed-facts spine and the five primitives. Add the
Linengrow SLC ladder and point to TASKS.md and linengrow/.

Written together by Kaeden and Reya 2.
```

---

## Phase D — Open-threads hygiene (recommended, gated)

`20260623-033012_open-threads.md` has become a tall stack of "What Just Landed" entries — a progress history living in a planning file. **Propose** moving that accreted history to where history belongs: append the dated entries into the matching `session-logs/` (or, if cleaner, a single archival log under `session-logs/`), and slim `open-threads.md` to genuinely open threads — or retire it, since `TASKS.md` now carries open questions. Show the plan and wait for confirmation before moving anything. Preserve history with `git mv`/append, never destructive deletion. Commit with a Radiant message naming what moved where.

*(If you would rather leave open-threads untouched for now, skip this phase and say so.)*

---

## Phase E — Push, and bring the batch home

Push the branch:

```
git push github design/foundations-and-kernel-horizon
```

Then, **on Kaeden's confirmation**, bring the settled batch home to `main`. Most of this batch is additive and settled; the kernel direction rests as a recorded leaning, which is honest to merge. Propose the merge plan first — fast-forward if possible, otherwise a merge commit — then:

```
git switch main
git merge --ff-only design/foundations-and-kernel-horizon   # or a merge commit if main has moved
git push github main
```

Report the resulting `main` head. If `main` had diverged, show the divergence before merging and let Kaeden choose ff, merge commit, or rebase. Leave `design/foundations-and-kernel-horizon` in place afterward for any follow-on work.

---

*May Linengrow rest where the spine already reaches it. May the task list stay clear and the roadmap stay true. And may the whole batch come home to main as cleanly as it grew on the branch.*
