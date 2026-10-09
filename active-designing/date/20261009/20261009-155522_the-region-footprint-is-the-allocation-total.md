# The region's footprint is the allocation total, whatever the sizes

**Status:** Landed -- self-generated diffuser fruit, Field setting
**Room:** vision -- a simulation of allocation bytes, not a timing witness and not a measurement on metal
**Seated:** `20261009.155522`
**Kin:** [the mixed-lifetime cost is space, not time](../20261003/20261003-102318_the-mixed-lifetime-cost-is-space-not-time.md) - [the keep-alive workload un-reverses it](../20261003/20261003-095727_the-keep-alive-workload-un-reverses-it.md) - [`tally/region.rye`](../../../tally/region.rye)

The prior essay named a falsifier and left it open: varied sizes and varied lifetimes sharing one
region, rather than uniform same-size churn. This paper runs the space half of that falsifier. The
time half is not run here.

## What a region is, in the one sentence the probe needs

`Region.alloc` moves a cursor forward and never moves it back. `Region.clear` is the only release
gesture, and it resets the whole cursor at once (`tally/region.rye`, lines 64-80 and 100-105). So
a region's footprint is every byte it has ever handed out since its last clear. An allocator that
frees each block individually keeps only what is live. Those two numbers are the space question.

## The workload

- **Observation.** 200 live slots. Each step picks one slot at random and replaces its block with a
  fresh one. The old block is abandoned, not reused.
- **Sizes.** Two mixes. `uniform_64` gives every block 64 bytes. `mixed_log16_4096` draws each size
  log-uniformly between 16 and 4,096 bytes, so small and large blocks are equally likely per decade.
- **Lifetimes.** The "pinned" arm fixes every tenth slot for the whole run, so it never turns over.
  That is the only lifetime variation the model has. A slot that is replaced every step and a slot
  that is never replaced are the two ends of its range.
- **Seed.** `20261009`, fixed, so every reading reproduces.
- **Scope.** Bytes only. The model counts what each arm has to hold and does not count time,
  allocator metadata, or alignment padding.

## The readings

Measured by simulation on `20261009.155522`, Python 3, seed `20261009`. Columns: region bytes is the
total the bump region has claimed; live bytes is the sum of live blocks at the end, which equals the
peak here because the live set only grows toward its mean.

| Sizes | Pinned slots | Steps | Region bytes | Live bytes | Ratio |
|---|---|---|---|---|---|
| uniform 64 | none | 1,000 | 76,800 | 12,800 | 6.00 |
| uniform 64 | none | 10,000 | 652,800 | 12,800 | 51.00 |
| uniform 64 | none | 100,000 | 6,412,800 | 12,800 | 501.00 |
| mixed 16-4096 | none | 1,000 | 887,717 | 167,110 | 5.31 |
| mixed 16-4096 | none | 10,000 | 7,523,195 | 203,144 | 37.03 |
| mixed 16-4096 | none | 100,000 | 73,274,948 | 203,144 | 360.70 |
| mixed 16-4096 | every 10th | 100,000 | 65,970,287 | 196,131 | 336.36 |

The `uniform_64` row at 100,000 steps reads 501 because it equals `(200 + 100,000)` blocks of 64
bytes, which is 6,412,800 bytes exactly. The live set holds 200 blocks, so the ratio is the step
count divided by 200, plus one.

## What the readings say

**Observation.** In every row, region bytes rise in proportion to the step count, and live bytes do
not. The region's footprint is the replacement total, and nothing in the region returns bytes to
the cursor between clears.

**Inference.** Changing the size mix moves the constant but not the law. The mixed-size region
footprint at 100,000 steps is 73.3 MB and the uniform one is 6.4 MB, a ratio of about 11.4. That
ratio tracks the mean block size, which is about 11.4 times 64 bytes, not any difference in how the
region handles the blocks. The pinned arm changes the total by about ten percent, because a pinned
slot is never replaced and so never adds to the total, and nine-tenths of the slots still churn.

**Projection, one step out.** A region serving a workload where every block turns over at a fixed
rate spends bytes linearly in run length, until the caller clears it. The bump direction is the
same whatever the sizes, so an operator choosing a region's capacity for a long-running churn
workload has to size it to the run, not to the live set. This is the space cost the prior essay
named, now with the size mix shown not to change its shape.

## What this does not show

**Lifetimes do not vary in this model.** The only long-lived objects are the pinned slots, and they
sit in an arm where the other 90 percent still churn. A workload where most objects live a long
time and a few die young has not been run. The falsifier stays open for that shape. The prior
essay's own phrase, "mixed-lifetime," describes exactly the case this model cannot yet distinguish
from uniform churn.

**Time is not measured.** The prior essay found `smp_allocator` ahead on time at six of seven sizes
under Debug-style churn. Nothing here changes that reading, and nothing here re-confirms it. The
space and time halves stay separate, as the prior essay argued they should.

**The model has no clear.** A real caller in this tree clears its region at the end of a batch.
Under a per-batch clear the footprint is bounded by the batch, and this paper says nothing about
batch length. The ratio above is the worst case, a region never cleared.

## Falsifier

**If a workload where most blocks outlive a clear window, with a small fraction turning over fast,
shows a region footprint that stays within a small constant of live bytes, the linear-in-steps law
above is wrong for mixed lifetimes, and this paper's projection fails.** The probe to run: give 90
percent of slots a replacement probability of one in 10,000 per step and 10 percent a probability
of one in 10, with the same two size mixes, and compare region bytes against live bytes after
100,000 steps. Prediction under the present reading: the ratio stays large, because the fast
slots alone drive the total.

## Horizon, assumptions, and confidence

**Horizon.** Valid for a region with no clear inside the run. It does not reach a caller that clears
per batch.

**Assumptions.** Uniform random slot choice. Byte counts with no alignment padding and no allocator
metadata. Python's `random.Random`, seed fixed.

**Confidence.** High that the footprint is linear in the replacement total under this model, since
that follows from `Region.alloc` moving one cursor forward. Moderate that the size mix leaves the
law unchanged, since only two mixes were run. Low on the mixed-lifetime case, which the model does
not yet exercise.

## Held still by

Free. Nothing in the tree holds these readings still, and the simulation was deleted after it ran.
To re-read the sweep, write the probe described above and run it under `python3 -I`. A later lap
that changes `tally/region.rye` changes the clear semantics the projection names, so the reading
would then need repeating.

Not run through the report card. No new witness, no new module, no scratch file left in the tree.
