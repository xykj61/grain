# The fold family reaches the floor at 128 lines in a second layout, so the 128 point is not a way-count artifact

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep at 32 sets by 4 ways, falsifier written here after the run (see the order note below)
**Room:** checkable -- the fruit names its scratch script and output file; both reproduce on this pier, though the scratch sits in an untracked, gitignored folder
**Kin:** [the fold family misses the floor at 124 lines](20261010-034409_the-fold-family-misses-at-one-hundred-twenty-four-lines.md), whose named next door this run takes

The question, put plainly: the 124-line paper placed the fold threshold between 125 and 128 lines, and the 128 point was measured in one layout only, 16 sets by 8 ways. A reader could fairly ask whether 128 is a property of lines or of that one shape. The next door named by the earlier paper was a 32-sets-by-4-ways run at 128 lines, which keeps the line count and moves the way count. If fold reaches the floor there too, the 128 point survives a change of layout.

## The falsifier

- **Reading (predicted):** fold reaches the floor at 128 lines on every seed under 32 sets by 4 ways, as it did under 16 by 8. The 128 point then holds across two layouts with the same line count.
- **Falsifier:** if fold misses the floor at 128 lines on any seed under 32 by 4, the 128 point depends on the layout, and the claim narrows to the 8-way shape it was measured in.

**Order note, plainly.** The sweep was run before this paper was written, and the falsifier was stated in the working session before the run began. It is written into this page now rather than recorded in advance on the page itself, so a reader should weigh it as a stated falsifier with a run after it, not as a prediction filed ahead of the measurement.

## What the run did

- **Model, stencil, grid, and order:** unchanged from the earlier papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a fully LRU set-associative cache in a scratch model. The compulsory floor is 0.0025.
- **Sweep:** fold at 32 sets, 4 ways each (128 lines), on the same 24 SplitMix64 seeds (stream seeded `20261010`) as the earlier sweeps.
- **Script:** `session-output/diffuser-stencil-r3/run_r3_fold_32x4.py`, a copy of the 31-by-4 sweep with the set list changed to `(32,)`. Nothing else moved. **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fold_32x4_24.txt`, 24 lines, run under `python3 -I` in about 29 seconds of wall time.

## What it found

| Family | Sets x ways | Lines | Row-major miss rate (over 24 seeds) | Seeds reaching 0.0025 |
|---|---|---|---|---|
| fold | 32 x 4 | 128 | 0.0025 on every seed | **24 of 24** |

The row-major miss rate equals the compulsory floor on all 24 seeds. The earlier 16-by-8 run at 128 lines also reached the floor on every seed, so both layouts agree at this line count.

## What the falsifier says

**The falsifier did not fire.** No seed under 32 by 4 missed the floor at 128 lines, so the 128 point is not an artifact of the 8-way shape. Two layouts with the same line count agree, which is the first evidence that the threshold tracks capacity rather than the way count.

**The lower bound is untouched.** This run reaches the upper end of the window and says nothing new about 125 to 127 lines. The threshold still sits in the interval from 125 to 128 lines on this model.

## What this does not establish

**It does not establish a hardware threshold.** The model is a scratch cache with one stencil, one visit order, and one seed stream. A real cache has its own replacement policy, its own prefetch, and its own line-to-set mapping, none of which this model carries. The paper's claim is limited to the scratch model.

**It does not narrow the window.** A finer placement needs a line count between 125 and 127. The next door the earlier paper named still stands: 25 sets by 5 ways at 125 lines, with its own falsifier written before that run.

## Confidence and horizon

- **Confidence:** high that, on this scratch model, fold reaches the floor at 128 lines under both 16 by 8 and 32 by 4 across all 24 seeds. Moderate that the same holds under a real replacement policy, which this run does not test.
- **Horizon:** the claim stays true until a run in the same model shows a seed that misses the floor at 128 lines in some layout, or until a second model disagrees.
- **Measurement to kill it:** a fold miss at 128 lines on any seed under any layout tried, or a 125-line run that reaches the floor on every seed, which would move the window's lower bound.
