# A third of the sky has no road

**Stamp:** `20260906.010402`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** **Mixed** -- the sponsor readings are measured and re-derive in one command; the torus readings describe a metric nothing in this tree implements (`context/TWO_ROOMS.md`)
**Instrument:** `sh tools/fixtures/t/topology_graph_census.sh` -- 25 seconds, no arguments (15 at this page's stamp; the point leg added `20260906.105235` is the difference)
**Room one:** [`the-ring-and-the-ladder`](../external-research/20260906-010402_the-ring-and-the-ladder.md)
**Reads:** `comlink/topology.rye`

*`route_hops` publishes a hop count. A hop count claims a walk exists. This lap built the graph the metric's own unit distance defines, walked it from every point, and found that for one ordered pair in three there is no walk at all.*

---

## The finding, with its number

Over `compass_sky`, the seated twelve-five-twelve topology, measured `20260906.010402`:

| Reading | Compass (720 points) | Council (405 points) |
|---|---|---|
| Edges in the graph the metric defines | 642 | 375 |
| Points with no edge at all | **132** | **120** |
| Connected components | 133 | 121 |
| Ordered pairs the walk cannot reach | **172,524 of 518,400 (33.28%)** | 82,680 of 164,025 (50.41%) |
| Ordered pairs where the walk disagrees on a value | **0** | **0** |

That last row is the one that makes the rest legible. **Where a walk exists, `route_hops` is exactly right** -- all 345,876 reachable ordered pairs agree to the hop. The whole error is one shape: 132 points that no edge touches, about which the metric nonetheless answers confidently.

## The instrument, and what proves it

[`tools/fixtures/t/topology_graph_census.sh`](../tools/fixtures/t/topology_graph_census.sh) reads the three fan-outs out of `comlink/topology.rye`, rebuilds `decode` and `route_hops` in `awk`, and then does the thing no earlier pass did: it treats the metric as a graph. **Edges are exactly the pairs the metric places at distance one**, so no edge set is assumed anywhere -- the metric is asked, and its own answer builds the graph. A breadth-first walk then runs from all 720 points.

Three legs run before any new number is printed, because a census that reproduces a function is making a claim about that function:

- The five pairs `comlink/topology.rye` asserts in its own selftest, against the answers it asserts.
- The derived counts: `star_count` 60 and `universe_points` 720, or the census refuses rather than confidently measuring a sky nobody runs.
- **The elder census's three published compass readings** -- diameter 5, entropy 1.0461 bits, diameter share 0.7703. Binding to a sibling instrument means a change that moves either script's numbers is caught by the other rather than by a reader.

Three refusal paths were proven on metal in a pen. A hop model answering 3 where the module asserts 5 failed the agreement leg **four ways at once** -- the selftest pair and all three elder readings, `faults=1900`. A torus leg that dropped one of the three rings called 2,880 distinct pairs zero apart and disagreed with its own graph on the same 2,880. A ring gap counting each step twice left no pair at unit distance at all, so the graph held zero edges and 517,680 ordered pairs went unreachable.

**A fourth plant taught more by passing, and the census was wrong about it first.** This lap wrote down, before running it, that a ring gap which forgot to wrap would red. It does not. The plain absolute difference is still a graph metric -- it is the Manhattan distance on a **mesh**, and a mesh realizes it exactly, at diameter 26 against the torus's 14. **The wrap buys the diameter; it does not buy the honesty.** The claim was published in this paper's own draft and in the script's header before measurement removed it.

## The root, measured rather than argued

The 132 points are not a random third. The census names them by a predicate and checks the two sets point by point rather than by matching two counts, since two different sets can also have the same size:

```
sponsor_compass_isolated isolated=132 star_index_zero_planets=132 in_both=132 same_set=yes
```

**Every isolated point is a planet whose star index is zero, and every planet whose star index is zero is isolated.** These are the points the inclusive breach made sponsored by a galaxy directly.

The second leg says why in one line. `Address.parent` sends a planet to `(galaxy, star)` with tier `star`, and `Sky.encode` turns that into `galaxy + star * galaxies`. When the star index is zero, that arithmetic returns the galaxy's own number -- and `decode` reads a number below twelve as tier `galaxy`, at depth zero. So the sponsor is one point wearing two outfits, and the metric reads the outfit rather than the point:

```
sponsor_compass_sponsor points_with_a_sponsor=708 hop_is_one=576 hop_is_not_one=132
                        all_of_them_star_index_zero=yes
sponsor_compass_sponsor first_disagreeing_point=60 sponsor_number=0 metric_says=2 chain_says=1
```

Point 60 is the first planet of galaxy 0. Its sponsor is point 0. The chain reaches it in one step; `route_hops` answers two. **The module is internally consistent and externally wrong**: `route_hops(planet, star_address)` answers 1 correctly, and the very same two points answer 2 once the sponsor is named by its number. The elder census had already caught this from the other side and left the sentence standing in its own header -- *a distance depends on which outfit each end wears rather than on the two points alone*. This lap prices it: **132 points, 33.28 percent of ordered pairs.**

## What the ladder costs beyond that

Two further readings came free once the graph existed.

**Degree runs from 0 to 15** with a mean of 1.78. A galaxy holds eleven peer links plus four stars; a star holds one parent and eleven planets; a planet holds one link, or none. Nothing in the design is uniform, so nothing about one node's load predicts another's.

**Fifty-nine points are cut points** -- their removal strands part of the 588-point reachable component -- and the worst strands 48 points, 8.16 percent of it. (The census holds one start point out of that sweep and says so in the field name, so the true count is 60: the twelve galaxies and the forty-eight stars.) **Every interior node of the ladder is a single point of failure for its own subtree.** That is the shape rather than a defect; it is what a ladder is.

## The same coordinates, read as three rings

`decode` already gives every point three coordinates: a galaxy index modulo twelve, a star index modulo five, a planet index. The census reads those unchanged and only swaps the distance -- the shorter way around each ring, summed. Nothing else moves.

| Reading | Ladder | Three rings |
|---|---|---|
| Diameter | 5 | 14 |
| Mean distance | 4.68 | 7.20 |
| Distinct values | 6 | 15 |
| Entropy | 1.0461 bits | 3.4271 bits |
| Ceiling | 2.5850 bits | 3.9069 bits |
| **Efficiency** | **40.47%** | **87.72%** |
| Degree | 0 to 15 | 6, everywhere |
| Components | 133 | 1 |
| Cut points | 59 | **0** |
| Ordered pairs a walk realizes | 66.72% | **100%** |
| Same-galaxy cross-star planet pairs, distinct values | 1 | 8 |

The last row is the elder finding answered. The elder census showed the metric is **angle-blind**: 29,040 pairs of planets under different stars of one galaxy, and one hop value between all of them. Read as rings, those same pairs take eight distinct values, because a ring keeps the angle the ladder throws away.

**The ring costs a bigger diameter and it is not close.** Fourteen against five, mean 7.2 against 4.68. That cost is real and does not shrink. What it buys is that every number is realized by a walk, no point is a single point of failure, and every node carries the same six links.

## The ruling: two questions, one function

**`route_hops` derives routing from the sponsor chain, so the identity hierarchy became the network topology by inheritance rather than by choice.** Sponsorship genuinely wants a parent -- who vouches for you, who may revoke you, whose quota you spend. Routing wants none of that; it wants a distance that is a total function of two names.

The module answers both questions with one walk up the sponsor chain, and that is where the outfit enters: a sponsor is an identity fact, and asking it for a hop count makes the answer depend on which role the sponsor is currently wearing. The single-stranded test settles it the same way it settled a rate bound one paper ago: **keep the ladder for sponsorship, and let routing read the coordinates it already has.**

This is a design finding rather than a booked change. `comlink/` is not this seat's module, and the repair belongs to the seat that holds it.

## Three things BAKERY can build, small and separable

**One -- `ring_gap(x, y, n)`.** Six lines, two asserts, no policy: the shorter way around one ring of `n` seats, `@min(d, n - d)` on the absolute difference. It is the kernel of the torus reading above *and* of the `seat_arc` handoff the elder paper left, so the two compose instead of competing. Bound: `n` under the 256-seat `tier_ceiling` the module already asserts; refuse when either coordinate is at or past `n`.

**A note on what a peer landed while this was being written.** `%452` (`20260906.002658`) corrected `route_hops`'s doc from *zero exactly when `a` and `b` are one point* to *the same **address***, and seated `prove_route_is_never_blind` over every ordered pair of both skies. That builds **two of the three things the elder paper handed over** -- the zero-hop witness and a doc line. **It repaired the metric's zero end.** The sentence this paper refutes, *the hop count from `a` to `b`*, is the other end and stands unchanged; re-run against the changed module `20260906.014200`, every number above is unmoved, since a doc line and a selftest moved and the arithmetic did not. Two invariants about one function: theirs proves the metric never confuses two points, and this one shows it is not a walk.

**Two -- the reachability guard, which reds today.** A witness asserting that every point reaches every other in the graph `route_hops` defines. **It will refuse at 132 isolated points**, which is the whole of its value: it turns a paragraph into a standing instrument, so the day the outfit question is settled, the guard says so. Hand it over as a statement of the fault rather than as a green.

**Three -- the other half of the doc line.** `%452` fixed the zero clause; the opening clause still reads *the hop count from `a` to `b`*, and it is exact between two addresses whose tiers are explicit and incomplete between two numbers, for the third of pairs measured above. One sentence naming which reading is which costs nothing and stops the next reader from rediscovering this.

## What this does not claim

**That the module is wrong in its own terms.** `route_hops` takes two `Address` values, and between two addresses at explicit tiers it is exact -- all 345,876 reachable ordered pairs agree. The fault appears only in the number space, and the number space is what a network routes between.

**That the torus is the right answer for Comlink.** It is *an* answer with measured properties, offered so a design argument can cite a number. Its diameter cost is real, its authority story is absent, and choosing it is a ruling this seat does not hold.

**Any energy claim about hops on an overlay.** A hop here is a socket, not a wire. Room one names the one energy statement that survives: dimension-order routing on a ring needs no routing table, and table lookups on every packet show up in a power budget. That is a horizon for Aurora on real boards, not a finding about Comlink today.

**That the ladder's flat distribution is itself a defect.** It is a consequence of shape. Whether it costs anything depends on what reads the metric, and this lap did not measure that.

## The falsifier

**This paper dies if a reader exhibits, in `comlink/`, a link between any star-index-zero planet and any other point.** The whole finding rests on those 132 points having no edge in the graph the metric defines. One real link, and the isolation is an artifact of how this census reads adjacency rather than a property of the metric.

The narrower one, for the ruling: **exhibit a routing decision that genuinely needs the sponsor chain** -- a next hop that cannot be computed from two coordinate triples without knowing who sponsors whom. That would show the two questions are one question after all, and the single-stranded argument above would fail.

*Horizon: both readings hold while `comlink/topology.rye` computes `decode` and `route_hops` as it does today; the census reads the fan-outs from the source, so a sky change is measured rather than assumed. Assumptions: adjacency is the metric's own unit distance, and distance is symmetric. Confidence: high -- every number re-derives in fifteen seconds, and both refusal paths were proven on metal.*

---

## Errata -- the primary falsifier fired, `20260906.105235`

**The body above keeps every word.** A dated page is corrected by erratum, so a reader sees the
claim and what the measurement did to it.

This page named one thing that would kill it: *a link between any star-index-zero planet and any
other point, in `comlink/`.* That link landed at `20260906.092125`, eight hours after this page
was written, in the commit *"comlink: the router's question, asked of numbers."* `Sky.point_hops`
walks the sponsor chain in **number** space, where a star of index zero and its galaxy are one
point rather than two, and `comlink/topology.rye` now asserts `point_hops(60, 0) == 1` in its own
selftest. Point 60 is a star-index-zero planet. **That is the exhibit, and this page dies as
written.**

**What it was right about.** The address-space reading is unchanged and still measures what this
page measured: `route_hops` publishes a distance for 172,524 of 518,400 ordered pairs that no walk
on its own unit-distance graph realizes, and the 132 isolated points are exactly the
star-index-zero planets, checked point by point. Every number above re-derives. The repair
happened *because* the reading was correct.

**What it was wrong about.** This page treated that isolation as a property of the metric rather
than of one of two questions the metric was being asked, and its closing section -- *what this
does not claim* -- did not include the possibility that the module could answer both. The cure
was not to correct `route_hops` but to notice the second question, and `route_hops` is untouched
today.

**What is measured now.** The census grew a **point leg** on `20260906.105235`, so both shipping
readings are walked rather than one. Compass sky, 720 points, all 518,400 ordered pairs:

| | `route_hops` | `point_hops` |
|---|---|---|
| Isolated points | 132 | **0** |
| Components | 133 | **1** |
| Pairs claimed and unrealized | 172,524 (33.28%) | **0** |
| Entropy against ceiling | 40.47% | 60.01% |
| Cut points, and their tiers | 59: 11 galaxies, 48 stars, 0 planets | 59: 11 galaxies, 48 stars, 0 planets |

**The one reading the repair did not move is the cut structure**, and it is the same on both sides
because it is a fact about hierarchy rather than about addressing: every interior point is an
articulation vertex, no leaf is, and the twelfth galaxy is absent from the count only because the
walk starts there. **A hierarchy's shape survived the repair; its addressing did not.**

The point leg's own five asserted pairs are bound to the module's, and the leg was proven able to
red three ways in a pen -- including the `%454` fault planted back, which it catches at the chain,
the depth and the sponsor pair at once.

*Horizon: this correction holds while `comlink/topology.rye` publishes both metrics. Assumptions
unchanged. Confidence: high -- the exhibit is a line in the module's own selftest, and every figure
re-derives in twenty-five seconds.*
