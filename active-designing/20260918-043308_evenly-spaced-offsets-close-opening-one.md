# Evenly spaced offsets close Opening One -- 52 beats 33, and a closed form beats a search

**Stamp:** `20260918.043308`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- a checked mathematical claim with brute-force confirmation; no witness on
metal exists yet for the tree's own `torus_place_scan.sh`, which is named as the buildable item
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md`](20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md)
(Opening 1, whose falsifier this piece fires against) -
[`../tools/fixtures/t/torus_place_scan.sh`](../tools/fixtures/t/torus_place_scan.sh) (the reading
one, three, and ring4wide's measured 33 this piece beats) -
[`date/20260910/20260910-060204_the-bounded-torus-moonshots.md`](date/20260910/20260910-060204_the-bounded-torus-moonshots.md)
(row 5, the master ranking both openings answer to)

## The one sentence this piece is for

Opening 1 asked whether a small search over offset sets beats the free-choice ring's already-measured
run-kill length of 33; a closed form answers instead of a search, and the answer is **52**, a 58%
gain -- reached by spacing the replica offsets as evenly as possible around the ring rather than by
searching for them.

## What was computed, and how

The metric is `torus_place_scan.sh`'s own reading 3: the shortest contiguous run of storage indices
whose loss destroys every copy of some cell, for a replica set of `k` offsets (including the cell
itself) on a ring of `C` storage cells. Because the ring is vertex-transitive, this reduces to one
number for the whole offset set: sort the `k` offsets around the circle, take the largest gap
between consecutive ones (wrapping), and the run-kill length is `C - max_gap + 1`.

**Maximizing run-kill length is minimizing the largest gap.** For any way of splitting `C` into `k`
positive gaps, the largest one is at least `ceil(C/k)` -- an even split (gaps of `floor(C/k)` and
`ceil(C/k)`, mixed to sum to `C`) is the best any partition can reach, and it achieves that bound
exactly. So the closed-form maximum is:

```
runkill_max(C, k) = C - ceil(C/k) + 1
```

**Checked two ways.** First, an exhaustive brute force over every size-`(k-1)` subset of offsets
from `{1, ..., C-1}` (the fixed `0` offset is the cell itself) at the tree's own `g=8`, `C=64`,
`k=5` -- the exact configuration round one measured `ring4wide` at 33. `C(63,4) = 595,665`
combinations, each scored in one pass:

```
best runkill= 52  offsets= (0, 12, 25, 38, 51)
```

Second, the same brute force at three more `(C, k)` pairs, checked against the closed form:

| C | k | brute-force best | `C - ceil(C/k) + 1` | agree |
|---|---|---|---|---|
| 16 | 5 | 13 | 13 | yes |
| 36 | 5 | 29 | 29 | yes |
| 64 | 4 | 49 | 49 | yes |
| 100 | 5 | 81 | 81 | yes |

Every brute-force maximum matches the closed form exactly, at four `(C, k)` pairs beyond the one
round one measured. This stands as confirmation across a small sample of configurations. The
pigeonhole argument above carries the actual proof; the brute force checks that the argument was
applied correctly.

## Reading the elder numbers against the new one

| Rule | Offsets (C=64, k=5) | Run-kill | Source |
|---|---|---|---|
| `torus4` | `{0, 1, -1, 8, -8}` | 17 | round one, closed form `2g+1` |
| `ring4adj` | `{0, 1, -1, 2, -2}` | 5 | round one, closed form `5` |
| `ring4wide` | `{0, 8, -8, 16, -16}` | 33 | round one, closed form `4g+1` |
| `evenspread` | `{0, 12, 25, 38, 51}` (or `{0,13,26,38,51}`, same run-kill) | **52** | this piece |

`evenspread`'s own gaps are `{13,13,13,13,12}` -- as close to `C/k = 12.8` as five integers summing
to 64 can sit. The rule stays plain: place the offsets at multiples of `round(C/k)`, and let the
last gap absorb whatever remainder is left over.

## Falsifier, read against the claim it was aimed at

Opening 1's own falsifier: *the best offset set the search finds reads at or below round one's
already-measured 33 -- which would mean round one's free-choice ring was already near-optimal.*
That falsifier stays quiet: 52 stands 58% above 33, and the elder ring turns out to have been one
reasonable guess among many, with a better one sitting the whole time in plain arithmetic.

**A new falsifier for this piece's own claim.** A `(C, k)` pair where the brute-force maximum falls
below `C - ceil(C/k) + 1` would reveal a gap the four checked cases left standing in the pigeonhole
argument above. All four agreed with the closed form; a fifth reader finding disagreement on a
fifth pair is the signal worth watching for.

## What this changes about Opening 1's own plan

Opening 1 proposed extending `torus_place_scan.sh` to *search* offset sets. The closed form replaces
that search for the general case -- the optimum arrives by arithmetic -- while a search stays the
right tool where a later reading adds a constraint the closed form leaves open: offsets restricted
to powers of two, say, or to values reachable by one bitwise operation, which a real placement rule
might want for cheap computation over a division.

## What Bakery could pick up, and what stays here

**Buildable now:** add a fourth rule, `evenspread`, to `torus_place_scan.sh`'s reading 3, computed
as `offsets[i] = round(i * C / k)` for `i` in `0..k-1`, alongside the three existing rules and their
closed-form checks (`runkill_ring4adj_closed`, `runkill_ring4wide_closed` already exist as a
pattern to extend with `runkill_evenspread_closed = C - ceil(C/k) + 1`). The two-line closed form is the whole addition,
and the witness can assert the emitted number against the four `(C, k)` pairs this piece already
checked by hand.

**Stays here, named as vision:** how close a placement rule constrained to bitwise-cheap offsets
(the kind a real store would actually compute per write) can land to 52, and whether the run-kill
metric itself is the right failure model for a medium this tree has yet to name a store for -- both
open questions the elder scan's own header already leaves standing.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line. `construction/ITINERARY.md`
gains one line naming the buildable item for Bakery.

May the next reader who reaches for a search remember to ask, first, whether the shape they are
searching for already has a name.
