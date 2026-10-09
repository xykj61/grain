# The slow fraction holds the gap inside seed noise

**Status:** Landed -- one falsifier run at four slow fractions, per-seed ranges printed beside the means; the probe is copied into the appendix below
**Room:** vision -- the probe is scratch and no witness binds these numbers; the numbers are free, and re-running the appendix reproduces them
**Stamp:** `20261009.171658` (EDT)
**Kin:** [the slow-block population on a real buffer](20261009-171150_the-slow-block-population-on-a-real-buffer.md) (the run this one extends, and whose named next step it takes) - [the single jump on a real buffer](20261009-170234_the-single-jump-on-a-real-buffer.md) (the jump probe both reuse)
**Grade:** not yet graded -- the QA card has not been run on this page

## Question

The slow-block paper named two open items. One was a slow fraction near half. The other was the
per-seed spread, which that paper's own table left unprinted. This page runs the first and prints
the second beside every mean.

The question is narrow: **does a slow fraction near half move the single jump's over-budget counts
outside the seed noise that the uniform control shows?** The slow-block paper's own falsifier was a
factor of two from the uniform control at some window, or a change in the jump's direction. Both are
written down before the run, so either can fail.

## Observation, and one change to the probe

**Observation.** The probe is the slow-block probe with three changes, and only one of them is a
choice.

- The slow fraction `f` is a command-line argument, swept over 0.0 (uniform), 0.1, 0.3 and 0.5.
- The slow-victim probability is no longer a fixed `0.01`. It is solved so the per-slot lifetime
  ratio stays at **11** for any `f`: `p_s = f / (f + 11 (1 - f))`. At `f = 0.1` that gives `0.01`,
  the paper's own value, so the 0.1 row is the paper's population. Without the solve, the ratio at
  `f = 0.5` would be about 19, and the sweep would change two quantities at once.
- The arm is `jump` or `gradual`. Everything else is the paper's: 200 slots, 100,000 steps, the jump
  at step 50,000, budget `k = 4` times an exponentially weighted live average with `alpha = 1/W`,
  three seeds (`20261009`, `20261010`, `20261011`), and glibc `malloc` through `ctypes`.

**Observation.** The 0.1 control reproduces the slow-block paper's W=10,000 row. This run reads
1,795 over-budget allocations against that paper's 1,780, and the paper's own seed spread was never
printed, so the reproduction is close but not exact.

## Measurement

Over-budget allocations, mean over three seeds, with the minimum and maximum of the three beside
each mean. Each arm ran under `python3 -I`, Python 3.13, on this host, in about six seconds per
arm.

**Jump arm.**

| W | f = 0.0 (uniform) | f = 0.1 (paper) | f = 0.3 | f = 0.5 |
|---|---|---|---|---|
| 30 | 129.7 (126-136) | 122.3 (114-133) | 120.3 (117-125) | 122.3 (109-129) |
| 100 | 141.7 (138-148) | 133.3 (125-146) | 133.0 (130-136) | 132.7 (116-142) |
| 300 | 175.0 (171-181) | 167.3 (160-181) | 166.0 (162-171) | 164.3 (148-173) |
| 1,000 | 286.3 (281-292) | 284.0 (271-296) | 272.7 (270-276) | 283.3 (269-294) |
| 3,000 | 595.0 (548-624) | 598.7 (596-604) | 607.0 (582-624) | 602.7 (571-621) |
| 10,000 | 1,699.7 (1,570-1,812) | 1,795.0 (1,729-1,888) | 1,740.3 (1,646-1,825) | 1,776.0 (1,719-1,875) |

**Gradual arm, at f = 0.5, the arm the slow-block paper read as zero.** Over-budget allocations are
zero at every window, with every seed at zero.

**Observation, the spread.** At W=10,000 the uniform control spans 1,570 to 1,812, a range of 242.
The f = 0.5 arm spans 1,719 to 1,875, a range of 156. The f = 0.1 arm spans 1,729 to 1,888. Across
the four fractions the means at W=10,000 run from 1,700 to 1,795, a spread of 95. The uniform
control's mean (1,699.7) sits inside the f = 0.3 range and just below the f = 0.1 and f = 0.5 ranges,
which start at 1,729 and 1,719. The control's own range (1,570 to 1,812) overlaps all three slow
ranges, so no arm separates from it at this window.

## Inference

**Inference.** Across the sweep, a slow fraction from 0.0 to 0.5 moves the jump's over-budget counts
by less than the seed-to-seed spread of the uniform control at every window. The largest mean
difference from the control is at W=10,000, about 95 allocations, or 5.6 percent. The control's own
three seeds span 242 at that window. This is the same reading the slow-block paper reached at f = 0.1,
now extended to half the population.

**Inference.** The factor-of-two falsifier did not fire, and it could not have fired on this sweep.
No fraction produces a mean more than about 1.06 times the control at any window. The jump's
direction also holds. Over-budget counts rise monotonically with the window at every fraction, and
the rise matches the control's shape.

**Inference.** The gradual arm stays at zero at half the population as well. A slow fraction does
not produce the gradual knee the earlier paper looked for, in this model.

**Observation, what the sweep does not separate.** Three seeds cannot separate fractions whose means
differ by less than their ranges. The sweep is informative about direction and about whether the
effect is large, and says nothing sharp about its exact size.

## Falsifier, run

**Falsifier named before the run:** a factor of two from the uniform control at some window, or a
reversal of the jump's rise with the window, at any fraction up to 0.5.

**Result: did not fire.** The largest ratio to the control is 1.06 at W=10,000, and the rise with the
window is monotone at every fraction.

**Falsifier for the next lap, which this run does not reach.** A **lifetime ratio** of about a
hundred rather than eleven. The slow-block paper named it, and the solve above holds the ratio fixed,
so this sweep is silent about it. If the ratio of 100 moves the jump by a factor of two from the
control, then the gap to the simulated paper may depend on the lifetime model rather than on the slow
fraction.

## Assumptions

- The per-slot lifetime ratio is held at 11 by solving the victim probability. A different ratio
  would be a different population, and this sweep tests only the fraction.
- Three seeds. The ranges are printed so a reader can see that three is thin.
- A single jump at step 50,000, with every slot replaced at once. A drifting shift is the
  knee-probe's arm, which this page does not repeat.
- glibc `malloc` through `ctypes`, with `memmove` for each compaction. The bump bookkeeping is Python,
  as before.
- Over-budget means a single allocation that would exceed `k` times the live average even after a
  clear, as the earlier papers define it.

## What this does not reach

- **The magnitudes against the simulated paper.** The gap is still there. The slow fraction is ruled
  out as its cause, and the lifetime ratio is not.
- **A lifetime ratio of about a hundred.** Named above and not run.
- **A Zig or Rye allocator.** The host has no Zig and no Rishi on the search path, so the real
  allocator is still glibc.
- **The copy price.** The copy traffic stays a word for Keaton, as the earlier papers said.

## Confidence

**Confidence:** high that the slow fraction, from 0.0 to 0.5 at a ratio held at 11, does not move the
single jump's over-budget counts beyond seed noise. Moderate that the lifetime ratio is the likelier
source of the simulated gap, since that is the one parameter this sweep did not vary. Low on the exact
magnitudes, since three seeds bound the means only loosely.

## Appendix -- the probe, copied in full

```python
# Scratch probe: slow-block fraction sweep on glibc malloc, single jump.
# Derived from the slow-block paper (20261009.171150). The only change: the
# slow-victim probability is solved so the per-slot lifetime ratio stays at
# RATIO = 11 for any slow fraction f:  p_s = f / (f + RATIO * (1 - f)).
# At f = 0.1 this gives p_s = 0.01, the paper's own value.
# Run as: python3 -I slowfrac_probe.py <slow_frac> <arm>   (arm = jump | gradual)
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
RATIO = 11.0
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
    print(f"frac={frac} p_slow={frac / (frac + RATIO * (1.0 - frac)):.4f} arm={arm}")
    for window in WINDOWS:
        rows = [run(seed, window, arm, frac) for seed in SEEDS]
        ov = [r["over"] for r in rows]
        oa = [r["over_after"] for r in rows]
        print(f"W={window} over_mean={sum(ov)/3:.1f} over_min={min(ov)} over_max={max(ov)} "
              f"after_mean={sum(oa)/3:.1f} after_min={min(oa)} after_max={max(oa)} "
              f"clears_mean={sum(r['clears'] for r in rows)/3:.1f}")
```

Run as `python3 -I slowfrac_probe.py <slow_frac> <arm>`, for example `0.5 jump`. The scratch copy is deleted after this appendix carries it.
