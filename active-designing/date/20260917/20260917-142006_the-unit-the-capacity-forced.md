# The unit the capacity forced

**Stamp:** `20260917.142006`
**Language:** EN
**Room:** checkable -- every figure below is published by
[`../tools/fixtures/a/aurora_file_placement_scan.sh`](../tools/fixtures/a/aurora_file_placement_scan.sh)
and the instrument is walled by
[`../tools/a/aurora_file_placement_witness.rish`](../tools/a/aurora_file_placement_witness.rish),
rostered as the guard `aurora_file_placement` at `tier lap`
**Status:** Landed -- the measurement stands; what it recommends for row 7 is a recommendation
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Answers:** the named next step of
[`20260916-095958_the-two-ways-a-proxy-drifts.md`](20260916-095958_the-two-ways-a-proxy-drifts.md),
and through it row 7 of
[`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Kin:** [`20260916-042700_the-grid-that-was-already-flat.md`](20260916-042700_the-grid-that-was-already-flat.md)
-- [`20260915-175000_the-axis-that-carried-nothing.md`](20260915-175000_the-axis-that-carried-nothing.md)

---

## The sentence this answers

Row 7 of the bounded-torus moonshots asks for a placement map as its first witness: which module
sits on which node of a small torus of cores. Two readings have already been taken of it. The first
found the map has no operand -- this tree holds structure rather than traffic. The second found
something harder, and closed on a step it left for somebody else:

> **every assignment of MODULES to nodes overflows a node at either grid the row names** -- while
> the largest single file is a quarter of a node's share, so the unit fits one level down.
>
> Recommended re-aim a second time: **name which FILES sit on which node rather than which
> modules**, since the coarsening the first erratum called the harder half is forced rather than
> optional.

This paper takes that step, and it finds three things. The unit that fits has a ceiling of its own,
one grid up. The graph at that granularity is mostly edges a room-level reading cannot see. And the
coarsening the constraint forbids was carrying most of the locality the row was quietly counting on.

## What was measured, and how

`tools/fixtures/a/aurora_file_placement_scan.sh` reads this tree and emits `key=value` lines.
The population is every tracked `*.rye` path whose git mode is a regular file -- **1,761 sources**,
**35,113,670 bytes**, read `20260917.142006`. The **233** tracked Rye symlinks are excluded from
the population and used as what they are: this tree spells a cross-room import as a bare name
pointing at a hand-filed symlink, because Zig refuses an import that escapes the root file's own
directory.

An edge is one `@import("name.rye")` site, resolved against the importing file's directory, through
the symlink map where one stands, and kept only when both ends are real files in the population.
A self-import is dropped. A mutual pair is one edge rather than two, since the cost of an edge is
symmetric. That gives **7,549 unordered edges** over **1,561 endpoint files**.

The placement is a capacity-constrained greedy assignment: files ordered by degree descending with
the file name breaking every tie, each taking the feasible node that minimises its cost against the
neighbours already placed. A node's capacity is the equal share plus a named 25 percent of slack,
so a packer has somewhere to put a file that will not fit an exact sixteenth. **The layout is a
property of the tree rather than of a listing order**, and the control reads the same tree twice to
say so.

Every figure here is **free**: the tree grows. Run the scan rather than reading them.

## Finding one -- the unit that fits has its own ceiling

| Grid | Nodes | Equal share, bytes | Largest file's share | Fits | Rooms over share |
|---|---|---|---|---|---|
| 2 x 2 | 4 | 8,778,417 | 0.0647 | yes | 1 of 44 |
| 4 x 4 | 16 | 2,194,604 | 0.2589 | yes | 4 of 44 |
| 8 x 8 | 64 | 548,651 | **1.0357** | **no** | 11 of 44 |

The largest single file is `caravan/farewell.rye` at **568,249 bytes**. The elder erratum's "a
quarter of a node's share" is exact at sixteen nodes, and the sentence stops one grid too early:
at sixty-four nodes that one file is **103.6 percent** of an equal share, so no assignment of files
to nodes divides the tree evenly there either. The escape the coarsening bought is **one grid
wide**, and it runs out immediately above the largest grid row 7 names.

The reading matters because a bounded scheduler on a real board does not get to choose its node
count for the convenience of its source tree. Sixty-four cores is an ordinary number.

## Finding two -- most of the graph was never visible

| Reading | File granularity | Room granularity |
|---|---|---|
| Edges | **7,549** | 67 room pairs |
| Endpoints | 1,561 files | 36 rooms |
| Edges per room pair | **112.672** | 1 |

**6,389 of the 7,549 edges -- a share of 0.8463 -- have both ends in one room.** A room-level graph
cannot represent them at all: they vanish into a node of the coarser graph. That is not a defect of
the elder reading, which was answering a different question; it is what a coarsening does.

The consequence is what makes it worth writing down. Under a module placement, every one of those
6,389 edges lands on a single node **by construction**, and costs nothing. The room graph the elder
reading measured is therefore the whole of what a module placement would have had to pay for --
about a sixth of the coupling that is actually there.

## Finding three -- the price of the forbidden coarsening

Put the two together. Capacity forbids the module placement. So the free traffic stops being free.

| Layout | Share of edges on one node | Feasible at 16 nodes |
|---|---|---|
| By room (forbidden) | **0.8463** | no -- 4 rooms exceed a node |
| By file (computed) | **0.2184** | yes -- 0 files unseated |

**0.6279 of the graph turns from free traffic into real hops**, purely because the unit had to get
smaller. The placement is not merely finer-grained; it is solving a materially harder problem than
the one the row's sentence describes, and the difficulty arrives from the capacity term rather than
from the topology.

The layout is still worth computing, and the reading that says so is the conservative one:

| Grid | Cost | Free random floor | Gain | **Count-matched floor** | **Matched gain** |
|---|---|---|---|---|---|
| 4 nodes | 4,306 | 7,552.292 | 0.4298 | 6,804.292 | **0.3672** |
| 16 nodes | 9,072 | 15,088.833 | 0.3988 | 14,288.667 | **0.3651** |
| 64 nodes | 17,582 | 30,210.667 | 0.4180 | 28,994.292 | **0.3936** |

The **count-matched** floor is the one that decides it, and the reason is a lesson this lane already
paid for one paper over: a node holding many files pays nothing for the traffic inside it, so a
layout free to pile files up beats a spread baseline under **any** weights, including weights
carrying no information at all. The matched floor deals every file at random into the same per-node
file count the computed layout produced, so the only thing left to compare is where the graph put
them. It ignores capacity on purpose -- a baseline free of a constraint the layout obeyed can only
do better than an achievable one, which makes the comparison conservative in the direction that
matters. The computed layout beats it by **0.3651** at the grid row 7 names.

## The falsifiers, named

This paper would be wrong if any of these read otherwise, and each is one command away:

- **`unit_fits_sixteen=no`.** The file unit would fail exactly where the module unit does, and the
  erratum's named step would be unavailable rather than merely harder.
- **`intra_room_edge_share` near zero.** The finer unit would reveal nothing a room graph lacked,
  and finding two would be arithmetic about nothing.
- **`sixteen_beats_matched_floor=no`.** The layout would read no better than its own occupancy
  dealt at random, and the placement would be measuring concentration rather than coupling.
- **`sixteen_infeasible_files` above zero.** The capacity rule would have failed to seat a file,
  and the feasibility claim in finding three would be false.

**Confidence: high for findings one and two, moderate for finding three.** One and two are counted
over the whole population with closed arithmetic beside them -- an equal share is a division, and
an intra-room edge is a string comparison. Three rests on one greedy heuristic and one baseline
family, so the *sign* is solid and the *magnitude* is a property of this packer. A better packer
would raise the kept share and lower the cost; nothing available would move the 0.8463 a room
layout gets for free, because that number is the graph rather than the algorithm.

**Horizon: this tree, this week.** Every figure moves as the tree grows, and the direction is
adverse -- `caravan` is already 14,039,993 bytes, and a room that grows crosses a share before the
tree does.

## What this does not reach

**Whether a torus board arrives.** The geometry half of row 7 is graded in its sibling instrument
and untouched here.

**Whether files are the right unit for a real Aurora.** They are the unit *this* constraint leaves
available on *this* corpus. A build that emits one object per module, or a linker that splits a
file, changes the question entirely.

**A run-time weight.** The import graph is structure read as a lower bound on coupling, and its
sibling measured the tolerance: roughly two thirds of the edges may wander before a computed layout
falls behind chance. That tolerance is borrowed here rather than re-measured, and it is the
weakest joint in the argument.

**Whether the placement should be computed at all before a board exists.** Row 7 is ranked twelfth
of twelve, and nothing here recommends moving it.

## The recommendation for row 7

**Re-aim a third time, keeping the rank of twelfth.** Keep the row and its placement map. Say
**files** rather than **modules**, name the grid ceiling the file unit carries -- it fits at four
and sixteen nodes and overflows at sixty-four -- and state plainly that the capacity constraint
costs the map about five eighths of the locality a module placement would have had for nothing.
The row's first witness is then a sentence a measurement can answer, which is what it has lacked
through three readings.

---

*May the unit we can afford be the unit we describe, and may the price of a coarsening we cannot
have be written down beside it.*
