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

| Lap | Claim | Witness |
|-----|--------|---------|
| **0** | f32 `Matrix` - shape asserts - matmul 2x2 | parity **211** |
| **1** | Elementwise `add` - shape asserts | parity **217** |
| **2** | Row-major `reshape` - element-count assert | parity **257** |
| **3** | `reduce_sum` into 1x1 - shape assert | parity **260** |
| **4** | Elementwise `scale` - shape assert | parity **264** - `tools/l/lattice_lap5.rish` |
| **5** | `transpose` - shape assert | parity **268** - `tools/l/lattice_lap6.rish` |
| **6** | Elementwise `mul` - shape assert | parity **272** - `tools/l/lattice_lap7.rish` |
| **7** | `fill` with constant - shape assert | parity **276** - `tools/l/lattice_lap8.rish` |
| **8** | `copy` - shape assert | parity **280** - `tools/l/lattice_lap9.rish` |
| **9** | Elementwise `sub` - shape assert | parity **284** - `tools/l/lattice_lap10.rish` (`191112`) |
| **10** | Elementwise `neg` - shape assert | parity **291** - `tools/l/lattice_lap11.rish` (`192749`) |
| **11** | Elementwise `div` - shape assert - zero refuse | parity **295** - `tools/l/lattice_lap12.rish` (`193358`) |
| **12** | `reduce_mean` into 1x1 - shape assert | parity **299** - `tools/l/lattice_lap13.rish` (`200203`) |
| **13** | Elementwise `abs` - shape assert | parity **303** - `tools/l/lattice_lap14.rish` (`200819`) |
| **14** | Elementwise `clamp` - shape assert | parity **307** - `tools/l/lattice_lap15.rish` (`211930`) |
| **15** | `reduce_max` into 1x1 - shape assert | parity **311** - `tools/l/lattice_lap16.rish` (`211930`) |
| **16** | `reduce_min` into 1x1 - shape assert | parity **315** - `tools/l/lattice_lap17.rish` (`212715`) |
| **17** | Elementwise `sqrt` - negative refuse | parity **319** - `tools/l/lattice_lap18.rish` (`212715`) |
| **18** | Elementwise `exp` - shape assert | parity **323** - `tools/l/lattice_lap19.rish` (`213317`) |
| **19** | Elementwise `log` - non-positive refuse | parity **327** - `tools/l/lattice_lap20.rish` (`213317`) |
| **20** | Elementwise `pow` - negative refuse | parity **331** - `tools/l/lattice_lap21.rish` (`213738`) |
| **21** | Elementwise `relu` - shape assert | parity **335** - `tools/l/lattice_lap22.rish` (`213738`) |
| **22** | Elementwise `sigmoid` - shape assert | parity **339** - `tools/l/lattice_lap23.rish` (`214145`) |
| **23** | Row-wise `softmax` - shape assert | parity **343** - `tools/l/lattice_lap24.rish` (`214145`) |
| **24** | Elementwise `tanh` - shape assert | parity **347** - `tools/l/lattice_lap25.rish` (`215613`) |
| **25** | Elementwise `gelu` (tanh approx) - shape assert | parity **351** - `tools/l/lattice_lap26.rish` (`215613`) |
| **26** | Elementwise `silu` - shape assert | parity **355** - `tools/l/lattice_lap27.rish` (`223639`) |
| **27** | Elementwise `leaky_relu` - shape assert | parity **359** - `tools/l/lattice_lap28.rish` (`223639`) |
| **28** | Elementwise `softplus` - shape assert | parity **363** - `tools/l/lattice_lap29.rish` (`224322`) |
| **29** | Elementwise `maximum` - shape assert | parity **367** - `tools/l/lattice_lap30.rish` (`224322`) |
| **30** | Elementwise `minimum` - shape assert | parity **371** - `tools/l/lattice_lap31.rish` (`224805`) |
| **31** | Elementwise `elu` - shape assert | parity **375** - `tools/l/lattice_lap32.rish` (`224805`) |
| **32** | Elementwise `softsign` - shape assert | [`tools/l/lattice_lap33.rish`](../tools/l/lattice_lap33.rish) |
| **33** | Elementwise `square` - shape assert | [`tools/l/lattice_lap34.rish`](../tools/l/lattice_lap34.rish) |
| **34** | Elementwise `sign` - shape assert | [`tools/l/lattice_lap35.rish`](../tools/l/lattice_lap35.rish) |
| **35** | Elementwise `reciprocal` - shape assert | [`tools/l/lattice_lap36.rish`](../tools/l/lattice_lap36.rish) |
| **36** | Elementwise `hard_sigmoid` - shape assert | [`tools/l/lattice_lap37.rish`](../tools/l/lattice_lap37.rish) |
| **37** | Elementwise `rsqrt` - shape assert | [`tools/l/lattice_lap38.rish`](../tools/l/lattice_lap38.rish) |
| **38** | Elementwise `hardtanh` - shape assert | [`tools/l/lattice_lap39.rish`](../tools/l/lattice_lap39.rish) |
| **39** | Elementwise `cube` - shape assert | [`tools/l/lattice_lap40.rish`](../tools/l/lattice_lap40.rish) |

## Layout

| Path | Role |
|------|------|
| [`lattice_core.rye`](lattice_core.rye) | Matrix ops through minimum - elu |
| [`lattice.rye`](lattice.rye) | Selftest binary |

```bash
rishi/bin/rishi run tools/l/lattice_lap40.rish     # the newest rung -- cube
rishi/bin/rishi run tools/l/lattice_lap1.rish      # the first -- matmul 2x2
rishi/bin/rishi run tools/l/lattice_suite_witness.rish # all forty, admitted and refused sides
```

*The eight rungs above lap 31 stood on disk and undocumented until `20260827`: the table stopped at
lap 31 while `tools/l/` carried lap witnesses through 40. A ladder counts what it has climbed
(`.claude/rules/stamp-and-name.md`), so the table counts forty now.*

*May the numbers stay honest before the model runs.*
