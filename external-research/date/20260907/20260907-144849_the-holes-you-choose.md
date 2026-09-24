# The holes you choose

**Stamp:** `20260907.144849`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Research -- measured readings a design argument may cite; nothing here is implemented
**Room:** external-research -- research for understanding, read through the doorway of separation
**Witness:** [`../tools/t/topology_occupied_witness.rish`](../tools/t/topology_occupied_witness.rish) over [`../tools/fixtures/t/topology_occupied_scan.sh`](../tools/fixtures/t/topology_occupied_scan.sh) and [`../tools/fixtures/t/topology_occupied_control.sh`](../tools/fixtures/t/topology_occupied_control.sh)
**Elder:** [`20260907-111058_the-size-you-actually-have.md`](20260907-111058_the-size-you-actually-have.md) -- this paper fires that one's second falsifier

---

## What this measures, bounded before the numbers

Two **(n,k)-star** graphs, built and holed and walked exhaustively on this pier on `20260907`:
S(6,3) at 120 vertices on degree 5, and S(7,4) at 840 vertices on degree 6. Sixteen occupancy
configurations across four named hole geometries. Every live pair of every configuration is routed
by three rules to three sampled targets -- 46,000 routes in all -- and every stretch is measured
against a breadth-first walk **through live members only**, since a packet may not pass through a
member that is not there.

Every reading stops at 840 vertices and at 50 percent occupancy. Nothing here is implemented:
[`../comlink/topology.rye`](../comlink/topology.rye) publishes the seated three-ring reading and no
shape on this list. These are numbers a design argument may cite
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).

## The falsifier this fires

The elder paper measured seventeen graphs and found a rule -- the **chain rule** -- that routes
every vertex of every one of them by a shortest path, reading only the packet's own address and its
target's. It closed by naming three falsifiers and firing none, and the second one was the one a
deployment meets first:

> Every reading here assumes all `n!/(n-k)!` vertices are occupied. A supervision tree with 800
> members on an 840-vertex shape has 40 holes, and a rule that walks into one has to do something.
> If the answer needs a table of live members, the free-routing claim does not survive contact with
> a real membership.

That doubt is well aimed, because holes are the **ordinary case rather than the edge**. An
(n,k)-star offers 840 vertices, then 990, then 1,320; a membership arrives at whatever number it
arrives at. Any real deployment of this shape runs partly empty, always.

**The question is narrower than the doubt, and the narrowing is the whole paper.** A node already
knows which of its own `n-1` neighbours answer -- degree-many bits, refreshed by the supervision the
shape exists to carry, and steady as the membership grows. So the honest
question is whether **neighbour liveness** is enough, and it has a number.

## Three rules, and what each loses

Each rule ranks the same `n-1` neighbours in the same order -- the chain rule's own preference,
extended over the whole neighbourhood rather than the handful of moves it names -- and they differ
only in what they are allowed to see.

| Rule | Sees | State it carries |
|---|---|---|
| **blind** | the two addresses | none -- the published rule, exactly |
| **local** | the two addresses, plus which neighbours answer | none |
| **trace** | the same, plus where this packet has already been | the path, in the packet |

At **S(7,4), 840 vertices, 798 live** -- which is the elder paper's own headline shape carrying
five percent holes -- across 2,391 routed pairs:

| Rule | Delivered | Lost into a hole | Lost to a cycle | Mean stretch | Max stretch |
|---|---|---|---|---|---|
| blind | 2,001 | **390** | 0 | 0 | 0 |
| local | 2,162 | 0 | **229** | +0.017 | 2 |
| trace | **2,391** | 0 | 0 | +0.304 | 6 |

**Observation.** The published rule loses **one packet in six** with five percent of the shape
empty. At ten percent it loses 632 of 2,265, better than one in four.

**Observation.** Filtering by neighbour liveness stops every hole loss and starts a different one:
`local` delivers 90.4 percent and spends the remainder circling until the hop cap. It keeps moving throughout --
there is always some live neighbour -- and simply revisits.

**Inference.** What the rule lacks is therefore **memory, not a table**. Those are two different
purchases, and one of them scales with the membership while the other stays fixed.

**Observation.** A packet carrying the vertices it has already stood on, and retreating one hop when
every ranked neighbour is dead or already visited, delivered **every reachable pair of every
configuration measured** -- sixteen configurations, four hole geometries, occupancies from 95 down
to 50 percent, zero undelivered. It pays a mean of **+0.30 hops** at 95 percent occupancy and
**+1.53** at 75 percent.

## What the trail costs, which is the number the claim turns on

A packet carrying tens of entries is a path record. A packet carrying hundreds is a table of live
members wearing a different coat, and the free-routing claim would end there.

| Occupancy of S(7,4) | Live | Largest visited set any packet carried |
|---|---|---|
| 95 percent | 798 | **13** |
| 90 percent | 756 | **16** |
| 75 percent | 630 | **25** |

**Observation.** The state is bounded by the walk rather than by the membership: 25 entries at
three-quarters occupancy on a shape of 840, against a live diameter of 8.

**Inference.** The claim survives its falsifier **with an amendment**, and the amendment is worth
stating in the terms a builder cares about: *free routing under holes asks for one thing only --
that the packet remember where it has been -- and for no per-node table or membership view at all.* That is the same trade a
loop-free source route makes, at a size the address already affords.

**Projection.** *Horizon:* shapes to roughly ten thousand vertices, occupancies at or above three
quarters. *Assumption:* the visited set grows with the live diameter rather than with the vertex
count, which is what these three readings show and what a longer walk would test. *Falsifier:* should
S(9,4) at 3,024 vertices want a visited set materially larger than its live diameter times a small
constant, the state is tracking the shape rather than the path, and this projection falls.
*Confidence:* moderate, on three points of a curve.

## The finding a builder can act on: which holes, not how many

The four hole geometries were chosen because a real membership meets each -- a scattered loss, a
contiguous address range, and a whole rack. At **S(7,4)**, holding the count fixed where it can be:

| Hole geometry | Holes | Components | Live diameter | Blind rule's loss |
|---|---|---|---|---|
| **far-end class** -- every vertex whose last position holds symbol 7 | 120 | 1 | 7 | **0** |
| **two far-end classes** | 240 | 1 | 7 | **0** |
| **door class** -- every vertex whose FIRST position holds symbol 7 | 120 | **4** | 6 | 0, on 837 of 2,157 pairs |
| **scattered** | 42 | 1 | 7 | 390 of 2,391 |
| **contiguous block** | 84 | 1 | 7 | 801 of 2,265 |

**Observation.** Removing a whole far-end symbol class -- **120 vertices, one seventh of the shape**
-- costs nothing measurable. Every rule, the blind one included, delivers every pair with **zero
stretch**, and the diameter does not move. Two classes, 240 of 840 gone, read the same.

**Observation.** Removing a **door** class of exactly the same size splits the shape into **four
components**, the largest holding 360 of the 720 survivors.

**Inference.** In this family, position 1 is the door every move touches and the far positions are
not. Emptying the far end takes vertices the routes between survivors leave alone; emptying the door
takes the moves themselves.

**Inference, and it is the actionable one.** **Which addresses you leave empty is a design variable,
and it is free to choose.** A supervision tree of 720 members on an 840-vertex shape can seat them
so that the 120 empty addresses are one far-end class -- and then the published rule, with no
liveness knowledge at all, routes every pair optimally. The same 120 holes taken at random cost a
sixth of the traffic; taken at the door, they cost half the membership its reachability.

**Projection.** *Horizon:* the (n,k)-star family, memberships that are a multiple of `n!/(n-k)!/n`.
*Assumption:* that a deployment chooses its own addresses -- true of a supervision tree, and false
of a network of pre-existing identities. *Falsifier:* a membership landing between whole
classes -- 800 on 840, say -- leaves 40 holes with no class to hide them in, and the finding above
is silent on the best partial-class arrangement. *Confidence:* high on the measurement
at these two shapes, low that the free geometry generalises to families outside this one.

## The reading that nearly told a comfortable lie

With one door class removed, the delivery line read **837 of 837 delivered, zero dead ends, zero
stretch** for all three rules. It was a perfect score on a partitioned network.

The arithmetic was right; the subject had moved. The scan excludes a pair whose target is
unreachable, because a partition is the **shape** refusing rather than the rule failing -- and
excluding it *silently* is how a partition comes to read as perfection. The number that tells the truth here is
the count of pairs excluded, and it now stands on the same line: **`unreachable=1320`** beside
`delivered=837`.

This is the family REDS `%463` named one room over -- a census that reads nothing and reports all clear
looks exactly like a healthy file -- reached through a different door. The witness binds
that count where the partition is, so the shape cannot go quiet again.

## Against the shape a builder reaches for instead

At **equal points and equal degree** -- 840 vertices, degree 6 -- the best three-ring torus is
7 x 8 x 15, and it meets the same hole sets under the same three rules.

| Occupancy | Star, memoryless | Torus, memoryless | Star, with trail | Torus, with trail |
|---|---|---|---|---|
| 90 percent | 312 of 2,265 lost (13.8%) | **303 of 755 lost (40.1%)** | +0.43 hops | **+0.77 hops** |
| 75 percent | 638 of 1,887 lost (33.8%) | **299 of 629 lost (47.5%)** | +1.53 hops | **+3.08 hops** |

**Observation.** The torus's memoryless rule **dead-ends** where the star's merely cycles. A
coordinate rule that only steps closer arrives at a hole with its whole option set spent, so it
stops; the star's rule always holds another ranked neighbour.

**Inference.** Degree 6 spent on three rings buys fewer escape routes than the same degree spent on
a star's door, and holes are where the difference shows. The elder paper's finding was that the star
family reaches 7 hops where the torus reaches 14; this one adds that the gap **widens** under holes
rather than closing.

## Coverage gaps and the falsifiers

**Horizon.** Two shapes, 120 and 840 vertices, measured `20260907` on this pier. Sixteen
configurations, occupancies from 95 to 50 percent, four hole geometries, three targets sampled per
configuration.

**Assumptions.** That hop count is the cost worth counting. That neighbour liveness is genuinely
local -- degree-many bits a supervision layer already refreshes -- rather than a table in disguise.
That a packet may carry its own visited set, which costs address space in every hop. And that three
targets stand for the shape, which is **weaker here than in the elder paper**: a hole set destroys
vertex-transitivity, so one target no longer stands for all of them, and the scan prints the sample
size on every line rather than hiding it.

**Falsifiers, in the order I would fire them:**

1. **A partial class.** The free-geometry finding is measured only at whole classes -- 120 and 240 of
   840. A membership of 800 leaves 40 holes, which is a third of a class, and nothing here says what
   the best 40-hole arrangement is or whether it is anywhere near free. This is the cheapest to
   fire: hole one class partially and read the same table.
2. **The visited set at scale.** Twenty-five entries at 840 vertices is small. If S(9,4) at 3,024 or
   S(9,5) at 15,120 needs a set that grows with the vertex count rather than with the live diameter,
   the trail stops being a path record and the amendment above fails.
3. **Churn rather than holes.** Every reading here is a **static** occupancy: the hole set is chosen
   once and the whole routing pass runs against it. A real membership changes while packets are in
   flight, and a retreating packet holding a stale trail may retreat toward a member that has since
   left. Nothing here measures that, and it is the difference between a shape that survives a census
   and one that survives a Tuesday.
4. **Instructions rather than hops.** The candidate scan is counted; nanoseconds await their own instrument. The
   memoryless rule scans 164 candidates per delivered pair at 95 percent occupancy against the
   retreating rule's 30, which is a real difference in the direction the paper argues, and it is
   still not a wall-clock number.

**Confidence, in plain words.** *High* that the measured numbers are what these two graphs and three
rules do under these sixteen hole sets -- every pair is routed exhaustively, under 37 planted
behaviors. *High* that the published rule loses packets into holes, since it is measured from both
sides and the anchor proves the rule is the same one. *High* that a far-end class is free at these
two shapes, since blind, local and trace all read zero stretch independently. *Moderate* that the
trail stays bounded by the path at larger sizes; falsifier 2 is exactly that doubt. *Low* that any
of this survives churn, since falsifier 3 is unfired and is the one a running system meets every
day.

## What the instrument does that its readings cannot

The scan reads **its own source** before printing a verdict and refuses when any routing function
mentions the breadth-first distance array. That leg exists because it is the one fault the output
can never show: a rule that quietly consulted the walk would print perfect delivery and zero
stretch, which is exactly the table-bound case wearing the table-free answer.

Two faults were caught by the instrument's own arithmetic while it was being written, and both are
worth recording, since each would have read as healthy in a summary. **Crediting the blind rule with
deliveries it made through dead members** produced a **negative** mean stretch -- a route shorter
than the shortest path, which is impossible, and which is exactly why it was caught. And **a relabel
defined on only the target's `k` symbols** falls short of being a function: the other `n-k` symbols
keep their names and collide with the images of the mapped ones, which showed up as targets dead-ending at eight
times the identity's rate. The control plants both again, and lifts them, since a refusal proven only
in the passing direction reads exactly like a bypass.
