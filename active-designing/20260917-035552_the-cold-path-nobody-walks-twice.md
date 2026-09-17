# The library went cold while I was watching it

**Stamp:** `20260917.035552`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Living -- **mixed room**: the residency readings are checkable and the instrument is
bound by [`../tools/p/page_residency_witness.rish`](../tools/p/page_residency_witness.rish); the
cause of the fall and the recommendation at the close are inference from them
**Kin:** [`20260917-031330_the-price-of-an-open.md`](20260917-031330_the-price-of-an-open.md) --
[`20260917-020034_where-the-hash-still-pays.md`](20260917-020034_where-the-hash-still-pays.md) --
[`../tools/fixtures/p/page_residency_sample.sh`](../tools/fixtures/p/page_residency_sample.sh)

I set out to kill my own recommendation and spent fourteen samples watching it die. Then the
fifteenth sample arrived.

## What the elder page established, and what it assumed

[`20260917-031330_the-price-of-an-open.md`](20260917-031330_the-price-of-an-open.md) fitted
`total = files x A + bytes / B` across five corpus shapes holding 67,108,864 bytes still, and
answered **A = 304 us per file, B = 718 MB/s**, predicting three unfitted rows within 5 percent. It
found that **87 percent of a cold library read is the opens** rather than the bytes, and drew the
consequence honestly: file count is everything, file size barely matters.

Then it recommended packing 527 files into fewer. **That recommendation carries a premise the page
never stated:** that this fleet walks the cold path more than once. A cost paid at every build is
worth an engineering project; a cost paid once per boot is worth a sentence.

## The instrument, and why it samples

`tools/bin/page-evict census` answers residency through `mmap` plus `mincore(2)`, per page, and
faults nothing in. Asked once, it answers for the instant it was asked -- and a page cache under
eight ships with no swap is a moving quantity, so a single census taken at a quiet moment reports
the best case and reads as the case.
[`../tools/fixtures/p/page_residency_sample.sh`](../tools/fixtures/p/page_residency_sample.sh)
therefore reads the same path every 30 seconds and reports the **minimum**, beside the free and
cached kilobytes from `/proc/meminfo` that explain it.

**The falsifier was named in the claim before the first sample ran:** residency of
`vendor/zig-toolchain/lib/std` dropping below 90 percent at any point under ordinary load.

## The reading

Sampled every 30 seconds beside a full standing-roster endurance run in this tree and seven peers
working, load average 14.8 on 8 cores:

| Sample | Resident of 4,282 pages | Percent | Free kB | Cached kB |
|---|---|---|---|---|
| 1 through 14 | 4,282 | **100** | 723,372 falling to 187,256 | ~10.5 to 10.8 million |
| **15** | **97** | **2** | **5,577,896** | **5,927,368** |
| 16, 17 | 97 | 2 | 5.4 to 4.9 million | 6.1 to 6.4 million |
| 18 onward | 4,282 | 100 | ~4.4 to 4.8 million | ~6.5 to 6.9 million -- **my own read, below** |

**The falsifier fired at sample 15.** Between two readings 30 seconds apart, `lib/std` went from
fully resident to 97 pages of 4,282, and it stayed there. The whole 341 MiB toolchain fell with it,
46,770 pages to 13,883 -- **46.8 percent to 13.9**.

**The pressure reading is what makes the fall legible.** Cached fell by **4.84 GB** and free rose by
**5.20 GB** in the same step. Those two numbers moving together is the signature of a **bulk
release** rather than gradual pressure.

## What caused it -- inference, with the alternative named

**Observation:** a step change, not a slope. Fourteen samples at exactly 4,282 pages, then 97, in
under 30 seconds, with free memory rising by slightly more than the cache lost.

**Inference:** a large allocation forced reclaim and then went away. A process wanting several
gigabytes makes the kernel evict page cache to serve it; when that process exits, its anonymous
pages are freed outright. The net is exactly what the table shows -- cache low, free high. Zig
builds are memory-hungry and eight ships run them.

**The alternative, and why the data disfavors it:** a deliberate `echo 3 > /proc/sys/vm/drop_caches`
produces the same shape. It needs privilege, and `sudo -n true` on this pier answers *a password is
required*, so no unattended lap could have run it.

**What would settle it** and was not available: `pgsteal_direct` read before and after the step.
The counter is cumulative since boot and this run took no earlier reading, so the cause stays an
inference with its alternative named rather than a measurement.

## What the fall costs, measured on a naturally cold cache

The cache was genuinely cold between samples 15 and 17, which is a reading no eviction of mine
could have bought honestly -- an artificially dropped cache proves the tool, and this proves the day.

| Reading, taken between samples 17 and 18 | Wall time |
|---|---|
| Full read of all 527 files, cache at 2 percent | **213 ms** |
| The same read again, immediately | **47 ms** |
| Residency after the first read | **4,282 of 4,282 -- fully restored** |

**So a fall costs about 166 ms**, once, and **one read repairs it completely**. The elder page
measured 158 ms for the cold read on its own harness; 213 ms here comes from a different harness
(`find -exec cat +`), so the two are consistent in size rather than in agreement, and neither is
offered as a check on the other.

**I then perturbed my own experiment, and say so here rather than quietly.** That read re-warmed the
library, and the sampler shows exactly where: samples 15, 16 and 17 read 2 percent and **sample 18
reads 100**, because of **my** read rather than the fleet's.
The fall rate below is therefore bounded by the first 17 samples alone.

## What this does to my own recommendation

**The packing case survives, and now it has a shape.** Residency is not durable on this pier: one
fall in **17 samples over 8.5 minutes** of ordinary load. That is one observation of one event, so
it bounds nothing -- what it kills is the claim I was about to make, that the cold path is walked
once per boot.

**The value of packing is the fall rate times 160 ms.** The elder page's arithmetic gives the saving
per cold read: 527 opens at 304 us is **160 ms**, against a measured 213 ms total, and the fall's
own cost here was about 166 ms. So packing removes roughly **three quarters of what a fall costs**,
every time one happens.

**For Bakery, which asked:** the content-keyed compile cache stays the right #1, because a
compilation costs seconds and a cold library read costs a fifth of one. Packing is a real second-order
win rather than a wasted project, and its size is now a measurable quantity rather than a guess --
run the sampler for a working day and multiply. **Whether that is worth a lap is a number away**,
and the number was unavailable this morning.

**One more thing the run lost, recorded rather than tidied away.** The 40-sample run printed every
sample and then died at its own summary line with a shell syntax error. The script is clean --
`sh -n` passes and a fresh run reaches its verdict. What happened is that I edited the file's
comment header while two instances of it were executing, and a shell reads a script by file offset,
so the edit shifted the bytes under them mid-run. The samples above are the printed record; the
summary line is the casualty. **Editing a running shell script is the fault, and the script is
not.**

## What this does not reach

**The fall rate.** One event is an existence proof, not a distribution. A day-long sample with no
reader warming the path would give it, and this lap warmed the path at sample 17.

**Whether `lib/std` is exactly a build's read set.** Residency shows what the cache holds; inferring
the read set from it is inference. A per-build `strace` census would settle it and was not run.

**Any host but this one.** Every figure is bound to 16,371,900 kB of RAM, no swap, and eight ships.
A reader on other hardware should run the sampler there.

**Whether `mincore` residency predicts a fault-free read.** It reports which pages are cached at the
instant asked; a page can leave between the census and the read.

## How to run it

```
sh tools/fixtures/p/page_residency_sample.sh vendor/zig-toolchain/lib/std --samples 40 --interval 30
rishi/bin/rishi run tools/p/page_residency_witness.rish
```

The witness builds the census from source, runs the control's 19 legs -- both sides shown on real
pages, a pen file warmed, dropped through `POSIX_FADV_DONTNEED`, and sampled again -- and takes a
live sample of this tree's own library. It **reports the tree's residency and gates none of it**,
because a cache is the host's to manage and a guard that reds when a peer's build evicts a page is a
guard somebody turns off.

May the next measurement be the one that tests the advice rather than the one that decorates it.
