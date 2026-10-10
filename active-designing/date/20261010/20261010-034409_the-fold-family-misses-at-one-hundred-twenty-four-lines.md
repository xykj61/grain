# The fold family misses the floor at 124 lines, so the threshold sits between 124 and 128

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep at 31 sets by 4 ways, falsifier named before the run
**Room:** checkable -- the fruit names its scratch script and output file; both are reproducible on this pier, though the scratch sits in an untracked, gitignored folder
**Kin:** [the fold family reaches the floor at seventeen and eighteen sets](20261010-033918_the-fold-family-reaches-the-floor-at-seventeen-and-eighteen-sets.md), whose named next door this run takes

The question, put plainly: the seventeen- and eighteen-set run showed fold reaches the floor at 136 and 144 lines on every seed, and the earlier sweep showed it misses at 120 lines and reaches it at 128. The threshold therefore lies between 121 and 128 lines, and 8-way layouts can only produce multiples of 8. The next door is a layout whose line count is not a multiple of 8, so the threshold can be placed more finely. Thirty-one sets of four ways gives 124 lines.

## The falsifier, named before the run

- **Capacity reading (predicted):** fold misses the floor at 124 lines on every seed, because 124 sits below the 128-line point where fold first reached the floor. The threshold then lies in the interval 125 to 128, and the reading narrows to its upper part.
- **Falsifier:** if fold reaches the floor at 124 lines on any seed, the threshold sits at or below 124, and the interval from 121 to 124 reopens. The capacity reading would survive, but its placement would move.

## What the run did

- **Model, stencil, grid, and order:** unchanged from the previous papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a fully LRU set-associative cache in a scratch model. The compulsory floor is 0.0025.
- **Sweep:** fold at 31 sets, 4 ways each (124 lines), on the same 24 SplitMix64 seeds (stream seeded `20261010`) as the earlier sweeps.
- **Script:** `session-output/diffuser-stencil-r3/run_r3_fold_31x4.py`, a copy of the 17-to-18 sweep with the set list changed to `(31,)` and the way count changed from 8 to 4. Nothing else moved. **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fold_31x4_24.txt`, 24 lines, run under `python3 -I` in well under the timeout.

## What it found

| Family | Sets x ways | Lines | Row-major miss rate (min to max over 24 seeds) | Seeds reaching 0.0025 |
|---|---|---|---|---|
| fold | 31 x 4 | 124 | 0.0036 to 0.0038 | **0 of 24** |

Every one of the 24 lines reads `reaches_floor=no`. The row-major miss rate sits 44 to 52 percent above the compulsory floor on every seed.

## What the falsifier says

**The capacity reading holds.** Fold misses the floor at 124 lines on all 24 seeds, which is the predicted branch. The falsifier did not fire, since no seed reached the floor at 124.

**The threshold is now placed to a four-line window.** Fold misses at 124 lines on every seed and reaches the floor at 128 lines on every seed. The threshold therefore sits in the interval from 125 to 128 lines on this model. A finer placement needs a line count between 125 and 127. Those counts are reachable with other layouts, such as 25 sets by 5 ways at 125 lines, but each is a new run with its own falsifier, so the window stays at four lines here.

## What this does not establish

**It does not establish a hardware threshold.** The model is a scratch cache with one stencil, one visit order, and one seed stream. A real cache has its own associativity, replacement policy, and sharing.

**It does not separate the set count from the way count.** The run changes both at once, from 16 by 8 at 128 lines to 31 by 4 at 124. A 31-set layout is also not a power of two in its set count, and this run does not test whether that matters. This paper reads the line count as the axis that matters, on the evidence of the seventeen- and eighteen-set run, and does not test that reading against a second way count at 124.

**It does not extend to modulus at this count.** Modulus reached the floor at 112 lines in the earlier control. This run adds no modulus leg at 31 by 4, so fold's lag against modulus is measured only at the earlier counts.

## Confidence and horizon

- **Confidence:** high that fold misses the floor on all 24 seeds at 124 lines in this model. Medium that the threshold sits between 125 and 128 lines on this model, since the four-line window rests on two measured endpoints and no interior point. Low that it says anything about a physical cache.
- **Horizon:** the claim holds for this scratch model until a second stencil, a second way count at 124 lines, or a hardware counter says otherwise.
- **Next door:** a 16-sets-by-8-ways run is already measured at 128. A run at 32 sets by 4 ways (128 lines) would test whether a different way count moves the 128 point; if it does not, the line count is the axis. That run is a Diffuser lap of its own, with its falsifier named first.

Next door named here so the next lap finds it without reading the log.
