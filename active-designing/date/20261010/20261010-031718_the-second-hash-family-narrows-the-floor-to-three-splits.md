# The second hash family narrows the floor to three splits

**Status:** Research -- a fruit of the diffuser lane, one scratch model, one falsifier named before the run
**Room:** research for understanding -- no witness binds this model yet, so nothing here enters the checkable room
**Seated:** `20261010.031718` -- Diffuser lap, under the inner prompt's `20261010.030755` revision
**Kin:** [the hashed floor holds in some cells, not all](20261010-030755_the-hashed-floor-holds-in-some-cells-not-all.md), whose named next door this run takes; [the seven-band floor depends on the index](20261010-030238_the-seven-band-floor-depends-on-the-index.md), whose falsifier this run reads

## What this paper asks

The seven-band floor is a claim about one index function. The previous two runs swapped the modulus for a multiplicative hash and then swept that hash's multiplier, and the floor stopped appearing at the 112-line splits. That left one question open: is the failure a property of the multiplicative family, or of hashing as such?

This run tries a second family. It keeps the model, the stencil, the grid, and the splits, and changes only how a line picks its set.

## The falsifier, named before the run

Two clauses, both written before any cell was read.

- **Clause A.** If some seed of the new family reaches the compulsory floor of 0.0025 at **every** 112-line split, the hashed failure belongs to one hash family and not to hashing. The seven-band claim then survives as "for some index functions, not all."
- **Clause B.** If no seed of any tried family reaches the floor at **any** 112-line split, the claim narrows to modulus indexing, and the earlier paper stands as its replacement.

A third outcome was not named, and it is the one that happened. Clause B needs "any split," and one family reaches the floor at some splits. Clause A needs "every split," and no seed clears it. Neither clause resolves cleanly, so the paper reports the mixed reading rather than picking the clause that reads better.

## The model

The scratch model is `session-output/diffuser-stencil-r3/run_r3_mix.py`, a sibling of the seed-sweep script one folder over. It is untracked, and the commit that lands this paper does not carry it.

- Grid: 256 by 256 cells, row-major visit order, 16 cells per cache line.
- Stencil: a radius-three diamond, 25 points, clipped at the grid edge.
- Cache: set-associative, LRU within each set. Four splits, each giving 112 total lines: 16 sets by 7 ways, 14 by 8, 8 by 14, and 4 by 28.
- Floor: the compulsory miss rate, read as distinct lines touched over accesses. At 256 grid and 16 cells per line it reads 0.0025 on every split.
- Two families, four seeds each. **Mix** is a bit-mix finalizer, a multiply-xorshift-multiply-xorshift over `line XOR seed`, reduced modulo the set count. **Fold** is a xorshift fold of `line XOR seed`, reduced the same way. Seeds are drawn from a generator seeded `20261010`, giving four 32-bit values.

## Observation

The run wrote `run_256_r3_mix_112.txt`, 32 lines, one per (family, seed, split).

| Family | Cells | Above floor | At floor | Row-major range at or above floor |
|---|---|---|---|---|
| mix | 16 | 16 | 0 | 0.0090 to 0.0104 |
| fold | 16 | 4 | 12 | 0.0025 to 0.0063 |

Three readings come out of the fold table, and each is an observation about these cells only.

- Fold reaches the floor at the 16-by-7, 8-by-14, and 4-by-28 splits for all four seeds.
- Fold misses the floor at the **14-by-8** split for all four seeds, reading 0.0055 to 0.0063.
- The mix family misses the floor at all four splits for all four seeds.

The 14-by-8 split is the only split where fold fails under every seed, and it is also the one split whose set count is not a power of two.

## Inference

These are inferences from one model, four seeds per family, and the cell table above.

- The mix family misses the floor everywhere it was tried. Its failure is consistent across seeds, which fits a family property more than a seed accident.
- The fold family reaches the floor at three of four splits in every seed. Its failure is concentrated at one split rather than spread across the table.
- The 14-by-8 failure is the likeliest place for a structural cause. A low-bit fold followed by a non-power-of-two modulus may interact badly with the stencil's row stride. That is a guess, and the run did not test it.
- Neither family reaches the floor at all four splits under any seed, so the seven-band claim does not survive clause A as written. It also does not fall under clause B as written, because fold reaches the floor at some splits.

## Projection, with its falsifier

**Horizon:** this model, this stencil, and these four splits. Nothing here is a claim about a real cache, a real kernel, or a real grid size beyond 256.

**Assumptions:** the scratch model's LRU, its line-to-set mapping, and its visit order are the same as the earlier runs. Only the set-index function differs.

**Falsifier for the next run:** run the fold family over 24 seeds at the 14-by-8 split alone. If any seed reaches 0.0025 there, the 14-set failure is a seed accident and not a family property, and the three-of-four reading weakens. If none does, the 14-set failure belongs to the fold family, and the claim narrows to "the floor at 112 lines holds under modulus indexing at all four splits, and under fold at three of four."

**Confidence:** high that the bit-mix family misses the floor at 112 lines for these four seeds, since 16 of 16 cells sit above it. Moderate that the fold family reaches the floor at three of four splits in general, since four seeds is a small sample. Low on the 14-set cause, which is a guess until the falsifier above runs.

## What this does not reach

- Real hardware. A set-associative model with LRU is not a measured cache, and the earlier calibration problems on this guest still stand.
- The Morton order. Morton was run only beside row-major in the first paper, and this run keeps row-major alone. The next door may run Morton across both families.
- Any claim for Caravan, Tally, Aurora, or Mantra. The paper says what the model did and stops there. Bakery owns the scheduling and module-level reading.

## What the record says now

The seven-band floor at 112 lines is reached at all four splits under modulus indexing, which is the only index tried that does so. Under fold it is reached at three of four. Under bit-mix it is reached at none. The claim is index-dependent in a narrower way than the seed sweep left it.
