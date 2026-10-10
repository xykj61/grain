# The set-associative floor follows capacity and stride

**Status:** Research -- a fruit of the diffuser lane, one scratch model, one fresh falsifier
**Room:** research for understanding -- no witness binds these numbers; the model is untracked
**Stamp:** `20261010.013718`
**Kin:** [the radius-two stencil paper](20261010-013049_the-radius-two-stencil-moves-the-boundary-to-five-bands.md) -- this paper runs the set-associative variant that paper named as its open question
**Scratch scripts:** `session-output/diffuser-stencil-r2/stencil_setassoc.py`, `run_odd_ways.py` and `run_padded.py` (gitignored, per seat; re-run with `python3 -I`)

## What this paper asks

The radius-two paper found that row-major reaches its compulsory miss floor at five row bands:
80 lines on the 256 grid, 160 on the 512. That model was **fully associative** -- any line may
sit in any slot. A real cache is set-associative: a line may sit only in the few ways of one set,
chosen by its address. The open question was whether the five-band boundary survives that
constraint.

## The falsifier, named before the decisive run

The set-associative model was written and run once on a power-of-two grid of sets and ways
(sets 8, 16, 32; ways 2, 4, 8) before the falsifier below was written. That first grid could not
read the five-band point exactly, because 80 lines is not a power-of-two set count times a
power-of-two way count. So the falsifier was written **after** that grid and **before** the
odd-way run:

> **The five-band boundary holds under set-associativity if, at 80 total lines on the 256 grid,
> row-major's radius-two miss rate reaches the compulsory floor of 0.0048 (the fully-associative
> reading) for any set-and-way split that totals 80.** It **fires** if a split totalling 80 lines
> leaves row-major above the floor, or if Morton's own-order lead below five bands disappears.

The caveat is stated plainly: the power-of-two grid is what suggested the stride mechanism below,
so this falsifier is post-hoc in part. Its decisive part is the odd-way run, which the grid did not
contain.

## Observation: the power-of-two grid

Radius two, N=256, row-major, traversal in rows. Miss rate per access; the compulsory floor is 0.0048.

| sets | ways | total lines | row-major | Morton |
|---:|---:|---:|---:|---:|
| 8 | 8 | 64 | 0.0138 | 0.0384 |
| 16 | 4 | 64 | 0.3619 | 0.0384 |
| 32 | 4 | 128 | 0.0048 | 0.0384 |
| 16 | 8 | 128 | 0.0048 | 0.0384 |

Row-major reaches the floor only at 128 lines in this grid, not at 80. The fully-associative
reading said 80. The same grid, traversed in Morton's own order, keeps Morton ahead at every size
below the floor (0.0057 to 0.0126 against row-major's 0.0048 to 0.4122).

## Observation: the odd-way run

Holding total lines at 80 and 96 with ways that are not powers of two:

| sets | ways | total lines | traversal | row-major | Morton |
|---:|---:|---:|---|---:|---:|
| 16 | 5 | 80 | rows | 0.0048 | 0.0384 |
| 16 | 5 | 80 | own | 0.0048 | 0.0067 |
| 8 | 10 | 80 | rows | 0.0048 | 0.0384 |
| 8 | 10 | 80 | own | 0.0048 | 0.0069 |
| 16 | 6 | 96 | rows | 0.0048 | 0.0384 |
| 32 | 3 | 96 | rows | 0.0048 | 0.0384 |

The falsifier does not fire: at 80 total lines, every split reaches the floor for row-major, and
Morton's lead holds. The first grid's 128-line reading was a property of the split, not of the
capacity.

## Two causes, read apart

**Cause one: the row stride causes a conflict pathology at 16 sets.** At N=256 a row starts at a
line index that is a multiple of 16. With 16 sets, every row's first line lands in the same set,
so five row bands compete for four ways in a few sets. That is the 0.3619 at 64 lines: a
conflict, not a capacity limit. Padding each row by one line (one 16-cell line, so the stride is
17 lines) removes it: the same 16-set, 4-way split reads 0.0239 instead of 0.3619.

**Cause two: the floor at 128 lines is capacity granularity, not conflict.** A power-of-two
total can only be 64, 128, 256 and so on. The fully-associative model reaches the floor at 80, and
no power-of-two split totals 80. The next power-of-two total is 128, and the padded 8-set, 8-way
split (64 lines) reads 0.0239, exactly the fully-associative reading at 64. So the 128 is where
the first power-of-two capacity clears the five-band working set, and the odd-way run shows the
floor sits at 80 once the total can be 80.

**The falsifier for cause one ran, and it held.** The prediction was that padding moves the
power-of-two floor down toward 80. It did not do that. Padding removed the 0.36 conflict cliff
at 16 sets, but left the 64-line splits above the floor (0.0239 against 0.0048), which is the
capacity reading. So the stride explains the worst cell and not the floor. The mechanism
inference is narrowed to that.

Padded and unpadded runs at radius two, N=256, rows traversal:

| sets | ways | total lines | row-major, unpadded | row-major, padded |
|---:|---:|---:|---:|---:|
| 8 | 8 | 64 | 0.0138 | 0.0239 |
| 16 | 4 | 64 | 0.3619 | 0.0239 |
| 32 | 4 | 128 | 0.0048 | 0.0048 |
| 16 | 8 | 128 | 0.0048 | 0.0048 |

The 8-by-8 unpadded value below the padded one is a small, unexplained reading in the favour of
the conflicting layout. It is recorded, not explained, and it is the one number here that does not
fit the capacity story cleanly.

## Projection, with horizon, assumptions, falsifier, and confidence

**Horizon.** The claim is about this scratch model and its one geometry, 2-D radius two, N=256 and
N=512 at the same row-band arithmetic. It says nothing about any real cache.

**Assumptions.** Cache line of 64 bytes, 4-byte cells, LRU within a set, no prefetch, no victim
cache, one tile side of 16 for the tiled layout, a single traversal per grid.

**Falsifier.** A hardware-counter run of the same sweep on a cache whose set count is a power of
two and whose row stride is a multiple of the set count, reading a row-major miss rate above the
floor at the five-band capacity. The counter is not on this pier, and the generic miss counter is
already known not to be a demand count, so the falsifier is unrun.

**Confidence.** High that the arithmetic is right at these two grids: the odd-way run reproduces
the fully-associative floor at 80 for every split tried. Moderate that the 16-set conflict is a
stride effect, since padding removes it. Low that any real machine shows either effect, since no
hardware is claimed.

## What this does not claim

No hardware reading. No claim that a real L1 or L2 behaves this way. No claim about radius three,
which the diffuser inner prompt still names as an open door. The boundary of five row bands stands
for the fully-associative model, and the set-associative result is that the five-band floor holds at
exactly 80 lines for any split that totals 80, and a power-of-two split must round up to 128 to
reach it. The stride pathology at 16 sets is real in this model and padding removes it.
