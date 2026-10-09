# The live budget bounds the footprint at k times live, roughly

**Stamp:** `20261009.162216`
**Status:** Vision -- a simulation of allocation bytes, not a timing witness and not a measurement on metal
**Room:** vision
**Kin:** [`20261009-161337_the-byte-threshold-holds-the-budget-not-the-frontier.md`](20261009-161337_the-byte-threshold-holds-the-budget-not-the-frontier.md) (the constant-budget paper this one answers) - [`20261009-160733_the-clear-cadence-bounds-the-footprint.md`](20261009-160733_the-clear-cadence-bounds-the-footprint.md)

The prior paper named its next falsifier and left it unrun: a budget set once, as k times the live set
measured at the start, drifts away from the working set when the size mix changes. The prediction
written before the run was that a budget tracking k times the measured live set holds the bound at k
times that live set, and that copy traffic rises wherever the live set rises fastest. This paper runs it.
The first part of the prediction held. The second part held only roughly: the bound overshoots k by
about ten percent against the live set at the moment of the peak.

## What was run

A scratch probe in `.lap/clear/live_budget_probe.py`, run under `python3 -I` and deleted with the lap.
The model is the one the prior paper used: a bump allocator, 200 slots, 20 fast at a replacement
probability of 1/10 per step and 180 slow at 1/10000, seed `20261009`, 100,000 steps. A clear resets the
bump offset and re-copies every live block once at the new offset.

Two size mixes, and one shift between them. Steps 0 to 49,999 use a uniform 64-byte mix. Steps 50,000 to
99,999 use a log-uniform 16 to 4,096 byte mix. The shift is the new condition: the prior paper ran one
mix at a time.

Two budget rules, each at k = 4 and k = 8:

- **Constant:** budget = k times the live bytes at the start, held fixed. This is the prior paper's rule.
- **Tracked:** budget = k times an exponentially weighted average of live bytes, with a window of about
  1,000 steps, updated each step.

A clear fires just before an allocation that would carry the offset past the current budget. An
over-budget count is an allocation that still exceeds its budget after the clear.

## Observation

Steady run (no shift), the uniform mix throughout:

| Rule | k | Ratio | Clears | Copy bytes per step |
|---|---|---|---|---|
| Constant | 4 | 4.00 | 336 | 42.8 |
| Tracked | 4 | 4.00 | 336 | 42.8 |
| Constant | 8 | 8.00 | 144 | 18.3 |
| Tracked | 8 | 8.00 | 144 | 18.3 |

The steady arms agree with each other and with the prior paper's threshold rows for the same k. A
tracked budget has nothing to track while the mix is still, so this is the expected baseline.

Shift run (uniform to log-uniform at step 50,000). Ratio is high-water bytes over mean live bytes for the
whole run, with the phase-one and phase-two ratios computed against each phase's own mean live bytes:

| Rule | k | Ratio, whole run | Phase 1 | Phase 2 | Over-budget allocations | Clears | Copy bytes per step |
|---|---|---|---|---|---|---|---|
| Constant | 4 | 2.55 | 4.00 | 1.41 | 96,802 | 97,418 | 124,097.4 |
| Tracked | 4 | 9.11 | 4.00 | 5.02 | 0 | 433 | 283.8 |
| Constant | 8 | 2.55 | 8.00 | 1.41 | 79,403 | 80,662 | 111,640.3 |
| Tracked | 8 | 18.26 | 8.00 | 10.07 | 0 | 181 | 120.0 |

The constant budget fails in the way the prediction named. After the shift its budget sits far below the
new working set, so almost every allocation is over budget, and the clear fires on nearly every step
(about 97,000 clears in 100,000 steps). Its low phase-two ratio is not a success: it reads low because the
bound is not holding the footprint at all.

The tracked budget holds with zero over-budget allocations in both phases, at a fraction of the copy
traffic (283.8 against 124,097.4 bytes per step at k = 4).

Denominator check. Phase two's ratio of 5.02 is measured against that phase's mean live set, which is
rising through the phase. A rising live set makes the late peaks look larger against a lower mean. So a
second pass measured the peak against the live set at the same step, phase two only:

| k | Max of offset over instantaneous live | At step |
|---|---|---|
| 4 | 4.41 | 84,041 |
| 8 | 8.93 | 54,588 |

## Inference

The constant budget does not survive a change of mix. A budget fixed at the start of a run is a bound
for the mix it was measured on, and the prior paper's zero over-budget counts described only those
budgets. This is the failure the falsifier named, and it fired.

The tracked budget keeps the bound close to k times the live set. Against the instantaneous live set,
the peak reaches 4.41 times at k = 4 and 8.93 times at k = 8. So the overshoot is about ten percent of k,
and it is not zero. I read it as two causes that the model does not separate. First, the average lags
the live set by roughly the window's length, so the budget sits a little low while the live set rises.
Second, a single allocation can be as large as 4,096 bytes, and the clear rule admits it whenever it fits
the budget, so the offset can finish one block past the budget.

The prediction said the bound stays at k times the measured live set. Read strictly, it held only to
within about ten percent. The copy-traffic part of the prediction held: copy traffic was far lower under
the tracked rule, and it did rise in phase two, where the live set rose.

## Projection

Horizon: this model, the two size mixes, one shift of mix, 200 slots, and the replacement rates named
above. A `Region` on metal could differ in alignment, allocator metadata, the window a caller can afford,
and whether its live set moves smoothly or in steps.

Assumptions: the bump model charges bytes only, so the ten percent overshoot is a byte-count result and
not a timing one. The live set moves gradually because slow slots turn over only about once in ten
thousand steps; a workload that replaced its whole working set at once would move the live set in one
jump and could beat the window.

Falsifier, sharpened. A `Region` under a live-tracked clear whose high-water mark exceeds k times its
instantaneous live set by more than the largest single allocation, over a workload whose live set
changes. A second falsifier: a tracked-budget arm that accrues more copy traffic than the constant-budget
arm at equal over-budget counts, on a workload this model does not cover.

Confidence: high that a constant budget fails under a mix shift, since the over-budget count is large
and direct. Moderate that the tracked budget holds at about k times the live set on a real allocator,
since the model omits what a real allocator adds. Low that the window of about 1,000 steps is the right
choice for any workload other than this one.

## What the run does not show

The run measures bytes only. Wall-clock time is unmeasured, so whether a tracked clear costs more time
than a constant clear is open, and the copy-traffic column stands in for that cost and says so.

The window length was chosen once, at about 1,000 steps, and not swept. A shorter window would track
faster and overshoot less during a rise, at the price of noisier budgets. This paper does not measure that
trade-off.

## Grade

Graded A/90 at Field by `sh tools/fixtures/q/qa_report_card.sh <this page> --setting field --service 85`:
register 75 (25 percent negative sentences, under the 30 percent Field ceiling), reach 100, truth 100
counted, service 85 judged. The counted truth half is the only half the card read; service stays a
judgment. No new witness and no new module. The scratch probe was written to `.lap/clear/`, run twice
(once for the shift table, once for the denominator check), and deleted before the lap ends.
