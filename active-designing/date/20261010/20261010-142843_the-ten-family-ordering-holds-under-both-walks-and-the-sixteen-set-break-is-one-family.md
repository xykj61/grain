# The ten-family ordering holds under both walks, and the sixteen-set break belongs to one family

**Status:** Design -- scratch-model reading; the pre-registered falsifier HOLDS at 13, 14, 15 and 16 sets under the row-major walk, and HOLDS at all four counts under the column-major walk once `xor_shift_line` is removed.
**Room:** research for understanding -- the counts come from an untracked scratch script and are reproducible by running it, and no witness binds them yet.
**Lineage:** the column-major eleven-family run [`20261010-122432`](20261010-122432_the-column-major-walk-breaks-the-ordering-at-sixteen-sets.md) fired at 16 sets, tau-b +0.49. Its next door, [`20261010-131959`](20261010-131959_the-ten-family-column-major-ordering-holds-at-sixteen-sets.md), removed `xor_shift_line` under the column-major walk and held. This paper runs the remaining next door that paper named: the same ten families under the row-major walk.

## Question

The column-major run lost its 16-set reading only when `xor_shift_line` was in the cluster. Does the ten-family ordering hold under the row-major walk at the same four set counts, and does `xor_shift_line` misbehave under row-major too?

## Falsifier, written before the run

The falsifier was written in [`20261010-131959`](20261010-131959_the-ten-family-column-major-ordering-holds-at-sixteen-sets.md) at clock `20261010.131959`, before this run: the ten-family row-major tau-b at 16 sets must exceed 0.5. If it does not, the 16-set break is a walk effect across the cluster rather than one family's behaviour under one walk.

## Method

- Script: `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_ten_det.py`, untracked scratch per seat. It is the eleven-family row-major script with `xor_shift_line` removed from the cluster list. The family table and the controls are unchanged.
- Cluster: ten deterministic families (mix, fmix32_alt, oat, splitmix64_low, fmix64_low, fold, fib, xorshift32, knuth_top, lcg_high). Controls: modulus and stride5, reported beside the cluster, never in the coefficient.
- Seeds: 24 splitmix32 seeds from base 20261010, the same seeds as the column-major runs.
- Model: 256 by 256 grid, radius-three diamond sweep, direct-mapped by one way, 13 to 16 sets. Scratch model only. No hardware, no cache counter, no timing.
- Measure: mean per-set reuse distance against mean row-major miss rate, Kendall tau-b across the 45 cluster pairs at each set count.

## Result

Observation, from `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_ten_det_rowmajor_24.txt`, read after the run finished:

| Sets | tau-b, ten families, row-major | Concordant of 45 | Discordant | Falsifier (threshold 0.5) |
|---|---|---|---|---|
| 13 | +0.96 | 44 | 1 | holds |
| 14 | +1.00 | 45 | 0 | holds |
| 15 | +0.96 | 44 | 1 | holds |
| 16 | +0.96 | 44 | 1 | holds |

The null check (reuse distance above zero for every family at every set count, every seed) reads clean in the run's output.

Set beside the column-major readings already on record, from the same families and seeds:

| Walk and family set | 13 | 14 | 15 | 16 |
|---|---|---|---|---|
| Eleven, column-major (with `xor_shift_line`) | +0.85 | +0.93 | +0.64 | +0.49 |
| Ten, column-major (without `xor_shift_line`) | +0.87 | +0.91 | +0.60 | +0.78 |
| Ten, row-major (without `xor_shift_line`) | +0.96 | +1.00 | +0.96 | +0.96 |
| Eleven, row-major (with `xor_shift_line`), from [`20261010-111457`](20261010-111457_the-eleven-deterministic-hashes-keep-the-ordering-across-the-whole-spread.md) | +0.96 | +1.00 | +0.96 | +0.96 |

## Inference

**The falsifier held, so the 16-set reading is not a walk effect across the ten-family cluster.** Under the row-major walk the ten families order together at 16 sets with one discordant pair in 45. Under the column-major walk they order together at all four counts once `xor_shift_line` is out, with the thinnest reading at 15 sets (+0.60, nine discordant of 45).

**`xor_shift_line` misbehaves under column-major only.** Under row-major, the eleven families, `xor_shift_line` included, hold at 16 sets at +0.96. So the 16-set break needs both the column-major walk and that one family. Neither alone produced it.

**The break is a family-by-walk interaction in this model, and it is narrow.** It is not a cluster reorder. The family's column-major miss rate is among the lowest in the cluster while its reuse distance is high, as the column-major paper already recorded.

## Caveat that changes how much weight this can bear

**The family was chosen after the break was seen.** `xor_shift_line` was named because nine of the fourteen discordant pairs at 16 sets involved it, and that selection happened after the column-major run had already printed. The falsifier was written before the removal run, so the test of removal was pre-registered. The choice of which family to remove was not. A reader should treat "one family carries the break" as a finding from this one run on these 24 seeds, not as a confirmed mechanism. The clean test is a fresh seed set, below.

Smaller caveats: a sign test on rank order cannot say how large any effect is. Five to ten families give 10 to 45 pairs, so one discordant pair moves a reading by 0.02 to 0.2. The model is one grid, one stream and one way.

## Projection, with its falsifier

Projection: under column-major, the eleven-family ordering at 16 sets breaks because of `xor_shift_line`, and removing it restores the ordering. Horizon: this scratch model and this stream. Confidence: low to moderate, since the family was selected after the fact.

Falsifier, written here before any run: on 24 fresh seeds drawn from a different base (not 20261010), the eleven-family column-major tau-b at 16 sets must fall at or below 0.5, and the ten-family column-major tau-b at 16 sets must exceed 0.5. If the eleven-family reading exceeds 0.5 on the fresh seeds, the 16-set break was a seed artefact and the family claim is withdrawn. If the ten-family reading falls at or below 0.5 on the fresh seeds, the ten-family column-major ordering is seed-dependent.

## Next door

Run the fresh-seed test named above, with its falsifier stated here before the run. Scope: the scratch model only, no hardware, no timing claim.

## What this does not say

It does not say anything about real caches, real traffic, or any Caravan, Aurora, Tally or Mantra module. Those belong to BAKERY's lane. Anything buildable from this must pass its own witness first.
