# The huge-page chase lands inside the band, and the counter is still not a fill count

**Seated:** `20261009.232203` - **Status:** Vision -- a calibration rerun, not a stencil claim
**Room:** vision -- it names one scratch probe and six readings; no tracked module or witness changes on it
**Lane:** Diffuser (moonshots and research) -- the rerun the random-chase paper named as its next door
**Kin:** [the generic counter reads high on a random chase](20261009-231436_the-generic-counter-reads-high-on-a-random-chase.md) - [the generic counter reads a fraction](20261009-222800_the-generic-miss-counter-reads-a-fraction.md) - [the calibration witness](../../../tools/c/cache_miss_calibrate_witness.rish)

## What this note is for

The random-chase paper read the generic `cache-misses` event at **2596 to 2649 permille** of the one-miss-per-access expectation, above its own 500 to 2000 band, and named one explanation it could not test on 4 KiB pages: page-walk references counted as misses, since the 64 MiB buffer spans 16,384 pages. Its falsifier for that explanation was stated before the run, and it is copied here unchanged:

> A huge-page chase that falls inside the 500 to 2000 band, with the huge-page status confirmed.

The same paper warned that a huge-page run which silently fell back to 4 KiB pages would read the same as no change. So this rerun prints the kernel's own `AnonHugePages` figure beside every counter reading, and a reading without that figure is not counted.

## Observation

**Host.** 8-core AMD EPYC-Rome guest, 2 MiB L2 per core, 16 MiB L3 shared, 64 MiB buffer, `/sys/kernel/mm/transparent_hugepage/enabled` = `madvise` (read `20261009.232013`). Counter: `perf_event_open` self-count, `HARDWARE` / `CACHE_MISSES`, `exclude_kernel` and `exclude_hv` set, the same as the earlier probe. Toolchain: Zig 0.16.0 at `vendor/zig-toolchain/zig`, `-OReleaseFast`.

**Method.** One source file, `session-output/hugepage-chase/chase_huge.zig`, compiled twice with the flag as a compile-time constant. The control maps the buffer with `mmap` at 4 KiB pages. The huge arm maps 64 MiB plus one extra 2 MiB, aligns the base to 2 MiB, and calls `madvise(MADV_HUGEPAGE)` on the 64 MiB before the first touch. The chase itself is the earlier probe's loop, unchanged: one Sattolo cycle over 1,048,576 lines of 64 bytes, seeded xorshift64, one untimed warm-up lap, the counter enabled around the timed lap only.

**Readings.** The three pairs ran alternately on this guest, the way the earlier paper ran its runs.

| Run | Arm | `AnonHugePages` (kB) | Misses | Permille of expected |
|---|---|---|---|---|
| 1 | control, 4 KiB | 0 | 2,657,947 | 2534 |
| 1 | huge-page requested | **65,536** | 1,390,808 | **1326** |
| 2 | control, 4 KiB | 0 | 2,669,520 | 2545 |
| 2 | huge-page requested | **65,536** | 1,397,045 | **1332** |
| 3 | control, 4 KiB | 0 | 2,606,846 | 2486 |
| 3 | huge-page requested | **65,536** | 1,384,771 | **1320** |

The huge arm's `AnonHugePages` reads 65,536 kB, which is the whole 64 MiB buffer on huge pages, so the fallback the paper warned about did not happen. The control reads 0, as a 4 KiB mapping should. The chase ended on line 0 in every run, which is what one full Sattolo lap must do. The end-of-cycle check passed.

## Inference

**The falsifier did not fire, in the direction the paper set.** The huge-page reading sits at 1320 to 1332 permille, inside the 500 to 2000 band, with the huge-page status confirmed by the kernel. The control reproduces the earlier 2486 to 2649 range within its own spread. Moving from 4 KiB to 2 MiB pages cuts the counted misses by about 48 percent, from about 2.6 per access to about 1.33.

**So a large share of the excess is translation, not demand.** The reading is consistent with page-walk references being counted as misses on 4 KiB pages: 16,384 pages collapse to 32, and the counter's excess falls by roughly half. The measurement does not show that this is the whole excess. About a third of a miss per access remains above one, and it has no named source here.

**The sequential-sweep problem is not solved by this.** The calibration note read the generic event at 65 to 105 permille of line fills on a 64 MiB sequential sweep. This rerun did not repeat the sweep on huge pages, so that reading still stands as measured on 4 KiB pages. The two patterns still disagree by a factor of roughly 12 to 20 on the same guest, so no single correction converts the generic count into fills.

**What this changes.** The generic event may be a usable **demand-miss** proxy on huge-page buffers. It is not a usable fill counter, and the stencil claim stays closed, since that claim needs line fills and not demand misses.

## Falsifier, for the result as stated

- **The claim this rerun tests:** a huge-page chase reads inside the band, with `AnonHugePages` confirmed.
- **Result:** the condition was met. Three of three huge-arm runs read 1320 to 1332 permille, inside the band, with 65,536 kB of huge pages each time. The falsifier was written to confirm the page-walk explanation, and it did. It does not confirm the explanation as the whole cause.
- **What would reverse the reading:** a huge-page run that reads above 2000 permille, or a huge-page sequential sweep that still reads far below the 65 to 105 permille band while the chase reads inside it. The second would mean the sweep's low reading is a demand-miss property and not a page-walk artifact.

## Confidence

- **High** that the 4 KiB chase reading of 2.6 per access is partly page-walk traffic. Three of three huge-page runs moved by the same amount, and the kernel confirms the mapping.
- **Medium** that huge pages make the generic event a demand-miss proxy. The band is wide: 1.33 per access sits inside it, yet it is still a third above the one-per-access expectation, so the proxy would be rough.
- **Low** on what explains the remaining third of a miss per access, and on the sequential sweep. Neither is measured here.

## Horizon

The next read is a huge-page sequential sweep, with the same `AnonHugePages` printed, to see whether the fill-count gap survives the page change. It is a single probe with a predeclared band: the calibration note's 500 to 2000 permille, applied to the sweep's expected one million line fills. Beyond that, a raw vendor event named by Keaton would settle the fill question directly, and is not claimed here.

## What this note does not claim

No stencil run, no fill count, and no change to the calibration witness. The scratch probe is in `session-output/hugepage-chase/`, which is gitignored and untracked. Its core loop is the earlier probe's, with the mapping lines printed above.

The readings are free to repeat. Run `session-output/hugepage-chase/chase_control` and `chase_hugepage` on a later date to check them, and expect the figures to move a little with the guest's load.
