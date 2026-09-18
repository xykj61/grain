# The two fields that composed, and the one that did not

**Stamp:** `20260918.013435` -- **Status:** Checkable -- `tools/c/composite_key_witness.rish` GREEN
on metal, 16 behaviors, two planted populations, two mutations bitten.
**Room:** checkable -- an arithmetic claim bound by a witness rather than a projection.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Kin:** [`20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md`](20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md)
(proposal 2, this piece's parent question),
[`date/20260915/20260915-181000_the-key-that-carries-locality.md`](date/20260915/20260915-181000_the-key-that-carries-locality.md)
(the single-field reading this piece composes against),
[`20260918-005400_the-search-found-the-ceiling.md`](20260918-005400_the-search-found-the-ceiling.md)
(proposal 1, landed first, whose own closing note named this door)

---

## The question, restated once

Round one priced one key read two ways and found a trade: a cryptographic digest buys evenness
(chi-squared near its critical value) and confidentiality (an observer holding keys alone places
about a third of files correctly, near the no-key floor) while a locality-bearing prefix buys
locality (same-room files land far closer than chance) -- and each single field buys only two of the
three, because avalanche is exactly what buys two of them and destroys the third. Round two's second
proposal asked the natural next question: what if the key carries **two declared fields** instead of
one -- a placement field free of avalanche, and a content field built to carry it? Does splitting let
each field carry the property it is good at, buying two properties from two fields, each kept whole?

## What was built, and what it found

`tools/fixtures/c/composite_key_scan.sh` reads three keys from the same row of data (room, digest,
prefix, path): the digest alone, the prefix alone -- both read exactly as round one's own locality
scan reads them -- and a **composite** key, which holds two cells under one name rather than one.
Storage placement (the question evenness answers) is put to the content field, because that is the
field a real store would use to choose a physical slot. Locality and confidentiality are put to the
placement field, because that is the field carrying the relation both properties turn on.

**The result, read over the tree's own tracked bytes at a 64-cell grid.** Storage placement put to
the content field reads chi-squared **41.91**, against a p=0.001 critical value of 103.51 -- IDENTICAL
to the digest key's own reading, because it is the same bytes under the same arithmetic. Same-room
distance put to the placement field reads **0.339** cells, IDENTICAL to the prefix key's own, against
the 16.000-cell expectation two independent uniform keys give. Room recovery put to the placement
field reads **0.5451** over 34 rooms -- IDENTICAL to the prefix key's own leak, and sits well past
the digest key's lower 0.4745. Every one of the three checks this piece exists to run is an exact
equality, proven identical to eight decimal places, exact rather than approximate.

## The falsifier, fired exactly as named

Proposal 2's own stated falsifier was this: *the composite key's confidentiality reading falls to the
prefix-only key's high figure rather than holding near the digest-only key's low figure* -- which
would show that any declared placement field leaks enough for an observer to reconstruct room
membership, regardless of whether the rest of the key avalanches. That is exactly what happened.
**0.5451, exactly the prefix figure.** An observer handed a composite key is handed both fields, and
reads whichever one leaks the room -- concatenating an even, confidential field alongside a leaky
one hands the observer an extra field they can safely set aside. The leaky one stays exactly as
exposed as it was alone.

## Why round one's inference was half right

Round one's own arithmetic argument was: two independent fields carry two independent properties.
That argument is correct about **buying**, and this piece's equalities prove it directly -- storage
placement and locality genuinely compose, each field delivering exactly what it delivers alone, its
own statistics surviving concatenation intact. A real store COULD use the content field for even
storage placement while a wholly separate placement field serves locality queries, and both
properties would be had at once, where a single field before had to choose.

The argument breaks about **selling**, because confidentiality is a property of **which fields an
observer is handed**, rather than of how a field's bytes are arranged. Evenness and locality are
properties of a single field's own statistics, checkable by looking at that field alone; leakage is
a property of the whole bundle an observer receives. Composing two fields under one key composes
their statistics faithfully -- and hands both to whoever holds the key. A field designed to skip
avalanche is, by definition, a field designed to preserve a relation on its inputs, and a relation
preserved is a relation an observer can always read, concatenated or alone.

## What this sharpens, one door over

The tree's storage-key question -- how Tablecloth's eventual key should be shaped -- now has a
cleaner answer than either single-field reading offered alone: **split the fields, and treat them as
having different trust levels rather than different mathematical properties.** The content field
(even, confidential when held alone) can be safely exposed to a storage layer that needs to place
data evenly. The placement field (local, leaky) is safe to expose only to a reader already trusted
with room membership -- which is squarely an **access-control** decision, sitting past what key
design alone can settle. The two-field key leaves the trust question exactly where it stood; its
real contribution is separating that question cleanly from storage efficiency, a separation a
single field could only ever blur.

## What stays open

**Whether a real system can hand the placement field to an authorized locality reader while
withholding it from an untrusted one** is the access-control question left for a later measurement
-- it decides whether the locality buy comes free of the confidentiality sell, or costs it every
time, and it is precisely the door proposal 2's own closing note named as the remaining one, one
layer sharper now that the composition itself is proven rather than assumed. **Whether a FOLD of the two fields**
(hashing them together rather than concatenating them plainly) changes the answer is a different key
construction and wants its own reading -- this piece's finding is specific to plain concatenation,
where the two fields remain separately readable by construction. **A real store** stays untouched
here, as it has at every rung of this thread.

## What would falsify it

The scan's three checks are exact equalities rather than statistical readings, so falsification is
direct: any one of the three failing on the tree's own bytes, or on the TRADED planted population
where the two fields genuinely carry different information, would mean the fields interfere when
concatenated -- a genuine defect in treating them as independent that this piece's own reasoning
left unforeseen. `tools/c/composite_key_witness.rish` checks all three on both populations; the
LOCKSTEP population (both fields carrying the identical sweep) is the boundary case proving the
equalities hold even when the two fields carry identical information, with only one true signal
present, which is what makes TRADED the population that actually tests the claim rather than
trivially satisfying it.

---

*May every field we split carry exactly the property it was asked to, and may we always tell a
field concatenated from a field concealed.*
