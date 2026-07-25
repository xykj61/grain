# Cursor prompt — File the season's writings: the civic discipline and the filing guide

**Goal:** Two new homes, and a guardrail. Place the civic-design discipline in `context/` beside the other disciplines, place the repository's filing guide at the root with its tree brought current, and confirm the foundations and Linengrow placements already made — without churning them. Two files are provided alongside this prompt: `CIVIC_STYLE.md` and `ORGANIZING.md`. Gated propose-then-confirm.

Work in Radiant Style. Commit and push each phase when confirmed, then append a session log.

---

## Step 0 — Footing

Confirm, then stop:

- Current branch and its cleanliness; whether it is level with its GitHub remote.
- `context/`, `foundations/`, and `linengrow/` all exist.
- These already-placed items are present (we will confirm, not move them): the seven `20260628-133212_*` essays and `20260628-140812_the-roots-beneath-the-work.md` in `foundations/`; the three civic visions (`*aspiring-radiance*`, `*regenerative-experiment*`, `20260628-124512_anywhere-we-are-found.md`) in `foundations/`; the two foundation briefs in `foundations/`; the Linengrow README, business model, and venture pitch in `linengrow/`.
- Neither `context/CIVIC_STYLE.md` nor a root `ORGANIZING.md` exists yet.

Report what you find. If any of the already-placed items are missing or sit elsewhere, name that and pause — do not relocate anything before we talk.

---

## Phase A — Place the civic discipline

Place the provided file as a living discipline document in `context/`:

| File | First line |
|------|-----------|
| `context/CIVIC_STYLE.md` | `# Civic Style — Designing Public Benefit So the Reward Points at the Good` |

This is the fourth discipline, the civic companion to `TAME_STYLE.md` (code), `RADIANT_STYLE.md` (prose), and `SIMPLE_LOVABLE_COMPLETE.md` (product). It is a living document: plain name, "Last updated" line, no content stamp, no dated-memo credit.

If `context/` carries a README or index, **propose** a one-line addition naming `CIVIC_STYLE.md` among the disciplines, in the surrounding shape. Show the diff, confirm, apply.

Commit:

```
context: add CIVIC_STYLE — the discipline for designing public benefit

The civic companion to TAME (code), Radiant (prose), and Simple,
Lovable, Complete (product): name the outcome you want, name what the
reward measures, keep the two aligned. Reframed from the Aligned
Incentives framework into a living discipline, with its worked examples
kept as illustrations.
```

---

## Phase B — Place and freshen the filing guide

Place the provided `ORGANIZING.md` at the **repository root** (its paths are root-relative, so root keeps them correct). It is a living document: plain name, "Last updated" line of `2026-06-28`, no content stamp, no dated-memo credit.

Before committing, **propose** these freshening edits so the guide matches the repository as it is now. Show the diff, confirm, apply:

1. **In "The Shape of the Tree," add the two folders the guide predates.** Add a paragraph for each, in the surrounding shape:
   - `foundations/` — the why beneath the work: foundation briefs, the distilled essays and the weave that composes them, and the civic visions. Dated artifacts rest beneath a living README.
   - `linengrow/` — the civic-application track: Linengrow's README, business model, and venture pitch, sharing the one spine with the operating system. It graduates to its own repository once its first ring runs.

2. **In the `context/` paragraph, name the disciplines it now holds:** Tiger and TAME for code, Radiant for prose, Simple-Lovable-Complete for product, and Civic for public-benefit design.

3. **Replace the ephemeral sections "Placing This Season's Writings" and "New Folders, Lightly Made"** with a single short paragraph: the placements for any given season are recorded in `session-logs/`, and the durable test for where a new piece belongs is the one above — read it aloud and ask what it is doing. The season-by-season snapshot lives in the log, not in this guide, so the guide stays evergreen.

Keep every other section as written: "A Word First," "The One Test for Placement," "The One Clock," "Caretaking," and the closing benediction. They are durable and good.

Commit:

```
docs: place the filing guide at root, brought current

Adopt the repository filing guide (tree shape, the placement test, the
one-clock law, caretaking). Add foundations/ and linengrow/ to the tree,
name the four disciplines under context/, and move the season-specific
placement snapshot to the session log so the guide stays evergreen.
```

---

## Phase C — Confirm, do not churn

A guardrail, because the filing guide as first written suggested folders we did not end up using. Confirm in your report that:

- No `essays/` folder is created; the seven essays remain in `foundations/` with their weave.
- No `civic-platform/` or `vision/` folder is created; the three civic visions remain in `foundations/`, and the Linengrow pieces remain in `linengrow/`.
- The Aligned Incentives framework now lives only as `context/CIVIC_STYLE.md`; it is not duplicated into Linengrow.

If anything tempts a move, stop and name it rather than acting.

---

## Phase D — Push, and record

Push the branch (or `main`, wherever this lands) and report the head.

Append a `session-logs/` entry naming what landed: `CIVIC_STYLE.md` placed in `context/` as the fourth discipline; `ORGANIZING.md` placed at root and brought current; the season's placements confirmed in `foundations/` and `linengrow/` without churn. Keep `TASKS.md` accurate if any open item is touched.

---

*May each file rest with its own kind, and the guide that says where stay true to the tree it describes. May the discipline for public benefit hold the same care as the discipline for code. And may the next reader, agent or human, find exactly what they came for.*
