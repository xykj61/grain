# Fill ALES77 — Lotus's equal-power auto-pan: ALES11's quarter-circle split swept across the field

**Stamp:** `20260814.203749` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the modulation family's rung the auto-pan itself named as next — the equal-power curve against ALES76's linear centre)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES77**
**Kin:** [`../lotus/power.rye`](../lotus/power.rye) (ALES11 — the equal-power split `split(pos, den)` swept here in time) · [`../lotus/auto_pan.rye`](../lotus/auto_pan.rye) (ALES76 — the same triangle-swept position, only the linear split swapped for the equal-power one) · [`../lotus/chorus.rye`](../lotus/chorus.rye) (ALES71 — the triangle-LFO driver `triangle_delay_at`, now the pan position) · [`../lotus/pan.rye`](../lotus/pan.rye) (ALES10 — the StereoClip) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

ALES76's auto-pan swept ALES10's **linear** pan across the stereo field, and it closed on exactly this next rung by name: the **equal-power auto-pan**, ALES11's `power.split` swept in place of the linear weight, so the panned voice holds constant loudness as it crosses the field. The linear auto-pan preserved the **sum** — `left + right == src` byte-for-byte — at the cost of a −6 dB dip as the voice passes centre. This rung preserves the **power** instead: each sample sits on the **quarter circle** rather than the straight line between the speakers, so the two channels' squared amplitudes stay constant and the voice keeps its apparent loudness everywhere in the field. At centre each side carries **0.707 (−3 dB)** where the linear auto-pan gives **0.5 (−6 dB)** — the audible difference the equal-power law exists for.

Lindy-first, both durable primitives are already proven and untouched: ALES11's equal-power split (with its bounded integer `isqrt`, the one genuinely new arithmetic the suite ever needed) and ALES76's triangle-swept-position shape. Crux-first, the decisive recognition is a single sentence, the twin of ALES76's own: **equal-power auto-pan is ALES11's equal-power pan swept across time** — position through the stereo field and position through a triangle period are one parameter, and only the *law* reading that position changes.

## The crux — the swept quarter circle, and the power the split keeps

ALES11's defining property is that **the two squared weights sum to a constant** — `w_left² + w_right²` held at `den²` in the power domain, and within a proven two-`isqrt` truncation bound after the roots. Auto-pan-power reads the same swept position through that same split:

- the position is ALES71's triangle, read in units of `glide_scale` (`0` = hard left, `glide_scale` = hard right) — the field unit doubles as the split's denominator `den = glide_scale = 256`, which sits well inside ALES11's fold bound `max_pan_den = 4096`;
- the two amplitude weights are `power.split(pos, glide_scale) = [isqrt(den·(den − pos)), isqrt(den·pos)]`, reused **verbatim** — no pan arithmetic re-derived;
- each channel is a plain attenuation: `right[i] = saturate(x[i]·w_right(i)/glide_scale)`, `left[i] = saturate(x[i]·w_left(i)/glide_scale)`.

The **sum is no longer preserved** — that was the linear auto-pan's law, and letting it go is the whole point. What holds instead is the power: `w_left² + w_right² ≤ glide_scale²` at every sample under the swing, so the voice never grows louder than the dry as it crosses the field.

Because each weight is a **non-negative amplitude no greater than the field unit** (`isqrt` monotone with `den²` its cap), each channel is a fraction of the dry, so `|left|, |right| ≤ |x|` and both sit inside the i16 rail: the write's `saturate` is a proven **no-op**, exactly as the linear auto-pan's was. Equal-power auto-pan is the tremolo's non-negative kin too — no sign flip and no two's-complement corner (contrast the ring modulator). It reads the mono source and writes a fresh `StereoClip`; the source is **untouched**, a stereo render rather than an in-place edit.

## Shape

`lotus/auto_pan_power.rye` offers `auto_pan_power(src, out, centre_scaled, depth_scaled, period)` — it pans the whole mono `src` Clip into `out`, an ALES10 `StereoClip`, reading `chorus.triangle_delay_at`, `power.split`, `glide.glide_scale`, and `pan.StereoClip` over their public APIs. The field faults are exactly ALES76's, because the position window is identical (only the split law downstream differs):

- `BadPeriod` — a period that is not a positive multiple of four, or wider than `max_clip`.
- `BadDepth` — a negative depth, or a swing whose floor (`centre − depth`) falls past hard-left (below `0`) — a pan position has no sign.
- `BadPan` — a swing whose top (`centre + depth`) rises past hard-right (above `glide_scale`) — the position stays within the field.

There is no `BadGain` (the denominator is the fixed `glide_scale`, never a caller's divide), no `BadDelay`, and no `BadRange` on a span (the whole clip is panned and `out` shares the source's bound — asserted, never a live error).

## The laws to prove

1. **The moving equal-power law holds at every sample** — under a full triangle swing over a varied signal including `sample_min`, the two channel weights keep constant power: `w_left² + w_right² ≤ glide_scale²`, and within ALES11's proven two-`isqrt` truncation bound of `glide_scale²`. This is the crux (contrast ALES76's exact sum).
2. **A hand-computed sweep** — centre `scale/2`, depth `scale/2`, period `4`: the position traces `128 → 256 → 128 → 0 → 128`, so a steady `1000` splits `right = [707, 1000, 707, 0, 707]`, `left = [707, 0, 707, 1000, 707]` — 707 at centre, 1000 at the edge (`isqrt(256·128) = 181`, `1000·181/256 = 707`).
3. **The centre is −3 dB, not −6 dB** — a steady `1000` panned dead centre lands `707` each side under the equal-power law, distinctly louder than ALES76's linear `500`. The whole reason the rung exists, made visible.
4. **A depth-0 equal-power auto-pan is a static equal-power pan** — the LFO at rest holds one position: centre `scale/2` splits every sample to 0.707; centre `0` routes the whole clip to the left (right silent, `isqrt(den²) = den` exact); centre `scale` routes it wholly to the right.
5. **The source is read-only** — after `auto_pan_power`, `src` is unchanged.
6. **The equal-power voice never exceeds the dry rail** — each channel is an attenuation of an in-range sample, so both stay within `[sample_min, sample_max]` and the write's `saturate` is a documented no-op.
7. **Every fault refuses by name** — `BadPeriod`, `BadDepth`, `BadPan`, each leaving `src` and `out` untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one mono clip rendered to a two-channel `StereoClip`, siloed to `lotus/`. The position is counted in scaled units (`0` = hard left, `256` = hard right) and the period in samples, not hertz. No delay line, no snapshot, no lookahead, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate. No custody gate is touched. With both pan laws — linear (ALES76) and equal-power (ALES77) — now swept across time, the modulation family's three LFO targets (delay, amplitude, position) all stand complete; the family's next reach is the **stereo modulation** family, where the LFO drives the two channels in quadrature (a rotary/Leslie-style motion) rather than one mono source into the field.
