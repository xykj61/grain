# The fully associative floor reaches at 112 lines, so the 126 miss is an index effect

**Seated:** `20261010.041547` -- **Status:** Living -- **Room:** vision (scratch model only, no witness binds it; `context/TWO_ROOMS.md`)
**Lineage:** the three 126-line papers -- [fold](20261010-040037_the-fold-family-misses-at-one-hundred-twenty-six-lines.md), [mix](20261010-040441_the-mix-family-misses-at-one-hundred-twenty-six-lines.md), [fib](20261010-041124_the-fib-family-also-misses-at-one-hundred-twenty-six-lines.md) -- and the radius-three paper [`20261010-014349`](20261010-014349_the-radius-three-stencil-moves-the-boundary-to-seven-bands.md)
**Scope:** a scratch model, one stencil, one visit order, one LRU policy. No hardware is claimed.

## Summary

The three index families all miss the compulsory floor at 126 lines under a 21-set, 6-way layout. The prior papers read that miss as a capacity property of the model, and the next door named a 127-line run. This paper runs a fully associative version of the same model at 120 to 127 lines and at 48 to 112 lines. Fully associative has no index, so it tests capacity alone. It reaches the floor at every line count from 112 up to 127, and it misses at 104 and below. The capacity reading therefore fails for this model: the 126 miss comes from how lines are assigned to sets, not from the number of lines.

## What was run, and the falsifier written first

The falsifier was written into the script header after the clock read `20261010.041501` and before the 127-line run. The script is `session-output/diffuser-stencil-r3/run_r3_fa_127.py`, scratch and untracked. Its core loop is the `run()` function of `run_r3_mix.py`: a 25-point radius-three diamond, row-major visit order over a 256 grid, 16 elements per line, and an LRU cache of lines.

The falsifier said two things about 127 lines:

- *row-major reaches the compulsory floor at 127 lines*, which would put the 126 point under a layout artifact.
- *row-major misses the floor at 127 lines*, which would hold the window at 127 to 128.

The layout was not settled by the pre-registration. The prior paper said that no power-of-two split of 127 exists. This paper took the fully associative layout, one set by 127 ways, so that no index function is involved. That choice means the falsifier was tested on a different question from the one its three-family wording named, and the result below should be read with that in mind.

## Observation

Each row is one deterministic run, with no seed. The compulsory floor is the count of distinct lines divided by accesses, 0.0025.

| Lines (fully associative, 1 set) | Row-major rate | Compulsory | Reaches floor |
|---|---|---|---|
| 48 | 0.0175 | 0.0025 | no |
| 64 | 0.0175 | 0.0025 | no |
| 80 | 0.0174 | 0.0025 | no |
| 96 | 0.0173 | 0.0025 | no |
| 104 | 0.0173 | 0.0025 | no |
| 112 | 0.0025 | 0.0025 | yes |
| 120 | 0.0025 | 0.0025 | yes |
| 124 | 0.0025 | 0.0025 | yes |
| 125 | 0.0025 | 0.0025 | yes |
| 126 | 0.0025 | 0.0025 | yes |
| 127 | 0.0025 | 0.0025 | yes |

The threshold sits between 105 and 112 lines, since 104 misses and 112 reaches. The lines between 105 and 111 were not run.

For comparison, the same grid under a 21-set, 6-way layout at 126 lines, 24 seeds each, misses the floor for every seed: fold reads 0.0029 to 0.0034, mix 0.0084 to 0.0089, and fib 0.0065 to 0.0070 (from the three 126-line papers and the fib output file, `session-output/diffuser-stencil-r3/run_256_r3_fib_21x6_24.txt`).

## Inference

**Observation, one sentence:** under full associativity, row-major reaches the compulsory floor at every size from 112 to 127 lines.

**Inference, one sentence:** the 126 miss under 21 sets by 6 ways is a conflict effect of the set assignment, because the same line count with no set assignment has no miss at all.

**Inference, a second sentence:** the set-associative floor depends on the layout, not only on the total line count. The fold family at 16 sets by 8 ways reaches the floor at 128 lines for all 24 seeds (the 16-set run in the set-count paper), while the same fold family at 21 sets by 6 ways misses at 126. Two layouts at 126 and 128 lines disagree, and a pure capacity threshold cannot make that happen.

**Projection, for this model only:** the window the prior papers drew from 125 to 128 lines is a property of the set layouts they tried, not of the cache's size. A layout chosen to avoid conflicts should reach the floor at lower line counts than the 21-by-6 layout does.

## The falsifier, read against the result

The falsifier's first branch, "row-major reaches the floor at 127," is met. The paper's second sentence was not tested in the form written: the three families were not run at 127 lines under any set layout, and the fully associative run tests a different question. So the honest reading is partial. The falsifier fired on the capacity side, and the capacity reading the prior paper drew from 126 falls for this model. Whether the 127-line point misses under the real index families has not been run, and the next door below names that test.

## What would falsify the conflict inference

- **The inference fails** if a set-associative layout at 126 or 127 lines reaches the floor for all 24 seeds under every family. The earlier runs already show that the 16-by-8 layout at 128 reaches for fold, so that case is partly in hand. A full count across layouts at 126 has not been run.
- **The inference fails** if fully associative at 112 lines misses under a different visit order. Only row-major was run, so the reach at 112 is for row-major alone.
- **A direct test** would count, for each set, how many distinct lines the stencil touches over one sweep. A 21-by-6 layout whose busiest set holds well above six lines per row band would show the conflict directly. That count has not been taken.

## Confidence

- **High** on the arithmetic for this model: the runs are deterministic, the compulsory floor matches every prior paper, and the fully associative result reproduces the 112-line floor that the radius-three paper already reported.
- **Medium** on the conflict attribution: it is the only reading that fits a layout-dependent floor, but no per-set occupancy has been measured.
- **Low** on any claim about hardware or about a real stencil. The model has one visit order and one replacement policy, and a hardware set-associative cache could differ in both.

## Next door

Two runs, in order, each with its falsifier written before the run.

1. **Set occupancy at 21 by 6.** Count the busiest set's distinct lines per row band for fold, mix and fib at 126 lines. Falsifier: if the busiest set holds no more than six lines per band for every family, the conflict inference is wrong and the miss has another cause.
2. **The 127-line layout, honestly named.** No power-of-two split exists, so the layout must be chosen before the run and the choice printed. Falsifier, written first: fold, mix and fib at 127 lines under the named layout all reach the floor for every seed, or all miss for every seed. Any mix is reported, not moved.

Neither needs a word from Keaton. Both stay inside the scratch model.

## What this does not claim

No hardware, no energy figure, and no ship's cache. The result belongs to a model with one stencil, one visit order, and one replacement policy, and nothing here reaches Caravan, Aurora, Tally, or Mantra directly. Anything for BAKERY to build from it would need a real cache trace first.
