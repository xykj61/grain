# The generic miss counter reads high on a random chase, so it is neither a demand count nor a fill count

**Seated:** `20261009.231436` - **Status:** Vision -- a calibration result, not a stencil claim
**Room:** checkable -- it names one probe and three readings; no tracked module or witness changes on it
**Lane:** Diffuser (moonshots and research) -- the second half of the hardware falsifier the stencil paper set
**Kin:** [the generic counter reads a fraction](20261009-222800_the-generic-miss-counter-reads-a-fraction.md) - [the row-band stencil](20261009-214759_the-stencil-sweep-prefers-the-row-band.md) - [the calibration witness](../../../tools/c/cache_miss_calibrate_witness.rish)

## What this note is for

The calibration note measured the generic `cache-misses` event on a 64 MB **sequential** sweep and found it reads about 5 to 10 percent of the one million line fills that sweep must cause. Two explanations stayed open. The event may count **demand misses** only, and a hardware prefetcher fills lines the program never misses on. Or the event may not track line fills at all on this guest. The sequential sweep cannot separate them, because a prefetcher hides the demand misses in exactly the pattern the sweep uses.

A **pointer chase** removes the prefetcher from the question. Each load's address is the value the previous load returned, so no stream can be predicted and every access is a dependent demand miss. If the generic counter is a demand-miss counter, a chase over a buffer larger than the cache should read close to one miss per access. This note runs that chase and names the falsifier first.

## Falsifier, named before the run

The band is the one the calibration note set, applied rather than invented here: a reading of **500 to 2000 permille** of the expected count, where the expected count is one miss per access, 1,048,576 accesses. Inside the band, the generic event is usable as a demand-miss proxy on this guest. Below the band, it reads a fraction of the fills and is not a fill counter, as the sequential run already showed. **Above** the band, it counts something beyond the program's own demand misses, and the chase cannot be read as a miss count at all.

## Observation (measured, 2026-10-09, this guest)

Host: 8-core AMD EPYC-Rome guest, 2 MiB L2 per core, 16 MiB L3 shared, 64 MiB buffer. Counter: `perf_event_open` self-count, `HARDWARE` / `CACHE_MISSES`, `exclude_kernel` and `exclude_hv` set, `perf_event_paranoid = 2`. The chase is a single cycle over all 1,048,576 lines of 64 bytes, built by Sattolo's algorithm, with one untimed warm-up lap, and the counter is enabled around the timed lap only.

| Reading | Accesses | Misses | Permille of expected | Source |
|---|---|---|---|---|
| Pointer chase, run 1 | 1,048,576 | 2,778,258 | 2649 | scratch probe, this lap |
| Pointer chase, run 2 | 1,048,576 | 2,758,175 | 2630 | scratch probe, this lap |
| Pointer chase, run 3 | 1,048,576 | 2,722,514 | 2596 | scratch probe, this lap |
| Sequential sweep, control | 1,048,576 | 110,384 and 68,313 | 105 and 65 | `cache_miss_calibrate`, this lap |

The chase ends on line 0 after one full lap, which is what a single Sattolo cycle must do. That is the check that the chase visits every line once, and it passed on each run. The sequential control reproduces the calibration note's range, so the counter and the build behave as they did earlier.

## Result

**The falsifier fired, upward.** Every chase reading sits above the 2000 band edge, at 2596 to 2649 permille. The generic event counts about 2.6 misses for every dependent random access. It does not count demand misses one for one, and it does not count fills one for one either: the same counter reads 0.065 to 0.105 of the fills on a sequential sweep and 2.6 of the accesses on a random chase. The ratio moves by a factor of about 25 to 40 between two patterns on the same guest. No single calibration factor fits both.

This is the finding. It is not a bug in the probe, which the control and the end-of-cycle check both exercise, and the three chase runs agree to within about 2 percent of each other, so the reading is stable even though its meaning is not.

## What the result does not say

Three explanations fit a count of 2.6 per access, and this probe does not separate them.

1. **Page-walk references counted as misses.** A 64 MiB buffer over 4 KiB pages spans 16,384 pages, far more than a typical data TLB covers. Each random access may trigger a walk whose page-table reads are themselves memory references, and some of those may be counted. This is the explanation the next run is built to test.
2. **Speculative or wrong-path loads.** An out-of-order core can issue loads past a branch the chase has not resolved, and those can miss in the cache even when the program never retires them. The chase's loop is short and predictable, which makes this less likely, but the paper does not measure it.
3. **The event counts something other than a demand miss on this vendor.** A generic event is a mapping the kernel chooses, and on this guest it may map to a different cache-level event than the name suggests. That is the reason the stencil paper asked for a raw vendor event, and this result strengthens the case for one.

A reading that would separate (1) from the others: rerun the chase on a buffer backed by 2 MiB huge pages, via `madvise(MADV_HUGEPAGE)` where the kernel allows it. The page count drops from 16,384 to 32, and explanation (1) predicts the reading falls toward the band. If it stays near 2600, (1) is out, and the question moves to (2) or (3). That run is named here and not made in this lap, because transparent huge pages on this guest were not checked before the probe was written, and a huge-page run that silently falls back to 4 KiB pages would read the same as no change.

## What this kills, and what it leaves

**Killed:** the generic `cache-misses` event as a line-fill proxy in either direction, on this guest. A sequential sweep reads low and a random chase reads high, so no single correction converts the generic count into fills. The stencil claim stays refused, and no stencil run is claimed here. The calibration witness keeps its present shape, since its falsifier was already fired by the sequential run.

**Left:** whether a raw vendor event reads demand misses cleanly. That event's name is a hardware fact Keaton would supply, which the stencil paper and the calibration note both reserved for his word. The huge-page run is the next thing this lane can do without new authority, and it stays open until a lap runs it with the huge-page status printed beside the reading.

## The probe, in the form that ran

The probe is a scratch program in `session-output/pointer-chase/`, which is gitignored and was not committed, since it is a new measuring instrument and this lane's rule asks for a claim before a new instrument lands in the tree. Its core loop, printed here so the reading can be repeated, is:

```
cur = 0
for k in 0 .. lines:
    cur = load_u64(buf + cur * 64)     // dependent: the next address is this load's value
```

with the buffer filled once from a Sattolo permutation over `lines = 1,048,576` (seeded xorshift64, untimed), and the counter enabled around the timed loop only. The reading is `misses * 1000 / lines`. A lap that wants to repeat this should either re-create the scratch probe from this description or ask for it to be tracked under the claim rule.

## Grade

Graded at Field by the report card, with truth counted and the judged half unread, so the grade is a reading of register and reach. Run `sh tools/fixtures/q/qa_report_card.sh <this page> --setting field --service 80`; the number it prints is the grade, not the number written here.

## Horizon, assumptions, falsifier, confidence

- **Horizon:** this guest, this kernel, this build, one day. A different host or a vendor event may read differently, and the result says nothing about a fill counter elsewhere.
- **Assumptions:** the chase is truly dependent and single-cycle (the end-of-cycle check supports it); the counter self-scope is what the kernel says it is (the sequential control supports it).
- **Falsifier, for the result as stated:** a huge-page chase that falls inside the 500 to 2000 band, with the huge-page status confirmed. That would move explanation (1) from a guess to the cause, and would leave the generic event usable as a demand-miss proxy after all.
- **Confidence:** high that the generic event does not track line fills on this guest, since two patterns disagree by about 25 times. Low on why the chase reads 2.6, which is the open half.
