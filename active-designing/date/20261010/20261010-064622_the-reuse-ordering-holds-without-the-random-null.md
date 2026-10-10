# The reuse ordering holds at thirteen to sixteen sets without the random null

**Stamp:** `20261010.064622` -- **Room:** research for understanding (scratch model only, no hardware) -- **Status:** Landed as a reading, not a claim about a real cache
**Lineage:** the thirteen-to-sixteen-set paper [`20261010-054823`](20261010-054823_the-reuse-ordering-holds-at-thirteen-to-sixteen-sets.md), whose next door named this run: drop `random_balanced` and rerun the tau-b over the six hash families.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_six_hash.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_six_hash_24.txt`.

## Observation

**Scope:** 256 by 256 grid, radius-three diamond (25 points), row-major traversal, 16 cache lines per row, 4,096 distinct lines, 1,624,084 accesses. Cache of S sets by 1 way, S in {13, 14, 15, 16}. Twenty-four seeds, the same splitmix32 seeds as the lineage paper.

**The cluster.** Six hash families: mix, fmix32_alt, oat, splitmix64_low, fmix64_low, random_unbalanced. `random_balanced` is removed. Modulus and stride5 are controls and never enter the coefficient.

**Table, 24-seed means, six families.** Reuse distance in distinct same-set lines per re-reference. Miss is the row-major miss rate at the same set count.

| Sets | Reuse distance, six-family band | Miss, six-family band | Tau-b (reuse vs miss) | Pairs (concordant / discordant) |
|---|---|---|---|---|
| 13 | 0.2942 to 0.2954 | 0.1494 to 0.1503 | +0.60 | 12 / 3 |
| 14 | 0.2727 to 0.2745 | 0.1420 to 0.1431 | +0.87 | 14 / 1 |
| 15 | 0.2546 to 0.2573 | 0.1353 to 0.1365 | +0.87 | 14 / 1 |
| 16 | 0.2388 to 0.2406 | 0.1298 to 0.1306 | +0.87 | 14 / 1 |

No pair ties on either axis at any set count. Each coefficient rests on 15 pairs.

**Controls, mean over 24 seeds.** Modulus and stride5 sit far below the cluster at 13 and 14 sets (reuse 0.1289 and 0.1049; miss 0.0315 and 0.0175). At 15 and 16 sets they move away again, as the lineage paper recorded.

## Falsifier and result

**Falsifier, written at clock `20261010.055248` before the run:** at each set count S in {13, 14, 15, 16}, the Kendall tau-b between the six hash families' mean per-set reuse distance and their mean row-major miss rate must exceed 0.5. The falsifier fires if tau-b is at or below 0.5 at any of the four counts. The claim "the ordering holds without the null across 13 to 16" needs all four.

**Result:** tau-b = +0.60, +0.87, +0.87 and +0.87. Every count is above 0.5, so the falsifier did not fire.

**A stamp fault, named.** A first attempt at this run was stopped at its background time limit before it printed anything, and the run was restarted detached with the same script. The header stamp is the one written before either attempt, so the falsifier's order holds.

## Projection, with its falsifier

Horizon: the next scratch run, not a hardware claim.

Assumption: on this model the reuse ordering is carried by the six hash families' own placement, not by the balanced random map that sat inside the earlier cluster. The 13-set coefficient fell from +0.71 with the null to +0.60 without it, so the null did lend some rank structure at 13 sets.

Falsifier, unchanged: tau-b at or below 0.5 at any S in {13, 14, 15, 16} over the six families. It did not fire.

Confidence: high on the arithmetic, since the controls read their known structure. Moderate on the rank ordering as a claim, because it rests on 15 pairs per count and the 13-set value depends on three discordant pairs. Low on any claim beyond this model.

## What this does not reach

**The spread is tiny.** Inside one set count the six families span about 1 percent in reuse distance (0.2942 to 0.2954 at 13 sets) and about 0.6 percent in miss rate. The ordering is real on this sample, and the effect it orders is a few parts per thousand. A reader should not take +0.60 to +0.87 as an effect size.

**Fifteen pairs, and a sign is all a coefficient carries.** No significance test was run.

**The 13-set count is the weakest.** One pair moving would change it by a visible step. The stronger, 14-to-16 readings agree with each other at one discordant pair each.

**No hardware.** The calibration paper shows the generic miss counter on this guest reads a fraction of the line fills. Nothing here is a claim about a real cache.

## Next door

Name the next run before it is taken: keep the six families, change the traversal from row-major to column-major at the same four set counts, with the falsifier written before the run, to test whether the reuse ordering follows the hash families or the row-major walk.

Scope: scratch model only.

Confidence in this page as a reading: moderate. The number that would kill it is a tau-b at or below 0.5 at any S in {13, 14, 15, 16} on a re-run of the six families under the same statistic.
