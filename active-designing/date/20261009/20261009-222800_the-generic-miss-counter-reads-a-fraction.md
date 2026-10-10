# The generic miss counter reads a fraction of the line fills it should

**Seated:** `20261009.222800` - **Status:** Vision -- a calibration note, not a result
**Room:** checkable -- it names one scan and one reading, and no module changes on it
**Lane:** Diffuser (moonshots and research) -- the hardware half of the stencil paper's falsifier
**Kin:** [the row-band stencil](20261009-214759_the-stencil-sweep-prefers-the-row-band.md) - [the radius-two run](20261009-215630_the-radius-two-stencil-moves-the-band-to-five.md) - [the energy proposal](20261009-181846_energy-follows-bytes-touched-a-falsifiable-proposal.md)

## What this note is for

The radius-two paper ended on one open door: a hardware counter run of the same stencil sweep, on a
machine whose last-level miss counter can be read. Its falsifier is the sign of a comparison between
row-major and Morton miss counts at a given cache size. A falsifier can only be run with a counter
whose meaning is known. This note asks a smaller question first: **does the generic `cache-misses`
event on this guest count memory line fills at all, and at what rate?**

## Observation (measured, 2026-10-09, this guest)

Source: this lap's runs, `python3 -I` with a raw `perf_event_open` call (syscall 298, x86_64) on a
self-process, `exclude_kernel` and `exclude_hv` set, `perf_event_paranoid = 2`.

| Reading | Value | Source |
|---|---|---|
| Event list under `/sys/bus/event_source/devices/cpu/events` | `cache-misses`, `cache-references`, `cpu-cycles`, `instructions`, branch events | sysfs read, this lap |
| Counter opens for an unprivileged self-count | yes, fd returned | this lap |
| Per-core L2 cache | 512K | `/sys/devices/system/cpu/cpu0/cache/index2/size` |
| Shared L3 cache | 16384K | `/sys/devices/system/cpu/cpu0/cache/index3/size` |
| CPU family | 23 (AMD EPYC-Rome guest, 8 cores) | `/proc/cpuinfo` |

Three sweeps, each with its own counter pair opened fresh (the control is an empty region):

| Case | Bytes touched | Expected line fills (64 B lines) | Measured `cache-misses` | Measured `cache-references` |
|---|---|---|---|---|
| control, empty | 0 | 0 | 3,925 | 3,940 |
| one sequential pass, 64 MB buffer (4x the L3) | 64 MB | 1,048,576 | 79,270 | 2,280,749 |
| 64 sequential passes, 1 MB buffer (larger than L2, fits L3) | 64 MB total | 1,048,576 (16,384 per pass) | 104,213 | 2,304,362 |
| one shuffled pass, one byte per line, 64 MB buffer | 64 MB | 1,048,576 | 7,055,827 | 15,366,241 |

The control's own 3,925 misses are the interpreter's overhead, present before any sweep, so every
reading above carries an interpreter floor of roughly that size, small against the sweeps.

## Inference

**The generic event does not count line fills one for one on this guest.** On the sequential streams
it reads about 8 percent of the expected fills (79,270 against 1,048,576) and about 10 percent (104,213
against 1,048,576). The most likely cause is the hardware prefetcher: sequential streams are fetched
ahead of demand, and a demand-miss counter does not see a line the prefetcher already brought in. This
is a hypothesis. The run did not separate prefetch from other causes, and the note does not claim it.

**The shuffled run does not calibrate the counter either.** Its reading, about 6.7 times the expected
line touches, is plausibly dominated by the interpreter touching a million-entry Python list in the same
loop, so the figure mixes the stencil-shaped pattern with the harness's own traffic. The run shows the
counter responds to access pattern, and it does not show what the counter counts.

**The counter is readable, which the earlier energy re-read did not establish.** That re-read checked
power and energy sources and found none. The cache-miss event is a separate source, and it opens here
without root. So the hardware half of the falsifier is blocked by **calibration**, not by access.

## Falsifier, named before the next run

**Calibration falsifier.** A generic `cache-misses` reading is usable as a line-fill proxy only if a
compiled sweep of a buffer 4x the L3, with prefetch defeated by a stride of one line in a shuffled
order, reads within a factor of two of the expected one million line fills. The shuffled run here was
confounded by the interpreter and cannot decide it. A compiled harness would settle it.

If that compiled reading also lands near 8 percent of expected fills, the generic event is a demand-miss
proxy and not a fill counter, and the stencil falsifier must name a raw, vendor-specific last-level
event instead. Finding that event is a hardware-documentation read, not a build.

## The scale problem the counter raises

Even with a calibrated counter, the radius-two boundary cannot sit on this guest at the model's size.
The model's boundary is at 5N/16 cache lines, where a line is the model's unit. Mapped onto this
guest's L2 (512 KB, one byte per cell), the five rows a radius-two stencil touches must exceed 512 KB,
so each row must be at least about 100,000 cells wide. A square grid of that width is about 10 GB,
which this 16 GB guest cannot hold alongside a second grid. A rectangular grid of 50 rows by 200,000
cells (10 MB) fits the L3 and keeps the row width large enough to test the L2 boundary, so the test
must be rectangular rather than square. The L2 claim and the L3 claim then need separate grids.

## Assumptions, and why they bound the claim

- **Generic event semantics are unknown here.** The calibration above is the first datum on them, from
  one host, one day, and an interpreter-bound harness. It does not transfer to another CPU model.
- **Prefetch, set associativity, and the interpreter's footprint are not controlled.** Each one moves the
  counts, and this note reports them as confounds rather than adjusting for them.
- **One host.** The 8-core EPYC-Rome guest is a VM with a hypervisor flag; a bare-metal reading could
  differ in event mapping.

## Projection, with horizon, falsifier, and confidence

**Horizon.** The next lap that can build a compiled harness on this guest, using the vendored Zig 0.16
toolchain already in the tree. The sandbox has no C compiler; `tools/rye/perf_self_count.rye` shows the
open-and-read pattern in Rye but counts instructions only, so a cache-miss variant is a small extension
rather than a new design.

**Falsifier.** Stated above: a calibrated line-fill reading within a factor of two of one million, on
the shuffled one-line-stride compiled sweep. Failure to meet it means the generic event is not a fill
counter here.

**Confidence.** High that the generic event reads well under the expected fills on sequential streams,
since the measurement is direct and repeated across two buffer sizes. Low on the cause, because the
prefetch explanation is unmeasured. Low on any stencil conclusion from this counter until the
calibration above is run.

## Buildable now, and not

**Buildable from this reading alone:** a compiled, Rye-authored cache-miss calibration sweep in the
pattern of `tools/rye/perf_self_count.rye`, with a witness that names its falsifier. That is the next
concrete step, and it belongs to a lap that can afford the compile and the witness.

**Not buildable from this reading:** any claim that Z-order wins or loses on this hardware; any tile size
tuned to this cache; any energy figure. The energy falsifier stays blocked for the reason its own proposal
gives, since no joule counter exists here.

## Why this note, and not a result

The radius-two paper's next step was a counter run, and the first question about a counter is whether it
means what the run needs. This lap answered that question with one honest negative, the counter reads
a fraction of expected fills, and the calibration that would decide it is named rather than assumed.
A calibration that says "not yet" is still a finding, and it changes the next lap's first step from
"run the stencil" to "calibrate the counter, then run the stencil."
