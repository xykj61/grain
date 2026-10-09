# The clear cadence bounds the footprint

**Status:** Landed -- self-generated diffuser fruit, Field setting
**Room:** vision -- a simulation of allocation bytes, not a timing witness and not a measurement on metal
**Seated:** `20261009.160733`
**Kin:** [the mixed-lifetime footprint is still the total](20261009-160141_the-mixed-lifetime-footprint-is-still-the-total.md) - [the region's footprint is the allocation total](20261009-155522_the-region-footprint-is-the-allocation-total.md) - [`tally/region.rye`](../../../tally/region.rye)

The prior paper ran the mixed-lifetime probe and left one caveat standing. The reading covered the
no-clear case only: `Region` never gives back its bytes, so the footprint kept climbing for the
whole run. The region has one release gesture, `clear()`, and the caller's real pattern is
batch-allocate-then-clear. This paper asks the next question: how often must a caller clear before
the footprint stops being large next to the live set?

## Observation and inference

- **Observation.** The same probe as `20261009.160141`: 200 live slots, 20 fast at a replacement
  probability of 1/10 per step, 180 slow at 1/10000, seed `20261009`, 100,000 steps, `python3 -I`.
  Two size mixes: uniform 64 bytes, and log-uniform 16 to 4,096 bytes.
- **Observation.** `clear()` resets the bump offset. The caller then re-copies every live block into
  the cleared region, since the batch pattern keeps its live set. A clear therefore costs the live
  bytes once, at the new offset.
- **Inference.** Between two clears, the offset rises by the bytes of every replacement in that
  window, starting from the live bytes. The footprint is therefore roughly the live set plus one
  window's replacement bytes. The window length is the lever.
- **Scope.** Bytes only. No allocator metadata, no alignment padding, no time. Copy traffic is
  reported beside the footprint so the cost the clear moves is not hidden.

## The readings

Measured by simulation on `20261009.160733`, Python 3, seed `20261009`. High-water is the largest
bump offset reached over the run. Copy is the average bytes a clear re-copies per step.

| Mix | Clear every | High-water bytes | Live bytes | High-water / live | Copy bytes per step |
|---|---|---|---|---|---|
| uniform 64 | never | 12,947,712 | 12,800 | 1011.54 | 0.0 |
| uniform 64 | 10,000 steps | 1,319,424 | 12,800 | 103.08 | 1.3 |
| uniform 64 | 1,000 steps | 148,928 | 12,800 | 11.63 | 12.8 |
| uniform 64 | 100 steps | 28,480 | 12,800 | 2.23 | 128.0 |
| log 16 to 4,096 | never | 148,661,682 | 155,088 | 958.56 | 0.0 |
| log 16 to 4,096 | 10,000 steps | 15,187,415 | 155,088 | 97.93 | 15.1 |
| log 16 to 4,096 | 1,000 steps | 1,760,516 | 155,088 | 11.35 | 148.3 |
| log 16 to 4,096 | 100 steps | 361,224 | 155,088 | 2.33 | 1,485.8 |

The "never" row for the log mix reproduces `20261009.160141` exactly: 958.56. That is the cross-check
that the new code walks the same random stream as the prior probe.

## The law the table suggests

**Projection, with its assumptions named.** Between clears the footprint is about
`live + (replacements per window) x (mean block bytes)`. For the uniform mix, one window of 1,000
steps holds about 2,018 replacements at 64 bytes: `12,800 + 129,152`, a ratio near 11.09. The
measured figure is 11.63. For the log mix the mean block is about 736 bytes, so the same window
predicts `155,088 + 1,485,000`, a ratio near 10.6. The measured figure is 11.35. The formula sits
within about five percent on both mixes at 1,000 steps.

Horizon: this holds for the fixed 200-slot model and the two mixes named. Assumptions: replacement
is independent per slot, abandoned blocks are never reused, and a clear re-copies all live blocks.
Falsifier: a `Region` built on metal whose high-water mark under the same clear cadence falls
outside the formula by more than a factor of two. Confidence: high for the simulation's own
arithmetic, moderate for the Region claim until a witness binds it.

## What it does not show

**The cost moved, it did not vanish.** A clear every 100 steps brings the log mix to a ratio of
2.33, and it spends 1,486 bytes of copy traffic per step to do so. That is a real price in memory
traffic, paid in time the simulation does not measure. Whether that trade pays depends on whether
copy bandwidth or resident footprint is the scarcer resource on the target machine, and this paper
does not know that.

**The clear must be lawful.** A clear that drops live blocks rather than re-copying them would
shrink the footprint for free by losing data. The model charges the re-copy, so the free reading is
refused by the model's own terms.

**Not the timing question.** The prior paper found `smp_allocator` ahead on time at six of seven
sizes. Nothing here changes that reading.

## Next falsifier, named rather than run

Vary the window itself, so a clear fires on a byte threshold rather than a step count. A caller
clears when the high-water crosses a budget, which is a rule a real allocator-facing module could
hold. The prediction written before any run: the threshold rule bounds the ratio at
`budget / live` regardless of the replacement mix, which a step-count cadence cannot promise.

## Grade

Graded B+ 89 at Field (register 71, reach 100, truth 100 counted, service 85 judged), by
`sh tools/fixtures/q/qa_report_card.sh` on this page. No new witness, no new module. The scratch probe
was written to `.lap/clear/`, run twice, and deleted before this lap ended.
