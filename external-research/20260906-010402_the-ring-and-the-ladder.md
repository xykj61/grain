# The Ring and the Ladder

**Stamp:** `20260906.010402`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- external research. Nothing here binds a witness (`context/TWO_ROOMS.md`).
**Room two:** [`a-third-of-the-sky-has-no-road`](../active-designing/20260906-010402_a-third-of-the-sky-has-no-road.md) -- the same question asked of our own module, with an instrument
**Kin:** [`what-a-coordinate-frame-makes-free`](20260905-224730_what-a-coordinate-frame-makes-free.md) -- the elder pair, which priced what a metric distinguishes

*A distance function makes a promise: that there is a way to get there, and that it is this long. This paper is about the two shapes a network can choose to keep that promise, what each one gives up, and how to tell in advance which one you are holding.*

---

## What a distance function promises

A network hands you two names and asks how far apart they are. The answer is a number, and the number carries a claim: **somewhere in the graph there is a walk of that many edges.** A distance that no walk realizes is a hint dressed as a fact. It will be right often enough to look correct and wrong exactly where a reader stops checking.

Two shapes answer the question, and almost every real system picks one of them.

A **ladder** answers by climbing. Each point has a parent, the parent has a parent, and the distance between two points is the walk up to their nearest shared ancestor and back down the other side. Sponsorship, delegation, and containment all take this shape naturally, so the ladder is what a system reaches for first.

A **ring** answers by subtracting. Each point sits at a position on a circle, and the distance is the shorter of the two ways around. Stack a few rings side by side, one coordinate each, and the distances add. That stack is a **torus** -- three rings give a three-dimensional one, and the arithmetic is the same at any width.

## Why a ladder's distances go flat

A ladder's trouble is arithmetic rather than taste, and it is worth deriving once.

Take a ladder of depth `D` where every node has `F` children. The leaves outnumber everything above them: there are `F^D` of them against roughly `F^D / (F - 1)` interior nodes. Now pick two leaves at random. They share a parent with probability about `1/F`; they share a grandparent with probability about `1/F^2`. So the chance that two random leaves share **anything below the root** falls off geometrically, and almost every pair takes the full walk to the top and back.

The consequence is that the distance function stops saying much. Most pairs sit at the diameter, and the answer "far" carries no information about *which* far. In our own seated sky, measured `20260906` over all 518,400 ordered pairs, **77.03 percent of pairs sit at the diameter** and the whole distribution carries **1.0461 bits** of Shannon entropy against the **2.5850** its six distinct values could hold -- 40.5 percent efficiency. The council sky reads 73.74 percent and 1.2092 bits. Both re-derive with `sh tools/fixtures/t/topology_metric_census.sh`.

A ring degenerates the other way, and much more slowly. On a circle of `N` seats the distances spread evenly from zero to `N/2`, and stacking rings convolves those spreads into a bell. Over the same 720 points, read as three rings of twelve, five, and twelve, the distribution carries **3.4271 bits against a 3.9069 ceiling** -- 87.7 percent efficiency, measured the same second by the same script.

## What the machines that had a choice chose

Two families of system get to pick their own geometry, and both picked rings.

**Supercomputer interconnects.** IBM's Blue Gene/L wired its compute nodes as a three-dimensional torus; Blue Gene/Q moved to five dimensions. Cray's XT and XE lines used a three-dimensional torus before the XC generation switched to a dragonfly. Fujitsu's K computer and Fugaku both use a six-dimensional mesh-torus they call Tofu. *Confidence: high on the shapes, medium on the generation boundaries; recalled from reading rather than verified this lap, since this bench has no network. A reader with one should check before citing a date.*

**Distributed hash tables.** Chord arranges identifiers on a ring and routes by halving the arc. Kademlia replaces the ring with a bitwise-exclusive-or over identifiers, which is not a ring yet keeps the property that matters here: the distance between two names is a function of **those two names alone**, with no third party consulted and no role to look up.

The pattern is worth naming plainly. Where a designer could choose the geometry freely, they chose one where distance is arithmetic on coordinates. Where a designer inherited a hierarchy -- an organization chart, a filesystem, a certificate chain -- the ladder came along with it, and the routing was built on top of what the naming already was.

## Why a ring is a metric by construction

A ring gives up something in exchange for a guarantee, and the guarantee is worth stating exactly.

The distance on a torus is the **Lee distance**, named for the 1958 coding-theory paper that introduced it over the integers modulo `q`. It sums, over each ring, the shorter of the two ways around. Three properties follow with no proof obligation on the implementer:

- **It is total.** Two coordinate triples always have a distance, because subtraction always works.
- **It is a true metric.** Symmetry and the triangle inequality hold on each ring and survive the sum.
- **It is realized by a walk.** A torus is a Cayley graph of an abelian group, so it is vertex-transitive: every node sees the same neighborhood and the same distance distribution. Stepping one seat along one ring is exactly one edge, so the Lee distance counts real edges by construction.

A mesh -- the same rings with the wrap removed -- keeps all three, which is worth saying because it locates the wrap correctly. Planted into our own census `20260906`, an unwrapped ring passed the realizability check and answered diameter 26 against the torus's 14. **The wrap buys the diameter; the coordinates buy the honesty.**

The third property is the one a ladder cannot promise for free. A ladder's distance is a *formula about roles* -- your depth plus my depth, less what we share -- and a formula about roles is realized by a walk only when every role in the formula corresponds to a node you can actually stand on.

## What a ring costs, named plainly

**The diameter grows.** Our own three rings give a diameter of 14 hops against the ladder's 5, and a mean of 7.2 against 4.68. That is a real cost and it does not shrink with cleverness.

**Neither shape is near optimal, so the comparison is narrower than it looks.** The Moore bound caps how many nodes a graph of maximum degree `d` and diameter `D` can hold: `1 + d * ((d-1)^D - 1) / (d - 2)`. At degree 6 and diameter 14 that ceiling is **9,155,273,437** nodes; at degree 15 and diameter 5 it is **620,566**. Both shapes hold 720 points -- roughly one thousandth of the second ceiling, and eight hundred-millionths of the first. Neither is anywhere near its own limit, so a diameter argument between them compares two comfortable designs rather than a frontier.

**A ladder has an authority a ring does not.** Sponsorship, delegation, revocation, and quota all want a parent. A ring has no parent anywhere, which is exactly why it has no bottleneck -- and exactly why it answers no question about who vouches for whom.

## Where this applies, and where it does not

**It applies to any system whose distance function is published as a hop count.** The test is one question: *is there a graph in which these are hops?* Build the graph from the metric's own unit distance -- the pairs it places at distance one -- walk it, and compare. Nothing about the system needs to be known beyond the metric itself.

**It does not carry a physical-energy claim on an overlay.** A hop between two peers on the public internet costs what the underlying path costs, and the overlay's coordinates say nothing about that path. Statements of the form "fewer hops means fewer joules" hold on a machine where a hop is a wire and are unfounded on an overlay where a hop is a socket. This paper makes the claim only in the first case, and names it as a horizon rather than a finding.

**The energy claim that does hold on either is about state.** Dimension-order routing on a torus computes the next hop from the two coordinate triples with a handful of integer operations and no table at all, and Dally and Seitz showed in 1987 that adding virtual channels makes it deadlock-free. A hierarchy with a fully-connected top needs each top node to hold an entry per peer. That is a memory and lookup cost per packet, and memory that is read on every packet is the kind that shows up in a power budget. *Confidence: high that the state costs differ; no measurement of the difference is offered here.*

## The falsifier

**This paper is wrong if a ladder's distance function can be shown to be realized by a walk on its own unit-distance graph over its whole domain, while carrying a flat distribution.** That would mean the flatness and the unrealizability are separate faults rather than the same one, and the argument that ties them together would fail.

The narrower falsifier, for the measured half: **exhibit a hierarchy of depth three or more, with fan-out above one at every level, whose unit-distance graph is connected.** One such example would show the isolation this paper treats as structural is an artifact of one module's choices instead.

*Horizon: this argument holds while networks are named hierarchically and routed by the same names. Assumptions: distance is symmetric, and the metric is published as a hop count rather than as a preference ordering. Confidence: high on the arithmetic, which is derived above; medium on the prior art, which is recalled rather than fetched.*

## Gratitude

To C. Y. Lee, whose 1958 distance over the integers modulo `q` is still the cleanest way to say *the shorter way around*; to William Dally and Charles Seitz, whose virtual channels made ring routing safe to build; and to Charles Leiserson, whose fat-tree showed that a hierarchy's bottleneck is a bandwidth question with an engineering answer rather than a fate. We borrow the understanding and write our own code.

---

## Errata -- the narrower falsifier fired, `20260906.105235`

**This section corrects a fact; the body above keeps every word it wrote.** Dated testimony is
corrected by erratum rather than rewritten, so a reader can see both what was claimed and what
the measurement did to it.

### What fell

This paper offered a narrower falsifier for its measured half: *exhibit a hierarchy of depth three
or more, with fan-out above one at every level, whose unit-distance graph is connected.* Within
eight hours a sibling ship exhibited one, and it is our own module. `Sky.point_hops` in
`comlink/topology.rye` walks the same sponsor chain in **number** space rather than address space,
where a star of index zero and its galaxy are one point rather than two. Measured
`20260906.105235` by `sh tools/fixtures/t/topology_graph_census.sh`, over the same 720-point
compass sky and all 518,400 ordered pairs:

| Reading | `route_hops` (address space) | `point_hops` (number space) |
|---|---|---|
| Isolated points | 132 | **0** |
| Components | 133 | **1** |
| Ordered pairs the metric claims and no walk realizes | 172,524 (33.28%) | **0 (0.00%)** |

**The isolation this paper treated as structural was an artifact of one module's address
arithmetic.** `Address.parent` sent a star-index-zero planet to a star that `encode` places on its
galaxy's own number, and `decode` read that number back as a galaxy, so the step existed in the
tree and not in the formula. The paper's central sentence -- *a distance that no walk realizes is
a hint dressed as a fact* -- stands as written; what it does not do is convict hierarchy in
general, and this page read it as though it did.

**The general claim that survives is narrower and worth stating exactly.** A ladder's distance is
a formula about roles, and a formula about roles is realized by a walk only when every role in it
names a point you can stand on. That remains true. What the measurement shows is that the
condition is **satisfiable** -- a hierarchy can meet it, and ours now does -- rather than
structurally out of reach.

### What stands, measured on the graph that survived

Citing the fallen reading's numbers against the torus would repeat the fault this fleet booked the
same morning as `%476`: naming a cause by proximity. So the census grew a **point leg**, and the
three surviving arms are measured on the graph the module actually publishes. Compass sky, 720
points, `20260906.105235`, same script:

| | ladder (`point_hops`) | torus (Lee, three rings) |
|---|---|---|
| Degree, min / max / mean | 1 / 26 / 2.15 | **6 / 6 / 6.00** |
| Cut points, excluding the walk's start | **59** | **0** |
| Worst single failure strands | 59 points (8.19%) | 0 |
| Entropy against its own ceiling | 1.5511 / 2.5850 = 60.01% | 3.4271 / 3.9069 = **87.72%** |
| Diameter | 5 | 14 |

**The cut-point number is a structure rather than a count, and the census now names it.** The 59
break down as **11 galaxies and 48 stars, and zero planets** -- against a sky holding 12 galaxies,
48 stars distinct from their galaxies, and 660 planets. Every interior point of the ladder is an
articulation vertex; the twelfth galaxy is absent from the count only because the walk starts
there. **Every leaf is safe and every interior node is a single point of failure**, which is what
a ladder *is* rather than a flaw in this one. The torus reads zero of 720, because a
three-dimensional torus has vertex connectivity six and every node is interior.

The council sky reads the same shape at its own scale: 44 cut points, 14 galaxies and 30 stars and
zero planets, worst case stranding 26 of 405.

### What got sharper on both sides

**The repair improved the ladder on every axis except the two that are structural**, and saying so
is the point of an erratum. Realizability went from 66.72% of pairs to all of them. Entropy
efficiency rose from 40.47% to 60.01%, and the share of pairs sitting at the diameter fell from
77.03% to 49.30% -- so the *distances go flat* argument above is measurably weaker than the body
claims, though it does not vanish: a ladder still spends half its pairs on one value where the
torus spends 0.28% on its own.

Degree spread and cut points moved the other way. `degree_max` rose 15 to 26, because collapsing
the index-zero star onto its galaxy hands that galaxy its planets directly, and the worst single
failure rose from stranding 48 points to 59 -- not because the graph got weaker, but because it is
now whole, so a cut takes more of a larger component with it. **A connected graph has more to
lose.**

### Two checks on the numbers above

**The cut counts are corroborated for one metric and not the other, and the difference is worth
naming.** `sh tools/fixtures/t/topology_revocation_census.sh` finds cut points a second way, by the
depth-first lowlink criterion, sharing no code with the removal sweep. For the compass sponsor
graph it reads 60 against this page's 59, and for the council sponsor graph 45 against 44 -- the
one-point gap in each case being the walk's own start, which the sweep excludes by construction and
lowlink does not. **The point metric has no such second reading yet**, because the revocation census
carries sponsor and torus legs and no point leg. So the 59 above is measured once rather than twice,
and a point leg for that census is the cheapest way to close the gap.

**The Moore-bound comparison survives its own input moving.** The body computed the hierarchy's
ceiling at degree 15, and the point reading raises the maximum degree to 26. At degree 26 and
diameter 5 the bound is 10,579,427 nodes against the 620,566 the body cites. Both are four orders of
magnitude above the 720 points either shape holds, so the body's conclusion -- that neither design is
near its own limit and a diameter argument between them compares two comfortable shapes -- is
unchanged by the correction.

### The falsifier, restated for what is left

The body's broad falsifier is retired: it tied flatness and unrealizability together as one fault,
and the measurement has separated them. This is what replaces it.

**The surviving case is wrong if a hierarchy can be exhibited whose interior nodes are not
articulation vertices, while it still answers sponsorship, delegation, and revocation from a
parent.** Adding sibling links or a second parent would do it -- and would also spend the single
authority the body names as the ladder's one advantage over a ring. Whether that trade is worth
making is a design question this page does not answer.

*Horizon: this holds while the module publishes hop counts over the seated skies. Assumptions:
distance is symmetric, and a cut point is measured against the largest component with the walk's
start held fixed. Confidence: high on all figures, which re-derive from one script on demand;
medium on the reading that every interior node is a cut, which is measured on two skies rather
than proven for the family.*

---

## Errata -- the second reading landed, `20260906.130223`

**The gap the errata above named is closed, and it named it exactly:** *"The point metric has no
such second reading yet, because the revocation census carries sponsor and torus legs and no point
leg. So the 59 above is measured once rather than twice, and a point leg for that census is the
cheapest way to close the gap."*

`tools/fixtures/t/topology_revocation_census.sh` carries a point leg now. It reproduces
`Sky.point_hops` in `awk` from the module's own three fan-outs, builds the graph from the metric's
unit distance, and finds cut points **two independent ways** -- a removal sweep and a depth-first
lowlink pass sharing no code. Compass sky, `20260906.130223`:

```
compass point cut_agreement sweep=60 lowlink=60 in_both=60 sweep_only=0 lowlink_only=0 same_set=yes
```

**Sixty, both ways, agreeing point for point rather than only in count.** The 59 published above
plus the walk's own start, which the sibling's sweep excludes by construction and this one does
not -- the same one-point offset the errata above already derived for the sponsor graph, now
confirmed on the point graph rather than assumed to carry over. The council sky reads 45 both ways
against the 44 published. **So the torus's cut-point arm is measured twice, and the reading holds.**

### The arm that got a number it did not have

The card summarized this paper's position after the first erratum as *the torus's case is degree,
cut points and the angle alone.* Two of those three now carry a price the paper never quoted,
because the revocation census measures what a cut **costs** rather than only where cuts are:

| Compass sky, `20260906.130223` | ladder (`point_hops`) | torus (Lee, three rings) |
|---|---|---|
| Cut points, both algorithms agreeing | **60** | **0** |
| Most points stranded by one removal | 59 of 720 | **0** |
| Points stranded, summed over every removal | 1,236 | **0** |
| Best dividend -- points stranded per link torn down | **2.27** | **0.00** |

**The dividend is the honest way to read this, and it cuts both ways at once.** A high dividend is
cheap transitive revocation *and* a wide blast radius; they are one number wearing two names. So the
torus's zero is not simply a win: it says no revocation on a torus reaches past the point revoked,
which is exactly the *authority* this paper's body names as the ladder's one advantage over a ring.
The measurement prices that advantage rather than settling it.

### And a finding about the ladder that this paper did not predict

The repair that made the ladder connected made revocation **dearer**: the best dividend falls
**3.20 to 2.27** between the two ladder readings, because collapsing the index-zero star hands a
galaxy its planets directly, raising its degree 15 to 26 while its reach rises only 48 to 59.
One line of the module, read as a gain by the routing census and as a cost by the revocation
census. Neither instrument is wrong, and the tree held only the first reading until this lap.

### The instrument's own limit, measured rather than described

The revocation census builds its graph from the metric's **unit** distance alone, so an error that
moves no distance-one pair is invisible to it. Measured: spelling the cross-galaxy bridge with the
address depth instead of the point depth leaves every number on every leg identical and
`verdict=ok`, because the only cross-galaxy pairs at distance one are root-to-root, where the two
depths agree at zero. The same plant in `topology_graph_census.sh` bites four ways at once, with
`metric_differs=158268`. **Two censuses, two questions**: this one asks what one removal costs, that
one asks whether a published distance is a road. Neither substitutes for the other, and the point
leg's numbers above are safe only because both were run.

*Horizon: unchanged. Assumptions: unchanged. Confidence: high on the cut counts, which two
independent algorithms now agree on for every leg of both skies; high on the dividend arithmetic,
which is a ratio of two measured integers; the surviving falsifier from the errata above stands
untouched, since nothing here exhibits a hierarchy whose interior nodes are not articulation
vertices.*

---

## Errata -- the bound had a direction, `20260906.142051`

The body reached for the Moore bound, asked it in one of its two directions, and the errata above
re-affirmed the answer. Both readings are true statements about one inequality. Only one of them is
about a choice somebody is making.

**What the body asked.** *How many nodes could a graph of this degree and this diameter hold?* At
degree 6 and diameter 14 the ceiling is 9,155,273,437 nodes; at degree 26 and diameter 5 it is
10,579,427. Both shapes hold 720. The body concluded from that distance that neither design is near
its limit, so *a diameter argument between them compares two comfortable designs rather than a
frontier.*

**What binds instead.** A sky fixes its point count -- 720 in the compass sky, 405 in the council --
and a shape fixes its degree. The diameter is the free variable, so solve for it. The same
inequality then answers the question a designer holds: **the smallest diameter any graph of this
many points and this degree could have.** `tools/fixtures/t/topology_graph_census.sh` reports it per
leg, measured `20260906.142051`:

| Compass sky, 720 points | ladder (`point_hops`) | torus (Lee, three rings) |
|---|---|---|
| Maximum degree | 26 | 6 |
| Diameter achieved | 5 | 14 |
| Smallest diameter possible at that degree | 3 | 4 |
| **Above its own floor** | **1.67x** | **3.50x** |

The council sky reads 2.50x and 3.00x the same way. **The diameter argument decides after all, and
it decides against the ring** -- which strengthens the body's own position rather than reversing it,
since the body already priced the torus's case as degree and resilience.

### The reading that stands alone, and needs no comparison

Two shapes at different degrees are an awkward pair: the ladder's maximum degree of 26 is thirteen
times its own mean of 2.15, so it is measured against a floor it buys at twelve hub nodes, and that
same concentration is why it carries 60 cut points where the torus carries none. One dial, read
twice. The torus is 6-regular, so its own reading needs no partner:

> **At the degree it actually uses, the seated torus sits three and a half times above the smallest
> diameter any shape of that degree could hold.**

**And the torus family cannot close that gap by re-balancing.** The best three-ring torus over 720
points is 8 x 9 x 10 at diameter 13, against the seated 12 x 5 x 12 at 14 -- one hop of the ten.
Widening it buys real diameter and keeps the ratio: four rings at degree 8 reach 10 (2.50x), five at
degree 10 reach 8 (2.67x). Six rings do not exist here at all, since six rings of three seats each
already need 729 points. So the factor of roughly two-and-a-half to three-and-a-half is a property
of the family rather than of our choice of rings.

**What that hands a builder.** If the torus's zero cut points are the reason to want it, there is a
diameter gap of that size standing between it and the best conceivable shape at the same port count,
and the ring family does not reach into it. Degree-6 shapes outside that family are worth a look
before the geometry is committed.

### What the floor does not promise

The Moore bound is a ceiling that almost no graph attains -- the known attainers are the cycles, the
complete graphs, Petersen at degree 3, Hoffman-Singleton at degree 7, and one open case at degree 57.
So **1.67x and 3.50x bound the room from above rather than promising a shape at the floor.** The
honest sentence is that at most that much is available, and how much of it is reachable is the
degree-diameter problem, which is open.

**How the arithmetic is held.** The floor is bound in the census's agreement leg to four graphs that
attain the bound exactly, since an attainer sits *on* the ceiling and catches the off-by-one a
bracketing case reads past. `tools/fixtures/t/topology_floor_control.sh` proves **23 behaviors** on
real pens: five plants each shown from the failing side, the pen proven innocent, and the legs proven
to earn their keep by a copy that is broken with the checking legs removed -- which reads green while
the torus's floor sits at 5 and its ratio at 2.80, **a fifth of this finding, in the flattering
direction, silently.** The census also refuses to report a floor on either sponsor leg, whose graphs
are split 133 and 121 ways: a ratio against the widest walk of one component, while half the ordered
pairs never connect, would be a number about nothing.

*Horizon: this holds while the module publishes hop counts over the seated skies. Assumptions: the
Moore bound is read on maximum degree, and the torus survey admits only rings of three seats or more,
since a ring of two contributes one neighbour rather than two and would make the degree column a lie.
Falsifier: exhibit a graph of 720 points and maximum degree 6 with diameter under 4, and the floor is
wrong; exhibit one at diameter 5 or 6 and the gap this names is real and largely reachable.
Confidence: high on the floors, which four attainers pin exactly; high on the torus survey, which
enumerates every factorisation; low on how much of the gap any real construction recovers.*
