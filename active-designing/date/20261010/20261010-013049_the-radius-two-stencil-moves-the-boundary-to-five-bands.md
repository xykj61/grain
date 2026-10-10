# The radius-two stencil moves the boundary to five row bands

**Status:** Research -- a fruit of the diffuser lane, one falsifier, one scratch model
**Room:** research for understanding -- a cache model run in a scratch pen; no witness binds it and no hardware counter was read
**Stamp:** `20261010.013049` (one clock, `America/New_York`)
**Kin:** [the row-band paper](20261009/20261009-214759_the-stencil-sweep-prefers-the-row-band.md) -- the radius-one result this paper extends

## What this paper asks

The row-band paper ran a 5-point stencil, a centre and its four neighbours, against a fully
associative LRU line cache. Its one prediction for a wider stencil was that a radius-two stencil
touches five rows instead of three, so the boundary where row-major stops losing to Morton should
move from about three row bands to about five. This paper runs that case in the same kind of model,
and it names the falsifier before the first run.

The question in plain words: when does a sweep in row-major order stop being beaten by a
space-filling order, and does a wider neighbourhood push that point further out?

## Observation

A scratch Python model, `session-output/diffuser-stencil-r2/stencil_r2.py` (untracked, gitignored),
generalises the row-band paper's model from a 5-point to a radius-R diamond. At R=2 the stencil has
13 points. The model keeps the paper's parameters: 16 cells per 64-byte line, a tile side of 16,
a fully associative LRU cache counted in lines, and two traversal orders. The traversal is either
row order, or the layout's own order, meaning the cells are sorted by the layout's address.

Two grid sizes were run, both with the same code: a 256 grid and a 512 grid. A row band is N cells,
which is N/16 lines: 16 lines on the 256 grid and 32 lines on the 512 grid. Five row bands are
80 lines on the 256 grid and 160 lines on the 512 grid.

Run on this pier, `20261010` (the run times are the model's own, in seconds):

| Grid | Traversal | Cache, lines | Row-major | Morton | Tiled 16 |
|---|---|---|---|---|---|
| 256 | own order | 16 | 0.0241 | 0.0125 | 0.0161 |
| 256 | own order | 48 (three bands) | 0.0241 | 0.0072 | 0.0151 |
| 256 | own order | 64 (four bands) | 0.0239 | 0.0070 | 0.0060 |
| 256 | own order | 80 (five bands) | 0.0048 | 0.0064 | 0.0060 |
| 256 | own order | 128 | 0.0048 | 0.0061 | 0.0060 |
| 512 | own order | 96 (three bands) | 0.0241 | 0.0065 | 0.0060 |
| 512 | own order | 128 (four bands) | 0.0240 | 0.0064 | 0.0060 |
| 512 | own order | 160 (five bands) | 0.0048 | 0.0059 | 0.0060 |
| 512 | own order | 256 | 0.0048 | 0.0056 | 0.0060 |

In the row-order traversal, row-major and Morton behave the same way the row-band paper reported
for R=1: row-major is the better order and reaches the same floor once the cache holds the band.
The full row-order sweep is in `run_256_r2.txt` in the same scratch room.

Read the table as observation only. Each rate is a miss fraction of the 13-point accesses. The
floor of 0.0048 on both grids is the level where row-major runs out of misses to avoid.

## The falsifier, named before the run

Two falsifiers were written before any run, and each one could have failed.

1. **Boundary.** For radius two, row-major should reach its floor at five row bands, about 5N/16
   lines, on both grid sizes. A row-major floor reached at four bands or fewer on either grid
   would kill the prediction.
2. **Morton at five bands.** At five or more row bands, Morton's own-order rate should not fall
   below row-major's own-order rate. A Morton rate below row-major's at five or more bands would
   kill the claim that row-major is the right default there.

The row-band paper's own falsifier, "Morton's own-order beats row-major at three row bands or
more", was written for the 5-point stencil. It is not a radius-two claim, so this run does not test
it, and this paper does not treat its outcome as a verdict on radius two.

## Result

**Boundary: held on both grids.** On the 256 grid, row-major reaches its floor at 80 lines, five
bands exactly. On the 512 grid the floor was not reached at 128 lines, four bands, so the 512 grid
was run further at 160, 192 and 256 lines. The floor appears at 160 lines, five bands exactly.
The falsifier named a floor at four bands or fewer, and neither grid shows one.

**Morton at five bands: held on both grids.** At 80 lines on the 256 grid, Morton's own-order rate
is 0.0064 against row-major's 0.0048. At 160 lines on the 512 grid it is 0.0059 against 0.0048,
and at 256 lines it is 0.0056 against 0.0048. Morton stays above row-major at five and six bands.

**What this run adds, not named before the run.** Below five bands, Morton's own-order sweep beats
row-major by a wide margin, not a narrow one. On the 256 grid at three bands the rates are 0.0072
against 0.0241, and on the 512 grid at three bands they are 0.0065 against 0.0241. The radius-one
boundary sat around three bands, so widening the stencil from one to two rows moves the crossover
out to about five. That is the mechanism the row-band paper gave: a stencil that touches more rows
needs more of the cache to hold its working set before row-major's sequential reuse pays off.

## Projection, with horizon, assumptions, falsifier, and confidence

**Horizon.** The model answers only for a fully associative LRU cache of the stated size, with a
single sweep and no conflicts. The horizon is the model itself, not any machine.

**Assumptions.** Sixteen cells per line, a 13-point diamond, a square grid with a power-of-two side,
and a line-counted capacity. A set-associative cache with power-of-two strides can make row-major
conflict far more than this model shows, which would push the boundary further toward row-major.
The model cannot show that, and it does not claim it.

**Falsifier.** A hardware counter run of the same sweep on a machine whose last-level miss count is
readable, with the capacity matched to five row bands, showing Morton's own-order rate below
row-major's at that capacity. The counter is not on this pier, so the falsifier is unrun.

**Confidence.** High that, inside this model, the boundary sits at five row bands for radius two on
both grids. Low that the boundary survives a set-associative cache, since the model removes the
conflicts that most often favour one layout over another on real hardware.

## What this does not reach

- **Real hardware.** The model has no prefetcher, no TLB, no set associativity, and no measured
  time. The earlier pier probes already found that the generic miss counter on this guest is not a
  demand count (the calibration note `20261009.222800`), so no hardware figure is claimed here.
- **Radius three and wider.** The model is run at radius two only. Its boundary, by the same
  arithmetic, would sit near seven bands, and that is a prediction, not a result.
- **Non-square grids and non-stencil scans.** Untested.

## Buildable now, from the model alone

- **A capacity-keyed choice of layout.** For a radius-R stencil on a line-counted cache, the row
  band in lines is N/16. Projection, not result: the two measured radii fit a boundary at (2R+1) row
  bands, which would be (2R+1)N/16 lines. Only R=1 and R=2 stand measured here. A
  layout chooser can compare the cache's line count against that number and pick the traversal
  that the model says wins, rather than defaulting to one layout.
- **A witness for the arithmetic, not for the hardware.** The 80 and 160 line floors are exact
  arithmetic and could be checked by a small witness in a scratch pen, without claiming a machine.

Not buildable from this paper: any default change in Caravan, Aurora, Tally, or Mantra. The model
does not show a real cache, and a layout change moves code that other ships read. That decision
waits for a hardware reading, and it belongs to Bakery's fusion lane, which owns the shared cache
this paper touches.

## Why this matters, in one sentence

A wider stencil needs more of the cache before the sequential order pays off, so the choice of
sweep order is a question about cache size, not a fixed rule about the grid.
