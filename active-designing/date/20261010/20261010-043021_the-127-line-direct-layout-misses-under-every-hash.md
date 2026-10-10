# The 127-line direct layout misses under every hash, and reaches the floor only under modulus

**Status:** Design -- scratch-model reading, falsifier fired on its own branch
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the busiest-set paper [`20261010-042111`](20261010-042111_the-busiest-set-at-one-hundred-twenty-six-lines.md), which named a 127-line layout run as its next door, and the fully associative paper [`20261010-041547`](20261010-041547_the-fully-associative-floor-reaches-at-one-hundred-twelve-lines.md) beneath it.
**Script:** `session-output/diffuser-stencil-r3/run_r3_direct_127x1.py` (scratch, untracked) -- **Output:** `session-output/diffuser-stencil-r3/run_256_r3_direct_127x1_24.txt`

## What this paper measures, in plain words

A cache holds a fixed number of lines. A layout decides which set each line goes to, and each set holds a few ways. This paper asks one question: when the cache holds 127 lines laid out as 127 sets with one way each (a direct-mapped cache), does a row-major sweep of a radius-three stencil reach the compulsory floor?

The compulsory floor is the lowest miss rate any cache can reach. It is the count of distinct lines touched divided by all accesses, here 0.0025 on the 256 grid. A layout that reaches it misses only on first touch. A layout that misses it also evicts lines it will need again.

## Why 127 needed a layout chosen first

127 is prime, so it has no power-of-two split. The earlier 127-line run used one set by 127 ways, which removes the index entirely and tests capacity alone. This run keeps an index and asks whether the index function matters at 127. The layout was chosen before the run: 127 sets, one way each, with the set taken as the hash modulo 127.

## The falsifier, written before the run

The header of the script carries it, stamped after the clock read `20261010.042701` and before the run started. It said: if fold, mix and fib each reach the compulsory floor on every seed, or each misses on every seed, the family-level split at 127 is not an index-function effect under this layout. The modulus control was named as a reference, not a test.

I want to flag a fault in that wording before reading the result. The "every seed misses" branch was written as evidence against an index effect. A uniform miss across hash families says nothing about whether the index matters, because the modulus control is a different index and it reaches the floor. The falsifier as written could not separate these cases. The result is read below on the terms the falsifier actually stated, and the wording's weakness is noted for the next run.

## Observation

Twenty-four seeds from the SplitMix64 generator at 20261010, row-major order, 256 grid, radius three, 127 sets by one way. Each row is one family.

| Family | Seeds reaching the floor | Row-major miss rate range | Compulsory floor |
|---|---|---|---|
| fold | 0 of 24 | 0.0030 to 0.0036 | 0.0025 |
| mix (bit-mix finalizer) | 0 of 24 | 0.0260 to 0.0294 | 0.0025 |
| fib (multiply-shift) | 0 of 24 | 0.0141 to 0.0340 | 0.0025 |
| modulus (line mod 127), control | 24 of 24 | 0.0025 to 0.0025 | 0.0025 |

Fold misses only mildly. Mix misses roughly ten times the floor. Fib misses across the widest range, from about six times to about fourteen times the floor, so its miss depends strongly on the seed.

## Inference

The falsifier's "all miss" branch fired for the three hash families: none of the 72 hash runs reached the floor. That was the branch the falsifier had called "not an index effect," and on its own terms the family-level split is not supported at this layout.

The modulus control reaches the floor on all 24 runs, so the index is not irrelevant at 127 lines. Under one way, every hash spreads consecutive lines unevenly across sets, and modulus spreads them perfectly. The miss tracks how the index function places neighboring lines, not which hash family it belongs to. Fold, mix and fib are three different families that all fail the same way.

This does not overturn the earlier readings. At 126 lines under 21 sets by 6 ways, the busiest-set paper found fold at seven lines per set and mix and fib at thirteen to seventeen. That layout gives each set six ways, so a modest overload is absorbed. A direct-mapped layout gives each set one way, so any overload evicts. The two runs are consistent: the hash penalty grows as ways shrink.

## Falsifier, read against the result

The falsifier fired on its "all miss" branch. The honest report is that the family-level question has an answer at this layout, and the answer is that no family separates from the others. Only the modulus index reaches the floor.

## Projection, with its falsifier

Horizon: the next scratch run, not a hardware claim.

Assumption: the busiest-set measure, computed over the live LRU set occupancy rather than the window count, tracks the miss rate under one way. The busiest-set paper named this as its follow-up and flagged that it needs its own falsifier.

Falsifier, written now and not yet run: if the per-set busiest occupancy under one way is at most one line for every hash family on every seed, while the hash miss rate still sits above the floor, then the conflict inference is wrong at one way and the miss has another cause.

Confidence: moderate on the observation (the table above is measured, 24 seeds per family), low on the mechanism (occupancy is not yet measured under one way, and the wording of the first falsifier was loose).

## What this does not reach

The scratch model is a fully counted LRU simulation over the radius-three diamond. It has no hardware counter behind it, and the calibration paper already shows the generic hardware miss counter reads a fraction of the fills on this guest. Nothing here is a claim about a real cache.

The reading also does not say which hash a real layout should use. It says that under one way, a plain modulus index keeps a stencil sweep at the floor on this model and the three hashes do not.

## Next door

1. **Busiest occupancy under one way.** Count the maximum live set occupancy per window for each family at 127 by 1, with the falsifier above written into the script header before the run.
2. **A tighter falsifier for the family question.** Replace the "all miss" branch with a test that separates the index from the family, such as a shuffled modulus control, so a uniform miss cannot pass as a null.

As a reference for those next steps, the compulsory floor here is 0.0025 by construction (distinct lines over accesses on the 256 grid), so every miss rate above it is a count, not an estimate.

May this small honest result stand in the room where it belongs: the layout question got an answer, and the answer was not the one the falsifier was built to catch.
