# No anchor names the head -- three doors, and the measurement that picks between them

**Stamp:** `20260916.105110`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- **mixed room**: every measurement below is checkable and reproduced by claim 9 of [`../mantra/src/weave_apply_witness.rye`](../mantra/src/weave_apply_witness.rye); the three doors are vision until Keaton's word seats one
**Module:** [`../mantra/src/weave.rye`](../mantra/src/weave.rye)
**Charter:** [`20260905-153729_mantra-was-named-for-the-weave.md`](20260905-153729_mantra-was-named-for-the-weave.md)

## The mechanism, in one paragraph

`Weave.apply` places each inserted line by giving it four numbers -- run, site,
order key, position -- and `Place.less_than` reads them in that order. An insert
carrying an anchor in `Diff.after` inherits the anchor's run and order key and
draws a fresh position, which is higher than the anchor's, so it sorts just past
it. An insert with a null anchor keeps the counter's own answer: a fresh run,
which stands above every held run, so it sorts last. That second sentence has
stood in the module's head since the anchor landed at REDS `%689`, and claim 9
of the apply witness is what now reads it.

## What the same plant shows beside it

Anchoring on the FIRST line lands the insert **second**, never first. It
inherits that line's run and order key, and the position is the last tiebreak,
so a fresh position sorts just past the anchor by construction. A fresh weave's
first line carries order key zero and the lowest position drawn, so **no anchor
a caller can name puts a line ahead of it.**

That turns the residue from a forgotten branch into a property of the order law,
which is why it wants a word rather than a patch. Measured on metal
`20260916`: both readings hold, and each of two planted mutations -- the anchor
lookup forced false, and the run comparison reversed -- walks free at exit 0
when claim 9 is removed from the witness, so the leg is the only reading in the
file that presses either.

## Why no initializer fixes it

The tempting repair is to give a null anchor order key zero and run zero rather
than the counter's answer. Run it: the line then shares run, site and order key
with the first line, the position breaks the tie, and a fresh position is always
the highest. The line lands last again. The only mutation in the module that can
put a fresh insert in first place is a change to `Place.less_than` itself, which
is why the control plants exactly that and why this page exists.

## The three doors

**Door A -- reserve the order key zero band.** Read an order-key-zero line ahead
of every other line, whatever its run and site. **Cost, measured:**
`Weave.empty()` starts `next_pos` at zero and every line written before REDS
`%680` carries `ord == pos`, so order key zero is **occupied by the first line
of every weave this tree has ever written**. Reserving it displaces a real line
in every existing record, which is a breach rather than an accretion.

**Door B -- a fourth place field.** Add a `head` flag beside `ord`, read first by
`Place.less_than`, so a head-inserted line sorts ahead of every ordinary one and
head inserts are ordered among themselves by the three fields already there.
**Cost:** one field through 12 place constructions, the three record formats, and
their lifts. **What it keeps:** an elder line reads `head = false`, so every
weave on disk reads exactly as it read before -- the same accretion `ord` itself
made at `%680`.

**Door C -- a document-start sentinel.** Give every weave one implicit line at
run zero, site zero, order key zero, start real positions at one, and let a head
insert anchor after the sentinel. **Cost:** the sentinel must be held out of
`current`, out of every count, and out of the line bound, and positions shift by
one. **What it keeps:** the anchor stays the single placement mechanism, and
`apply` needs no new branch at all -- a head insert becomes an ordinary insert.
An elder record lifts by inserting the sentinel, which is the move `from_v1`
already makes rather than a conversion.

## What none of the doors changes

**Two hands inserting at the head in one run stay ordered by site**, so each
hand's block still arrives whole. That is the property the run number was
introduced to keep, and the head band, the flag, and the sentinel each sit above
it rather than beside it.

## The recommendation, and what would falsify it

**Door C**, on one reading: it adds no field to the order law and no branch to
`apply`, so the placement mechanism stays single-stranded. **Horizon:** one lap.
**Assumption:** holding one sentinel out of `current`, the counts and the bound
is cheaper than threading one field through 12 constructions and three formats.
**Falsifier:** a count of the places that would have to learn about the sentinel.
If that count exceeds the 12 place constructions Door B touches, Door B is the
cheaper accretion and this recommendation is wrong. **Confidence:** moderate --
the two costs were reasoned about rather than both counted, and only one of them
has a number beside it on this page.

*May a line find its place by the name of what it follows, and may the day the
document grows at its head arrive with a word rather than a guess.*
