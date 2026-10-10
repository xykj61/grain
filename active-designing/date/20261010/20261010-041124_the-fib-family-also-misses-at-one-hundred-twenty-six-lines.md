# The Fibonacci-hash family also misses the floor at 126 lines, so the 126 miss holds across three index families

**Status:** Research -- a fruit of the diffuser lane, one scratch sweep at 21 sets by 6 ways under a third index family, falsifier written before the run
**Room:** checkable -- the fruit names its scratch script and output file; both reproduce on this pier, though the scratch sits in an untracked, gitignored folder
**Date:** 2026-10-10 (stamp `20261010.041124`; the scratch header carries the clock read `20261010.041058`)
**Scope:** the scratch model only, with no hardware claim
**Lineage:** the bit-mix paper [`20261010-040441`](20261010-040441_the-mix-family-misses-at-one-hundred-twenty-six-lines.md) named a third index family at 126 lines as one of its two next doors, beside a 127-line layout

## What this paper asks

The fold family and the bit-mix family both miss the compulsory floor at 126 lines, on all 24 seeds each. Two families is still a small sample of index functions. Both use the modulus on a non-power-of-two set count, so the open question was whether a structurally different index reaches the floor at this capacity. This paper runs a multiplicative Fibonacci hash at the same 126 lines and asks whether it does.

## Setup

- **Model, stencil, grid, and order:** unchanged from the earlier papers. A 256 grid, a radius-three diamond of 25 points, row-major visit order, and a set-associative LRU cache in a scratch model. The compulsory floor is 0.0025.
- **Layout:** 21 sets by 6 ways, so 126 lines, the same layout as the fold and mix runs.
- **Index family:** `fib(line, seed)` takes `((line XOR seed) * 0x9E3779B1) mod 2^32`, shifts it right by 16, and the set index is that value modulo 21. The multiply-shift form differs in structure from the fold's xorshift and the mix's two multiply-xorshift rounds.
- **Seeds:** 24 seeds from the SplitMix64 stream at 20261010, the same stream the fold and mix runs used.
- **Script:** `session-output/diffuser-stencil-r3/run_r3_fib_21x6.py`, which imports the model from `run_r3_mix.py`. **Output:** `session-output/diffuser-stencil-r3/run_256_r3_fib_21x6_24.txt`, 24 lines, run under `python3 -I`, exit 0.

## Order note

The script's header was written after the clock read `20261010.041058` and before any output was read. The falsifier below is the text in that header.

## Falsifier, written before the run

- **Falsifier:** fib reaches the compulsory floor (0.0025) at 126 lines on every seed. That would place the 126 miss in the modulus families, and the window's lower bound would then be an index-function property for those two only.
- **Miss branch:** fib misses the floor on every seed. The 126 miss holds across all three index families, the miss reads as a capacity property of this model, and the lower bound stays at 127 to 128.
- **Mixed branch:** some seeds reach and some miss. The 126 point is reported as seed-dependent for fib, and the window is not moved by this run.

## Result, read at `20261010.041124`

- **Seeds reaching the floor:** 0 of 24.
- **Row-major miss rate:** 0.0060 to 0.0076 against the 0.0025 floor, across 24 seeds. The lowest value, 0.0060, is 2.4 times the floor.
- **Falsifier branch:** the miss branch. Every seed misses, so the falsifier's first branch did not fire, and the miss branch did.

**Establishes, on this model:** three structurally different index functions, fold, bit-mix, and multiply-shift Fibonacci, each miss the compulsory floor at 126 lines under 21 by 6 on all 24 seeds. The 126 miss therefore does not belong to any one index function tested, and this scratch model reads it as a capacity property at this layout.

**Also visible, and not claimed as a finding:** the three families sit at different margins over the floor at 126 lines. Fold reads near 0.0031, fib 0.0060 to 0.0076, and mix near 0.0086. The index function changes the size of the miss, and this run does not say why one family sits closer than another.

**Does not establish:** a threshold at exactly 127, since the 127-line point has not been run. Nor does it establish that every index function misses at this capacity. Three functions is a small sample, and all three use the same LRU, the same stencil, and the same visit order. A replacement policy or a visit order other than row-major could move the result.

## Confidence

- **High** that, on this scratch model with this seed stream, the multiply-shift Fibonacci family misses the floor at 126 lines under 21 by 6, on all 24 seeds. The margin is wide: the lowest fib rate, 0.0060, is 2.4 times the floor.
- **Moderate** that the 126 miss is a capacity property rather than a property of the three index functions. Every family was run in one layout, so a layout effect is not yet ruled out.
- **Low** that the same window holds under a real replacement policy, since this run uses LRU in a scratch model with one stencil and one visit order.

## What would kill this

The reading that the 126 miss is a capacity property would fall if a fourth index function reached the floor at 126 lines on some seed, or if the 127-line layout reached the floor for all three families, since that would place the threshold at 127 and show the 126 point was a layout artifact. Neither has been run.

## Next door

One candidate, not run here:

1. A 127-line run, which still needs a layout with a clean way count. No clean power-of-two split exists at 127, so the paper does not name one as settled. The falsifier has to be written before the layout is chosen.

The next lap should write that falsifier before any sweep. The run stays inside the scratch model and needs no word from Keaton.
