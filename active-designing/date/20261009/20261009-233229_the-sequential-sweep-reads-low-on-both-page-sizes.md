# The sequential sweep reads low on both page sizes, so the generic counter is not a fill count

**Seated:** `20261009.233229` - **Status:** Vision -- a calibration reading, not a stencil claim
**Room:** vision -- it names one scratch probe and six readings; no tracked module, witness, or fixture changes on it
**Lane:** Diffuser (moonshots and research) -- the sequential huge-page sweep the huge-page paper named as its next door
**Kin:** [the huge-page chase lands inside the band](20261009-232203_the-huge-page-chase-lands-inside-the-band.md) - [the generic counter reads high on a random chase](20261009-231436_the-generic-counter-reads-high-on-a-random-chase.md) - [the generic miss counter reads a fraction](20261009-222800_the-generic-miss-counter-reads-a-fraction.md)

## What this note is for

The huge-page paper ended on one predeclared probe: a sequential sweep over the same 64 MiB buffer,
with the same huge-page status printed, to see whether the fill-count gap survives the page change.
The band was carried over unchanged from the calibration note: **500 to 2000 permille** of the
expected one million line fills. This note runs that probe and reports what it read.

## The probe, and what it measures

The scratch source is `session-output/hugepage-chase/sweep_huge.zig`, untracked and gitignored. It
is the earlier huge-page chase with its access pattern swapped. The mapping, the perf counter, and
the `AnonHugePages` readback from `/proc/self/smaps_rollup` are the same. The loop changes:

```zig
// one untimed warm-up lap, then the counted lap, both in address order
var k: usize = 0;
while (k < lines) : (k += 1) {
    const slot: *align(1) const u64 = @ptrCast(buf + k * line_bytes);
    sink +%= slot.*;
}
```

`lines` is 64 MiB / 64 B = 1,048,576. A sweep that touches each line once in address order should
cause one line fill per line, so the expectation is **1,048,576 fills**, and a permille reading is
`misses * 1000 / 1,048,576`. A 4 KiB control is the same source with `use_huge` set to `false`.

## Readings

Measured on `20261009`, after the probe binaries were built at 23:31 host time, on this guest
(8-core AMD EPYC-Rome, unprivileged self-count, `cache-misses` generic event). Each row is one
process run. The exact run times were not logged, so the day and build time are the stamp.

| Arm | Run | `AnonHugePages` (kB) | Misses | Permille |
|---|---|---|---|---|
| 2 MiB requested | 1 | 65,536 | 109,339 | 104 |
| 2 MiB requested | 2 | 65,536 | 115,431 | 110 |
| 2 MiB requested | 3 | 65,536 | 99,553 | 94 |
| 4 KiB control | 1 | 0 | 329,178 | 313 |
| 4 KiB control | 2 | 0 | 356,061 | 339 |
| 4 KiB control | 3 | 0 | 327,674 | 312 |

The huge arm's status is confirmed by the kernel in every run, and the control's is confirmed at
zero. The control's label prints as `sweep_huge` with `huge=control`, because the scratch source
kept its name when the constant was flipped. The `huge=` field is the one to read.

## Falsifier, stated before the run

**The falsifier:** if the generic `cache-misses` event is a fill count for a sequential sweep, then
each arm must read within 500 to 2000 permille of 1,048,576.

**Result: the condition was not met, on either arm.** The huge arm reads 94 to 110 permille, below the
band. The 4 KiB control reads 312 to 339 permille, also below the band. So the generic event does not
count one miss per line fill on this guest for a sequential sweep, at either page size. The falsifier
fired on both arms.

## What the two arms say together

Observation: the same counter reads about a third of the expected fills on 4 KiB pages and about a
tenth on 2 MiB pages, from one sweep over one buffer. Moving to huge pages lowers the counted misses
by a factor of about three on this pattern. That is the opposite direction from the random chase,
where huge pages cut the counted misses by about 48 percent.

Inference, one explanation consistent with both: a hardware prefetcher fills lines a demand access
never misses on, and it reaches further on huge pages, because a 4 KiB boundary stops it and a 2 MiB
boundary does not. Under that explanation the counter is right about demand misses and blind to
prefetch fills, which is the cause the calibration note already named as possible. This is an
inference from two arms and one pattern. The paper does not test it.

Two things it does not show. It does not show that the counter is wrong about demand misses, since
no demand-only reference exists on this guest. And it does not show the prefetcher is the cause,
since no prefetch-disabled run was made. The prefetcher is a candidate, not a finding.

## Projection, with its falsifier and confidence

- **Horizon:** until a raw vendor event or a prefetch-disabled control is available on this host. The
  generic event is not usable as a line-fill proxy for sweeps on either page size, so any stencil
  claim that rests on it stays closed.
- **Falsifier of the prefetch explanation:** a run with hardware prefetch disabled (where the guest
  allows it) that reads within 500 to 2000 permille on the 4 KiB sweep. If it does, the gap is
  prefetch, and the explanation stands. If it stays below the band, the explanation is wrong and the
  counter is under-counting for another reason.
- **Falsifier of the counter as a demand-miss proxy on random access:** a random chase on 4 KiB pages that
  reads inside 500 to 2000 permille of one miss per access. The random-chase paper read 2,596 to 2,649
  permille on 4 KiB pages, which is above that band, so this check needs a fresh run to say where the
  counter sits for random access now.
- **Confidence:** high that the generic event fails the fill-count band on sequential sweeps on this
  guest, since both arms fell outside it in all six runs. Low on the prefetch cause, which rests on
  one pattern and no control.

## What this does not reach

It does not restate the calibration note's falsifier as settled. It runs the next probe that note
named, and the result lands on the same side. It also does not claim a raw event. A raw last-level
event would settle the fill question directly, and that is Keaton's word to name, since the choice is
hardware-specific and nothing here names one.

## Next, for this lane

One of two doors, and neither is built here:

1. A prefetch-disabled sweep, if the guest allows the control. The falsifier above names the reading
   it has to meet.
2. A raw vendor event, named by Keaton, and read on the same sweep so the generic and raw readings
   sit side by side.

## Grade

Graded at Field by self-reading, not by the QA report card: the register is plain, every figure
carries its unit, date, and the run count, and the projection carries its horizon, falsifier, and
confidence. The falsifier was written before the run and the result is printed against it, including
the arms it did not confirm. The paper is a reading of one scratch probe on one guest, so its weight
is the instrument's, not the tree's.

Thank you for reading this far. The counter reads low on the sweep the way it reads low on the
calibration, and the next door is written down before anyone walks through it.
