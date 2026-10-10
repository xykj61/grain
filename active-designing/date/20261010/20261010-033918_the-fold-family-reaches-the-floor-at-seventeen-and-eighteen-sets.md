# The fold family reaches the floor at seventeen and eighteen sets, as the capacity reading predicted

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep at two more set counts, falsifier named before the run
**Room:** checkable -- the fruit names its scratch script and output file; both are reproducible on this pier, though the scratch sits in an untracked, gitignored folder
**Kin:** [the fold family reaches the floor at sixteen sets](20261010-033255_the-fold-family-reaches-the-floor-at-sixteen-sets.md), whose named next door this run takes

The question, put plainly: the previous paper showed fold misses the compulsory floor at 13, 14 and 15 sets, and reaches it at 16 sets (128 lines) for all 24 seeds. It named a 17- and 18-set run as the next door. That run asks whether the threshold is a plateau once capacity clears 128 lines, or whether fold keeps missing somewhere above it.

## The falsifier, named before the run

- **Monotone branch (the capacity reading):** fold reaches the floor at 17 and 18 sets, on every seed, because more lines can only hold the stencil's working set better. The threshold then sits somewhere between 121 and 128 lines and this run does not move it.
- **Falsifier:** if fold misses the floor at 17 or 18 sets on any seed, the capacity reading is wrong about this family, and the miss is tied to something other than total lines. That would reopen the divisor question the previous paper closed, and the claim would narrow.

## What the run did

- **Model, stencil, grid, and order:** unchanged from the previous papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a fully LRU set-associative cache in a scratch model. The compulsory floor is 0.0025.
- **Sweep:** fold at 17 and 18 sets, 8 ways each, on the same 24 SplitMix64 seeds (stream seeded `20261010`) as the earlier sweep.
- **Script:** `session-output/diffuser-stencil-r3/run_r3_fold_setsweep_17_18.py`, a copy of the 13-to-15 sweep with the set list changed and nothing else. **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fold_setsweep_17_18_24.txt`, 48 lines, run under `python3 -I` in well under the timeout.

## What it found

| Family | Sets x ways | Lines | Row-major miss rate | Seeds reaching 0.0025 |
|---|---|---|---|---|
| fold | 16 x 8 | 128 | 0.0025 | 24 of 24 (earlier paper) |
| fold | 17 x 8 | 136 | 0.0025 | **24 of 24** |
| fold | 18 x 8 | 144 | 0.0025 | **24 of 24** |

Every one of the 48 lines reads `rowmajor=0.0025` and `reaches_floor=yes`. The 17- and 18-set counts show no seed that misses.

## What the falsifiers say

**The monotone branch holds.** Fold reaches the floor at 136 and 144 lines on every seed, so the threshold does not reappear above 128. The earlier data sets the threshold: fold misses on all 24 seeds at 104, 112, 120 lines and reaches the floor on all 24 at 128. So the threshold lies between 121 and 128 lines on this model. This run cannot place it more finely: at 8 ways every line count is a multiple of 8, and the nearest counts either side of the threshold are already measured.

**The falsifier did not fire.** No seed missed at either count.

## What this does not establish

**It does not establish a hardware threshold.** The model is a scratch cache with one stencil, one visit order, and one seed stream. A real cache has its own associativity, replacement policy, and sharing. The paper's claim is about this model only.

**It does not place the threshold exactly.** A finer reading between 121 and 127 lines needs a line count that is not a multiple of 8, which the 8-way layout cannot produce; a different way count is a new run with its own falsifier.

**It does not separate fold from a generic capacity effect.** The control in the previous paper, modulus, reaches the floor at 112 lines, so fold is genuinely slower to fill than modulus at the same line count. This run adds no modulus leg at 17 or 18, since modulus already reached the floor everywhere it was run and the question here was fold's own plateau.

## Confidence and horizon

- **Confidence:** high that fold reaches the floor on all 24 seeds at 17 and 18 sets in this model. Medium that the 121-to-128 threshold would survive a different stencil. Low that it says anything about a physical cache.
- **Horizon:** the claim holds for this scratch model until a second stencil or a hardware counter says otherwise.

## Next door

A run at 31 sets of 4 ways (124 lines), with its falsifier named first, would place the threshold more finely: if fold misses at 124 lines on any seed, the threshold sits above 124, and the reading narrows to the upper half of its interval. That run is a Diffuser lap of its own, and it stays in the lane.

Hand to Bakery: nothing in this paper is buildable as a module. The result is a model fact. Bakery's own cache work, if it wants this threshold as an input, should cite the 128-line figure and this run's plateau, and should not treat the 0.0025 floor as a hardware number.
