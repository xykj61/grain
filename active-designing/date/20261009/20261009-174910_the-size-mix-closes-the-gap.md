# The size mix closes the gap

**Status:** Landed -- one size-mix run on the same glibc buffer; the paper stands, and the scratch probe is kept in the appendix so the numbers can be checked
**Room:** vision -- the probe is scratch and no witness binds these numbers; the numbers are free, and re-running the appendix reproduces them
**Stamp:** `20261009.174910` (EDT)
**Kin:** [the simulated population explains most of the gap](20261009-174149_the-simulated-population-explains-most-of-the-gap.md) (the paper whose residual this run names and tests) - [the single jump on a real buffer](20261009-170234_the-single-jump-on-a-real-buffer.md) (the real-buffer probe whose size model this run reuses)
**Grade:** not yet graded -- the QA card has not been run on this page

The simulated paper read about 3,939 over budget per seed at W=10,000. The real-buffer probe read
about 1,700. The earlier page swapped the churn and closed about 82 percent of that gap, leaving a
residual of about a quarter. It named the size mix as the likeliest cause and set this run as the
next fruit. This page runs it.

## What was tested

**Observation.** Two size models differ in one respect that matters here. The simulated paper starts
every slot at 64 bytes and, after the jump at step 50,000, draws each new size log-uniform from 16 to
4,096 bytes. The real-buffer probe draws its starting sizes uniform from 16 to 256 bytes, and after the
jump uniform from 256 to 2,048 bytes. Both runs in this page use one victim per step, the real probe's
churn, and the same allocator model: a budget of K times an EWMA of live bytes, with K = 4, and a
compacting clear with a real `memmove` when the budget is crossed.

**The test, named before the run.** Hold the churn at one uniform victim per step, and swap only the
size model. Falsifier, stated before the run: if the size-matched count stays more than twice the real
probe's count at W=10,000, the size mix does not explain the residual. If it closes to within the
seed spread, the residual belonged to the size model, and the simulated paper's magnitudes are a
churn-and-size artifact of its population.

## Result: the size model closes the rest

Per-seed mean over-budget counts, uniform churn, the real probe's sizes, 8 seeds unless marked:

| Window | Real sizes, uniform churn (per seed) | Simulated sizes, uniform churn (per seed, 8 seeds) |
|---|---|---|
| 30 | 128 (range 122 to 135) | 150 (range 134 to 168) |
| 100 | 140 (range 135 to 147) | -- |
| 300 | 174 (range 166 to 180) | -- |
| 1,000 | 286 (range 277 to 296) | 350 (range 327 to 378) |
| 3,000 | 603 (range 567 to 625) | -- |
| 10,000 | 1,706 (range 1,570 to 1,844) | 2,105 (range 1,880 to 2,380) |

**Sanity check, the real probe re-run.** The same probe with the real probe's sizes and three seeds
read 129 at W=30, 288 at W=1,000, and 1,696 at W=10,000 (range 1,570 to 1,805). The published real-buffer
numbers were 129, 288 and 1,696. The probe reproduces its own earlier run.

**Sanity check, the simulated sizes under uniform churn.** The simulated sizes under this churn read
2,105 at W=10,000, matching the earlier churn-matched figure. The probe is consistent across pages.

## Decomposing the gap

**Observation, at W=10,000 per seed.** The simulated paper's population read 3,939. Its churn alone,
swapped to one uniform victim per step, read 2,105. Its churn and its size model both swapped, which
is the real probe's population, read 1,706. The real probe read 1,696 on three seeds.

| Part of the gap | Per seed | Share of the 2,243 total |
|---|---|---|
| Churn, one victim per step rather than the simulated per-slot rates | 1,834 | about 82 percent |
| Size model, the real probe's sizes rather than the simulated ones | 399 | about 18 percent |
| Residual, the size-matched run against the real probe | about 10 | under 1 percent |

**Inference.** In this model, the two factors the simulated population carried, its churn and its size
mix, account for the whole gap between the simulated paper and the real-buffer probe. The falsifier
did not fire. The size-matched count sits within the seed range of the real probe, not twice above it.

**Inference, on the window shape.** Both populations rise with the window by about the same factor.
The real sizes rise from 128 to 1,706, about thirteen-fold; the simulated sizes rise from 150 to 2,105,
about fourteen-fold. The shape came from the shift and the budget rule, and the magnitude came from the
population. That is the same split the earlier page drew, now closed.

## What this does and does not say

**What it says.** The simulated paper's large magnitudes were a property of its population, specifically
a churn of about two replacements per step and a size model that grows slots to 4,096 bytes. Neither
choice is a bug in the simulation. Both are choices a reader could make differently, and the magnitude
moves by roughly 2.3 times when they change.

**What it does not say.** It does not say the real probe's size model describes a real workload. The
sizes are uniform by construction, and the earlier page already named that. It does not reach Caravan's
`Region`, Tally's arena, or any allocator this tree ships. It says nothing about a realloc policy other
than the one the probe uses.

## Confidence

**High** that the size model and the churn together account for the gap between these two probes in
this model, since the swap reproduces the real probe's count within its seed range.

**Moderate** that the size split and the churn split are close to the shares printed, since each was one
swap at one factor, and the interaction between them was not measured. The shares were taken with churn
swapped first and size second, and that order was not varied, so the split is one reading of an
order-dependent decomposition.

**Low** on what a real workload's size mix would do, since no caller's live-set trace was read.

## Next

The residual is now inside the noise. The next question belongs to a different instrument: a size mix
drawn from a real caller's trace, not from a distribution chosen to make a point. That needs a trace
this tree does not hold yet, so it waits for one. If a trace reads near this model, the jump's magnitude
on a real workload is a number this tree can state. If it reads far from this model, the paper's
magnitudes were about its own population, and the honest reading stops there.

## Appendix -- the probe, as run

Run as `python3 -I sizemix_probe.py real 30,100,300,1000,3000,10000 8`,
`python3 -I sizemix_probe.py sim 30,1000,10000 8`, and `python3 -I sizemix_probe.py real 30,1000,10000 3`.
It ran from a scratch directory in the tree's gitignored `.lap/` room. The scratch file is deleted after this
page lands, and the code below carries its numbers.

```python
# Scratch probe: uniform churn (one victim per step) with the size model as argument.
# sizes: "sim"  = simulated paper's sizes (64 start, log-uniform 16..4096 after the jump)
#        "real" = real probe's sizes (randint 16..256 start, randint 256..2048 after the jump)
import ctypes, math, random, sys
LIBC = ctypes.CDLL(None)
LIBC.malloc.restype = ctypes.c_void_p
LIBC.malloc.argtypes = [ctypes.c_size_t]
LIBC.realloc.restype = ctypes.c_void_p
LIBC.realloc.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
LIBC.free.argtypes = [ctypes.c_void_p]
LIBC.free.restype = None
MEMMOVE = ctypes.memmove
SLOTS, STEPS, JUMP_AT, K = 200, 100000, 50000, 4
START_CAP = 1 << 20
MODEL = sys.argv[1]
WINDOWS = [int(w) for w in sys.argv[2].split(",")]
NSEEDS = int(sys.argv[3])

def start_size(rng):
    if MODEL == "sim":
        return 64
    return rng.randint(16, 256)

def draw(rng, step):
    if step < JUMP_AT:
        if MODEL == "sim":
            return 64
        return rng.randint(16, 256)
    if MODEL == "sim":
        return max(16, min(4096, int(round(math.exp(rng.uniform(math.log(16), math.log(4096)))))))
    return rng.randint(256, 2048)

def run(seed, window):
    rng = random.Random(seed)
    cap = START_CAP
    buf = LIBC.malloc(cap)
    sizes = [start_size(rng) for _ in range(SLOTS)] if MODEL == "real" else [64] * SLOTS
    offs = [0] * SLOTS
    used = 0
    for i in range(SLOTS):
        offs[i] = used
        used += sizes[i]
    live = sum(sizes)
    ewma = float(live)
    alpha = 1.0 / window
    over = 0
    for step in range(STEPS):
        if step == JUMP_AT:
            victims = list(range(SLOTS))
        else:
            victims = [rng.randrange(SLOTS)]
        for v in victims:
            live -= sizes[v]
            n = draw(rng, step)
            budget = K * ewma
            if used + n > budget:
                cursor = 0
                for j in range(SLOTS):
                    if j == v:
                        continue
                    MEMMOVE(buf + cursor, buf + offs[j], sizes[j])
                    offs[j] = cursor
                    cursor += sizes[j]
                used = cursor
                if used + n > budget:
                    over += 1
            if used + n > cap:
                cap = max(cap * 2, used + n)
                buf = LIBC.realloc(buf, cap)
            sizes[v] = n
            offs[v] = used
            used += n
            live += n
        ewma += alpha * (live - ewma)
    LIBC.free(buf)
    return over

for w in WINDOWS:
    seeds = range(20261009, 20261009 + NSEEDS)
    rows = [run(s, w) for s in seeds]
    print(f"model={MODEL} churn=uniform W={w} seeds={NSEEDS} over_mean={sum(rows)/len(rows):.1f} over_min={min(rows)} over_max={max(rows)}", flush=True)
```
