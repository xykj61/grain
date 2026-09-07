# What a Departure Costs a Table Everybody Shares

**Stamp:** `20260907.000309`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- external research, **mixed**. The numbers are measured and bound by a witness; the design reading is proposed (`context/TWO_ROOMS.md`).
**Instrument:** `tools/fixtures/t/topology_churn_scan.sh` -- witness `tools/t/topology_churn_witness.rish` -- control `tools/fixtures/t/topology_churn_control.sh`
**Elder:** [`what-it-costs-to-decide-the-next-hop`](20260906-195719_what-it-costs-to-decide-the-next-hop.md), whose coverage section named this gap and left it open

*A table every node agrees on is a beautiful object while the network is whole. This paper prices the first afternoon it stops being one.*

---

## What this paper bounds

Every figure here concerns the same **720 points** at **degree 5 or 6** the elder paper priced, on the same four shapes, measured on `20260906` and `20260907` on this bench by `tools/fixtures/t/topology_churn_scan.sh`. Every departure figure below removes points from a graph this scan builds and walks the remainder exhaustively. Nothing here implements anything: `comlink/topology.rye` publishes the seated three-ring reading, and this tree holds no routing code at all.

The elder paper measured that the exact routing table for a 720-point Cayley graph is **270 bytes**, and that it is the **same 270 bytes at every node** -- because the graph is vertex-transitive, so a route depends on the difference between two points rather than on the pair. It proved that end to end over all 517,680 ordered pairs from all 720 sources.

That proof rests on a condition a live network breaks the first afternoon it runs: **the graph has to be the whole group.** Remove one point and vertex-transitivity is gone, so the argument that produced the shared table no longer describes the graph the survivors are standing on. The elder paper named the gap in its own coverage section -- *how either shape behaves when a node leaves* -- and left it outside. This is that paper.

## The question, in the form that decides something

Global state stays where it is between departures, so the useful question concerns the table already in hand rather than the one a rebuild would produce. It is whether the survivors can keep using the table they already agreed on, and what that costs them. Four readings answer it, and the third is the one the elder paper's closing line actually asked for.

1. How much longer is the walk once a point is gone, even routed perfectly?
2. How much of that damage does the **stale** shared table deliver?
3. How many of the 719 entries actually **change**, and at which nodes?
4. How does the answer bend as departures accumulate, and does the *pattern* of loss matter?

## Two pieces of node state, priced against each other

One breadth-first walk from the identity yields two arrays, and the elder paper kept only the first.

| State | Size | What it holds | At a dead next hop |
|---|---|---|---|
| **table** | 719 entries x 3 bits = **270 bytes** | a generator index per difference | nothing else to read -- the packet is dropped |
| **distance** | 719 entries x 4 bits = **360 bytes** | a hop count per difference | descend to the live neighbour whose stale distance is smallest |

The generator index is recoverable from the distance array by picking the neighbour whose distance is one less, so the second strictly contains the first. On the intact graph they route identically. Under a departure they part company, and **the 90 bytes are exactly what the parting costs.** On the star graph they cost the same 270, since a diameter of 7 fits in the same three bits five generators do -- the graceful reading is free there.

A third rule joins them, and it spends a different resource. **`distance_nr`** holds the same 360 bytes at the node and gives the **packet** a visited set: descend to the smallest stale distance among live neighbours **not already on this walk**. It stays acyclic by construction, since the rule skips any point already on the walk. Its cost is packet header rather than node memory, and the scan prices that too.

## Why one removed point is representative, and how the check went wrong first

G minus v is isomorphic to G minus w for any two points of a vertex-transitive graph, so a single-departure reading holds whichever point left. That is an argument, and the `hole` leg checks it -- three removed points, four readings each, required to agree exactly.

**The first draft of that leg read `agree=no` on a graph that is genuinely vertex-transitive**, and the reason is worth carrying. The leg samples destinations to stay cheap, and it sampled them in **absolute** numbering while the hole moved. The isomorphism carrying G minus v onto G minus w is translation by the difference, so it carries destination `t` to `t` plus that shift: a sample fixed in absolute numbering names a **different relative set** at each probe. Three probes measured three different things and looked like one comparison. Translating the sample with the hole is what makes a comparison a comparison, and with that one change the three probes agree exactly:

```
hole shape=circ probes=3 removed=0,137,421 signature=42362/10/393/42176/42176 agree=yes
```

A check that compares two things must first be sure it is comparing them under the same coordinates. This one measured under two, and it said so out loud rather than passing quietly, which is the whole reason the leg exists.

## What the graph actually loses

One point leaves. Every surviving ordered pair is walked breadth-first on the punctured graph and compared against its intact distance.

| Shape | Degree | Diameter | Damaged pairs | of 516,242 | Extra hops | Worst | +1 | +2 | Punctured diameter |
|---|---|---|---|---|---|---|---|---|---|
| circulant `C_720(1,8,75)` | 6 | 9 | **84** | 0.016% | 152 | 2 | 16 | 68 | 9 |
| torus 12x5x12 -- the seated shape | 6 | 14 | **42** | 0.008% | 82 | 2 | 2 | 40 | 14 |
| torus 8x9x10 | 6 | 13 | **30** | 0.006% | 54 | 2 | 6 | 24 | 13 |
| star `S_6` | 5 | 7 | **980** | 0.190% | 1,960 | 2 | 0 | 980 | 7 |

**The graph barely notices.** Every pair on every shape stays connected, and every diameter holds. The longest walk that grows, grows by two hops. On three of the four shapes fewer than one pair in ten thousand is affected at all.

**The star graph is the exception, by an order of magnitude**, and the reason is structural rather than incidental: it has fewer shortest paths per pair to fall back on. Its detour column says so exactly -- **every one of its 980 damaged pairs costs exactly 2**, with the `+1` column at zero. The star graph is a Cayley graph on transpositions, which are odd permutations, so it is bipartite: every walk between two points has the same parity, and a detour therefore costs an even number of extra hops. A bipartite shape pays its detours in twos. The two tori and the circulant each carry a generator of each parity, and their `+1` columns are nonzero accordingly.

## What the stale table loses, which is forty-five times more

Now route every surviving pair with the table the network already agreed on.

| Shape | Table drops | Drop share | Graph damage | Ratio |
|---|---|---|---|---|
| circulant | 3,811 | 0.738% | 84 | **45x** |
| torus 12x5x12 | 4,465 | 0.865% | 42 | **106x** |
| torus 8x9x10 | 4,121 | 0.798% | 30 | **137x** |
| star `S_6` | 2,725 | 0.528% | 980 | 2.8x |

**The graph loses 84 pairs and the table loses 3,811 of them**, because the table committed to one path. A shortest walk usually has siblings; a table entry names one of them, so a departure that the graph routes around still kills every route whose chosen path crossed it.

**And that number is predictable before it is measured.** A walk of `h` hops passes through `h - 1` intermediate points, spread over the `n - 1` points that are not its own endpoints, so the share of pairs a departure kills is `(mean hops - 1) / (n - 1)`. The scan computes that from the intact walk and prints it beside the measurement:

| Shape | Mean hops | Predicted drops | Measured | Residual |
|---|---|---|---|---|
| circulant | 6.3004 | 3,805.7 | 3,811 | +5.3 |
| torus 12x5x12 | 7.2100 | 4,458.8 | 4,465 | +6.2 |
| torus 8x9x10 | 6.7316 | 4,115.3 | 4,121 | +5.7 |
| star `S_6` | 4.7900 | 2,721.2 | 2,725 | +3.8 |

Every residual is under seven pairs -- roughly one part in a hundred thousand -- and every one is positive, which the mechanism also explains: the prediction averages over all pairs while the measurement excludes the pairs that ended at the departed point, and those were the shorter ones.

**So a shape's routing advantage compounds into a churn advantage.** The circulant's shorter walk is why it loses fewer packets per departure than either torus, and the star's shorter walk again is why it loses fewest of all -- while being, by the previous table, the shape a departure damages most. Those two facts sit in different columns and both are true: **the star graph's routes are the most fragile and the fewest of them cross any given point.**

## How many entries actually change

This is the elder paper's own closing question, asked exactly. For every surviving node and every destination, is the shared table's entry still a first hop on a shortest **punctured** walk? A live neighbour one step closer is the whole test.

| Shape | Entries | Changed | Share | Nodes needing no change | Nodes needing a change | Worst node |
|---|---|---|---|---|---|---|
| circulant | 516,242 | **925** | 0.179% | **638** of 719 | 81 | 311 |
| torus 12x5x12 | 516,242 | **805** | 0.156% | **669** of 719 | 50 | 359 |
| torus 8x9x10 | 516,242 | **794** | 0.154% | **668** of 719 | 51 | 359 |
| star `S_6` | 516,242 | **1,576** | 0.305% | **489** of 719 | 230 | 359 |

**Between 99.69 and 99.85 percent of the shared table is still exactly right after a departure.** On the two tori more than nine nodes in ten hold a table that stands unchanged, on the circulant just under nine in ten, and on the star graph a little over two in three.

**The cause splits in two, and the split is the design finding.** A **dead first hop** is something a node sees for itself -- its own neighbour stopped answering. A **live first hop whose onward path broke** is invisible from where the node stands, and needs word from further away.

| Shape | Dead first hop | Stale onward path | Ring 1 | Ring 2 | Ring 3 | Ring 4+ |
|---|---|---|---|---|---|---|
| circulant | **713** | 212 | 713 | 67 | 55 | 90 |
| torus 12x5x12 | **713** | 92 | 713 | 38 | 26 | 28 |
| torus 8x9x10 | **713** | 81 | 713 | 40 | 28 | 13 |
| star `S_6` | **714** | 862 | 714 | 268 | 258 | 336 |

**The dead-hop count is exactly `n - 1 - degree`, on every shape, and it can be derived rather than measured.** Write `u` for a neighbour of the departed point `v`, so `u = v g^{-1}` for one generator `g`. The entry at `u` for destination `t` is dead exactly when the table sends it into `v`, which is when `BRANCH[d] = g` for `d = u^{-1} t`. Run over every non-identity difference `d`: each has exactly one table entry `g = BRANCH[d]`, which names exactly one such pair -- and the pair is excluded only when `d = g`, meaning the destination is `v` itself. So the count is the number of non-identity differences less the number of generators: `719 - 6 = 713` at degree 6, and `719 - 5 = 714` at degree 5. Both are what the scan reads.

**The derivation carries one condition, and it is worth naming.** It counts one dead entry per generator per difference, which needs the `deg` neighbours of a point to be `deg` distinct points -- so no generator may be its own inverse in a way that collapses two edges into one. All four shapes here satisfy it: the circulant's `1`, `8`, and `75` are none of them 360, the tori's rings are all longer than two, and the star graph's five swaps land on five distinct permutations. A shape carrying an involution would land below the count, and the falsifier below is written to that.

**Every dead-hop change sits at ring 1**, which the same derivation predicts and the histogram confirms: only a neighbour of the hole can have a dead first hop. So the local, self-detectable part of the damage is a **fixed 713 entries held by exactly six nodes**, whatever shape is chosen.

**Only the non-local part discriminates**, and it discriminates sharply: 81 entries on the better torus, 212 on the circulant, **862 on the star graph**. That is the first column in either paper where the seated torus wins outright, and it is worth saying plainly after the elder paper's reversal: **against the better torus's 81, the circulant walks shorter and carries 2.6 times the non-local repair, and the star graph walks shortest of all and carries 10.6 times it.**

## What the state buys, measured three ways

| Shape | Rule | Bytes | Arrival share | Optimal | Extra hops | Failures |
|---|---|---|---|---|---|---|
| circulant | table | 270 | 0.992618 | 512,431 | 0 | 3,811 dropped |
| circulant | distance | 360 | 0.997383 | 514,884 | 11 | 1,351 cycled |
| circulant | distance + packet memory | 360 | **1.000000** | 514,947 | 2,575 | none |
| torus 12x5x12 | table | 270 | 0.991351 | 511,777 | 0 | 4,465 dropped |
| torus 12x5x12 | distance | 360 | 0.997166 | 514,757 | 22 | 1,463 cycled |
| torus 12x5x12 | distance + packet memory | 360 | **1.000000** | 514,790 | 2,894 | none |
| torus 8x9x10 | distance + packet memory | 360 | **1.000000** | 515,082 | 2,302 | none |
| star `S_6` | distance + packet memory | 270 | 0.999946 | 514,729 | 10,028 | 28 stalled |

**Ninety bytes cuts the failures by roughly two thirds**, from a drop to a cycle: the distance array holds enough to derive an alternative where the generator index holds only the answer.

**A packet that remembers where it has been closes the rest on the three abelian shapes**, delivering every one of the 516,242 pairs, at a mean stretch of 0.005 hops and a worst walk of 11 to 16. Priced honestly, that memory is packet header rather than node memory: the worst walk observed needs 110 to 160 bits of visited set at 10 bits a point.

**On the star graph the same rule frays**, stalling on 28 pairs, wandering to 63 hops, and spending 10,028 extra hops where the circulant spends 2,575. A non-abelian address makes the descent hard to un-stick once it leaves a shortest path, which is the same fact the elder paper found from the other side when the star graph alone could tell one end of a shortest word from the other.

## Where the repair belongs

Two counts of the same departure disagree by a factor of seven, and the disagreement is the practical answer.

| Shape | Nodes whose **traffic** a departure hurts | Nodes whose **table** it makes wrong |
|---|---|---|
| circulant | 569 of 719 -- **79%** | 81 -- **11%** |
| torus 12x5x12 | 599 -- **83%** | 50 -- **7%** |
| torus 8x9x10 | 575 -- **80%** | 51 -- **7%** |
| star `S_6` | 433 -- **60%** | 230 -- **32%** |

**Four nodes in five lose packets and one node in ten is wrong**, because the packets die at the hole rather than at their source. The mean graph distance from the hole to one of the 551 nodes the distance rule still leaves short is 5.7 on the circulant, and 6.8 to one of the 571 on the seated torus -- effectively the whole network, since the mean walk is 6.3 and 7.2. Damage spreads by **paths through** the hole rather than by proximity to it.

**So repair belongs at the hole's own neighbours rather than at the sources.** Six nodes hold the self-detectable fix for a fault that reaches five hundred and sixty-nine, and those six can detect it alone, without a message from anyone. This is a stronger statement than *the table survives churn*: it says which nodes have to do anything at all.

## The curve, and the pattern that surprised us

Departures accumulate. The scan removes `k` points for `k` in 1, 2, 4, 8, 16, 32, 64 under two named patterns and routes with the distance rule. **Spread** takes points `i x 137 mod 720`, coprime to 720, which is the independent-departure model. **Cluster** takes a breadth-first ball around one point, which is clustered in every shape rather than in the index, and is the correlated-failure model -- one region, one rack, one operator going dark together.

**No shape ever split**, at any `k`, under either pattern: 56 configurations, `connected=yes` in all 56, up to 64 points gone -- 8.9 percent of the network.

Arrival share at `k = 64`, with the intact shared table and no rebuild anywhere:

| Shape | Spread | Cluster | Cluster advantage |
|---|---|---|---|
| circulant | 0.7672 | **0.9494** | 1.24x |
| torus 12x5x12 | 0.8196 | **0.9375** | 1.14x |
| torus 8x9x10 | 0.8454 | **0.9393** | 1.11x |
| star `S_6` | 0.7319 | **0.9000** | 1.23x |

**A scattered loss hurts a shared table more than a clustered loss of the same size**, on every shape, and the gap widens with `k`. The mechanism follows from what the table is: a global object indexed by difference. Sixty-four departures in one region poison the routes through one region and leave the rest of the table true. Sixty-four departures scattered evenly poison routes everywhere, and a walk of six hops has six chances to meet one.

This reverses the intuition that correlated failure is the harder case. For a *replicated* store it is; for a *shared table* it is the easier one, and the difference is worth holding onto because the two live in the same system.

**One reading in that leg needs its bias named.** The mean walk of the packets that *arrive* falls as `k` rises -- 6.3004 to 6.0884 on the circulant -- while the mean walk the punctured graph *offers* rises, 6.3004 to 6.3875. Both are true and only the second is about the network: the routes that fail are the long ones, so the deliveries that survive look shorter than the network is. A meter reading only the successes would report a network getting faster while it got worse.

## What is measured, what is derived, and what is neither

**Measured.** Every distance, damaged pair, drop, cycle, stall, stretch, and changed entry, on graphs this scan builds and walks. The single-departure legs are exhaustive over all 516,242 surviving ordered pairs on all four shapes. The transitivity check is exhaustive over its 42,362 probe pairs at three removed points.

**Derived, and then confirmed against the measurement.** The drop prediction `pairs x (mean hops - 1) / (n - 1)`, within six pairs on all four shapes. The dead-hop count `n - 1 - degree`, exactly on all four. The bipartite parity argument for the star graph's detour column, exactly. Each was written down before its number was read, which is the only reason the agreement means anything.

**Definitions rather than findings.** The three routing rules, each the most natural rule its state supports -- a better rule for the same state would move its numbers. The two removal patterns. The 60-destination sample the curve and the hole leg use, named where it is taken.

**Outside all of it.** What a table costs to **agree on** rather than to store, which is a consensus question and a different paper. What a *joining* node costs, which differs from the mirror of a departure, since a joiner earns its address only when the group grants one. Whether any of this survives at a size where one walk can still enumerate the group.

## The falsifier

*Horizon: this holds while the sky carries 720 points at degree 5 or 6, while a route is a walk on an undirected graph with hop count as its cost, and while departures are silent -- a point stops answering and says nothing. Assumptions: every shape is a Cayley graph under right multiplication, so a route depends on the difference; the shared table names a generator index and the distance array a hop count; the three routing rules and the two removal patterns are as defined above. Falsifier, in five parts, each cheap: exhibit a shape of degree d on this group whose generators give d distinct neighbours and whose dead-hop entry count differs from `n - 1 - d`, and the derivation is wrong rather than merely unproven in general; exhibit a departure whose measured drop count departs from `pairs x (mean hops - 1) / (n - 1)` by more than a hundred, and the "routes that crossed it" mechanism is not what is happening; exhibit two removed points whose four probe readings disagree under a translated sample, and vertex-transitivity is not what this rests on; exhibit a removal of 64 or fewer points that disconnects any of these four shapes, and the connectivity claim falls; exhibit a clustered removal that beats its spread counterpart on arrival share at any k, and the pattern reading is an artifact of these two definitions. Confidence: high on every single-departure number, each an exhaustive walk bound by a witness with a control that breaks it ten ways; high on the two derivations, which were predicted before measurement and agree exactly or within six pairs; medium on the curve, whose destinations are a 60-point sample rather than exhaustive; medium on the pattern finding, measured on two definitions of pattern rather than on a family of them; low on whether a live network's departures resemble either pattern, which is a fact about deployments and not about graphs.*

## What this hands the seated design

**The 270-byte shared table survives churn, and the survival is not close.** After a departure it is between 99.69 and 99.85 percent correct, roughly nine nodes in ten hold it unchanged on the three abelian shapes, and the part that is wrong is dominated by a fixed `n - 1 - degree` entries sitting at the hole's six neighbours, who can detect the fault for themselves.

**The 90 bytes that turn it into a distance array are the best-value line in either paper.** They convert a drop into a detour on three shapes and ride free on the fourth.

**The elder paper's reversal stands, and this one narrows it.** The circulant still walks shorter than the seated torus and loses fewer packets per departure. It also carries 2.3 times the seated torus's non-local repair -- 212 entries against 92 -- so the ring reading now buys something measurable rather than legibility alone -- and the star graph, which walks shortest, is the most fragile shape here by every reading in this paper.

## Gratitude

Cayley graphs, vertex-transitivity, and the fault-tolerance literature on interconnection networks are studied rather than borrowed; the change-making and bipartite-parity readings are old and well known, restated here in our own terms. Every graph was built and walked in this tree, and every number was measured on this bench rather than recalled from a table.
