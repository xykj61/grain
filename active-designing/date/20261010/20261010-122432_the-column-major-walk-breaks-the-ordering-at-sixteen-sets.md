# The column-major walk breaks the ordering at sixteen sets, and one family carries the break

**Status:** Design -- scratch-model reading; the pre-registered falsifier FIRES at 16 sets and holds at 13, 14 and 15.
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the eleven-family row-major run [`20261010-111457`](20261010-111457_the-eleven-deterministic-hashes-keep-the-ordering-across-the-whole-spread.md), whose next door was this same eleven-family sweep under a column-major walk, with the falsifier written first.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_eleven_det_colmajor.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_eleven_det_colmajor_24.txt`.

## What this paper asks

The eleven-family row-major run found a between-family ordering: mean per-set reuse distance and mean row-major miss rate rank the families the same way, with tau-b between +0.96 and +1.00 at 13 to 16 sets. The open question was whether that ordering depends on the direction the stream walks. This paper runs the same eleven families, the same 24 seeds and the same four set counts, with only the walk changed from row-major to column-major.

## Falsifier, written before the run

The falsifier is in the script's header, stamped `20261010.112003`, before the script's run. For each set count S in {13, 14, 15, 16}, Kendall tau-b between the eleven deterministic families' mean per-set reuse distance under the column-major stream and their mean column-major miss rate must exceed 0.5. The falsifier fires if tau-b is at or below 0.5 at any of the four counts. Modulus and stride5 are reported beside the cluster and are never in the coefficient.

Read in plain words: if the ordering needs the row-major direction to exist, a column-major walk should lose it. If it holds at all four counts, the ordering does not depend on which way the walk runs.

## What was run

Eleven deterministic families, 1,248 jobs in all: 13 families (eleven plus the two controls) times four set counts times 24 seeds, under a column-major traversal of the radius-three diamond sweep over the 256 grid. Each set has one way, so the layout is 13, 14, 15 or 16 sets by 1 way. The null check reads zero cluster pairs at zero reuse distance, so the measure is live on every seed.

## Result

| Sets | tau-b (eleven families, column-major) | Concordant of 55 | Discordant | Falsifier |
|---|---|---|---|---|
| 13 | +0.85 | 51 | 4 | holds |
| 14 | +0.93 | 53 | 2 | holds |
| 15 | +0.64 | 45 | 10 | holds |
| 16 | **+0.49** | 41 | 14 | **fires** |

The falsifier fired at 16 sets, where tau-b is +0.49 and the threshold is above 0.5. The paper reports that fire as the result. The row-major run did not fire at any count, so the claim narrows: under this walk and at 16 sets, the between-family ordering is not established.

## Where the break sits

At 16 sets, the 14 discordant pairs are not spread evenly. One family, `xor_shift_line`, appears in 9 of them. It has the second-highest mean reuse distance in the cluster, at 1.675, yet a column-major miss rate of 0.0576, which is among the lowest. Every other cluster family sits near a miss rate of 0.10 to 0.14 at this count. Most of the other cluster families sit between 0.10 and 0.14 at this count, and fib, lcg_high and xorshift32 sit lower. So the ordering breaks mostly because one family's reuse distance and its miss rate disagree, not because the cluster reorders as a whole.

The remaining discordances are small. Mix, fmix32_alt, oat, splitmix64_low and fmix64_low differ by about 0.0016 in reuse distance and about 0.0001 to 0.0005 in miss rate. Those are ties in practice, so they count as discordant on the sign of very small gaps.

Two controls read apart from the cluster at 16 sets: modulus and stride5 carry a reuse distance of 14.56 and a miss rate of 0.323. They are excluded from the coefficient and sit at the top of both measures, as the design intends. Fold also reads high at this count, with reuse 2.13 and miss 0.313, and it stays concordant with the rest.

## What this does and does not establish

**Observation:** under a column-major walk, tau-b between reuse distance and miss rate across the eleven families is +0.85, +0.93, +0.64 and +0.49 at 13 to 16 sets. The falsifier fires at 16.

**Inference:** the row-major ordering from the earlier run was carried partly by the walk direction at 16 sets. Under column-major the reuse distance of `xor_shift_line` stops predicting its miss rate, and that single family accounts for most of the break.

**Projection, with its own falsifier:** the claim "the between-family ordering holds across a wide deterministic set" survives at 13, 14 and 15 sets under both walks, and does not survive at 16 sets under column-major. Confidence: moderate that the sign holds at 13 to 15 sets in this model; low that the 16-set break generalises, since it is one count, one walk and one model. The falsifier that would kill the 13 to 15 reading is tau-b at or below 0.5 under any walk or family set not yet tried.

## A correction the record needs

The script's header names an earlier six-family column-major run, `20261010.080118`, which also fired at 16 sets with tau-b +0.20. That run was not reported at the time. It is reported here in its own right, so the 16-set break is now two runs under column-major, both with the falsifier written before the run. The six-family run's tau-b is weaker than this eleven-family reading, and the difference is consistent with a wider set spreading the families further.

## Next door, with its falsifier written before the run

The next run removes `xor_shift_line` from the eleven and recomputes the coefficient under column-major at the same four set counts and 24 seeds.

Falsifier, written here before any run: with `xor_shift_line` removed, the ten-family column-major tau-b at 16 sets must exceed 0.5. If it stays at or below 0.5, the break is not carried by that one family, and the 16-set reading is a wider effect across the cluster rather than one outlier. This paper does not run that test; the falsifier stands for the next lap.

Scope: the scratch model only. No hardware is claimed, no cache is measured, and no traffic is claimed beyond the model's own access stream.
