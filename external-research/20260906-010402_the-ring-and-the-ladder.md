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
