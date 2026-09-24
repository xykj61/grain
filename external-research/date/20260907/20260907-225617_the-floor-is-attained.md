# The Floor Is Attained

**Stamp:** `20260907.225617`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- external research, **mixed room**: every count and every diameter here is
reproducible from the tracked program named below; the design reading at the end is proposed
(`../context/TWO_ROOMS.md`).
**Instrument:** [`../tools/rye/topology_gap_sweep.rye`](../tools/rye/topology_gap_sweep.rye) --
cross-checked against an independent all-pairs walk written in awk for this reading
**Elder:** [`the-floor-you-can-stand-on`](20260906-152821_the-floor-you-can-stand-on.md), whose
second falsifier this paper fires

*A paper that names a falsifier and nobody runs it has made a promise, not a test. This one runs
the elder's.*

---

## What this paper bounds

Every figure concerns **720 points** -- the size of the seated sky -- at **degree 6** and
**degree 5**, the two wire budgets already on the table. Every diameter was measured on
`20260907.225617` on this pier by breadth-first search on a graph the program builds. Nothing here
implements anything: `comlink/topology.rye` still publishes the seated three-ring reading alone.

## The sentence this fires

The elder paper named its own coverage gap plainly, and wrote its falsifier in three parts. This
is the second:

> *exhibit any degree-6 circulant on 720 points at diameter 8, and the sweep's reach was the
> binding limit rather than the family*

It is here. **`C_720(5, 55, 72)` walks at diameter 8**, which is the abelian floor exactly, and the
elder's own confidence on that sentence read **medium** for exactly the right reason.

## What was measured, and how

The elder sweep walked circulants with a **unit** generator -- 63,903 graphs of the form
`C_720(1, b, c)`. That covers every circulant holding a jump coprime to 720, since multiplying a
connection set by a unit gives an isomorphic graph. Three non-units can still generate, and those
triples stood outside it.

This sweep fixes nothing. It walks **all 7,647,059** triples `1 <= a < b < c <= 359`, which is
every degree-6 circulant on 720 points up to the order of its generators: a jump of 360 is its own
inverse and would land the graph at degree 5, so the pairs stop at 359.

```
RYE_ZIG=$PWD/vendor/zig-toolchain/zig ./rye/bin/rye build tools/rye/topology_gap_sweep.rye -O ReleaseFast
./topology_gap_sweep
```

**40 seconds** on this pier, ReleaseFast. A circulant is vertex-transitive, so one walk from vertex
0 gives the diameter; the program repeats the elder's cross-check of that reading, and an
independent all-pairs walk confirms every headline graph below.

## The reading

**Observation.** Of the 7,647,059 triples, **6,416,816 are connected** and **1,230,243 are not** --
a connection set whose three jumps share a factor with 720 generates a proper subgroup.

**Observation.** The best diameter over every connected graph is **8**, attained by **48** of them.

**Observation.** All 48 sit in the family the elder sweep could not see. Split by whether any
generator is coprime to 720:

| Family | Connected | Best diameter | Attainers at best | At or below the floor of 8 |
|---|---|---|---|---|
| holds a unit -- what the elder sweep covers | 4,649,648 | 9 | 95,280 | **0** |
| holds no unit -- the gap | 1,767,168 | **8** | 48 | **48** |
| `a = 1` -- the elder sweep exactly | 63,903 | 9 | 1,240 | 0 |

**The elder sweep reproduces to the number.** 63,903 graphs, best 9, 1,240 attainers: the same
three figures its own instrument published, from a program written independently a day later. That
agreement is what earns the rest of this table its credit.

**Inference.** The gap was not a sliver at the edge of the answer. It held **the whole** of it. The
covered family's best stays at 9 across 4.6 million graphs, and every graph that reaches the floor
lies outside it.

## The exhibit, and there is only one of it

`C_720(5, 55, 72)` -- `gcd(5, 720) = 5`, `gcd(55, 720) = 5`, `gcd(72, 720) = 72`, and
`gcd(5, 55, 72) = 1`, so it generates. Measured by all-pairs walk over all 517,680 ordered distinct
pairs: **diameter 8, mean hops 6.1210**.

| Shape | Degree | Diameter | Mean hops | Over Moore floor 4 | Over abelian floor 8 |
|---|---|---|---|---|---|
| torus 12x5x12 -- the seated shape | 6 | 14 | 7.2100 | 3.50 | 1.75 |
| `C_720(1, 8, 75)` -- the elder's best | 6 | 9 | 6.3004 | 2.25 | 1.12 |
| **`C_720(5, 55, 72)`** | 6 | **8** | **6.1210** | 2.00 | **1.00** |

**Observation.** The 48 attaining connection sets are **exactly the orbit of `{5, 55, 72}` under
multiplication by the 192 units modulo 720** -- checked set by set, and the two lists are
identical. So **up to isomorphism there is one** degree-6 circulant on 720 points at the abelian
floor, and the 48 are one graph wearing 48 labellings.

**Observation.** Every one of the 48 holds either **72** or **216** as a generator. `72` generates
the subgroup of order 10, and `216` is three times it.

**Inference, offered as structure rather than as theory.** A connection set built from one coarse
jump that closes a short cycle of cosets, plus two finer jumps that move inside them, is a
**hierarchy** rather than an odometer. That is a different legibility from the three-ring reading,
and it is not obviously worse -- yet nothing here proves it is the mechanism, and a single orbit is
a sample of one.

**Observation.** The mean hardly moves again. From 9 to 8 on the diameter is 11.1 percent; 6.3004
to 6.1210 on the mean is **2.85 percent**. The elder paper found the same split one step earlier,
and it holds at the bottom: **the last hop lives entirely in the tail.**

## The degree-5 leg -- not an accident of one wire budget

A cyclic group of even order holds exactly one involution, so every degree-5 circulant on 720
points is `{360, +-b, +-c}`: **64,261** graphs, walked whole in the same run. **41,328** are
connected. The elder derived the abelian floor at degree 5 as **14**.

**Observation.** The best is **14**, attained by **672** graphs, the first being
`C_720(360, 1, 82)` -- confirmed at diameter 14 by the independent all-pairs walk.

**Inference.** Attaining the abelian floor on 720 points is not a degree-6 accident: it happens at
both wire budgets on the table. A designer holding this ring size can plan against the floor rather
than against a search.

**And the asymmetry is worth naming.** The degree-5 attainer holds the unit generator 1, so the
elder's unit-fixing convention would have found it. The convention cost nothing at degree 5 and
cost the whole answer at degree 6, which is what makes a named coverage gap worth more than a
confident number.

## What this does to the elder's design reading

The elder framed the trade as **the longest walk against legibility**: five hops off the seated
torus, paid for with generators chosen by search. Two things move.

**The price rises by one hop, and the legibility falls further.** `C_720(1, 8, 75)` at least reads
as a mixed-radix odometer with a unit stride. `C_720(5, 55, 72)` has no unit at all: no generator
steps by one, and no coordinate reading survives. Against the seated torus it is **42.9 percent**
off the diameter and **15.1 percent** off the mean.

**The floor stops being an aspiration.** A designer can now say what the best commutative
arrangement of six edges on 720 points actually costs -- 8 hops -- rather than what it might cost.
Whether the seated shape should move is unchanged as a question, and it can now be asked against a
number that no further search will improve.

## What is measured, what is derived, and what is outside

**Measured.** Every count, diameter, and mean above.

**Derived, and inherited.** The abelian floor of 8 at degree 6 and 14 at degree 5, taken from the
elder paper, whose instrument checks the closed form against a direct enumeration of the lattice
ball at every radius from 0 to 10.

**Outside.** Whether any of these shapes is a good idea. Resilience under a lost edge, how a route
is computed from an address, and what a person can hold in their head are three properties this
measurement does not touch, and the last of them is where the exhibit is weakest.

## Horizon, assumptions, falsifier, confidence

*Horizon: this holds for 720 points at degree 5 and 6, and says nothing about another ring size.
Assumptions: distance is hop count on an undirected graph; every degree-6 circulant on a cyclic
group of order 720 has the form used here; the abelian floor is the elder's, derived and checked
there rather than re-derived here.*

*Falsifier, in two parts, and both are cheap. **First:** exhibit a degree-6 circulant on 720 points
at diameter 7. The floor derivation says none exists, so producing one falsifies the floor, this
paper's 1.00 ratio, and the elder's table together -- one walk decides it. **Second:** re-run the
sweep with a distinct breadth-first implementation and a distinct triple enumeration; if the
attainer count leaves 48 or the best leaves 8, this sweep has a fault the awk cross-check did not
reach, since that check confirmed three named graphs rather than the enumeration around them.*

*Confidence: high on the exhibit and its diameter, which two independent implementations walked and
agreed on; high on the family split and the counts, which come from one exhaustive enumeration
whose covered slice reproduces the elder instrument's three published figures exactly; high on the
48 being one orbit, checked set by set; medium on the hierarchy reading of `72` and `216`, which is
structure observed on a single orbit rather than a mechanism proven; low on whether a shape with no
unit generator is one a person should want, which is a judgment and stays one.*

## Gratitude

The degree-diameter problem, the Moore bound, and the isomorphism of circulants under unit
multiples of the connection set come from the graph-theory literature, studied rather than
borrowed. Every graph here was built and walked in this tree, on this bench, on the stamp above.
