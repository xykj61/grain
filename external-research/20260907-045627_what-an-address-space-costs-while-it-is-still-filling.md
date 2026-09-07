# What an Address Space Costs While It Is Still Filling

**Stamp:** `20260907.045627`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- external research, **mixed**. Every number below is measured and bound by a witness; the design reading is proposed (`context/TWO_ROOMS.md`).
**Instrument:** `tools/fixtures/t/topology_growth_scan.sh` -- witness `tools/t/topology_growth_witness.rish` -- control `tools/fixtures/t/topology_growth_control.sh`
**Elder:** [`what-a-departure-costs-a-shared-table`](20260907-000309_what-a-departure-costs-a-shared-table.md), which priced a full space losing a point and left the filling regime outside
**Kin:** [`the-shape-you-grew-and-the-shape-you-are`](../foundations/20260823-105651_the-shape-you-grew-and-the-shape-you-are.md) -- Gall's law is the allocator here, rather than a lens on one

*A routing table computed for a whole address space is stale from the first day, because on the first day the space is nearly empty. This paper prices that day, and finds the cost sitting somewhere nobody had looked: not in the table, and not in the allocator, but in the numbering both of them inherited.*

---

## What this paper bounds

Every figure concerns the same **720 points at degree 5 or 6** on the same four Cayley graphs the two elder papers priced -- the circulant on Z_720 with generators 1, 8 and 75; two three-dimensional tori, 12x5x12 and 8x9x10; and the star graph on the 720 permutations of six symbols. All were measured on `20260907` on this bench by `tools/fixtures/t/topology_growth_scan.sh`, a 21-second pass over five allocation policies at six occupancies, routing every live ordered pair two ways from 24 sampled destinations.

**Nothing here implements anything.** `comlink/topology.rye` publishes the seated three-ring reading; this tree holds no routing code and no address allocator at all. Every number below is a measurement of a graph, and every design sentence is proposed.

**The occupancies are 5, 10, 20, 30, 50 and 75 percent.** Six points bracket the transition described below without resolving it; a finer sweep is named in *What this does not reach*.

## The question the elder papers left open

The elder work established that the exact routing table for a 720-point Cayley graph is **270 bytes**, and that it is the *same* 270 bytes at every node, because the graph is vertex-transitive and a route therefore depends on the difference between two points rather than on the pair. That proof is whole, and it holds over all 517,680 ordered pairs.

It rests on one condition: **the graph has to be the whole group.** The departure paper asked what happens when a point leaves. This paper asks the question that comes first in time and lasts far longer -- **what happens before the points have arrived.**

A network begins with one node and fills over months or years. Every node holds a table describing a graph that has mostly yet to arrive. The live set is chosen by an **allocation policy**, and the policy is the subject.

## Five policies, and what each one knows

| Policy | What it knows | What it costs to run |
|---|---|---|
| `lowfree` | a counter | one integer, shared |
| `random` | nothing at all | nothing -- an address derived from a public key |
| `grow_ball` | the graph; frontier taken breadth-first | a live peer to ask |
| `grow_snake` | the graph; frontier taken depth-first | a live peer to ask |
| `lowfree_bfs` | a counter, over a breadth-first **numbering** | one integer, shared |

The first two are **numbering-blind** and the last three are **graph-aware**, and the split is the finding rather than the setup. `random` is what a self-sovereign identity system wants, since nobody assigns an address derived from a key and nobody can withhold it. `lowfree_bfs` is the interesting one: the allocator is still a bare counter that knows nothing, and the knowledge has moved into the numbering, which is published once when the space is designed.

**Connectivity under the two grow policies is a tautology and is not a finding.** Each grown point attaches to a point already live, so the induced subgraph is connected by construction. The scan prints `components=1` there so a reader can watch it hold; what actually decides something is the stale table's arrival share.

## One sixth of a star graph is an independent set

The mechanism behind everything below is a theorem, and the instrument checks it by counting edges rather than by trusting the argument.

Lexicographic rank orders the string `a1 a2 ... a6`, so the first 120 ranks are exactly the permutations with `a1 = 1`. Every star generator swaps position 1 with some position j, so a neighbour of such a permutation has `a1 = aj`, which is not 1, and therefore has rank at least 120.

**The first 120 lexicographic ranks of S_6 form an independent set: a sixth of the space, allocated first by any lowest-free counter, and mutually unreachable.**

Measured, over the largest edgeless prefix of each shape's own numbering:

```
indep shape=circ    prefix_edgeless_max=1   share_of_space=0.0014
indep shape=torus12 prefix_edgeless_max=1   share_of_space=0.0014
indep shape=torus8  prefix_edgeless_max=1   share_of_space=0.0014
indep shape=star    prefix_edgeless_max=120 share_of_space=0.1667
```

The three coordinate shapes read **1**, and that mirror is load-bearing. Their numberings ravel the coordinates, so index `i` and index `i+1` differ by a generator step; a leg that found the star failing and never found a shape passing could not be told from a leg that finds edges nowhere.

## What the first afternoon actually looks like

The star graph at 5 percent occupancy, under a lowest-free counter:

```
growth shape=star policy=lowfree live=36 occupancy=0.0500
  components=36 largest=1 connected=no pairs=840 unreachable=840
  table_arrival_share=0.000000 dist_arrival_share=0.000000
```

**Thirty-six nodes, thirty-six components, largest component one.** Every early adopter is alone. All 840 ordered pairs are unreachable, by any route, from any table. The condition persists to 10 percent, and at 75 percent the space is still in eight pieces.

The same graph, the same counter, the same occupancy -- and a breadth-first numbering underneath:

```
growth shape=star policy=lowfree_bfs live=36 occupancy=0.0500
  components=1 largest=36 connected=yes pairs=840 unreachable=0
  table_arrival_share=0.682143 dist_arrival_share=0.852381
```

**One component, and 85 percent of pairs arrive on the stale table.** The allocator did not change. The graph did not change. The occupancy did not change. Only the order in which the addresses were written down.

## The premium, priced both ways

Averaged over all six occupancies, split by whether the shape's numbering is a coordinate ravel or a permutation rank:

| Policy | coordinate shapes (18 rows) | | star graph (6 rows) | |
|---|---|---|---|---|
| | whole | graceful arrival | whole | graceful arrival |
| `lowfree` | 18/18 | **0.9597** | **0/6** | **0.0284** |
| `lowfree_bfs` | 18/18 | 0.9493 | 6/6 | 0.6884 |
| `grow_ball` | 18/18 | 0.9482 | 6/6 | 0.6886 |
| `grow_snake` | 18/18 | 0.9449 | 6/6 | 0.3496 |
| `random` | 2/18 | 0.1456 | 1/6 | 0.1125 |

Read the first two rows together, because they are the paper.

**On a coordinate shape the plain counter is the best policy measured**, at 0.9597 -- better than every graph-aware policy, because the ravel already encodes a generator and the counter is accidentally graph-aware. **On the star graph it is the worst measured**, at 0.0284, and worse than `random` by the reading that matters most: `random` reaches one whole configuration out of six and `lowfree` reaches none.

So the breadth-first numbering is an **insurance premium**, and both sides of it are measured:

- **It costs 0.0104 absolute on the coordinate shapes** -- 0.9597 down to 0.9493, a relative loss of **1.1 percent**.
- **It pays 0.6600 absolute on the star graph** -- 0.0284 up to 0.6884, a factor of **24**.

A premium of one percent against a payout of twenty-four times, on a property the designer cannot check by looking at the allocator, is a trade this paper proposes taking.

## Why nobody notices

The reason this stays invisible is worth stating plainly, because it is the general form.

A coordinate numbering is built **from** the generators. `v = (x*q + y)*r + z` means `v` and `v+1` are neighbours everywhere except at a wrap, so `lowfree` on a torus is a graph-aware allocator wearing a counter's clothes. It has always been right, and it has always borrowed the reason from the numbering.

The star graph asks the counter to stand alone. Lexicographic rank is built from a different idea than transpositions, so the counter shows what it has always been: a policy that borrows its opinion of the graph from whoever wrote the addresses down.

**Contiguity is a property of a numbering. Connectivity is a property of a graph.** In a coordinate space they coincide, which is why the distinction has no name. In a permutation space they come apart completely.

The `grow_snake` column is the same lesson at lower volume. On coordinate shapes the depth-first grower **is** the lowest-free counter exactly -- the circulant's rows agree digit for digit at every occupancy, because generator `+1` always offers the lowest free neighbour of a filled prefix -- and on the star graph it reaches 0.3496 where the breadth-first grower reaches 0.6886. **The tie-break decides the shape of what grows**, a ball or a snake, and a snake is connected and long where a ball is connected and compact.

## What a self-sovereign address costs

`random` is what you get when an address is a hash of a public key: no registry, no counter, no coordination, and nobody who can refuse you. That is a real property worth wanting, and this is what it costs.

Across eight independent pseudorandom draws at each occupancy on each shape -- 24 rows, so the single-draw numbers above are bounded rather than anecdotal -- **no draw on any shape is whole below half full.** The four occupancies that reach a connected draw are all at three quarters full.

The largest component as a share of the live set, per shape, is the transition:

| occupancy | circ | torus12 | torus8 | star |
|---|---|---|---|---|
| 5% | 0.056 | 0.111 | 0.056 | 0.083 |
| 20% | 0.069 | 0.076 | 0.069 | 0.090 |
| 30% | 0.347 | 0.352 | 0.208 | 0.255 |
| 50% | 0.983 | 0.983 | 0.989 | 0.967 |
| 75% | 0.998 | 1.000 | 1.000 | 1.000 |

*Observation:* the giant component emerges between 30 and 50 percent occupancy on all four shapes.
*Inference:* this is ordinary site percolation, and the mean-field estimate for a d-regular graph, `1/(d-1)`, gives 0.20 at degree 6 and 0.25 at degree 5. The measured transition sits above both, which is what a finite graph with short cycles gives -- the tree approximation the estimate rests on does not hold here.
*The agreement is in order of magnitude and is offered as a cross-check rather than a confirmation.* Six occupancy points cannot locate a threshold; they can only bracket it.

*Projection, and the one a design would act on:* a network whose addresses are derived from keys spends its entire early life -- every day below roughly a third full -- as several disconnected networks that cannot see each other, and no routing table repairs it, because there is no path to route along. **Horizon:** the design of Comlink's address space, before any allocator is written. **Falsifier:** a measurement at finer occupancy showing a giant component below 20 percent on any of these four shapes, or showing that a bootstrap-peer overlay recovers reachability without additional links. **Confidence:** high for the measurement, moderate for the projection, because a real network carries out-of-band introductions this model does not.

## The graceful rule walks a geodesic or it stalls

One result arrived as a correction and is sharper than what it replaced.

An early draft printed a stretch -- mean hops over mean optimum -- and it read **below one on 68 of 96 rows**, which would mean routing beating the shortest path. The two means were over different populations: hops averaged the pairs that arrived, and the optimum averaged every pair the live subgraph connects, including the long ones that stall. A ratio of those two answers a different question.

Removing it left the real statement standing, and it is stronger. **Every generator step changes the full-space distance to the destination by at most one**, since the generator set is symmetric and the shape is a Cayley graph; **the graceful rule requires a strict decrease**; so a walk that arrives has length exactly the stale distance it started from. A live path of that length cannot exceed the live distance, and a subgraph cannot be shorter than the full graph, so the three are equal.

**The rule therefore never routes around a hole.** It walks a fully-live full-space geodesic or it stalls, and there is no third outcome and no stretch to measure. Its arrival share is exactly *the share of live ordered pairs joined by a shortest path that happens to be entirely live.* Measured across all 120 configurations, **zero rows arrive off a geodesic**, and the control proves the reading breaks when the strict comparison is loosened.

This is why the graceful rule's 90 extra bytes buy so much less during growth than during churn: a hole made by one departure has live detours around it, and a space that is 95 percent dark does not.

## What connectivity does not tell you

The control taught one thing worth carrying out of it. A plant disarms the grower's free-neighbour test, so it re-selects addresses it already holds and the live set stalls at **two points** while the counter believes it grew. That broken row prints `components=1`, `connected=yes`, and `table_arrival_share=1.000000` -- a perfect score on a network of two.

The plant was first aimed at the connectivity reading and passed clean, which is how the wrong tell was found. **A shape metric reads its best on a degenerate input**, so the live count is the tell and connectivity is not. The same caution applies to every `components=1` in this paper's grow rows, and it is why those rows are printed as a check rather than offered as a result.

## What this does not reach

**Where the percolation threshold actually is.** Six occupancy points bracket it between 0.30 and 0.50 and cannot locate it. A sweep at one-percent resolution over that band is the next instrument, and it is cheap -- the `seeds` leg is 0.36 seconds.

**Departures during growth.** This paper fills and never empties; the elder paper empties and never fills. A real network does both at once, and the interaction is unmeasured.

**Any shape but these four, and any size but 720.** The independent-set argument generalises to the star graph on S_n for every n -- the first `(n-1)!` ranks always fix the first symbol -- yet the arrival shares do not, and nothing here says how the readings move with n.

**What an introduction protocol recovers.** `random` looks catastrophic here because reachability is measured through graph edges alone. A joining node that keeps its bootstrap peer as a permanent link is building a different graph, and this instrument does not model it. That is the most likely way the `random` bill is overstated, and it is named rather than assumed away.

**Whether any of this is the right shape for Comlink.** These are four candidates measured against each other, not a recommendation about the address space itself.

## Buildable, and for whom

Handed to BAKERY, in the order the measurement supports:

1. **Publish the address space in breadth-first order.** It costs one array computed once when the space is designed, keeps the allocator a bare counter, and is the whole difference between a network and a pile of isolated points on any shape whose numbering is not already a coordinate ravel. Measured premium 1.1 percent, measured payout 24x.
2. **If addresses must be derived from keys, budget for a disconnected early network** and design the introduction protocol as load-bearing rather than as bootstrap convenience. Below a third full it is the only thing holding the network together.
3. **Read the live count beside every `components=1`.** A shape metric reads its best on a degenerate input.

Not buildable, and named as such: the finer percolation sweep and the fill-and-empty model are measurements rather than modules, and neither is needed before an address space is chosen.

---

*May the order we write things down in be the order they can reach each other in. May the counter stay simple and the numbering carry what it must. And may the first two nodes find each other before the third arrives.*
