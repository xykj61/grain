# ALES11 -- Lotus's equal-power law, and the constant it keeps

**Stamp:** `20260814.122502` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES10
**Waymark:** ALES - rung ALES11
**Kin:** [`ALES10 -- pan, the second channel`](20260814-fill-ales10-lotus-pan-stereo.md) - [`ALES4 -- a fade envelope`](20260814-fill-ales4-lotus-fade-envelope.md) - [`lotus/power.rye`](../lotus/power.rye) - [`lotus/pan.rye`](../lotus/pan.rye) (ALES10) - [`lotus/fader.rye`](../lotus/fader.rye) (ALES8)

---

## Why this round

ALES10 opened the second channel with a **linear** pan -- weights that sum to `den`, so left + right reproduces the mono mix exactly. That law keeps the **sum** constant, and every rung since ALES4 named its companion as the road's next crux: the **equal-power** law, which keeps the **power** constant instead. Three rungs deferred it in the same words -- ALES4's fade, ALES10's pan, the README's road-on all end pointing here. Lindy-first, crux-first: the most durable unbuilt thing on the Lotus road is the law those three rungs kept promising, and the crux that makes it real is a piece of arithmetic the suite has never needed before -- a **square root over the integers**, proven to a contract.

A linear pan dips **-6 dB** at center: each channel gets half, so a centered track sounds quieter than a hard-panned one, and a linear crossfade audibly sags in the middle. The equal-power law fixes exactly this. It places each track on the **quarter circle** rather than the straight line between the speakers, so the two channels' *powers* -- their squared amplitudes -- sum to a constant. At center each side carries `0.707` (**-3 dB**), and a track keeps its apparent loudness wherever it sits in the field.

## The one crux this rung fixes

**Constant power is a fact about the squared weights, and it is exact in the power domain before a single sqrt is taken.** The temptation is to reach for `sin`/`cos` and a floating-point angle; the durable move is to see that "equal power" *means* the two squared weights sum to `den2`, and to build the weights from that fact directly:

> `left_power = den-(den - pos)` and `right_power = den-pos`, so **`left_power + right_power = den2` exactly, for any pan position.**

The amplitude weights are then `left = isqrt(left_power)`, `right = isqrt(right_power)` -- the honest floor of each square root. This is the whole law, with no trigonometry and no float: the power split is a straight line (linear in `pos`), and taking the square root bends that line into the quarter-circle the ear wants. The linear law was linear in **amplitude**; the equal-power law is linear in **power**.

The crux is therefore the **bounded integer square root** itself -- the one genuinely new arithmetic in the suite -- proven to its contract on metal:

> `isqrt(x)` returns the `r` with **`r2 <= x < (r+1)2`** -- the exact floor of sqrtx, no float, a fixed-bit digit-by-digit descent with a named bound (`max_pan_den2` never exceeds `224`, so twelve steps suffice).

Constant power then survives the truncation with a **proven bound**, not a hope: because each `isqrt` loses less than `2r+1`, the two amplitudes satisfy `left2 + right2 <= den2` and `den2 - (left2 + right2) <= 2-(left+right) + 2`. Power is constant to within the resolution of the square root -- and at any usable `den` (100, 1000) that resolution is inaudible, while the **-3 dB center** it buys is the whole point.

## The shape

`lotus/power.rye`:

- Reuses [`pan.StereoClip`](../lotus/pan.rye) and [`pan.max_pan_den`](../lotus/pan.rye) -- the second channel and the fold bound are ALES10's, untouched.
- `isqrt(x)` -- the bounded integer square root, its contract `r2 <= x < (r+1)2` asserted at the postcondition.
- `PowerPan { pos, den }` and `make(pos, den)` -- the same validated fraction ALES10 uses, refusing `BadGain` / `BadRange` at the edge.
- `weights(p)` -- the equal-power split: `isqrt(den-(den-pos))` left, `isqrt(den-pos)` right, with the constant-power law `left_power + right_power == den2` asserted exactly.
- `render_stereo(session, faders, pans, clock, out)` -- folds each track's fader with its equal-power weight into a per-channel effective fader, then runs ALES8's `fader.render` once per channel -- the same two-sums-are-one reuse ALES10 proved, only the weights are angular now. Forwards `ClipFull` / `DurationTooLong`.

## What the witness proves (GREEN on metal)

`tools/al/ales_power_witness.rish`: the `isqrt` contract holds across a sweep (`r2 <= x < (r+1)2`, and perfect squares land exact); the constant-power law `left_power + right_power == den2` holds for every position; a **center** pan carries `0.707` per side (-3 dB) -- distinctly louder than ALES10's linear `0.5` (-6 dB), the audible proof the law is angular, not straight; hard left and hard right route the whole track to one channel exactly (`isqrt(den2) == den`, `isqrt(0) == 0`); `left2 + right2` stays within the proven truncation bound of `den2` across the whole sweep (constant power, as distinct from ALES10's constant sum); pan composes with the fader; two tracks panned opposite separate into the two channels; `make` refuses `BadGain` / `BadRange`; a track past the master bound forwards `ClipFull`. Purely local -- no socket, no network, no keys, no funds, no real device, no real speaker.

## The road on

With both laws in hand -- linear for constant sum, equal-power for constant loudness -- the mixer can offer the keeper the choice a real desk offers, and the same `isqrt` now proves out unlocks the **equal-power crossfade** over time (ALES4's fade curve bent the same way) and honest **stereo metering** (an RMS level is a square root of a mean square). The audio-interface hardware -- the real two-channel sound-card write a stereo master would ultimately feed -- stays a paused research round, taken only on Keaton's word.
