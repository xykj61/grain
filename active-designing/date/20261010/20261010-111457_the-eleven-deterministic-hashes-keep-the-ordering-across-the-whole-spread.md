# The eleven deterministic hashes keep the ordering across the whole spread

**Status:** Design -- scratch-model reading; the pre-registered falsifier did not fire at any of the four set counts. The wider set spreads far more than the cluster did, so this is a between-family ordering, not a thin one.
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the five-family run [`20261010-095311`](20261010-095311_the-five-deterministic-hashes-order-the-cluster-with-no-random-map.md), whose next door was a wider deterministic family set at 13 to 16 sets, with the falsifier written before the run.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_eleven_det.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_eleven_det_24.txt`.

## What this asks

The five-family run removed both random maps and kept the ordering, but five families give only 10 pairs, so one discordant pair moved the reading by 0.2. This run widens the deterministic set. It adds the six structured families the ordering module already defines (fold, fib, xorshift32, knuth_top, lcg_high, xor_shift_line) to the five cluster members, giving eleven families and 55 pairs. Random families stay out of the coefficient. Modulus and stride5 are the controls.

## Falsifier, written before the run

Written at clock `20261010.100627`, before the run started, and recorded in the script's header:

For each set count S in {13, 14, 15, 16}, the Kendall tau-b between the eleven deterministic families' mean per-set reuse distance and their mean row-major miss rate must exceed 0.5. The falsifier fires if tau-b is at or below 0.5 at any of the four counts.

## Result

Tau-b, 55 pairs, 24 seeds per family:

| Sets | Tau-b | Concordant | Discordant |
|---|---|---|---|
| 13 | +0.96 | 54 | 1 |
| 14 | +1.00 | 55 | 0 |
| 15 | +0.96 | 54 | 1 |
| 16 | +0.96 | 54 | 1 |

The falsifier did not fire at any count. The controls, modulus and stride5, are excluded from the coefficient and sit at the bottom of both measures, as they should.

Spread, read from the summary lines at 13 sets: mean row-major miss rates run from 0.0315 (modulus, the control) to 0.1923 (fib). The five cluster families sit between 0.1494 and 0.1503, and the structured families span 0.0784 (lcg_high) to 0.1923 (fib). Mean per-set reuse distances run from 0.1289 to 0.3012.

## Reading

The ordering holds across families that differ widely in miss rate, not only across a tight cluster. One discordant pair out of 55 is the most a single pair can cost here, and the coefficient stays above 0.95 at three of four counts. The five-family thinness caveat no longer applies to this result, because the pair count is large and the spread is large.

Inference, kept separate: families whose row-major miss rate is high also show high mean reuse distance, so reuse distance tracks row-major miss across both tight and wide spreads. Projection: this is a statement about how these index functions interact with this one row-major traversal, not about hardware.

## Falsifier for the next claim

Next door: the same eleven-family sweep with a second traversal order, column-major, to see whether the ordering depends on the row-major stream. The falsifier must be written before that run. If tau-b at or below 0.5 at any count under column-major, the claim narrows to row-major traversal.

## Projection, with its falsifier

Horizon: the next scratch run at these set counts, not a hardware claim. Assumptions: the scratch model's row-major traversal, 24 seeds, and the chosen family set are representative of the model. Falsifier: tau-b at or below 0.5 at any of 13 to 16 sets under a traversal or family set not yet tried. Confidence: moderate that the sign holds in this model; low that it generalises beyond the model's own geometry.

Scope: scratch model only. No hardware claim is made.
