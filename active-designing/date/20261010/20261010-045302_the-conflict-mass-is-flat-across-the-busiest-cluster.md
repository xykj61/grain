# The conflict mass does not separate the busiest-6-to-7 cluster either, so the cluster's spread has another cause

**Status:** Design -- scratch-model reading; the literal falsifier did not fire, but the measure carries almost no signal inside the cluster, which the paper names as the reading
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the ordering paper [`20261010-044925`](20261010-044925_the-ordering-holds-across-fourteen-index-functions-with-a-random-null.md), whose next door asked for a finer collision measure inside the busiest-6-to-7 cluster, with its falsifier written before the run.
**Script:** `session-output/diffuser-stencil-r3/run_r3_conflict_mass_127x1.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_conflict_mass_127x1_24.txt`. The per-seed miss rates come from the ordering run's output, `run_256_r3_ordering_127x1_24.txt`.

## Observation

**Scope:** 256 by 256 grid, radius-three diamond (25 points), row-major traversal, 16 cache lines per row. Cache of 127 sets by 1 way, fully counted LRU. Twenty-four seeds, the same as the ordering paper. Compulsory floor 0.0025.

**The measure.** For each radius-three window, 112 lines in all, conflict mass is the number of lines in the window minus the number of distinct sets they occupy. That equals the sum over occupied sets of (count minus one). The reading for a seed is the maximum over rows. This is the excess the busiest-window count only saw as a single peak.

**Falsifier, written before the run** (clock read `20261010.045302`, written in the script header): over the cluster, the Kendall tau-b between each family's mean conflict mass and its mean row-major miss rate. If tau-b is zero or below, conflict mass does not order the misses inside the cluster, the count is the wrong instrument for that range, and the spread has another cause. A random balanced null must read a positive mass on every seed. The modulus and shuffled-modulus controls must read zero on every seed.

**The cluster was defined before the run, from the ordering output.** Families with a mean busiest-window count from 6.0 to 7.0 are seven: mix, fmix32_alt, oat, splitmix64_low, fmix64_low, random_balanced and random_unbalanced. The ordering paper counted eight. The eighth would be xorshift32 at 5.88, which sits below the rule. This paper keeps the rule and not the earlier count.

| Family (cluster) | Mean conflict mass | Min to max | Mean row-major miss |
|---|---|---|---|
| mix | 46.88 | 44 to 51 | 0.0277 |
| oat | 46.50 | 44 to 49 | 0.0281 |
| splitmix64_low | 46.50 | 44 to 51 | 0.0280 |
| fmix64_low | 46.50 | 44 to 50 | 0.0280 |
| fmix32_alt | 46.50 | 44 to 50 | 0.0278 |
| random_balanced (null A) | 46.50 | 43 to 51 | 0.0274 |
| random_unbalanced (null B) | 46.54 | 44 to 49 | 0.0281 |

The controls read zero on every seed. The random balanced null reads a positive mass on every seed, with a mean of 46.50, so the measure is not broken.

## Inference

**The literal falsifier did not fire.** Kendall tau-b across the seven families is **+0.07**, with 6 concordant pairs, 5 discordant, and 10 pairs tied on mean mass. The miss rates had no ties.

**That +0.07 is not evidence of ordering.** Five of the seven families sit at exactly 46.50 on the mean mass. Ten of the twenty-one pairs tie on the mass, so the coefficient is decided by eleven pairs, six of them agreeing. Seven items with that many ties cannot carry a sign. The honest reading is that the coefficient is near zero, and the ordering falsifier's threshold of zero was a sign test the data cannot resolve.

**The mass saturates where the busiest count did.** The busiest-window count was flat across the cluster because one peak clustered near 6 and 7. The conflict mass is flat for a different reason: the random-placement families all reach the same mean of 46.50. Placement sets the mass, and the hashes match the random balanced map on it. The finer measure confirms the earlier paper's separation between placement-driven families and the low-conflict ones, and nothing finer than that.

**So the cluster's spread has another cause, and this paper does not name it.** The miss rates in the cluster span 0.0274 to 0.0281, a band of about 2.5 percent of their mean. Conflict mass is flat across the same families, to within one or two lines of its window total. Whatever moves the miss rate by those few parts in a hundred is not a per-window collision count, under one way, at this layout.

## Projection, with its falsifier

Horizon: the next scratch run, not a hardware claim.

Assumption: misses in a fully counted LRU set depend on the order lines return within a set, not only on how many lines share a window. A per-window count cannot see that order, so it cannot separate families whose counts agree.

Falsifier, written now and not yet run: over the seven cluster families, a per-set reuse-distance measure taken across the whole traversal, not one window, must order the misses with a tau-b above 0.5 on 24 seeds. If it does not, the spread is noise at this scale and no measure among these will separate the cluster.

Confidence: high on the observation (24 seeds per family, all three controls at zero, the null reading positive), low on the projection, because the reuse-distance measure is itself untested.

## What this does not reach

The scratch model is an LRU simulation with no hardware behind it. The calibration paper already shows the generic miss counter reads a fraction of the fills on this guest. Nothing here is a claim about a real cache.

The cluster has seven families, and their miss rates overlap almost entirely. A tau-b on seven items with ten ties is a weak statistic and this paper claims no significance. The +0.07 is reported in full as a fact about this sample, and it is not presented as confirmation of either branch.
