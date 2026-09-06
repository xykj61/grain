# The revocation and the fault ride one edge

**Stamp:** `20260906.034951`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** **Mixed** -- the ladder readings are measured and re-derive in four seconds; the ring readings describe a metric this tree has yet to implement ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Instrument:** `sh tools/fixtures/t/topology_revocation_census.sh` -- 4 seconds, argument-free
**Its refusals:** `sh tools/fixtures/t/topology_revocation_control.sh` -- four plants, twelve assertions
**Elder:** [`a-third-of-the-sky-has-no-road`](20260906-010402_a-third-of-the-sky-has-no-road.md), which measured the routing half and left this half in one sentence
**Reads:** `comlink/topology.rye`

*Its elder ruled that routing should leave the sponsor ladder and read coordinates instead, and closed on a sentence it left unpriced: a ladder has an authority a ring does not. This lap priced it, and found that the authority and the fragility are one structure counted once.*

---

## The finding, in one line

**A revocation and a fault travel the same edges, so any shape that makes one of them cheap makes the other cheap too.** In the ladder that ships, one removal reaches as many as 48 of 720 points. In the three-ring reading of the same coordinates, one removal reaches exactly one point. Both numbers are prices rather than defects, and a design wanting both halves is asking for a graph that has yet to exist.

## The numbers, measured `20260906.034951`

Over `comlink/topology.rye` at that stamp, by `tools/fixtures/t/topology_revocation_census.sh`. Points are the sky's own points; edges are exactly the pairs each metric places at distance one, so each metric's own answer builds its own graph.

| Reading | Compass ladder | Compass rings | Council ladder | Council rings |
|---|---|---|---|---|
| Points | 720 | 720 | 405 | 405 |
| Edges | 642 | 2,160 | 375 | 1,215 |
| Components | 133 | **1** | 121 | **1** |
| Degree, min / mean / max | 0 / 1.78 / 15 | 6 / 6.00 / 6 | 0 / 1.85 / 16 | 6 / 6.00 / 6 |
| Points whose removal strands another | **60** | **0** | **45** | **0** |
| Most points stranded by one removal | **48** | 0 | **18** | 0 |
| Points stranded, summed over every removal | 1,104 | 0 | 510 | 0 |
| Best dividend -- points stranded per link torn down | **3.20** | 0 | 1.12 | 0 |

The dividend row is the trade in one figure. Point 0 of the compass sky is a galaxy holding fifteen links; tearing those fifteen down takes 48 further points off the network with them, so each link torn down reaches 3.2 points. Every point of the ring reading holds six links, and spending all six reaches one point.

## Two revocations, kept apart because they are different acts

The census separates them, and the separation is where the price hides.

**Refuse as endpoint.** Every neighbor refuses traffic whose end is `p`. The point is cut off and transit through it still works. The bill is one refusal per neighbor -- **exactly `deg(p)`, and that is the whole bill** -- and it reaches one point. This is why the census prints degree and endpoint cost on one line rather than two: they are one number, and the graph already publishes the enforcement bill.

**Refuse as peer.** The links to `p` come down, so its transit capacity goes with it, and whatever routed only through `p` goes too. The bill is the same `deg(p)`. What it *reaches* is the whole question, and it is the cascade column above.

## Why the two cascades are one set, rather than two that happen to match

Here the argument is arithmetic rather than measurement, and it is short.

A point's removal strands another point exactly when that point is a cut vertex. Whether the removal was **chosen** -- a sponsor revoking what it vouched for -- or **suffered** -- a host whose power went out -- is a fact about the world outside the graph. The graph is handed the same gap either way.

So the set of points where revocation cascades and the set where a fault cascades are one set rather than two that agree. **They are one set named twice**, and this tree's own compass sky holds 60 of them: twelve galaxies and forty-eight stars, each an interior node of the ladder.

That identity is what makes the trade unavoidable. A design that buys transitive revocation buys transitive failure with it, because it is buying one edge structure and reading it under two names.

## The third cost, which is the interesting one

A hierarchy compresses revocation state, and this is the argument for keeping one. Under the ladder, taking a star and its eleven planets off the network is **one** entry in a revocation list, because the eleven were reachable only through it. Under the rings, the same twelve points want **twelve** entries, since every one of them is reachable six other ways.

*This paragraph is inference from the measured table rather than a separate measurement.* Compass ladder removals strand 1,104 points across 60 removals, a mean of **18.4 points per entry**; ring removals strand only themselves, so the ratio is **1.0 by construction**.

**And that is where the ring's own advertisement runs out.** The elder paper's surviving energy statement was that dimension-order routing on a ring computes the next hop from two coordinate triples from those triples alone. True, and it holds for *routing*. Revocation then puts a table back, sized by the number of revoked points rather than by the number of peers. **The saving reaches routing and stops there**, and a design study quoting the routing figure alone would be selling half a system.

The honest counter runs the other way with equal force: the hierarchy's compression **is** its over-reach. One entry taking twelve points offline is the same sentence as one revocation taking eleven innocent planets with it. Compression, blast radius, and cheap revocation are three readings of the cut-vertex structure, and every shape this lap measured ties the three together.

## The menu, priced

| If a design wants | The ladder gives | The rings give |
|---|---|---|
| A distance every pair can walk | 66.72% of ordered pairs (elder reading) | 100% |
| Revocation that reaches a subtree | one removal, up to 48 points | enumerate, always |
| Revocation state per group revoked | 1 entry per 18.4 points, measured | 1 entry per point |
| A fault that stops at itself | at 660 of 720 points | at all 720 |
| A uniform load per node | degree 0 to 15 | degree 6, everywhere |

**Every column costs.** That is the finding, and a design ruling here is a choice about which cost the network would rather pay, made by whoever holds the module.

## What this hands BAKERY, small and separable

**One -- the census itself, already built and already refusing.** `tools/fixtures/t/topology_revocation_census.sh` runs in four seconds argument-free and binds three of its numbers to the elder census, so a change to either script is caught by the other rather than by a reader. These numbers stay honest exactly as they stand.

**Two -- a bound worth naming in `comlink/`, whichever shape wins.** `max_revocation_cascade`: how many points one removal may take with it. The compass ladder's answer today is 48 of 720, which is 6.67 percent of the sky, measured rather than declared. A named maximum turns a shape's blast radius into a number a reader can check, and TAME already asks every collection to name a max.

**Three -- the reachability guard the elder paper handed over is still unbuilt**, and this lap adds a second reason to want it. It would red today at 132 isolated points, and its value is that it turns a paragraph into a standing instrument.

## What this does not claim

**That the ladder is the wrong shape for sponsorship.** Sponsorship genuinely wants a parent, and transitive revocation is a real feature of having one. This paper prices it and leaves the ruling where it belongs.

**That the ring is the right shape for Comlink.** Its authority story is still to be written, and its diameter cost -- 14 against 5, elder reading -- is real. Choosing it is a ruling that belongs to the seat holding `comlink/`.

**Any claim about how often a real revocation happens.** The dividend prices one revocation. How often a network revokes decides whether the price matters at all, and this lap left that unmeasured.

**Any energy claim.** A hop here is a socket rather than a wire, and the elder paper already named the one statement that survives on an overlay. This paper adds the revocation-table cost on the other side of that ledger and stops there.

## The falsifier

**This paper dies if a reader exhibits a graph in which some point's removal strands a set, while that same point's failure strands zero points.** The whole argument rests on the graph being handed the same gap whether the removal was chosen or suffered. One counterexample and the identity is an accident of these two shapes rather than a property of graphs.

The narrower one, for the compression claim: **exhibit a revocation scheme on the ring reading whose state grows more slowly than one entry per revoked point** -- a range, a coordinate mask, an interval on one axis. That would show the hierarchy's compression is a property of naming rather than of topology, and the third cost above would fall.

*Horizon: both readings hold while `comlink/topology.rye` computes `decode` and `route_hops` as it does today; the census reads the three fan-outs out of the source, so a sky change is measured rather than assumed. Assumptions: adjacency is each metric's own unit distance, distance is symmetric, and a removal is total rather than partial. Confidence: high on the ladder numbers, which re-derive in four seconds and agree with a sibling instrument on three published readings; high on the identity, which is definitional; medium on the compression arithmetic, which is derived from the table rather than separately measured.*
