# The busiest set at 126 lines: fold overflows by one, mix and fib by eight or more

**Seated:** `20261010.042111` -- **Status:** Living -- **Room:** vision (scratch model only, no witness binds it; `context/TWO_ROOMS.md`)
**Lineage:** the fully associative paper [`20261010-041547`](20261010-041547_the-fully-associative-floor-reaches-at-one-hundred-twelve-lines.md), which named this as its first next door, and the three 126-line papers beneath it.
**Scope:** a scratch model, one radius-three stencil, one row-major visit order, one LRU policy, 256 by 256 grid, 16 elements per line. No hardware is claimed.

## Summary

The 126-line miss has been read as an index effect since `20261010.041547`. The fully associative run showed that capacity alone reaches the floor at 112 lines, so the conflict in a set-associative layout is the remaining suspect. This paper measures the first thing that suspicion predicts: how many distinct lines the busiest set holds within one row band. The busiest set holds 7 lines for fold on 23 of 24 seeds, and 13 to 17 for mix and fib. The falsifier did not fire. The fold reading is marginal, and the mix and fib readings are strong.

## The falsifier, written before the run

The falsifier was written into the script header after the clock read `20261010.042055` and before the run. The script is `session-output/diffuser-stencil-r3/run_r3_occupancy_21x6.py`, scratch and untracked.

For each row `r`, the radius-three diamond touches rows `r-3` through `r+3`. At 16 lines per row, that window is 112 consecutive lines, fewer at the grid edge. The measure counts distinct lines per set within that window, and takes the maximum over all `r`.

- **The conflict inference predicts** that the busiest set holds well above six lines per window for fold, mix and fib.
- **The falsifier:** if the busiest set holds no more than six lines per window for every family on every seed, the conflict inference is wrong, and the 126 miss has another cause.
- **Control:** the modulus index, `line % 21`, maps 112 consecutive lines to exactly 6 per set by construction. It is the reference the threshold is drawn against, not a test of the falsifier.

## Observation

24 SplitMix64 seeds (stream 20261010), 21 sets, 6 ways, 126 lines. Output in `session-output/diffuser-stencil-r3/run_256_r3_occupancy_21x6_24.txt`.

| Family | Busiest set, max over seeds | Mean over seeds | Seeds above six |
|---|---|---|---|
| fold | 7 | 6.96 | 23 of 24 |
| mix | 17 | 14.62 | 24 of 24 |
| fib | 15 | 13.42 | 24 of 24 |
| modulus (control) | 6 | 6.00 | 0 of 24 |

The control reads exactly 6, so the measure is not inflating counts by construction. The three hash families read above it.

## Inference

**Mix and fib overload their busiest set well past six lines.** A set with six ways that must hold 13 to 17 lines of one row band cannot keep them resident. The earlier miss rates for these families (0.0084 to 0.0089 for mix, 0.0065 to 0.0070 for fib) sit where that overload predicts.

**Fold's overload is marginal.** Seven lines in a six-way set is one line over capacity, on the busiest set only. That is weaker than the prior paper's word "well above six" allowed for. Fold's own miss rate (0.0029 to 0.0034) is also the smallest of the three, which fits a small overload more than a large one. Whether one line of overload alone accounts for fold's whole miss is not something this measure settles.

**The modulus control's exact six is the reason the threshold is useful.** Fold, mix and fib all sit above the value a conflict-free layout achieves on a contiguous window. That is the reading the conflict inference needed, and it holds for two of the three families strongly.

## The falsifier, read against the result

The falsifier did not fire. It required every family on every seed to read no more than six, and fold reads seven on 23 of 24 seeds. The one seed at six does not meet the falsifier's condition, which asks for all seeds, all families.

The result is therefore a partial confirmation. The conflict inference survives for mix and fib by a wide margin. For fold it survives only at the one-line margin.

## What would falsify the conflict inference further

- **The inference fails for fold** if the busiest-set reading is recomputed with the true live set under LRU, rather than the window's distinct-line count, and that live set holds six or fewer lines for every seed. The window is an upper bound on the live set, not the live set itself. This paper did not run that check.
- **The inference fails for mix and fib** if a per-set count under a non-contiguous visit order, such as a column sweep, shows the same overload. That would make the overload a property of the stencil's shape, not of the row-major order.

## Confidence

- **High** that the busiest set exceeds six lines for mix and fib on this model: the margin is eight or more lines, and the measure is deterministic per seed.
- **Medium** that fold's one-line overload reflects the same mechanism. It is the only reading that fits fold's sign, but its size is at the edge of what the window bound can resolve.
- **Low** on any claim about a hardware set-associative cache, which may differ in index function, replacement policy, and line size.

## Next door

The first next door from `20261010.041547` is done here. Its second is the 127-line layout, named plainly, with its falsifier written before the run:

1. **The 127-line layout.** No power-of-two split of 127 exists, so the layout must be chosen and printed before the run. The falsifier will be written first, in that run's header, with the choice named. Falsifier: fold, mix and fib at 127 lines under the named layout all reach the floor for every seed, or all miss for every seed. Any mix is reported, not moved.

A follow-up before any sweep: recompute the busiest set using the live LRU set rather than the window count, so fold's one-line reading can be tested directly. That needs its own falsifier, written in the same way.

## What this does not claim

No hardware, no energy figure, and no ship's cache. The result belongs to a model with one stencil, one visit order, and one replacement policy. Nothing here reaches Caravan, Aurora, Tally, or Mantra. BAKERY would need a real cache trace before building anything from this.

Projection, for this model only: a layout that spreads the contiguous window evenly across its sets should reach the floor at lower line counts than the 21-by-6 layout does. That is the same projection the fully associative paper drew, now with a measured overload behind it for two of three families.
