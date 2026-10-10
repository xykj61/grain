# The per-set reuse distance orders the busiest-6-to-7 cluster, and the random null does not carry the result

**Status:** Design -- scratch-model reading; the pre-registered falsifier did not fire, and the reading is thin (seven families, 21 pairs)
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the conflict-mass paper [`20261010-045302`](20261010-045302_the-conflict-mass-is-flat-across-the-busiest-cluster.md), whose next door was a per-set reuse-distance measure over the whole traversal, with its falsifier written in the paper before any run.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_distance_127x1.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_distance_127x1_24.txt`. Row-major miss rates come from `run_256_r3_ordering_127x1_24.txt`.

## Observation

**Scope:** 256 by 256 grid, radius-three diamond (25 points), row-major traversal, 16 cache lines per row, 4,096 distinct lines. Cache of 127 sets by 1 way. Twenty-four seeds, the same splitmix32 seeds as the ordering paper. Compulsory floor 0.0025.

**The cluster, fixed before the run.** Families whose mean busiest-window count over 24 seeds lies in [6, 7], read from the ordering output: mix, fmix32_alt, oat, splitmix64_low, fmix64_low, random_balanced, random_unbalanced. Seven families, the same set the conflict-mass paper used.

**The statistic, fixed before the run.** For each access to a line the traversal has already touched, its per-set reuse distance is the number of distinct lines of the same set accessed since its previous access. A family's value for one seed is the mean of that distance over every re-reference in the whole traversal. The per-seed value is then averaged over 24 seeds.

**Table, 24-seed means.** Reuse distance is in distinct lines per re-reference. Miss is row-major miss rate against the 0.0025 floor.

| Family | Mean reuse distance | Mean row-major miss |
|---|---|---|
| random_balanced | 0.0292 | 0.0274 |
| mix | 0.0298 | 0.0277 |
| fmix32_alt | 0.0299 | 0.0278 |
| oat | 0.0301 | 0.0281 |
| fmix64_low | 0.0302 | 0.0280 |
| splitmix64_low | 0.0302 | 0.0280 |
| random_unbalanced | 0.0302 | 0.0281 |

Controls: modulus and stride5 read exactly 0.0000 on every seed, the instrument's floor. The random balanced null reads 0.0292 on average and is nonzero on all 24 seeds (seeds_at_zero=0 of 24).

## Falsifier and result

**Falsifier, written at clock `20261010.045911` before the run:** over the seven cluster families, the Kendall tau-b between each family's mean per-set reuse distance and its mean row-major miss rate must exceed 0.5. If tau-b is at or below 0.5, a whole-traversal per-set reuse distance does not separate the cluster's misses either, and the spread is noise at this scale.

**Result:** tau-b = +0.62 (17 concordant, 4 discordant, 0 ties on either axis). The falsifier did not fire.

**Sensitivity.** The random balanced null is the lowest family on both axes, and a reader could suspect the coefficient rests on that one anchor. It does not. With random_balanced removed, six families give tau-b = +0.60 (10 concordant, 2 discordant, 3 tied on reuse, 0 on miss). The ordering survives the removal, though six families is a smaller sample still.

## Projection, with its falsifier

Horizon: the next scratch run, not a hardware claim.

Assumption: misses in a fully counted LRU set depend on how many distinct lines return to the set between reuses, and the whole-traversal distance counts that where the one-window count does not.

Falsifier, unchanged from above and already run: tau-b at or below 0.5 over the seven cluster families. It did not fire.

Confidence: high on the arithmetic, since the controls read their known values and the null reads nonzero on every seed. Moderate on the ordering, because seven families and 21 pairs is a thin sample. Low on any claim beyond this model.

## What this does not reach

**The spread is small.** Every family in the cluster reads between 0.0292 and 0.0302 mean reuse distance, a band of about 3 percent. The miss band is about 2.5 percent. The ordering is real on this sample, but the effect it orders is a few parts in a hundred. A reader should not take the +0.62 as an effect size.

**Seven families, 21 pairs.** The coefficient rests on 21 pairs, three of them tied on reuse distance, so a sign is all it carries. The paper claims no significance.

**A measurement fault, named.** The first run listed random_balanced twice, once from the cluster and once from the null list, so the family was computed twice and the summary repeats it. The duplicate reads the same value both times and changes no number above. It is noted here so the repeated line is not read as a second family.

**No hardware.** The calibration paper already shows the generic miss counter reads a fraction of the line fills on this guest. Nothing here is a claim about a real cache.

## Next door

Name the next run before it is taken: a set-count sweep of the reuse-distance ordering at 13 to 16 sets, with the falsifier written in the paper before the run, to test whether the ordering holds where the miss rate itself moves more than 2.5 percent across the cluster.

Scope: scratch model only.

Confidence in this page as a reading: moderate. The number that would kill it is a tau-b at or below 0.5 on any re-run of the same seven families under the same statistic.
