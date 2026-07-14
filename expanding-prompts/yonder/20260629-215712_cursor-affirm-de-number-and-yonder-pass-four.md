# Cursor Pass — Affirm and De-Number the Kept, and Yonder Pass Four

*The affirmation touch grows one job richer. When we keep a canonical file, we now also clear the dead number from its title and lightly freshen its voice — all in the single commit that already marks it reviewed. The old `NNN ·` prefixes have gone ambiguous and the timestamp filename is the true name, so the number leaves the title and nothing else moves. Then the fourth yondering pass: one foundational brief stays, three realized or consumed pieces go to the horizon.*

**Stamp:** `20260629.215712`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Tip:** pull `e28454e` first.

*Written together by Kaeden and Reya 2.*

---

## Part A — The Enriched Affirmation Touch (kept canonical files)

The `NNN ·` title prefixes are vestigial and now ambiguous — three different `993`s and several `995`s live in the tree, so the number no longer names a file; the timestamp filename does. Removing a number from a title does **not** break the freeform `` `992` ``-style mentions scattered across the corpus: those are legacy prose, already ambiguous, and a full number→filename reference migration is a separate effort (out of scope here — see the closing note).

**For each kept canonical file below, in one touch, with no reference changes:**

1. **Strip the dead number prefix** from the H1 — `# 997 · The Recommended Path …` becomes `# The Recommended Path …`. The unique text title stands on its own; collisions vanish with the numbers.
2. **Re-date** — `Last updated: 2026-06-29`.
3. **Affirm** — keep or add the line: *Reviewed in the yonder sweep on 2026-06-29 and kept active.*
4. **Lightly freshen** — only where the prose has genuinely drifted from Radiant Style, a gentle pass: affirmative framing, active voice, sentences that land, no over-formatting. A light touch, not a rewrite; leave already-radiant prose alone.

Apply to the four previously affirmed, plus the new keep from this pass:

- `active-designing/yonder/20260618-182412_single-stranded.md`
- `active-designing/yonder/20260618-184912_growing-a-language.md`
- `active-designing/yonder/20260618-184912_recommended-architecture.md` *(new — Part B keep)*
- `work-in-progress/20260620-212126_usize-width-baseline.md`
- `expanding-prompts/20260620-210812_explicit-width-audit.md`

Filenames and references stay untouched throughout — only titles, the dating, and gentle prose change.

### Record the convention in ORGANIZING.md

> **Affirming a kept file does four small things in one touch:** strip its dead `NNN ·` number prefix (the timestamp filename is the true name now), re-date its `Last updated`, add the reviewed-and-kept line, and lightly freshen the Radiant voice where it has drifted. No rename, no reference change. Vibrancy rides on this touch and on writing Radiant by default — never on a sweeping restyle.

---

## Part B — Yonder Pass Four

### Kept (affirmed in Part A, not moved)

- **`active-designing/yonder/20260618-184912_recommended-architecture.md`** — foundational clean-room architecture brief, "Active Design," cited 12 times; the third of the foundational trio with single-stranded and growing-a-language. Affirmed and de-numbered above.

### Move to `yonder/`, with reference repoints

| File | To | Why · refs |
|------|----|-----------|
| `expanding-prompts/20260619-024512_the-near-future.md` | `expanding-prompts/yonder/` | forward projection now largely built; living successor is ROADMAP + TASKS · ~1 ref |
| `external-research/20260617-195812_aurora-boot-riscv.md` | `external-research/yonder/` | realized-origin (Aurora boots); "builds on" the ownerboot and caravan-tally pieces already in `yonder/` — reunites the Aurora-boot trio · ~6 refs |
| `external-research/20260617-201612_useful-utilities.md` | `external-research/yonder/` | forward "what we'll re-grow" inventory, not presently driving work; live plan is ROADMAP/TASKS · ~5 refs |

- `git mv` each; grep the tree for the filename and repoint every inbound reference to the new path.
- **`aurora-boot-riscv`** declares `Builds on: yonder/20260617-195612_ownerboot-riscv-caravan.md, yonder/20260617-195712_caravan-tally-networking.md` — those already point into `yonder/`; after the move all three sit together, so confirm the links still resolve from the new location.
- **`useful-utilities`** is a borderline call — `yonder/` (forward, deferred) is the default; if Kaeden treats it as a still-consulted living re-grow roadmap, keep it one level deep instead. Default to the move unless told otherwise.

---

## Out of Scope (named, not done)

- **The number→filename reference migration** — ~282 files mention bare `` `99x` `` / `` `100xx` `` numbers as legacy prose. Resolving them all to timestamp filenames is a real, separate, deliberate effort, aided by the rename-mapping docs in `archive/`. Not this pass; the title-cleanup above neither needs it nor breaks it.
- **A blanket Radiant restyle of recent commits** — declined by design. Freshening rides on the affirmation touch and on Radiant-by-default, not on a sweep.

---

## Verify

- The five kept files: H1 de-numbered, re-dated, affirmed, lightly freshened where needed; filenames and references unchanged.
- The three moved files: `git mv` with history preserved; no dangling reference to an old path; the Aurora-boot trio reunited in `external-research/yonder/`.
- `rye build` and `tools/parity.rish` stay green on metal.

---

## Record and Push

Commit as one honest unit — the ORGANIZING.md convention, the five enriched affirmations, the three moves with repoints, and the session log. Log at `session-logs/<stamp>_affirm-de-number-and-yonder-pass-four.md`: the enriched affirmation touch, the five de-numbered titles, the three moved, the number-migration and restyle both named as out of scope. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## Before You Move On — Recommend the Next Step

End with an explicit recommendation, and say why:

- **Recommend keep going** when the next item is mechanical and follows written policy — further plainly-consumed `yonder/` candidates, light references.
- **Recommend checking in with Claude** when a candidate is foundational or heavily cited (assess, don't assume), or for **Skate text rendering**, which opens the surface ring and needs a scope-and-acceptance ruling before bench work.

One line — *"Recommend: keep going to …"* or *"Recommend: check in with Claude before …"*.

---

## Definition of Done

- [ ] ORGANIZING.md records the four-in-one affirmation touch (de-number, re-date, affirm, lightly freshen)
- [ ] The five kept files are de-numbered, re-dated, affirmed, and freshened where drifted; filenames and references untouched
- [ ] `the-near-future`, `aurora-boot-riscv`, and `useful-utilities` are `git mv`'d into `yonder/` (useful-utilities per Kaeden's call), references repointed, no dangling path; the Aurora-boot trio reunited
- [ ] The number-migration and the blanket restyle are both recorded as out of scope
- [ ] History preserved; `rye build` and parity green on metal
- [ ] Session log shipped; four remotes pushed; next step recommended

---

*May the true name be the one that endures, and the dead number fall away without a sound. May each kept page read a little more brightly for being touched, and no page be touched that did not need it. And may the work stay vibrant by being written so, season after season, rather than by any anxious sweep.*
