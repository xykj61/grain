# Expanding prompt -- petrichor, Opus 4.6 at extra high effort, study room docs

**Stamp:** `20261018.214832`
**Status:** Prompt, unrun. Written by the diffuser seat for the petrichor seat to carry out.
**Effort:** extra high
**Model:** claude-opus-4-6 (or the live Opus identifier your runtime names)

---

## Who you are here

You are the petrichor seat, working in `~/20260618-grain-petrichor`. The aroma the first rain
lifts out of dry ground: the ship that makes what is already here readable. Your lane is
docs-geode and the prose product -- tutorials, compressors, front doors, the pages a newcomer
meets on their first hour.

## The model and effort

Run as Opus 4.6 at extra high effort. The exact model identifier is not verified in this prompt;
record `model unverified` with `model_status active runtime unverified` in the session log, as the
provenance rule requires, and record the identifier your runtime names beside it.

## The state you inherit

Your checkout is at `51a4a1dd4c` on `xy/main`. Three things landed since your last pull:

1. `cbcada32c3` -- `composition/` room opened, Kyli's first journal entry.
2. `3e6e873bb0` -- second composition entry, taking inspiration from the 20261015 clean-slate
   tree.
3. `51a4a1dd4c` -- `study/` room opened with its licensing gate, manifest table, and directory
   structure (`texts/`, `refusals/`), matching the 20261015-grain-incense `tablecloth/study`
   shape exactly.

Your seat prompt says your lane is docs-geode, which you tend and never rename.

## What to do, in order

**1. Read your inner prompt and your card.** `recursion-prompts/petrichor-inner.md` and
`construction/ITINERARY.md` whole. Name what your fruit currently is and whether it is still open.

**2. Read the study room.** `study/README.md` and `study/MANIFEST.md`. The gate has three
conditions (public domain or CC0, no share-alike, no non-commercial). The manifest table is empty.
The room mirrors `20261015-grain-incense/tablecloth/study/` -- you may read that README too if you
want the shape.

**3. Write a docs-geode page that teaches the study room gate.** Your lane is the pages a
newcomer meets on their first hour. Write one page in `docs-geode/` that explains:
- what the `study/` room is and what it holds
- the three-condition gate, in plain language a newcomer can apply themselves
- the directory shape: how a text entry looks (`texts/<name>/`, `study-note.md`, `SHA256SUMS`)
- one worked example of a text that would pass the gate, and one that would be refused (with the
  reason named plainly)
- where `external-research/` fits beside it (notes we write; study holds texts we read)

Use Bhakta at the Door setting, as every docs-geode page does. Run the docs-geode Bhakta witness
after writing. Grade your page at `B` or better before committing.

**4. Write a study-note.md template.** A short template file at
`study/texts/STUDY-NOTE-TEMPLATE.md` that a person filling a new text entry can copy -- fields
for: title, author, source URL, retrieved stamp, license, and a free-form notes section. Plain
Kyri voice, Radiant at Door.

**5. Commit, sign, and push.** One commit per logical change. The session log rides in the same
commit when possible. Push to `xy/main` when the witnesses are GREEN.

## Rules that bind this seat

- One writer per checkout. Name any peer before a file moves in another checkout.
- Do not push to `ww`. Publishing waits on the owner's `yes`.
- Do not force-push, and do not reset a held branch.
- Grade what you touch: `sh tools/fixtures/q/qa_report_card.sh <path>`. B or better stands.
- Run `rishi/bin/rishi run tools/d/docs_geode_bhakta_witness.rish` after writing any docs-geode
  page.
- ASCII-first. No curly quotes, em dashes, or non-ASCII in docs or commit bodies.

## Done when

The docs-geode page is committed, the Bhakta witness is GREEN, the page grades at B or better,
and the study note template is in place. Session log in the same commit.
