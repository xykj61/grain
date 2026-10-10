# The seventh base reads the eleven-family break just above the line

**Status:** Design -- scratch-model reading, seven seed bases, one way, column-major walk, sixteen sets
**Room:** research for understanding -- the counts come from untracked scratch scripts (`session-output/diffuser-stencil-r3/`) and are reproducible by running them; no witness binds them yet.
**Lineage:** [`20261010-170418`](20261010-170418_the-sixth-base-keeps-the-sixteen-set-break-as-a-tendency.md) named a seventh seed base as its next door, with its falsifier written before the run.

## What the falsifier said, and when

Clock `20261010.170904`, before any seventh output file was opened, the seventh scripts carried this header: the eleven-family column-major tau-b at 16 sets must exceed 0.5, and the withdrawal rule is the sixth paper's own -- withdrawal only if the eleven-family reading is above 0.5 on a **majority** of bases. With seven bases that means **four above 0.5**. One base cannot trigger it.

## The run (observation)

Seed base `20261016`, `splitmix32(20261016, 24)`, 24 seeds, 16 sets by one way, column-major walk, modulus and stride5 controls reported beside the cluster. Outputs: `run_256_seventh_eleven_det_colmajor_16_seed20261016.txt` and `run_256_seventh_ten_det_colmajor_16_seed20261016.txt`, both written 20261010 17:09 to 17:28 by the two scripts named `run_r3_seventh_*_det_colmajor_16.py`.

| Family set | Tau-b (16 sets, column-major) | Null check |
|---|---|---|
| Eleven, with `xor_shift_line` | +0.56 (43 concordant, 12 discordant) | cluster pairs at zero reuse: 0 |
| Ten, `xor_shift_line` removed | +0.87 (42 concordant, 3 discordant) | cluster pairs at zero reuse: 0 |

The ten-family script's label read `eleven_det_colmajor_tau_b` in the sixth run and in this run's header copy, and the sixth paper flagged it. The seventh scripts print `ten_det_colmajor_tau_b` for the ten-family line. The cluster lists were already correct; only the label moved.

## The reading (inference, with its count)

Eleven-family tau-b across the bases read at 16 sets, column-major:

| Seed base | Eleven-family tau-b | Above 0.5? | Pre-registered? |
|---|---|---|---|
| 20261010 | +0.49 | no | yes |
| 20261011 | +0.35 | no | yes |
| 20261012 | +0.31 | no | yes |
| 20261013 | +0.53 | yes | **no** -- post-hoc |
| 20261014 | +0.27 | no | **no** -- post-hoc |
| 20261015 | +0.27 | no | yes |
| 20261016 | +0.56 | yes | yes |

Seven bases, two above 0.5. The withdrawal rule needs four. The pre-registered readings are four bases (`20261010`, `20261011`, `20261012`, `20261015`) plus this seventh, five in all; one of those five sits above 0.5, and that one is this seventh base. The falsifier as stated on its own terms did not fire, because a single above-line reading is not a majority.

The ten-family reading is +0.87 on this base, the highest of the ten-family set so far (readings run +0.51 to +0.82 across the earlier bases). The ten-family ordering is the stronger claim, and this base strengthens it.

## What this does not establish

- **The eleven-family break is not withdrawn, and not confirmed as a stable effect.** The eleven-family reading now sits within a band of roughly +0.27 to +0.56 across seven bases, straddling the 0.5 line. A binary break at 0.5 is a fragile way to state it.
- **The scratch model is not a real cache.** No live-set trace from a real caller exists in the tracked tree (`20261009.202114`), so nothing here reaches past the model.
- **The seed bases are not independent of the design choices.** The eleven-family cluster was chosen after the first break was seen; the paper's own record says so and the choice is not re-tested here.

## Projection, with its horizon, assumptions, falsifier and confidence

- **Horizon:** this scratch model, this stream, this traversal, these 16 sets.
- **Assumptions:** splitmix32-seeded hash families, 24 seeds per base, Kendall tau-b between mean per-set reuse distance and mean column-major miss rate.
- **Falsifier, stated now and before any eighth base is run:** an eighth base with its falsifier written first, at 24 seeds, will count toward withdrawal if the eleven-family reading lands above 0.5 on a majority of the eight bases, meaning at least five of eight. Then the eleven-family break is withdrawn in favour of the ten-family ordering alone. At or below 0.5 on a majority, the break stands as a tendency with its spread beside it.
- **Confidence:** moderate that the ten-family ordering holds on this model; low that the eleven-family 0.5 line is a fact about the model rather than about the seed bases.

## Next door

The next scratch-model step is an eighth base with its falsifier written first. The value of further bases is falling: each adds a point to a spread already known to straddle the line, and the only door that reaches past the model needs a live-set trace from a real caller, which the tracked tree does not hold. This paper recommends that the eighth base be run only if Keaton asks for it, and that the trace question be named as the real blocker.
