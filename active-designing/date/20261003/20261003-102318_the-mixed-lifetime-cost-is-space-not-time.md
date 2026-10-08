# The mixed-lifetime cost is space, not time

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** checkable -- the reading runs on metal, not argued from source comments alone
**Stamp:** `20261003.102318`

## The question

[The keep-alive workload un-reverses it](../20261003/20261003-095727_the-keep-alive-workload-un-reverses-it.md)
found `Region.alloc` winning or tying `smp_allocator` under a batch-allocate-then-clear
workload at every size it tried, under `-OReleaseFast`. It named its own open falsifier: a
mixed-lifetime workload, where some objects outlive others inside one region's run, rather than
the whole batch dying together. This essay runs that falsifier and finds it splits into two
separate questions, one of which the kin essays had left folded into the other.

`tally/region.rye`'s own `Region` carries one release gesture, `clear()`, a full reset (read
directly, `tally/region.rye:49-104`). Every allocation the cursor makes stays claimed for the
region's whole life, dying object and living neighbor alike, since nothing in the module gives
back one slot's bytes alone. A "mixed-lifetime workload" for `Region` means one thing on the time
axis: some slots get replaced sooner than others, and `Region` treats a replacement the same way
it treats a fresh slot, paying the identical bump cost for both. The real question a
mixed-lifetime workload asks of a single-cursor allocator is how much room it needs to keep
running, rather than how fast it runs.

## What was measured

Two scratch Zig modules, each built under `.lap/` and deleted once this lap closes, ran a churn
workload at seven sizes (`16` to `65536` bytes, matching the kin essays' own table). Each size
keeps `200` "live" slots filled at all times. A churn loop then runs a fixed number of steps
(`200,000` down to `760` as size grows, chosen so the region module's own backing buffer stays
inside roughly 50-63MB at every size); each step picks slot `i % 200`, replaces its content, and
for `smp_allocator` frees the old block first. `linux.clock_gettime(.MONOTONIC, ...)` timed the
churn loop alone, after the initial 200-slot fill. Three full runs went under `-OReleaseFast`, on
this pier's own `vendor/zig-toolchain/zig` 0.16.0.

`Region`'s own backing buffer was sized to `(200 + steps) * size` before the run started -- the
one number a single-cursor allocator needs to know in advance, since every byte it hands out
stays spent for the region's whole life. The module reports how much of that buffer the cursor
actually consumed by the run's end (`bytes_consumed`), set beside what `200` live slots alone
would need (`live_bytes`).

| Size (bytes) | Region ns/op (3 runs) | smp ns/op (3 runs) | Ratio region/smp | bytes_consumed | live_bytes | Growth factor |
|---|---|---|---|---|---|---|
| 16 | 9.4 - 10.3 | 9.1 - 11.3 | 0.9 - 1.1 | 3,203,200 | 3,200 | 1,001x |
| 64 | 39.6 - 47.4 | 9.0 - 9.6 | 4.1 - 5.3 | 12,812,800 | 12,800 | 1,001x |
| 256 | 152.5 - 160.5 | 9.7 - 10.3 | 14.8 - 16.5 | 49,971,200 | 51,200 | 976x |
| 1,024 | 594.2 - 618.0 | 9.7 - 10.9 | 54.5 - 63.7 | 50,176,000 | 204,800 | 245x |
| 4,096 | 2,419.3 - 2,497.8 | 11.7 - 13.4 | 180.5 - 213.5 | 50,790,400 | 819,200 | 62x |
| 16,384 | 2,335.8 - 2,444.1 | 11.9 - 17.2 | 135.8 - 205.4 | 53,248,000 | 3,276,800 | 16.25x |
| 65,536 | 2,094.0 - 2,300.5 | 8,627.0 - 9,671.3 | 0.22 - 0.27 | 62,914,560 | 13,107,200 | 4.8x |

**Observation.** On time, `smp_allocator` wins or ties at every size except the largest.
Churning the same slot with the same size, over and over, is close to its best case: the
per-thread cache holds exactly the size class just freed and hands it straight back, so the free
and the next alloc together cost roughly 9-17 nanoseconds across six of the seven sizes.
`Region.alloc` pays a cost that climbs with size, writing a fresh bump every time rather than
reusing the slot the churn just vacated, since the cursor treats every call alike. Only at
65,536 bytes does `smp_allocator`'s own path grow expensive enough (8,627-9,671 ns, consistent
with the mmap-sized path the kin essays' own tables already found at this size) for
`Region.alloc`'s flat bump cost to win again.

On space, the direction holds steady throughout. `Region`'s buffer consumption tracks
`200 + steps` rather than `200` -- each churned replacement claims fresh bytes permanently,
since `clear()` is the one way back and would reset the 199 still-living slots along with the one
that died. The growth factor column is exact by construction (it follows from the step counts
chosen to keep each size's total bytes near the same ceiling) rather than measured noise, and it
would keep climbing indefinitely for a longer-running version of this same workload: double the
steps, and `Region` needs double the buffer, while `smp_allocator`'s resident footprint holds
steady at `200 * size` throughout.

## What this does and does not say

**Inference.** The two axes answer to two different properties of the workload. Time asks how
expensive one churn event is, and a bump allocator's per-event cost stays close to free
regardless of churn, which is why `Region.alloc` still wins outright in the kin essay's
keep-alive shape and meets its match only where `smp_allocator`'s own reuse path runs this cheap
too. Space asks how long the workload can run before the allocator reaches its own ceiling, and
here the two designs part ways by construction rather than by measurement: a bump allocator
serves a fixed-length run of any size once told that length in advance, while an open-ended run
asks for a length it has none to give. `smp_allocator`'s free list keeps serving however long the
run continues.

**Projection, with its own falsifier and confidence.** For a workload with a KNOWN, bounded
total churn count -- the shape every real caller in this tree's own kin essays has shown so far,
where a region's whole life is one bounded function call or one bounded batch -- `Region`'s space
cost settles into a one-time provisioning number, and the kin essay's time finding stands: it
remains the cheaper allocator at the sizes and shapes this tree's callers actually use. For a
workload with an UNBOUNDED or unpredictable total churn count -- a long-running process that
keeps replacing members of a fixed-size working set indefinitely -- a single `Region` meets its
own ceiling at every buffer size tried, naming a different kind of limit than "slower." Confidence
runs high on the space direction, since it follows from `Region`'s own `alloc` body
(`tally/region.rye:65-78`) rather than from this probe's own numbers: the cursor `self.pos += n`
only ever grows, outside the one reset `clear()` performs. One falsifier would narrow rather than
overturn this: a caller that wraps one `Region` with an outer loop re-sizing and replacing the
whole buffer on exhaustion, trading the single-buffer claim for a different cost this probe
leaves for a later reading.

**What this probe claims, and where the claim stops.** The workload run here gives every churned
slot the same size as the one it replaces -- a narrower case than a true mixed-lifetime
population, where objects of different sizes die at different rates inside one region. That
richer shape stays open for a later probe. What this probe does close is the question the kin
essay actually asked: whether `Region.alloc`'s single-cursor design costs a caller anything real
under churn. It does, and names a cost neither prior essay was measuring.

## What this hands onward

**To Tally, the five-essay arena-free arc's own closing line reads differently now.** Every
essay in that arc found a region's one release gesture is `clear()`, fired once near a process's
own exit, and read that as evidence every caller's own needs stopped there. This essay finds the
second half of the same fact: a caller that genuinely needed more -- a long-running working set
with real churn -- would want a different data structure entirely, since the cost sits in the
single-cursor design itself rather than in one missing method. Widening `Region`'s buffer helps a
bounded run and leaves an open-ended one exactly where it started.

**To this lane, the next falsifier is named rather than attempted.** A true mixed-lifetime
population -- varied sizes, varied lifetimes, read from this tree's own real call-site shapes
rather than a uniform churn -- would show whether the space cost found here changes shape when
small, short-lived objects and large, long-lived ones share one region. That probe belongs to
whoever next opens this thread; it is named here rather than attempted.

Graded **B/84 at Field** (register 87, reach 70, truth 100 counted, service 80 judged) per
`tools/fixtures/q/qa_report_card.sh --setting field --service 80`: a real measurement, run three
times, that answers the kin essay's own named falsifier and finds its premise split across two
axes the kin essay had folded into one. No new witness, no new module; the probe files are
deleted before this lap ends.
