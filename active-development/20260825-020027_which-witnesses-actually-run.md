# Which witnesses actually run

**Stamp:** `20260825.020027` - **Status:** Measurement, no change proposed - **Style:** Gauge, Field setting
**Voice:** Kyri - **Room:** development, because this scopes a decision rather than reasoning about a shape
**Occasioned by:** three witnesses found failing while chasing an unrelated red, none of them gated

## What was counted, and how

Population: **1,684** tracked `tools/**/*_witness.rish`. Four `_witness.rye` files in `tools/`
and 130 in module rooms are excluded -- those are compiled and run by a `.rish` counterpart. The
15 `_lab.rish` scripts are excluded because a lab is explicitly not a gate.

A witness **runs** when something that itself runs names it. So the reading is a transitive closure
rather than a grep: start from roots, follow every naming edge, and see what is reached.

**Roots (57):** the `path` rows of `construction/standing-equipment.kyri`, plus every witness named
by `tools/hooks/` or by a `recursion-prompts/` loop file. Those three are the only things in this
tree that run a witness without a person deciding to.

**Edges:** any tracked `.rish` or `.sh` naming a witness path other than its own.

## The three-way split, measured `20260825.020027`

| Class | Count | Share |
|---|---:|---:|
| **Reached** from a root, transitively | **261** | 15.5% |
| **Named** by something, that something never reached | **533** | 31.7% |
| **Named by nothing at all** | **890** | 52.9% |
| Population | 1,684 | |

Of the 261 reached, **57** are roster rows, **110** arrive through `tools/ca/caravan_suite_witness.rish`,
and **91** through `tools/cr/crypto_suite_witness.rish`. Two suites carry three quarters of everything
this tree measures automatically.

## The 533 are mostly a few ungated aggregators, which makes them cheap

The middle class is not 533 scattered files. It is a handful of suites that name many witnesses and
are not themselves on the roster. Measured greedily -- at each step, the one roster row that would
reach the most new witnesses:

| Roster row | New witnesses reached | Running total |
|---|---:|---:|
| `tools/p/parity_ch01.rish` | +107 | 368 |
| `tools/f/font5x7_upper_close_witness.rish` | +27 | 395 |
| `tools/gen/season/equinox_e110_ch8_reserve_choir_witness.rish` | +22 | 417 |
| `tools/gen/season/prin_scope.rish` | +21 | 438 |
| `tools/gen/season/grad_seal_witness.rish` | +19 | 457 |
| `tools/d/drey_witness.rish` | +17 | 474 |
| `tools/gen/season/equinox_ch5_surface_witness.rish` | +17 | 491 |
| `tools/gen/season/equinox_ch6_surface_witness.rish` | +17 | 508 |

**Eight rows take reachability from 261 to 508**, roughly 15% to 30% of the population, at the cost
of eight lines and whatever those suites cost in wall time. **1,176 would still stand unreached.**

## What the ungated ones actually do, sampled on metal

61 of the 1,423 ungated witnesses were run under a 45-second timeout -- 41 sampled evenly from the
890 named by nothing, 20 from the 533 named-but-unreached.

| Sample | GREEN | RED | Red rate |
|---|---:|---:|---:|
| Named by nothing (41) | 36 | 5 | 12.2% |
| Named, unreached (20) | 19 | 1 | 5.0% |
| Together (61) | 55 | 6 | **9.8%** |

Extrapolated to 1,423 ungated: a point estimate of about **140 failing witnesses**. The sample is
4.3% of the population, so the honest 95% interval on that proportion is roughly **2.3% to 17.3%**,
which is **33 to 246 witnesses**. The number is large under every reading in that range and the
midpoint should not be quoted as if it were counted.

## A red here is not always a defect, and that is the finding that shapes the decision

The six reds separate into at least two kinds, and the difference matters more than the count:

- **Genuine drift.** `vols_classify_witness` reports *a live guarded file drifted* -- a real
  disagreement between a guard and the tree, standing unnoticed.
- **Missing context.** `stoa237_native_embedded_desk_witness` fails inside an APK pack, which wants
  a device this pier does not have. `oven_season_o0_witness` and two others fail because a scan
  they depend on exits non-zero, which may be a season that has closed rather than a bug.

**So gating all 1,684 would be wrong**, and not merely expensive. A wall that reds because a device
is absent is a wall somebody turns off, which is the failure this tree has already named twice.

## What this measurement does not settle

Which population *should* be gated. Three readings are visible and this note argues for none of them:
gate the eight aggregators and stop; gate every witness that passes today and let the rest ratchet;
or triage the ungated set by kind first -- device, closed season, genuine drift -- and gate only the
third. The last is the most honest and the most expensive, and choosing between them is a decision
rather than a measurement.

## The falsifier

**This note is wrong if the red rate is an artifact of the 45-second timeout or of running from a
cold tree.** No sampled witness reported a timeout, which is evidence against the first. A full run
of the 1,423 would settle it and costs hours rather than minutes; it has not been done, and no claim
here rests on having done it.
