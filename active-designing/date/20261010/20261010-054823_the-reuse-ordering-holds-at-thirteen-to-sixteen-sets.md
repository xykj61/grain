# The per-set reuse-distance ordering holds at 13 to 16 sets, and the spread inside the cluster is a few parts per thousand

**Status:** Design -- scratch-model reading; the pre-registered falsifier did not fire at any of the four set counts, and the reading is thin (seven families, 21 pairs, a sub-percent spread)
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the reuse-distance paper [`20261010-050359`](20261010-050359_the-reuse-distance-orders-the-cluster-and-the-null-does-not-carry-it.md), whose next door was a set-count sweep of the same statistic at 13 to 16 sets, with its falsifier written before the run.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_small_sets.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_small_sets_24.txt`.

## Observation

**Scope:** 256 by 256 grid, radius-three diamond (25 points), row-major traversal, 16 cache lines per row, 4,096 distinct lines, 1,624,084 accesses. Cache of S sets by 1 way, S in {13, 14, 15, 16}. Twenty-four seeds, the same splitmix32 seeds as the ordering paper.

**The cluster, fixed from the 127-set ordering output.** Mix, fmix32_alt, oat, splitmix64_low, fmix64_low, random_balanced, random_unbalanced. Modulus and stride5 are reported as controls and never enter the coefficient. The set was read from the 127-set run and not chosen by hand, the same rule the lineage paper used.

**The statistic.** Per-set reuse distance over the whole row-major traversal, as in the lineage paper: for each re-reference, the number of distinct same-set lines touched since its previous access, averaged over every re-reference and then over 24 seeds. Miss is the row-major miss rate at the same set count and way count.

**Table, 24-seed means, cluster families.** Reuse distance is in distinct lines per re-reference. Miss is row-major miss rate against the compulsory floor (not reached at these sizes).

| Sets | Reuse distance, cluster band | Miss, cluster band | Tau-b (reuse vs miss) |
|---|---|---|---|
| 13 | 0.2942 to 0.2954 | 0.1494 to 0.1503 | +0.71 (18 concordant, 3 discordant) |
| 14 | 0.2727 to 0.2745 | 0.1420 to 0.1431 | +0.90 (20 concordant, 1 discordant) |
| 15 | 0.2546 to 0.2573 | 0.1353 to 0.1365 | +0.81 (19 concordant, 2 discordant) |
| 16 | 0.2388 to 0.2406 | 0.1298 to 0.1306 | +0.81 (19 concordant, 2 discordant) |

No pair ties on either axis at any set count. The random balanced null reads a nonzero reuse distance on all 24 seeds at every set count (seeds_at_zero = 0 of 24 at 13, 14, 15 and 16).

**Controls, mean over 24 seeds.** Modulus and stride5 are not at the same place as the cluster. At 13 sets both read reuse 0.1289 and miss 0.0315, well below the cluster. At 14 sets they read 0.1049 and 0.0175. At 15 and 16 sets modulus reads 0.1897 and 1.7844, and stride5 reads 1.1013 and 1.7844, with misses near 0.32. The controls move away from the cluster as set count changes, so they are a reference for the statistic and not a second family in the ordering.

## Falsifier and result

**Falsifier, written at clock `20261010.051050` before the run:** at each set count S in {13, 14, 15, 16}, the Kendall tau-b between the seven cluster families' mean per-set reuse distance and their mean row-major miss rate must exceed 0.5. The falsifier fires if tau-b is at or below 0.5 at any of the four counts. The claim "the ordering holds across 13 to 16" needs all four.

**Result:** tau-b = +0.71, +0.90, +0.81 and +0.81. The falsifier did not fire at any count. The null check held on every seed. The controls were reported in full and not folded in.

**A stamp fault, named.** The falsifier header first read `20261010.052400`, a time typed ahead of the clock. The clock read `20261010.051050` before the script was run, and the header was corrected to that read before any output existed. The run's order is therefore the one the header now states.

## Projection, with its falsifier

Horizon: the next scratch run, not a hardware claim.

Assumption: misses in a fully counted one-way set depend on how many distinct same-set lines return between reuses, and the whole-traversal reuse distance counts that. Rank order among the cluster is preserved across set counts 13 to 16 on this model.

Falsifier, unchanged from above: tau-b at or below 0.5 at any S in {13, 14, 15, 16} over the seven cluster families. It did not fire.

Confidence: high on the arithmetic, since the controls and the null read their known structure. Moderate on the rank ordering as a claim, because the coefficient rests on 21 pairs, and low on any claim beyond this model.

## What this does not reach

**The spread is tiny, and this is the main reading.** Inside one set count, the cluster's reuse distance spans about 1 percent (0.2942 to 0.2954 at 13 sets), and its miss spans about 0.6 percent (0.1494 to 0.1503 at 13 sets). The ordering is real on this sample, but the effect it orders is a few parts per thousand. A reader should not take +0.71 to +0.90 as an effect size. The coefficient records that the order is consistent across the seven families, not that a family is meaningfully worse.

**Seven families, 21 pairs.** Each coefficient rests on 21 pairs, and a sign is all it carries. The paper claims no significance, and no test was run for one.

**The null sits inside the cluster.** Random balanced is one of the seven, so the ordering is partly a placement effect of the balanced random map. The lineage paper removed the null and found the sign survived. This sweep did not repeat that removal at every set count, so the claim about hash families rests on the 127-set result for that.

**No hardware.** The calibration paper shows the generic miss counter reads a fraction of the line fills on this guest. Nothing here is a claim about a real cache.

## Next door

Name the next run before it is taken: drop random balanced and rerun the tau-b at 13 to 16 sets over the six hash families, with the falsifier written before the run, to test whether the ordering is carried by the null's placement or by the hash families themselves.

Scope: scratch model only.

Confidence in this page as a reading: moderate. The number that would kill it is a tau-b at or below 0.5 at any S in {13, 14, 15, 16} on a re-run of the same seven families under the same statistic.
