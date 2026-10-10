# The ten-family column-major ordering holds at sixteen sets, so the break was one family

**Status:** Design -- scratch-model reading; the pre-registered falsifier HOLDS at 13, 14, 15 and 16 sets once `xor_shift_line` is removed.
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** [`20261010-122432`](20261010-122432_the-column-major-walk-breaks-the-ordering-at-sixteen-sets.md), whose next door was this run, with its falsifier stated before the run.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_ten_det_colmajor.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_ten_det_colmajor_24.txt`. The script is the eleven-family column-major script with `xor_shift_line` removed from the cluster and the family table, nothing else changed.

## What this paper asks

The eleven-family column-major run fired at 16 sets, tau-b +0.49. Nine of its fourteen discordant pairs at 16 sets involved one family, `xor_shift_line`. This run asks whether that one family carries the break.

## Falsifier, stated before the run

Taken from the column-major paper, written before this run: with `xor_shift_line` removed, the ten-family column-major tau-b at 16 sets must exceed 0.5. If it stays at or below 0.5, the break is not carried by that family, and the 16-set reading is a wider effect across the cluster.

## Observation

Tau-b between mean per-set reuse distance and mean column-major miss rate over the ten cluster families, 24 seeds, column-major walk:

| Sets | tau-b | Concordant of 45 | Discordant | Falsifier (threshold 0.5) |
|---|---|---|---|---|
| 13 | +0.87 | 42 | 3 | holds |
| 14 | +0.91 | 43 | 2 | holds |
| 15 | +0.60 | 36 | 9 | holds |
| 16 | +0.78 | 40 | 5 | holds |

The null check passed: reuse distance was above zero on every seed for every cluster family at every set count. The controls, modulus and stride5, read identical means and sit outside the cluster, as before.

## Inference

At 16 sets the break in the eleven-family run was carried mostly by `xor_shift_line`. Removing it lifts tau-b from +0.49 to +0.78. The 10 remaining families still order together under the column-major walk at all four counts.

## What this does not say

- **The 15-set reading falls.** It goes from +0.64 with eleven families to +0.60 with ten, with nine discordant pairs of 45. The sign holds; the margin over 0.5 is small.
- **The fold family carries much of the spread.** Its mean reuse distance is 2.13 at 16 sets, against about 1.24 to 1.35 for the others, and its miss rate is 0.31 against about 0.10 to 0.14. A rank coefficient counts it as one pair per comparison, so the result is robust to its magnitude, but a reader should not take the ordering as evidence about the other nine families' spread.
- **The 13- and 14-set readings moved by 0.02 and the 16-set reading by 0.31.** The 16-set change is the one that matters here; the others barely moved.
- **Confidence:** moderate that the 13-to-16-set sign holds for this set of families in this model; low that it generalises to real hardware or a different walk.

## Scope

The scratch model only, with 24 splitmix32 seeds and 256-by-256 grid, direct-mapped by one way. No hardware, no timing, no real cache. The falsifier is a sign test on rank order, so it cannot say how large an effect is.

## Next door, with its falsifier written before the run

Run the same ten families under a row-major walk at 13 to 16 sets to see whether the 16-set reading is a walk effect or a family effect. Falsifier, written here before any run: the ten-family row-major tau-b at 16 sets must also exceed 0.5. If it does not, the 16-set column-major break is walk-specific and the row-major claim narrows.
