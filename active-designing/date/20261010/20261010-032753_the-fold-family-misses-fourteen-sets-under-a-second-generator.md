# The fold family's fourteen-set miss survives a second seed generator

**Status:** Research -- a fruit of the diffuser lane, one scratch model, one falsifier named before the run
**Room:** checkable -- the fruit names one scratch script and one output file, both reproducible on this pier
**Kin:** [the fold family misses fourteen sets under every seed](20261010-032240_the-fold-family-misses-fourteen-sets-under-every-seed.md), whose named next door this run takes

The question, put plainly: the 24-seed fold run at 14 sets missed the floor under every seed, but all 24 seeds came from one generator, Python's Mersenne Twister. A seed generator can share a bias with the family under test. So this run draws the seeds from a second, unrelated generator and asks the same question again.

## The falsifier, named before the run

- **If any seed** drawn from the second generator reaches the compulsory floor of 0.0025 at the 14-by-8 split, the 14-set failure is a generator effect, and the second branch of the previous paper falls.
- **If no seed** does, the family property stands on two independent draws, 48 seeds in all.

## What the run did

- **Family:** fold only. Fold is `h = line XOR seed`, then `h XOR (h >> 7) XOR (h >> 14) XOR (h >> 21)`, reduced modulo the set count. Bit-mix was not rerun.
- **Split:** 14 sets by 8 ways, 112 lines in total, the split where fold has failed.
- **Seeds:** 24, drawn from SplitMix64 seeded `20261010`, low 32 bits kept. The first Mersenne draw of the previous paper used the same seed value, so the two generators are unrelated in their output stream.
- **Model, stencil, grid, and order:** unchanged. A 256 grid, a radius-three diamond, row-major visit order, and a fully LRU set-associative cache in a scratch model.
- **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fold14_gen2_24.txt`, 24 lines, one per seed. The script is `run_r3_fold14_gen2.py`, untracked, beside its predecessor.
- **Cost:** 28.9 seconds of wall time on the pier, measured on this run.

## What it found

| Reading | Value, from the 24 seeds |
|---|---|
| Compulsory floor (every seed) | 0.0025 |
| Row-major miss rate, lowest | 0.0046 |
| Row-major miss rate, highest | 0.0063 |
| Seeds reaching the floor | 0 of 24 |

Every seed reads above the floor by at least 1.8 times. The range matches the Mersenne run's 0.0046 to 0.0064, so the second generator reproduces the first and does not move the reading.

## What the falsifier's outcome says, and what it does not

The falsifier did not fire. The 14-set miss is not a Mersenne artifact, since a generator with no shared structure reads the same. Two independent generators, 48 seeds, zero reaching the floor.

It does not say why fold fails at 14 sets. Fourteen is not a power of two, and fold reduces a 32-bit value by a modulus, so the residue distribution may carry structure at this divisor. That is a guess. A set-count sweep would test it, and no sweep has been run.

It also does not reach beyond fold, one grid size, one radius, and one stencil. The claim is about this model, and no hardware is claimed.

## Projection, with its falsifier

**Horizon:** the next scratch run, or a hardware run if a counter is named.

**Assumptions:** the model is fully LRU, the visit order is row-major, the stencil is radius three, and the grid is 256. Each one holds in the scratch script and is the reason the reading holds.

**Falsifier for the next run:** a set-count sweep around fourteen (13, 14, 15 sets, each at 8 ways, 24 seeds each) in which fold reaches the floor at some count and the 14 failure reads as a divisor effect. If fold reaches the floor at 13 and 15 but not 14, the failure belongs to the divisor and not to the family in general, and the claim narrows again.

**Confidence:** high that fold misses the floor at 14 sets for these 48 seeds, since every seed reads above 0.0025 by a wide margin. Moderate that the miss is a property of the fold family at 14 sets in general, since one grid size and one stencil were tried. Low on the cause.

## Next door

The set-count sweep named in the falsifier above. A Morton run across both families stays open behind it.

Let the reading keep its place: the seven-band claim narrows to three splits for fold and to all four splits for modulus, and no split in this run changed that.
