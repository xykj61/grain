# The two ways a proxy drifts, and the one that decides it

**Stamp:** `20260916.095958` -- **Status:** Landed -- **Room:** mixed -- the four readings are checkable and bound by a green witness; the disposition at the close is a recommendation and waits for Keaton's word.
**Style:** Gauge at Field -- **Voice:** Kyri -- **Seat:** diffuser
**Answers:** the question [`20260916-042700_the-grid-that-was-already-flat.md`](20260916-042700_the-grid-that-was-already-flat.md) raised and set aside
**Grades:** row 7 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Instrument:** [`../tools/fixtures/a/aurora_placement_scan.sh`](../tools/fixtures/a/aurora_placement_scan.sh)
-- **Pen:** [`../tools/fixtures/a/aurora_placement_control.sh`](../tools/fixtures/a/aurora_placement_control.sh)
-- **Witness:** [`../tools/a/aurora_placement_witness.rish`](../tools/a/aurora_placement_witness.rish), rostered `aurora_placement`, `tier lap`

Row 7 of the bounded-torus moonshots wants a placement map: which module sits on which core of a
16-core network-on-chip, and the hop count for every pair. The reading of `20260916.042700` found
the map's operand absent -- this tree measures what it is far more than what it does -- and closed
on a question it set aside:

> whether the static import graph, read as a **lower bound** on coupling rather than as a weight,
> would be enough to start.

This reading answers it. The answer is **yes, with a named tolerance**, and it turns on a
distinction the question left open.

## The question has two halves, and only one is about weight

A proxy graph departs from the truth two independent ways.

**Scale drift.** The edges stand and the numbers wander: a pair carrying twice the traffic its
import count suggests, or a tenth of it.

**Structure drift.** The edges themselves wander. An import read once at startup stays silent all
day, and two rooms that skip each other in source may speak through a third.

Every discussion of this proxy in the tree so far has named the first. The reading below measures
both, and they answer oppositely.

## Reading: what the proxy buys, once the baseline is honest

A placement is costed as the weight of every cross-node pair times its hop count. Rooms are
coarsened onto the nodes by heavy-edge merging, and the groups laid on the grid by a bounded search
over 27 deterministic orders. Read `20260916.095958` by `sh tools/fixtures/a/aurora_placement_scan.sh`:

| Grid | Computed torus cost | Size-matched floor | Size-matched mean | Gain | Clears the floor |
|---|---|---|---|---|---|
| 2 x 2, 4 nodes | 4 | 4 | 53.891 | 0.9258 | it ties |
| 4 x 4, 16 nodes | 49 | 147 | 352.257 | **0.8609** | **yes** |

**The baseline is size-matched, and that is what makes the number mean anything.** A node holding
many rooms pays zero for the traffic inside it. So a layout free to pile rooms up beats a spread
baseline under **any** weights, including weights carrying pure noise. The first draft of this
reading used an unconstrained baseline, and the computed layout finished **behind** chance, 49
against a mean of 30.5. The reason is plain once seen: the true minimum of an unconstrained
placement is every room on one node at cost zero. That is the objective asking for a capacity term.
The baseline here deals the rooms out at random into the **same node-occupancy profile** the
computed layout produced, so the only thing left to compare is where the graph put them.

**It costs the graph three points of credit to be measured honestly.** Against a baseline required
only to fill every node, the same layout reads a gain of 0.8931; against the size-matched one,
0.8609. The difference is occupancy rather than coupling -- the busiest node holds **17 of the 32
rooms** in the graph.

**At four nodes the layout ties its floor**, which is the verdict the geometry half reached by
another road: at the smaller grid the row's artifact is ceremony.

**And the second axis pays.** The same layout costed on a ring of the same node count reads **88**
against the torus's **49**, so the torus is worth **0.4432**. That is the first row on that page
where a second axis carries something past what a line already carries.

## Reading: scale drift leaves the layout where it stood

Each weight is multiplied by a factor drawn uniformly from `[1, R]`, the layout is costed under the
drifted weights, and the same matched baseline is costed under them too. Twenty draws per rung.

| Drift factor R | 1 | 4 | 16 | 64 | 256 |
|---|---|---|---|---|---|
| Mean gain share | 0.8574 | 0.8499 | 0.8506 | 0.8671 | 0.8732 |

**Flat to a factor of 256.** The scan emits `scale_drift_bites=no`. A reading that mis-scales every
weight by two orders of magnitude places exactly as well, because a placement depends on the
**order** of the weights far more than on their sizes, and multiplicative noise keeps that order in
expectation.

## Reading: structure drift is what decides it

With probability `p` a real import edge falls silent, and the same count of room pairs standing
outside the import graph carry traffic at the graph's own mean weight.

| Structure drift p | 0 | 20 | 40 | 60 | 80 | 100 |
|---|---|---|---|---|---|---|
| Mean gain share | 0.8574 | 0.6910 | 0.5409 | 0.3827 | 0.0571 | **-0.1057** |

**At total structural drift the computed layout finishes behind chance**, which is the reading
validating its own instrument. A layout built on an unrelated graph should finish behind a random
layout of the same shape, and it does, by a tenth.

The scan emits `structure_drift_bites=yes` and
`proxy_survives_structure_drift_upto_pct=60`, against a keep threshold of a tenth of the average
cost -- *a placement pass earns its keep at a tenth*, which is a named threshold rather than a
measured one. **The crossing sits in a band rather than at a point.** Re-run across five seeds, the
80 rung cleared the threshold twice and fell short three times, while every seed agreed that 60
clears it and 100 falls short. So the honest statement is **between 70 and 90 percent**, and the
emitted 60 is the last rung this instrument's own fixed seed clears.

**Read plainly: the static import graph may be wrong about two thirds of its edges and still place
better than chance.** That is a strong result for a proxy, and it is the answer the set-aside
question wanted.

## The operand nobody asked for, which this tree does hold

A placement has a second operand, and the row leaves both unnamed. A node holds a bounded amount of
code, so a map from rooms to nodes is feasible while every room fits inside a node -- and *that*
term stands here, as tracked Rye bytes per room.

| Reading | Value |
|---|---|
| Tracked non-symlink Rye bytes | 34,941,409 |
| Largest room | `caravan`, 14,039,993 bytes |
| Largest room's share | **0.4018** |
| Equal share per node at 16 nodes | 2,183,838 |
| Largest room over that share | **6.43x** |
| Largest single file | 568,249 bytes, 0.26 of the share |

**Every figure here is FREE** -- the tree grows -- so run the scan rather than reading them.

**Symlinks stay out of the byte count, and the exclusion is the reading rather than a detail.** A
cross-room `.rye` symlink is an import edge, and `wc -c` follows it, so counting one bills the
importing room for the imported room's bytes. This tree files 233 of them.

**So a placement at room granularity refuses before any weight is gathered.** One room is forty
percent of the tree's Rye and six times what an equal sixteenth would hold; at four nodes it is
still 1.61x. The row's first witness names *which module sits on which node*, and at either grid
the row names, every such assignment overflows a node. **At file granularity it fits** -- the
largest single file is a quarter of a node's share -- so the unit is the thing to change, and the
coarsening the prior reading called the harder half is forced rather than optional.

The bytes stand for instruction memory by assumption. A compiled size differs from a source size,
and the reading turns on a ratio near six rather than near one, which any uniform constant factor
leaves standing.

## What the pen found, which is the part worth reading twice

**A deterministic generator that names one arithmetic and runs another.** The first draft carried
the LCG this tree writes elsewhere, `state = (state * 1103515245 + 12345) % 2147483648`. In awk a
number is a double, and `20260912 * 1103515245 + 12345` is `22358225269615785` -- above the `2^53`
where a double stops holding integers exactly. Measured: awk computes `22358225269615784`, one
less, so the stream is a **rounded shadow** of the LCG the comment names, from its first step. It
stays reproducible wherever awk uses doubles, which is why it has stood this long; it would part
from itself on an awk carrying exact 64-bit integers. This reading uses MINSTD, `48271`, whose
largest product is `1.0e14` and stays exact. **Two tracked sites carry the elder multiplier** --
`tools/fixtures/t/torus_fold_control.sh:60`, whose own comment says *the pen must plant the same
population on every host*, and `tools/fixtures/w/workload_trial_scan.sh:275`, where the generator
is a CPU burner and exactness is beside the point. Named as a **tell** rather than booked as a red:
on this host the two spellings agree, and the divergence stays a hazard rather than a measurement.

**A leg thrown away for measuring a different thing.** The unconstrained baseline above is a
reading that **inverted**, rather than a fault that was fixed. It read as a finding -- *the graph
places worse than chance* -- for as long as it took to ask why chance was winning. A baseline free
to collapse everything onto one node has stopped being a baseline.

## What the witness proves

`tools/a/aurora_placement_witness.rish` is GREEN on metal over a control of **75 legs and 0
failures**, building three real git repositories in a throwaway pen. The first proves the operand
readings against counts known in advance. The second is new, and it exists because a placement
needs more rooms than nodes: six rooms and five weighted pairs, laid so the right answer is
computable by hand. Heavy-edge merging joins alpha and beta first at weight 3, then gamma at 2 + 1,
leaving four groups after two merges with three rooms on the busiest node. The two edges still
crossing a boundary cost exactly **3** on a 2 x 2 torus, and the pen asserts that number.

**A third pen carries no Rye at all**, and both granularity readings answer `unread` there rather
than `feasible`, with the placement refusing: an empty population fits every node trivially, and a
verdict unable to tell that from a real fit teaches nothing.

**Six mutations are planted and each is asserted to bite.** The four standing ones, and two new:
counting symlinks in the size reading, which bills a room for another room's bytes; and a baseline
that stops matching the occupancy profile, which is the inversion above planted deliberately.

## Projection

**Horizon:** the life of row 7, which the page puts at a year or more.

**Assumptions:** source bytes rank like instruction memory; the drift model -- uniform
multiplicative scale, uniform structural swap -- resembles how a real traffic graph departs from an
import graph; one edge per distinct import name is the right unit of static weight.

**Falsifier:** measure run-time message counts between rooms, then compute what share of import
pairs stay silent and how many hot pairs stand outside the import graph. Should that share exceed
roughly seventy percent, the static graph has stopped being enough to start, and this reading
retires. It is a measurement somebody can take.

**Confidence:** high on the capacity arithmetic, which is division on measured bytes; moderate on
the placement gain, which is a greedy upper bound over a proxy; low-to-moderate on the 70-to-90
crossing band, which rests on five seeds over six rungs.

## The disposition

**Change the unit, and keep the rank.** The prior reading recommended a re-aim from 4 cores to 16,
and that stands. This one adds: row 7's first witness should name **which files sit on which node**
rather than which modules, since at module granularity every assignment overflows a node at either
grid, and the overflow is arithmetic rather than opinion. And the row may state its operand
honestly now -- the static import graph, read as a lower bound, tolerates structural drift up to
roughly two thirds and still beats chance.

May the thing we measure be the thing that decides it, and may a proxy honest about its own limits
be worth more than a weight still ungathered.
