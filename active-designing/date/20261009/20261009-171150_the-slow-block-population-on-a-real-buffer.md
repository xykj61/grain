# The slow-block population on a real buffer

**Status:** Landed -- one falsifier run, one scratch probe; the paper stands and the probe is copied into the appendix below
**Room:** vision -- the probe is scratch and no witness binds these numbers; the numbers are free, and re-running the appendix reproduces them
**Stamp:** `20261009.171150` (EDT)
**Kin:** [the single jump on a real buffer](20261009-170234_the-single-jump-on-a-real-buffer.md) (the run this one extends) - [the jump reverses the window trade](20261009-165111_the-jump-reverses-the-window-trade.md) (the simulated jump)
**Grade:** not yet graded -- the QA card has not been run on this page

The single-jump paper named its own next step: a population with a **slow block**, which its
real-buffer run did not model. Its magnitudes were about a third to a quarter larger than the
simulated paper's, and this page asks whether a slow block explains that gap. Short answer: no. A
slow block of the shape tried here moves the jump's over-budget counts by about five percent at
the widest window, which three seeds cannot separate from the uniform population.

## What the paper says, in order

**Observation.** On `20261009`, one scratch probe ran on the host with `python3 -I`, Python 3.13.15,
and glibc, the same host and the same real allocator as the single-jump run. Buffer, reallocation,
and compaction copies are real `ctypes.memmove` on one glibc `malloc`'d block that never grew past
1,048,576 bytes. The bump bookkeeping is Python arithmetic, as before.

**Observation.** The population is 200 live slots, 100,000 steps, three seeds (`20261009`,
`20261010`, `20261011`), budget `k = 4` times an exponentially weighted average of live bytes
with `alpha = 1/W`, and `W` swept over 30, 100, 300, 1,000, 3,000 and 10,000. The slow block is
the last 10 percent of slots (20 of 200). On each step one victim is chosen: a slow slot with
probability `0.1 x 0.1 = 0.01`, otherwise a fast slot. So each fast slot is replaced at about
`0.99 / 180 = 0.0055` per step, a mean lifetime of about 183 steps, and each slow slot at about
`0.01 / 20 = 0.0005` per step, a mean lifetime of about 2,000 steps. That is a lifetime ratio of
about eleven, which is the "about ten times" the card asked for.

**Observation.** Three runs, mean over seeds, over-budget allocations after a clear:

| W | uniform control, jump | slow block, jump | slow block, gradual |
|---|---|---|---|
| 30 | 124.7 | 117.0 | 0.0 |
| 100 | 136.0 | 128.3 | 0.0 |
| 300 | 167.3 | 161.3 | 0.0 |
| 1,000 | 289.3 | 277.7 | 0.0 |
| 3,000 | 614.0 | 596.0 | 0.0 |
| 10,000 | 1,692.3 | 1,779.7 | 0.0 |

The uniform control is the single-jump probe with its slow fraction set to zero. It reproduces
the single-jump paper's shape, 129 to 1,696 there and 125 to 1,692 here. The two differ by a few
allocations because the control consumes one extra random draw per step, so its seed path is not
the earlier paper's path. The slow-block gradual arm reads zero over-budget allocations at every
window, as the uniform gradual arm did.

**Inference.** Under a jump, the slow block leaves the over-budget rise with the window almost
exactly where the uniform population put it. The gap between this real buffer and the simulated
paper is therefore not explained by a slow block of this size. Its likelier sources are the
simulated paper's own size distribution and clear accounting, which were never run against a real
allocator, and are named as open rather than assumed here.

**Inference.** The slow block does not produce the gradual knee either. Its gradual arm stays at
zero over-budget at every window, so whatever the window does, a drifting size ceiling alone never
breaches the bound in this model.

**Observation, the spread that was not measured.** Only the three means were kept. The per-seed
range was not printed, so the difference between arms at W=10,000 (about five percent) cannot be
set against seed noise from this run. A later run should print it before anyone reads that
difference as a finding.

## Falsifier, written before the run

The single-jump paper's falsifier was the knee, and it did not fire. This paper's falsifier is
narrower: **a slow block with the same eleven-times lifetime ratio should move the jump's
over-budget counts by at least a factor of two, at some window, from the uniform control.** If
the slow block only shifts magnitudes by a few percent everywhere, the gap to the simulated paper
has another cause. The run above shows a shift of about five percent at most, so the falsifier
does not fire. It would also fire if the slow block changed the direction of the jump's rise with
the window, and it did not.

## Projection, with its horizon, assumptions, falsifier, and confidence

**Horizon:** the next real-buffer run in this family, one scratch probe per paper.

**Assumptions:** the victim rule above, three seeds, a single jump at step 50,000, and glibc
`malloc` through `ctypes`. Not Zig, and not a Rye allocator.

**Falsifier:** a slow fraction nearer half the population, or a lifetime ratio nearer a hundred,
moves the jump's counts by at least a factor of two at some window. This is the test to run next
before any claim that slow blocks explain the simulated gap.

**Confidence:** moderate that a slow block of this size does not explain the magnitude gap; low
on the magnitudes themselves, since the seed spread was not printed and the probe is not a
witness.

## What this does not reach

- **Magnitudes against the simulated paper.** The gap is still there. This run only rules out one
  candidate cause of it.
- **Copy price.** The copy-traffic trade stays a word for Keaton, as the single-jump paper said.
- **A Zig or Rye allocator.** The host has no Zig and no Rishi on the search path, so the real
  allocator is still glibc.

## Appendix -- the probe, copied in full

The probe is the single-jump probe with a slow block added. Its uniform control is the same file
with `SLOW_FRAC = 0.0`. It runs in about six seconds per arm under `python3 -I`.

```python
# Scratch probe: slow-block population on glibc malloc, with a single jump.
# Fast slots (90%) are replaced each step with prob 1; slow slots (10%) are
# replaced with a one-in-SLOW_EVERY chance per step, so they live ~10x longer.
# Run as: python3 -I slowblock_probe.py <arm>   (arm = jump | gradual)
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
SLOW_FRAC = 0.10
N_SLOW = int(SLOTS * SLOW_FRAC)
SLOW_EVERY = 10
STEPS = 100000
JUMP_AT = 50000
K = 4
MIN_SIZE, MAX_SIZE = 16, 256
START_CAP = 1 << 20
JUMP_HI = 8 * MAX_SIZE

def size_for(rng, step, arm):
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
    clears = copied = over = over_after = grows = 0
    peak_cap = cap
    for step in range(STEPS):
        # one victim per step: a slow slot with probability 0.1 x 0.1, else a fast slot
        if rng.random() < SLOW_FRAC and rng.random() < 1.0 / SLOW_EVERY:
            v = rng.randrange(N_SLOW)
        else:
            v = N_SLOW + rng.randrange(SLOTS - N_SLOW)
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
    return {"clears": clears, "copied": copied, "over": over, "over_after": over_after, "cap": peak_cap, "grows": grows}

if __name__ == "__main__":
    arm = sys.argv[1]
    for window in [30, 100, 300, 1000, 3000, 10000]:
        rows = [run(seed, window, arm) for seed in (20261009, 20261010, 20261011)]
        m = lambda k: sum(r[k] for r in rows) / len(rows)
        print(f"arm={arm} W={window} over_mean={m('over'):.1f} over_after_mean={m('over_after'):.1f} clears_mean={m('clears'):.1f} copied_mean={m('copied'):.0f} cap_max={max(r['cap'] for r in rows)}")
```
