# What It Costs to Decide the Next Hop

**Stamp:** `20260906.195719`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- external research. The numbers are measured and bound by a witness; the design reading is proposed (`context/TWO_ROOMS.md`).
**Instrument:** `tools/fixtures/t/topology_routing_scan.sh` -- witness `tools/t/topology_routing_witness.rish` -- control `tools/fixtures/t/topology_routing_control.sh`
**Elder:** [`the-floor-you-can-stand-on`](20260906-152821_the-floor-you-can-stand-on.md), whose closing paragraph named the cost this paper prices

*A shorter walk is worth what it costs to find. The walk already had a number; this paper gives the finding one.*

---

## What this paper bounds

Every figure here concerns **720 points**, the size of the seated sky, at **degree 5 or 6**, the wire budgets already on the table. Every hop count, table size, and stretch was measured on `20260906` by building each graph and walking it, on this bench, in `tools/fixtures/t/topology_routing_scan.sh`. Nothing here implements anything: `comlink/topology.rye` publishes the seated three-ring reading, and this tree holds no routing code at all.

The elder paper measured that a circulant on 720 points walks at diameter **9** where the seated three-ring torus walks at **14**, on the same six edges per point. It closed on a trade it left unpriced: a torus's coordinates mean something and route by subtraction, while a circulant's jumps are arithmetic that happens to work. That sentence holds two separable questions and one judgment, and only the judgment had to stay a judgment.

- Can a node route with **no table at all**, by a local rule, and how much longer is that walk?
- If it wants exact routing, what does the **table** cost?
- Is a ring reading worth paying for? -- which stays a judgment, and gets smaller once the first two are answered.

## The structural fact everything here rests on

Each shape in this paper is a **Cayley graph**: its points are a group, and its edges are right multiplication by a fixed set of generators. That makes it **vertex-transitive** -- the graph looks identical from every point -- so a shortest walk depends on the **difference** between source and destination rather than on the pair.

Two consequences follow, and both are load-bearing.

**One walk from the identity produces the whole answer.** A single breadth-first search from the identity yields the exact distance to every point, so the measurements below cost one walk per shape rather than 720.

**One table serves every node.** Because the answer is a function of the difference, the next-hop table is indexed by difference, and every node holds the *same* table. That is the difference between a table each node builds and a table the network agrees on once.

Neither is assumed here. The scan checks the first against a full 720-source breadth-first walk over all 517,680 ordered pairs, and the second by taking the identity's own table and routing from every one of the 720 sources with it.

## What the exact table costs

One breadth-first walk from the identity records, for every point, which of the identity's own neighbours starts a shortest path there. That array **is** the shared table: at node `u` routing to `t`, the difference indexes it and the answer is a generator index.

| Shape | Degree | Diameter | Exact mean hops | Entries | Bits/entry | Shared bytes | Per-node bytes |
|---|---|---|---|---|---|---|---|
| torus 12x5x12 -- the seated shape | 6 | 14 | 7.2100 | 719 | 3 | **270** | 194,130 |
| torus 8x9x10 | 6 | 13 | 6.7316 | 719 | 3 | **270** | 194,130 |
| circulant `C_720(1, 8, 75)` | 6 | 9 | 6.3004 | 719 | 3 | **270** | 194,130 |
| star `S_6` | 5 | 7 | 4.7900 | 719 | 3 | **270** | 194,130 |

**The exact routing table for a 720-node network of any of these shapes is 270 bytes**, and it is the same 270 bytes at every node. The right-hand column is what the same information costs when each node keeps its own copy indexed by destination -- 720 times more, carrying exactly as much knowledge.

That table was **proven to route**, rather than argued to: routing all 517,680 ordered pairs with the identity's table arrives in exactly the breadth-first distance every time, `wrong=0`. The check is worth its seconds because the failure it catches is silent -- a table built from the wrong end of the path holds perfect *distances* and routes nowhere, and looks correct in a dump.

**One reading crosses instruments and is worth naming.** The exact mean hops above -- 7.2100, 6.7316, 6.3004, 4.7900 -- were read here from a single walk out of the identity. The elder instrument read the same four numbers from an all-pairs walk over 517,680 pairs, on a different day, in a different script. They agree to four decimal places, which is vertex-transitivity confirmed twice by two hands rather than asserted once.

**And the table is order-insensitive on three of the four shapes, which is a fact about the group.** Building it from the **last** generator on a shortest path rather than the first leaves both tori and the circulant routing perfectly -- 719 of 719 each -- because their generators commute, so the last step of a shortest word is a valid first step of another shortest word. The star graph, on a non-abelian group, drops to **5 of 719**. Commutativity buys a freedom in how the table is built that a permutation address charges for, and it is the first place in either paper where being abelian pays rather than costs.

## Routing with no table at all

A table-free rule reads the destination and the node's own address, and picks a neighbour. Each shape gets the most natural rule its address space supports.

**The torus** rule is coordinate subtraction: reduce the first axis still wrong, taking the shorter way round that ring. **The circulant** rule is the only local reading a single integer supports: take the neighbour whose ring distance to the destination is smallest. **The star graph** rule sorts the difference: if position one carries a symbol that is not home, swap it home; otherwise swap in any symbol that is not.

| Shape | Rule | Optimal | Share | Mean hops | Mean stretch | Worst stretch | Greedy diameter | True |
|---|---|---|---|---|---|---|---|---|
| torus 12x5x12 | axis subtract | 719/719 | **1.0000** | 7.2100 | 0 | 0 | 14 | 14 |
| torus 8x9x10 | axis subtract | 719/719 | **1.0000** | 6.7316 | 0 | 0 | 13 | 13 |
| star `S_6` | sort the difference | 719/719 | **1.0000** | 4.7900 | 0 | 0 | 7 | 7 |
| circulant `C_720(1,8,75)` | smallest ring gap | 609/719 | **0.8470** | 6.6565 | 0.3561 | 6 | 12 | 9 |

**Two of the three address spaces route optimally with no table.** A torus address is a coordinate vector, and the shortest walk is the coordinate difference, so the rule and the answer are the same arithmetic. A star-graph address is a permutation, and the shortest walk is the sort, which the rule performs. Both are **exact and free**, and that is the real content of "the coordinates mean something."

**A circulant address is one integer, and the shortest walk is a representation problem.** Reaching a difference of `d` in fewest hops means writing `d` as a shortest signed sum of the generators, which is the change-making problem in disguise -- and the greedy rule is the greedy coin algorithm, which is exact only for coin systems that happen to be canonical. `{1, 8, 75}` is not one. It routes optimally to 84.70 percent of destinations, misses by 0.3561 hops on average, and by as much as **6 hops** in the worst case.

## The lookahead that buys nothing

The obvious repair is to look further before stepping. Score each first hop by the best ring gap reachable in a **second** hop -- thirty-six evaluations per decision rather than six -- and, failing that, a **third** -- two hundred and sixteen. Both rules still hold a table of zero entries.

| Rule | Evaluations per hop | Total hops to all 719 | Optimal | Greedy diameter |
|---|---|---|---|---|
| smallest ring gap | 6 | **4,786** | 609 | 12 |
| depth-2 lookahead | 36 | **4,786** | 609 | 12 |
| depth-3 lookahead | 216 | **4,786** | 609 | 12 |

**Thirty-six times the local computation moves nothing.** Not the total, not the count of optimal destinations, not the worst walk.

This is more than the two rules agreeing on what to do. Measured in the same instrument, the depth-2 rule picks a **different first hop on 162 of the 719 destinations** and a different hop count on **none** -- visibly different paths, every one of them exactly as long. The heuristic descends a potential -- ring distance on `Z_720` -- and the length of that descent is set by the potential rather than by how far ahead the search looks. Deepening the search changes which shortest-under-the-potential path is walked, and the potential is what is wrong.

**So the 3-hop gap between 9 and 12 is not a search failure, and it does not close for local compute.** It closes for 270 bytes, or it does not close.

That is a cleaner design statement than the one this paper set out to make. A cost that shrinks under more computation is a tuning question; a cost that holds steady under it is a structural one, and structural costs are the ones worth putting in a table.

## The reading that reverses the argument

Set the two candidate shapes side by side at their honest operating points -- the torus routed by its free exact rule, the circulant routed by the crudest rule that exists for it, holding nothing.

| | Torus 12x5x12, exact, no table | Circulant `C_720(1,8,75)`, greedy, no table |
|---|---|---|
| Worst walk | 14 | **12** |
| Mean walk | 7.2100 | **6.6565** |
| Address | 11 bits | **10 bits** |
| Table | none | none |

**The circulant wins on every row.** Routed at its worst, holding nothing, guessing locally and wrong 15 percent of the time, it still walks shorter than the torus routed perfectly -- 12 against 14 at the tail, 6.6565 against 7.2100 in the middle. Its address is also **one bit smaller**, since 720 factors as 16 x 45 rather than as powers of two, so a three-ring coordinate spends bits the rings leave empty.

Add the 270 bytes and it walks at **9 and 6.3004**.

So the case for the seated torus cannot rest on routing cost. It rests on **legibility** -- `(4, 2, 7)` is three facts a person holds where `413` is one number they look up -- and legibility is a judgment this paper leaves exactly where it found it. What has changed is the price attached: the ring reading now costs 2 hops at the tail and 0.55 in the middle against the *table-free* alternative, or 5 and 0.91 against the table-carrying one, rather than costing nothing.

**And one column above is a caution rather than a win.** The star graph's 18-bit working address packs to 10 bits, and the packing is free to store and costs an unranking to use. Every address-width comparison here is between working forms, which is the form a router actually holds.

## What is measured, what is derived, and what is neither

**Measured.** Every hop count, stretch, share, and table size, on graphs this scan builds. The 517,680-pair transitivity check, the 517,680-pair any-node routing check, and the three lookahead totals.

**Derived.** The per-node comparison figure, which is `720 x 719 x 3` bits by arithmetic rather than by allocation -- no implementation holds it, and no implementation should.

**Definitions rather than findings.** The three greedy rules. Each is the most natural table-free rule for its address space, and **a better rule for the same shape would move that shape's numbers.** This is exactly why the circulant is given three rules rather than one: the reading rests on a measured insensitivity to search depth rather than on a single heuristic's word.

**Outside all of it.** Whether legibility is worth its price; how either shape behaves when a node leaves; and what a table costs to *agree on* rather than to store, which is a consensus question and a different paper.

## The coverage gap, named rather than glossed

**The pancake graph is absent on purpose.** Its sibling measured it at diameter 7, tying the star graph. Its exact table is computable by the same walk. Its table-free rule stays open: finding a shortest prefix-reversal walk is the pancake-sorting problem, NP-hard for general inputs, so naming a greedy rule for it would be inventing a research result rather than measuring one. Including it would make one leg honest and one leg fiction.

**The insensitivity is measured on one circulant.** Depths 1, 2, and 3 agree on `C_720(1, 8, 75)`. Whether they agree on every circulant of this order is unmeasured, and the sentence above is written to that reach.

**One table serves every node** is proven end to end on the circulant, where a difference is one subtraction. On the torus and the star graph it is proven from the identity and rests on the transitivity leg for the rest -- which is checked, on the circulant, over every pair.

## The falsifier

*Horizon: this holds while the sky carries 720 points at degree 5 or 6, and while a route is a walk on an undirected graph with hop count as its cost. Assumptions: every shape is a Cayley graph under right multiplication, so a route depends on the difference; a table entry names a generator index; the three greedy rules are the natural table-free rules for their address spaces. Falsifier, in four parts, each cheap: exhibit a table-free rule for `C_720(1, 8, 75)` that routes optimally to more than 609 of 719 destinations, and "the gap does not close for local compute" is wrong as stated; exhibit a lookahead depth on the same potential whose total differs from 4,786, and the insensitivity is an artifact of three shallow depths; exhibit any node for which the identity's 270-byte table misroutes, and the shared-table claim falls whole; measure a torus destination the coordinate rule reaches in more than the breadth-first distance, and "exact and free" is wrong. Confidence: high on every measured number, each an exhaustive walk cross-checked against a second reading and bound by a witness with a ten-plant control; high on the shared-table claim, proven over all 517,680 pairs from all 720 sources; medium on the lookahead insensitivity, which is exhaustive at three depths on one circulant and unmeasured beyond; low on whether the legibility a ring buys is worth the two hops it now costs, which is a judgment and stays Keaton's.*

## Gratitude

The degree-diameter problem, Cayley graphs, and the star graph's routing algorithm come from the graph-theory and interconnect literature, studied rather than borrowed. The change-making reading of circulant routing is our own restatement of a correspondence that is old and well known. Every graph here was built and walked in this tree, and every number was measured on this bench rather than recalled from a table.
