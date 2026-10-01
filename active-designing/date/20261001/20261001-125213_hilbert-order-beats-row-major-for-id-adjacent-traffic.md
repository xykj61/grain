# Hilbert order beats row-major for ID-adjacent traffic, on both mesh and torus

**Status:** Vision -- a combinatorial finding, not yet witnessed on metal ([`../../../context/TWO_ROOMS.md`](../../../context/TWO_ROOMS.md))
**Setting:** Gauge Field - **Voice:** Kyri
**Stamp:** `20261001.125213`
**Kin:** [`../20260910/20260910-060204_the-bounded-torus-moonshots.md`](../20260910/20260910-060204_the-bounded-torus-moonshots.md)
(row 7, the mesh-vs-torus topology question) -
[`../../../tools/fixtures/a/aurora_placement_scan.sh`](../../../tools/fixtures/a/aurora_placement_scan.sh)
(the grid and hop-distance machinery this essay reuses) -
[`20261001-120623_aurora-energy-crossover-calculator-lands.md`](20261001-120623_aurora-energy-crossover-calculator-lands.md)
(the sibling study that priced torus-vs-mesh hop savings in joules)

## What this essay answers, and what it stands beside

[Row 7's own study](../20260910/20260910-060204_the-bounded-torus-moonshots.md) asks **which
topology** a k x k grid should wear, mesh or torus, and measures the hop-distance gap between
them. This essay keeps that topology fixed and asks a second, narrower question: **in what order
should module IDs land on grid nodes**, so a module numbered `i` sits near the module numbered
`i+1`? Row-major (cartesian) order -- `node(i) = (i mod k, i div k)` -- is the default
[`aurora_placement_scan.sh`](../../../tools/fixtures/a/aurora_placement_scan.sh) already builds. A
**Hilbert curve** order is the classical alternative, priced here in the same hop-distance unit row
7 already uses.

Topology and assignment order are two separate dials. A tree can turn both at once: keep row 7's
torus finding, and also reorder which module sits at which address.

## Observation -- the arithmetic, checked by direct computation

A Hilbert curve of order `k` (`k` a power of two) visits every cell of a `k x k` grid exactly once.
Each step in its sequence moves to a grid-adjacent cell, by construction rather than by
measurement. That single property sets the mean hop distance between **consecutive integers** in
Hilbert order to exactly **1.0**, at every grid size the construction admits.

Row-major order carries a weaker property. `i` and `i+1` sit side by side in the same row for most
pairs, yet every `k`-th pair crosses from the end of one row to the start of the next. That
crossing's cost depends on the topology:

| `k` | row-major, torus hops (mean) | row-major, mesh hops (mean) | Hilbert hops (mean, either topology) |
|---|---|---|---|
| 2 | 1.333 | 1.333 | 1.000 |
| 4 | 1.200 | 1.600 | 1.000 |
| 8 | 1.111 | 1.778 | 1.000 |

Computed `20261001` by direct simulation: a `d2xy` Hilbert mapping, every `k^2 - 1` consecutive
pair, torus hop = `min(|dx|, k-|dx|) + min(|dy|, k-|dy|)`, mesh hop = `|dx| + |dy|`. This reading is
**held**, in [Gauge Style's](../../../context/GAUGE_STYLE.md) own sense: the two orderings and the
metric fix every cell, and a reader re-derives the whole table from the mapping named above, with
no dependence on tree state that could drift.

Two findings sit in the table already, each visible in the numbers rather than argued toward:

- **Hilbert order wins at every grid size checked, and wins more on mesh than on torus** -- 37.5%
  at `k=4` (1.6 -> 1.0) against 16.7% (1.2 -> 1.0). A torus's own wraparound link already
  absorbs part of row-major's row-boundary cost, so a better ordering has less left to recover.
- **Row-major's mesh cost climbs with grid size; Hilbert's cost holds flat.** At `k=8` the mesh
  row-major mean reaches 1.778 while Hilbert stays at 1.000. The gap widens because Hilbert's
  guarantee holds at every scale, while row-major's row-boundary crossing keeps its full weight
  as the grid grows.

## Inference -- what the arithmetic settles, and what still waits on this tree

The arithmetic settles a fact about two orderings and one metric. It says nothing yet about
Aurora, Caravan, or any module this tree runs. [Row 7's own
study](../20260910/20260910-060204_the-bounded-torus-moonshots.md) already named the open problem
this essay inherits: a placement map wants a module-to-module **traffic weight**, and
[`aurora_placement_scan.sh`](../../../tools/fixtures/a/aurora_placement_scan.sh)'s own Reading 2
records that this tree holds two proxies for it today -- an import-graph edge count (structural)
and a `loom`-key co-occurrence count (free, growing) -- and neither one is a traffic weight in the
sense a placement map needs.

This essay's own working assumption narrows that open question to something checkable: **modules
created near each other in time, numbered consecutively by whatever process assigns an ID,
communicate more with each other than modules numbered far apart.** The assumption holds plausibly
for a system that hands out IDs in creation order, where related work arrives in bursts -- a lap's
own commits already cluster by module, visible in this tree's own `git log`. A Hilbert-order
placement pays off exactly when this assumption is true.

## Projection

**Horizon:** this finding changes no module's behavior today. It names a placement choice
available the day any module -- Aurora's own, or a future one -- assigns a grid position to a
sequentially-numbered set of things.

**Assumptions, named in full:**
1. Module or node IDs are assigned in an order correlated with communication frequency, as stated
   above and left unverified here.
2. The grid size is a power of two, since the classical Hilbert construction used here requires
   it. `k=3`, one of the four sizes
   [`aurora_placement_scan.sh`](../../../tools/fixtures/a/aurora_placement_scan.sh) already
   grades, needs a generalized curve or a different space-filling order, left outside this
   essay's scope.
3. Hop count stands in as an honest proxy for energy or latency cost -- the same open,
   unweighted question [the energy crossover
   calculator](20261001-120623_aurora-energy-crossover-calculator-lands.md) already names rather
   than settles.

**Falsifier:** a real traffic measurement on this tree's own modules could show `loom`-key
co-occurrence pairs spread evenly across ID-distance, rather than concentrated near ID-adjacent
pairs. That outcome would mean ID-adjacency fails to approximate real traffic, and the Hilbert-order
advantage computed here would answer a question this tree never actually asks.

**Confidence:** high in the arithmetic, since it is checked rather than estimated. Low in the
traffic assumption, since this essay measures the grid alone and leaves the real pattern for a
future reading to take.

## What Bakery could build, named plainly

A `hilbert_order_scan.sh` sibling to
[`aurora_placement_scan.sh`](../../../tools/fixtures/a/aurora_placement_scan.sh) is buildable now,
with no hardware dependency. It would take the same `GRIDS` list, restricted to powers of two,
compute both orderings' mean consecutive-pair hop distance under both topologies, and assert the
table above on metal rather than in a scratch file outside the tree. That step closes this essay's
arithmetic half into the checkable room. The traffic-assumption half stays open, waiting on the same
measurement [row 7's own study](../20260910/20260910-060204_the-bounded-torus-moonshots.md) already
asked for.

## Related

[`20261001-120623_aurora-energy-crossover-calculator-lands.md`](20261001-120623_aurora-energy-crossover-calculator-lands.md)
prices the topology question this essay keeps fixed. This essay touches no production code; its
own working computation ran in a scratch file outside the tree and is reproduced here as a table.
