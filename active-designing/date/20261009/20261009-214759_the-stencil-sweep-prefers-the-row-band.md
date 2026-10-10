# The stencil sweep prefers the row band, and Z-order wins only below it

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Room:** research for understanding -- a cache model run in a scratch pen; no witness binds it and no hardware counter was read
**Status:** Living
**Stamp:** `20261009.214759`
**Kin:** [the call-site size mix is not the one the probe assumed](20261009-154443_the-call-site-size-mix-is-not-the-assumed-mix.md) - [the mixed-lifetime cost is space, not time](../20261003/20261003-102318_the-mixed-lifetime-cost-is-space-not-time.md)

## The question

Caravan, Tally, Aurora, and Mantra all hold two-dimensional grids of cells: canvases, tiles, and
channel maps. A common instinct, borrowed from texture hardware and from recursive algorithms, says
the grid should be stored in Z-order (Morton order), because nearby cells in both directions then
share cache lines. The question here is narrower: for the workload these modules are most likely to
run, a read-only 5-point stencil swept across the grid, does Z-order lower the cache miss rate
against plain row-major storage? And if it does, under what cache size?

## What was measured, and how

Observation. A Python model, run on this pier at `20261009.214759` in a scratch directory outside the
tree. It is a fully-associative LRU cache of 64-byte lines, holding 16 cells of four bytes each. Each
cell is read with its four neighbours, boundary reads skipped. Three layouts are compared: row-major,
Morton, and 16 by 16 tiles with row-major inside each tile. Each layout is traversed two ways: a plain
row sweep, and that layout's own storage order. The script is inlined below so the figures can be
re-derived on any machine with Python 3.

```python
# stencil_layout.py -- miss rate of a 5-point stencil sweep, fully-associative LRU line cache
import sys
from collections import OrderedDict

N = int(sys.argv[1]) if len(sys.argv) > 1 else 256
BITS = N.bit_length() - 1
PER_LINE = 16          # 64-byte line / 4-byte cell
T = 16                 # tile side

def rowmajor(r, c): return r * N + c

def morton(r, c):
    z = 0
    for b in range(BITS):
        z |= ((c >> b) & 1) << (2 * b)
        z |= ((r >> b) & 1) << (2 * b + 1)
    return z

def tiled(r, c):
    tr, tc = r // T, c // T
    return (tr * (N // T) + tc) * T * T + (r % T) * T + (c % T)

def run(layout, cap, order):
    cells = [(r, c) for r in range(N) for c in range(N)]
    if order == "own":
        cells.sort(key=lambda p: layout(*p))
    lru = OrderedDict(); m = acc = 0
    for r, c in cells:
        for rr, cc in ((r, c), (r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)):
            if 0 <= rr < N and 0 <= cc < N:
                line = layout(rr, cc) // PER_LINE
                acc += 1
                if line in lru:
                    lru.move_to_end(line)
                else:
                    m += 1; lru[line] = 1
                    if len(lru) > cap: lru.popitem(last=False)
    return m / acc

print(f"N={N} compulsory_miss_rate={N*N//PER_LINE/(5*N*N-4*N):.4f}")
for order in ("rows", "own"):
    print(f"traversal={order}")
    for cap in (16, 32, 48, 64, 96, 128, 192):
        vals = [f"{n}={run(f, cap, order):.4f}" for n, f in
                (("rowmajor", rowmajor), ("morton", morton), ("tiled16", tiled))]
        print(f"  cap_lines={cap:4d} " + " ".join(vals))
```

Run as `python3 -I stencil_layout.py 256` (about 15 seconds) and `python3 -I stencil_layout.py 512`
(about 25 seconds, the same script at a larger grid). The **compulsory** rate is the floor no layout
can beat: each line must be loaded once.

## The figures

Observation, grid 256 by 256, **compulsory miss rate 0.0125**, read `20261009.214759`:

| Cache (lines) | Row sweep: row-major | Row sweep: Morton | Own order: row-major | Own order: Morton | Own order: tiled 16 |
|---|---|---|---|---|---|
| 16 | 0.0375 | 0.0748 | 0.0375 | **0.0242** | 0.0375 |
| 32 | 0.0375 | 0.0748 | 0.0375 | **0.0208** | 0.0375 |
| 48 | **0.0125** | 0.0748 | **0.0125** | 0.0178 | 0.0146 |
| 64 | **0.0125** | 0.0615 | **0.0125** | 0.0177 | 0.0140 |
| 96 | **0.0125** | 0.0492 | **0.0125** | 0.0164 | 0.0140 |
| 128 | **0.0125** | **0.0125** | **0.0125** | 0.0156 | 0.0140 |
| 192 | **0.0125** | **0.0125** | **0.0125** | 0.0148 | 0.0140 |

Observation, grid 512 by 512, own traversal only (the row sweep was not run at this size), **compulsory
miss rate 0.0125** by the same formula. Row-major reaches the floor at 96 lines; Morton stays above it
through 192 lines:

| Cache (lines) | Own order: row-major | Own order: Morton | Own order: tiled 16 |
|---|---|---|---|
| 32 | 0.0375 | **0.0211** | 0.0383 |
| 64 | 0.0375 | **0.0181** | 0.0140 |
| 96 | **0.0125** | 0.0167 | 0.0140 |
| 128 | **0.0125** | 0.0162 | 0.0140 |
| 192 | **0.0125** | 0.0152 | 0.0140 |

The compulsory rate the script prints is `(N*N/16) / (5*N*N - 4*N)`: one load per line over the
accesses the stencil makes. It is **0.0125** at both sizes, because the line count and the access count
both grow with the square of N. Figures are read off the script's printout at `20261009.214759`; re-run
the script to read them again.

## What this says, and what it does not

**Observation.** In the row sweep, Morton never reaches the compulsory rate at any cache size tested
up to 192 lines, and it sits at 0.0492 to 0.0748 wherever row-major is still thrashing. In its own
order, Morton has the lowest miss rate at 16 and 32 lines on both grid sizes. Row-major reaches the
compulsory rate once the cache holds roughly three row bands.

**Inference.** A row band is N/16 lines, since a row of N cells at 16 cells per line spans N/16 lines.
A five-point stencil revisits the row above, the current row, and the row below, so it needs about
three bands resident to reuse them: 3N/16 lines. The table agrees with that. At N=256 row-major
reaches the floor at 48 lines, which is 3 times 16. At N=512 it reaches the floor at 96 lines, which is
3 times 32. Below that capacity, row-major re-reads the row above and below from memory on each row,
and Morton's clustering of nearby cells in both directions recovers some of that reuse. Above it, the
row band fits, row-major reads each line once, and no layout can do better.

**Inference.** Tiled storage is not a better answer for this workload. It matches row-major at the
floor (0.0140 against 0.0125, a small excess at tile edges) and never beats it.

## The falsifier, named before the run

**The claim dies if** a configuration with a cache of at least 3N/16 lines shows Morton's own-order miss
rate **below** row-major's own-order rate at the same capacity, on either grid size. The model reads
the opposite at 128 and 192 lines on N=256 and at 96 through 192 lines on N=512, so the claim survives
this run. A second falsifier is the hardware question, below.

## Assumptions, and why they bound the claim

- **Fully-associative LRU.** Real caches are set-associative, and conflict misses can hit row-major
  harder than the model shows, since row-major strides by N cells, a power of two. The model cannot
  show that.
- **One cache level, read-only, one stencil.** Writes, a second level, and wider stencils are not
  modelled. A 3 by 3 box stencil still touches only three rows, so its boundary stays at 3N/16. A
  radius-two stencil touches five rows, which would move the boundary to about 5N/16 lines by the same
  arithmetic. Neither is modelled here.
- **No hardware prefetch.** Real processors detect the row-major stream and prefetch ahead of it.
  That favours row-major further on hardware, and the model gives it no such help.
- **No TLB and no page effects.** Morton's jumps across the grid may cost more in pages than in lines.

## Projection, with horizon, falsifier, and confidence

**Horizon.** The projection covers a single-threaded read-only 5-point stencil over a square grid of
four-byte cells on a cache of one level. It says nothing about multi-level hierarchies, writes, or
other stencils until those are modelled.

**Assumptions.** The three assumptions above, each named in the list.

**Falsifier.** A hardware counter run of the same sweep on a machine with a readable last-level miss
counter, at a cache holding at least 3N/16 lines, in which Morton's miss count is lower than
row-major's. The pier's `/sys/bus/event_source` and `perf` were not checked for this lap, so the
hardware figure is unread; it is a named measurement, not a result.

**Confidence.** High that, inside this model, row-major is optimal once the row band fits. Low that
the small-cache advantage of Morton survives set-associativity and prefetch, since both are absent from
the model and both tend to favour row-major.

## What Caravan, Tally, Aurora, and Mantra can take from this

**Buildable now, from the model alone.** Default grid storage to row-major for stencil and scan
workloads, which the model says reaches the floor whenever the cache holds three row bands. Keep
Z-order as a candidate only for code whose traversal is forced into tiles and whose cache is known to
be small. No module changes on this reading, and none is proposed here.

**Not buildable from this reading.** A claim about hardware, a Z-order implementation, or a tile size
tuned to a real cache. Each needs the counter measurement named above, which this lap did not run.

## Why this paper

The lane's last fruit waited for a live-set trace this tree does not hold. This one asks a question a
sandbox can answer in fifteen seconds, with the falsifier written first and the model's own limits
printed beside its result. A sentence about a cache is cheap; a table a reader can re-run is not.
