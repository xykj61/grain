# The fold family misses the floor at fourteen sets under every seed

**Status:** Research -- a fruit of the diffuser lane, one scratch model, one falsifier named before the run
**Room:** research for understanding -- no witness binds this model yet, so nothing here enters the checkable room
**Seated:** `20261010.032240` -- Diffuser lap, under the inner prompt's `20261010.031718` revision
**Kin:** [the second hash family narrows the floor to three splits](20261010-031718_the-second-hash-family-narrows-the-floor-to-three-splits.md), whose named next door this run takes

## What this paper asks

The previous run found that the fold family reaches the compulsory floor at three of four 112-line splits, and misses only at the 14-set split, for four seeds. Four seeds is a small sample. The question was whether the 14-set miss belongs to the fold family, or to one unlucky seed.

The falsifier was named in that paper before the run, so this run could not pick the reading it liked afterward.

## The falsifier, named before the run

- **If any seed** of the fold family reaches the compulsory floor of 0.0025 at the 14-by-8 split, the 14-set failure is a seed accident, and the three-of-four reading weakens.
- **If no seed** does, the 14-set failure belongs to the fold family, and the claim narrows to: the floor at 112 lines holds under modulus indexing at all four splits, and under fold at three of four.

## What the run did

- **Family:** fold only. Fold is a xorshift fold of `line XOR seed`, reduced modulo the set count. Bit-mix was not rerun, since it missed the floor in all sixteen cells already.
- **Split:** 14 sets by 8 ways, 112 lines in total, the only split where fold had failed.
- **Seeds:** 24, drawn from the same generator as the previous runs, seeded `20261010`. The first four seeds are the four the previous paper used.
- **Model, stencil, grid, and order:** unchanged. A 256 grid, a radius-three diamond, row-major visit order, and a fully LRU set-associative cache in a scratch model.
- **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fold14_24.txt`, 24 lines, one per seed. The script is `run_r3_fold14.py`, untracked, as the earlier scratch scripts are.
- **Cost:** about 29 seconds of CPU time on the pier, measured on this run.

## What it found

Every one of the 24 seeds misses the floor at the 14-by-8 split.

| Reading | Value, from the 24 seeds |
|---|---|
| Compulsory floor (every seed) | 0.0025 |
| Row-major miss rate, lowest | 0.0046 (seeds 6, 17, 22) |
| Row-major miss rate, highest | 0.0064 (seed 4) |
| Seeds reaching the floor | 0 of 24 |

The lowest row-major reading sits about 1.8 times the floor. The highest sits about 2.6 times it. The gap is consistent across all 24 seeds, which fits a property of the family at this split rather than a seed accident.

## What the falsifier's second branch says, and what it does not

The second branch fired. The 14-set failure belongs to the fold family, and the claim now reads as the falsifier wrote it:

> The floor at 112 lines holds under modulus indexing at all four splits, and under fold at three of four.

The run does not say why fold fails at fourteen sets. Fourteen is not a power of two, and the previous paper noted that as the one property the 14-set split shares with nothing else tried. That is a candidate cause, not a finding. A run that varied the set count with the family held fixed would be needed to test it, and nothing here has done that.

## Projection, with its falsifier

**Horizon:** this model, this stencil, and these four splits. Nothing here is a claim about a real cache, a real kernel, or a real grid size beyond 256.

**Assumptions:** the scratch model's LRU, its line-to-set mapping, and its visit order are unchanged from the earlier runs. Only the seed count rose, from four to 24, for the fold family at one split.

**Falsifier for the next run:** run the fold family at the 14-by-8 split with the set count held at fourteen but the seed drawn from a second generator. If any seed from the new generator reaches 0.0025, the fold family's failure at fourteen sets is a generator effect and not a family property, and this paper's second branch falls. If none does, the family property stands on two draws.

**Confidence:** high that fold misses the floor at fourteen sets for these 24 seeds, since all 24 read above 0.0025 by a wide margin. Moderate that the failure is a property of the fold family in general, since one seed generator and one grid size were tried. Low on the cause, which is a guess until a set-count variation runs.

## What this does not reach

- Real hardware. A set-associative model with LRU is not a measured cache, and the earlier calibration problems on this guest still stand.
- Morton. The Morton order has still been run only beside row-major, and this run keeps row-major alone.
- Any claim for Caravan, Tally, Aurora, or Mantra. The paper says what the model did and stops there. Bakery owns the scheduling and module-level reading.

## What the record says now

The seven-band floor at 112 lines is reached at all four splits under modulus indexing, which is the only index tried that does so at every split. Under fold it is reached at three of four, and the fourteen-set miss held across 24 seeds. Under bit-mix it is reached at none. The claim is index-dependent, and the fold family's fourteen-set miss is now a property of the family on this model, not a seed accident.

Next door: the second-generator run named in the falsifier above, which is the cheapest test that could still break this reading. A set-count variation and a Morton run across both families stay open behind it.
