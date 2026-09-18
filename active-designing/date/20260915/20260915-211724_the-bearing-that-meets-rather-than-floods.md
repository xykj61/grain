# The bearing that meets rather than floods

**Stamp:** `20260915.211724`
**Room:** mixed -- the three readings are checkable and bound by a green witness; the recommendation at the close is vision and waits for its own first witness.
**Status:** Landed -- the measurement stands; the disposition it proposes is a proposal.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Witness:** [`../tools/m/bearing_quorum_witness.rish`](../tools/m/bearing_quorum_witness.rish) -- scan [`../tools/fixtures/m/bearing_quorum_scan.sh`](../tools/fixtures/m/bearing_quorum_scan.sh), control [`../tools/fixtures/m/bearing_quorum_control.sh`](../tools/fixtures/m/bearing_quorum_control.sh)
**Reads:** row 8 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)

Row 8 of the bounded-torus page is the last measurable row of the twelve nobody had opened, and it
says this:

> Consensus routing travels on polar bearings. A node announces along a meridian and confirms along
> a parallel, so message count grows with the perimeter rather than the area.

**That sentence carries two claims, and they come apart.** One is about what the scheme costs, and
the other about what it delivers. The cost claim stands at every grid measured. The delivery claim
describes something the scheme never does. A sentence holding both lets the true half vouch for the
other, which is the shape [`20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)
names one room over.

---

## What was measured, and how

`tools/fixtures/m/bearing_quorum_scan.sh` builds a `g x g` torus of `N = g*g` nodes in arithmetic
and takes three readings at four grids -- `g` of 4, 8, 16 and 32. It opens no file and reads no
population, so every figure below is a fact about a topology rather than about this tree, and every
ship reads the same numbers. All three are gated for that reason.

**Reading 1 counts the cost by walking the two lines.** An announce travels the announcer's row and
a query travels the querier's column, so one operation costs `2g - 2` messages. The floor for
*dissemination* -- every node learning the value -- is `N - 1`, because every node but the source
must receive at least once, whatever the topology or the schedule.

**Reading 2 asks what an operation delivers.** Coverage after one announce is counted directly. The
intersection of an announcer's row with a querier's column is built as two cell sets and intersected
through a marker array, so the count is read rather than reasoned -- which matters, because two
perpendicular lines meeting exactly once is precisely the kind of fact a scan can assert without
ever checking it.

**Reading 3 withholds a packet**, which is row 8's own falsifier. One link on the announce line is
cut at every position in turn, and two lines of the same length `g` are compared: a **cycle**, which
is what a torus row is, and a **path**, which is what a grid row is. For each cut the reachable set
is walked from the announcer, and a **silent wrong answer** is counted for every querier whose
column meets the announce line at a cell the announce never reached. That querier finds nothing, and
has no way to tell *no value* from *the value did not arrive*.

---

## Reading 1 -- the cost half stands

Read `20260915`, and held by the closed form rather than by a fitted curve:

| `g` | nodes | bearing messages | dissemination floor | ratio |
|---|---|---|---|---|
| 4 | 16 | 6 | 15 | 0.400 |
| 8 | 64 | 14 | 63 | 0.222 |
| 16 | 256 | 30 | 255 | 0.118 |
| 32 | 1024 | 62 | 1023 | 0.061 |

The counted cost equals `2g - 2` at every grid, and the ratio falls at every step. The exponent of
cost against node count reads **0.5237** over the two largest grids and **0.5604** over all four.

**The gap between those two numbers is arithmetic rather than noise, and it is worth saying out
loud.** The closed form is `2g - 2` against `g*g`, so the exponent approaches 0.5 **from above** --
the `-2` is a larger share of the cost at a small grid. The tail fit is what the gate reads, and
both are printed so a reader sees the finite-size bias instead of one tuned number.

So row 8's cost clause is right. Perimeter against area is exactly what this is.

---

## Reading 2 -- the delivery half is a different property

After one announce, the nodes holding the value number `g` of `N`:

| `g` | covered | share |
|---|---|---|
| 4 | 4 | 0.250 |
| 8 | 8 | 0.125 |
| 16 | 16 | 0.0625 |
| 32 | 32 | 0.03125 |

The share falls as `1/g`. Row 8's own word is **consensus routing**, which a reader takes as
everyone learning the value; at `g = 32` a thirty-second of the network does.

**What the scheme guarantees instead reads clean.** The intersection of an announcer's row with a
querier's column is **exactly one cell** for all **1,360** distinct cases across the four grids --
minimum one, maximum one. Two operations are guaranteed to *meet*.

**That is a quorum system, and the cost follows from the guarantee.** A scheme costs the square root
of `N` precisely because it promises intersection rather than coverage: a row and a column are each
`sqrt(N)` long, and any row crosses any column. Row 8 priced a rendezvous and described a broadcast,
and the price it quoted was the right price for the thing it did not describe.

**The correction is one word.** A bearing scheme is how a node *finds* a value another node holds,
rather than how a value *reaches* every node. Both jobs are real; a system needs each. Naming them
apart is what lets a reader see that the cheap one was already cheap for a reason.

---

## Reading 3 -- the wrap is worth exactly one cut

This is the finding that belongs to the torus rather than to the grid beside it, and it is the one
positive result in a lane whose last four readings published refusals.

| line | cut positions losing coverage | queriers answered silently |
|---|---|---|
| cycle -- a torus row | **0** | **0** |
| path -- a grid row | 1,300 | 372,368 |

A cycle walked in both directions from the announcer reaches every cell under **any** single cut,
because the far direction carries what the near one dropped. A path cannot, and the queriers whose
columns land past the break receive silence that reads exactly like an absent value. **Row 8's own
falsifier fires on the path and is extinguished by the wrap.**

**And the bound is exactly one, counted rather than assumed.** Two distinct cuts split the cycle in
all **650** cases walked. A wrap buys one link of tolerance and no more, which is a smaller promise
than *a torus is resilient* and a far more useful one, since a reader can hold it.

---

## What this is worth to Comlink and Mycelium

**One design sentence follows from the three readings**, and it is a proposal rather than a result.
A routing layer that wants both jobs wants them named apart: a **rendezvous** plane, priced at
`2 sqrt(N)` per operation with an intersection guarantee, and a **dissemination** plane, priced at
`N - 1` at best and reached for only when every node genuinely must learn. Most of what a supervision
tree calls consensus is the first, and paying area prices for perimeter work is the ordinary way that
mistake is made.

**Two conditions this cannot tell you, stated plainly.** Whether a real link's queue makes a hop
count a poor proxy for latency -- it does, and by how much is a different reading. And whether a
querier can be made to **detect** the gap on a path rather than merely suffer it. A sequence number
at the intersection cell, or a second quorum crossing the first, would each turn silence into a
refusal. Neither is measured here, and neither is hard; they are the obvious next witness.

---

## Falsifiers, and what would move this

**The cost half falls** if the closed form `2g - 2` misses at any grid, or if the cost share of the
dissemination floor stops falling as `g` grows. Both are gated at zero.

**The meet guarantee falls** if any intersection reads other than one. The control fires exactly
this by making the querier read its own row instead of its column: two lines of the same orientation
meet in `g` cells or in none, never in one, and the scan says `meet_fails`.

**The wrap finding falls** two ways, and both are planted. A cycle losing coverage under a single cut
would mean the wrap buys nothing -- proven by walking the cycle one way only, which loses coverage
immediately. A path holding coverage under every cut would mean the wrap was never the cause --
proven by a mutation that makes the path lossless, which refuses beside it.

**Confidence.** High for all three, and the reason is the subject rather than the care taken: these
are facts about a graph, reproduced by arithmetic on any machine. The low-confidence half of this
page is the design sentence above, which rests on a judgment about what routing layers actually spend
their messages on, and that judgment wants a real workload rather than a proof.

---

## Disposition proposed for row 8

**Re-aim rather than re-rank, and keep the row.** Row 8's first witness as written is a three-node
fixture proving the protocol reports a gap; that witness is still worth building, and the reading
above tells it what to look for. What the row's own text should lose is the word *consensus* and the
implication of coverage. What it gains is a guarantee it can state exactly -- every announce meets
every query in one cell -- and a tolerance bound it can name to the link.

**Recommended rank: fourth**, up from ninth. The two readings ahead of it published refusals and the
rows behind it wait on hardware; this one carries a positive finding and an obvious next witness.

*Every figure on this page is HELD -- `tools/m/bearing_quorum_witness.rish` reds on the lap any of
them moves, and the scan opens no file, so none of them can move under this tree. Run
`sh tools/fixtures/m/bearing_quorum_scan.sh` to read them yourself.*

May the announce find its query, and may the wrap be worth its one cut.
