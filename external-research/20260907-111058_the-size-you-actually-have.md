# The size you actually have

**Stamp:** `20260907.111058`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Research -- measured readings a design argument may cite; nothing here is implemented
**Room:** external-research -- the named world, read through the doorway of separation
**Witness:** [`../tools/t/topology_relaxed_witness.rish`](../tools/t/topology_relaxed_witness.rish) over [`../tools/fixtures/t/topology_relaxed_scan.sh`](../tools/fixtures/t/topology_relaxed_scan.sh) and [`../tools/fixtures/t/topology_relaxed_control.sh`](../tools/fixtures/t/topology_relaxed_control.sh)
**Elder:** [`20260906-175851_the-hop-you-can-compute.md`](20260906-175851_the-hop-you-can-compute.md) -- this paper walks the two doors that one named and left open

---

## What this measures, bounded before the numbers

Seventeen graphs, built and walked exhaustively on this pier on `20260907`: thirteen
**(n,k)-star** graphs from 120 to 6,720 vertices at degrees 5 through 11, and four **arrangement**
graphs from 120 to 1,680 vertices at degrees 9 through 16. Every diameter is a breadth-first walk
rather than a formula. Every routing claim is a rule run from **every** vertex of the graph to one
target, so *optimal* here means checked at each of the 6,719 differences rather than argued.

Every reading here stops at 6,720 vertices, and every one is a measurement rather than an
implementation: [`../comlink/topology.rye`](../comlink/topology.rye) publishes the seated
three-ring reading, and it remains the tree's one shape. These are numbers a design argument may cite
([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).

## The wall this answers

Its elder measured seven shapes on 720 and 5,040 points and found one that reaches a low diameter
**and** routes optimally from the two addresses alone: the **star graph**. At 720 points it walks 7
on degree 5, half the commutative family's own floor of 14 at that degree, and its rule finds a
shortest path for every one of the 719 differences.

That paper named the shape's limit in the same breath. **A star graph has n! vertices**, so the
family's next size after 720 is 5,040 -- while a supervision tree takes its member count from its
membership. It named two families from the literature that relax the factorial,
called measuring either one future work, and stopped. This paper walks both.

## The two families, in plain terms

Both replace *permutations of n symbols* with **arrangements**: ordered lists of k distinct symbols
drawn from n. There are `n!/(n-k)!` of those, which is a far denser grid than a factorial.

**The (n,k)-star, written S(n,k).** Two arrangements are adjacent when one is the other with
position 1 swapped against some position i, or with the symbol at position 1 replaced by one of the
n-k symbols the arrangement leaves out. Degree is n-1. At k = n-1 the family **is** the star
graph, which is why two of the thirteen readings below are the elder paper's own two numbers: they
are the anchor proving this instrument builds the graphs it says it builds.

**The arrangement graph, written A(n,k).** Same vertices, adjacent when they differ in exactly one
position. Degree is k(n-k), which buys a shorter diameter with markedly more wire.

## Reading one: the grid really is denser

Derived from the falling factorial, bounded at n = 14:

```
window between=720_and_5040 star_family_sizes=0 nkstar_sizes=8 bound_n=14
  840(S7,4/deg6) 2520(S7,5/deg6) 1680(S8,4/deg7) 3024(S9,4/deg8)
  990(S11,3/deg10) 1320(S12,3/deg11) 1716(S13,3/deg12) 2184(S14,3/deg13)
```

**Eight sizes stand where the star family offers none**, and 8 is a floor rather than a total,
since the count rises with the bound on n. Two of the eight hold degree 6 -- the degree the seated
three-ring torus already spends.

## Reading two: what those sizes walk

At **840 points**, all four rows measured or derived here:

| shape | degree | diameter | routes optimally with no table |
|---|---|---|---|
| best three-ring torus, 7x8x15 | 6 | **14** | yes, by coordinate subtraction |
| any degree-6 commutative shape | 6 | **9 or more** | -- this is the floor, not a shape |
| **S(7,4)** | 6 | **7** | **yes** |
| A(7,4) | 12 | **6** | yes |

At **5,040 points**, where the elder paper took its second reading:

| shape | degree | diameter | routes optimally with no table |
|---|---|---|---|
| best three-ring torus, 15x16x21 | 6 | **25** | yes |
| any degree-6 commutative shape | 6 | **16 or more** | -- |
| star graph = S(7,6) | 6 | **9** | yes |
| **S(10,4)** | 9 | **7** | **yes** |

So S(7,4) at 840 points walks **half** what the best torus of that size and degree walks, and it
walks **two hops under the commutative floor** for that degree -- the non-abelian payoff stated as
a number. S(10,4) reaches 7 hops on 5,040 points by spending three more edges per node than the
star graph does, which is the trade the denser grid offers rather than a free win.

## Reading three: the rule survives, and it takes a correction to get there

This is the part worth the round, and the first answer came back short.

The star's rule is one indexed read and a swap: if position 1 holds a symbol whose home is position
j, swap it there. Read literally into S(n,k), that rule is **exact at k = n-1 and short everywhere
below it**:

```
suboptimal_sizes  naive=11  door=2  chain=0  hole=0     (of thirteen sizes)
```

The naive rule gives back **two hops at S(7,4)** and **three at S(10,4)**, and routes only 396 of
S(7,4)'s 840 vertices by a shortest path. The cause is structural. When k < n-1 the arrangement carries symbols the
target leaves out, and a rule written where every symbol is wanted simply leaves those where they
sit.

**One correction recovers the diameter and most of the optimality.** Never seat the symbol that
belongs at position 1 by a replacement, and prefer to swap in a symbol whose own home currently
holds an unwanted one -- so a single move places a symbol **and** brings junk to the door. That
rule reaches the true diameter at all thirteen sizes and leaves a residue at two of them: 72 of
6,720 vertices at S(8,5), and 24 of 2,520 at S(7,5).

**The residue's root is a chain, and reading the chain closes it.** From a candidate symbol s,
follow s to the symbol currently sitting at position s, and on, for at most k steps. A chain ending
in an unwanted symbol is a **free eviction** -- the next replacement removes it. A chain ending at
symbol 1 drags the one symbol already home back to the door and wastes a move. Preferring the first
and refusing the second is the whole correction, and it routes **every vertex of every one of the
thirteen graphs by a shortest path**, 6,720 at the largest.

Worked, at S(8,5), where the one-step rule is short by one hop. From `(6,1,2,5,7)` toward
`(1,2,3,4,5)`, symbols 3 and 4 stand outside the arrangement. Symbol 3's chain runs 3 to 2 to 1 and ends at the door.
Symbol 4's runs 4 to 5 to 7, which is junk. Taking 4 costs six hops; taking 3 costs seven.

## Reading four: what the free rule costs per hop

Table-free means the next hop comes from the two addresses and the generating set, in work bounded
by the address length, out of what those two addresses already carry. That is a claim about cost, so it is
measured:

```
branch n=8 k=5  hops=38584  swap_home=0.610 door=0.064 fill=0.327  mean_candidates=0.540 max_candidates=4  bound=k=5
branch n=10 k=4 hops=26582  swap_home=0.512 door=0.033 fill=0.455  mean_candidates=0.607 max_candidates=3  bound=k=4
```

**Just over half of all hops answer from the arrangement alone** -- they are the star rule's own
single indexed read and swap. The rest scan **0.54 candidates on average** and at most **4**, always under k. For
comparison the elder paper priced the star's own scan branch at 1.703 entries mean and 4 maximum,
and a three-ring torus at three coordinate subtractions. The chain rule sits inside that same
range, so the relaxation buys its denser grid without changing what a hop costs.

## Reading five: the second door opens as written

The arrangement graph's natural rule -- fill a position whose wanted symbol stands outside,
and when every wanted symbol is present, evict one misplaced position to open a hole -- is **optimal on all four sizes at first
writing**, with a diameter one or two hops under the (n,k)-star of the same vertex count. Its bill
is wire: degree k(n-k) reaches 12 at 840 points and 16 at 1,680, against 6 and 7 for the
(n,k)-star. A design choosing between them is choosing between edges and hops with both numbers in
hand.

## What this hands BAKERY

**Buildable now, and still small.** The seated three-ring reading in `comlink/topology.rye` stays
where it stands, and this round leaves it there. What the round adds is a **priced alternative at a
size a real membership can take**: if a supervision tree wants a diameter near 7 at roughly 840
members on degree 6, S(7,4) is a shape that reaches it and routes to it with no table, and the
chain rule is short enough to write in an afternoon.

**Held back, and said plainly.** The relaxation trades one wall for another. A star graph's sizes
are `n!`; an S(n,k)'s are `n!/(n-k)!`, which is dense yet still a grid -- 840, then 990, then 1,320. **Every family here offers a grid rather than a continuum**, so a real
deployment still owes an answer to "what happens at 1,000 members", and that answer is a shape
with some vertices unoccupied or a different family altogether. Measuring how a partially-filled
S(n,k) routes is the obvious next round, and it waits for its own.

**And one thing worth refusing.** A reader who takes "optimal and table-free" from this paper and
reaches for the arrangement graph because its diameter is lowest should carry `k(n-k)` in the same
sentence. Six hops at 840 points is a real number, and it is available only to a node willing to
hold twelve neighbours.

## Coverage gaps and the falsifier

**Horizon:** thirteen (n,k)-star graphs from 120 to 6,720 vertices and four arrangement graphs from
120 to 1,680, all measured `20260907` on this pier. Every projection here stops at 6,720.

**Assumptions:** that hop count is the cost worth counting; that one walk stands for the whole
graph because both families are vertex-transitive, which the scan **checks** from five spread
sources per shape rather than assuming; and that a rule reading only the arrangement is what
routing without a map means.

**Falsifiers, in the order I would fire them:**

1. **The chain rule failing to be optimal at 40,320 points.** It is proven optimal by exhaustion at
   thirteen sizes topping out at 6,720. If it stretches at S(9,6) or S(8,7), then "optimal and
   table-free" is a property of the sizes walked rather than of the family, and every design
   sentence above narrows to those sizes. This is the cheapest one to fire: raise the size list and
   run the scan.
2. **A partially-filled S(n,k) losing the rule.** Every reading here assumes all `n!/(n-k)!`
   vertices are occupied. A supervision tree with 800 members on an 840-vertex shape has 40 holes,
   and a rule that walks into one has to do something. If the answer needs a table of live members,
   the free-routing claim does not survive contact with a real membership.
3. **Instructions rather than hops.** The branch reading is the nearest this paper comes to a
   wall-clock number and stops short of one. If a chain step costs much more than a coordinate subtraction
   in real instructions, the 14-against-7 advantage at 840 points shrinks, and the comparison would
   need re-taking in nanoseconds.

**Confidence, in plain words.** *High* that the measured numbers are what these seventeen graphs
and four rules do -- they are exhaustive walks with the rules proven to read the arrangement alone,
under 44 planted behaviors. *High* that the naive rule's failure is real, since it is measured from
both sides: exact where the family is the star graph, short at every k below. *Moderate* that the
chain rule is optimal for the **family** rather than for the thirteen sizes walked; falsifier 1 is
exactly that doubt. *Low* that any of this survives a partially-filled shape, since falsifier 2 is
unfired and is the one a real deployment meets first.

## What the instrument does that its readings cannot

The scan reads **its own source** before it prints a verdict, and refuses when any routing function
mentions the breadth-first distance array. That leg exists because it is the only fault the output
cannot show: a rule that quietly consulted the walk would print `stretch=0` and `optimal=all` and
would be exactly the table-bound case wearing the table-free answer. Every other leg reads hop
counts, and a hop count cannot say what the rule looked at.

The control plants that fault three ways -- in a body, on a declaration line, and by renaming rules
so the check passes with nothing left to read -- and lifts each plant again, since a refusal proven
only in the passing direction cannot be told from a bypass. Every plant is applied through
[`../tools/fixtures/p/plant.sh`](../tools/fixtures/p/plant.sh), which refuses by name when a plant
lands nowhere: a `sed` naming a literal line is a claim that the line is spelled that way today,
and a plant that matches nothing leaves the phase reading green for a fault it never made. That
happened here while this file was being written, when a rename plant rewrote the checker's own two
string literals.
