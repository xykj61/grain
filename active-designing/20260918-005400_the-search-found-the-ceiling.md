# The search found the ceiling

**Stamp:** `20260918.005400` -- **Status:** Checkable -- `tools/t/torus_offset_search_witness.rish`
GREEN on metal, 13 behaviors, two grids, one mutation bitten.
**Room:** checkable -- an arithmetic claim bound by a witness rather than a projection.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Kin:** [`20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md`](20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md)
(proposal 1, this piece's parent question),
[`date/20260915/20260915-175000_the-axis-that-carried-nothing.md`](date/20260915/20260915-175000_the-axis-that-carried-nothing.md)
(round one's own reading 3, the two hand-picked points this piece re-reads)

---

## The question, restated once

Round two's first proposal asked whether round one's ring-declustering measurement had compared
the right two points. `tools/fixtures/t/torus_place_scan.sh` reading 3 measured the shortest
contiguous run of storage indices whose loss destroys every copy of some cell -- the
**declustering spread** -- for three placement rules on a 64-cell grid: a torus's own fixed
offsets (survives 17), a ring taking its nearest four neighbours (survives 5), and a ring free to
choose offsets of one and two rows (survives 33). All three matched their closed forms, and the
free-choice ring won. **Proposal 1 asked whether some OTHER offset choice, in the same shape
family, beats 33** -- because two measured points show what those two points do, and the family's
best member stays an open question until it is searched.

## What was built, and what it found

`tools/fixtures/t/torus_offset_search_scan.sh` generalizes the one free parameter round one's two
points already share: both are members of the shape `{d, -d, 2d, -2d} mod C` -- five copies
including the cell itself -- differing only in `d` (round one tried `d=1` and `d=g`). The new scan
sweeps every `d` from 1 to `C/2` and reports the best run-kill length found, at the same 64-cell
grid round one used.

**The result.** `d=13` survives a run of **52** -- well past 33, and exactly equal to
`C - ceil(C/5) + 1 = 64 - 13 + 1 = 52`, the theoretical ceiling for five points splitting a ring
of 64 cells as evenly as the integers allow. Five points can cut a ring into at most five gaps;
the run-kill length is the ring size minus the widest gap plus one, so it is maximized exactly
when the gaps sit as even as possible -- each near `C/5`. **The search reached the criterion's
own maximum**, past whatever a hand-picked guess might have found.

A second grid, `g=32` (`C=1024`), repeats the shape: the elder closed form `4g+1=129` reproduces
correctly, and the search finds `d=205`, run-kill 820 -- again exactly the theoretical ceiling,
`1024 - ceil(1024/5) + 1 = 1024 - 205 + 1 = 820`.

## Why round one's two points were never going to be the maximum

`d=1` and `d=g` both came from the offsets a torus and a ring already supply by construction --
"nearest neighbour" and "one row over" -- rather than from the criterion that actually governs
declustering spread. A hand-picked shape inherited from a data structure's own geometry stands in
loosely for a spacing criterion the structure was built for other reasons entirely. Once the
criterion is named explicitly -- five points, evenly spaced, on a ring of known size -- the
arithmetic answer follows directly, and the search verifies the closed-form guess against every
integer up to `C/2`, so the guess earns its confidence rather than assuming it.

**This sharpens proposal 2's own open door rather than closing it.** Round two's second proposal
asked whether a two-field key could buy locality and confidentiality from two fields at once. This
finding says the SAME thing about placement offsets: a criterion chosen on purpose (even spacing)
beats a criterion inherited by accident (a data structure's own fixed axis), in both cases because
naming the actual goal and solving for it beats borrowing whatever shape happened to be at hand.

## What stays open

**A fully generic four-offset search** -- freed from the `{d,-d,2d,-2d}` shape -- is a larger,
harder question this piece leaves for a future round; the arithmetic bound above (five points,
five gaps, evenness) hints the generic search would land at the same ceiling by a different route,
which stays a conjecture until it is run. **Whether five copies is the right replica count** for a
real store is round one's own inherited assumption, carried forward as-is. **A real store** stays
untouched here; this reading measures one integer's effect on one circular arithmetic quantity.

## The falsifier

The scan's own gate reproduces both elder closed forms and holds the search's best answer at or
above the hand-picked point it already knows. The FINDING itself -- that the search reaches the
exact theoretical ceiling, past merely beating 33 -- stands on two grids; a third grid finding the
search's best answer short of `C - ceil(C/5) + 1` would falsify it, pointing to an error the
closed-form reasoning above carries that the two tested grids happened to miss.
`tools/t/torus_offset_search_witness.rish` tests `g=8` and `g=32`; a third grid is one flag away
for the next reader who wants to press on it.

## What comes next, and why it waits

Round two's proposals 2 and 3 stand open, with proposal 3 already closed at zero cost by an
earlier lap on this same pier. Proposal 2 -- the two-field key -- is the more interesting
remaining door: a genuine design choice for Tablecloth's eventual key shape, resting on an
inference this piece's own finding echoes structurally (a criterion named on purpose beats one
inherited by accident) and still waiting on its own check against the channel that could defeat
it, a placement field leaking through some path beyond direct observation. Taking it up asks its
own claim first, per this fleet's own convention.

---

*May the offsets chosen on purpose always beat the ones handed down by a shape's own accident.*
