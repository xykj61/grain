# The fifth base holds the drag, and the ten-family ordering holds by a hair

**Status:** Design -- scratch-model reading of the fifth seed base `20261014`, against the falsifier written at `20261010.155457`.
**Room:** research for understanding -- no witness binds the scratch scripts, so nothing here is checkable yet.
**Lineage:** [the falsifier](20261010-155457_the-xor-drag-is-stable-across-four-bases-and-a-fifth-base-tests-the-gap.md) fixed two thresholds before any fifth-base run: F1, the gap on base `20261014` at least +0.15; F2, the ten-family tau-b above 0.5.

## The run

Both scripts are copies of the fourth-base scripts. The only change is the seed constant, `20261013` to `20261014`, confirmed by diff. Everything else is the same: 16 sets, column-major walk, 24 seeds, one way, the 256 by 256 scratch grid. The two runs were launched together and finished on their own.

Observation, read from the `tau=` lines of the two output files:

| File | Family set | Tau-b (16 sets, base 20261014) |
|---|---|---|
| `run_256_fifth_eleven_det_colmajor_16_seed20261014.txt` | eleven, with `xor_shift_line` | +0.27 |
| `run_256_fifth_ten_det_colmajor_16_seed20261014.txt` | ten, `xor_shift_line` removed | +0.51 |

The ten-family script prints the copied label `eleven_det_colmajor_tau_b` on its tau line, the same labelling fault the fourth-base paper carried forward. Both values here are read by file name, not by the printed word.

## Against the two thresholds

- **Gap** = ten minus eleven = +0.51 - +0.27 = **+0.24**.
- **F1** (gap at least +0.15): **holds**. The gap sits inside the observed band of +0.25 to +0.29 on the four earlier bases, a little under its lowest value, and well above the +0.15 line.
- **F2** (ten-family tau-b above 0.5): **holds, by +0.01**. The reading is +0.51 against a line at 0.5. That is a real pass under the rule written in advance, and it is thin. A different seed base could land on either side of it.

Inference: `xor_shift_line` again drags the 16-set reading down on this base, by about a quarter of a tau unit. The drag is now stable across five bases, all on this scratch model.

Projection: none beyond the scratch model. Horizon: this stream and this model only. Confidence: moderate that the drag is a stable property of the index function on this model; low that it means anything about a real cache, since no real trace has been read.

## What the fifth base does not settle

The ten-family set was still chosen after the eleven-family break was seen. The fifth base tests whether the gap is stable. It cannot re-test the choice of `xor_shift_line` as the family to remove, which would need a family set fixed before any run. That caveat stands unchanged from the four-base paper.

The eleven-family side reads +0.27 here, below 0.5. Across the five bases, that side has now sat on both sides of the line: above on one base, below on four. The straddle is noted as a fact about the seeds, and it is not explained by this run.

The margin on F2 is one hundredth. A sixth base would be the first honest test of whether the ten-family ordering is stable above 0.5 or only lands there, and its falsifier should be written before that run, as this one was.

## Scope

- **Scratch model only.** A 256 by 256 grid, a radius-three diamond sweep, and a direct-mapped cache of one way. No hardware, no timing, no real traffic, no real caller's trace.
- **Not for BAKERY's modules.** This page says nothing about Caravan, Aurora, Tally, or Mantra.
- **Not a witness.** No witness binds the scratch scripts. The two fifth-base copies live in the gitignored `session-output/diffuser-stencil-r3/`, and their outputs are re-derivable by the reproduce commands in the falsifier.

## Next door

A sixth seed base, `20261015`, with its falsifier written first, using the same one-line seed change and the same two thresholds, F1 at +0.15 and F2 at 0.5. Thresholds are not to be lowered after seeing the base.

## Reproduce

```
cd session-output/diffuser-stencil-r3
python3 -I run_r3_fifth_eleven_det_colmajor_16.py > run_256_fifth_eleven_det_colmajor_16_seed20261014.txt
python3 -I run_r3_fifth_ten_det_colmajor_16.py > run_256_fifth_ten_det_colmajor_16_seed20261014.txt
```
