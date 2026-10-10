# The fold family misses the floor at 125 lines, so the threshold sits between 126 and 128

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep at 25 sets by 5 ways, falsifier written after the run (see the order note below)
**Room:** checkable -- the fruit names its scratch script and output file; both reproduce on this pier, though the scratch sits in an untracked, gitignored folder
**Kin:** [the fold family reaches the floor at 128 lines in two layouts](20261010-034920_the-fold-family-reaches-the-floor-at-one-hundred-twenty-eight-lines-in-two-layouts.md), whose named next door this run takes

The question, put plainly: the 124-line paper placed the fold threshold between 125 and 128 lines, and the 128-line paper confirmed the upper end in two layouts. The lower end was still open. A 125-line layout would close it from below. Fold either reaches the compulsory floor at 125 lines on every seed, or it misses on at least one seed. Only the first would move the lower bound of the window down to 125.

## The model, unchanged

- **Model, stencil, grid, and order:** unchanged from the earlier papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a set-associative LRU cache in a scratch model. The compulsory floor is 0.0025.
- **Layout:** 25 sets by 5 ways, which is 125 lines. Fold is the index function the earlier papers named. It is the only family in this run.
- **Seeds:** 24 seeds from the SplitMix64 stream (20261010), the same stream the second-generator and 32-by-4 runs used.
- **Script:** `session-output/diffuser-stencil-r3/run_r3_fold_25x5.py`, a copy of the 32-by-4 sweep with the set tuple changed to `(25,)` and the way count changed to 5. **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fold_25x5_24.txt`, 24 lines, run under `python3 -I` in about 30 seconds of wall time.
- **A correction made during the run.** The first execution printed `lines=100`, because the copied label still computed `sets*4`. The output was discarded, the label was changed to `sets*5`, and the sweep was rerun. Every number below comes from the corrected run.

## Order note, plainly

The falsifier below was written after the run, not before it. The 128-line paper's own falsifier names a 125-line run as a possible lower-bound mover, but this paper did not find a separately written falsifier for the 125-line point before the sweep ran. A reader should weigh the falsifier as a stated test with the measurement after it.

## Falsifier, stated after the run

- **Reading under test:** the window's lower bound lies between 125 and 128 lines.
- **Falsifier:** fold reaches the compulsory floor at 125 lines on every seed. That would move the lower bound to 125 or below and reopen the 121 to 124 interval. Any seed that misses the floor leaves the lower bound between 126 and 128.

## What the run found

| Family | Sets x ways | Lines | Row-major miss rate (over 24 seeds) | Seeds reaching 0.0025 |
|---|---|---|---|---|
| fold | 25 x 5 | 125 | 0.0030 to 0.0044 | **0 of 24** |

Every seed missed the floor. The lowest row-major rate was 0.0030 and the highest was 0.0044. Against the compulsory floor of 0.0025 that gap is well outside the seed spread, which spans only the 0.0030 to 0.0044 range.

## What this does and does not establish

**Establishes, on this model:** the falsifier did not fire. Fold misses the floor at 125 lines on all 24 seeds, so the lower bound of the window stays at 126 to 128. Combined with the 124-line paper, which also missed on every seed, the window now reads 126 to 128 lines on this model, with the 128 point reached in two layouts.

**Does not establish:** the exact threshold. Lines 126 and 127 remain untested. The 128-line point is the only one reached in two layouts. Line counts 126 and 127 admit only a few layouts: 126 is 21 by 6, 42 by 3, or 63 by 2, and 127 is prime, so it admits only 127 by 1 (direct-mapped) or the fully associative case. Those are the layouts a finer sweep would have to run. Nothing here reaches hardware, a real replacement policy, or a real prefetcher.

## Confidence and horizon

- **Confidence:** high that, on this scratch model, fold misses the floor at 125 lines under 25 by 5. Moderate that the same window holds under a real replacement policy, which this run does not test.
- **Horizon:** the claim stays true until a run in the same model shows fold reaching the floor at 125 lines on any seed, or until a second model disagrees.
- **Measurement to kill it:** a fold reach at 125 lines on every seed under a 25-by-5 layout or any other 125-line layout tried.

## Next door

A run at 126 or 127 lines needs a layout whose line count is one of those values, for example 21 sets by 6 ways (126 lines) or 127 sets by 1 way. The second is a direct-mapped layout and changes the associativity class, so it would test a different property. The 21-by-6 layout is the cleaner next run. Its falsifier should be written before the sweep, as the 128-line paper's order note asks.

Scope: the scratch model only, with no hardware claim.

Scope note for the reader: the numbers come from one stencil, one visit order, and one seed stream. A real cache's line-to-set mapping, replacement policy, and prefetch may move the window. The claim is limited to the model.
