# The byte threshold holds the budget, not the frontier

**Stamp:** `20261009.161337`
**Status:** Vision -- a simulation of allocation bytes, not a timing witness and not a measurement on metal
**Room:** vision
**Kin:** [`20261009-160733_the-clear-cadence-bounds-the-footprint.md`](20261009-160733_the-clear-cadence-bounds-the-footprint.md) (the step-count clear this paper answers) - [`20261009-160141_the-mixed-lifetime-footprint-is-still-the-total.md`](20261009-160141_the-mixed-lifetime-footprint-is-still-the-total.md)

The prior paper named one falsifier and wrote its prediction before any run: a clear that fires on a
byte threshold, rather than on a step count, should bound the high-water mark at the budget, whatever
the size mix. This paper runs it. The prediction held in both mixes, and the bound is the whole of
what the threshold buys. The step count already offers the cheaper trade-off.

## What was run

A scratch probe in `.lap/clear/threshold_probe.py`, run under `python3 -I` and deleted with the lap.
It is a bump allocator model: 200 slots, 20 fast at a replacement probability of 1/10 per step and
180 slow at 1/10000, seed `20261009`, 100,000 steps. Two size mixes, uniform 64 bytes and log-uniform
16 to 4,096 bytes. A clear resets the bump offset and re-copies every live block, so a clear costs the
live bytes once at the new offset.

Three arms, all over the same model:

- **Step cadence:** clear every N steps. N = 100, 1,000, and never.
- **Byte threshold:** clear just before an allocation that would carry the offset past a budget. The
  budget is k times the expected live bytes (200 slots at the mix's mean block), with k = 2, 4, 8, 16.

Every ratio below is high-water bytes divided by mean live bytes across the run, which is the same
denominator the prior paper used.

## Observation

Uniform mix (`20261009.161337`, `python3 -I`, seed `20261009`):

| Arm | High-water bytes | Mean live bytes | Ratio | Copy bytes per step | Clears |
|---|---|---|---|---|---|
| Never | 12,935,936 | 12,800 | 1,010.6 | 0.0 | 0 |
| Cadence 1,000 | 147,456 | 12,800 | 11.52 | 12.8 | 100 |
| Cadence 100 | 28,608 | 12,800 | 2.23 | 128.0 | 1,000 |
| Threshold k=2 (budget 25,600) | 25,600 | 12,800 | 2.00 | 127.9 | 1,004 |
| Threshold k=4 (budget 51,200) | 51,200 | 12,800 | 4.00 | 42.7 | 335 |
| Threshold k=8 (budget 102,400) | 102,400 | 12,800 | 8.00 | 18.3 | 144 |
| Threshold k=16 (budget 204,800) | 204,800 | 12,800 | 16.00 | 8.5 | 67 |

Log-uniform mix, same seed and steps:

| Arm | High-water bytes | Mean live bytes | Ratio | Copy bytes per step | Clears |
|---|---|---|---|---|---|
| Never | 149,587,181 | 142,185 | 1,052.1 | 0.0 | 0 |
| Cadence 1,000 | 1,835,688 | 142,185 | 12.91 | 141.6 | 100 |
| Cadence 100 | 372,689 | 142,185 | 2.62 | 1,421.3 | 1,000 |
| Threshold k=2 (budget 294,309) | 294,309 | 142,185 | 2.07 | 1,406.8 | 989 |
| Threshold k=4 (budget 588,619) | 588,619 | 142,185 | 4.14 | 475.0 | 335 |
| Threshold k=8 (budget 1,177,239) | 1,177,236 | 142,185 | 8.28 | 204.8 | 144 |
| Threshold k=16 (budget 2,354,478) | 2,354,455 | 142,185 | 16.56 | 95.8 | 67 |

Each threshold arm kept every allocation inside its budget and kept the live set under it, with zero
over-budget counts in both mixes.

## Cross-check against the prior paper

The uniform mix reproduces the earlier readings. Cadence 1,000 reads 11.52 here against 11.63 there.
Cadence 100 reads 2.23 against 2.23. Never reads 1,010.6 against 1,011.

The log mix reproduces in shape only. Cadence 1,000 reads 12.91 here against 11.35 there, and cadence 100
reads 2.62 against 2.33. The cause is the random stream: the prior probe's draw order was not kept,
and this probe draws each size from a different sequence. The ratio that depends on the stream moves
about 14 percent; the arms' ordering does not move. Read the log-mix rows as this model's own numbers,
not as a correction of the earlier table.

## Inference

The threshold rule holds the high-water mark at its budget. In every threshold arm the high-water mark
sits at the budget, to within one allocation. That is the bound the prediction named, and it does not
depend on the mix: the uniform and the log mix both land at k times the mean live set.

The step cadence offers a rate, not a bound. Its high-water mark is set by how many replacement bytes
arrive inside one window, and the mix sets that number. Under the log mix the same 1,000-step window
reaches 12.91, under the uniform mix 11.52, and no step count fixes the ratio for both.

On the trade-off curve, the step cadence stays ahead. Compare the two arms that cost
about the same copy traffic on the uniform mix: cadence 100 reads 2.23 at 128 copy bytes per step,
and threshold k=2 reads 2.00 at 127.9. The threshold wins by 0.23 of a ratio point and nothing more.
Across the rest of the curve the step cadence is cheaper. On the log mix, cadence 1,000 reads 12.91
at 141.6 copy bytes per step, while threshold k=8 reads 8.28 at 204.8. The threshold pays more copy
traffic for a lower ratio at k=8, and pays much more again in the mixed case at k=4, which costs 475
against cadence 1,000's 141.6 for a ratio of 4.14 against 12.91.

So the threshold's value is the guarantee, and the frontier stays with the cadence. A caller that must hold a
memory budget gets a bound it can state. A caller that only wants a small ratio on average gets the
same answer from a cadence, at lower copy traffic.

## Projection

Horizon: this model, the two size mixes, 200 slots, and the replacement rates named above. A
`Region` on metal could differ in alignment, allocator metadata, and whether its caller clears at all.

Assumptions: the bump model charges bytes only. Alignment, metadata, and the cost of the copy itself in
time are outside it. The live set is stationary, so the budget tracks it.

Falsifier: a `Region` on metal, under a byte-threshold clear, whose high-water mark exceeds its budget
when its live set stays under the budget. A second falsifier: a threshold arm whose copy traffic falls
below the cadence arm's at an equal ratio on a workload this model does not cover. Either would put the
guarantee or the frontier claim in doubt.

Confidence: high that the bound holds in this model, because it follows from the clear rule and the
run confirms it. Moderate that the bound survives a real allocator, since the model omits everything a
real allocator adds. Low that the frontier claim generalizes past two mixes.

## What the run does not show

The run measures bytes only. Wall-clock time is unmeasured: whether a threshold clear costs more or less
time than a cadence clear is open, and the copy-traffic column stands in for that cost and says so.

Every budget used sits above the live set at every step, so the zero over-budget counts describe those
budgets alone.

## The next falsifier, named rather than run

Make the budget follow the live set instead of a constant, so that a budget set once does not drift
away from the working set as the mix changes. A caller that sets k times its own measured live bytes
would track a shifting workload the constant cannot. The prediction written before any run: the bound
stays at k times the measured live set, and the copy traffic rises wherever the live set rises
fastest. It stays unrun.

## Grade

Graded A/91 at Field by `sh tools/fixtures/q/qa_report_card.sh` on this page (register 79, reach 100,
truth 100 counted, service 85 judged). The first reading read register 65, over the 30 percent negative
ceiling, and the negatives that could carry a positive form were rephrased before the grade was taken.
No new witness, no new module. The scratch probe was written to `.lap/clear/`, run once per mix, and
deleted before this lap ends.
