# The scatter that had to be shown

**Stamp:** `20260917.185601` -- **Status:** Landed -- **Room:** checkable -- every reading below is
emitted by one scan under one green witness; the limits at the close are limits rather than results.
**Language:** EN -- **Style:** Gauge, Field setting -- **Voice:** Kyri
**Grades:** row 7 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Answers:** the missing evidence named by [`20260917-163338_the-tolerance-that-was-a-ladder-rung.md`](20260917-163338_the-tolerance-that-was-a-ladder-rung.md)
**Instrument:** [`../tools/fixtures/a/aurora_file_placement_scan.sh`](../tools/fixtures/a/aurora_file_placement_scan.sh) reading 5, under [`../tools/a/aurora_file_placement_witness.rish`](../tools/a/aurora_file_placement_witness.rish)

---

## The sentence this answers

The paper that re-measured the drift tolerance on file edges closed on an inference, and named it
as one in its own words:

> **Three graphs, one ordering.** 7,549 edges read straight; 67 pairs and 32 edges do not. The
> inference is that each draw's gain is an average over the live edge set, so a graph with two
> orders of magnitude more edges has two orders of magnitude less draw-to-draw scatter, and the
> mean curve shows through. **This is an inference from three points, not a measured scaling law**
> -- the falsifier is below.

Those three graphs differ in unit, in tree and in provenance all at once, so no two of them separate
size from anything else: this tree's file edges at a departure of **0.004641**, the sibling's room
pairs at **0.1144**, the pen's at **0.0703**. The falsifier below named the missing evidence in one
line -- *a fourth graph at an intermediate size* -- and nobody had built it.

**The prediction was written into the claim before the run, so it could be wrong out loud:** the
departure would scale as one over the square root of the edge count, a 500-edge subsample reading
about **0.0180** and a 100-edge about **0.0403**, each within a factor of 2.5 of that curve; and the
0.05 straightness threshold would be crossed near **65** edges.

## The method: only the size moves

A subsample is drawn without replacement from this tree's own file edge list, and everything else is
held where reading 4 left it -- the same tree, the same 1,761 tracked Rye files, the same per-node
capacity, the same greedy placement rule, the same eight-rung drift ladder, the same keep threshold
of 0.10, the same count-matched floor costed under the same distorted edges. The layout is
**recomputed** on each subsample, because a smaller graph's layout is what a smaller graph would
actually get. Each rung below the top is three independent draws, averaged.

**The full rung is a proof rather than a data point.** At the top of the ladder the subsample is
every edge, so the placement it seats must cost exactly what reading 3 computed at this grid. It
does: `size_full_rung_cost=9072`, `size_full_rung_matches_placement=yes`. A mismatch there would
have meant the re-seated order is not the order the scan places by, and every rung below it would be
measuring a layout this scan never computed.

## Reading one: the departure rises as the graph shrinks

Read `20260917.185601` by `sh tools/fixtures/a/aurora_file_placement_scan.sh`:

| Edges | Files with an edge | Undistorted gain | Departure (mean) | Departure (min-max) | Straight |
|---|---|---|---|---|---|
| **7,549** | 1,561 | 0.366363 | **0.002836** | one draw | yes |
| 4,000 | 1,396.7 | 0.347971 | 0.005165 | 0.003925-0.006227 | yes |
| 2,000 | 1,117.0 | 0.388218 | 0.007938 | 0.005564-0.012246 | yes |
| 1,000 | 799.3 | 0.476454 | 0.009129 | 0.007542-0.011501 | yes |
| 500 | 527.7 | 0.556552 | 0.016386 | 0.007899-0.023856 | yes |
| 250 | 321.7 | 0.617019 | 0.016437 | 0.013361-0.021328 | yes |
| 100 | 156.7 | 0.725103 | 0.032551 | 0.017533-0.048294 | yes |
| **50** | 88.0 | 0.783805 | **0.052561** | 0.049212-0.058286 | **no** |

The departure rises monotonically by a factor of **18.5** as the graph falls by a factor of 151, and
the straightness verdict flips between 100 edges and 50. **A flat ladder would have refuted the
elder paper's inference outright.** This one climbs.

## Reading two: the rate is the rate an average's scatter falls

A least-squares line through the seven subsample rungs, log edge count against log departure:

```
drift_scatter_loglog_slope=-0.5070 drift_scatter_slope_rungs=7 drift_scatter_slope_near_half=yes
```

**Minus one half is what scatter in an average does.** The measured slope sits 0.007 from it across
more than two decades of graph size. That is the reading this lap was built to take, and it is the
one number here an anchor leaves alone.

## Reading three: the anchor carries the calibration, and the anchor is one draw

Every ratio against the inverse-square-root curve lands inside the claim's tolerance -- worst
**1.508**, all seven `within_tolerance=yes`. Yet **all seven sit above 1**, which under a fair coin
is one outcome in 128, so it is a signal rather than noise.

It is a signal about the **anchor**. The full rung is drawn once, because the whole graph has one
subsample; reading 4 drew the same quantity independently on the same graph and got **0.004641**
against this rung's **0.002836**. The two differ by 64 percent of the smaller, so the curve is being
quoted against a point estimate carrying that much noise. Anchored at reading 4's value instead, the
worst ratio is **1.551** and the ratios fall below 1. Both anchors are printed:

```
drift_scatter_anchor_full=0.002836 drift_scatter_anchor_reading4=0.004641
```

**The shape is robust where the calibration stays loose**, which is why the slope above is the
finding and the ratios are context.

## Reading four: the crossing, measured rather than extrapolated

```
drift_linearity_measured_crossing_edges=53.7
drift_linearity_implied_crossing_edges=24.3
```

The ladder brackets the 0.05 threshold between 100 edges and 50, and interpolating in log-log puts
the crossing at **53.7 edges**. The closed form extrapolated from the noisy anchor says **24.3** --
off by a factor of 2.2, in exactly the direction the anchor's own noise predicts.

**The claim predicted 65 before the run.** The measured reading is 53.7, within 21 percent; the
anchor-derived number sits a factor of 2.2 away. The point predictions land the same way: 500 edges was predicted
at 0.0180 and reads 0.016386, 100 edges was predicted at 0.0403 and reads 0.032551 -- within 9 and
19 percent respectively. Those predictions were anchored at reading 4's value, which reading three
above independently identifies as the better anchor. **The prediction written before the run was
closer than the instrument's own default extrapolation**, and the reason is legible rather than
lucky.

## What this ladder does not separate

**Density moves with size, and the instrument says so.** The file population is held at every rung,
so edges per file falls from 4.287 to 0.028 and the small rungs are sparser graphs as well as
smaller ones. A flat reading would therefore have refuted the averaging inference **or** found a
density effect standing in its place, and this instrument cannot tell those two apart. Holding
density fixed instead means dropping files with the edges, which moves the capacities and the
placement underneath the comparison -- a different confound rather than a clean reading.

**The undistorted gain rises as the graph shrinks**, 0.366 to 0.784, because a sparse graph is easy
to place well. So the absolute departure is measured against a growing quantity. The relative
departure -- `rel_dev`, the departure over that gain -- rises too, from 0.0077 to 0.0671, at a
shallower slope. The straightness verdict is stated on the **absolute** departure, which is what
reading 4's law uses, so absolute is the quantity the prediction was about and the quantity
reported.

**A subsample of a graph is a thinned graph rather than a small one.** These rungs are this tree's own import structure
thinned, and a genuinely small codebase's graph may be shaped differently. What this shows is that
**size alone suffices** to produce the curvature; it does not show that size is the only thing that
ever produces it.

**The top rung is one draw.** Three draws per rung below it, which is enough for a slope over seven
rungs and thin for any single rung's own value -- the min-max spreads in reading one are wide,
0.0079 to 0.0239 at 500 edges.

## What would refute this

`drift_scatter_slope_near_half=no` -- a fitted slope leaving the neighbourhood of minus one half --
refutes the averaging account directly. `drift_scatter_scales_as_inverse_sqrt=no` says the same at
the coarser resolution of the ratios. `size_full_rung_matches_placement=no` would void every rung at
once, since the graph being re-seated would not be the graph the scan placed. Each is one command
away, and the witness holds all three.

## What it costs, named

Reading 5 takes this guard from **26 seconds to 179 seconds** on this host, read `20260917`, because
it runs the drift sweep once more at the full size and three times each at seven smaller ones. That
is a free figure -- the tree grows and the ladder's top rung grows with it. The control stands at
**100 legs, zero failures**, with two new plants: a full rung silently short of one edge, and the
full edge list lost before the reading that needs it.

**And the cost opens a question this paper declines to answer.**
[`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)
is plain about what the zone rewards -- *the affordable witness is the one that keeps being run* --
and 207 seconds a lap, on eight ships, is a budget rather than a rounding. Readings 1 through 4
measure a tree that changes every lap; **reading 5 measures a scaling law, which does not.** A
cadence-tier seat for this guard, or a flag that runs the size ladder only when asked, would keep
the finding and give the hours back. That is a change to a shared roster row, and it wants its own
lap and Keaton's word rather than a quiet edit at the end of this one.

**Two earlier plants of the first one did not bite, and the reason is kept in the control.** Pen
two's four rings each sit whole on one node, so its layout costs zero and every ordering of it costs
zero alike. Disabling the placement order's sort left a regular graph's order exactly where it stood;
reversing the comparison gave a different order at the same cost. A pen whose placement is order-insensitive
cannot exercise that check at all, so **pen four** was built -- one chain, padded until capacity
spreads it -- and its cost is asserted positive before its plant is read as proof of anything.

## What BAKERY can take

**Buildable now:** the tolerance a placement map may be trusted under is a property of the graph's
size as much as of its shape, and it is computable -- `drift_scatter_loglog_slope` plus one
undistorted gain gives the departure at any size, and the 0.05 straightness crossing at **54 edges**
says where a closed-form tolerance stops describing the graph. Any Aurora placement over a graph
above roughly a hundred edges may use the closed form; below that, measure.

**Not buildable, and named as such:** none of this says a torus placement is worth building. It says
what the tolerance reading means at a given graph size. Row 7 stays a moonshot until something runs
on metal.

---

*May the next number be one somebody could have been wrong about.*
