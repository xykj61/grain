# The seven-band floor depends on the set index, not only on capacity

**Status:** Research -- a fruit of the diffuser lane, one scratch model, one falsifier
**Room:** research for understanding -- no witness binds these numbers; the model is untracked
**Stamp:** `20261010.030238`
**Kin:** [the radius-three floor under set-associativity](20261010-014913_the-radius-three-floor-holds-under-set-associativity.md), whose named next test this run is -- [the radius-three stencil](20261010-014349_the-radius-three-stencil-moves-the-boundary-to-seven-bands.md)
**Scratch script:** `session-output/diffuser-stencil-r3/run_r3_hashed.py` (gitignored, per seat; re-run with `python3 -I`). Outputs: `run_256_r3_hashed.txt`, `run_256_r3_hashed_112.txt`, `run_512_r3_hashed.txt`.

## What this paper asks

The previous paper ran a radius-three stencil through an LRU set-associative model whose set index is
`line % sets`. Every split at 112 total lines reached the compulsory floor of 0.0025 on the 256 grid, so
seven row bands held. That paper named one next test: swap the modulus for a **hashed set index**, and see
whether row-major still reaches the floor. The question is whether the seven-band boundary belongs to
capacity, or to the index function that happened to be used.

## The falsifier, named before the run

> **The seven-band boundary is a property of capacity under set-associativity if, at 112 total lines on
> the 256 grid under a multiplicative hashed index, row-major's miss rate reaches the compulsory floor of
> 0.0025 for every split totalling 112.** It **fires** if any hashed split at 112 leaves row-major above
> the floor.

The 96-line hashed cell was named as the second check, because the previous paper's stride reading
predicted it: a hash should spread the 16-set conflict cliff away. That prediction was also named before
the run, and it could fail independently of the first clause.

The hash is `set = ((line * 2654435761) mod 2^32) >> 16, then mod sets`. It is one multiplicative hash,
chosen for being simple and standard. It is not the only hash, and this paper does not claim it is
representative of any real cache.

## Observation: 112 lines, 256 grid, hashed index

Radius three (25-point diamond), N=256, LRU within each set, compulsory floor 0.0025. Row-major is the
row sweep and the cell that the falsifier reads; Morton is the own-order sweep.

| sets | ways | total lines | row-major (rows) | row-major (own) | Morton (own) |
|---:|---:|---:|---:|---:|---:|
| 16 | 7 | 112 | 0.0095 | 0.0095 | 0.0032 |
| 14 | 8 | 112 | 0.0077 | 0.0077 | 0.0033 |
| 8 | 14 | 112 | 0.0102 | 0.0102 | 0.0033 |
| 4 | 28 | 112 | 0.0060 | 0.0060 | 0.0033 |

Under the modulus index in the previous paper, the same four splits all read 0.0025. Under the hash, none
reaches the floor. The falsifier's first clause **fires**: at 112 lines, row-major sits above the floor for
every split tried, and the largest gap is at the 16-set, 7-way split, about 3.8 times the floor.

## Observation: 96 lines, 256 grid, hashed index

| sets | ways | total lines | row-major (rows) | Morton (own) |
|---:|---:|---:|---:|---:|
| 16 | 6 | 96 | 0.0166 | 0.0034 |
| 8 | 12 | 96 | 0.0169 | 0.0033 |

The modulus model read 0.2611 at 16 by 6 and 0.0071 at 8 by 12. The hash removes the sharp cliff: the
16-set split falls from 0.2611 to 0.0166, roughly sixteen times lower. It does not reach the floor. The
second check's prediction, that a hash would bring 16 by 6 to the floor, is therefore **half-true**: the
cliff softens, and the floor stays missed.

## Observation: 224 lines, 512 grid, hashed index

| sets | ways | total lines | row-major (rows) | row-major (own) | Morton (own) |
|---:|---:|---:|---:|---:|---:|
| 16 | 14 | 224 | 0.0094 | 0.0094 | 0.0030 |
| 8 | 28 | 224 | 0.0118 | 0.0118 | 0.0030 |
| 32 | 7 | 224 | 0.0091 | 0.0091 | 0.0030 |

The 512-grid cells also read above the floor of 0.0025 at every split. The 32 by 7 cell's Morton column is
the own-order reading, and its rows-order Morton reading is 0.0209.

## Two readings, read apart

**The seven-band floor does not survive a hashed set index at the tried splits.** The modulus result was
that every split at 112 reached 0.0025. Under the hash, no split at 112 does, and the same holds at 224
on the 512 grid. The capacity is the same in both models, so what changed is which lines share a set, and
the modulus result depended on that. This narrows the previous paper's claim from "the boundary holds under
set-associativity" to "the boundary holds under modulus-indexed set-associativity, at the tried splits."

**Morton's lead is unchanged by the hash.** At every row above, Morton's own-order sweep reads 0.0030 to
0.0034 and row-major reads 0.0060 to 0.0169. The hash moves row-major, not the Morton reading, which is
the part of the earlier result that the index does not touch.

## What this does not say

The hash is a single multiplicative hash. A different hash could land closer to the floor or further from
it, and no hash family was swept. The 512 grid was run at three splits, not a sweep. The set index is one
choice in a model with no prefetcher, no pseudo-LRU, no write traffic and no second level. Real caches
combine a hashed index with pseudo-LRU and often a second level, so no hardware claim follows.

The falsifier fired on the modulus-to-hash swap, and that is a result about the model. It says nothing
about whether row-major ever reaches its floor on a physical cache, which needs a counter this pier cannot
read (see the calibration notes in `diffuser-inner.md`).

## Falsifier for the next run

The next check is a sweep of hash seeds, or a second hash family, at the 112-line splits. The falsifier is
named now: if a seed reaches 0.0025 for every 112-line split, the hashed failure is a property of this hash,
and the seven-band claim survives as "for some index functions, not all." If no seed reaches the floor at
112 under any tried hash, the claim narrows to modulus indexing and this paper stands as its replacement.

## Confidence

**High** that, in this model, the modulus-indexed seven-band floor does not transfer to the one hash tried:
all four 112-line hashed cells read above the floor, and the falsifier clause fired on each.
**Medium** that the softened 96-line cliff reflects the hash spreading the 16-set stride, since the cell
moved by roughly sixteen times and the mechanism is consistent with it, but no second hash was run.
**Low** for any claim about real hardware, which this paper does not measure.
