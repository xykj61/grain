# The hardware cache-miss counter is readable on this pier

**Status:** Landed -- a readability probe, one run; the falsifier itself is not yet run
**Room:** research for understanding (no module claim; nothing here enters the checkable room)
**Kin:** [the radius-two stencil](20261009-215630_the-radius-two-stencil-moves-the-band-to-five.md) (the paper whose falsifier named this counter) - [the row band](20261009-214759_the-stencil-sweep-prefers-the-row-band.md) - [the energy proposal](20261009-181846_energy-follows-bytes-touched-a-falsifiable-proposal.md) (which found no power counter on this guest)

**Plain function.** A *hardware counter* is a number the processor keeps about its own work, here
the count of last-level cache misses. The radius-two paper's falsifier needs that count from a real
sweep. Its own text says the pier's `perf` was not read for that lap, so the counter stayed unknown.
This note reads it.

## Observation

Read on `20261009.221036`, on the 8-core AMD EPYC-Rome guest the energy paper already described:

| Reading | Value |
|---|---|
| `/sys/bus/event_source/devices` | `breakpoint cpu kprobe msr software tracepoint uprobe` |
| `cpu/events` includes `cache-misses` | yes (with `cache-references`, `instructions`, `cpu-cycles`) |
| `/proc/sys/kernel/perf_event_paranoid` | `2` -- user-space counting permitted for one's own process |
| `perf` binary on path | no |
| `/proc/cpuinfo` hypervisor flag | present (a guest, so the counter may be virtualised) |

The energy paper's absence stands: there is still no `power` source, so no joule figure exists.
What is new is the **cache-miss** source, which the energy paper never looked for.

**Probe.** One `perf_event_open` call through `ctypes` (no `perf` binary needed), counting
`PERF_COUNT_HW_CACHE_MISSES` with kernel and hypervisor excluded, enabled around a strided pass over
128 MiB of Python list cells. Output on the run:

```
open_ok cache_misses=432796 checksum=0
```

The count is nonzero and the open succeeded. The probe's source is reproduced in the appendix so the
reading can be repeated.

## Inference

The counter is readable from a user process here, so the hardware half of the radius-two falsifier
is no longer blocked by this guest. The gate that remains is a **real sweep**, not a counter.

**What the probe does not establish.** It does not prove the count is accurate. A virtualised
counter can under- or over-count, and a Python list's pointer traffic dominates a strided pass, so
the 432,796 figure says the counter moves, not what the sweep costs. Calibration needs a known
workload with an expected miss count, which the next step must supply.

## Projection, with horizon, falsifier, and confidence

**Horizon.** A single-threaded plus-shaped stencil of radius one and two over a square grid of
four-byte cells, compiled code, on this one guest. Nothing about other hardware is claimed.

**Falsifier, unchanged from the radius-two paper.** At a cache whose size reaches the radius-two row
band count (5N/16 lines in the model), Morton's measured miss count should exceed row-major's. A
result where Morton's count stays at or below row-major's at grid sizes past the boundary kills the
small-cache claim on this machine.

**Why the falsifier cannot be run as the model states it.** The model varies cache size in lines.
A real cache has a fixed size, so the test must vary the grid size instead, letting the row-band
working set cross the real last-level capacity. That is a translation of the model onto hardware,
and the translation itself is a claim that could be wrong. The paper does not pretend otherwise.

**Confidence.** Medium that the counter reads as a sweep needs it. Low that a real sweep reproduces
the model's boundary, since prefetch, sets, and the guest's cache partitioning all sit outside it.

## Buildable now, and not

**Buildable from this reading:** nothing in the tree yet. A sweep kernel is a new instrument, and
by the baton's own rule a new instrument is claimed before it is built. This lap opens no claim and
writes no kernel.

**Not buildable from this reading:** an energy figure (no power source), a Z-order speed claim on
real hardware, or any tile size tuned to this cache.

## The next door, named for a check-in

Build a compiled row-major and Morton sweep kernel, calibrate its miss count against a workload with
a known expected count, then run the grid-size sweep across the real last-level boundary. That is a
new instrument with a seam (compiled code, a counter read, a Rye or Rishi harness), so it is
Keaton's or Claude's to rule on before the claim opens. Recorded as a check-in, not a build.

## Appendix -- the probe, verbatim

```python
import ctypes, os, struct, sys
libc = ctypes.CDLL(None, use_errno=True)
SYS_perf_event_open = 298  # x86_64
attr = bytearray(128)
struct.pack_into("<II", attr, 0, 0, 128)            # type=PERF_TYPE_HARDWARE, size
struct.pack_into("<Q", attr, 8, 3)                  # config=PERF_COUNT_HW_CACHE_MISSES
struct.pack_into("<Q", attr, 40, (1 << 5) | (1 << 6))  # exclude_kernel, exclude_hv
buf = (ctypes.c_char * 128).from_buffer(attr)
fd = libc.syscall(SYS_perf_event_open, buf, 0, -1, -1, 0)
if fd < 0:
    print("open_failed errno=%d %s" % (ctypes.get_errno(), os.strerror(ctypes.get_errno())))
    sys.exit(0)
IOC_RESET, IOC_ENABLE, IOC_DISABLE = 0x2403, 0x2400, 0x2401
libc.ioctl(fd, IOC_RESET, 0); libc.ioctl(fd, IOC_ENABLE, 0)
n = 1 << 24
a = list(range(n // 8))
s = 0
for i in range(0, len(a), 8):
    s += a[i]
libc.ioctl(fd, IOC_DISABLE, 0)
val = struct.unpack("<Q", os.read(fd, 8))[0]
print("open_ok cache_misses=%d checksum=%d" % (val, s & 0xffff))
os.close(fd)
```

Run it with `python3 -I`. The counter is the measurement; the printed checksum only keeps the loop honest.
