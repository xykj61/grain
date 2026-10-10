# The falsifier needs a wide grid, not a big one

**Status:** Landed -- a check-in note with a named next door; no instrument built, no claim opened
**Room:** vision (nothing here is bound by a witness; the falsifier stays unrun)
**Kin:** [the hardware counter is readable](20261009-221036_the-hardware-counter-is-readable-here.md) (the probe this note builds on) - [the radius-two stencil](20261009-215630_the-radius-two-stencil-moves-the-band-to-five.md) (the paper whose falsifier this translates) - [the row band](20261009-214759_the-stencil-sweep-prefers-the-row-band.md)

**Plain function.** The model in the stencil papers measures cache size in *lines*, 64 bytes each.
A real machine has a cache of fixed size in *bytes*, and the grid's shape decides how many bytes a
row band takes. This note asks a narrow question: on this guest, which grid can actually cross the
boundary the falsifier names, and what shape must it have to do so.

## Observation

Read on `20261009.221533`, on the 8-core AMD EPYC-Rome guest, from `/sys/devices/system/cpu/cpu0/cache`
and `free -m`:

| Level | Size | Shared by |
|---|---|---|
| L1 data | 32 KiB | cpus 0-1 |
| L2 unified | 512 KiB | cpus 0-1 |
| L3 unified | 16,384 KiB | cpus 0-7 |

Memory: 15,988 MB total, 13,538 MB available. The guest reports 8 online cpus.

A compiler is in the tree. `vendor/zig-toolchain/zig` reports `0.16.0`. No `cc`, `gcc`, or `clang`
is on the system path. The earlier note's assumption that a compiled kernel needed a new toolchain
does not hold: the tree already carries one.

The cache sizes are the guest's view. The host may share that last-level slice with other tenants,
so the effective capacity here is not read from these numbers. It is a calibration item below.

## Inference

**The model's axis is lines; the machine's is bytes.** The radius-two falsifier says the small-cache
claim is in force while the cache holds fewer than `5N/16` lines, where `N` is the row length in
cells and each cell is four bytes. Convert that to bytes and the boundary is five row bands:
`5 x N x 4` bytes. The band count is a property of the row length, not of the square side.

**A square grid cannot reach the boundary on this guest.** Five bands exceed the 16 MiB L3 only
when a row holds more than `16,777,216 / (5 x 4) = 838,860` cells. A square grid that wide holds
`838,860 squared` cells, about `2.8 x 10^12` bytes, roughly 2.8 TB. The guest has 15.9 GB of memory.
So the falsifier cannot be tested by growing a square grid here.

**A wide, short grid can.** Keep the row count small and let the row length carry the band count.
Eight rows of 838,861 cells is `8 x 838,861 x 4 = 26.8 MB`, about 25.6 MiB, which fits in memory and
is past the L3 boundary. Sixteen rows is about 51.2 MiB. These are the sizes the next lap would
measure. The arithmetic is the whole result: the translation the paper said it could not make is
made by changing the shape, not the scale.

**The lower boundary is cheap.** Five bands fit the 512 KiB L2 only when a row holds at most
`524,288 / 20 = 26,214` cells. A grid of that row length is 105 KB per row, so the L2 arm needs
memory of tens of megabytes, not gigabytes.

**Which level the counter sees decides which arm is testable.** The probe reads
`PERF_COUNT_HW_CACHE_MISSES`. The note does not establish which cache level that generic event
counts on this AMD guest. If it counts L3 misses, only the wide-grid arm is informative. If it
counts L2 misses, the 26,214-cell row arm is the testable one, and it is far cheaper. The first
calibration step settles this and is not assumed here.

**A layout caveat.** The model's Morton order is defined over a square. On an 8-row-by-838,861 grid,
a Z-order needs a padding or blocking choice that the model never tested. That choice is a second
translation, and this note names it rather than hiding it inside the first.

## Projection, with horizon, falsifier, and confidence

**Horizon.** A single-threaded five-point-plus-radius-two plus-shaped stencil of four-byte cells, on
this one guest, with compiled code. Nothing about other hardware, other stencils, or energy is
claimed.

**Falsifier, named before any run.** Two arms, both from the model's own claim.

- **Arm A, row bands fit the cache (row length below 26,214 for L2, below 838,860 for L3).** The
  model says Morton's own order beats row-major only below the band count, so here row-major should
  reach its compulsory rate. Kill condition: Morton's miss count is at or below row-major's on a
  grid that fits, at a size where the counter is calibrated to read.
- **Arm B, row bands exceed the cache (row length past the boundary).** The model says Morton's
  count falls below row-major's. Kill condition: Morton's count is at or above row-major's on a wide
  grid past the boundary.

The first arm can be run at tens of megabytes. The second needs the eight-to-sixteen-row grids above.

**Confidence.** Medium on the arithmetic, since it uses the guest's own sizes. Low on the boundary's
exact position, since prefetch, set associativity, and the shared L3 slice all sit outside the
model. Low that a Z-order over a wide rectangle reproduces the square result without the padding
caveat being decided first.

## Buildable now, and not

**Buildable from this reading:** nothing is built. The sizes above are arithmetic, and the toolchain
fact is a reading.

**Not buildable from this reading:** a joule figure (still no power source), a Z-order speed claim on
real hardware, or any tile size tuned to this cache.

## The next door

A new instrument: a compiled row-major and Morton sweep through `vendor/zig-toolchain/zig`, with the
counter opened from compiled code, calibrated first. The calibration has three parts, each with an
expected count written down before the run:

1. **Known-count sequential read** of a buffer past L3, where the expected line count is the buffer
   size over 64 bytes. Prefetch can reduce demand misses, so the count is a bound, not a value.
2. **Pointer chase** over a 64 MiB randomised cycle, where each access should miss, so the count
   should sit near the access count.
3. **Capacity knee** by touching working sets from 4 MiB to 64 MiB, to read the effective L3 rather
   than trust the guest's report.

Only after those does the falsifier's arm A run, then arm B on the wide grids.

This is a new instrument with a seam (compiled code, a counter read from it, a padding choice), so
the baton's rule applies: claim, push, then build. That claim is the ruling the previous note asked
for, and this note does not open it. It is Keaton's or Claude's word to give, and it is named here
as the next door, not taken.

## What this does not reach

**Whether the boundary is real on this machine.** Only a run can say that, and no run was made.

**Whether `cache-misses` is an L3 or an L2 event on this guest.** Calibration settles it; this note
leaves it open on purpose.

**Energy.** The energy proposal's blocked reading is unchanged by anything here.
