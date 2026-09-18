# One Lowering, Two Engines

**Stamp:** `20260826.001745`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; the tensor layer's shape carried forward from the April 2026 essays on our own roots; every seat awaits the Lattice season
**Kin:** [`../external-research/20260826-001743_the-toroidal-archive-read-against-the-tree.md`](../external-research/20260826-001743_the-toroidal-archive-read-against-the-tree.md)

The April 2026 essay pair proposed a Zig-native GPU compute layer and named it after a
tree at a garden's edge. The name belongs to that season, and the tree's inference names
-- Lattice for tensors, Ember for the bake, Lantern for the meter -- have since been
seated. What stayed alive under the name is a design for the tensor layer's shape, and it
is worth carrying forward on our own roots.

## Ship primitives and a fuser, never a library of special cases

The teacher project the essays studied reduces every neural computation to three
operation families: elementwise transforms, reductions, and movement operations that
reshape without copying. Every convolution, matrix product, and attention layer lowers to
a composition of those three, fused into kernels by a small compiler. The industry
alternative ships hundreds of hand-tuned kernels, one per operator variant per vendor.
The reduction is TAME's bound-everything applied at the level of a codebase: the teacher
holds its whole core under a stated line ceiling enforced in review, so the primitive set
stays small because the budget makes it stay small. Lattice, when its building season
arrives, should inherit exactly this: three op families as tagged unions, shape
bookkeeping resolved at compile time so it costs nothing at run time, a fuser with a
named maximum graph size, and a repo-level line budget with a witness watching it.

## Reach the accelerator through the widest stable seam

The essays' sharpest strategic idea generalizes the tree's own "widest stable seam" rule
to GPU compute. Three seams exist, in descending width. The **portable kernel form** -- a
standard intermediate representation any conformant graphics driver accepts -- runs on
silicon from every vendor, which makes it the seam with the most independent
implementations. The **direct GPU-ISA emission** path compiles straight to one vendor's
open instruction target and loads through the operating system's own kernel driver,
bypassing the vendor's userspace stack entirely. The **vendor runtime** is the narrow
seam, one implementation, one owner, held at arm's length. The Zig toolchain of that
season already emitted the first two forms natively, with honest limits the essays named
plainly: weaker floating-point guarantees on the portable path, and no standard-library
GPU primitives yet. Both facts are the essays' own April 2026 reading and want
re-verification the day a Lattice lap opens. The order of preference stands regardless:
widest seam for reach, direct emission for sovereignty, vendor runtime only where a host
seam is honestly named.

## One geometry, two lowerings

The quiet thesis underneath: the bounded ring is one abstraction with two lowerings. On
the CPU it lowers to a masked wrap index over a power-of-two buffer. On the GPU it lowers
to a bounded kernel dispatch queue. A service scheduling GPU work should reach for the
same ring primitive as a service scheduling CPU work, so the kernel's story and the
accelerator's story stay one story, and the bounds discipline crosses the seam intact.
This is the piece no external teacher supplies, because it depends on the tree's own ring
vocabulary -- and it is the piece that makes the tensor layer Grain's rather than a port.

## Decline the faster locked path, and say so

The essays refused the higher-throughput accelerator boxes on principle: silicon whose
compute stack answers to one vendor locks the ring at the substrate, whatever the
benchmark says. That refusal deserves to be a written law rather than a preference:
**where two substrates differ mainly in lock-in, take the open one and write down the
cost.** The cost is real -- the locked path was faster on paper -- and writing it down is
what keeps the choice a decision rather than a mood.

## The order of purchase

The sibling essay's ladder discipline compresses to three rungs, and the first one is
free. **Rung zero:** the proof runs under emulation on the machine already owned; a
cross-compiled kernel booting in an emulated open-ISA machine is a software project with
a hardware price of zero. **Rung one:** the demo runs on the cheapest real open-ISA board
(the essays' example: a four-core RISC-V mini-ITX board listed from $199 at its late-2024
launch, per the vendor's announcement). **The apex** is bought by the engagement that
needs it, paid for by that engagement, never in advance -- the second harvest's "buy the
rung the work has earned," with the zero-dollar rung now written beneath it. The
self-hosting economics ride the same discipline: a machine owned outright, depreciated
over its service years plus electricity, is compared honestly against a per-seat monthly
subscription, and the strongest line in that comparison is physical rather than
financial -- the weights live in a machine in the room, so the data-custody story is a
door and a lock rather than a certification. Live prices belong to the tree's purchase
guide, which already carries them with dates; funding questions defer to the register of
money spent into being.

## Sources and standing

**Drawn from:** `2026-04-18-023802-pdt-two-boxes-one-ring-v5.md` and
`2026-04-18-031102-pdt-the-open-spine-v4.md`.

**The living tree already covers:** the tensor teacher study and Lattice's inheritance
list in `external-research/20260620-020712_formats-editors-inference-and-tensors.md`; the
widest-stable-seam and buy-the-earned-rung maxims in
`external-research/20260703-071712_the-second-harvest.md`; live hardware pricing in
`external-research/20260703-013412_home-server-purchase-guide.md`; the accelerator host
seam noted in `external-research/20260710-133500_local-forge-minisforum-inference.md`;
the funding register in `external-research/20260729-231500_money-spent-into-being.md`.

**Genuinely new here:** the three-family-plus-fuser reduction stated as a bound rather
than a preference; the three-seam ladder for reaching a GPU, with the direct-emission
middle rung; the one-geometry-two-lowerings thesis tying the dispatch queue to the tree's
ring vocabulary; the substrate lock-in refusal written as a law with its cost named; and
the zero-dollar rung seated beneath the earned-rung discipline.
