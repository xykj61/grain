# The five deterministic hashes keep the ordering with no random map at all

**Status:** Design -- scratch-model reading; the pre-registered falsifier did not fire at any of the four set counts, and the reading is thin (five families, 10 pairs, a spread of a few parts in a thousand)
**Room:** research for understanding (scratch model only, no hardware)
**Lineage:** the six-family rerun [`20261010-084906`](20261010-084906_the-six-hash-ordering-holds-without-the-null-at-thirteen-to-sixteen-sets.md), whose next door was to drop random unbalanced as well, leaving five deterministic families, with the falsifier written before the run.
**Script:** `session-output/diffuser-stencil-r3/run_r3_reuse_sweep_five_det.py` (scratch, untracked, per seat). Output: `session-output/diffuser-stencil-r3/run_256_r3_reuse_sweep_five_det_24.txt`.

## What this asks

The six-family result kept the ordering with random balanced removed from the coefficient, but random unbalanced stayed in. So a second random map still sat inside the statistic. This paper removes both random families and asks whether the per-set reuse distance still orders the row-major miss rates across the five deterministic hash families alone, at 13, 14, 15 and 16 sets by one way.

Observation: the five families are mix, fmix32_alt, oat, splitmix64_low and fmix64_low. Five families give 10 pairs, so the coefficient carries less weight than the six-family one, which gave 15.

## Falsifier, written before the run

Written at clock `20261010.091252`, before the run started at `20261010.091301`, and recorded in the script's header:

For each set count S in {13, 14, 15, 16}, the Kendall tau-b between the five deterministic families' mean per-set reuse distance and their mean row-major miss rate must exceed 0.5. The falsifier fires if tau-b is at or below 0.5 at any of the four counts. The claim "the ordering needs no random map at all" needs all four.

## Result

Tau-b, with 10 pairs, no ties, and 24 seeds per family:

| Sets | Tau-b | Concordant | Discordant |
|---|---|---|---|
| 13 | +0.80 | 9 | 1 |
| 14 | +1.00 | 10 | 0 |
| 15 | +0.80 | 9 | 1 |
| 16 | +1.00 | 10 | 0 |

The falsifier did not fire at any count. The controls, modulus and stride5, sit far below the cluster on both measures, as they should, since neither is in the coefficient.

Scope of the cluster's spread, read from the summary lines: at 13 sets the five families' mean row-major miss rates span 0.1494 to 0.1503, a range of 0.0009 absolute, or about six parts in a thousand of the mean. Their mean reuse distances span 0.2942 to 0.2954. The spread is that narrow at every count.

## Reading

The ordering that survives is real in the sense that the pre-registered sign held at every count, with random maps removed. It is also thin. Five families give 10 pairs, so one discordant pair moves tau-b by 0.2, and the 13- and 15-set readings each carry one discordant pair. The coefficient reads a sign, not an effect size, and the paper says so before anything else. A flip of one pair decides the 0.8 readings, so a reader should not take them as a measured strength of association.

Inference, kept separate: the deterministic families rank in the same order on both measures, so the rank agreement is not produced by a random map. Projection: the same sign on a larger family set would be stronger evidence than five families can give.

## Falsifier for the next claim

Next door, unchanged from the earlier papers: a set-count sweep over more deterministic families at 13 to 16 sets, with the falsifier written before the run, to see whether the sign survives once the pair count rises past 10. If a wider deterministic set fails tau-b above 0.5 at any count, the claim that the ordering needs no random map narrows to the five families measured here.

## Projection, with its falsifier

Horizon: the next scratch run at these set counts, not a hardware claim. Assumptions: the scratch model's row-major traversal and the 24-seed set are representative of the model, which is itself one traversal. Falsifier: tau-b at or below 0.5 at any of 13 to 16 sets over a wider deterministic family set. Confidence: moderate that the sign holds in this model; low that it means more than the model's own geometry.

Scope: scratch model only. No hardware claim is made.
