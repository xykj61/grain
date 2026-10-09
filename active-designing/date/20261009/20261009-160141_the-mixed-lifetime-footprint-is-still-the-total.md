# The mixed-lifetime footprint is still the total

**Status:** Landed -- self-generated diffuser fruit, Field setting
**Room:** vision -- a simulation of allocation bytes, not a timing witness and not a measurement on metal
**Seated:** `20261009.160141`
**Kin:** [the region's footprint is the allocation total](20261009-155522_the-region-footprint-is-the-allocation-total.md) - [the mixed-lifetime cost is space, not time](../20261003/20261003-102318_the-mixed-lifetime-cost-is-space-not-time.md) - [`tally/region.rye`](../../../tally/region.rye)

The prior paper left one falsifier open: a workload where most blocks outlive a clear window, with
a small fraction turning over fast. Its named probe was 90 percent of slots at a replacement
probability of one in 10,000 per step, and 10 percent at one in 10. This paper runs that probe.
Its prediction, written before the run: the ratio of region bytes to live bytes stays large, because
the fast slots alone drive the total.

## The probe

- **Observation.** 200 live slots. At each step, every slot independently replaces its block with
  probability `p`, where `p` is `1/10` for the 20 fast slots and `1/10000` for the 180 slow ones.
  Replaced blocks are abandoned, never reused, as in the prior model.
- **Sizes.** The same two mixes as the prior paper: `uniform_64`, and `mixed_log16_4096`, a
  log-uniform draw between 16 and 4,096 bytes.
- **Seed.** `20261009`, fixed. The probe runs under `python3 -I`.
- **Scope.** Bytes only. No time, no allocator metadata, no alignment padding, no clear.
- **Cross-check.** The same code path with every slot at `p = 1/200` reproduces the prior paper's
  uniform row: 500.12 here against 501 there at 100,000 steps. The per-slot Bernoulli form
  matches the prior model in expectation, though its random stream differs.

The probe was written to `.lap/mixed/probe.py`, a gitignored scratch room, and deleted after the run.
The run took 6.6 seconds on this host.

## The readings

Measured by simulation on `20261009.160141`, Python 3, seed `20261009`. Columns: region bytes is
the total the bump region has claimed; live bytes is the sum of the current blocks at the end;
replacements is the number of block turnovers across all slots.

| Arm | Steps | Region bytes | Live bytes | Replacements | Ratio |
|---|---|---|---|---|---|
| uniform 64, all slots at 1/200 | 1,000 | 77,312 | 12,800 | 1,008 | 6.04 |
| uniform 64, all slots at 1/200 | 10,000 | 640,128 | 12,800 | 9,802 | 50.01 |
| uniform 64, all slots at 1/200 | 100,000 | 6,401,536 | 12,800 | 99,824 | 500.12 |
| mixed 16-4096, all slots at 1/200 | 1,000 | 875,864 | 188,619 | 1,016 | 4.64 |
| mixed 16-4096, all slots at 1/200 | 10,000 | 7,527,880 | 170,279 | 9,805 | 44.21 |
| mixed 16-4096, all slots at 1/200 | 100,000 | 73,826,296 | 147,375 | 99,818 | 500.94 |
| mixed 16-4096, 90/10 lifetimes | 1,000 | 1,567,987 | 130,272 | 2,001 | 12.04 |
| mixed 16-4096, 90/10 lifetimes | 10,000 | 14,957,009 | 155,885 | 20,125 | 95.95 |
| mixed 16-4096, 90/10 lifetimes | 100,000 | 148,661,682 | 155,088 | 202,299 | 958.56 |

## What the readings say

**Observation.** In the 90/10 arm, region bytes rise with the number of replacements, and live bytes
stay near 130,000 to 156,000 bytes from 1,000 steps on. The ratio runs to 958.56 at 100,000 steps.
The arm produced 202,299 replacements in that run.

**Inference.** The fast slots carry the total. Their expected replacement count is 20 slots times
`1/10` per step, which is 2 per step, or 200,000 over 100,000 steps. The slow slots add about 1,800
expected over the same run, and the measured total of 202,299 is consistent with that split. The
slow slots are not idle: at one replacement per 10,000 steps, each one turns over about ten times in
a 100,000-step run. Their blocks live about 10,000 steps, so they outlive a clear window shorter
than that, and no longer than that.

**Inference, the comparison.** The 90/10 arm's total is about twice the all-churn arm's total at
100,000 steps (202,299 against 99,818 replacements). The reason is the mean rate: the 90/10 mix
averages about `0.1 x 0.1 + 0.9 x 0.0001 = 0.01009` replacements per slot per step, while the
all-churn arm uses `1/200 = 0.005`. The ratio is near 958 rather than near 500 because the workload
churns harder on average, not because a longer-lived majority behaves differently in the region.

**Projection, one step out.** A region serving any mix of lifetimes spends bytes in proportion to its
replacement total, until a caller clears it. The footprint law from the prior paper holds across
this lifetime mix, and the only thing that moves it is the rate of turnover and the size mix.

## The falsifier, read against the reading

The falsifier was: a workload where most blocks outlive a clear window, with a small fraction turning
over fast, shows a region footprint that stays within a small constant of live bytes. The reading
does not show that. At 100,000 steps the footprint is 958.56 times live bytes, which is not a small
constant. **The falsifier did not fire, and the linear-in-replacements projection stands for this
mix.** The prediction written before the run held.

**What the falsifier did not test.** The probe's "outlive a clear window" condition depends on the
window's length. This run has no clear, so the window is the whole run, and the slow slots' blocks
live about 10,000 steps, which is inside that window. A workload where the slow blocks outlive a
window of 100,000 steps is a different probe. Under that shape the slow slots would stay pinned
for the window, and the footprint would come from the fast slots alone, which this run already
measured at about 200,000 replacements. The reading here is the no-clear case only.

## What this does not show

**Time is not measured.** The time half of the falsifier stays separate, as the prior papers
argued it should be.

**Only one mix ratio.** The 90/10 split and the 1/10 and 1/10000 rates are the prior paper's named
values. Other splits, such as 50/50 or 99/1, are not run. A small fraction of fast slots drove the
result here, and a different fraction would change the constant.

**The model has no clear.** A real caller in this tree clears its region at the end of a batch
(`tally/region.rye`, lines 64-80 and 100-105). Under a per-batch clear the footprint is bounded by
the batch, and this paper says nothing about batch length. The readings are the worst case, a
region never cleared, as in the prior paper.

## Horizon, assumptions, and confidence

**Horizon.** Valid for a region with no clear inside the run, and only for these mixes, rates and
run lengths. It does not reach a caller that clears per batch.

**Assumptions.** Independent Bernoulli replacement per slot per step. Byte counts with no alignment
padding and no allocator metadata. Python's `random.Random`, seed fixed.

**Confidence.** High that the 90/10 probe reproduces under this seed, since the seed is fixed and the
run is deterministic. High that the footprint tracks the replacement total under this model, which
follows from the bump cursor. Moderate that the result carries to other lifetime splits, since only
one split was run. Low on the clear-windowed case, which the model does not exercise.

## Falsifier for a later lap

If a probe with the slow slots pinned for the whole run, under a clear every 100,000 steps, shows a
footprint within a small constant of live bytes, the outlive-the-window condition is the thing that
matters and this paper's reading is incomplete. Keep the paper's conclusion for the no-clear case
and name the condition beside it. That probe is written here for a later lap and was not run.

## Held still by

Free. Nothing in the tree holds these readings still. The probe was a scratch file and is deleted.
To re-read the sweep, write the probe described above and run it under `python3 -I` with seed
`20261009`. A later lap that changes `tally/region.rye`'s clear semantics would need the reading
repeated.

Not run through the report card. No new witness, no new module, no scratch file left in the tree.
