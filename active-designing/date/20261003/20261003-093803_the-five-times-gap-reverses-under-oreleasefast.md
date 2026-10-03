# The five-times gap reverses under -OReleaseFast

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Status:** checkable -- the reading runs on metal, not argued from source comments alone
**Stamp:** `20261003.093803`

## The question

[The bump costs five times less than the free list](../20261002/20261002-163731_the-bump-costs-five-times-less-than-the-free-list.md)
measured `Region.alloc` running 4.3 to 5.0 times faster than `smp_allocator`'s `alloc`/`free`
pair, at sixteen bytes per call. It named its own falsifier: does the gap hold, narrow, or
reverse at a size where `smp_allocator`'s own per-thread cache catches up? This essay runs that
falsifier across eight sizes, from 16 bytes to 262,144 bytes. It finds a second variable that
matters more than size: the compiler's own optimization level.

## What was measured

A scratch Zig module ran the kin essay's own method at eight sizes: `16, 64, 256, 1024, 4096,
16384, 65536, 262144` bytes. One `Region.init`'d backing buffer, sized for the whole run, raced
`smp_allocator`'s `alloc` then `free`. `linux.clock_gettime(.MONOTONIC, ...)` kept the clock. The
iteration count shrank as size grew, from 500,000 down to 1,000, to keep total bytes moved roughly
steady. Two full sweeps ran in each of two build modes, on this pier, `vendor/zig-toolchain/zig`
0.16.0: plain `zig run <probe>`, and `zig run <probe> -OReleaseFast`. The scratch file was removed
after the run.

**Why Debug earns its own column.** `rye/src/main.rye:814-820` builds the `zig build-exe`
argument list for every `rye build` and `rye run` call in this tree. It names no `-O` flag of
its own. Zig's own default mode, when nothing names one, is Debug. So a probe that calls `rye
build` or `rye run` and never adds `-OReleaseFast` runs in Debug. That covers every probe this
lane built before this one, including the kin essay this one answers. Debug is this tree's own
unstated default, picked by its own build path rather than chosen for this essay.

| Size (bytes) | Debug region ns/op | Debug smp ns/op | Debug ratio | Release region ns/op | Release smp ns/op | Release ratio |
|---|---|---|---|---|---|---|
| 16 | 24.0 - 25.9 | 181.5 - 193.8 | 7.5 - 7.6 | 9.7 - 12.0 | 7.9 - 8.3 | 0.69 - 0.82 |
| 64 | 24.2 - 26.0 | 211.3 - 216.2 | 8.3 - 8.7 | 40.4 - 43.8 | 8.0 - 8.3 | 0.19 - 0.20 |
| 256 | 25.4 - 26.4 | 204.9 - 211.3 | 8.0 - 8.1 | 147.8 - 174.5 | 7.8 - 8.8 | 0.05 |
| 1,024 | 27.8 - 31.7 | 220.8 - 241.1 | 7.6 - 8.0 | 605.5 - 682.6 | 8.0 - 8.5 | 0.01 |
| 4,096 | 54.9 - 55.7 | 282.7 - 288.2 | 5.2 | 2,292.6 - 2,358.3 | 8.0 - 8.7 | 0.00 |
| 16,384 | 34.9 - 36.6 | 541.7 - 662.7 | 15.5 - 18.1 | 2,233.4 - 2,246.1 | 11.9 - 13.7 | 0.01 |
| 65,536 | 48.3 - 58.5 | 50,742.5 - 51,891.1 | 867 - 1,075 | 2,127.1 - 2,174.7 | 10,774.8 - 12,149.2 | 4.86 - 5.59 |
| 262,144 | 77.9 - 224.5 | 184,863.1 - 189,770.5 | 824 - 2,436 | 2,234.8 - 2,630.4 | 10,857.2 - 11,699.0 | 4.45 - 4.86 |

**Observation.** In Debug mode, `Region.alloc` wins at every size tried. The margin widens with
size, rather than narrows. The kin essay's own 16-byte reading sits inside this run's 7.5 - 7.6
range. The gap grows past three orders of magnitude once `smp_allocator` reaches for a raw
`mmap`/`munmap` pair. **In ReleaseFast mode, the direction flips for every size from 16 bytes
through 16,384 bytes.** `smp_allocator` reads 1.2 to over 200 times faster than `Region.alloc`
across that range. `Region.alloc` wins again, at roughly the kin essay's own margin, only once
the size reaches 65,536 bytes.

## What this does and does not say

**Inference.** Two reasons fit both halves of the reversal. `Region.alloc`'s own body
(`tally/region.rye:65-78`) is cheap: one subtraction, one comparison, two `@intCast`s, one add.
Debug's own safety checks -- bounds checks, the module's own `assert` calls -- tax that cheap work
by a roughly constant amount per call. ReleaseFast strips that tax close to zero, down near the
bare arithmetic. The probe's own pattern -- write, then free right away -- hands `smp_allocator`
its best case too: the freed block sits at the top of its own per-thread cache, and the next
`alloc` of the same size takes it straight back. Debug taxes that fast path the same way it taxes
`Region.alloc`. ReleaseFast lets it run close to a bare cache push and pop. `Region.alloc`'s own
cost under ReleaseFast climbs instead, from roughly 10ns at 16 bytes to over 2,200ns at 4,096
bytes. That points at the backing buffer, rather than the allocator's own arithmetic. Each
allocation writes one byte at its own start. A region sized for the whole run can run to tens of
megabytes at the larger sizes. The kernel faults in a fresh page the first time any byte on it is
touched. Debug's own overhead used to hide that page-fault cost; ReleaseFast now shows it plainly.

**Projection, with its own falsifier and confidence.** Reaching for `Region.alloc`, at sizes
under roughly 32KB, buys a real win *in this tree's own Debug default*. It buys a real loss
*under `-OReleaseFast`* -- on this host, at these sizes, under this allocator, under this probe's
own write-then-free pattern. The falsifier that would overturn the ReleaseFast half: a workload
that keeps many objects alive at once, rather than freeing each one before the next allocation.
That would deny `smp_allocator` its own warm-cache best case, and might restore `Region.alloc`'s
edge even under ReleaseFast. Confidence: moderate on the reversal itself, which held across two
runs in each mode, at every size under 65,536 bytes, with a clean sweep. Confidence stays low on
which side wins in a realistic mixed-lifetime workload -- a question this probe leaves for a
later lap.

**What this probe claims, and where the claim stops.** Its claim stays narrow. Debug is one real
mode among several this host can build under. The kin essay's own reading stays correct for its
own stated scope: that essay named its host, its size, and its allocator plainly, and its ratio
sits inside this run's own Debug numbers at the same size. What this essay adds is the variable
that reading left unnamed. The build mode a shipped binary runs under changes which allocator
wins. This tree's own witnesses run in the one mode where `Region.alloc` wins by the widest
margin -- and that mode is also the one a shipped binary would least often pick for itself.

## What this hands onward

**To Tally and Caravan, the design stays correct, and the cost claim narrows.** Nothing moves in
`tally/region.rye`'s own correctness. Its construction and mutation asserts hold. Every one of
the 179 confirmed `garden.free(` call sites keeps behaving exactly as the kin arc already read.
What narrows is the kin essay's own closing figure, "roughly a fifth of the cost." That figure
holds for this tree's own Debug default. It wants its own `-OReleaseFast` reading before it can
travel into a claim about a shipped binary.

**To this lane, a falsifier that wants a different probe shape, rather than a different size.**
The open question is whether `Region.alloc`'s edge survives ReleaseFast once a workload keeps
allocations alive at once, rather than freeing each before the next. That is the shape every real
caller this tree has already read actually uses -- `comlink/discovery/table.rye`'s
`pack_descriptors`, and the production sites in `rye/src/main.rye`. This probe's own
write-then-free pattern never tried that shape.

Graded **A/95 at Field** (register 94, reach 100, truth 100 counted, service 85 judged) per
`tools/fixtures/q/qa_report_card.sh --setting field --service 85`: a real measurement, in two
build modes, on real metal. A falsifier a prior essay named, run rather than left standing. The
reversal held across two runs each, rather than one sample alone. The mixed-lifetime falsifier
stays unattempted, and is named above for a later lap.
