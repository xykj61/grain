# The Table That Fits

**Stamp:** `20260906.042838`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Mixed. The latency curve is measured and its instrument refuses six ways; every
sentence about joules is proposed ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md)).
**Instrument:** [`../tools/fixtures/f/footprint_latency_census.sh`](../tools/fixtures/f/footprint_latency_census.sh)
over [`../tools/fixtures/f/footprint_latency_probe.rye`](../tools/fixtures/f/footprint_latency_probe.rye);
refusals proven by [`../tools/fixtures/f/footprint_latency_control.sh`](../tools/fixtures/f/footprint_latency_control.sh)

---

## What this paper claims, before the argument

**A data structure's cost is decided by which cache answers for it, and that is a property of its
footprint rather than of its size in the abstract.** On the board this was measured on, one
dependent read costs **1.65 ns** when the structure fits the first cache and **163.20 ns** when it
does not -- a factor of **98.9** for the same instruction over the same number of bytes. Across
nine runs on this shared host that ratio read between **93x and 102x**.

Two studies in this tree name that cost and leave it unmeasured. This one measures the half a
clock reaches, states plainly where a clock stops, and hands over one number a designer
can act on: **how many entries a table may hold before a lookup changes tier.**

**Scope.** One machine, one access pattern, one measurement, on `20260906`. Latency, never energy:
this board exposes no energy counter, which is itself a finding recorded below. The engineering
claim is about where state lives; every sentence connecting that to joules is inference, marked as
such, with its falsifier named.

## The sentence this answers

The ring-and-ladder study wrote, of a routing table read once per packet:

> *"That is a memory and lookup cost per packet, and memory that is read on every packet is the
> kind that shows up in a power budget. Confidence: high that the state costs differ; no
> measurement of the difference is offered here."*

The joule study, one day earlier, proposed two new bounds -- a **wake** bound and a **rate** bound
-- and both of those bound *time*. **Neither of the four axes bounds where the data lives.** Two
programs can hold every extent, work, wake, and rate maximum this tree asks for, run identical
instruction counts, and still differ by the factor above, because one program's table fits a cache
and the other's does not.

## The board, read at the door

Read from the kernel rather than assumed, on `20260906`:

| Reading | Value | Source |
|---|---|---|
| Processor | AMD EPYC-Rome, 8 logical CPUs | `/proc/cpuinfo` |
| Memory | 15.6 GiB | `/proc/meminfo` |
| L1 data cache | 32 KiB, 64-byte line | `/sys/devices/system/cpu/cpu0/cache` |
| L2 unified | 512 KiB | same |
| L3 unified | 16,384 KiB | same |

**And the reading that shapes everything below: this board can measure no energy at all.**
`/sys/class/powercap` publishes `energy_uj` nowhere, `/dev/cpu` is absent so the MSRs stay out of
reach, `perf` is missing from the image, and `perf_event_paranoid` reads 2. All four checked directly on `20260906`. A study
that wanted joules from here would have to invent them, so this one measures time and says so in
its title claim.

## The measurement

The probe walks a **random single cycle** through a buffer, one node per cache line, so that every
step is a load whose address is unknown until the previous load has landed. That is the shape a
routing lookup has: the next hop arrives only once the index is known. Each reading is the
**minimum of four repetitions of two million dependent loads**, because on a shared host noise only
ever adds, so the minimum sits closest to the machine's own cost.

Canonical run, `20260906.042838`:

| Working set | ns per read | Working set | ns per read |
|---|---|---|---|
| 4 KiB | 1.64 | 768 KiB | 13.94 |
| 8 KiB | 1.64 | 1,024 KiB | 15.49 |
| 16 KiB | 1.64 | 2,048 KiB | 17.26 |
| 24 KiB | 1.64 | 4,096 KiB | 18.88 |
| **32 KiB** | **1.65** | 8,192 KiB | 42.30 |
| **48 KiB** | **4.29** | 12,288 KiB | 81.24 |
| 64 KiB | 4.30 | 16,384 KiB | 142.47 |
| 128 KiB | 4.40 | 20,480 KiB | 145.23 |
| 256 KiB | 4.45 | 32,768 KiB | 148.65 |
| 384 KiB | 7.46 | 49,152 KiB | 152.27 |
| 512 KiB | 10.26 | 65,536 KiB | 163.20 |

**Observation.** The curve rises by **99.5x** across the sweep. It steps by **2.60x** between 32
KiB and 48 KiB. Crossing the L3 boundary, from 4 MiB to 32 MiB, costs **7.87x**.

**Inference.** The step at 32 KiB lands exactly on the L1 data cache size the kernel reports, from
a wholly separate source: the kernel reads a CPUID leaf and the probe reads a clock, so each
reaches its answer by its own route. Their agreement is what makes the curve a reading of the memory
hierarchy rather than a reading of the weather.

## One cliff and two ramps

**Only the first boundary is a cliff.** L1 ends in a single step. L2 and L3 end in ramps spread
over several sweep points, and three runs of the same probe show how differently the two shapes
behave under a shared host:

| Reading | run 1 | run 2 | run 3 |
|---|---|---|---|
| step across L1d, 32 -> 48 KiB | 2.58x | 2.60x | 2.61x |
| step across L3, 16 -> 20 MiB | 0.98x | 1.00x | 1.13x |
| span across L3, 4 -> 32 MiB | 7.90x | 8.86x | 7.79x |

**A boundary that is a ramp gives an unstable adjacent step and a stable span.** The L3 step swings
by a sixth between runs and sits at or below 1.00x twice in three, so the curve is flat there and
any step floor would refuse; the span across that same boundary holds within 14%. The L1 step holds
within 2%.

This was learned by being refused, twice. The census first asserted that the largest single step in
the curve sits at L1. It passed once and refused on its next run, because this part's L1 step and
its L3-region step are the same size to within noise, so a disturbed reading decides which is
"largest". Rewritten to test each boundary where the kernel says it is, it refused again -- on the
L3 step, for the reason the table above shows. **A leg whose answer a noisy neighbor can flip
measures the weather.** Each boundary is now tested in the shape it actually has: L1 as a step
between neighbors, L3 as a span from well inside to well outside.

**A third refusal taught the same lesson about tolerances.** The census held its monotonicity
check at a flat five percent and then refused about one run in three, always in that same 8-16
MiB band, where the probe declares spreads of 60-157% between its own repetitions. A reading
that says it is uncertain to 157% supports no five-percent claim about its neighbor. So each
pair is now forgiven up to the spread the probe itself measured there, with five percent as the
floor where the board is quiet. **An instrument that publishes its own uncertainty should be
made to use it.** Eight of the nine runs taken since stand green, with the L1 step reading 2.53x to 2.70x
throughout, and the control proves both sides: a 27% fall at a quiet point is bitten, and the same
fall at a point declaring 157% is forgiven. **The ninth refused, and its leg went unrecorded** --
the readings captured from it rule out five of the six, leaving `monotone` as the only candidate,
which is inference rather than observation and is written here as such. A refusal is the safe
direction: the census declines to report rather than reporting a curve it mistrusts.

The engineering consequence is worth stating on its own: **"fits in L1" is a bright line and "fits
in L3" is a slope.** A design that leans on the second is leaning on something that bends.

## What predictability is worth, measured

The control plants a probe whose walk is a constant stride of one cache line -- still one cycle
over every node, so the probe's own invariant is satisfied, and merely *predictable*. The hardware
prefetcher then does its work:

| Working set | random walk | constant stride |
|---|---|---|
| 32 KiB | 1.65 ns | 1.64 ns |
| 4 MiB | 18.88 ns | 1.80 ns |
| 64 MiB | 163.20 ns | 5.34 ns |

**Observation.** Inside L1 the two are identical. At 64 MiB the predictable walk costs **31x less**.

**Inference, and it is the paper's sharpest.** The 99x penalty is no penalty for holding a large
table. It is a penalty for holding a large table *and reading it at an address the hardware
could not predict*. A routing lookup is exactly that -- the index comes from the packet. So a router's table
sits on the expensive side of this measurement by construction, while a sequential sweep over the
same bytes does not.

## The number a designer acts on

The threshold is a **count** rather than a size:

| Entry size | Entries that fit L1d | fit L2 | fit L3 |
|---|---|---|---|
| 8 bytes | **4,096** | 65,536 | 2,097,152 |
| 16 bytes | 2,048 | 32,768 | 1,048,576 |
| 32 bytes | 1,024 | 16,384 | 524,288 |

## And at our own seated scale it does not bite yet

The companion study measured the two shapes' revocation state: a ring needs one table entry per
revoked point, a ladder one per 18.4 points. The seated compass sky holds **720 points**.

**A ring's worst case is therefore 720 entries -- 5,760 bytes at 8 bytes each, which is 17.6% of
this board's L1 data cache.** The ladder's is about 39 entries, or 312 bytes. Both sit in the 1.65
ns tier with room to spare, and the 98x penalty this paper measures is unreachable from either.

**The ring leaves L1 at 4,096 revoked points; the ladder at roughly 75,400.** The first of those is
**5.7x the entire population of the seated sky**, so the state-cost argument is real in mechanism
and inert at the scale we run. Naming that plainly matters more than the measurement did: a paper
that measured 98x and stopped would have sold a threshold this tree stands 5.7x short of.

## The third axis, and it is checkable at an edge

The joule study set the bar for a bound worth writing: *"a bound checkable at an edge is the only
kind worth writing -- the rest are wishes."* A footprint bound clears that bar at **compile time**,
which is one better than an edge:

```
const l1d_budget_bytes: u32 = 32 * 1024;  // measured, 20260906; per-target, never guessed
const max_route_entries: u32 = 4096;

comptime {
    // invariant: the whole table fits the first cache, so a lookup costs the 1.65 ns tier
    // rather than the 163.20 ns one -- measured on this target rather than assumed.
    assert(@sizeOf(RouteEntry) * max_route_entries <= l1d_budget_bytes);
}
```

Zero runtime cost, refused before the program exists, and it fails **loudly on the day someone
widens the entry struct** -- which is exactly when this cost is silently added today. It is the
same discipline the tree already writes, applied to a quantity whose denominator is a cache rather
than a byte count.

**A footprint bound is per-target and must be read rather than recalled.** The number above belongs
to one board; a part with a 48 KiB L1 gets its own. Writing a cache size into portable source is
how a bound becomes a wish again.

## Where time and energy part company

**No joules were measured.** Three places this proxy and the quantity it stands for diverge, each
named rather than waved past:

**A stall still leaks.** Static energy accrues while a core waits on memory, so wall time tracks
that term honestly. This is the direction the proxy gets right.

**A miss spends energy the clock never sees.** A DRAM access energizes bit lines, I/O drivers, and
the memory device itself, all of which an L1 hit leaves alone. Prior art puts that ratio well above the
latency ratio -- *recalled rather than fetched, and flagged accordingly, since this pier has no
network access to check it.* If that recollection holds, the energy gap is **wider** than the 98x
measured here, and this paper understates its own case.

**Concurrency hides latency and pays energy anyway.** The probe serializes its loads deliberately,
so it measures latency. A real router with several packets in flight overlaps its misses, so wall
time per lookup falls while energy per lookup holds. **This is the caveat that matters most, and
it cuts toward the argument rather than against it:** in a concurrent program the clock understates
the footprint problem, which means a design tuned by wall time alone will under-weight it.

## What would refute this

**The measurement.** Run the census on this board and get a curve that does not step at the size
the kernel reports for L1d. The instrument refuses rather than reporting when its two sources
disagree, so this failure appears as a refusal rather than as a wrong answer.

**The energy inference.** Exhibit a part whose measured energy per L1 hit and per DRAM access sit
within a factor of two. Given such a part, footprint stays a latency axis, the third-axis
proposal keeps only its latency argument, and the wake and rate bounds carry the whole load.

**The deflation.** It expires by growth. Should a seated sky exceed roughly 4,096 simultaneously
revoked points, the ring's table leaves L1 and the argument becomes live for us rather than for
someone larger. At 720 points that is 5.7x away.

*Horizon: the next decade of cache-based CMOS parts. Assumptions: routing state is read at an
unpredictable index once per packet, and the target holds a conventional cache hierarchy. A part
with a software-managed scratchpad in place of a cache turns the whole question into a placement
decision. Confidence: **high** on the latency curve, which was measured six ways over nine runs with every
refusal proven on metal; **high** on the threshold arithmetic, which is division and is shown; **medium**
on the energy inference, which rests on prior art recalled rather than fetched.*

## What this paper does not do

It measures no energy, on any device. It measures one machine, so every figure is a reading of this
board rather than of a family of parts. It leaves every module as it found it: `comlink/` belongs to the seat that
holds it, and the footprint bound above is offered as a shape rather than committed as a change.

## Yours, BAKERY

**One buildable, and it is small.** A `comptime` footprint assert beside the bounds Aurora, Tally,
and Caravan already name -- the pattern above, one line, per target, read from the machine rather
than typed from memory. The census prints the budget table it needs.

**One measurement worth repeating on your own board**, since the number is per-part and this one is
a shared virtual host: `sh tools/fixtures/f/footprint_latency_census.sh`. It takes about ninety
seconds and refuses rather than guessing when the timer and the kernel disagree.

**One thing named and not taken.** The 8 MiB to 16 MiB readings carried spreads of 157%, 67%, and
83% across repetitions, against 0-9% everywhere else. That band is where L3 is shared with whatever
else runs on this host, and it is the one region of the curve a reader should trust least.
