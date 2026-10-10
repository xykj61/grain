# The window count orders the miss rates across fourteen index functions, and a random balanced map lands with the hashes

**Status:** Design -- scratch-model reading, falsifier not fired on its ordering branch, with a weaker reading inside the saturated cluster named below
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the busiest-window paper [`20261010-043624`](20261010-043624_the-busiest-window-at-one-hundred-twenty-seven-lines-under-one-way.md), whose next door asked for at least eight more index functions, a random balanced map among them, and a test of whether the window count orders their miss rates as it orders fold, mix and fib.
**Script:** `session-output/diffuser-stencil-r3/run_r3_ordering_127x1.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_ordering_127x1_24.txt`.

## Observation

**Scope:** 256 by 256 grid, radius-three diamond (25 points), row-major traversal, 16 cache lines per row, 4096 lines in total. Cache of 127 sets by 1 way, fully counted LRU. Twenty-four seeds from the SplitMix64 generator at 20261010, the same seeds as the busiest-window paper. Compulsory floor 0.0025.

**Falsifier, written before the run** (clock read `20261010.044032`, written in the script header): over the three original families plus eleven new ones, the Kendall tau-b between each family's mean busiest-window count and its mean row-major miss rate. If tau-b is zero or below, the window count does not order the miss rates as it orders fold, mix and fib, and it is not the mechanism. A random balanced map must read busiest above one on most seeds, or the measure is blind to placement.

**The reproduction check.** Fold reads busiest 2 on all 24 seeds and miss 0.0030 to 0.0036, matching the busiest-window paper's own fold row, so the harness is the same one.

| Family | Mean busiest | Max busiest | Mean miss | Miss range (24 seeds) |
|---|---|---|---|---|
| modulus, control | 1.00 | 1 | 0.0025 | 0.0025 |
| shuffled modulus, control | 1.00 | 1 | 0.0025 | 0.0025 |
| stride5 (line times 5 mod 127) | 1.00 | 1 | 0.0025 | 0.0025 |
| xor_shift_line | 2.62 | 3 | 0.0067 | 0.0065 to 0.0068 |
| lcg_high | 2.00 | 2 | 0.0035 | 0.0035 |
| fold (original) | 2.00 | 2 | 0.0033 | 0.0030 to 0.0036 |
| knuth_top | 3.46 | 4 | 0.0600 | 0.0504 to 0.0821 |
| fib (original) | 4.00 | 4 | 0.0188 | 0.0141 to 0.0340 |
| xorshift32 | 5.88 | 7 | 0.0224 | 0.0203 to 0.0239 |
| random_balanced (null A) | 6.12 | 7 | 0.0274 | 0.0252 to 0.0288 |
| fmix64_low | 6.42 | 9 | 0.0280 | 0.0255 to 0.0303 |
| random_unbalanced (null B) | 6.46 | 8 | 0.0281 | 0.0264 to 0.0307 |
| splitmix64_low | 6.54 | 8 | 0.0280 | 0.0264 to 0.0306 |
| mix (original) | 6.62 | 9 | 0.0277 | 0.0260 to 0.0294 |
| oat | 6.62 | 9 | 0.0281 | 0.0266 to 0.0301 |
| fmix32_alt | 6.21 | 7 | 0.0278 | 0.0254 to 0.0306 |

Every family with busiest above one reads above one on every seed, and the three controls read 1 on every seed. The measure therefore reports collisions for random placement too: the random balanced map reads 6.12 on average, with no seed at 1.

## Inference

**Kendall tau-b is +0.66 across the fourteen non-control families.** Counts: 73 concordant pairs, 14 discordant, 2 tied on busiest, 2 tied on miss. The falsifier's ordering branch did not fire.

**The tau is carried mostly by the separation between families, not by ordering within a cluster.** Four families sit near busiest 1 to 3 and miss 0.0025 to 0.0067: stride5, xor_shift_line, lcg_high and fold. Most of the discordant pairs involve knuth_top, which has a middling busiest count of 3.46 and by far the highest miss, 0.0600. So the window count is a coarse predictor of which families miss badly, and it is a poor predictor of how badly.

**Inside the saturated cluster the count does not order the misses.** Eight families read a busiest mean between 5.88 and 6.62, counting the two nulls and a miss between 0.0224 and 0.0281. Among the families at 6.2 or above, the miss rates are flat to within noise: mix 0.0277 at 6.62, oat 0.0281 at 6.62, fmix32_alt 0.0278 at 6.21, random_unbalanced 0.0281 at 6.46. The window count separates families at the scale of two or three lines, and at that scale it is blind to the next order of difference. This is a weaker reading than the paper's inference would like, and it is the one the next paper has to test.

**The random balanced null is the most informative row.** It has bucket sizes equal to modulus by construction, so its placement is the only thing that differs from modulus. Its busiest window count is 6.12, and its miss rate, 0.0274, sits with the hash families and well above the 0.0025 floor. Placement, not spread, is what causes the miss: a balanced map with random placement misses like a hash, and a balanced map with structured placement (modulus, stride5) reaches the floor. That is a separation the paper's first next door asked for, and it runs in the direction the conflict reading predicts.

**The null B result is the same story from the other side.** Independent uniform placement, with free bucket sizes, reads a miss of 0.0281 and a busiest of 6.46. Neither null is distinguishable from the hashes on either measure.

## Projection, with its falsifier

Horizon: the next scratch run, not a hardware claim.

Assumption: the windowed busiest count bounds the miss excess under one way, at the scale of roughly two or three lines per set. Below that scale, the count orders families. Above it, it does not separate them.

Falsifier, written now and not yet run: if a finer measure, the number of distinct window lines per set summed over sets above one (conflict mass), does not order the miss rates inside the busiest-6-to-7 cluster, the count is the wrong instrument for that range and the cluster's spread has another cause.

Confidence: high on the observation (24 seeds per family, all three controls at 1, fold reproduced against the earlier paper), moderate on the ordering inference (fourteen families, with heavy overlap in the middle of the ordering, and no significance test run), low on any magnitude claim.

## What this does not reach

The scratch model is a fully counted LRU simulation with a windowed count alongside. It has no hardware counter behind it, and the calibration paper already shows the generic hardware miss counter reads a fraction of the fills on this guest. Nothing here is a claim about a real cache.

The fourteen families are not independent draws from one population. Several are close relatives of one another (the three multiply-xorshift finalizers, the two splitmix variants), so the tau-b counts their agreement more than once. A significance test is not run, and this paper claims no p-value.

## Next door

1. **A finer collision measure inside the busiest-6-to-7 cluster.** Conflict mass, the sum over sets of the excess lines above one, computed per window and maximized over rows. Its falsifier is written above and is the next run's first act.
2. **A random balanced null at a second layout.** The random balanced placement should be tested at 21 sets by 6 ways, where the paper already has a structured-index reference, to see whether placement alone carries the miss there too.

May this small result stand where it belongs: the window count orders families at the coarse scale, the random null misses like a hash and so isolates placement, and the place the count goes blind is named before anyone leans on it.
