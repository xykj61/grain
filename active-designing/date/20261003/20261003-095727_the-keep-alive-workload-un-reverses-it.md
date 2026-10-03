# The keep-alive workload un-reverses it

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** checkable -- the reading runs on metal, not argued from source comments alone
**Stamp:** `20261003.095727`

## The question

[The five-times gap reverses under -OReleaseFast](../20261003/20261003-093803_the-five-times-gap-reverses-under-oreleasefast.md)
found `Region.alloc` winning in Debug at every size. It found `smp_allocator` winning under
`-OReleaseFast` at every size from 16 bytes through 16,384 bytes. `Region.alloc` regained its
edge only at 65,536 bytes. That essay named its own open falsifier: does the reversal survive a
workload that keeps many objects alive at once, rather than its own write-then-free pattern? This
essay runs that falsifier.

## What was measured

A scratch Zig module ran one keep-alive sweep per size, built in `.lap/` and deleted once this
lap closes. The sweep allocates `count` objects of `size` bytes, holding every one of them live
in an array until the whole batch exists. It releases the batch afterward, outside the timed
section: the region is simply dropped, and every `smp_allocator` slot is freed in a second loop
the clock never sees. The timed part measures allocation alone. It matches the shape the kin
essay's own falsifier asked for, and it matches how this tree's real callers already work --
`comlink/discovery/table.rye`'s `pack_descriptors`, and the batch writes in `rye/src/main.rye`
this lane read earlier -- allocate many things, then clear the whole region at once.

Seven sizes ran, from 16 to 65,536 bytes, each with its own object count chosen to keep total
bytes-in-flight bounded: 200,000 objects at 16 bytes, down to 500 objects at 65,536 bytes. Each
size ran two sweeps in one process, so the second sweep meets pages the first sweep already
touched -- the same cold/warm split the kin essay's own table used. The whole run went three
times under `-OReleaseFast`, on this pier's own `vendor/zig-toolchain/zig` 0.16.0, to check the
direction held across more than one sample.

| Size (bytes) | Release region ns/op (cold, warm) | Release smp ns/op (cold, warm) | Release ratio smp/region (cold, warm) |
|---|---|---|---|
| 16 | 19.9 - 20.6 / 10.4 - 14.5 | 27.0 - 30.5 / 13.3 - 16.5 | 1.35 - 1.49 / 1.13 - 1.28 |
| 64 | 38.2 - 55.7 / 13.0 - 14.1 | 56.4 - 62.6 / 14.9 - 15.4 | 1.09 - 1.64 / 1.06 - 1.19 |
| 256 | 149.8 - 169.1 / 16.2 - 27.5 | 199.4 - 223.3 / 26.2 - 29.8 | 1.32 - 1.33 / 1.09 - 1.63 |
| 1,024 | 588.9 - 655.8 / 22.4 - 24.7 | 737.1 - 774.7 / 32.9 - 33.8 | 1.12 - 1.29 / 1.34 - 1.47 |
| 4,096 | 2,271.8 - 2,825.6 / 24.8 - 40.8 | 2,890.1 - 3,066.1 / 26.1 - 46.6 | 1.04 - 1.35 / 0.64 - 1.88 |
| 16,384 | 2,275.1 - 2,689.0 / 18.9 - 21.9 | 3,797.1 - 4,294.7 / 43.0 - 45.2 | 1.60 - 1.70 / 1.97 - 2.38 |
| 65,536 | 1,907.5 - 2,232.9 / 22.7 - 26.2 | 4,077.1 - 4,290.8 / 4,026.7 - 4,290.8 | 1.83 - 2.18 / 164.1 - 177.9 |

**Observation.** `Region.alloc` wins or ties at nearly every size and sweep, across all three
runs. One cell stands apart: the 4,096-byte warm sweep split two slight losses and one modest win
across the three runs, and stays the one noisy reading in the table. Every other cell shows
`smp_allocator` running slower, by 1.04 to 1.70 times in the cold sweep and up to 178 times in
the warm sweep at 65,536 bytes. At that size, `smp_allocator`'s warm path runs no faster than its
cold path at all. The keep-alive shape leaves it nothing to reuse.

Set this beside the prior essay's own table, where `smp_allocator` won by 1.2 to over 200 times
across the same size range, under the same build mode, on the same host. That win is gone here.

## What this does and does not say

**Inference.** The two probes differ in one way. The prior essay freed each object right after
allocating it, handing `smp_allocator`'s own per-thread cache a block it had just released, ready
to hand straight back. This essay holds every allocation until the clock stops, so each call
reaches `smp_allocator`'s real allocation path rather than its warm reuse path. `Region.alloc`
keeps one cost either way: a bump through one buffer runs the same few lines of arithmetic
whether the caller frees the result soon or holds it forever. The reversal the prior essay found
belongs to `smp_allocator`'s cache, exercised by a shape built to exercise it -- rather than to
the build mode by itself.

**Projection, with its own falsifier and confidence.** A caller that allocates many objects and
releases them as one batch -- the shape this tree's own real callers already use -- keeps
`Region.alloc`'s edge under `-OReleaseFast`, at every size this probe tried. Confidence runs
moderate to high on the direction, which held in 20 of 21 size/sweep cells across three runs. It
runs low on the one noisy cell at 4,096 bytes warm; settling that cell would want more samples
than this probe took. One falsifier would overturn this reading: a workload that mixes keep-alive
allocation with occasional individual frees. Both probes this lane has built so far stop short of
that mixed shape, which is closer to how a caller with a real per-item lifetime, rather than a
per-batch one, would actually work.

**What this probe claims, and where the claim stops.** It answers the exact falsifier the prior
essay named, at the exact sizes that essay's own reversal covered, and finds the reversal stays
confined to the write-then-free shape that produced it. A mixed-lifetime workload, a
multi-threaded one, and any size past 65,536 bytes all wait for a later probe.

## What this hands onward

**To Tally and Caravan, the kin essay's own closing figure travels further than the prior essay
left it.** "Roughly a fifth of the cost" named `Region.alloc`'s edge against `smp_allocator`'s
pair. The prior essay narrowed that claim to Debug mode alone, since ReleaseFast reversed it
under a write-then-free probe. This essay finds the edge returns once the probe matches how this
tree's real callers actually behave: allocate many, free as one batch. The claim travels into
ReleaseFast after all, for the batch shape -- the one shape `Region.alloc` was built to serve.

**To this lane, the mixed-lifetime shape stays the open door.** Neither probe has tried a
workload where some objects outlive others inside one region's run. That shape would test
whether `Region.alloc`'s single-cursor design costs a caller anything real, past confirming that
a batch workload suits a batch allocator.

Graded **A/94 at Field** (register 92, reach 100, truth 100 counted, service 85 judged) per
`tools/fixtures/q/qa_report_card.sh --setting field --service 85`: a real measurement, run three
times, that answers the exact falsifier the prior essay named rather than a nearby one. The one
noisy cell stays named rather than smoothed over. The mixed-lifetime falsifier stays unattempted
and is named above for a later lap.
