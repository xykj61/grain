# Lattice -- the arithmetic voice, in bounded gardens

**Stamp:** `20260827.185500` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living module -- **laps 0 through 39 green**, all forty run together on Linux `20260829` by [`lattice_suite_witness.rish`](../tools/l/lattice_suite_witness.rish)
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Kin:** [`Lantern`](../lantern/README.md) serves what Lattice counts, [`Ember`](../ember/README.md) forges the corpus, [`Scribble`](../scribble/README.md) reads it -- the four faculties of the **Q-vane** (`context/QUIN.md`) (the card seated **Lumen** as this vane's name on `20260816` and 80 living pages still say Q-vane -- **REDS %300**, open and gated) - the trinity essay [`Lantern, Lattice, Kiln`](../foundations/20260827-025117_lantern-lattice-kiln.md) - the bounds law [`tame-guidance`](../.claude/rules/tame-guidance.md), which is why every op asserts its shape

---

## What this is

**Lattice is arithmetic that says what it is doing.** It holds explicit tensor math -- matrices of
`f32`, and forty operations over them -- inside **bounded gardens**, the season allocator every
module here reaches for rather than a raw arena.

Two disciplines shape every line of it, and they are the reason it is worth reading. **Every
operation asserts its own shape** before it computes, so a mismatch is a named refusal rather than
a wrong number. And **every lap is one operation with one witness**, so the module grew by forty
small provable steps rather than by one large plausible one.

Build order places **Lattice before Lantern** on purpose: every matmul that will one day serve a
model has already met its gate.

*Read as the Q-vane's voices, Lattice is the arithmetic one -- precision held in bounds, claims
sized honestly, a number meaning what it measures rather than what anyone wished.*

| Claim | Witness |
|--------|---------|
| f32 `Matrix` - shape asserts - matmul 2x2 | parity **211** |
| Elementwise `add` - shape asserts | parity **217** |
| Row-major `reshape` - element-count assert | parity **257** |
| `reduce_sum` into 1x1 - shape assert | parity **260** |
| Elementwise `scale` - shape assert | parity **264** - `tools/l/lattice_scale_witness.rish` |
| `transpose` - shape assert | parity **268** - `tools/l/lattice_transpose_witness.rish` |
| Elementwise `mul` - shape assert | parity **272** - `tools/l/lattice_mul_witness.rish` |
| `fill` with constant - shape assert | parity **276** - `tools/l/lattice_fill_witness.rish` |
| `copy` - shape assert | parity **280** - `tools/l/lattice_copy_witness.rish` |
| Elementwise `sub` - shape assert | parity **284** - `tools/l/lattice_sub_witness.rish` (`191112`) |
| Elementwise `neg` - shape assert | parity **291** - `tools/l/lattice_neg_witness.rish` (`192749`) |
| Elementwise `div` - shape assert - zero refuse | parity **295** - `tools/l/lattice_div_witness.rish` (`193358`) |
| `reduce_mean` into 1x1 - shape assert | parity **299** - `tools/l/lattice_reduce_mean_witness.rish` (`200203`) |
| Elementwise `abs` - shape assert | parity **303** - `tools/l/lattice_abs_witness.rish` (`200819`) |
| Elementwise `clamp` - shape assert | parity **307** - `tools/l/lattice_clamp_witness.rish` (`211930`) |
| `reduce_max` into 1x1 - shape assert | parity **311** - `tools/l/lattice_reduce_max_witness.rish` (`211930`) |
| `reduce_min` into 1x1 - shape assert | parity **315** - `tools/l/lattice_reduce_min_witness.rish` (`212715`) |
| Elementwise `sqrt` - negative refuse | parity **319** - `tools/l/lattice_sqrt_witness.rish` (`212715`) |
| Elementwise `exp` - shape assert | parity **323** - `tools/l/lattice_exp_witness.rish` (`213317`) |
| Elementwise `log` - non-positive refuse | parity **327** - `tools/l/lattice_log_witness.rish` (`213317`) |
| Elementwise `pow` - negative refuse | parity **331** - `tools/l/lattice_pow_witness.rish` (`213738`) |
| Elementwise `relu` - shape assert | parity **335** - `tools/l/lattice_relu_witness.rish` (`213738`) |
| Elementwise `sigmoid` - shape assert | parity **339** - `tools/l/lattice_sigmoid_witness.rish` (`214145`) |
| Row-wise `softmax` - shape assert | parity **343** - `tools/l/lattice_softmax_witness.rish` (`214145`) |
| Elementwise `tanh` - shape assert | parity **347** - `tools/l/lattice_tanh_witness.rish` (`215613`) |
| Elementwise `gelu` (tanh approx) - shape assert | parity **351** - `tools/l/lattice_gelu_witness.rish` (`215613`) |
| Elementwise `silu` - shape assert | parity **355** - `tools/l/lattice_silu_witness.rish` (`223639`) |
| Elementwise `leaky_relu` - shape assert | parity **359** - `tools/l/lattice_leaky_relu_witness.rish` (`223639`) |
| Elementwise `softplus` - shape assert | parity **363** - `tools/l/lattice_softplus_witness.rish` (`224322`) |
| Elementwise `maximum` - shape assert | parity **367** - `tools/l/lattice_maximum_witness.rish` (`224322`) |
| Elementwise `minimum` - shape assert | parity **371** - `tools/l/lattice_minimum_witness.rish` (`224805`) |
| Elementwise `elu` - shape assert | parity **375** - `tools/l/lattice_elu_witness.rish` (`224805`) |
| Elementwise `softsign` - shape assert | [`tools/l/lattice_softsign_witness.rish`](../tools/l/lattice_softsign_witness.rish) |
| Elementwise `square` - shape assert | [`tools/l/lattice_square_witness.rish`](../tools/l/lattice_square_witness.rish) |
| Elementwise `sign` - shape assert | [`tools/l/lattice_sign_witness.rish`](../tools/l/lattice_sign_witness.rish) |
| Elementwise `reciprocal` - shape assert | [`tools/l/lattice_reciprocal_witness.rish`](../tools/l/lattice_reciprocal_witness.rish) |
| Elementwise `hard_sigmoid` - shape assert | [`tools/l/lattice_hard_sigmoid_witness.rish`](../tools/l/lattice_hard_sigmoid_witness.rish) |
| Elementwise `rsqrt` - shape assert | [`tools/l/lattice_rsqrt_witness.rish`](../tools/l/lattice_rsqrt_witness.rish) |
| Elementwise `hardtanh` - shape assert | [`tools/l/lattice_hardtanh_witness.rish`](../tools/l/lattice_hardtanh_witness.rish) |
| Elementwise `cube` - shape assert | [`tools/l/lattice_cube_witness.rish`](../tools/l/lattice_cube_witness.rish) |

## Layout

| Path | Role |
|------|------|
| [`lattice_core.rye`](lattice_core.rye) | Matrix ops through minimum - elu |
| [`lattice.rye`](lattice.rye) | Selftest binary |

```bash
rishi/bin/rishi run tools/l/lattice_cube_witness.rish     # the newest rung -- cube
rishi/bin/rishi run tools/l/lattice_matmul_witness.rish      # the first -- matmul 2x2
rishi/bin/rishi run tools/l/lattice_suite_witness.rish # all forty, admitted and refused sides
```

*The eight rungs above lap 31 stood on disk and undocumented until `20260827`: the table stopped at
lap 31 while `tools/l/` carried lap witnesses through 40. A ladder counts what it has climbed
(`.claude/rules/stamp-and-name.md`), so the table counts forty now.*

*May the numbers stay honest before the model runs.*
