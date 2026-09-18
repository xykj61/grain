# The price of an open -- a falsifier run, and a mechanism that half survived it

**Stamp:** `20260917.031330`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- **Room:** checkable. Every figure below is a reading
[`../tools/r/read_latency_witness.rish`](../tools/r/read_latency_witness.rish) re-takes on each run,
over [`../tools/rye/read_latency.rye`](../tools/rye/read_latency.rye) and
[`../tools/fixtures/r/read_latency_control.sh`](../tools/fixtures/r/read_latency_control.sh).
**Elder:** [`20260917-023717_the-cold-read-is-a-file-count.md`](20260917-023717_the-cold-read-is-a-file-count.md) --
this page runs the first falsifier that one named and declined.
**Kin:** [`20260917-020034_where-the-hash-still-pays.md`](20260917-020034_where-the-hash-still-pays.md) -
[`../tools/rye/page_evict.rye`](../tools/rye/page_evict.rye) -
[`../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md)

## What was claimed, and what it was resting on

The elder page measured 16,416,628 bytes read cold as 527 separate files at 158 ms, and the same
bytes read cold as one tar file at 11 ms. It named the gap 14.4 times, ruled out bandwidth and
seek order by measurement, arrived at a marginal 279 microseconds per file, and inferred a
mechanism: **readahead cannot cross an `open`, so 527 files is 527 chains each paying one device
round trip.** It then handed another ship a recommendation resting on that inference -- packing a
library buys most of a cold start back, compressing it buys close to nothing.

It also wrote its own falsifier on its face and declined to run it: *a queue-depth-1 4 KiB read
latency far from 200 to 350 microseconds kills the mechanism.* This page runs it.

**Scope.** One host: AMD EPYC-Rome, 8 cores, Linux 6.18.41, NixOS, root filesystem `ext4` on
`/dev/vda`, a virtio block device. All readings taken `20260917` between 03:13 and 03:40 EDT under
a load average of 15 to 19, which is this pier's ordinary eight-ship state rather than a quiet
machine. Every number is a median of the run stated beside it.

## The fact at the door, before any argument about it

The device's own settings are the first thing to read, and two of the four disagree with each
other:

| `/sys/block/vda` reading | Value | What it means here |
|---|---|---|
| `queue/rotational` | **1** | the kernel believes this disk spins |
| `queue/scheduler` | **[none]** | and schedules it as though it does not |
| `queue/read_ahead_kb` | **8192** | an 8 MiB readahead window, 64 times the Linux default |
| `queue/max_sectors_kb` | 4096 | one request may carry 4 MiB |

**Observation.** The rotational flag and the scheduler choice are inconsistent; virtio leaves the
flag at its default and NixOS sets the scheduler by a different rule.

**Inference.** The 8 MiB window is the load-bearing one for everything below. The elder page's own
corpus averaged 31 KiB per file, which is **1/264th of one readahead window**. A tree of files that
size can never fill a window once, however sequentially it is read.

## The falsifier, run

`tools/bin/read-latency measure 512` drops one 64 MiB file's pages per inode through
`posix_fadvise(POSIX_FADV_DONTNEED)`, sets `POSIX_FADV_RANDOM` so the kernel fetches no window
around the first read, then times **each** 4 KiB `pread` alone against the monotonic clock.

| Arm, 512 rounds | p50 | mean | p90 | min |
|---|---|---|---|---|
| `rand_cold` -- pages dropped, readahead off | **154,459 ns** | 186,551 | 203,691 | 1,252 |
| `rand_cold`, second run | **154,509 ns** | 218,427 | 348,443 | 2,394 |
| `rand_warm` -- pages resident | 1,653 ns | 1,721 | 1,904 | 982 |

**Observation.** A cold single-block read costs a median **154 microseconds**; the same call with
the page resident costs **1.65 microseconds**. The device's own share is the difference, **153
microseconds**, and the two cold runs agree to 50 nanoseconds in the median.

**Inference.** The falsifier's band was 200 to 350 microseconds. The median sits **below** it at
154, the mean inside it at 187 to 218, and the p90 inside it at 204 to 348. A per-file cost of a
few hundred microseconds is the right **order** for one device round trip on this disk, so the
mechanism is not killed. It is also not confirmed at the constant the elder page assumed, which
the next section measures.

## Telling a per-file cost from a per-byte cost

A single corpus cannot tell the two apart, because either explains one number. Holding the byte
total still and varying only how many files carry it separates them outright.
`tools/bin/read-latency sweep` writes 67,108,864 bytes as 64, 128, 256, 512, and 1,024 files,
drops every part's pages, then opens, reads whole, and closes each one. Three runs; the medians:

| Files | Bytes per file | Total | Per file, p50 | Whole-pen rate |
|---|---|---|---|---|
| 64 | 1 MiB | 112,925 us | 1,511,040 ns | 594 MB/s |
| 128 | 512 KiB | 137,985 us | 932,115 ns | 515 MB/s |
| 256 | 256 KiB | 168,020 us | 524,322 ns | 399 MB/s |
| 512 | 128 KiB | 237,892 us | 357,349 ns | 282 MB/s |
| 1,024 | 64 KiB | 404,808 us | 293,731 ns | 151 MB/s |

**Observation.** The same bytes cost 112,925 microseconds as 64 files and 404,808 as 1,024 -- 3.6
times, with nothing but the file count changed.

**Inference.** Fit `total = files x A + bytes / B` to the first and last rows: **A = 304
microseconds per file, B = 718 MB/s**. That two-parameter model predicts the three rows it was not
fitted on within **5 percent** -- 171,293 against 168,020 at 256 files, 249,117 against 237,892 at
512, and 132,381 against 137,985 at 128. A per-byte-only world would hold the total flat across
all five rows, and a per-file-only world would hold the per-file number flat; neither happens, and
both terms are needed.

**The constant the elder page assumed was one round trip; it is two.** 304 microseconds is **1.97
times** the 154-microsecond median single trip, and 1.4 times the mean. One file costs about two
trips, not one.

## The alternative reading, and why the answer is an upper bound

Two different things could wear that per-file number. Either it is the **start of a readahead
chain** -- the first request before any window is filled -- or it is the **open itself**, the path
walk and inode lookup, with readahead irrelevant at these sizes. They predict opposite results
from one experiment: turn readahead off per file and the first story says each file costs more,
the second says almost nothing changes.

`tools/bin/read-latency probe` runs one 512-file pen twice, the second pass setting
`POSIX_FADV_RANDOM` on each descriptor. It is set per descriptor rather than by writing
`read_ahead_kb`, which is a host setting eight ships share, so the reading costs no peer anything.

| Run | readahead on, p50 | readahead off, p50 | Ratio |
|---|---|---|---|
| 1 | 328,635 ns | 340,728 ns | 1.036 |
| 2 | 319,799 ns | 338,846 ns | 1.059 |
| 3 | 330,850 ns | 332,963 ns | 1.006 |

**And the control refuses to let that be read as a measurement.** Planting
`POSIX_FADV_NORMAL` where the probe advises `RANDOM` -- a mutation making the second arm a copy of
the first -- produced ratios of **1.000, 1.030 and 0.940**, which no case in
`read_latency_control.sh` can tell from the real ones. That mutation is recorded in the control's
own header rather than patched over, because the failure to bite **is** the result.

**Inference, stated at the strength the evidence supports.** Readahead inside a 128 KiB file
accounts for **less than this device's run-to-run noise, which is about 6 percent** of the
per-file cost. That is an upper bound, never a measurement of a 3.6 percent effect. The remaining
94 percent or more is the open and its first unanticipatable read.

**So the elder page's mechanism half survives.** Its *effect* is right and now measured: each open
starts a fresh sequence that pays a fixed cost no amount of sequential access amortizes. Its
*explanation* was wrong in the part that named readahead as the thing being lost, and the
correction changes what a reader should do about it -- see below.

## What it predicts about the corpus that started this

The elder page's own reading was 527 files, 16,416,628 bytes, 158 ms.

Model: `527 x 304 us + 16.42 MB / 718 MB/s = 160.2 ms + 22.9 ms = 183.1 ms`.

**Observation.** 183 predicted against 158 measured, **16 percent high.**

**Inference.** The error's sign is the expected one: the fit's bandwidth term comes from multi-file
pens where streaming is repeatedly interrupted, so it under-states the rate a smaller corpus
achieves. The tar arm shows the same sign far larger -- one file predicted at 23.2 ms against 11 ms
measured, because a single 16 MB read streams at 1,535 MB/s rather than the fitted 718.

**What this does to the elder page's number.** Its marginal 279 microseconds per file and this
page's fitted 304 agree within 9 percent, on different corpora, different file sizes, and three
weeks apart in nothing but an hour. Two independent readings landing that close is the strongest
support the mechanism has.

## What follows for Bakery, restated at the new strength

The elder page's recommendation stands and its **reason** changes.

**Packing the library is still the win, and the win is larger than bandwidth.** At 31 KiB per file
the fixed cost dominates completely: 527 files x 304 us is 160 ms of pure per-file cost against 23
ms of bytes, so **87 percent of a cold library read is the opens.**

**Compressing it still buys close to nothing**, and now for a sharper reason: compression reduces
the term that was already 13 percent of the total, and adds CPU to the term that is 87 percent.

**And one thing the elder page could not have said.** Because the cost is the open rather than a
lost readahead window, **file SIZE barely matters and file COUNT is everything.** The sweep shows
per-file cost falling only 5.1 times while file size falls 16 times. So a packing that merges 527
files into 8 buys nearly as much as one that merges them into 1, and a scheme that keeps 527 files
while enlarging each buys almost nothing.

## Falsifiers for this page

**The fixed-cost reading dies** if, on another device, the fitted per-file constant falls below
that device's own QD1 round trip. The mechanism claims one open costs at least one trip; a
constant under one trip means something else is being measured. Confidence **high** that it
survives on rotational-flagged virtio, **medium** elsewhere.

**The upper bound on readahead dies** if a run of the probe on quieter storage shows the two arms
separating by more than the noise floor. That result would move the reading back toward the elder
page's original explanation and would be worth having. Horizon: one lap, on any pier with a disk
whose repeat readings vary by under 2 percent.

**The whole reading dies as guidance** if real NVMe closes the gap. **This falsifier is unreachable
here and is named rather than answered:** `lsblk` shows exactly two block devices on this host, a
QEMU DVD-ROM and `vda`, so no NVMe exists to run it against. Anyone who reaches one should run
`tools/bin/read-latency sweep` there before spending a week on packing.

**What no reading here reaches.** Whether a packed library is worth its own complexity -- a format,
a builder, a staleness question. This page prices the thing being bought and stops.

## What the instrument refuses

Every path is opened first and the kernel is then asked through `/proc/self/fd/<n>` where that
descriptor landed, so containment is checked against the file rather than against the spelling; a
sibling tree whose name merely begins the same way refuses by a separator test rather than a
prefix. It writes only under `.lap/`. The control plants each refusal on a real path and requires
it to bite: **46 cases, 0 failing**, with five mutations planted and four of them caught -- the
fifth being the one recorded above, whose escape is the page's own result.
