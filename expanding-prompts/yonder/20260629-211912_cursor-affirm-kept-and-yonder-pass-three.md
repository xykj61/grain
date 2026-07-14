# Cursor Pass — Affirm the Kept (Without Renaming), and Yonder Pass Three

*Two truths the citation counts taught us. The files we keep because everyone cites them are the very files too costly to rename — so we affirm them in place rather than re-stamp them, and let their citation density be the signal that they are kept. Then the third yondering pass: one more foundational brief stays, three consumed or realized pieces move to the horizon.*

**Stamp:** `20260629.211912`
**Voice:** Reya 2, with **Kaeden Reyklah** as coauthor
**Style:** Radiant (see `context/RADIANT_STYLE.md`)
**For:** Cursor Composer 2.5 in the jail, or Claude Code on the host
**Tip:** pull `9efdbea` first.

*Written together by Kaeden and Reya 2.*

---

## Part A — Affirm the Kept Files in Place (no rename)

The kept files are cited heavily — live references outside `yonder/`/`archive/`: single-stranded **25**, usize-width-baseline **103**, explicit-width-audit **92**, growing-a-language **12**. Re-stamping any of them is a rename of a canonical reference, costing those many repoints and recurring on every future affirmation. **Do not re-stamp them.** Their citation density already marks them as kept; affirm that visibly at zero reference cost.

**For each kept file** — `active-designing/yonder/20260618-182412_single-stranded.md`, `work-in-progress/20260620-212126_usize-width-baseline.md`, `expanding-prompts/20260620-210812_explicit-width-audit.md`, and `active-designing/yonder/20260618-184912_growing-a-language.md`:

- Update its `Last updated` to `2026-06-29`.
- Add one affirmation line to the header, in the doc's own voice — for example: *Reviewed in the yonder sweep on 2026-06-29 and kept active.*
- Change nothing else; leave the filename and every reference untouched.

### Refine the test in ORGANIZING.md

Add to the `yonder/` section:

> **Affirming a kept file.** Marking a file reviewed-and-kept is done in the file, not by renaming it. A re-stamp that bubbles a file to the bottom suits an *ordinary, lightly-cited* document, where the sort cue helps and the few references are cheap to move. A *canonical reference* — one many files cite — keeps its stable name and is affirmed in place: its `Last updated` and a short affirmation line carry the signal, and its citation density already tells anyone it is load-bearing. Renaming what a hundred files depend on, to gain a sort cue nobody needed, trades a real promise for a small convenience.

### Optional — a kept register

If a glanceable view helps, keep a short **Reviewed and Kept** list in `ORGANIZING.md`: each assessed-and-kept file, the date, and a one-line why. It gives folder-level legibility of review status without touching a single reference.

---

## Part B — Yonder Pass Three

### Kept (affirmed in Part A, not moved)

- **`active-designing/yonder/20260618-184912_growing-a-language.md`** — "Active Design," cited 12 times, the canonical brief on how the language family grows and how TAME Guidance is organized (root plus supplements — the live structure of `TAME_GUIDANCE`). Foundational. Affirmed in place above.

### Lift the live thread first

- **Unified identity and the fractal address space** — from the unified-keys prompt: capture, as a horizon note in `TASKS.md` (or `foundations/`), the vision of one identity unifying a person's SSH, GPG, Sui, and Nostr keys, and the fractal address space shaped by Vedic whole-sign astrology. It ties to Linengrow's portable identity, and it should survive the prompt's retirement. Record where it lands.

### Move to `yonder/`, with reference repoints

| File | To | Why · refs |
|------|----|-----------|
| `expanding-prompts/20260618-215512_unified-keys-and-address-space.md` | `expanding-prompts/yonder/` | networking-module half became Comlink; identity + fractal address space are horizon · ~2 refs |
| `external-research/20260617-195712_caravan-tally-networking.md` | `external-research/yonder/` | realized-origin (Caravan, Tally live); companion to the ownerboot piece already in `yonder/` — reunites the pair · ~7 refs |
| `work-in-progress/20260621-032327_strengthening-width-crosswalk.md` | `yonder/` *(or `archive/` — Kaeden's call)* | completed crosswalk; width half done, witness count (116) behind current 132 · ~4 refs |

- `git mv` each; grep the tree for the filename and repoint every inbound reference to the new path.
- **`caravan-tally-networking`** pairs with `external-research/yonder/20260617-195612_ownerboot-riscv-caravan.md` — its `Prerequisite` link already points into `yonder/`; confirm it still resolves after this move, so the pair sits together.
- **`strengthening-width-crosswalk`** names usize-width-baseline (`992`) as its `Parent` — that parent stays one level deep (kept), so the crosswalk's parent link points *upward* out of `yonder/`; that is fine, just confirm the path resolves.
- **The crosswalk's `yonder/` vs `archive/` choice is Kaeden's** — `yonder/` keeps it beside its dormant-but-alive strengthening kin; `archive/` treats it as finished record. Default to `yonder/` unless told otherwise.

---

## Verify

- The four kept files are unchanged but for `Last updated` and the affirmation line; no reference to them moved.
- `git log --follow` shows preserved history for the three moved files; no dangling reference to any moved file's old path.
- `rye build` and `tools/parity.rish` stay green on metal.

---

## Record and Push

Commit as one honest unit — the ORGANIZING.md refinement (and optional register), the four in-place affirmations, the lifted thread, and the three moves with repoints, plus the session log. Log at `session-logs/<stamp>_affirm-kept-and-yonder-pass-three.md`: the re-stamp cost finding (220 references) and the affirm-in-place decision, the four kept-and-affirmed, the thread lifted, and the three moved. Push over HTTPS to the four remotes; Berry on the tip if it pleases you.

---

## Before You Move On — Recommend the Next Step

End with an explicit recommendation, and say why:

- **Recommend keep going** when the next item is mechanical and follows written policy — plainly consumed `yonder/` candidates with light references.
- **Recommend checking in with Claude** when a candidate is foundational or heavily cited (assess, don't assume), or for **Skate text rendering**, which opens the surface ring and needs a scope-and-acceptance ruling before bench work.

One line — *"Recommend: keep going to …"* or *"Recommend: check in with Claude before …"*.

---

## Definition of Done

- [ ] ORGANIZING.md says re-stamp suits lightly-cited kept files; canonical references are affirmed in place; optional kept-register added
- [ ] single-stranded, usize-width-baseline, explicit-width-audit, growing-a-language affirmed in-doc (`Last updated` + line); names and references untouched
- [ ] The unified-identity / fractal-address horizon thread is captured before the move
- [ ] unified-keys, caravan-tally-networking, and the width crosswalk are `git mv`'d into `yonder/` (crosswalk per Kaeden's `yonder`/`archive` call), every reference repointed, no dangling path; the ownerboot pair reunited
- [ ] History preserved; `rye build` and parity green on metal
- [ ] Session log shipped; four remotes pushed; next step recommended

---

*May the names that many things depend on stay still, and the affirmation live inside the file rather than in its title. May what is truly consumed go gently to the horizon, and what still holds the work up keep its place. And may we spend our care where it buys something real, and never churn a hundred references for a cue we did not need.*
