# The field with no distance -- what the roster answered when a falloff radius asked it a question

**Stamp:** `20260911.195059` - **Voice:** Kyri - **Style:** Gauge, Field setting
**Status:** Landed - **Room:** checkable (the reading is bound by `tools/a/aether_falloff_witness.rish`)
**Lane:** DIFFUSER -- moonshots and research
**Answers:** row 4 of [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md)
**Instrument:** [`../tools/fixtures/a/aether_falloff_scan.sh`](../tools/fixtures/a/aether_falloff_scan.sh) -
control [`../tools/fixtures/a/aether_falloff_control.sh`](../tools/fixtures/a/aether_falloff_control.sh) -
witness [`../tools/a/aether_falloff_witness.rish`](../tools/a/aether_falloff_witness.rish)

## What was asked

Row 4 of the moonshots page proposes an **aether falloff field** over the standing roster of
guards. Listening has a radius: intensity falls with distance, so a change wakes the rows near it
and leaves the rest cold. Its first witness asks for a roster scan that wakes only the rows within
path-distance R of the touched row, printing the woken count and the wall time.

The row states its own falsifier plainly: *the woken set at any useful R covers most of the roster,
which would show the roster is dense and a radius buys the same work under a new name.*

Nobody had taken that measurement. This paper takes it, and the falsifier fires.

## The measurement

**Observation.** Over a 200-commit window read `20260911` on this pier, at commit `f2e6f1b0e1`,
against `construction/standing-equipment.kyri` (345 seated guards) and
`tools/fixtures/s/standing_equipment_scope_map.sh` (66 rows):

| Reading | Value |
|---|---|
| Guards seated | 345 |
| Guards the map places in the tree | 57 |
| Guards declaring themselves whole-tree (`DISCOVERY`) | 9 |
| Guards with no map row at all | 279 |
| **Floor -- guards that wake at every radius** | **288, a share of 0.835** |
| Woken share of the whole roster at radius 0 | **0.881** |
| Woken share at radius 1 | 0.920 |
| Woken share at radius 2 | 0.996 |
| Radius at which the mapped 57 saturate | **2** |

**Observation.** The reading is steady across window sizes. A 40-commit window gives a floor share
of 0.835, a radius-0 share of 0.886, and the same saturation radius of 2.

**Observation.** Among the 57 guards the map does place, the mean distance to a commit's changed
files runs from **0.04** (`equinox_e123_living_pin_guard`) to **2.13** (`wire_lab_fn_drift`). The
entire coordinate range of the mapped population is under three hops.

## What the number says, and what it does not

**Inference.** The falsifier fires, and it fires at radius zero rather than at some useful radius
further out. A field that wakes 88.1 percent of the roster before its radius is even opened has
nothing left to fall off.

**Inference, and this is the part row 4 did not name.** The row attributes the covering to a
**dense** roster. The measurement gives a different cause: 288 of 345 guards carry **no coordinate
at all**. The scope map's own ABSENCE rule runs an unmapped guard on every pass, which is the
correct and conservative default -- a guard nobody has placed must not be skipped. So those guards
sit at distance zero from every change, by rule rather than by locality.

Density and absence are two faults wearing one number, and they want two different repairs. Absence
is closed by writing a map row, one guard at a time; that backlog is already priced by
`tools/fixtures/s/standing_equipment_scope_rank.sh`, which reads `absent_cost_share=0.920` on the
same day -- 92 percent of the roster pass's seconds held by guards nobody has mapped. Density is
closed by a finer coordinate, and no amount of mapping touches it.

**Inference, on the density half.** Suppose the map were finished tomorrow and every guard placed.
The radius-0 set among the currently mapped 57 is 16.05, a share of 0.282, and the radius-2 set is
all of them. So a perfect map would still leave a falloff field with **three distinct radii** --
0, 1, 2 -- before saturation. A 1/r intensity has nothing continuous to grade across three steps;
it is a step function with two thresholds, and the binary reach the tree already runs is that same
instrument with fewer parts.

## What this does not reach

**The coordinate itself is a choice, and the directory tree is only one.** Path distance is what
this tree owns today, so it is what was measured. A guard's real neighbourhood might follow the
import graph, the witness-to-control pairing, or the module roster rather than the filesystem, and
any of those could carry a wider range. The finding is about the roster under **this** coordinate.

**The anchor rule is an upper bound rather than an exact reading.** A watch word anchors to the
deepest leading directory holding no glob character, so `tools/*/ales_*_witness.rish` anchors at
`tools`. Widening an anchor can only ever shrink a distance, so every distance here is at or above
the true one, and the saturation radius reported is at or above the true saturation radius. The
finding survives that direction: a smaller true distance saturates sooner.

**Seconds are not counted here.** The ranking beside this one prices guards in wall time, and
running a second cost meter over one population would be the waste this tree names. Read the two
together.

## The projection, with its falsifier

**Projection.** Under the directory-tree coordinate, a falloff field over the standing roster will
save nothing measurable for as long as the map's coverage stays under roughly half the roster, and
will remain a three-step function after that.

**Horizon.** Through the next map-writing arc, however long the absent 279 take to place.

**Assumptions.** The scope map's ABSENCE rule holds, so an unmapped guard runs; the roster keeps
growing faster than the map; and the directory tree stays the coordinate.

**Falsifier, and it is cheap.** Re-run
`sh tools/fixtures/a/aether_falloff_scan.sh --window 200` after a mapping arc. Two readings would
overturn this paper. A `floor_share` under 0.5 with a `mapped_saturation_radius` of 4 or more
would show a real gradient had appeared, and a falloff field would then have something to grade. A
`woken_r0_share` under 0.5 would show the covering had lifted at the radius the falsifier turns on.

**Confidence.** High on the arithmetic, which is one pass over real commits and steady across two
window sizes. Medium on the projection, since it rests on the map staying behind the roster, and a
single arc of map-writing could move both numbers at once.

## Where row 4 now ranks

Row 4 stood at rank 6 of twelve, with the note *cheap to try; the saving rests on locality yet to be
measured*. The locality is measured. The row is **answered rather than retired**: its claim about
falloff is falsified under this coordinate, and the measurement it forced is the useful part --
`floor_share` names a backlog nobody had counted per guard, and the three-radius ceiling is a fact
any future scheduling proposal has to clear.

**Recommended re-rank: last among the twelve**, behind the whitepaper and the core torus, until
either the map is finished or a different coordinate is proposed. Writing a map row is the work
this row was standing in front of, and that work belongs to
`standing_equipment_scope_rank.sh`'s own ranking rather than to a radius.
