# The field that proves safety breaks the cycle

**Stamp:** `20260917.214608`
**Room:** checkable -- every reading below is emitted by one witness under one green pass on this
pier at this stamp.
**Status:** Landed -- a second reading of row 3 of
[`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
("Cyclic topos"), beside the elder `cyclic_witness` reading and beside definition one of
[`20260917-204915_bounded-cyclic-computing.md`](20260917-204915_bounded-cyclic-computing.md).
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Instrument:** [`../tools/rye/cyclic_state.rye`](../tools/rye/cyclic_state.rye), proven by
[`../tools/c/cyclic_state_witness.rish`](../tools/c/cyclic_state_witness.rish), rostered as guard
`cyclic_state` at `tier cadence`.

---

## What this answers, and why a second reading was worth building

Row 3's own first witness asked for one existing witness rewritten so the hash of its exit state
equals the hash of its entry state. The elder reading, `cyclic_witness`, answers that at the level
of the whole tree: it hashes `git status --porcelain` before and after a rostered witness runs, and
reports whether the tree came back clean. That is the right question for whether a witness leaves
residue, and it says nothing about whether the DATA STRUCTURE inside a witness that claims to be
cyclic actually is one.

`wrap_ring.rye` -- row 1's own witness, "the wrap is the bound" -- is exactly such a structure: a
ring of fixed circumference that the bounded-cyclic-computing paper's own definition one reads as
"a bound is a period." This file asks the row 3 question of that same ring directly: hash its state
before and after a lap, rather than hashing the tree around it.

## The method: two digests, because "state" is not one thing

A ring page carries two kinds of information -- the bytes it holds, and the lap number that wrote
them, the field `wrap_ring`'s own refusal mechanism depends on to catch a reader holding a recycled
page. `cyclic_state.rye` takes a Keccak-256 digest of each, separately, at four points: construction
(zeroed), after one full lap of a constant fill byte, and after a second identical lap.

## Reading one: the row's own wording fails immediately, and says why

Read `20260917.214608` on this pier:

```
cyclic-state: content digest does NOT return to entry (zeroed) after one lap -- entry-vs-exit is
the wrong comparison here
```

A ring starts zeroed and ends filled with a non-zero byte, so entry can never equal exit under any
honest write. Taking the row's wording literally -- exit hash equals entry hash -- asks a question a
written-to ring can never answer yes to. The corrected question is whether the ring reaches a FIXED
POINT it never leaves, which is a cycle of period one measured from wherever the ring settles,
rather than a return to a state it only ever held before anything wrote to it at all.

## Reading two: content settles, and stays settled

```
cyclic-state: content digest reaches a fixed point at the end of lap one and holds through lap two
(period 16)
```

Under a constant fill byte, every page holds the same value from the end of lap one onward -- lap
two's writes rewrite each page to the value it already carries, so the byte-content digest is
identical across every later lap. Content genuinely cycles, at the ring's own circumference, once
you compare lap-to-lap rather than entry-to-exit.

## Reading three: full state never cycles, and the reason is the safety property itself

```
cyclic-state: full-state digest differs lap one to lap two and will differ on every later lap too --
the lap tag never returns
```

`Ring.lap()` is `written / circumference`, and `written` only grows. Every page's lap tag is 0
throughout lap one and 1 throughout lap two, and no later lap number can ever equal an earlier one.
So the full state -- bytes plus lap tag -- is not merely slow to cycle; it is structurally
non-periodic, forever, by the same field that makes `read_held` able to refuse a recycled page.

**This is the load-bearing finding.** The field a ring needs to prove memory safety (a monotone lap
counter, so a reader can tell whether their page survived) is the same field that guarantees the
ring's full state never repeats. Period and safety are not merely two properties of one ring; on
this structure, the property that buys safety is the one that costs periodicity.

## What this means for the paper the two rows already support

`20260917-204915_bounded-cyclic-computing.md`'s definition one reads `wrap_ring` as evidence that "a
bound is a period," and treats definition two's cycle claim as the same shape read a second way. This
witness shows a finer distinction sitting inside definition one's own evidence: `wrap_ring` is
periodic in the sense that matters for its BOUND (content stays inside C pages, and the index wraps
exactly on schedule), and it is *not* periodic in the sense definition two's language reaches for
(a proof returning to its own start state) once the structure's own safety field is counted as part
of that state. A bound and a full return are not the same claim, even on one small ring built to
demonstrate both.

## Falsifier, restated for the next reader

The claim that "the field which proves safety is the field which breaks the cycle" would fall if a
structure existed whose safety-proving field were itself periodic -- for instance, a lap counter
taken modulo some second period rather than left to grow forever. `wrap_ring` was built without that
choice, on purpose, because a wrapping lap counter would need its own wrap-safety argument one level
up, and moonshot 1's whole point was keeping that argument to one level. A future ring built with a
bounded lap counter would need this witness run again against it before the finding could be called
general rather than particular to this one structure.

## What this leaves open

Whether the tension generalizes -- whether every structure whose safety proof needs an
ever-growing counter is thereby barred from full-state periodicity -- is a question about a CLASS of
structures, and this witness answers about exactly one. The `cyclic_witness` reading and this one
now stand as two different lenses on row 3, at two different grains: one asks whether a witness
disturbs the tree around it, the other asks whether a witness's own claimed cycle survives a
closer look at what "state" means. Neither replaces the other.
