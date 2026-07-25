# Cursor prompt — Foundations, Brix, and the Kernel-Direction batch

**Goal:** Open a working branch and place this batch on it — six foundation writings, the Brix composer brief, and the batch brief — each phase its own Radiant commit, the branch pushed at the end. Pure addition and one new folder; no renames, no code changes.

Work in Radiant Style. Gate every phase propose-then-confirm. Kaeden is the sole developer and permits `git commit --amend` and force-push to his own branches, so favor clean history over ceremony.

The authored files for this batch are provided alongside this prompt (in the same handoff): the two new briefs, and the six writings. Place each at the path named below; confirm each by its first line.

---

## Step 0 — Footing and branch

Confirm, then stop:

- Current branch is `main`, working tree clean, level with `github/main`.
- Create and switch to a working branch: `git switch -c design/foundations-and-kernel-horizon`.
- Confirm `gratitude/` and `gratitude/README.md` exist, `active-designing/` and `expanding-prompts/` exist, and that `foundations/` does **not** yet exist.

---

## Phase A — The gratitude syntheses

Place these two own-voice syntheses in `gratitude/`, beside `Systemantics.md`:

| File | First line |
|------|-----------|
| `gratitude/DevotionAndCreativeFreedom.md` | `# Devotion and Creative Freedom` |
| `gratitude/PathWithHeart.md` | `# The Path With Heart` |

Then **propose** an addition to `gratitude/README.md` — two entries under "What Lives Here," in the same shape as the surrounding ones, and bump "Last updated" to `2026-06-28`:

- **`DevotionAndCreativeFreedom.md`** — our own-voice synthesis in thanks to the devotional path of *bhakti* (the Bhagavata Purana) and to Nikolai Berdyaev's philosophy of creative freedom. Work as offering, freedom *for* something, the living gap between dream and reality. Honored in summary, not quoted.
- **`PathWithHeart.md`** — our own-voice principles summary in thanks to the warrior-philosophy of the path with heart (Carlos Castaneda's Don Juan series): choose the path with heart, keep your power gathered, act without waste. Held in summary, as we hold `Systemantics.md`, since the source is copyrighted.

Show the diff, confirm, then commit:

```
gratitude: welcome two own-voice syntheses — devotion and the path with heart

Devotion and Creative Freedom (bhakti + Berdyaev) and The Path With
Heart (the warrior's way), in our own words, beside Systemantics.

Written together by Kaeden and Reya 2.
```

---

## Phase B — The foundations folder

Create `foundations/` with a README, then place the four writings.

First write `foundations/README.md` with this content (a permanent folder README: plain header, no co-author line):

````markdown
# Foundations

**Language:** EN
**Last updated:** 2026-06-28
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)

---

This folder holds the why beneath the work — the reasons the building means something, at two scales. The foundation briefs name why the daily craft is an offering and a service. The vision documents name the larger civic horizon the work ultimately serves.

These rest beneath the specifications. The specs say what to build and how; these say what it is for.

## What Lives Here

**Foundation briefs** — the why beneath the daily work, on our own roots:

- `20260628-121512_the-foundation-beneath-the-work.md` — work as offering, building as service, freedom as the thing we build toward, grace as the ground we stand on.
- `20260628-121512_the-heart-in-the-work.md` — the path with heart as the test for what we take up, conserved energy as strength, clean craft as energy spent without leak.

**Vision documents** — the larger civic horizon, adaptable to any community:

- `the-aspiring-radiance-universal.md` — a regenerative policy design framework for every climate and community.
- `the-regenerative-experiment-universal.md` — a literary vision of renewal across every landscape.

The gratitude syntheses that seed the briefs — `DevotionAndCreativeFreedom.md`, `PathWithHeart.md` — live in `../gratitude/`, beside the sources they thank.

---

*May the why stay in view beneath the how. May the work remain an offering. May what we build serve the hands that need it, season after season.*
````

Then place the four writings:

| File | First line |
|------|-----------|
| `foundations/20260628-121512_the-foundation-beneath-the-work.md` | `# The Foundation Beneath the Work` |
| `foundations/20260628-121512_the-heart-in-the-work.md` | `# The Heart in the Work` |
| `foundations/the-aspiring-radiance-universal.md` | `**The Aspiring Radiance**` |
| `foundations/the-regenerative-experiment-universal.md` | `# The Regenerative Experiment: A Vision for Renewal Across Every Landscape` |

Commit:

```
foundations: open the why-beneath-the-work layer

Two foundation briefs (the foundation beneath the work; the heart in
the work) and two civic visions (The Aspiring Radiance; The
Regenerative Experiment), with a README naming the two scales.

Written together by Kaeden and Reya 2.
```

*(If you would rather the two civic visions live in their own `vision/` folder instead of beside the briefs, say so and we will split them — propose-then-confirm.)*

---

## Phase C — The Brix brief and the batch brief

Place the two new briefs and wire their cross-links:

| File | First line |
|------|-----------|
| `active-designing/yonder/20260628-120912_brix-the-composer.md` | `# Brix — The Composer, and the System Around It` |
| `expanding-prompts/20260628-120912_kernel-direction-brix-and-foundations.md` | `# The Kernel Direction, Brix, and the Foundation Beneath — A Batch Brief` |

Then **propose** index entries for each folder's `README.md` if those indexes exist (one line each, in the surrounding shape); if an index does not exist, say so and skip it. Show diffs, confirm, then commit:

```
design: record the Brix composer and the kernel-direction batch brief

Brix clarified through the sixos = Nixpkgs + infuse + s6 mapping
(Brix composes; Tablecloth holds; Mantra weaves; Comlink seals;
Caravan supervises; Tally bounds; Aurora boots). The batch brief
gathers the kernel-direction deliberation, the foundation layer, and
the revitalization practice.

Written together by Kaeden and Reya 2.
```

---

## Phase D — Push the branch

Push the working branch and report the branch name and head:

```
git push -u github design/foundations-and-kernel-horizon
```

Leave the merge to main for when the batch settles. If anything in this batch wants changing afterward, amend the relevant commit and force-push the branch — that is fine on a solo branch.

---

*May the branch hold this batch gently while it settles. May each placement be pure addition, and each commit say plainly what it carries. May the foundation rest where the next reader will find it.*
