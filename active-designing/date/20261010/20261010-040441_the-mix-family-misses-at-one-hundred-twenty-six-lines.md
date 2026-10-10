# The bit-mix family also misses the floor at 126 lines, so the miss belongs to the index function

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep at 21 sets by 6 ways under the second hash family, falsifier written before the run
**Room:** checkable -- the fruit names its scratch script and output file; both reproduce on this pier, though the scratch sits in an untracked, gitignored folder
**Date:** 2026-10-10 (stamp `20261010.040441`)
**Scope:** the scratch model only, with no hardware claim
**Lineage:** the 126-line paper [`20261010-040037`](20261010-040037_the-fold-family-misses-at-one-hundred-twenty-six-lines.md) named a second hash family at 126 lines as its next door, beside a 127-line layout

## What this paper asks

The 126-line paper showed the fold index missing the compulsory floor at 126 lines on all 24 seeds, which moved the window's lower bound to 127. That paper could not say whether the miss belongs to the fold family or to every index function at this capacity. This paper runs the bit-mix finalizer family at the same 126 lines and asks which of the two it is.

## Setup

- **Model, stencil, grid, and order:** unchanged from the earlier papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a set-associative LRU cache in a scratch model. The compulsory floor is 0.0025.
- **Layout:** 21 sets by 6 ways, so 126 lines, the same layout as the fold run.
- **Index family:** the bit-mix finalizer `mix` from `run_r3_mix.py` (two multiply-xorshift rounds, `0x85EBCA6B` and `0xC2B2AE35`), set index `mix(line, seed) % sets`.
- **Seeds:** 24 seeds from the SplitMix64 stream at 20261010, the same stream the fold run used.
- **Script:** `session-output/diffuser-stencil-r3/run_r3_mix_21x6.py`, which imports the model from `run_r3_mix.py`. **Output:** `session-output/diffuser-stencil-r3/run_256_r3_mix_21x6_24.txt`, 24 lines, run under `python3 -I` in 37 seconds.

## Order note

The script's header was written after the clock read `20261010.040441` and before any output was read. The falsifier below is the text in that header.

## Falsifier, written before the run

- **Falsifier:** mix reaches the compulsory floor (0.0025) at 126 lines on every seed. That would show the 126 miss is a property of the fold family, and the fold result stands as a family-specific miss.
- **Miss branch:** mix misses the floor on every seed. The miss belongs to the index function as a whole, and the lower bound stays at 127 to 128 for both families.
- **Mixed branch:** some seeds reach and some miss. The 126 point is reported as seed-dependent for mix, and the window is not moved by this run.

## Result, read at `20261010.040441`

- **Seeds reaching the floor:** 0 of 24.
- **Row-major miss rate:** 0.0084 to 0.0089 against the 0.0025 floor, across 24 seeds.
- **Falsifier branch:** the miss branch. Every seed misses, so the falsifier's first branch did not fire, and the miss branch did.

**Establishes, on this model:** the bit-mix family misses the compulsory floor at 126 lines under 21 by 6, on all 24 seeds. Together with the fold run at the same layout, two index families both miss at 126. The 126-line miss therefore reads as a property of the index function as a whole at this capacity, and the fold family is not the cause.

**Also visible, and not claimed as a finding:** at 126 lines the mix family's rate sits near 0.0086, while the fold family's sits near 0.0031 at the same capacity. Both miss the floor, but mix misses by roughly three times the margin. The index function matters a great deal for this stencil at this capacity, and this run does not say why.

**Does not establish:** a threshold at exactly 127, since the 127-line point has not been run. Nor does it establish that mix misses at every capacity; the earlier 112-line runs already showed mix missing in every cell, consistent with this reading, but that was a different capacity. The index functions tested are two, and both use the modulus on a non-power-of-two set count, so a third family might differ.

## Confidence

- **High** that, on this scratch model with this seed stream, the bit-mix family misses the floor at 126 lines under 21 by 6, on all 24 seeds. The margin is wide: the lowest mix rate, 0.0084, is 3.4 times the floor.
- **Moderate** that the 126 miss is an index-function property rather than a layout property. Both families were run in one layout, so a layout effect is not yet ruled out.
- **Low** that the same window holds under a real replacement policy, since this run uses LRU in a scratch model with one stencil and one visit order.

## What would kill this

The reading that the miss is an index-function property would fall if a third, structurally different index family reached the floor at 126 lines on some seed. Under that result the claim narrows to these two families. The reading would also fall if the 127-line layout reached the floor for both families, since that would place the threshold at 127 and show the 126 point was a layout artifact. Neither has been run.

## Next door

Two candidates, neither run here:

1. A 127-line run, which needs a layout that keeps the way count near 6 or 8. No clean power-of-two split exists at 127, so the paper does not name one as settled.
2. A third index family at 126 lines, written with its falsifier first, to test whether any hash reaches the floor at this capacity.

The next lap should pick one and write its falsifier before any sweep. Neither needs Keaton's word, since both stay inside the scratch model.

## Scope, stated once

Scratch model only. No hardware, no counter, and no claim about any real cache. The script and output sit in an untracked, gitignored folder, and the paper names both so a reader can rerun them.
