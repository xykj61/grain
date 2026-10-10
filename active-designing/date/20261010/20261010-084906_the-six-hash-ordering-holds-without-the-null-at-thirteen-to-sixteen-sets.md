# The six-hash ordering holds without the random null at 13 to 16 sets, and the margin is thin

**Status:** Design -- scratch-model reading; the pre-registered falsifier did not fire at any of the four set counts, and the reading is thin (six families, 15 pairs, a sub-percent spread)
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the 13-to-16-set paper [`20261010-054823`](20261010-054823_the-reuse-ordering-holds-at-thirteen-to-sixteen-sets.md), whose next door was to drop random balanced and rerun tau-b over the six hash families, with the falsifier written before the run.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_six_hash_nonull.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_six_hash_nonull_24.txt`.

## Observation

**Scope:** 256 by 256 grid, radius-three diamond (25 points), row-major traversal, 16 cache lines per row, 4,096 distinct lines, 1,624,084 accesses. Cache of S sets by 1 way, S in {13, 14, 15, 16}. Twenty-four seeds, the same splitmix32 seeds as the lineage papers.

**The six families.** Mix, fmix32_alt, oat, splitmix64_low, fmix64_low, random_unbalanced. These are the seven-family cluster of `20261010-054823` with random_balanced removed, and nothing else changed. Random balanced is still computed and printed as a reference, and it does not enter the coefficient. Modulus and stride5 are controls and never enter it either.

**The statistic.** Unchanged from the lineage paper: mean per-set reuse distance over the whole row-major traversal, averaged over 24 seeds, against the row-major miss rate at the same set count and way count.

**Table, 24-seed means, six hash families.** Reuse distance is in distinct same-set lines per re-reference. Miss is row-major miss rate.

| Sets | Reuse distance, six-family band | Miss, six-family band | Tau-b, six families (reuse vs miss) |
|---|---|---|---|
| 13 | 0.2942 to 0.2954 | 0.1494 to 0.1503 | +0.60 (12 concordant, 3 discordant) |
| 14 | 0.2727 to 0.2745 | 0.1420 to 0.1431 | +0.87 (14 concordant, 1 discordant) |
| 15 | 0.2546 to 0.2573 | 0.1353 to 0.1365 | +0.87 (14 concordant, 1 discordant) |
| 16 | 0.2388 to 0.2406 | 0.1298 to 0.1306 | +0.87 (14 concordant, 1 discordant) |

No pair ties on either axis at any set count.

**The reference and the controls, 24-seed means.** Random balanced, held out of the coefficient, reads reuse 0.2943, 0.2729, 0.2558 and 0.2388 at 13, 14, 15 and 16 sets, with miss 0.1495, 0.1422, 0.1361 and 0.1299. Those sit inside the six-family band at every count, so the null is an ordinary member of the cluster and not an outlier. Modulus reads reuse 0.1289, 0.1049, 0.1897 and 1.7844, with miss 0.0315, 0.0175, 0.1021 and 0.3230. Stride5 reads 0.1289, 0.1049, 1.1013 and 1.7844, with miss 0.0315, 0.0175, 0.3223 and 0.3230. Both controls move away from the cluster as the set count changes, as the lineage paper recorded.

## Falsifier and result

**Falsifier, written at clock `20261010.080220` before the run, which started at `20261010.080231`:** at each set count S in {13, 14, 15, 16}, the Kendall tau-b between the six hash families' mean per-set reuse distance and their mean row-major miss rate must exceed 0.5. The falsifier fires if tau-b is at or below 0.5 at any of the four counts. The claim "the hash families alone order the misses across 13 to 16" needs all four.

**Result:** tau-b = +0.60, +0.87, +0.87 and +0.87. The falsifier did not fire. The threshold was met at 13 sets by 0.10, which is the narrowest margin in the sweep.

**The comparison against the seven-family run.** The seven-family coefficients were +0.71, +0.90, +0.81 and +0.81. Removing the null lowered the coefficient by 0.11 at 13 sets and by 0.03 at 14 sets, and raised it by 0.06 at each of 15 and 16 sets. The ordering is therefore not carried by the null's placement at any count: it survives the removal at all four, with the sign unchanged. The reduced family set orders the misses about as well as the full one, somewhat less well at 13 sets and marginally better at 15 and 16.

## Projection, with its falsifier

Horizon: the next scratch run at these set counts, not a hardware claim.

Assumption: on this model, the rank order among hash families follows the mean same-set reuse distance, and that order does not depend on the random balanced map being in the set.

Falsifier, unchanged from above: tau-b at or below 0.5 at any S in {13, 14, 15, 16} over the six hash families. It did not fire.

Confidence: high on the arithmetic, since the controls and the reference read their known structure and the tie check is clean. Moderate on the rank ordering at 14 to 16 sets. Low on the 13-set reading, since 0.60 is 15 pairs with 3 discordant, and a single pair flipping would move the coefficient by about 0.13.

## What this does not reach

**The spread is still tiny.** Inside one set count, the six families' reuse distance spans about 1 percent at 13 sets (0.2942 to 0.2954), and their miss spans about 0.6 percent (0.1494 to 0.1503). The ordering is consistent, and the effect it orders is a few parts per thousand. A coefficient is a sign, not a size. Nothing here says one hash family is meaningfully worse than another.

**Fifteen pairs carry each coefficient.** Six families give 15 pairs. The paper claims no significance and ran no test for one. At 13 sets, 3 of 15 pairs are discordant, which is a weaker agreement than at 14 to 16 sets, where one pair is discordant.

**No hardware.** The calibration paper `20261009` shows the generic miss counter reads a fraction of the line fills on this guest. Nothing here is a claim about a real cache.

**The random unbalanced family is still a random map.** Removing random balanced alone leaves a second random family in the coefficient. The next door that removes both random families, leaving five deterministic hash families, would test whether the ordering survives with no random map at all. Five families give 10 pairs, so its coefficient carries less than this one. Its falsifier should be written before it runs.

## Next door

Name the run before it is taken: drop random unbalanced as well, leaving the five deterministic hash families (mix, fmix32_alt, oat, splitmix64_low, fmix64_low), and rerun tau-b at 13 to 16 sets. Five families give 10 pairs. Write the falsifier before the run. Read it against the claim that the ordering needs no random map at all.

Scope: scratch model only.

Confidence in this page as a reading: moderate at 14 to 16 sets and low at 13. The number that would kill it is a tau-b at or below 0.5 at any S in {13, 14, 15, 16} on a re-run of the six families under the same statistic.
