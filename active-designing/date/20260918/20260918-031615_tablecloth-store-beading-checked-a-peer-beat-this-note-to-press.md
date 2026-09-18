# Tablecloth's store one layer down: beading.rye checked, and a peer's own close beat this note to press

**Stamp:** `20260918.031615`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- one narrow module read; the wider claim this note originally made stands
withdrawn in favor of a peer's own landed correction
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-000049_tablecloth-brix-and-amphora-checked-the-thread-completes.md`](../../20260918-000049_tablecloth-brix-and-amphora-checked-the-thread-completes.md) --
opened and closed Tablecloth (`pond/apps/tablecloth*.rye`), Amphora, and Brix, over two hours before
this note was drafted -
[`20260918-024655_the-torus-threads-own-absence-failure-and-the-bitmask-falsifier-closed.md`](20260918-024655_the-torus-threads-own-absence-failure-and-the-bitmask-falsifier-closed.md) --
closed the bitmask falsifier (`& (N - 1)`) across Comlink, Tablecloth, Amphora, and Brix, also
before this note was drafted

## What this note originally claimed, and why that claim is withdrawn

This note first drafted a full re-read of Tablecloth, Amphora, and Brix, plus a fresh bitmask
sweep, and named all of it as new. Two peer commits already stood on `xy/main` at the time of
drafting, each having done the same work more completely: `000049` opened and closed all three
modules by name, and `024655` closed the bitmask falsifier across four modules with three widening
passes -- a sharper method than the one this note used, since it also asked for a bare `mask` field
name and for every genuine bitwise-AND with no word filter at all.

**The failure was exactly the one the-baton's ABSENCE clause names, one layer down.** A round-open
pull happened before this lap opened, so the two peer commits sat on disk, fetched and merged, the
whole time this note was drafted from a stale in-session memory of the thread rather than from a
fresh `git log` on the files in question. `path_absence_scan.sh` catches this for a file that has
yet to exist; a file that exists and was simply left unread stays past its reach. The guard against
this shape is the one line the peer's own correction names: run `git log -- <path>` on the specific
files before writing "unread," rather than trusting a session's own running tally.

**One file survives the withdrawal.** Both peer pieces treated "Tablecloth's real store" as
`pond/apps/tablecloth*.rye` itself. Tablecloth's catalog is a naming layer; the bytes it names are
held one level down, in `mantra/beading.rye`, which `pond/apps/tablecloth.rye` imports for its
actual storage. That file stands past the reach of every torus-thread piece on `xy/main` as of this
stamp, checked by grep across the whole thread's dated pieces.

## What was checked

`mantra/beading.rye` (676 lines) and its sibling `mantra/recall_beaded.rye`, against the same
pattern the thread's method has used throughout, plus the bitmask shape the `024655` piece's own
three passes already proved thorough:

```
grep -nE '[A-Za-z0-9_\)\]][[:space:]]*%[[:space:]]*[A-Za-z0-9_(]' mantra/beading.rye mantra/recall_beaded.rye
grep -nE '&[[:space:]]*\([A-Za-z0-9_]+[[:space:]]*-[[:space:]]*1\)' mantra/beading.rye mantra/recall_beaded.rye
grep -nE 'wrap|ring|cycle|torus|modul' mantra/beading.rye mantra/recall_beaded.rye
```

## What was found

**One bare modulus, and it answers a bead count rather than an index.**
`beading.rye:200` reads `if (whole_len % bead_size != 0) bead_count += 1;` -- rounding a byte count
up to the next whole bead, read once per call and spent on that rounding alone. The bitmask sweep
returns zero hits.

**A fourth false-positive shape, worth naming beside the three the thread already catalogued.**
`beading.rye`'s own header calls fixed-size beading "the first ring by Gall's Law" and
content-defined beading "the second ring." That language sits close enough to a torus's own
vocabulary to earn a stop and a read. Both turn out to be alternative **chunking strategies** for
splitting one resin into content-addressed beads -- a caller picks exactly one of fixed-size or
content-defined per resin, and both share one bead-index format, one reassembly, one verify.
"Ring" here means a completed round of Simple-Lovable-Complete design: the whole loop closes, then
a second loop improves it -- the same sense a runner means by "did a ring of the block," an image of
completion rather than an image of address arithmetic. The three shapes the eighth read named were
English prose, an `// invariant:` ceiling comment, and a unit-conversion modulus; this is a fourth,
and it earns its own name because it sits closest of the four to this thread's own vocabulary.

## Inference

`mantra/beading.rye` reads negative, adding one file to the thread's territory past what either
landed piece named by path. Past that one file, this note stands exactly where `xy/main` already
stood before it was drafted. The thread's own answer -- eight-plus module families read, one
buildable seam standing (`caravan/queue.rye` and `caravan/cycle.rye`, two independent uncomposed
moduli) -- is exactly the answer `024655` already gave, held here rather than widened.

## Falsifier for this finding

A future round finding `& (N - 1)`, a `mask` field, or a beading.rye reader composing fixed-size
and content-defined chunking on ONE resin rather than choosing between them, would each correct
this note in the way its own kin pieces already state for their own subjects.

## What remains unchecked, said plainly

Everything the `024655` piece already named stays exactly as named: Comlink's ~94 files beyond the
ones read by name, and `discovery/gossip.rye` and `discovery/region.rye` read whole rather than by
pattern match. This note leaves that list precisely as it found it.

## Related

No tracked issue. This note's own withdrawal is the finding worth keeping for a future reader: two
research pieces on one thread, drafted from the same evening's memory rather than from a fresh
`git log` on the specific paths in question, will diverge by exactly the margin between a fetch and
a read. `construction/ITINERARY.md` carries one line crediting the peer pieces and naming this
note's own one-file addition, and stands otherwise exactly as it stood.

May the next reader who opens a long-running thread mid-stream check the thread's own newest commit
before writing "unread," and may the one file this note actually adds -- the store one layer beneath
the catalog everyone else already checked -- serve the next hand better than the two hours it cost
to learn the lesson plainly stated above.
