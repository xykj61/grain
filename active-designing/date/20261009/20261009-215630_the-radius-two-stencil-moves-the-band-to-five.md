# The radius-two stencil moves the row band to five, and the rule holds

**Language:** EN - **Voice:** Kyri - **Style:** Gauge at Field
**Room:** research for understanding -- a cache model run in a scratch pen; no witness binds it and no hardware counter was read
**Status:** Living
**Stamp:** `20261009.215630`
**Kin:** [the stencil sweep prefers the row band](20261009-214759_the-stencil-sweep-prefers-the-row-band.md) - [the call-site size mix is not the one the probe assumed](20261009-154443_the-call-site-size-mix-is-not-the-assumed-mix.md)

## The question

The row-band paper ran a 5-point stencil (radius one) and found that row-major storage reaches the
compulsory miss floor once the cache holds three row bands, which is 3N/16 lines. It named the next
step itself: a radius-two stencil touches five rows, so the boundary should move to five bands, about
5N/16 lines. This paper runs that model. The question is whether the prediction holds, and whether
Z-order's small-cache advantage survives the wider stencil.

## Falsifier, written before the run

**The claim dies if** a configuration with a cache of at least 5N/16 lines shows Morton's own-order
miss rate **below** row-major's own-order rate at the same capacity, on either grid size. A second
kill condition: row-major does **not** reach its compulsory floor at or near 5N/16 lines, so the
row-band boundary is not five bands at all.

## What was measured, and how

A scratch model, run on this pier at `20261009.215630` with Python 3, in a directory under the
tree's gitignored lap room. It generalizes the radius-one script in the earlier paper to a plus-shaped
stencil of radius R: the centre plus 2R neighbours along each axis, so 4R + 1 cells per update.
Radius two gives nine cells. The cache is fully associative with LRU replacement. A line holds 16
four-byte cells, and the traversal is either row order or the layout's own sort order. Capacities
are 16 through 192 lines, with 80 and 160 added for the five-band boundary on N=256 and N=512.

```python
# stencil_radius.py -- miss rate of a radius-R plus-shaped stencil sweep,
# fully-associative LRU line cache.
import sys
from collections import OrderedDict

N = int(sys.argv[1]) if len(sys.argv) > 1 else 256
R = int(sys.argv[2]) if len(sys.argv) > 2 else 2
BITS = N.bit_length() - 1
PER_LINE = 16          # 64-byte line / 4-byte cell
T = 16                 # tile side
OFFS = [(0, 0)] + [(d, 0) for d in range(-R, R + 1) if d] + [(0, d) for d in range(-R, R + 1) if d]

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
        for dr, dc in OFFS:
            rr, cc = r + dr, c + dc
            if 0 <= rr < N and 0 <= cc < N:
                line = layout(rr, cc) // PER_LINE
                acc += 1
                if line in lru:
                    lru.move_to_end(line)
                else:
                    m += 1; lru[line] = 1
                    if len(lru) > cap: lru.popitem(last=False)
    return m / acc

print(f"N={N} R={R} compulsory_miss_rate={N*N//PER_LINE/((len(OFFS))*N*N-(len(OFFS)-1)*N):.4f}")
for order in ("rows", "own"):
    print(f"traversal={order}")
    for cap in (16, 32, 48, 64, 80, 96, 128, 160, 192):
        vals = [f"{n}={run(f, cap, order):.4f}" for n, f in
                (("rowmajor", rowmajor), ("morton", morton))]
        print(f"  cap_lines={cap:4d} " + " ".join(vals))
```

Run as `python3 -I stencil_radius.py 256 2` (about 27 seconds) and `python3 -I stencil_radius.py 512 2`
(about two minutes). The compulsory rate is the floor with one load per line, which for radius two is
the grid's `N*N/16` lines over `9*N*N - 8*N` accesses, so it reads 0.0070 at both sizes.

## Observation

**N=256, radius two, own-order traversal** (miss rate per access):

| Cache lines | Row-major | Morton | Reading |
|---|---|---|---|
| 16 | 0.0347 | 0.0135 | Morton lower |
| 48 | 0.0347 | 0.0099 | Morton lower |
| 64 | 0.0346 | 0.0099 | Morton lower |
| 80 | **0.0070** | 0.0091 | row-major at floor |
| 128 | 0.0070 | 0.0087 | row-major lower |
| 192 | 0.0070 | 0.0083 | row-major lower |

**N=512, radius two, own-order traversal:**

| Cache lines | Row-major | Morton | Reading |
|---|---|---|---|
| 16 | 0.0347 | 0.0137 | Morton lower |
| 96 | 0.0347 | 0.0093 | Morton lower |
| 128 | 0.0346 | 0.0090 | Morton lower |
| 160 | **0.0070** | 0.0085 | row-major at floor |
| 192 | 0.0070 | 0.0085 | row-major lower |

Row-major's floor appears at 80 lines on N=256 and at 160 lines on N=512. Both are 5N/16. Row-major
traversal alone shows the same boundary, with Morton worse at every size. The compulsory column reads
0.0070 on both grids, so the floor is the same at every size and only the boundary moves.

## Inference

**The boundary is five row bands for a radius-two stencil.** Row-major reads each line once when the
five rows the stencil touches stay resident, which is 5N/16 lines in this model. Below that, each row
re-reads the rows above and below from memory. The radius-one result of three bands follows the same
arithmetic, so the rule is "the cache holds the rows the stencil touches," stated in row bands.

**Z-order's advantage stays confined to the small cache.** Morton's own-order rate beats row-major's
below the boundary, and loses at and above it on both sizes. Widening the stencil moved the boundary
and did not move the sign.

## The falsifier, read

Neither kill condition fired. At and above 5N/16 lines, Morton's own-order rate stayed above
row-major's on both grids (N=256: 0.0091 against 0.0070 at 80 lines; N=512: 0.0085 against 0.0070 at
160 lines). Row-major reached its floor at 5N/16 on both grids, as predicted.

## Assumptions, and why they bound the claim

- **Fully-associative LRU.** The same limit as the radius-one paper. Real caches are set-associative,
  and row-major's power-of-two stride may conflict harder than this model shows.
- **One level, read-only, one plus-shaped stencil.** Writes, a second level, and box stencils are not
  modelled. The box case would touch the same rows, so its boundary is also five bands, but this run
  does not show it.
- **No hardware prefetch and no TLB.** Both favour row-major on hardware, and the model gives neither.

## Projection, with horizon, falsifier, and confidence

**Horizon.** A single-threaded, read-only, plus-shaped stencil of radius one or two over a square
grid of four-byte cells, on a single fully-associative cache. Nothing beyond that is claimed.

**Falsifier, unchanged.** A hardware counter run of the same sweep on a machine with a readable
last-level miss counter. At a cache of at least 5N/16 lines for radius two, Morton's miss count
should exceed row-major's. The pier's `/sys/bus/event_source` and `perf` were not read for this lap,
so the hardware figure stays unread.

**Confidence.** High that, inside this model, the row-major boundary sits at the rows the stencil
touches, and that Z-order does not win at or above it. Low that a real cache behaves the same way,
because the model omits conflicts, prefetch, and sets.

## Buildable now, and not

**Buildable from this reading alone:** nothing new. The row-major default the earlier paper proposed
already holds for radius two, since the boundary only moves outward. No module changes on this reading.

**Not buildable from this reading:** a claim about hardware, a Z-order implementation, or a tile size
tuned to a real cache. Each needs the counter named above, which this lap did not run.

## Why this paper

The earlier paper named this run as its next step and gave the arithmetic that predicted the answer.
A prediction that a sandbox can check in under three minutes is worth more than another sentence about
caches. The result matches, and the sign did not change, so the claim the earlier paper made stands
for the wider stencil as well.
