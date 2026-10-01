# The One Real Revision This Tree Has Is a Shift

**Stamp:** `20261001.184131`
**Room:** checkable -- every claim below cites a line number in a tracked source; the only
new artifact this page adds is the reading itself, no new code or witness.
**Status:** Landed -- one of the two open doors
[the dedup-ratio measurement](20261001-182131_the-ratio-the-comment-was-actually-about.md)
left for a next lap: "whether Mantra's real callers produce substitutions, shifts, or a mix."
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

`pond/apps/tablecloth.rye`'s `store_artifact` refuses to revise an artifact at all
(`NameTaken` on a repeat name), so of every tracked caller in this tree, exactly one
module demonstrates a real revision-over-revision edit sequence --
`mantra/recall_beaded.rye`'s own `selftest_beaded_revision_dedup` -- and the edit it
exercises is a 3-byte insertion near the front of a 400-byte resin, which is the shift
shape the fourth-angle measurement found content-defined beading winning, not the
same-length substitution shape it found losing.

## Observation: where a revision would have to live, and where it does not

The dedup-ratio page's open question asked whether real callers lean toward
substitution or shift. Answering it means finding a place in the tree where one
logical artifact is actually rewritten more than once, with beading called again on
the new bytes against the same `BeadStore`.

`pond/apps/tablecloth.rye:131-159` is the obvious place to look, since it is the one
production (non-selftest) call site `bead_content_defined` has (confirmed by grepping
every `.rye` file under `pond/apps/` for a live call to `beading.bead(` or
`beading.bead_content_defined(` outside a function named `selftest` or
`unwelcome_*` -- `tablecloth.rye:147` is the only hit). Reading `store_artifact`
itself at `tablecloth.rye:141`: `if (cat.find(name) != null) return error.NameTaken`.
A name, once stored, is permanent. There is no `update_artifact`, `revise_artifact`,
or `rebead` function anywhere under `pond/apps/` -- grepped for all three and for
`version` fields that might gate a second write, finding only `tablecloth_keyed.rye`'s
own unrelated `.version = 1` struct literal and the same `NameTaken` refusal repeated
at `tablecloth_keyed.rye:346` and `session_store.rye`'s single-shot `store_session`.

So the fourteen `pond/apps/` call sites the prior page counted are fourteen call sites
of a module that, as written today, never revises anything. Every one of those
callers stores each artifact exactly once; whatever dedup Tablecloth earns there comes
from **cross-artifact** byte sharing (two different named artifacts happening to
share content), which is a different mechanism from the **same-artifact,
revision-over-revision** resync `beading.rye`'s own header comment is about.

## The one real revision caller, and its edit shape

`mantra/recall_beaded.rye` is not under `pond/apps/` and carries its own `revision: u32`
field through its `Name` struct (`recall_beaded.rye:56`) and its own `append_leaf`
call that threads it (`recall_beaded.rye:62`, `recall_beaded.rye:86`). Its
`selftest_beaded_revision_dedup` function (`recall_beaded.rye:232-262`) is the one
place in this tree that actually beads two revisions of the same logical content and
checks the dedup:

```
content_v1: [400]u8          -- the base resin
content_v2: [403]u8          -- revision 2
  bytes [0..30)   <- content_v1[0..30)     (unchanged)
  bytes [30..33)  <- 'X', 'Y', 'Z'          (new, inserted)
  bytes [33..403) <- content_v1[30..400)    (unchanged, shifted +3)
```

That is a **3-byte insertion at offset 30**, not a same-length substitution: the
content grows from 400 to 403 bytes, and every byte from offset 30 onward in `v1`
moves three positions to the right in `v2`. The comment directly above it
(`recall_beaded.rye:237-239`) names exactly this shape in exactly the fourth-angle
measurement's own words: *"revision 2 edits a handful of bytes near the front. The
long tail is unchanged, so content-defined beading re-syncs it."* The asserted
outcome -- `rep_v2.beads_deduped >= 1` and `rep_v2.beads_deposited >= 1`
(`recall_beaded.rye:259-260`) -- is qualitative (at least one of each) rather than a
measured ratio, so it confirms the direction without the number the dedup-ratio scan
would give it.

Searching every other caller of `append_leaf_beaded` outside `recall_beaded.rye`
itself (`comlink/guest_batch_fetcher_rx.rye`, `comlink/guest_batch_source_tx.rye`,
`mantra/recall_batch_delivery.rye`) finds no second case: every `Name` constructed in
those three files carries `revision = 1` and nothing threads a `revision = 2` or
higher through an edited byte sequence. They exercise the batch-delivery protocol
around one revision's bytes, never a revision-to-revision edit.

## Inference: the real evidence, narrow and one-sided, points at shift

One example is not a workload distribution, and this page does not claim it is. What
it does establish: **the only revision-over-revision edit this tree's own authors
chose to write, anywhere, is a shift rather than a substitution** -- and they chose it
specifically to demonstrate the resync behavior the fourth-angle measurement just
quantified. That is weak evidence about real growth patterns in general (one
handwritten example, chosen to illustrate a point rather than sampled from traffic)
and it is the strongest evidence available today, because `pond/apps/`'s own revision
story does not exist to sample from at all.

The stronger reading is structural rather than statistical, and it follows from
`store_artifact`'s refusal rather than from the one example: **a system that cannot
revise an artifact cannot produce a substitution-shaped edit on that artifact**,
because a substitution is by definition an edit that keeps length and offsets fixed
while changing content in place, and `NameTaken` forecloses any second write to the
same name. Until something in `pond/apps/` grows a revision path, the realistic
sources of a same-length in-place edit are outside this tree's own call graph
entirely -- a caller editing a buffer before the first (and only) `store_artifact`
call, which this reading cannot see.

## Projection: what this narrows, and what it still leaves open

**Narrows:** the open question "does `pond/apps/` lean substitution or shift" had an
implicit premise -- that `pond/apps/` revises artifacts at all. It does not, today.
So the honest answer is not "shift" but "the question does not yet apply to
`pond/apps/`, and applies to exactly one module outside it, which leans shift by
construction and by the one example it carries."

**Leaves open:** whether a future `pond/apps/` revision path (a preset book edited in
place, a session updated rather than replaced) would look like `recall_beaded.rye`'s
chosen shape or like something else. **Falsifier for that question:** the day
`pond/apps/` grows an `update_artifact` or equivalent, running
`mantra/beading_dedup_ratio.rye`'s existing instrument against that real caller's
actual before/after byte pairs (rather than synthetic edits) would settle it on
measurement rather than reading. **Horizon:** this reading, and the fourth-angle
measurement it extends, hold only for `beading.rye` and `recall_beaded.rye` as they
stand on `20261001`; a chunker parameter change or a new revision caller would need a
fresh read. **Confidence:** high that the structural claim (`store_artifact` cannot
express a same-artifact edit) holds, since it rests on one `if` statement rather than
a sample; low-to-moderate that `recall_beaded.rye`'s one example represents what a
real revision workload would look like once one exists, since a handwritten
illustration is not a trace.

## What this does not reach

**`mantra/spool.rye`'s own larger scale** -- the fourth-angle page's other named open
door, 64 resins of 2 beads each, stays exactly as untouched as it was before this
page, and is still a fair next crux.

**Whether `recall_beaded.rye`'s revision mechanism is itself used by anything a real
keeper would run today** -- this page confirms the mechanism exists and shows its one
worked example; it does not trace whether any shipped `pond/apps/` surface calls into
it along a real user action.

*May the next revision this tree writes know, before it is written, which shape it
chooses -- and may the choosing be a measurement rather than a guess.*
