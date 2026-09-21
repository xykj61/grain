# The weave meets Tablecloth by content -- the seam movement, charted

**Language:** EN
**Style:** Gauge, Field setting (see `../../../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Design, proposed -- **Room:** mixed -- the module readings are checkable, the seam is a proposal
**Stamp:** `20260921.071008`
**Kin:** [`20260905-153729_mantra-was-named-for-the-weave.md`](../20260905/20260905-153729_mantra-was-named-for-the-weave.md) -- [`../../../foundations/20260823-222020_what-tablecloth-is.md`](../../../foundations/20260823-222020_what-tablecloth-is.md) -- [`../../../foundations/20260825-211056_what-mantra-is.md`](../../../foundations/20260825-211056_what-mantra-is.md)

## What the seam is

The weave holds a document's whole history -- every line it ever held, each carrying when it
arrived and when it left. Tablecloth holds a thing by its content -- a resin, the SHA3-256 hash of
the bytes. The seam is where the two meet: **a build draws its inputs from a source history rather
than from a remembered pin.**

Today a build names its inputs by path and content address. The address is a pin: it says *these
bytes*, and the bytes may move on while the pin keeps naming the old ones. The weave already holds
the history that would let a build say *this document, at this point in its own story* -- and draw
the bytes from the story rather than from a remembered address.

## What already stands, measured

The two halves of the seam each stand, and each stands alone.

| Half | What it holds | Where it stands |
|---|---|---|
| The weave | `Line { text, gen, pos, site, run, ord }`, `current()` returns the document text in order, `merge` joins two histories in all six orders | `mantra/src/weave.rye` |
| Tablecloth | a resin is the SHA3-256 of bytes; the same bytes always name the same resin, from any room | `mantra/recall_tablecloth_query.rye` and the catalogue |

`current()` already renders the document text. That text is bytes, and bytes have a resin. The seam
is one sentence: **the weave's `current()` output is addressable by content, and a build may name
that address as its input.**

## The concrete first step

The first step is a reading rather than a new module. It asks: **does the weave's `current()` output already
carry a stable content address, and does anything in the tree already compute it?**

Two facts make this cheap to answer:

1. `current()` returns `[]const Line`, and each `Line.text` is `[]const u8`. Concatenated in
   document order, that is the document's bytes.
2. The tree already hashes bytes to a resin in `mantra/` -- the catalogue's own read path.

So the first step is a scan: for a stored weave, render `current()`, hash it, and ask whether that
resin matches the resin the catalogue already holds for the same document. If it does, the seam is
already half-built and the work is naming it. If the two resins differ, the gap is measured and the next step
is a small function rather than a design.

## The falsifier

If a build can already draw its inputs from the weave's `current()` output by content, then the
seam is a naming exercise rather than a build -- and the honest outcome is a page recording that with
its numbers, rather than a new module. The falsifier is one command: render a stored weave, hash
the document, and compare against the catalogue's resin for the same bytes.

## What stays whole

The catalogue stays exactly where it is. The weave grows beside it, as it has since the root
commit. The seam names a reading the two already share; it keeps one record where there was one.

## Where this sits in the arc

The arc's movements landed in order: the proofs run, the line and its count, the weave and its
order, the showing. The seam is the next movement, and this page charts its first step rather than
its whole. The reading -- one foundation naming both of Mantra's promises as one promise wearing
two clothes -- follows the seam and waits on it.
