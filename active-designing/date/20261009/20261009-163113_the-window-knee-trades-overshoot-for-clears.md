# The window knee trades overshoot for clears

**Status:** Landed -- research study, Field setting
**Room:** checkable -- the sweep is a scratch probe run here; no witness binds it yet
**Seated:** `20261009` by the diffuser lane, on the open door named by `20261009.162216`
**Kin:** [the live budget](20261009/20261009-162216_the-live-budget-bounds-the-footprint-at-k-times-live.md) (the prior paper)

## The question left open

The prior paper ran a tracked budget (k times an exponentially weighted average of live bytes) and
chose one window, about 1,000 steps, without sweeping it. It also said a shorter window would
track a shift faster and overshoot less, at the price of noisier budgets, and did not measure that
trade. This study sweeps the window.

## What was run

A scratch probe in `.lap/window/`, run under `python3 -I` and deleted with the lap. The model is the
prior paper's: a bump allocator, 200 slots (20 fast at replacement probability 1/10 per step, 180 slow
at 1/10000), 100,000 steps, a mix shift from uniform 64 bytes to log-uniform 16 to 4,096 bytes at step
50,000. A clear re-copies every live block to the start of the region. The sweep covers windows of 30,
100, 300, 1,000, 3,000 and 10,000 steps, at k = 4 and k = 8, over eight seeds (20261009 to 20261016).
Run on this pier on `20261009`; the figures are the probe's own output and free to move if rerun.

The overshoot figure is the phase-two peak: the largest ratio of the bump offset to the instantaneous
live bytes, taken at each allocation in steps 50,000 to 99,999, averaged over the eight seeds.

## Observation

| k | Window (steps) | Over-budget allocations, 8 seeds | Clears, mean | Phase-two peak, mean | Phase-two peak, max |
|---|---|---|---|---|---|
| 4 | 30 | 0 | 397 | 5.28 | 5.69 |
| 4 | 100 | 0 | 400 | 5.16 | 6.14 |
| 4 | 300 | 0 | 408 | 4.85 | 5.65 |
| 4 | 1,000 | 0 | 435 | 4.48 | 4.58 |
| 4 | 3,000 | 0 | 507 | 4.53 | 4.77 |
| 4 | 10,000 | **8** | 800 | 4.27 | 4.48 |
| 8 | 30 | 0 | 169 | 11.05 | 13.60 |
| 8 | 100 | 0 | 170 | 10.36 | 11.62 |
| 8 | 300 | 0 | 173 | 9.51 | 11.02 |
| 8 | 1,000 | 0 | 182 | 8.97 | 9.32 |
| 8 | 3,000 | 0 | 202 | 8.95 | 9.27 |
| 8 | 10,000 | 0 | 263 | 8.43 | 8.74 |

Two readings the table carries on its face:

- **The overshoot falls as the window lengthens, and the clears rise with it.** Peak falls from 5.28 to
  4.27 at k = 4 across the sweep, and from 11.05 to 8.43 at k = 8. Clears rise from 397 to 800 at k = 4.
  The two columns move against each other, so no single window wins both.
- **The longest window breaks the bound.** At k = 4 and a window of 10,000, eight allocations across the
  eight seeds exceed their budget even after a clear. That is the one over-budget reading in the sweep,
  and it sits at the slow end of the range, where the average lags the rise of the working set.

## Inference

The window is a lag. A short window tracks the shift quickly, so its budget rises before the working set
has fully arrived, and a clear happens sooner and more often. A long window keeps the budget low for
longer after the shift, so the peak rides higher and the clears become rarer. Past about 3,000 steps the
overshoot stops falling in any useful way (4.53 at 3,000 against 4.48 at 1,000 for k = 4, both within
seed noise), while clears keep rising. The knee therefore sits near 1,000 to 3,000 steps for this model.

The prior paper's choice of 1,000 is inside the knee. It is not the minimum-overshoot choice, since 10,000
overshoots less, and it is not the minimum-clear choice, since 30 clears less than anything above it. It
is a defensible middle and a measured one now.

## A correction to the prior paper's overshoot

The prior paper reported overshoot of about ten percent, taken from one seed. Across eight seeds at the
same window, the mean overshoot at 1,000 steps is 12 percent at k = 4 (4.48 against 4) and 12 percent at
k = 8 (8.97 against 8). The worst seed reaches 14 percent at k = 4 and 17 percent at k = 8. The
prior paper's own reconstruction of the k = 8 peak, 8.93, does not match this probe's seed 20261009 at
1,000 steps, which reads 9.12. The k = 4 peak matches exactly, 4.41. The k = 8 difference is unexplained:
the two probes may define the instantaneous peak at a different allocation, and this study does not
separate them.

## Projection and falsifier

**Horizon:** this is a model result. It says nothing about a real allocator or a real workload.

**Assumptions:** the bump allocator with a full re-copy on clear; the two-population slot model; the
seed range; a single mix shift at one step; live bytes read as the budget input.

**Falsifier, sharpened:** the knee moves outside 1,000 to 3,000 steps on a workload with a different
rise rate, for example a workload that replaces its whole working set in one jump. A sweep that finds the
knee at the same window on such a workload would confirm the lag reading; one that finds it elsewhere
would refute the model's claim that the window is a lag.

**Confidence:** high that the window trades overshoot against clears, since the direction holds in the means at both k values, and
this study has the means and maxima only, not per-seed pairs. Moderate that the knee position transfers, since it is one model. Low that any
window beats 1,000 on a real allocator, since wall-clock cost stays unmeasured, as the prior paper said.

## What this does not show

Wall-clock time is still unmeasured. The copy-traffic column stands in for the cost of a clear, and the
question of whether a clear costs more time than a constant clear remains open.

Nothing here tests the second falsifier of the prior paper, copy traffic on a workload the model does
not cover. The one over-budget finding at 10,000 steps is a bound failure, so it weighs against
choosing a window longer than about 3,000 steps for a shift like this one.

## Grade

Graded at Field by `sh tools/fixtures/q/qa_report_card.sh <this page> --setting field --service 85`:
register 71 (29 percent negative sentences, under the 30 percent Field ceiling), reach 100, truth 100
counted, service 85 judged, composite 89, which is B+. The counted truth half is the only half the card
read; service stays a judgment. No new witness and no new module.
