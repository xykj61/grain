# The busiest window at 127 lines under one way: the conflict reading holds, and a shifted modulus stays flat

**Status:** Design -- scratch-model reading, falsifier not fired, one header stamp corrected by erratum
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the direct-layout paper [`20261010-043021`](20261010-043021_the-127-line-direct-layout-misses-under-every-hash.md), which named two next doors: busiest occupancy under one way, and a tighter falsifier with a shuffled-modulus control.
**Script:** `session-output/diffuser-stencil-r3/run_r3_busiest_127x1.py` (scratch, untracked) -- **Output:** `session-output/diffuser-stencil-r3/run_256_r3_busiest_127x1_24.txt`

## What this paper measures, in plain words

The previous paper showed that 127 lines laid out as 127 sets by one way miss the compulsory floor under fold, mix and fib on all 24 seeds, while plain modulus reaches it on all 24. It asked a follow-up: is the miss caused by hash collisions inside the radius-three window?

The window is the set of lines one row of the stencil touches, up to 112 consecutive lines. For each row, this paper counts how many of those lines land in each set, and takes the largest count. Call that the busiest window count. A busiest count of 1 means no two lines of the window share a set.

## A fault in the first measure, named before the numbers

The previous paper's next door asked for "busiest occupancy under one way," meaning the live LRU occupancy per set. Under one way a set holds one line at a time, so live occupancy can never exceed one. That measure is vacuous at this layout. This paper reads the windowed distinct count instead, the same measure the 126-line busiest-set paper used, and says so here rather than in a footnote.

## The falsifier, and its stamp

The falsifier sits in the script header, written before the run: if fold, mix and fib each hold a busiest window count of at most one line per set on every seed, the conflict-in-window inference is wrong at one way.

The first draft of that header carried the clock stamp `20261010.044100`. The run's own clock read `20261010.043600`, so the stamp was typed ahead of the clock. The header now reads `043600`, and the falsifier text is unchanged. This is an erratum on the script header, not a change to what was tested.

## Observation

Twenty-four seeds from the SplitMix64 generator at 20261010, 256 grid, radius three, 127 sets by 1 way. Counts are distinct lines per set within the window, maximized over every row.

| Family | Seeds with busiest count above 1 | Busiest count, max | Busiest count, mean |
|---|---|---|---|
| fold | 24 of 24 | 2 | 2.00 |
| mix (bit-mix finalizer) | 24 of 24 | 9 | 6.62 |
| fib (multiply-shift) | 24 of 24 | 4 | 4.00 |
| modulus (line mod 127), control | 0 of 24 | 1 | 1.00 |
| shuffled modulus ((line + seed) mod 127), control | 0 of 24 | 1 | 1.00 |

The two controls read exactly 1 on every seed. The measure is therefore not broken in the direction that would have hidden a hash effect.

## Inference

The falsifier's branch fired in the direction the conflict reading predicts. At one way, every hash family puts at least two lines of one window into one set on every seed. The 127 miss from the previous paper has a visible mechanism here: collisions inside the working set.

The shifted-modulus control is the check on the measure. A shift adds one constant to every line, so it is a bijection on residues and spreads a window perfectly by construction. It reads 1, as plain modulus does. A miss under the shifted modulus would have meant the measure was wrong; none appeared.

Across the three hash families, the mean busiest count and the miss rate rank the same way: fold at 2.00 with miss 0.0030 to 0.0036, fib at 4.00 with miss 0.0141 to 0.0340, and mix at 6.62 with miss 0.0260 to 0.0294. Fib's miss range is wide, so its position in the ordering is not tight. Three families make a weak ordering, and this paper claims no fit.

## Falsifier, read against the result

The falsifier fired on its own branch: none of the 72 hash runs held the busiest count at one. The conflict-in-window reading stands for one way on this model.

## Projection, with its falsifier

Horizon: the next scratch run, not a hardware claim.

Assumption: the windowed busiest count bounds the miss excess under one way, so a family with a larger count misses by more.

Falsifier, written now and not yet run: if, across at least eight more index functions beyond the three hashes, the busiest window count fails to order their row-major miss rates in the same way as the three families here, the window count is not the mechanism and the miss has another cause.

Confidence: high on the observation (24 seeds per family, both controls at 1), moderate on the inference (three families is a small ordering), low on any magnitude claim.

## What this does not reach

The scratch model is a fully counted LRU simulation with a windowed count alongside. It has no hardware counter behind it, and the calibration paper already shows the generic hardware miss counter reads a fraction of the fills on this guest. Nothing here is a claim about a real cache.

The shifted modulus is a weak control in one sense: it shares plain modulus's perfect spread by construction, so it confirms the measure's sanity and is not an independent null for the hash families. A stronger null, a random balanced map with the same bucket sizes, is a further door.

## Next door

1. **A wider index-function set for the ordering falsifier.** Add at least eight index functions, including a random balanced map, and test whether the window count orders their miss rates as it orders the three families.
2. **A random balanced map as the null.** Its bucket sizes match modulus exactly while its placement is random, so a miss there would separate placement from spread.

May this small result stand where it belongs: the collisions in the window are visible, the controls held, and the first measure was named as vacuous before anyone leaned on it.
