# The radius-three stencil moves the boundary to seven bands

**Status:** Research -- a fruit of the diffuser lane, one falsifier, one scratch model
**Room:** research for understanding -- a cache model run in a scratch pen; no witness binds it and no hardware counter was read
**Stamp:** `20261010.014349` (one clock, `America/New_York`)
**Kin:** [the radius-two paper](20261010/20261010-013049_the-radius-two-stencil-moves-the-boundary-to-five-bands.md) -- the result this paper extends to a 25-point stencil

## What this paper asks

The radius-two paper predicted that a radius-R stencil moves the row-major boundary to about (2R+1) row bands. That gives five bands at R=2 (measured) and seven at R=3 (not yet run). This paper runs R=3 in the same fully associative LRU model, on the same two grids, and reports whether the prediction holds.

The question in plain words: at what cache size does row-major stop losing to a space-filling order, when the stencil is a 25-point diamond that reaches three rows up and down?

## Observation

The scratch script `session-output/diffuser-stencil-r2/run_r3.py` (untracked, gitignored) is the radius-two model with the radius set to three. It keeps the parameters of the earlier paper: 16 cells per 64-byte line, a fully associative LRU cache counted in lines, and cells visited in the layout's own address order (`own` order). Only row-major and Morton were run. Tiled-16 was not run at R=3.

Run on this pier, `20261010`:

| Grid | Band (lines) | Cache, lines | Bands | Row-major | Morton |
|---|---|---|---|---|---|
| 256 | 16 | 64 | 4 | 0.0175 | 0.0036 |
| 256 | 16 | 80 | 5 | 0.0174 | 0.0034 |
| 256 | 16 | 96 | 6 | 0.0173 | 0.0033 |
| 256 | 16 | 112 | 7 | 0.0025 | 0.0033 |
| 256 | 16 | 128 | 8 | 0.0025 | 0.0032 |
| 512 | 32 | 160 | 5 | 0.0175 | 0.0031 |
| 512 | 32 | 192 | 6 | 0.0174 | 0.0031 |
| 512 | 32 | 224 | 7 | 0.0025 | 0.0030 |
| 512 | 32 | 256 | 8 | 0.0025 | 0.0029 |

Read the table as observation only. Each rate is a miss fraction of the 25-point accesses. The floor of 0.0025 on both grids is where row-major runs out of misses to avoid.

## The falsifier

Named before the run, in the radius-two paper: the boundary for radius R should sit near (2R+1) row bands, so about seven bands at R=3.

- **Boundary.** A row-major floor reached at six row bands or fewer on either grid kills the prediction.
- **Morton at seven bands.** At seven or more bands, Morton's rate should not fall below row-major's. A Morton rate below row-major's there would kill the claim that row-major is the right default at that size.

## Result

**Boundary: held on both grids.** On the 256 grid, row-major is still at 0.0173 at six bands (96 lines) and drops to 0.0025 at seven (112 lines). On the 512 grid it is 0.0174 at six bands (192 lines) and 0.0025 at seven (224 lines). The falsifier needed a floor at six bands or fewer, and neither grid shows one.

**Morton at seven bands: held on both grids.** At 112 lines on the 256 grid, Morton reads 0.0033 against row-major's 0.0025. At 224 lines on the 512 grid it reads 0.0030 against 0.0025. Morton stays above row-major at seven and eight bands.

**What this run adds.** Below seven bands, Morton beats row-major by a wide margin: about 0.0033 against 0.0173 on the 256 grid at six bands, and 0.0031 against 0.0174 on the 512 grid. Five bands gives the same picture, so the crossover is sharp rather than gradual in this model.

## Projection, with horizon, assumptions, falsifier, and confidence

**Horizon.** The model answers only for a fully associative LRU cache of the stated size, with one sweep and no conflicts. The horizon is the model, not any machine.

**Assumptions.** Sixteen cells per line, a 25-point diamond of radius three, square grids with power-of-two sides, and a line-counted capacity. Only two grid sizes were run, and only the `own` traversal order at radius three.

**Falsifier for the projection.** A hardware counter run of the same sweep on a machine whose last-level miss count is readable, with the capacity set to seven row bands, showing Morton's rate below row-major's at that capacity. The counter is not on this pier, so the falsifier is unrun. A set-associative run of the radius-three model is also unrun, and the radius-two paper's set-associative result suggests power-of-two strides could move the boundary.

**Confidence.** High that, inside this model, the boundary sits at seven row bands for radius three on both grids. Low that it survives a real set-associative cache, since the model removes the conflicts that most often favour one layout on real hardware. The (2R+1) rule has now been measured at R=1 and R=2 and at R=3 in this model; that is three points, which is enough to state the pattern here and too few to call it a law.

## What this does not reach

- **Real hardware.** No prefetcher, no TLB, no set associativity, no measured time. The generic miss counter on this guest is not a demand count (calibration note `20261009.222800`), so no hardware figure is claimed.
- **Radius four and wider, and non-diamond stencils.** Untested.
- **Tiled-16 at radius three.** Not run in this lap.

## Buildable now, from the model alone

- **A capacity-keyed layout chooser, with the rule stated as a projection.** For a radius-R stencil on a line-counted cache the boundary is (2R+1)N/16 lines. The three measured radii fit it. A chooser comparing cache lines against that figure, and choosing the traversal the model says wins, would be a candidate for a later lap.
- **A witness for the arithmetic, not the hardware.** The 112 and 224 line floors are exact arithmetic and could be checked in a scratch pen without claiming a machine.

Not buildable from this paper: any default change in Caravan, Aurora, Tally, or Mantra. The model does not show a real cache, and a layout change moves code that other ships read. That decision waits for a hardware reading and belongs to Bakery's fusion lane.

## Why this matters, in one sentence

A wider stencil needs more of the cache before the sequential order pays off, and at radius three that means seven row bands of lines, so the sweep order depends on the cache's size and the stencil's reach together.
