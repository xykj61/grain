# The lifetime ratio holds the gap inside seed noise

**Status:** Landed -- one falsifier run at a lifetime ratio of 100 beside the ratio of 11, the slow fraction at 0.1 and 0.5, per-seed ranges printed beside the means; the probe is copied into the appendix below
**Room:** vision -- the probe is scratch and no witness binds these numbers; the numbers are free, and re-running the appendix reproduces them
**Kin:** [the slow fraction holds the gap inside seed noise](20261009-171658_the-slow-fraction-holds-the-gap-inside-seed-noise.md) (the sweep this page extends, and whose named next step it takes) - [the slow-block population on a real buffer](20261009-171150_the-slow-block-population-on-a-real-buffer.md) - [the single jump on a real buffer](20261009-170234_the-single-jump-on-a-real-buffer.md) - [the knee probe](20261009-165111_the-jump-reverses-the-window-trade.md)

## What this page is for

The slow-block paper's simulated gap is the question left open. Its magnitudes sit well above a real glibc buffer's, and two earlier runs closed two candidate causes: the slow fraction, and the gradual arm's knee. The slow-fraction run held the per-slot lifetime ratio at **11**, so it could not say whether a different ratio moves the jump. This page runs the one parameter that run held fixed: a lifetime ratio of about **100**.

The question in one line: does a slot that lives a hundred times longer than the fast slots move the single jump's over-budget count beyond seed noise?

## Observation, and one change to the probe

**Observation.** The probe is the slow-fraction probe with one change. The lifetime ratio is a command-line argument, third in order, defaulting to 11 so the run with no third argument is the earlier sweep unchanged. The slow-victim probability is solved from that ratio, `p_s = f / (f + RATIO (1 - f))`, so the population is the same kind at every setting and only the ratio moves.

- The uniform control (`f = 0.0`) has no slow slots, so its ratio cannot matter. It is included as the reference.
- The ratio-11 rows at `f = 0.1` and `f = 0.5` reproduce the slow-fraction paper's own rows. The reproduction is exact: 122.3, 284.0, 1,795.0 at `f = 0.1`, the same numbers that paper printed.
- Three seeds (`20261009`, `20261010`, `20261011`), 200 slots, 100,000 steps, the jump at step 50,000, budget `k = 4` times an exponentially weighted live average, glibc `malloc` through `ctypes`. All as before.

## Measurement

Over-budget allocations, mean over three seeds, with the minimum and maximum beside each mean. Each run ran under `python3 -I`, Python 3.13, on this host, in about six seconds per arm.

**Jump arm, lifetime ratio 100 (the new run).**

| W | f = 0.0 (uniform) | f = 0.1, ratio 100 | f = 0.5, ratio 100 |
|---|---|---|---|
| 30 | 129.7 (126-136) | 124.0 (119-128) | 124.3 (115-134) |
| 1,000 | 286.3 (281-292) | 285.3 (277-296) | 286.3 (278-303) |
| 10,000 | 1,699.7 (1,570-1,812) | 1,791.3 (1,730-1,897) | 1,790.3 (1,728-1,911) |

**Jump arm, lifetime ratio 11 (the slow-fraction paper's rows, reproduced).**

| W | f = 0.1, ratio 11 | f = 0.5, ratio 11 |
|---|---|---|
| 30 | 122.3 (114-133) | 122.3 (109-129) |
| 1,000 | 284.0 (271-296) | 283.3 (269-294) |
| 10,000 | 1,795.0 (1,729-1,888) | 1,776.0 (1,719-1,875) |

**Observation, the window of the largest shift.** At W=10,000 the uniform control's mean is 1,699.7 and every ratio-100 arm sits between 1,790 and 1,792. That is a shift of about 5.4 percent. The ratio-11 arms moved the same way, 1,776 to 1,795, about 5.6 percent. The ratio changed the means by a fraction of a percent, and the seed ranges overlap for every pair compared.

**Observation, the trend.** Over-budget allocations rise monotonically with the window at every ratio and fraction tested, from about 124 at W=30 to about 1,790 at W=10,000. The jump's reversal has not appeared at any setting, so the rise is a property of the single jump and not of the lifetime model.

**Result: did not fire.** The falsifier named in advance was a factor of two from the uniform control, or a reversed trend. The largest ratio to the control is 1.05 at W=10,000, and the rise with the window is monotone everywhere. The lifetime ratio does not explain the simulated gap at this workload.

## Assumptions

- Three seeds. The ranges are printed so a reader can see the spread. Three is thin, and the seed ranges at W=10,000 run 156 to 242 allocations wide across these arms, which is larger than the 90 or so allocations of shift being read.
- The lifetime ratio is held by solving the victim probability, so the slow fraction and the ratio are read separately. Two parameters moved together would have confused the reading.
- A single jump at step 50,000, every slot replaced at once. A drifting shift is the knee probe's arm, and this page does not repeat it.
- The bump bookkeeping is Python over glibc `malloc` through `ctypes`, with `memmove` for every compaction. A Zig or Rye allocator is not measured here.
- Over-budget means a single allocation that would exceed `k` times the live average even after a clear, as the earlier papers define it.

## What this does not reach

- **The magnitudes against the simulated paper.** The lifetime ratio is now ruled out as the cause, as the slow fraction was. The gap to the simulated paper stays unexplained by either parameter. What remains unmeasured is the simulated paper's own seed spread and its exact population; without those the gap may still be a difference in model rather than in workload.
- **A lifetime ratio above 100, or below 11.** Only two points on the ratio axis were run, so the reading is a bracket of two, not a curve.
- **A real Zig or Rye allocator.** The host has no Zig and no Rishi on the search path, so the real allocator is glibc.
- **The copy price.** The copy traffic stays a word for Keaton, as the earlier papers said.

## Confidence

**Confidence:** high that the lifetime ratio, at 11 and at 100 and with the slow fraction at 0.1 and 0.5, does not move the single jump's over-budget counts beyond seed noise on this workload. Moderate that the gap to the simulated paper comes from something outside these three parameters, since the two closed causes now leave the model and the workload as the remaining candidates. Low on the exact magnitudes, since three seeds bound the means only loosely.

**Horizon:** this reading holds for the single-jump workload on glibc `malloc` on this host. It says nothing yet about a drifting shift on a real allocator, which the knee probe covers in simulation only.

**Falsifier for the next lap, which this run does not reach.** Read the simulated paper's population and seed spread, then re-run this probe at that population. If the simulated paper's own workload differs in the live-set size, not in the lifetime or the fraction, the gap belongs to the live-set model rather than to the lifetime model.

## Appendix -- the probe, copied in full

```python
# Scratch probe: lifetime-ratio sweep on glibc malloc, single jump.
# Derived from the slow-fraction probe (20261009.171658). The only change: the
# per-slot lifetime ratio is a command-line argument, third in order, defaulting
# to 11. The slow-victim probability is solved from it:
#   p_s = f / (f + RATIO * (1 - f))
# Run as: python3 -I lifetime_ratio_probe.py <slow_frac> <arm> [<ratio>]
import ctypes, random, sys
LIBC = ctypes.CDLL(None)
LIBC.malloc.restype = ctypes.c_void_p
LIBC.malloc.argtypes = [ctypes.c_size_t]
LIBC.realloc.restype = ctypes.c_void_p
LIBC.realloc.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
LIBC.free.argtypes = [ctypes.c_void_p]
LIBC.free.restype = None
MEMMOVE = ctypes.memmove
SLOTS = 200
RATIO = float(sys.argv[3]) if len(sys.argv) > 3 else 11.0
STEPS = 100000
JUMP_AT = 50000
K = 4
MIN_SIZE, MAX_SIZE = 16, 256
START_CAP = 1 << 20
JUMP_HI = 8 * MAX_SIZE
SEEDS = (20261009, 20261010, 20261011)
WINDOWS = [30, 100, 300, 1000, 3000, 10000]

def size_for(rng, step, arm):
    if arm == "gradual":
        hi = MAX_SIZE + (MAX_SIZE * step) // STEPS
        return rng.randint(MIN_SIZE, hi)
    if step < JUMP_AT:
        return rng.randint(MIN_SIZE, MAX_SIZE)
    return rng.randint(MAX_SIZE, JUMP_HI)

def run(seed, window, arm, frac):
    n_slow = int(SLOTS * frac)
    p_slow = frac / (frac + RATIO * (1.0 - frac))
    rng = random.Random(seed)
    cap = START_CAP
    buf = LIBC.malloc(cap)
    assert buf
    sizes = [rng.randint(MIN_SIZE, MAX_SIZE) for _ in range(SLOTS)]
    offs = [0] * SLOTS
    used = 0
    for i in range(SLOTS):
        offs[i] = used
        used += sizes[i]
    live = sum(sizes)
    ewma = float(live)
    alpha = 1.0 / window
    clears = copied = over = over_after = grows = 0
    peak_cap = cap
    for step in range(STEPS):
        if n_slow and rng.random() < p_slow:
            v = rng.randrange(n_slow)
        else:
            v = n_slow + rng.randrange(SLOTS - n_slow)
        victims = range(SLOTS) if (arm == "jump" and step == JUMP_AT) else [v]
        for v in victims:
            live -= sizes[v]
            n = size_for(rng, step, arm)
            budget = K * ewma
            if used + n > budget:
                cursor = 0
                for j in range(SLOTS):
                    if j == v:
                        continue
                    MEMMOVE(buf + cursor, buf + offs[j], sizes[j])
                    copied += sizes[j]
                    offs[j] = cursor
                    cursor += sizes[j]
                used = cursor
                clears += 1
                if used + n > budget:
                    over += 1
                    if step >= JUMP_AT:
                        over_after += 1
            if used + n > cap:
                cap = max(cap * 2, used + n)
                buf = LIBC.realloc(buf, cap)
                assert buf
                grows += 1
                peak_cap = max(peak_cap, cap)
            sizes[v] = n
            offs[v] = used
            used += n
            live += n
        ewma += alpha * (live - ewma)
    LIBC.free(buf)
    return {"over": over, "over_after": over_after, "clears": clears, "copied": copied}

if __name__ == "__main__":
    frac = float(sys.argv[1])
    arm = sys.argv[2]
    print(f"frac={frac} ratio={RATIO} p_slow={frac / (frac + RATIO * (1.0 - frac)):.4f} arm={arm}")
    for window in WINDOWS:
        rows = [run(seed, window, arm, frac) for seed in SEEDS]
        ov = [r["over"] for r in rows]
        oa = [r["over_after"] for r in rows]
        print(f"W={window} over_mean={sum(ov)/3:.1f} over_min={min(ov)} over_max={max(ov)} "
              f"after_mean={sum(oa)/3:.1f} after_min={min(oa)} after_max={max(oa)} "
              f"clears_mean={sum(r['clears'] for r in rows)/3:.1f}")
```

Run as `python3 -I lifetime_ratio_probe.py 0.1 jump 100`, or with `0.5 jump 100` for the second row. The scratch copy is deleted after this appendix carries it.

Every number above is free: nothing holds it still, so re-run the appendix to read it again rather than trusting the page. May the next probe find what this one could not, and may its falsifier be written before its numbers arrive.
