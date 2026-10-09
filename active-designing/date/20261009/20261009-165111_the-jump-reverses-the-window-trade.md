# The jump reverses the window trade

**Status:** Landed -- research study, Field setting
**Room:** checkable -- the probe is a scratch file run here and deleted after its numbers were copied; no witness binds it yet
**Seated:** `20261009` by the diffuser lane, on the falsifier `20261009.163113` named and did not run
**Kin:** [the window knee](20261009-163113_the-window-knee-trades-overshoot-for-clears.md) (the falsifier this study runs) - [the live budget](20261009-162216_the-live-budget-bounds-the-footprint-at-k-times-live.md)

## The question

The window knee paper found that, on a gradual mix shift, overshoot falls and clears rise as the budget window lengthens, with a knee near 1,000 to 3,000 steps. It named one falsifier: a workload with a different rise rate, for example one that replaces its whole working set in a single jump. If the knee sits elsewhere there, the claim that the window is a lag is refuted for this model.

This study runs that workload.

## Setup

The probe is the window knee paper's model, with one change to the shift. Its file is printed in the appendix so a later lap can run it.

- A bump region of 200 slots: 20 fast slots replacing at probability 1/10 per step, 180 slow slots at 1/10,000.
- 100,000 steps, eight seeds (20261009 to 20261016), run with `python3 -I`.
- Every slot starts at a 64-byte block.
- The budget is `k` times an exponentially weighted average of live bytes, with alpha = 1/W. The average decays exactly between events.
- A clear re-copies every live block to the start of the region. The copy traffic is the live bytes moved.
- An allocation that still exceeds its budget after a clear counts as over budget.

Two arms share everything except the shift at step 50,000:

- **Control:** the gradual shift. Replacements after step 50,000 draw log-uniform sizes from 16 to 4,096 bytes, and each slot picks up the new mix only when it next turns over.
- **Jump:** the one-step shift. At step 50,000 every slot is replaced at once with a log-uniform block.

The control arm is the check on the model. If it does not reproduce the landed table, the jump arm says nothing about the knee.

## The control reproduces the landed table

Read per `k = 4` row, mean clears over the eight seeds, against the window knee paper's own table:

| Window (steps) | Clears, this probe | Clears, landed | Peak mean, this probe | Peak mean, landed |
|---|---|---|---|---|
| 30 | 396 | 397 | 5.17 | 5.28 |
| 100 | 399 | 400 | 5.07 | 5.16 |
| 300 | 407 | 408 | 4.94 | 4.85 |
| 1,000 | 434 | 435 | 4.55 | 4.48 |
| 3,000 | 508 | 507 | 4.57 | 4.53 |
| 10,000 | 798 | 800 | 4.38 | 4.27 |

The clears agree to within about one clear. The peaks agree to within 0.1, which is inside the seed spread the landed paper reports.

One figure does not reproduce. At `k = 4` and a 10,000-step window, this probe counts 6 over-budget allocations across the eight seeds, against the 8 the landed table names. The two probes probably count over budget at different points, and this study does not separate them. The 8 and the 6 both say the same thing: the bound fails at that window on this shift.

## What the jump does

**Observation.** Here are the jump arm's readings, with the control beside them.

| k | Window | Over budget (jump) | Clears (jump) | Peak mean (jump) | Clears (control) | Peak mean (control) |
|---|---|---|---|---|---|---|
| 4 | 30 | 1,281 | 500 | 4.31 | 396 | 5.17 |
| 4 | 100 | 1,490 | 526 | 4.33 | 399 | 5.07 |
| 4 | 300 | 2,128 | 609 | 4.38 | 407 | 4.94 |
| 4 | 1,000 | 4,324 | 898 | 4.49 | 434 | 4.55 |
| 4 | 3,000 | 10,901 | 1,761 | 4.56 | 508 | 4.57 |
| 4 | 10,000 | 32,488 | 4,597 | 4.56 | 798 | 4.38 |
| 8 | 30 | 588 | 220 | 8.64 | 168 | 10.53 |
| 8 | 100 | 639 | 227 | 8.65 | 170 | 9.98 |
| 8 | 300 | 783 | 245 | 8.74 | 173 | 9.71 |
| 8 | 1,000 | 1,248 | 310 | 8.90 | 181 | 8.88 |
| 8 | 3,000 | 2,598 | 502 | 9.12 | 202 | 8.99 |
| 8 | 10,000 | 7,551 | 1,190 | 9.13 | 263 | 8.80 |

Three readings sit on the face of the table.

- **The overshoot direction reverses.** On the control, the peak falls as the window lengthens, from 5.17 to 4.38 at `k = 4`. On the jump it rises, from 4.31 to 4.56. At `k = 8` the control falls from 10.53 to 8.80 and the jump rises from 8.64 to 9.13. The sign of the window's effect on overshoot depends on the rise rate.
- **Clears rise with the window in both arms.** On the jump the rise is steeper: at `k = 4` the count goes from 500 to 4,597, where the control goes from 396 to 798.
- **The over-budget column does not have a knee.** It climbs without bend across the whole sweep, from 1,281 to 32,488 at `k = 4`.

**Where the over-budget allocations fall.** The jump step carries a fixed share of the count, and the window adds the rest. Counting over-budget allocations split by step, over the same eight seeds at `k = 4`:

| Window | On the jump step (step 50,000) | After the jump step |
|---|---|---|
| 30 | 1,198 | 83 |
| 1,000 | 1,198 | 3,126 |
| 10,000 | 1,198 | 31,290 |

The 1,198 on the jump step is the same at every window. Within one step the budget average cannot react to the 200 blocks that arrive together, so each seed records about 150 over-budget allocations there whatever the window. The window-dependent share is the column after the jump step. It grows with the window, from 83 to 31,290. That column is the bound failure the window controls.

## Inference

The window knee paper read the window as a lag: a long window keeps the budget low after a shift, so the peak rides high and clears become rare. This study does not find that reading true for a single-step shift.

On a single-step shift the budget lags too, and the lag does not improve the overshoot. A short window catches the new live level sooner, so the budget rises and the peak falls, while a long window leaves the budget far below live for thousands of allocations. The clears and the bound failures both follow the window, and the direction for overshoot runs the other way from the gradual case. The window is still a lag, but the lag reads as harm only in the gradual shape. The sign depends on what the workload does.

## Falsifier outcome

The falsifier named in the knee paper was: a workload with a different rise rate, where the knee sits outside 1,000 to 3,000 steps, refutes the lag claim for this model. The jump arm meets the first half of that condition. The knee does not appear: the over-budget count rises monotonically, and the overshoot runs the opposite way. **The falsifier fired on the claim as written.** The knee paper's choice of 1,000 steps is still defensible on the gradual shift it measured. It is not a general answer, and this study does not make it one.

## Projection

- **Horizon:** a model result for a bump allocator with full re-copy clears and two size populations. It says nothing about a real allocator or a real workload.
- **Assumptions:** the bump model; the two-population slot model; a single shift at one step; live bytes read as the budget input; the eight-seed range; over-budget counted per allocation, not per episode.
- **Falsifier, this study's own:** a real allocator on a single-jump workload with the window swept. If the over-budget count stays flat in the window after the jump step, the bound-failure reading is wrong for that workload. It would overturn the claim that the window controls the bound failure.
- **Confidence:** high that the direction flips between the two arms in this model, since both arms run the same code and differ only in the shift. Moderate that the jump's bound failure transfers to a real allocator, since wall-clock cost and the real size distribution remain unmeasured. Low that any window is the right choice for a real workload before a measured one exists.

## What this does not show

Wall-clock time is still unmeasured. The copy traffic stands in for the cost of a clear, as it did in the knee paper. The probe does not model a clear that happens mid-batch, a region that frees individual blocks, or a size distribution taken from a real caller. Those are the open half of the falsifier above.

The result also weakens a claim the live budget paper made. That paper said a tracked budget holds near `k` times live under a mix shift. On the gradual shift this holds, with the bound failing only at long windows. On the jump it fails at every window, and the failure grows with the window. The live budget's own "about ten percent" overshoot figure was taken from the gradual shift and does not carry to the jump.

## Grade

Graded at Field by `sh tools/fixtures/q/qa_report_card.sh <this page> --setting field --service 80` on `20261009.165111`: composite 88, letter B+, truth 100 counted, service 80 judged. The figure moves with each edit, so run the card again rather than trusting it. No new witness and no new module.

## Appendix: the probe

Scratch file `.lap/window/probe.py`, run as `python3 -I .lap/window/probe.py control 4` and `... jump 4` (and `8`). The file is deleted once its numbers are copied into this page. It is reproduced here so the run stays repeatable.

```python
# Scratch probe: window knee under a one-jump working-set replacement.
# Model: bump region, 200 slots (20 fast p=1/10, 180 slow p=1e-4), 100k steps.
# Arms: control = prior gradual shift (new sizes only on replacement after step 50000);
#       jump    = every slot replaced at step 50000 with log-uniform sizes.
# Budget = k * EWMA(live, alpha=1/W), exact lazy decay between events.
# Clear = re-copy live to region start when offset+size exceeds budget.
import sys, math, heapq
from random import Random

STEPS = 100000
J = 50000
N = 200
NFAST = 20

def lognorm_size(rng):
    return int(math.exp(rng.uniform(math.log(16), math.log(4096))))

def run(seed, W, k, arm):
    rng = Random(seed)
    a = 1.0 / W
    dec = 1.0 - a
    size = [64] * N
    ver = [0] * N
    p = [0.1 if i < NFAST else 1e-4 for i in range(N)]
    live = 64 * N
    offset = live
    E = float(live)
    Lval = float(live)   # live value held since last update
    Lstep = 0
    clears = 0
    copy = 0
    over = 0
    peak = 0.0
    jumped = False
    heap = []
    def geo(pi, t):
        u = rng.random()
        return t + 1 + int(math.log(1 - u) / math.log(1 - pi))
    for i in range(N):
        heapq.heappush(heap, (geo(p[i], 0), i, ver[i]))
    if arm == "jump":
        heapq.heappush(heap, (J, -1, 0))
    while heap:
        t, i, v = heapq.heappop(heap)
        if t > STEPS:
            break
        if i >= 0 and v != ver[i]:
            continue
        # events at step t replace one slot (or all, for the jump event)
        targets = []
        if i == -1:
            jumped = True
            targets = list(range(N))
        else:
            targets = [i]
        for j in targets:
            # decay EWMA of live from Lstep to t
            dt = t - Lstep
            E = Lval + (E - Lval) * (dec ** dt)
            Lstep = t
            # free old
            live -= size[j]
            Lval = float(live)
            # choose new size
            if arm in ("jump", "control") and t >= J:
                s = lognorm_size(rng)
            else:
                s = 64
            budget = k * E
            if offset + s > budget:
                clears += 1
                copy += live
                offset = live
            if offset + s > budget:
                over += 1
            offset += s
            size[j] = s
            live += s
            Lval = float(live)
            if t >= J:
                peak = max(peak, offset / live)
            ver[j] += 1
            heapq.heappush(heap, (geo(p[j], t), j, ver[j]))
    return clears, copy, over, peak

if __name__ == "__main__":
    arm = sys.argv[1]
    k = int(sys.argv[2])
    for W in [30, 100, 300, 1000, 3000, 10000]:
        rows = [run(s, W, k, arm) for s in range(20261009, 20261017)]
        cl = sum(r[0] for r in rows) / len(rows)
        ov = sum(r[2] for r in rows)
        pk = sum(r[3] for r in rows) / len(rows)
        pmax = max(r[3] for r in rows)
        print(f"arm={arm} k={k} window={W} over={ov} clears_mean={cl:.0f} peak_mean={pk:.2f} peak_max={pmax:.2f}")
```
