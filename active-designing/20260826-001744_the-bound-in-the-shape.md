# The Bound in the Shape

**Stamp:** `20260826.001744`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; extracted from the toroidal archive through the New Gauge lens; the TAME passage it proposes awaits Keaton's word
**Kin:** [`../context/TAME_CORE.md`](../context/TAME_CORE.md) -- [`../external-research/20260826-001743_the-toroidal-archive-read-against-the-tree.md`](../external-research/20260826-001743_the-toroidal-archive-read-against-the-tree.md)

A bound can live in a structure's coordinates rather than in a runtime check. That is the
one engineering idea the toroidal research pair keeps giving, and it deserves a worked
passage rather than a one-line memory. TAME already commands the bound: every allocation,
collection, and loop names a max, checked at the edge, failing with a named error. This
note describes the strongest form that command can take -- the form where the check
becomes a property of the data's shape, true by construction, with nothing left for
vigilance to forget.

## Two ways to hold a bound

**A bound by vigilance** is an assert at the edge. It is honest, it is TAME's floor, and
it depends on every future editor keeping it in place. **A bound by construction** weaves
the budget into the structure itself, so no code path exists that escapes it. The humble
form is already everywhere in this tree: a lap buffer whose index arithmetic wraps modulo
a power of two is a one-dimensional torus, and its wraparound index is a bound expressed
as shape. No index computed through the mask can leave the buffer, whatever the caller
intended. The general pattern: whenever a budget can be carried in the coordinates -- a
compact domain, a masked index, an address whose form is its own range proof -- prefer
that carriage, and keep the assert beside it as documentation of the invariant the shape
now enforces.

## Wrap is a meaning, never a net

The old hardware paper praised toroidal wrapping as a safety feature: out-of-bounds
access becomes a valid coordinate, so no buffer overflow. Read carefully, that sentence
describes a masked fault rather than a prevented one. An index that walked past the end
of a linear quantity and wrapped to the front did not become correct; it became silently
wrong at a valid address, which is the failure mode hardest to see.

The honest rule has two halves. **Wrap where the quantity is genuinely periodic** -- an
angle, a phase, a position in a ring that means to be a ring -- because there the wrap is
the semantics, and boundary handling would be the bug. **Assert where the quantity is
linear** -- a count, an offset into a record, a depth -- because there the wrap would be
aliasing wearing a safety costume. Every wrap site earns its `// invariant:` comment
saying which of the two it is. A reviewer who cannot tell whether a wrap is meaning or
net has found a red.

## The address that proves itself

The second gift of the geometry: when a value's coordinate is its address, a whole class
of translation state disappears. The old papers said it of silicon -- a memory cell's
coordinate on the torus is its pointer, no page tables, no translation layer -- and the
tree already lives a software form of it: a content address in Mantra is the value's own
digest, so no registry can disagree with it; a masked lap-buffer index is the slot's own
name, so no free-list can leak. This is the same argument static allocation makes about
allocator state: what the structure carries in its shape, the system never has to
persist, recover, or trust. Fewer translation layers is fewer places for the truth to
drift.

## A parked optimizer, honestly labeled

The research pair also carried a real technique: gradient descent on a compact, periodic
parameter domain, corrected by the local curvature, with a diagonal approximation that
keeps each step linear in the parameter count and fully deterministic. The shape fits
this tree exactly -- bounded domain, reproducible runs, single lane. The source's own
typical-case claim, unverified here, is convergence in tens of steps where the plain
gradient takes hundreds; its hardware multipliers (1.7x to 2.9x against a wafer-scale
baseline, from the January 2026 whitepaper) stay unquotable, since they are entangled
with silicon that was never built. The technique stays parked until a real tuner in this
tree wants it -- and when one does, the compact domain is the part to keep, because it is
the bound-in-the-shape pattern applied to a search space.

## Sources and standing

**Drawn from:** `toroidal-bounded-optimization.md`, `silicon-torus-hardware.md`,
`toroidal_ml_synthesis_whitepaper.md`, `the-grain-point-whitepaper.md`, and the harvest
line in `20260703-071712_the-second-harvest.md` ("let the shape carry the bound").

**The living tree already covers:** the one-line insight, recorded in
`external-research/20260703-071712_the-second-harvest.md` and marked ready to draft; the
optimizer's honest summary in
`external-research/grain-lineage-silo/toroidal-bounded-optimization.md`; the geometry
claims in `external-research/grain-lineage-silo/silicon-torus-hardware.md`; the bound
command itself in `context/TAME_CORE.md` root rule 1.

**Genuinely new here:** the worked construction-versus-vigilance distinction as a
candidate TAME passage; the wrap-is-a-meaning rule with its per-site invariant duty,
which corrects the old paper's wrap-as-safety claim; and the address-that-proves-itself
bridge from the hardware papers to Mantra's content addressing.
