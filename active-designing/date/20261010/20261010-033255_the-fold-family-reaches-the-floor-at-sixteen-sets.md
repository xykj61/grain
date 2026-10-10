# The fold family's fourteen-set miss is a capacity threshold, not a divisor effect

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep and one capacity control, two falsifiers named before the run
**Room:** checkable -- the fruit names its scratch scripts and output files, all reproducible on this pier
**Kin:** [the fold family misses fourteen sets under a second generator](20261010-032753_the-fold-family-misses-fourteen-sets-under-a-second-generator.md), whose named next door this run takes

The question, put plainly: fold missed the compulsory floor at 14 sets under 48 seeds from two generators. The next paper named a set-count sweep at 13, 14 and 15 sets to ask whether the miss belonged to the divisor 14. This run does that sweep, then adds a control the sweep alone could not supply. At a fixed 8 ways, changing the set count also changes the total line count, so the sweep varies capacity and divisor together. A seed-free modulus index at the same counts separates the two, and fold at 16 sets shows where the miss ends.

## The falsifiers, named before the run

- **Divisor branch (from the previous paper):** if fold reaches the floor at 13 and 15 sets but not at 14, the failure belongs to the divisor, and the family claim narrows.
- **Family branch:** if fold misses at 13, 14 and 15 alike, the miss is not a divisor effect, and the family claim stands at these counts.
- **Control, added before the run:** modulus, which is seed-free, must reach the floor at 14 sets where fold does not, or the comparison says nothing about fold. If modulus misses at the same counts as fold, the miss is a capacity effect shared by both index families.

## What the run did

- **Model, stencil, grid, and order:** unchanged from the previous papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a fully LRU set-associative cache in a scratch model. The compulsory floor is 0.0025 on every run.
- **Sweep:** fold at 13, 14 and 15 sets, 8 ways each, on the same 24 SplitMix64 seeds (stream seeded `20261010`) the previous paper used. Script: `run_r3_fold_setsweep.py`, output `run_256_r3_fold_setsweep_24.txt`, 72 lines, 87 seconds of wall time on the pier.
- **Control:** modulus at 13, 14, 15 and 16 sets (one run each, since modulus takes no seed), and fold at 16 sets on the same 24 seeds. Script: `run_r3_control_sets.py`, output `run_256_r3_control_sets_24.txt`, 28 lines.

## What it found

| Family | Sets x ways | Lines | Row-major miss rate | Seeds reaching 0.0025 |
|---|---|---|---|---|
| fold | 13 x 8 | 104 | 0.0103 to 0.0112 | 0 of 24 |
| fold | 14 x 8 | 112 | 0.0046 to 0.0063 | 0 of 24 |
| fold | 15 x 8 | 120 | 0.0038 to 0.0043 | 0 of 24 |
| fold | 16 x 8 | 128 | 0.0025 | **24 of 24** |
| modulus | 13 x 8 | 104 | 0.0124 | no |
| modulus | 14 x 8 | 112 | 0.0025 | yes |
| modulus | 15 x 8 | 120 | 0.0025 | yes |
| modulus | 16 x 8 | 128 | 0.0025 | yes |

The fold miss falls steadily as lines rise from 104 to 120, then reaches the floor at 128 for every seed. Modulus reaches the floor at 112 and misses only at 104.

## What the falsifiers say

**The divisor branch falls.** Fold misses at 13, 14 and 15 alike, so the 14-set failure is not an isolated divisor effect. The rate is monotone in set count, which is the shape of a capacity threshold.

**The family branch holds at these counts, and the control narrows it.** Fold misses the floor at every count from 104 to 120 lines. Modulus reaches it at 112, so the miss is not a shared capacity effect at 14 sets: at the same line count the two index functions differ. Fold does reach the floor, though, at 128 lines, for all 24 seeds. So the honest claim is that fold needs more capacity than modulus to hold this stencil's working set, not that fold never reaches the floor.

**The divisor-free reading holds only for this model.** The 13-set modulus miss shows that 104 lines is below this working set for any index, so the threshold is real capacity. Fold's excess sits between 112 and 128 lines. The paper does not measure where between those lines fold first reaches the floor, and a finer count (for example 17 and 18 sets, 136 and 144 lines) is the next door that would fix that edge.

## Projection, with its falsifier

**Horizon:** the next scratch run on this model. No hardware is claimed, and no counter is named.

**Assumptions:** fully LRU sets, a row-major visit order, a radius-three stencil, a 256 grid, 16 elements per line, and the same 24 seeds from one stream. Each one holds in the scratch script.

**Falsifier for the next run:** fold at 17 and 18 sets (136 and 144 lines, 24 seeds each) should reach the floor for every seed at both counts. If fold misses at 17 or 18 for any seed, the claim that fold reaches the floor by 128 lines is wrong, and the fold family's capacity need on this stencil is open-ended again.

**Confidence:** high that fold misses the floor at 104, 112 and 120 lines, since every seed reads above 0.0025 by a wide margin at each count. High that fold reaches it at 128 lines for these 24 seeds, since all 24 read exactly 0.0025. Moderate that the threshold is a property of fold on this stencil in general, since one grid size, one radius, and one visit order were tried. Low on the mechanism. Fold's excess might come from residue clustering at the modulus of its xor-shift output, but no run here tests that.

## Next door

The 17-and-18-set run named in the falsifier above, which pins where between 112 and 128 lines fold first reaches the floor. A Morton run across both index families stays open behind it. Keaton's word for a raw vendor event would open the hardware side, and none is claimed here.

Let the reading keep its place: the 14-set miss is a capacity threshold for fold on this model, and the divisor explanation is closed for these counts.
