# The simulated population explains most of the gap

**Status:** Landed -- one population run on a real allocator; the paper stands, and the scratch probe is deleted after its appendix carries it
**Room:** vision -- the probe is scratch and no witness binds these numbers; the numbers are free, and re-running the appendix reproduces them
**Stamp:** `20261009.174149` (EDT)
**Kin:** [the jump reverses the window trade](20261009-165111_the-jump-reverses-the-window-trade.md) (the simulated paper whose population this run reads) - [the single jump on a real buffer](20261009-170234_the-single-jump-on-a-real-buffer.md) (the real-buffer probe this run compares to) - [the lifetime ratio holds the gap inside seed noise](20261009-172710_the-lifetime-ratio-holds-the-gap-inside-seed-noise.md) (the last two parameters ruled out)
**Grade:** not yet graded -- the QA card has not been run on this page

The lifetime ratio and the slow fraction were both ruled out as the gap between the simulated jump
and the real-buffer jump. The one thing left unread was the simulated paper's own population and
seed spread. This page reads that population, runs it on the real glibc buffer, and then tests
one factor the population carries that the real probe did not.

## What the paper says, in order

**Observation, from the simulated paper.** Its model has 200 slots. Twenty fast slots replace at
probability 0.1 per step and 180 slow slots at 0.0001 per step. Every slot starts at a 64-byte
block. The jump arm replaces every slot at step 50,000 with a log-uniform size from 16 to 4,096
bytes. Eight seeds, 20261009 to 20261016, and a window sweep from 30 to 10,000 steps. The
simulated paper's over-budget column reads as a total over those eight seeds, read from its own
jump-step figure of about 150 per seed.

**Observation, from the real-buffer probe.** `20261009.170234` ran a different population: a
uniform victim each step, so one replacement per step across 200 slots. Sizes ran 16 to 256 bytes
before the shift and 256 to 2,048 after it. Three seeds. Its jump arm read 1,696 over budget at
W=10,000, and runs in `20261009.171150` and `20261009.172710` read 1,700 to 1,800 at the same
window.

**Observation, this run.** A probe with the simulated population, run on the same kind of
glibc buffer, read the paper's table to within a few percent. Then one factor was swapped.

## Result one: the simulated population reproduces the simulated table

Per-seed mean over eight seeds at k = 4, against the paper's total divided by eight:

| Window | Paper, per seed | Reproduction, per seed | Gap |
|---|---|---|---|
| 30 | 160 | 144 | -10% |
| 100 | 186 | 173 | -7% |
| 300 | 266 | 254 | -5% |
| 1,000 | 541 | 527 | -3% |
| 3,000 | 1,363 | 1,298 | -5% |
| 10,000 | 4,061 | 3,939 | -3% |

The reproduction runs slightly low at every window, and the seed range at W=10,000 is 3,771 to
4,155. The trend with the window matches: a rise with no knee, and the same shape the paper printed.
The population, not a typo in the paper, carries the magnitude.

**Projection that rests on this.** The simulated gap is a property of the simulated population,
and the real probe's lower count is a property of its own population. Horizon: this model, this
allocator, and this one shift. Falsifier, named before the run: if a churn-matched version of the
simulated population reproduces the real probe's jump count at W=10,000 to within a factor of two,
the population explains the gap. If it stays more than twice above, the gap belongs to the allocator
model.

## Result two: churn explains most of it

The simulated population replaces about two slots a step, since 20 fast slots at 0.1 each contribute
two replacements per step and the 180 slow slots contribute 0.018 more. The real probe replaces one.
The ablation keeps the simulated sizes exactly and picks one uniform victim per step, the real
probe's churn.

| Window | Simulated population (per seed) | Churn-matched (per seed, 8 seeds) | Real-buffer probe (per seed, 3 seeds) |
|---|---|---|---|
| 30 | 144 | 150 (range 134 to 168) | 129 |
| 1,000 | 527 | 350 (range 327 to 378) | -- |
| 10,000 | 3,939 | 2,105 (range 1,880 to 2,380) | 1,696 |

**Observation.** Matching the churn moves the W=10,000 count from 3,939 to 2,105. Measured against
the real probe's 1,696, the simulated-to-real gap at W=10,000 is 2,243. The churn change closes
1,834 of it, about 82 percent, and leaves a residual of roughly 400 per seed, about 24 percent of the
real figure.

**Observation, on the shape.** The churn-matched run and the real probe rise with the window by about
the same factor: 150 to 2,105 is about fourteen-fold, and 129 to 1,696 is about thirteen-fold. The
shape is shared. The magnitude differs by about a quarter.

**Inference.** Churn is the largest single factor in the gap. The shape of the window trend belongs to
the shift and the budget rule, which the simulated paper and the real probe both carry. The remaining
quarter is most likely the size mix, since the real probe used 16 to 256 bytes before the shift
where the simulated paper used a fixed 64, and a uniform 256 to 2,048 after where the simulated paper
used a log-uniform 16 to 4,096. The probe that would separate those two causes is the next fruit.

**Falsifier outcome.** The falsifier did not fire. The churn-matched count is about 20 percent above
the real probe, not a factor of two. The residual sits just outside the simulated run's seed range,
which is a reason to read the 24 percent as real rather than as noise, and not a reason to call it
large.

**Confidence.** High that the simulated population reproduces the paper's own table on this buffer,
since the reproduction is within 10 percent at every window. Moderate that churn is the largest
single factor, since this is one ablation with one factor swapped. Low on the residual's exact size,
since the real probe ran three seeds, and its seed range is not printed on the page that names its
number.

## What this does not reach

**The real allocator, with a real workload.** A bump model with full re-copy clears. Caravan's
`Region` and Tally's arena are neither of them, and this page says nothing about either.

**The size mix.** The residual is named, not measured. A probe with the real probe's sizes under the
simulated churn would test it, and it is the next thing to run.

**Whether the simulated population is the right one for this tree.** It is the paper's population,
which was chosen to make a point about a jump. The real probe's population was chosen for the same
reason at a smaller scale. Neither is a measurement of this tree's own live-set churn.

## Next

Run the real probe's size mix under the simulated churn. If the residual of about a quarter closes,
the size mix explains the rest, and the simulated paper's magnitudes are a churn artifact. If it does
not close, the residual belongs to something the bump model does not carry, such as the realloc
policy or the seed count, and the next probe reads that.

## Appendix -- the probe, as run

The probe was run as `python3 -I sim_population_probe.py jump` and `... gradual` for the population
sweep, and `python3 -I sim_population_probe.py jump uniform` for the churn ablation. It ran from a
scratch directory in the tree's gitignored `.lap/` room and is reproduced here so the numbers above
can be checked against it. The scratch file is deleted after this page lands.

```python
# Scratch probe: the simulated paper's own population on a real glibc buffer.
# Population (20261003 jump paper): 200 slots; per-slot replacement probability
# 0.1 for 20 fast slots, 1e-4 for 180 slow slots, per step; 100k steps; jump at
# 50k replaces every slot at once; sizes log-uniform 16..4096 in both arms;
# budget = K * EWMA(live, alpha = 1/W); clear = compact live with real memmove.
import ctypes
import math
import random
import sys

LIBC = ctypes.CDLL(None)
LIBC.malloc.restype = ctypes.c_void_p
LIBC.malloc.argtypes = [ctypes.c_size_t]
LIBC.realloc.restype = ctypes.c_void_p
LIBC.realloc.argtypes = [ctypes.c_void_p, ctypes.c_size_t]
LIBC.free.argtypes = [ctypes.c_void_p]
LIBC.free.restype = None
MEMMOVE = ctypes.memmove

SLOTS = 200
FAST = 20
P_FAST = 0.1
P_SLOW = 1e-4
STEPS = 100000
JUMP_AT = 50000
K = 4
LO, HI = 16, 4096
START_CAP = 1 << 20
LOG_LO, LOG_HI = math.log(LO), math.log(HI)
UNIFORM = len(sys.argv) > 2 and sys.argv[2] == "uniform"  # ablation: one uniform victim per step, the real probe's churn


START_BLOCK = 64  # the paper: every slot starts at a 64-byte block, and holds that size until the shift


def draw(rng, step):
    # before the shift every replacement is 64 bytes; after it, log-uniform 16..4096
    if step < JUMP_AT:
        return START_BLOCK
    return max(LO, min(HI, int(round(math.exp(rng.uniform(LOG_LO, LOG_HI))))))


def run(seed, window, arm):
    rng = random.Random(seed)
    cap = START_CAP
    buf = LIBC.malloc(cap)
    assert buf
    sizes = [START_BLOCK] * SLOTS
    offs = [0] * SLOTS
    used = 0
    for i in range(SLOTS):
        offs[i] = used
        used += sizes[i]
    live = sum(sizes)
    ewma = float(live)
    alpha = 1.0 / window
    clears = 0
    over = 0
    over_after = 0
    for step in range(STEPS):
        if arm == "jump" and step == JUMP_AT:
            victims = list(range(SLOTS))
        else:
            if UNIFORM:
                victims = [rng.randrange(SLOTS)]
            else:
                victims = [v for v in range(SLOTS)
                           if rng.random() < (P_FAST if v < FAST else P_SLOW)]
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
                clears += 1
                if used + n > budget:
                    over += 1
                    if step >= JUMP_AT:
                        over_after += 1
            if used + n > cap:
                cap = max(cap * 2, used + n)
                buf = LIBC.realloc(buf, cap)
                assert buf
            sizes[v] = n
            offs[v] = used
            used += n
            live += n
        ewma += alpha * (live - ewma)
    LIBC.free(buf)
    return {"clears": clears, "over": over, "over_after": over_after}


if __name__ == "__main__":
    arm = sys.argv[1]
    seeds = range(20261009, 20261017)
    for window in ([30, 1000, 10000] if UNIFORM else [30, 100, 300, 1000, 3000, 10000]):
        rows = [run(s, window, arm) for s in seeds]
        ov = [r["over"] for r in rows]
        cl = [r["clears"] for r in rows]
        print(f"churn={'uniform' if UNIFORM else 'per-slot'} arm={arm} W={window} over_mean={sum(ov)/len(ov):.1f} over_min={min(ov)} over_max={max(ov)} "
              f"over_after_mean={sum(r['over_after'] for r in rows)/len(rows):.1f} clears_mean={sum(cl)/len(cl):.1f}", flush=True)
```

*Two probe faults this run found, kept as record:* the first run started every slot at a
log-uniform size from 16 to 4,096, so the jump moved no live bytes and read zero over budget at
every window. The paper starts every slot at 64 bytes, and the jump is what introduces the larger
sizes. The first corrected run also read correctly for the jump arm and its control. Its numbers
are the ones above. The first runs are set aside and none of them appears in the tables.
