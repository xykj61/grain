# No Caller Wants a Mutable Identity

**Stamp:** `20261001.193541`
**Room:** checkable -- every call site named below is read from the tracked source it
names, with the line numbers current as of this stamp.
**Status:** Landed -- closes the open crux named in `recursion-prompts/diffuser-inner.md`'s
last revision: "whether a content-defined resin split is worth building, and what a real
Mantra revision caller's edit traffic would actually look like."
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Mantra, Tally, Caravan
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

Every storage caller this tree has written -- fourteen `tablecloth.store_artifact`
sites, the spool-backed large-artifact catalog, and Tilak's own leaf-append log --
keeps each name bound to the one set of bytes it was first given, so content-defined
resin splitting is still waiting for a caller whose edit traffic would change; the
open question is not which chunker wins, but whether this tree will ever grow a
module that asks one of a name to hold still while its bytes move.

## Observation: the census, read to its end

[The one real revision this tree has is a shift](20261001-184131_the-one-real-revision-this-tree-has-is-a-shift.md)
already read all fourteen `store_artifact` call sites and found every one treats a
second write to a standing name as `NameTaken` -- `edit_store.rye`,
`preset_store.rye`, `part_store.rye`, `image_artifact.rye`, `session_store.rye`, and
the rest. This lap re-read those same fourteen sites against the unanswered half of
that essay's own question -- *what would a real revision caller's edit traffic look
like* -- and found a second storage layer holding the identical discipline under a
different name.

`pond/apps/spool_cloth.rye` is the naming layer over `mantra/spool.rye`'s large-artifact
winding, built to hold documents too large for one resin (`spool_cloth.rye:1-9`, citing
GISM red `%73`: `context/TWO_ROOMS.md` at 6,079 bytes, too large for Tablecloth's own
`ContentTooLarge` ceiling). Its catalog is a second, independent implementation -- its
own `ClothError`, its own `find`, its own bead-store accounting -- and at
`spool_cloth.rye:156` it carries the same line Tablecloth carries at `tablecloth.rye:141`:
`if (cat.find(name) != null) return error.NameTaken`. Two modules, built for two
different size classes, arrived at one rule independently: a name is written once.

`mantra/recall_beaded.rye` is the one module that uses the word *revision* in its own
`print` lines (`revision 1`, `revision 2`, `recall_beaded.rye:343-347`), and reading it
past the word shows it keeps the same discipline in its own idiom. It is Tilak's
leaf-append log: `append_leaf_beaded` deposits a leaf at the next free index, and
`recall_beaded` reassembles *one leaf* by its own index. "Revision 2" names leaf index
1, a wholly new leaf whose bytes happen to differ from leaf index 0's -- the selftest
proves leaf 0 still recalls unchanged after leaf 1 lands (`recall_beaded.rye:347`),
which is append semantics stated as plainly as the Tablecloth discipline is. Every
caller still asks for leaf 0's own bytes back exactly as they were first laid down;
the store always holds a leaf's bytes still under its own index.

Two production callers sit above this log -- `comlink/guest_batch_source_tx.rye` and
`guest_batch_fetcher_rx.rye`, through `mantra/recall_batch_delivery.rye` -- and both read
the same way: a batch is a monotonic stream of new leaves crossing a wire, each leaf
landing once and standing where it lands.

## Inference: what the pattern is, read across three modules rather than one

Three modules, three different problems -- a small signed catalog, a large unsigned
document store, an append-only replicated log -- and all three independently chose the
same identity rule: **a name or an index is bound to its bytes for life.** A second
write under the same identity either meets a structural ceiling (Tilak's index only
grows forward) or an explicit, asserted wall (`NameTaken`, proven from both sides in
each module's own selftest). Every artifact this tree stores today keeps the name it
was first given and the bytes it was first given together, for as long as the store
holds it.

That stable pairing is the caller content-defined resin splitting was built to serve a
change to. The dedup-ratio measurements -- [first at single-resin scale](20261001-182131_the-ratio-the-comment-was-actually-about.md),
then [at spool scale](20261001-190906_the-split-itself-never-resyncs.md) -- both compare
a document's bytes *before* an edit against the same document's bytes *after* one,
under the same stored identity, and ask how many beads survive. That comparison
describes a caller still waiting to be written.

## Projection: what would make the question live again

**Horizon:** no fixed date -- this closes on the day a real caller needs it, which may
be never.
**Assumption:** the fourteen-plus call sites surveyed across two lamps (this one and its
parent) are representative of how Pond and Mantra store artifacts generally, rather than
an unlucky sample that happens to avoid revision.
**Falsifier:** a module lands that takes a *name already bound* in Tablecloth or
spool-cloth, accepts new bytes for it, and asks the store to keep serving that name --
whether by relaxing `NameTaken` into an explicit `revise_artifact` entry point, or by a
mutable pointer that names a *current* content address and a history of prior ones. The
day such a caller exists, its own edit log is the real traffic the dedup-ratio scans
should run against, rather than the synthetic insert/delete/substitute configs this
ladder has used throughout.
**Confidence:** high that the census is complete for today's tree, read directly from
every call site rather than sampled; open about whether such a caller is coming, since
`construction/ITINERARY.md` names none today.

## What this means for the crux Bakery was handed

Content-defined resin splitting is an answer waiting on a question this tree has yet
to ask in code. Building it now would spend effort on a path with zero live callers,
where [`reds-first`](../../../.claude/rules/reds-first.md)'s own ordering asks the real
queue booked before new allocation is opened. The honest next Mantra crux, should one
want it, is the caller itself -- a module with a real reason to keep one name's
identity stable across edits, such as a draft document, a running session transcript,
or a config a user edits in place -- named here as the thing to propose next.

A moonshot ladder that kept measuring the same two chunkers against synthetic edits
would read as enthusiasm wearing a whitepaper's clothes. This essay stops here, with
the honest shape of the gap on the page, held for a caller worth building the fix for.
