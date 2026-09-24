# The address read from the other end

**Stamp:** `20260907.173400`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Research -- measured readings a design argument may cite; nothing here is implemented
**Room:** external-research -- research for understanding, read through the doorway of separation
**Witness:** [`../tools/t/topology_partial_witness.rish`](../tools/t/topology_partial_witness.rish) over [`../tools/fixtures/t/topology_partial_scan.sh`](../tools/fixtures/t/topology_partial_scan.sh) and [`../tools/fixtures/t/topology_partial_control.sh`](../tools/fixtures/t/topology_partial_control.sh)
**Elder:** [`20260907-144849_the-holes-you-choose.md`](20260907-144849_the-holes-you-choose.md) -- this paper fires that one's closing falsifier

---

## What this measures, bounded before the numbers

Two **(n,k)-star** graphs, built and holed and walked on this pier on `20260907`: S(6,3) at 120
vertices on degree 5, and S(7,4) at 840 vertices on degree 6. **Five hole arrangements** at equal
hole counts, **42 whole classes** emptied one at a time, and a **hole-count sweep** from 4 to 60 on
the small shape -- 117 configurations in all. Every live pair of every configuration is routed to
twelve fixed targets by three rules, and every stretch is measured against a breadth-first walk
**through live members only**, since a packet may pass only through members that answer.

Every reading stops at 840 vertices and at 50 percent occupancy. Nothing here is implemented:
[`../comlink/topology.rye`](../comlink/topology.rye) publishes the seated three-ring reading and no
shape on this list. These are numbers a design argument may cite
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).

## The falsifier this fires

The elder paper found that **which addresses you leave empty is a design variable**, and that at
S(7,4) a whole far-end symbol class -- 120 of 840 vertices, one seventh of the shape -- costs
nothing measurable, where the same 120 taken at random cost a sixth of the traffic. It closed by
naming what that finding could not reach:

> A membership landing between whole classes -- 800 on 840, say -- leaves 40 holes with no class to
> hide them in, and the finding above is silent on the best partial-class arrangement.

The doubt is well aimed, because a class of S(7,4) holds exactly 120 members while a supervision
tree arrives at whatever number it arrives at. **A membership lands between whole classes
essentially always.**

## The hypothesis, and the shape of its refutation

The classes of an (n,k)-star **nest**. Fixing the last position of S(7,4) gives 840/7 = 120
vertices; fixing the last two gives 120/6 = 20; the last three, 20/5 = 4; all four, 1. So the sizes
a hole set can be built from are a **mixed-radix numeral** -- 120, 20, 4, 1 -- and 40 holes are two
whole classes of 20 rather than forty scattered losses. That ladder is derived by the falling
factorial and, in this scan, counted by grouping the vertices that actually share each suffix; the
two agree, and the scan refuses if they ever stop agreeing.

The hypothesis was that the greedy decomposition of any hole count into whole nested classes would
cost what the whole far-end class cost: nothing measurable. **The measurement refutes it**, and the way it
gives way is the paper's first finding.

## Finding one: the freedom does not descend the ladder

Every one of the 42 whole level-2 classes of S(7,4) was emptied in turn -- 20 vertices each, the
same size every time -- and the published rule was scored against one fixed target list.

| Reading across 42 equal whole classes | Value |
|---|---|
| Vertices removed, each configuration | 20 of 840 |
| Components remaining, each configuration | 1 |
| Live diameter, each configuration | 7, unmoved |
| Packets lost, **cheapest** class | **3** of 9,828 |
| Packets lost, **dearest** class | **491** of 9,828 |

**Observation.** Equal size, equal connectivity, equal diameter, and a **164-fold** spread in what
the choice costs.

**Inference.** The elder paper's freedom belongs to the **far-end class specifically** and does not
descend to the classes nested inside it. The finding a builder carries away is "empty the
*right* whole class" rather than "empty a whole class".

**A partial pattern, held loosely.** Sorting the 42 by the symbol each fixes at position `k-1`, the
mean loss runs 88 and 95 for symbols 7 and 6, against 171 to 358 for symbols 1 through 5. *Horizon:*
one shape, one target list of twelve. *Assumption:* that the pattern follows the symbol rather
than the addresses the twelve targets happened to occupy. *Falsifier:* the same table taken
at eight targets ranked symbol 5 among the cheap rather than among the dear, so a third target
count that moves the ranking again would say this pattern is sampling noise wearing a structure.
*Confidence:* low. The **164-fold spread itself** is a different matter -- it survived both target
counts and is what the finding rests on. *Confidence:* moderate.

## Finding two: the leftover addresses are nearly free

At the falsifier's own shape and its own count -- 800 live on 840 -- the five arrangements, scored
by the published memoryless rule against twelve fixed targets:

| Arrangement | What it is | Lost | Rate |
|---|---|---|---|
| **nested** | the first 40 addresses in **far-end-major** order | **429** of 9,588 | 4.5% |
| **block** | the first 40 in ordinary **door-major** order | 812 of 9,588 | 8.5% |
| **spread** | a deterministic hash over the address space | 1,156 of 9,588 | 12.1% |
| **class_partial** | 40 taken inside one far-end class, door-major | **1,410** of 8,789 | **16.0%** |

**Observation.** Arranging the holes cuts the published rule's loss from 12.1 percent to 4.5.

**Observation.** The obvious heuristic comes last of the five. `class_partial` is what a
builder reaches for having read the elder paper and stopped at "keep the holes in one class" -- and
taken door-major inside that class it costs a third more than scattering the holes at random.

**Inference.** The elder finding sits one sentence away from a harmful simplification, which is
why this reading is published beside the encouraging one.

**The answer to the doubt itself.** The falsifier asks what the *leftover* costs -- the addresses no
class can hold. Two more holes than two whole classes:

| Holes | Live | Arranged loss | Rate |
|---|---|---|---|
| 40 -- exactly two whole classes | 800 | 429 of 9,588 | 4.5% |
| **42 -- two classes plus a remainder of 2** | 798 | **457** of 9,564 | 4.8% |

**Observation.** The two addresses that fall outside every class cost 28 further packets, on a
base of 429.

**Inference.** A membership landing between whole classes pays the class-aligned price plus a
rounding error. The curve stays smooth across the class boundary, where the falsifier expected a cliff.

**And the rule that carries its trail still delivers everything** -- every reachable pair of all 117
configurations, zero undelivered. What the arrangement buys there is cost rather than delivery:

| Arrangement at 800 live | Mean stretch | Largest visited set carried |
|---|---|---|
| nested | **+0.05 hops** | **11** |
| spread | +0.11 | 12 |
| class_partial | **+0.81** | **26** |

**Inference.** The arrangement is worth roughly **sixteenfold** in the stretch the memory-carrying
rule pays, and better than twofold in the state the packet carries. The elder paper's amendment --
free routing under holes asks only that the packet remember where it has been -- survives, and the
arrangement sets the size of that "only".

## Finding three: the same run partitions, or does not, by which end is significant

This is the finding a builder can implement this afternoon, and it is one line of allocator code.

`nested` and `block` are **the same policy**: hand out a contiguous run of addresses. They differ
only in which end of the address is most significant. `block` is ordinary lexicographic order --
door first -- which is what a sequential allocator does today. `nested` sorts by position `k` first
and the door last, which makes every whole nested class a contiguous run.

At S(6,3), 120 vertices, holes taken 20 at a time:

| Holes | Arrangement | Components | Live diameter | Pairs the shape refused |
|---|---|---|---|---|
| 20 | **far-end-major** | **1** | 5, unmoved | **0** |
| 20 | door-major | **3** | 5 | **600** |
| 60 | far-end-major | 2 | 5 | 64 |
| 60 | door-major | **13** | 3 | 330 |

**Observation.** Twenty holes of 120 taken door-major break the network into three pieces. The same
twenty taken far-end-major leave it whole with an unmoved diameter.

**Observation.** The routing numbers on a partitioned line read *better*: the door-major row at 20
holes delivers 390 of 390 with zero losses. It is a perfect score on a network in three pieces, and the
count of refused pairs beside it is the one number that says so.

**Inference.** In this family position 1 is the door every move touches, so a contiguous run in
door-major order removes the **moves**; the same run in far-end-major order removes **vertices the
surviving routes leave alone**. The elder paper found this at the level of one whole class; it holds
for arbitrary contiguous runs, which is the form an allocator actually produces.

**Projection.** *Horizon:* the (n,k)-star family at 120 and 840 vertices, hole counts to half the
shape. *Assumption:* that a deployment controls its own address assignment -- true of a supervision
tree, false of a network of pre-existing identities. *Falsifier:* a shape where far-end-major
allocation partitions at a hole count door-major survives would end this finding outright; more
plausibly, S(9,4) at 3,024 vertices could show the two orders converging as the shape grows, which
would make this a reading about small shapes alone. *Confidence:* moderate on two shapes, and the mechanism is
legible enough to be worth testing on a third.

## The reading that ranked five arrangements backwards

The elder scan samples its targets from each configuration's own **live** set. Carried into this
one, that meant each arrangement was scored against a different set of destinations -- and with
three targets, the destinations decided the ranking.

| Targets, sampled from the live set | Where `class_partial` ranked among five |
|---|---|
| 3 | **best**, at 3.1 percent lost |
| 15 | **worst**, at 9.5 percent lost |

**Observation.** The same arrangement, the same shape, the same rule, and an inverted verdict.

**Inference.** Three targets suffice to establish that holes cost something, and fall far short of saying which
arrangement costs less. The elder paper's *rankings* between hole geometries deserve the
same caution its own coverage note asked for; its central three-rule finding stands clear of
them, since it compares rules within one configuration rather than configurations against each
other.

**The repair, and it is method rather than arithmetic.** Targets here are sampled from the **whole
address space** by a stride coprime to the vertex count and held **fixed across arrangements**, so
two arrangements are compared on the same destinations. A target a hole set killed is skipped and
**counted** -- `targets_dead=` on every line -- rather than quietly replaced by a live one, which
would reintroduce the same drift through a smaller door. The default is twelve.

## What the instrument refuses

A rule that consulted the breadth-first distance array would print perfect delivery and zero stretch
and would be exactly the table-bound case wearing the table-free answer, so the scan reads its own
source and refuses when any routing function mentions it. The check closes a function body at a
column-zero comment, which it learned by refusing this very file on its first run -- over a line of
prose *describing* the distance array between two functions while touching none of it.

Thirty-three behaviors are proven on real graphs in a throwaway pen, every refusal planted and then
lifted, since a refusal proven only in the passing direction reads exactly like a bypass.

## Coverage gaps and the falsifiers

**Horizon.** Two shapes, 120 and 840 vertices, measured `20260907` on this pier. 117 configurations,
five arrangements, 42 whole classes, hole counts from 4 to 60 on the small shape and 20 to 42 on the
large one, twelve fixed targets.

**Assumptions.** That hop count is the cost worth counting. That a deployment chooses its own
addresses. That twelve targets rank arrangements stably -- which is asserted from two target counts
agreeing on the ordering, and is the assumption this paper is least sure of.

**The falsifiers, named.**

*Finding one falls* if a third target count reorders the 42 classes materially, rather than only
moving one symbol's rank as the move from eight to twelve did.

*Finding two falls* if a shape past 3,000 vertices shows the remainder cost growing faster than the
class-aligned cost, so that "plus a rounding error" becomes "plus a term in the membership".

*Finding three falls* if far-end-major allocation partitions where door-major does not, on any shape
of this family -- or, more softly, if the two orders converge as the shape grows, which would make
this a reading about small shapes rather than about the family.

*All three fall together* if a real supervision tree cannot choose its own addresses, since every
finding here is a statement about an allocation policy and none is a statement about a rule.

**What is not measured.** Churn -- these are static hole sets, and a membership that joins and
departs is a different reading, taken by
[`../tools/fixtures/t/topology_churn_scan.sh`](../tools/fixtures/t/topology_churn_scan.sh). The
torus comparison the elder paper carries is not repeated here.

## What a builder can take from this today

Three sentences, each resting on a reading above.

**Allocate addresses far-end-major.** It is a comparison function, it changes no other behavior, and
on the shapes measured it is the difference between one component and three.

**Look past "keep the holes in one class."** Taken door-major inside a class, that heuristic came
last of the five arrangements measured, behind scattering.

**A membership between whole classes is fine.** The leftover addresses cost a rounding error, so a
supervision tree may stop wherever it stops rather than padding up to a class boundary.
