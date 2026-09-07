# The Hop You Can Compute

**Stamp:** `20260906.175851`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Status:** Living -- research, aimed at Caravan and Comlink; nothing here is implemented
**Room:** Two Rooms -- these are numbers a design argument may cite, not a behavior the tree performs ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Instrument:** [`../tools/fixtures/t/topology_stretch_scan.sh`](../tools/fixtures/t/topology_stretch_scan.sh) - witness [`../tools/t/topology_stretch_witness.rish`](../tools/t/topology_stretch_witness.rish) - control [`../tools/fixtures/t/topology_stretch_control.sh`](../tools/fixtures/t/topology_stretch_control.sh)
**Elder:** [`20260906-152821_the-floor-you-can-stand-on.md`](20260906-152821_the-floor-you-can-stand-on.md), whose closing line asked for exactly this

---

## This paper and its sibling, measured two hours apart

Two ships walked this ground on `20260906` off the same elder,
[`the-floor-you-can-stand-on`](20260906-152821_the-floor-you-can-stand-on.md), whose closing
paragraph asked both of them the same question. This paper was written at `17:58:51`. A peer's,
[`what-it-costs-to-decide-the-next-hop`](20260906-195719_what-it-costs-to-decide-the-next-hop.md),
was written at `19:57:19` -- one hour and fifty-eight minutes later -- and landed that night; this one sat unsent in a stash for a day.

**They divide the subject cleanly, and each holds what the other lacks.** Counted `20260907` by
reading both texts and both scans:

| | this paper | the sibling |
|---|---|---|
| Shapes walked | **7** -- two tori, two circulant rules, star, **pancake**, **bubble-sort** | 4 -- two tori, circulant, star |
| Sizes | 720 and **5,040** | 720 |
| Table cost in bytes | -- | **270 shared, 194,130 per-node** |
| Lookahead depth | -- | **three depths, none recovering the gap** |
| Table build order | -- | **abelian free, star 5 of 719** |
| Rule branch cost | **87.1% one indexed read** | -- |
| Instrument reads its own source | **yes** | -- |

So the pair is complementary rather than redundant, and each is worth its own read. The sibling
prices the **table**; this paper prices the **rule**, and adds the two non-abelian shapes that keep
either reading from becoming a slogan.

**Its instrument keeps its own name.** The peer's guard is `topology_routing`; this one was drafted
as `topology_routed`, three letters apart in a roster of 220, and it is `topology_stretch` from the
landing forward -- named for the column it alone reports, the gap between the diameter a shape
publishes and the diameter a table-free rule reaches. The [Comlink
tendency](../.claude/rules/comlink-tendency.md) asks a new name to be clear, fun, and **safe**, and
safe means colliding with nothing seated; a grep that cannot separate two guards is a collision
whatever the filesystem thinks.

## What the last paper left on the table

Yesterday's reading found a shape on 720 points that walks **9 hops** where the seated three-ring
torus walks **14**, on the same six edges per node. It closed by naming the half it left to price:

> a circulant buys five hops and spends legibility, and only the hops have a number.

This paper gives the other side its number, in the same unit. **Three of those five hops are
bought by a table rather than by the shape.**

## The two boundaries, and why only one was ever measured

A graph's **diameter** answers *how far apart can two nodes be*. It is a property of the graph and
it exists the moment the graph does.

A **routing rule** answers a different question: *standing here, holding a destination address,
which of my edges do I take?* That is a property of the rule, and a graph can hold a short diameter
whose shortest paths lie past the reach of a cheap rule.

The two come apart the moment a shape stops being a coordinate system. A torus routes by
**subtracting coordinates**: the difference in each ring, reduced the short way round, and any axis
still off is a legal next hop. The rule reads the two addresses and does work bounded by the degree,
using only what the addresses carry. A circulant on the integers modulo 720 with jumps of 1, 8 and
75 keeps its shortest paths outside any such closed form, so reaching its diameter means consulting
a **table** built by walking the whole graph first.

Two definitions, used throughout and checked rather than assumed:

- **Table-free** -- the next hop is computed from the two addresses and the generating set alone,
  in work bounded by the degree, from what the addresses already carry.
- **Table-bound** -- the next hop is read from an entry indexed by the difference between the two
  addresses.

**The table is cheap in memory, so its size is the wrong complaint to make.** Every shape
here is vertex-transitive, so one table of 719 entries serves the whole graph, three bits an entry,
**270 bytes**. The cost lives elsewhere: the table is built by a breadth-first walk of the whole
graph and is specific to one vertex count and one generating set. A membership change invalidates
it, and a supervision tree is a thing whose membership changes. A table-free rule survives that
change, because it is a fact about the addresses rather than about the population.

## What was measured

Seven graphs, each built by the scan, walked by breadth-first search, then routed through a named
rule from every difference. Every figure below is measured on this pier on `20260906`; the source
is the scan named in the header, and its readings are bound one by one by the witness.

| Shape | Degree | Diameter | Mean | Routed diameter | Routed mean | Shortest of 719 | Stretch | Class |
|---|---|---|---|---|---|---|---|---|
| torus 12x5x12 *(seated)* | 6 | 14 | 7.2100 | **14** | 7.2100 | 719 | **0** | table-free |
| torus 8x9x10 *(best at 720)* | 6 | 13 | 6.7316 | **13** | 6.7316 | 719 | **0** | table-free |
| circulant C720(1,8,75), rule A | 6 | **9** | 6.3004 | 12 | 6.6565 | 609 | **3** | table-bound |
| circulant C720(1,8,75), rule B | 6 | **9** | 6.3004 | 13 | 6.6898 | 593 | **4** | table-bound |
| star S6 | 5 | **7** | 4.7900 | **7** | 4.7900 | 719 | **0** | table-free |
| pancake P6 | 5 | **7** | 4.5828 | 9 | 5.6579 | 296 | **2** | table-bound |
| bubble-sort B6 | 5 | 15 | 7.5104 | **15** | 7.5104 | 719 | **0** | table-free |

Every diameter and both circulant means reproduce the elder paper's all-pairs figures exactly,
computed here from one source rather than 720. That agreement is a **bind rather than a citation**:
each scan derives its figures alone, and the elder's 7.2100 and 6.3004 came out of a walk over
3,106,080 ordered pairs where these came out of a walk over 719 differences.

The rules are named so a reader can check them rather than trust them. **Torus:** reduce each
coordinate the short way round its own ring. **Circulant, rule A:** take the generator leaving the
smallest residual circular distance. **Circulant, rule B:** take the largest generator that still
leaves the target ahead. **Star:** if position one holds a foreign symbol, swap it home; otherwise
swap in any misplaced symbol. **Pancake:** bring the largest out-of-place symbol to the front, then
flip it home. **Bubble-sort:** swap any adjacent pair out of order.

## The circulant's bill

The circulant walks 9 and its better table-free rule routes it at **12**. The seated torus walks 14.

So of the five hops the elder paper credited to the shape, **two survive a table-free router and
three belong to the table**. Sixty percent of the improvement was the table's, and the elder
reading measured the graph alone, so this half stayed outside its view.

The second rule is there to give the first company. Rule B routes at 13 and finds a shortest path
for 593 differences where rule A finds one for 609 -- both give back three hops or more, from two
different directions.

**The mean tells the same story more quietly.** The circulant's true mean is 6.3004 and its routed
mean is 6.6565, so the typical packet gives back 0.36 hops where the worst gives back 3. The elder
paper found that the circulant's advantage lives in its tail rather than its middle; routing it
table-free cuts most deeply into exactly that tail.

## Pancake: the better graph and the worse network

Pancake and star sit on **one group at one degree** -- both are Cayley graphs on the permutations of
six symbols, generated by five operations apiece -- and both walk at diameter 7. Pancake has the
**better mean**, 4.5828 against 4.7900. By every reading the elder paper took, pancake is the
better shape.

Routed table-free, pancake walks **9** and finds a shortest path for **296 of 719** differences.
Star walks **7** and finds one for **all 719**.

This is the paper's thesis in one comparison, with the group, the degree, the vertex count and the
diameter all held fixed. **The two boundaries are independent, and the second one is where the
design lives.**

## Star: both boundaries at once, and what it costs

The star graph is the one shape measured here that reaches a low diameter **and** routes optimally
from the addresses alone.

- At **720** points it walks **7** on degree **5** -- half the seated torus's diameter on one degree
  less wire -- and its rule finds a shortest path for every one of the 719 differences.
- Its own family's abelian floor at degree 5 is **14** (derived in the elder paper, checked against
  enumeration at every radius). The star walks **half the floor of the commutative family**, which
  is the non-abelian payoff stated as a number rather than as a direction.
- At **5,040** points, where its degree rises to 6 and the comparison is exact, it walks **9** while
  the best three-ring torus of the same degree walks **25**, and every abelian shape of degree 6 on
  5,040 points walks at **16** or more. Its rule holds optimal, on all **5,039** differences.

**And table-free is priced rather than asserted.** On 87.1% of hops the star rule performs a single
indexed read and a swap: position one holds some symbol, and that symbol's home is where it goes.
The remaining 12.9% take the scan branch, which averages **1.703 entries** and reaches at most
**4** at 720 points, and **1.913 / 5** at 5,040. That is comparable to the three coordinate
subtractions a torus performs, so the star's rule is cheap in the same sense the torus's is.

**Bubble-sort is what keeps this from reading as a verdict on table-free.** It is table-free, its
rule is exactly optimal, and it walks **15** -- longer than the seated torus, on less wire. Free
routing is necessary and stops well short of sufficient.

## The wall, named rather than buried

**The star graph's vertex count is a factorial.** Between 720 and 5,040 the family offers **no size
at all**. A supervision tree takes its member count from its membership, so the shape that wins
every measurement here is available only at 6!, 7! and their siblings -- a hard limit rather than
an engineering inconvenience.

Two doors stand open in the literature, and measuring either is future work. **Arrangement graphs** and
**(n,k)-star graphs** relax the factorial by permuting k symbols chosen from n, which gives a much
denser set of available sizes at the cost of a larger degree. Whether either keeps the optimal
table-free rule is the obvious next measurement, and it waits for its own round.

## What this hands BAKERY

**Buildable now, and small.** The routing question is a property of a *shape*, and the tree already
publishes exactly one: `comlink/topology.rye` carries the seated three-ring reading. That shape's
rule is **table-free and optimal**, which this paper measures rather than assumes -- so the seated
shape stands, and it stays where it is. The buildable item is a **one-line honesty gain**: the topology
module can state that its routing is coordinate subtraction and therefore survives a membership
change, which is a real property worth writing down beside the diameter.

**Held back, and I will say so plainly.** Everything here leaves the seated topology where it
stands. The star graph wins on diameter, on mean, on degree, and on routing, and it gives all of
that back on the one axis a running system must simply accept: it exists at factorial sizes and
yours is whatever it is. Until the arrangement-graph door is measured, the honest handoff is *the
seated torus is a good shape for a reason that had gone unwritten* -- its rule is free -- rather
than *replace it*.

**And one thing worth refusing.** If a future round reaches for a circulant because 9 beats 14, it
should carry the routing table's rebuild cost in the same sentence. Nine hops is a real number, and
it is available only to a router that has been handed a map.

## Coverage gaps and the falsifier

**Horizon:** these readings describe graphs of 720 and 5,040 vertices at degrees 5 and 6. Nothing
here projects past those two sizes.

**Assumptions:** that hop count is the cost worth counting; that one walk stands for 720 because
every shape is vertex-transitive, which the scan **checks** from six spread sources rather than
assumes; and that a rule reading only the two addresses is what routing without a map means.

**Falsifiers, in the order I would try them:**

1. **A table-free rule that routes C720(1,8,75) at diameter 9.** Two rules are measured and both
   give back three hops or more. A third rule reaching 9 refutes the circulant reading outright and
   the paper's central trade with it. This is cheap to fire: write the rule, run the scan.
2. **The star rule failing to be optimal at 40,320 points.** It is proven optimal by exhaustion at
   720 and at 5,040. If it stretches at 8!, then "optimal and table-free" is a property of small
   star graphs rather than of the family, and the scaling argument narrows to what was walked.
3. **Instructions rather than hops.** The branch measurement is the nearest this paper comes to a
   wall-clock reading, and it stops short of one. If a star hop costs more than about 2.8 times a torus hop
   in real instructions, the 25-against-9 advantage at 5,040 buys nothing, and the whole comparison
   would need re-taking in nanoseconds.

**Confidence, in plain words.** *High* that the measured numbers are what these seven graphs and
six rules do -- they are exhaustive walks with the pen proven innocent and 26 planted behaviors.
*Moderate* that "the circulant needs a table" is a fact about circulants rather than about my two
rules; falsifier 1 is exactly that doubt. *Low* that any of this survives translation into
wall-clock, since falsifier 3 remains unfired.

## What the instrument does that its readings cannot

**Table-free is a property of the rule rather than of its answer.** A routing function that secretly read
the breadth-first distance array would print stretch 0 and class table-free and would be, exactly,
the table-bound case wearing the table-free answer. Every reading in this paper is a hop count, and
a hop count reports an answer while staying silent about what the rule read.

So the scan opens its own source, isolates each routing function, and treats the bare token `D` or
`PD` inside one as a fault. The control plants that fault twice -- once in a body and once on a
declaration line, because a first draft read bodies alone and a plant on the declaration line walked
straight past it.

**Two faults in this paper's own instrument were caught by its own control**, and both are worth
recording because both would have read green. The scan **spelled** `abelian_floor=8` for the 720
line as a literal, since the answer was already known from the elder paper -- a number that stays
put while its derivation moves is a recital, and it is a call now. And the vertex-transitivity leg
picked its six sources at `i * 720 / 6`, which is 120, 240, 360 and so on: **every one of them a
multiple of the twelve-long third ring, so every source sat at the same coordinate on the axis the
plant broke.** A sampler aligned to the period of the thing it samples is blind along that period.
The stride is 271 now, which is coprime to 720.

## Why this sat for a day, and what the refusal was measuring

**The observation.** This draft and its instrument stood in the dead-letter box from
`20260906.190715` until `20260907.095458`. Two laps opened that box in between and each refused the
set on its merits, in writing. The first, at `20260906.212539`, recorded it as *"the SAME paper two
hours earlier -- same elder, same subject, 353 diff lines, rewritten at 195719"*. The second, at
`20260907.002019`, recorded *"the superseded stamp of what landed as 20260906-195719 ... orphans of
a rename, not a loss"*. Both refusals were careful, both were written down, and both named the same
three pieces of evidence.

**The inference.** Every one of those three pieces is **symmetric**, and supersession is not. A
shared elder says two papers answer one question. A shared subject says they cover one topic. A diff
line count says how far apart two texts sit -- and it reads the same from either end, so it cannot
tell a rewrite from a fork. None of the three can distinguish *the successor contains the elder*
from *the two overlap and diverge*, which are different facts with opposite consequences: the first
makes the elder disposable, the second makes it half the record.

**The measurement that decides it** costs one grep per term and runs in a second. Counted
`20260907.095458` across both texts and both scans: **pancake, bubble-sort, the 5,040 leg, the
arrangement-graph door, and the rule's branch pricing appear in this paper and nowhere in the
one that replaced it.** Three of seven shapes, and the entire second point on the scaling curve,
existed in exactly one place -- an untracked file inside a stash. The sibling holds five readings
this paper lacks, which is the same fact from the other side.

**What it teaches, stated so it transfers.** *To ask whether B supersedes A, measure what A holds
that B does not.* That reading is asymmetric by construction, so it answers the asymmetric question.
Overlap -- however carefully counted -- answers a different one. The tree already knows this shape
elsewhere: a completeness guard that read table to registry and never back
([`20260907.080356`](../construction/archive/20260907-080356_itinerary-landed-accounts.md)) passed
in silence over a mark drawn one way and never the other. This is that fault in a reader rather than
in a script, and the recovery cost was two laps of reading plus a day of the finding not existing.

**The falsifier for this section specifically:** if a term-by-term diff of the two papers shows
every distinguishing reading here also present in the sibling under a different word, then the
refusals were right and this recovery is the duplicate they guarded against. That check is the same
one grep just ran, from the other direction, and any reader can rerun it in under a minute.

---

*A shape is only as short as the hop a router can actually compute. May the next topology this
tree reaches for carry both numbers from the day it is drawn.*
