# The Wafer, Rehearsed in Software

**Stamp:** `20260826.001747`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; the wafer abstraction as a bounded module provable on ordinary metal now; the build is a future season's
**Kin:** [`../foundations/20260728-225239_the-wafer-and-the-sovereign-coin.md`](../foundations/20260728-225239_the-wafer-and-the-sovereign-coin.md) -- [`../external-research/20260826-001743_the-toroidal-archive-read-against-the-tree.md`](../external-research/20260826-001743_the-toroidal-archive-read-against-the-tree.md)

The tree holds the why of wafer-scale compute -- memory beside the cores, greener because
nothing travels far, funded openly as public infrastructure -- and the where -- the hot
graph held close, the cold remainder in low-cost storage, the log making the whole
recomputable. What the oldest pre-repo sketches held, and the tree does not yet, is a
how-now: the wafer's programming abstraction written today as a pure, bounded module,
proven by witnesses on ordinary metal, years before any open wafer exists to run it.

The tree already trusts this move. The Mikrophone's forgetful capture was proven pure in
Rye before any firmware touched a board. The same habit applies one level up: rehearse
the field of cores as a value, and let the silicon arrive later to a design already
green.

## The shape of the rehearsal

A late-2025 sketch laid the module out, and its bones hold. A **field** is a bounded
grid of core records -- an id, a state, a memory window -- with a named maximum
population. Placement on the grid wraps in both directions, so every core has exactly
four neighbors and no core is an edge case: the uniform-neighborhood property is the one
real gift of the torus, and it costs nothing in software. **The coordinate is the
address:** a core's grid position names its memory window, so the module carries no
translation table that could disagree with the layout. Allocation is a linear arena
against a named capacity, checked at the edge. Work is a bounded queue of operations
swept deterministically, so the same submissions in the same order always leave the field
in the same state -- which makes the whole module a pure fold, witnessable like any
other. Widths follow TAME as it stands today: u32 for counts and indices, u64 for sizes,
the seam casts named.

The rehearsal earns its keep twice. Today it is an honest scheduler model for many-core
machines already owned, and a test bed for the ring-lowering work the compute-layer draft
describes. The day an open wafer exists -- the day the sovereign-coin foundation argues
for -- the abstraction is already proven, and the public-funding case lands harder beside
a runnable design than beside a rendering.

## What the old sketch teaches by its own bug

The sketch computed a core's four neighbors into a stack-local array, then stored a slice
of that array in the long-lived core record -- a dangling reference the moment the
function returned, invisible to every assert in the file. The repair is the lesson: in a
bounded design, a neighbor set is four values stored inline or recomputed on demand,
never a pointer to a temporary. A rehearsal that ships with witnesses catches exactly
this class of wound, which is the strongest argument for rehearsing at all. The sketch's
redundant length-beside-slice fields carry the same smell, worth naming so the reborn
module avoids them.

## Honest labels, current figures

The wafer that exists is flat, with edges and an interconnect that routes around them.
The current generation's vendor figures: 900,000 cores, 44 GB of on-wafer SRAM, four
trillion transistors, on a 5 nm process, with external memory units of 1.5 TB to 1.2 PB
beside the wafer for large model weights (Cerebras WSE-3 announcement, March 2024; the
newest read this tree holds). Two idealizations in the old sketches therefore stay
labeled as such: "RAM-only, no external memory" describes an aspiration rather than the
shipping machine, and the solid three-dimensional torus is unfabricated and far beyond
present manufacturing -- the tree's silicon-torus silo already says so, and nothing
newer changes it. The toroidal wrap in the rehearsal is justified by the uniformity it
buys the software model, and would survive the hardware never arriving. One more image
from the old whitepapers files under vision: placing a mirror of each record at the
grid's far point as a redundancy pair is geometrically pleasing, unpriced, and welcome
to wait.

## Sources and standing

**Drawn from:** `0016-grain-field-wse-compute.md`,
`zyxsql-2025-11-23--034749-pst-grain-skate-toroid-silo-coordination.md`,
`silicon_torus_hpc_hardware_proposal_whitepaper.md`, and
`the-grain-point-whitepaper.md`.

**The living tree already covers:** the wafer's why in
`foundations/20260728-225239_the-wafer-and-the-sovereign-coin.md`; the hot/cold seam and
recomputable cache in `foundations/20260728-221253_the-graph-beneath-the-surface.md`; the
geometry's honest appraisal in
`external-research/grain-lineage-silo/silicon-torus-hardware.md`; the
prove-pure-before-metal habit in
`foundations/20260814-071700_hardware-and-right-to-repair.md`.

**Genuinely new here:** the rehearsal itself -- the wafer abstraction as a bounded,
deterministic, witness-proven module buildable now on ordinary metal; the dangling-slice
teaching lifted from the old sketch's own defect; and the current-figure grounding that
separates the shipping wafer from the sketches' idealizations.
