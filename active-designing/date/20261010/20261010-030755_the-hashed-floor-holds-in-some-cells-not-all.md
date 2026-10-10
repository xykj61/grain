# The hashed index reaches the seven-band floor in some cells, and in no seed at every split

**Status:** Research -- a fruit of the diffuser lane, one scratch model, one falsifier
**Room:** research for understanding -- no witness binds these numbers; the model is untracked
**Stamp:** `20261010.030755`
**Kin:** [the seven-band floor depends on the index](20261010-030238_the-seven-band-floor-depends-on-the-index.md), whose named next test this run is -- a hash-seed sweep at the 112-line splits
**Scratch script:** `session-output/diffuser-stencil-r3/run_r3_seeds.py` (gitignored, per seat; re-run with `python3 -I run_r3_seeds.py 24`). Output: `run_256_r3_seeds_112.txt`, 96 lines.

## What this paper asks

The previous paper swapped the modulus set index for one multiplicative hash, and every 112-line split
fell above the compulsory floor. That one hash could be unlucky. This run asks whether any member of a
family of multiplicative hashes brings row-major to the floor at the four 112-line splits, and it runs
the family rather than trusting one constant.

## The falsifier, named before the run

Two clauses, both from the paper it extends.

> **Clause A.** The seven-band boundary survives as "for some index functions, not all" if **a seed
> reaches 0.0025 for every 112-line split** on the 256 grid. The clause is met only if one seed does.
>
> **Clause B.** The claim narrows to modulus indexing, and the modulus paper stands as its replacement,
> if **no seed reaches the floor at 112 for any split**. The clause is met only if every one of the 96
> cells sits above the floor.

## The family and the model

The seed-0 multiplier is the previous paper's constant, 2654435761. The other 23 are odd 32-bit constants
drawn from a fixed generator, `random.Random(20261010)`. Each cell is the same LRU set-associative model
as the paper before it: radius-three 25-point diamond, N=256, row-order sweep, line of 16 cells, set index
`((line * m) mod 2^32) >> 16` modded by the set count. The compulsory floor is the distinct-line count over
accesses, and it is the same for every seed, because the set index does not change which lines are touched.

## Observation: 24 seeds, four 112-line splits

Ninety-six cells. Ninety-one sit above the floor. Five sit at it:

| seed | multiplier | split (sets x ways) | row-major | floor |
|---:|---:|---|---:|---:|
| 3 | 2843664299 | 4 x 28 | 0.0025 | 0.0025 |
| 11 | 1724006503 | 8 x 14 | 0.0025 | 0.0025 |
| 11 | 1724006503 | 4 x 28 | 0.0025 | 0.0025 |
| 23 | 3374939663 | 8 x 14 | 0.0025 | 0.0025 |
| 23 | 3374939663 | 4 x 28 | 0.0025 | 0.0025 |

Seed 2 reads 0.0026 at 4 x 28, a hair above the floor. No seed reaches the floor at all four splits. The
lowest row-major reading in any cell is 0.0025, and the highest is 0.0168 (seed 4, 16 x 7). Only the two
tightest splits, 4 ways of 28 and 8 ways of 14, ever reach the floor; the 16 x 7 split never does.

## Two readings, read apart

**Clause A is not met.** No seed reaches the floor at every split, so no seed supports a claim that the
hashed index keeps the seven-band boundary at 112 lines. The paper's own strongest hashed statement stands:
the hash moves row-major off the floor at most splits.

**Clause B is not met either.** Five cells reach the floor, so the strict form of clause B is
not met. The paper named that outcome as a gap, and this run lands in it. The honest reading is that under
multiplicative hashing the floor is reached sporadically: it depends on which multiplier and which split,
and it is not a property of capacity alone.

**The modulus result is the only index in which all four splits reach the floor.** The earlier paper's
clean seven-band claim stays exactly where it was: under modulus indexing, at the tried splits. Under
hashing, the boundary is index-dependent in a non-monotone way -- a smaller way-count split can reach the
floor while a larger one does not.

## What this does not say

Only row-major order is measured here. Morton's lead was run under one hash in the previous paper and is
not re-run across seeds, so its robustness to the hash is still open. The family is 24 odd multipliers
from one generator, not every multiplier, and not a second hash family such as an xor-shift. The model has
no prefetcher, no pseudo-LRU, no write traffic and no second level. No hardware claim follows.

## Falsifier for the next run

If a second hash family, an xor-shift or a Fibonacci-hashing variant, also reaches the floor at some
112-line splits, the index-dependence is a property of the hash class, not of these multipliers. If it
reaches the floor at every split under some member, clause A returns. If it reaches the floor at none,
clause B is met for two families, and the modulus claim is the only one standing. Name the falsifier
before the run, and run the Morton column beside row-major in the same sweep.

## Confidence

**High** that, in this model and across these 24 multipliers, no seed reaches the floor at all four
112-line splits. The run is deterministic, so this is not sampling noise; the spread is across multipliers.
**Medium** that the five floor cells are a real feature of the hash rather than an artefact of 24 draws.
**Low** for any statement about a physical cache, which this model does not measure.
