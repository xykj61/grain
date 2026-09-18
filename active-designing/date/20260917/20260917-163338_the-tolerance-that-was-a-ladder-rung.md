# The tolerance that was a ladder rung

**Stamp:** `20260917.163338` -- **Status:** Landed -- **Room:** checkable -- every reading below is
emitted by one scan under one green witness; the recommendation at the close is a recommendation and
waits for Keaton's word.
**Language:** EN -- **Style:** Gauge, Field setting -- **Voice:** Kyri
**Grades:** row 7 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Answers:** the weakest joint named by [`20260917-142006_the-unit-the-capacity-forced.md`](20260917-142006_the-unit-the-capacity-forced.md)
**Instrument:** [`../tools/fixtures/a/aurora_file_placement_scan.sh`](../tools/fixtures/a/aurora_file_placement_scan.sh) reading 4, under [`../tools/a/aurora_file_placement_witness.rish`](../tools/a/aurora_file_placement_witness.rish)

---

## The sentence this answers

The paper that placed files rather than modules closed by naming its own weakest joint, in its own
words:

> The import graph is structure read as a lower bound on coupling, and its sibling measured the
> tolerance: roughly two thirds of the edges may wander before a computed layout falls behind
> chance. That tolerance is **borrowed here rather than re-measured**, and it is the weakest joint
> in the argument.

A tolerance is a property of a graph rather than of an idea. The sibling measured it over **67 room
pairs**; the file reading rests on **7,549 edges over 1,561 files**, and keeps only **0.2184** of
them on one node against the room layout's **0.8463**. Less locality kept is less margin to spend,
so the borrowed number had a plain reason to fail at the finer unit.

**The prediction was written into the claim before the run, so it could be wrong out loud:** the
file tolerance would read **below** 60 percent. It reads **71.90**, and the story of why is worth
more than the number.

## The method, which is the sibling's unchanged

Changing the method and the unit at once measures nothing, so only the unit moved. With probability
**p** a real import edge carries no run-time traffic at all -- a file read once at startup -- and the
**same count** of file pairs carrying no import edge carry traffic the static graph cannot see. The
computed layout is held **fixed** and costed under those distorted edges, against a count-matched
floor costed under the same distorted edges. The keep threshold is the sibling's **0.10**, the
distorted grid is the sibling's **16 nodes**, and the sibling's five ladder rungs are kept exactly.

**Two rungs were added, at 70 and 90.** That is the one departure, and section three is why.

## Reading one: the borrowing was sound

Read `20260917.163338` by `sh tools/fixtures/a/aurora_file_placement_scan.sh`:

| Edges silenced | File-graph gain share | Still earns its keep |
|---|---|---|
| 0% | 0.366240 | yes |
| 20% | 0.293084 | yes |
| 40% | 0.219935 | yes |
| 60% | 0.141855 | yes |
| **70%** | **0.106710** | **yes** |
| 80% | 0.071481 | no |
| 90% | 0.039914 | no |
| 100% | -0.001378 | no |

`file_proxy_survives_structure_drift_upto_pct=70`, `file_drift_crossing_pct=71.90`.

**The instrument proves itself from the far side.** At 100 percent the layout is costed against a
graph sharing nothing with the one it was built from, and it finishes at **-0.001378** -- chance,
to three decimal places. A sweep that stayed positive there would be measuring occupancy.

**And the undistorted rung reproduces the placement already computed.** `drift pct=0` reads
**0.366240** against the scan's own `sixteen_matched_gain_share=0.365091` -- a difference of
**0.0011**, which says the sweep is costing the layout under test rather than some other one.

So the file graph tolerates **0.719** of its edges wandering, against the **roughly two thirds** the
paper cited. The borrowing stands, and the weakest joint closes in the paper's favor.

## Reading two: the number it agreed with was a ladder rung

**On the sibling's own five rungs, both graphs answer 60.** That agreement is an artifact of the
readout rather than a fact about the graphs.

A survival point **is** a rung: it names the highest ladder position still earning its keep, so two
graphs whose crossings differ by less than one rung report the same tolerance. The sibling's ladder
steps 20 points at a time, and interpolating each graph's own live ladder between the rungs that
bracket the threshold gives:

| Graph | Edges | Survival rung, 20-pt ladder | Interpolated crossing |
|---|---|---|---|
| Room pairs (sibling) | 67 | 60 | **77.37** |
| File edges (here) | 7,549 | 60 | **71.90** |

Room figures computed from that scan's live ladder this stamp -- `0.382684` at 60 percent and
`0.057109` at 80 -- by the same linear interpolation the file scan now emits for itself.

**So the file unit's tolerance is genuinely lower, by 5.47 points, and the coarse ladder hid it.**
The prediction's direction was right and its magnitude was badly wrong: a layout keeping a fifth of
its edges on-node rather than four fifths loses about five points of tolerance rather than the
collapse the locality gap suggests.

**Why the locality gap does not carry through.** Tolerance is measured against a **count-matched**
floor, which is dealt into the layout's own per-node occupancy. Whatever a layout gains from piling
files onto a node, the floor gains too, so the occupancy difference cancels and only the graph's
own contribution is left. That is the same reasoning the file paper gave for choosing that floor,
arriving one reading later in a place nobody had pointed it.

## Reading three: the decay is straight, so the tolerance has a closed form

The file ladder falls in a near-perfect line. Successive drops read -0.0732, -0.0731, -0.0781,
-0.0351, -0.0352, -0.0316, -0.0413 across rungs whose spacing is 20, 20, 20, 10, 10, 10, 10 --
**a constant slope per point of drift**. Against the straight line `g0 (1 - p)` the largest
departure over all eight rungs is **0.004641**, and the scan emits `drift_decay_linear=yes`.

If gain falls as `g0 (1 - p)`, it reaches the keep threshold at

```
p* = 1 - keep / g0
```

which is **`1 - 0.10 / 0.366240 = 0.7270`**. Measured crossing **71.90**, closed form **72.70**,
gap **0.79 points**. Both are emitted, so they can disagree out loud on a later tree.

**The law says the tolerance is not about granularity at all.** It is set by the layout's own
undistorted gain and the keep threshold, and the unit enters only through `g0`. A layout that gains
less tolerates proportionally less drift, whatever it is placing.

**And the law fails where the samples are few.** Running the same arithmetic on the room graph's
live numbers gives `1 - 0.10/0.857398 = 88.34` against an interpolated **77.37** -- a gap of
**10.97 points**, and a maximum departure from the straight line of **0.1144**, which the file
scan's own threshold would call `no`. The pen agrees from a third direction: on **32** edges the
same key reads `drift_decay_linear=no` with a departure of **0.0703**.

**Three graphs, one ordering.** 7,549 edges read straight; 67 pairs and 32 edges do not. The
inference is that each draw's gain is an average over the live edge set, so a graph with two orders
of magnitude more edges has two orders of magnitude less draw-to-draw scatter, and the mean curve
shows through. **This is an inference from three points, not a measured scaling law** -- the
falsifier is below.

## What the guard holds, and what it only reports

| Reading | Held at | This stamp |
|---|---|---|
| `reading4=read` | walled | read |
| `file_structure_drift_bites=yes` | walled | yes |
| `drift_decay_linear=yes` | walled | yes, at deviation 0.004641 against a 0.05 threshold |
| `drift k=4 pct=100` present | walled | the far side is always swept |
| `keep_share=0.10`, `drift_grid_nodes=16` | walled | the sibling's threshold and grid, so the two compare |
| `file_proxy_survives_structure_drift_upto_pct` | reported | 70 |
| `file_drift_crossing_pct` | reported | 71.90 |
| `drift_crossing_closed_form_pct` | reported | 72.70 |

Every reported figure is **FREE** -- the tree grows, and `caravan` grows fastest -- so run the scan
rather than reading them here. The walled ones are walled because they are structural: a sweep that
stops biting, stops reaching the far side, or stops falling straight has changed what it measures.

**`drift_decay_linear=yes` is a wall on a free figure**, named as such. It stands on ten times its
own threshold today. The repair, if a future tree crosses it, is to drop the closed form rather than
to raise the threshold -- the closed form is only meaningful where the decay is straight, and a
threshold raised to accommodate a curve is a law bent to fit its exception.

## The falsifiers, named

This paper would be wrong if any of these read otherwise, and each is one command away:

- **`file_drift_crossing_pct` below 66.7.** The borrowing the file paper made would be unsound, and
  its weakest joint would open rather than close.
- **`drift k=4 pct=100 mean_gain_share` far above zero.** The sweep would not reach a graph
  unrelated to the layout, and every rung below it would be measuring something else.
- **`drift pct=0` departing from `sixteen_matched_gain_share` by more than 0.02.** The sweep would
  be costing a different placement than the one the scan computed.
- **`drift_decay_linear=no` on this tree.** The closed form would describe nothing, and reading
  three would fall.
- **A graph of ~7,500 edges reading `drift_decay_linear=no` while a graph of ~30 reads `yes`.**
  The sample-size inference in reading three would be refuted, and the linearity would want another
  cause.

**Confidence: high for readings one and two, moderate for reading three.** One and two are counted
over the whole population with the arithmetic printed beside them, and each is proven from its
refusing side in a pen. Three rests on three graphs at 32, 67 and 7,549 edges -- an ordering
consistent with averaging and equally consistent with something about these particular graphs. A
fourth graph at an intermediate size would sharpen it, and none was built here.

## What this does not reach

**A run-time weight.** This tree still holds none. The sweep imagines a departure from structure
rather than measuring one, which is exactly what its sibling did and exactly what the file paper
said it was borrowing. What changed is that the imagining is now done on the graph the layout
actually uses.

**Whether the seed band holds.** The sibling reported its survival point as a band of seventy to
ninety percent across five seeds; this reading is taken at one fixed seed, because a walled scan
must not move between hosts. The scan carries no seed flag, so the band at file granularity is
unmeasured and named here rather than assumed.

**Whether a tolerance of 0.72 is enough for a real board.** It says the static graph survives a
great deal of being wrong. It says nothing about how wrong the truth actually is.

## The recommendation for row 7

**Keep the third erratum's re-aim exactly as written, and add one clause to its tolerance
sentence.** The row may now say that the static import graph read at file granularity tolerates
about **seven tenths** of its edges wandering before a computed layout stops earning its keep --
measured on this tree rather than borrowed -- and that the tolerance is set by the layout's own gain
over a count-matched floor rather than by the unit chosen.

**The rank stays twelfth.** Nothing here recommends moving it; a firmer operand for a placement
nobody can run yet is a firmer operand, and no more.

---

*May the next number this lane borrows be re-read on the graph it is asked about.*
