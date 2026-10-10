# The radius-three floor holds under set-associativity

**Status:** Research -- a fruit of the diffuser lane, one scratch model, one falsifier
**Room:** research for understanding -- no witness binds these numbers; the model is untracked
**Stamp:** `20261010.014913`
**Kin:** [the radius-three paper](20261010-014349_the-radius-three-stencil-moves-the-boundary-to-seven-bands.md) (fully associative, seven bands) -- [the radius-two set-associative paper](20261010-013718_the-set-associative-floor-follows-capacity-and-stride.md), whose method this run follows
**Scratch scripts:** `session-output/diffuser-stencil-r3/run_r3_setassoc.py` (gitignored, per seat; re-run with `python3 -I`). Outputs: `run_256_r3_setassoc.txt`, `run_256_r3_setassoc_below.txt`, `run_512_r3_setassoc.txt`.

## What this paper asks

The radius-three paper found that row-major reaches its compulsory miss floor at seven row bands:
112 lines on the 256 grid, 224 on the 512. That model was **fully associative**. The radius-two
set-associative paper found the five-band floor survives set-associativity once the total line
count is not forced to a power of two, but that a row stride of 16 lines can cause a conflict cliff
at 16 sets. The open question here is whether the seven-band boundary survives the same constraint.

## The falsifier, named before the decisive run

> **The seven-band boundary holds under set-associativity if, at 112 total lines on the 256 grid,
> row-major's radius-three miss rate reaches the compulsory floor of 0.0025 for every set-and-way
> split totalling 112.** It **fires** if any split totalling 112 leaves row-major above the floor,
> or if Morton's own-order lead below the floor disappears.

The 112-line splits were named before they were run. The below-floor run (96 lines) and the 512-grid
run (224 lines) were added after the first set, to read the Morton clause and the second grid. Those
two were not in the falsifier's original wording, so they are reported as a second check, not as
the decisive one.

## Observation: 112 lines, 256 grid, every split

Radius three (25-point diamond), N=256, LRU within each set. Compulsory floor 0.0025 (distinct lines
over accesses). Own-order is the Morton sweep; rows-order is the row sweep.

| sets | ways | total lines | row-major (rows) | row-major (own) | Morton (own) |
|---:|---:|---:|---:|---:|---:|
| 16 | 7 | 112 | 0.0025 | 0.0025 | 0.0033 |
| 8 | 14 | 112 | 0.0025 | 0.0025 | 0.0031 |
| 4 | 28 | 112 | 0.0025 | 0.0025 | 0.0033 |
| 14 | 8 | 112 | 0.0025 | 0.0025 | 0.0033 |

Every split reaches the floor. The falsifier's first clause does not fire.

## Observation: the below-floor and 512 checks

At 96 lines on the 256 grid, row-major is above the floor, and the split decides how far:

| sets | ways | total lines | row-major (rows) | Morton (own) |
|---:|---:|---:|---:|---:|
| 16 | 6 | 96 | 0.2611 | 0.0035 |
| 8 | 12 | 96 | 0.0071 | 0.0033 |

On the 512 grid at 224 lines, all three splits reach the floor (row-major 0.0025 in every row-major
cell), and Morton's own-order reading sits at 0.0030 to 0.0031 for the same splits.

Morton leads below the floor at every size checked, so the falsifier's second clause does not fire.

## Two readings, read apart

**The seven-band boundary survives set-associativity at every split tried.** Row-major's floor
lands at seven bands for 16 sets by 7 ways, 8 by 14, 4 by 28, 14 by 8, and on the 512 grid for 16
by 14, 8 by 28 and 32 by 7. No split of the 112 or 224 totals failed.

**The 16-set, 6-way cell at 96 lines is the conflict cliff again, and it is the same stride.** At
N=256 a row starts on a line index that is a multiple of 16, so with 16 sets every row's first line
lands in one set. Six ways then hold fewer than five row bands' worth of the stencil's rows, and the
row-major miss rate sits at 0.2611. The 8-by-12 split at the same total reads 0.0071, because the
stride spreads across eight sets. This is the radius-two cliff, one radius over, and it confirms that
the stride is the mechanism at this radius too: the conflict is a property of how many sets share the
row starts, not of the capacity.

## What this does not say

The model is one LRU set-associative cache with power-of-two stride from N. It has no prefetcher,
no replacement policy other than LRU, no write traffic, and no second level. Real caches use
pseudo-LRU and hash their set index. A hashed index would spread the 16-set cliff, and a prefetcher
would change the compulsory reading for the row sweep. Neither is modeled here.

The 96-line reading is one cell, one stride. The boundary between 96 and 112 is not sampled, so the
seven-band claim is "holds at 112 and 224, and fails at 96 for one split," not "the exact floor is
112 for every cache."

## Falsifier for this paper's own read

The next split to test is a hashed set index (the set chosen by a multiplicative hash of the line
number rather than `line % sets`). If row-major still reaches the floor at 96 lines for the 16-set,
6-way split under a hash, the conflict cliff is a property of the modulus, not of the boundary, and
this paper's stride reading is narrowed. If it does not, the stride reading stands.

## Confidence

**High** that the seven-band floor holds for the modulus-indexed set-associative model at the tried
splits: all fourteen row-major cells at 112 and 224 lines reach the printed floor, and no falsifier clause fired. **Medium**
that the conflict cliff is mainly stride: one cliff cell, and the hash test is named and not run.
**Low** for any claim about real hardware, which this paper does not measure.
