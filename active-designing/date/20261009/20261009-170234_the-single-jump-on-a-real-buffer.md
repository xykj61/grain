# The single jump on a real buffer

**Status:** Landed -- one falsifier run on a real allocator; the paper stands, the scratch probe is deleted after its appendix carries it
**Room:** vision -- the probe is scratch and no witness binds these numbers; the numbers are free, and re-running the appendix reproduces them
**Stamp:** `20261009.170234` (EDT)
**Kin:** [the window knee](20261009-163113_the-window-knee-trades-overshoot-for-clears.md) (the falsifier this run takes) - [the jump reverses the window trade](20261009-165111_the-jump-reverses-the-window-trade.md) (the simulated jump this run replaces) - [the live budget](20261009-162216_the-live-budget-bounds-the-footprint-at-k-times-live.md)
**Grade:** not yet graded -- the QA card has not been run on this page

The window knee paper named one falsifier and left it unrun: a real allocator on a single-jump
workload, with the window swept. This paper runs it. The honest answer is partial. The direction of
the jump result survives on a real buffer, the gradual knee does not appear in this model, and the
magnitudes differ from the simulated paper for reasons this page names.

## What the paper says, in order

**Observation.** On `20261009`, one scratch probe ran on the host, with `python3 -I`, Python 3.13.15,
and glibc. The host has no Zig, no C compiler, and no Rishi on the search path, so the allocator is
glibc `malloc` reached through `ctypes`, not a Rye or Zig allocator. The bump bookkeeping is Python
arithmetic. The buffer, the reallocation, and every compaction copy are real: `ctypes.memmove` moves
the live bytes, and the buffer is one `malloc`'d block of 1,048,576 bytes that never grew.

**Observation.** Three seeds (`20261009`, `20261010`, `20261011`), 200 live slots, 100,000
replacements per run, and budget `k = 4` times an exponentially weighted average of live bytes with
`alpha = 1/W`, updated once per step. The window sweeps `W` in 30, 100, 300, 1,000, 3,000 and 10,000
steps. Two arms share the code:

- **gradual** -- the size ceiling drifts from 256 to 512 bytes across the run.
- **jump** -- the size range holds at 16 to 256 bytes until step 50,000, then every slot is replaced at
  once with sizes from 256 to 2,048 bytes, so live bytes rise about eightfold in one step.

**Definition, the paper's own.** An allocation that still exceeds its budget after a clear counts as
over budget. A clear re-copies every live object to the front of the buffer with real `memmove`.

**Observation, the first run.** Before the jump arm was made eightfold, the probe read zero over-budget
allocations on both arms, under the same definition. A doubling of the size ceiling could not push
live bytes past the budget at `k = 4`, so the probe could not see the falsifier. Recorded here as a
calibration fault in the probe, not a finding about the allocator. The eightfold shift is the first
configuration in which the bound can fail at all.

**Observation, the reading that matters** (`20261009.170234`, the eightfold configuration, three seed mean):

| Arm | W | Over budget, all | Over budget, after step 50,000 | Clears | Bytes copied |
|---|---|---|---|---|---|
| gradual | 30 to 10,000 | 0 at every window | 0 | 165 to 179 | 6.5M to 7.1M |
| jump | 30 | 129 | 129 | 297 | 43.6M |
| jump | 100 | 141 | 141 | 308 | 46.3M |
| jump | 300 | 175 | 175 | 344 | 54.8M |
| jump | 1,000 | 288 | 288 | 464 | 83.3M |
| jump | 3,000 | 599 | 599 | 800 | 161.7M |
| jump | 10,000 | 1,696 | 1,696 | 1,989 | 435.0M |

Every over-budget allocation on the jump arm falls after the jump step. The gradual arm never fails
the bound at any window, so it offers no knee to compare against in this model.

## Inference

**Inference 1 -- the jump's direction survives on a real buffer.** On the jump arm over-budget
allocations rise monotonically with the window, from 129 at 30 steps to 1,696 at 10,000. The simulated
paper read 1,281 at 30 steps to 32,488 at 10,000 with `k = 4`, over eight seeds. The shape agrees and
the magnitude does not: the real-buffer run has three seeds, one size model, and no two-population
slow-block mix. This run does not say which magnitude is right. It says the monotone direction is not
an artifact of the simulator's bookkeeping.

**Inference 2 -- the gradual knee is absent in this model.** The window knee paper read a knee near
1,000 to 3,000 steps on a gradual shift. This model's gradual arm fails the bound nowhere, so it
cannot show a knee at any window. The gradual result is a fault of the model's gentleness, not
evidence against the knee. Whether the knee lives in the real two-population mix is open, and this
run does not reach it.

**Inference 3 -- the copy price dominates once the bound fails.** At 10,000 steps the jump arm copies
435 MB against 6.5 to 7.1 MB on the gradual arm, about sixty times more. The window that holds the
bound longest is the one that spends the most copy traffic. This is the same trade the clear-cadence
paper named, now on a real buffer.

## Falsifier, as the window knee paper stated it

> If the over-budget count stays flat in the window after the jump step, the bound-failure reading is
> wrong for that workload.

**Did not fire.** The count after the jump rises with the window, from 129 to 1,696, across the same
six windows and three seeds. The reading that a long window fails the bound after a jump stands on a
real buffer, in this model.

## What this does not reach

- **The two-population model.** The simulated paper used slow blocks alive for about 10,000 steps.
  This run uses uniform per-slot churn. The slow-block population is the most likely source of the
  magnitude gap, and it is unrun.
- **A Zig or Rye allocator.** The host has no compiler for either language, so the allocator is glibc
  behind `ctypes`, with Python bookkeeping. Caravan's `Region` and Tally's arena may place the
  bookkeeping differently. Stated as a limit, not a claim.
- **Seeds.** Three seeds per cell. The simulated paper had eight. The spread of the means is not
  reported here, and a claim about any single cell would need the eight.
- **Real workloads.** No caller's live-set trace was used. The sizes are uniform by construction.

## Projection, with horizon, assumptions, falsifier, and confidence

**Projection.** A window that holds a bounded footprint through a single-step rise in live bytes will
also hold more over-budget allocations than a short window does, on any bump region whose budget lags
its live set. Horizon: the next two rounds that touch Caravan's or Tally's region budget.

**Assumptions.** The budget is `k` times an EWMA of live bytes; the clear compacts the live set; the
shift is one step; sizes are independent of the step within a phase.

**Falsifier.** A real-workload trace with a single-step rise in live bytes, run on Caravan's or
Tally's own region, where over-budget allocations stay flat or fall as the window grows. That would
overturn this projection for that workload.

**Confidence.** Moderate on the direction, which survives two implementations. Low on the magnitude,
which moves with the population model. Low on the gradual knee, which this model cannot show.

## Handoff

**For Bakery and Caravan.** The falsifier above is buildable on Caravan's region without a new module.
The scratch probe is the template. Bakery owns the shared-cache work this fruit does not touch.

**For Keaton.** Whether the knee is worth a slow-block run is a word, not a lap. The copy price on the
jump arm argues for a byte-threshold clear over a step-cadence clear at long windows, and the earlier
byte-threshold paper already names that. Which of the two wins on a real trace is the falsifier.

## Appendix -- the probe, as run

The probe was run as `python3 -I allocator_jump_probe.py gradual` and `... jump`, from a scratch
directory in the tree's own gitignored `.lap/` room. It is reproduced here so the numbers above can be
checked against it, then deleted. Its size is 104 lines, read at `20261009.170234`.

```python
# Scratch probe for the single-jump falsifier on a real allocator.
# A bump region lives in one glibc malloc'd buffer; clears re-copy live objects
# with real memmove. Run as: python3 -I allocator_jump_probe.py
import ctypes
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

SLOTS = 200              # live slots, fixed for the whole run
STEPS = 100000           # replacements per run
JUMP_AT = 50000          # the jump arm replaces every slot at this step
K = 4                    # budget multiple of the live EWMA
MIN_SIZE, MAX_SIZE = 16, 256
START_CAP = 1 << 20
JUMP_HI = 8 * MAX_SIZE   # the jump arm eightfolds the size ceiling, so live bytes rise about eightfold in one step


def size_for(rng, step, arm):
    # gradual arm drifts the size range up over the run; jump arm holds it, then swaps it
    if arm == "gradual":
        hi = MAX_SIZE + (MAX_SIZE * step) // STEPS
        return rng.randint(MIN_SIZE, hi)
    if step < JUMP_AT:
        return rng.randint(MIN_SIZE, MAX_SIZE)
    return rng.randint(MAX_SIZE, JUMP_HI)


def run(seed, window, arm):
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
    clears = 0
    copied = 0
    over = 0
    over_after = 0
    peak_cap = cap
    grows = 0
    for step in range(STEPS):
        if arm == "jump" and step == JUMP_AT:
            victims = range(SLOTS)
        else:
            victims = [rng.randrange(SLOTS)]
        for v in victims:
            live -= sizes[v]
            n = size_for(rng, step, arm)
            budget = K * ewma
            if used + n > budget:
                # clear: compact live objects to the front with real memmove
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
    return {"clears": clears, "copied": copied, "over": over, "over_after": over_after, "cap": peak_cap, "grows": grows}


if __name__ == "__main__":
    arm = sys.argv[1]
    for window in [30, 100, 300, 1000, 3000, 10000]:
        rows = [run(seed, window, arm) for seed in (20261009, 20261010, 20261011)]
        mean_over = sum(r["over"] for r in rows) / len(rows)
        mean_clears = sum(r["clears"] for r in rows) / len(rows)
        mean_copy = sum(r["copied"] for r in rows) / len(rows)
        mean_after = sum(r["over_after"] for r in rows) / len(rows)
        print(f"arm={arm} W={window} over_mean={mean_over:.1f} over_after_mean={mean_after:.1f} clears_mean={mean_clears:.1f} copied_mean={mean_copy:.0f} cap_max={max(r['cap'] for r in rows)}")
```

*Two probe faults this run found, kept as record:* the first draft counted steps where the footprint
exceeded `k` times live, which is not the paper's definition. Once the count was brought into line with
the paper's own sentence, the doubling arm read zero everywhere, and the eightfold jump was the change
that let the bound fail at all. The first run's numbers were read and set aside; none of them appears
in the table above.
