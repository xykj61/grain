# The fold family misses the floor at 126 lines, so the lower bound moves to 127

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep at 21 sets by 6 ways, falsifier written before the run (see the order note below)
**Room:** checkable -- the fruit names its scratch script and output file; both reproduce on this pier, though the scratch sits in an untracked, gitignored folder
**Date:** 2026-10-10 (stamp `20261010.040037`)
**Scope:** the scratch model only, with no hardware claim
**Lineage:** the 125-line paper [`20261010-035410`](20261010-035410_the-fold-family-misses-at-one-hundred-twenty-five-lines.md) named this run as its next door

## What this paper asks

The 125-line paper showed fold missing the compulsory floor at 125 lines on all 24 seeds, which left the window's lower bound at 126 to 128 lines. Its own next door was a 21-by-6 layout at 126 lines, the cleaner of two options, since 127 by 1 changes the associativity class and tests a different property. This paper runs that layout and asks whether fold reaches the floor at 126.

## Setup

- **Model, stencil, grid, and order:** unchanged from the earlier papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a set-associative LRU cache in a scratch model. The compulsory floor is 0.0025.
- **Layout:** 21 sets by 6 ways, so 126 lines, the capacity this window's lower end needs.
- **Seeds:** 24 seeds from a SplitMix64 stream at 20261010, the same generator the 14-set and 25-by-5 runs used.
- **Script:** `session-output/diffuser-stencil-r3/run_r3_fold_21x6.py`, a copy of the 25-by-5 script with the set tuple changed to `(21,)` and the way count changed to 6. **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fold_21x6_24.txt`, 24 lines, run under `python3 -I`.

## Order note

The falsifier was written into the script's header at `20261010.035953`, before the run. The header first carried the 25-by-5 template's falsifier text, a copy error. That text was replaced before any sweep ran, and the run's output was produced only after the replacement. The falsifier below is the replaced text.

## Falsifier, written before the run

- **Falsifier:** fold reaches the compulsory floor (0.0025) at 126 lines on every seed. That would move the lower bound to 126 and close the window on the 126 point.
- **Miss branch:** fold misses the floor on every seed. The lower bound moves to 127 and the window reads 127 to 128.
- **Mixed branch:** some seeds reach and some miss. The 126 point is reported as seed-dependent on this model, and the window is not moved.

## Result, read at `20261010.040037`

- **Seeds reaching the floor:** 0 of 24.
- **Row-major miss rate:** 0.0029 to 0.0034 against the 0.0025 floor, a range of 24 seeds.
- **Falsifier branch:** the miss branch. Every seed misses, so the falsifier's first branch did not fire.

**Establishes, on this model:** fold misses the compulsory floor at 126 lines under 21 by 6, on all 24 seeds. Combined with the 124-line and 125-line papers, which also missed on every seed, fold now misses at 124, 125, and 126 lines. The reaching points are 128 lines in two layouts, 136 and 144 lines at 17 and 18 sets, and 128 at 16 sets. The window's lower bound moves from 126 to 127 on this model.

**Does not establish:** a threshold at exactly 127. The 127-line point has not been run. The 127 by 1 layout would test associativity rather than capacity, so it is a different question from the one this run answers. A 127-line run needs a 127-line layout that keeps the way count near the others, and no such layout is a clean power-of-two split. The paper does not name one.

## Confidence

- **High** that, on this scratch model with this seed stream, fold misses the floor at 126 lines under 21 by 6. The margin is consistent: row-major sits 16 to 36 percent above the floor across every seed.
- **Moderate** that the same window holds under a real replacement policy. This run does not test one, and the model has one stencil and one visit order.
- **Low** that the threshold is a clean capacity line rather than a layout effect. The 126 point has now been run in one layout only.

## Next door

Two candidates, neither run here:

1. A 127-line run at a layout that keeps the way count close to 6 or 8, with its falsifier written first. The available options are awkward, so this paper does not name one as settled.
2. A second hash family at 126 lines, to test whether the miss is a property of the fold family or of the index function as a whole.

The next lap should pick one and write its falsifier before any sweep. Keaton's word is not needed for either, since both stay inside the scratch model.

## Scope, stated once

Scratch model only. No hardware, no counter, and no claim about any real cache. The script and output sit in an untracked, gitignored folder, and the paper names both so a reader can rerun them.
