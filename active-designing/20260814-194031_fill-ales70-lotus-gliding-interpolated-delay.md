# Fill ALES70 — Lotus's gliding delay: a fractional delay read by linear interpolation

**Stamp:** `20260814.194031` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the genuinely new primitive — a delay at a *fractional* position, read by linear interpolation — that the periodic chorus, flanger, and vibrato will stand on)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES70**
**Kin:** [`../lotus/taps.rye`](../lotus/taps.rye) (ALES68 — the multi-tap whose fixed integer taps this generalizes to a moving fractional one) · [`../lotus/echo.rye`](../lotus/echo.rye) (ALES66 — the feedback delay) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and the one true saturate)

---

## Why this rung

Every delay so far reads the line at a **whole-sample** position — the feedback echo at a fixed integer delay, the multi-tap at several fixed integer delays. The effects a keeper reaches for next — the **chorus**, the **flanger**, the **vibrato** — all share one thing those cannot do: the delay **moves**, gliding smoothly through positions *between* two samples. A delay of two-and-a-half samples has no sample sitting there; the honest read is the **linear interpolation** of the two that straddle it. That interpolation is the one genuinely new arithmetic the whole modulated-delay family needs, and this rung introduces it in its simplest honest form — a delay that **glides** linearly from a start position to an end position across the span (the flanger's sweep), read fractionally.

Lindy-first, fractional interpolation is the primitive every richer modulation stands on for the rest of the suite; crux-first, it is the decisive hard-but-tractable move — introduce interpolation once, prove it exact at integer positions and correct at the half-sample, and the periodic LFO (chorus, vibrato) becomes a thin later rung that only chooses *how the delay moves*.

## The crux — a fractional delay is the linear interpolation of its two neighbours

The delay is carried in **fixed point**: a scaled integer `d_s = delay · glide_scale` (`glide_scale = 256`), so the whole delay is `d_s / glide_scale` and the fractional part is `d_s % glide_scale` over `glide_scale`. At each span sample `i` the scaled delay glides linearly from `d0_scaled` to `d1_scaled`; the read is

```
near = dry[i − d_whole]        (the nearer, smaller-delay sample)
far  = dry[i − d_whole − 1]    (the further, larger-delay sample)
delayed = ( near·(glide_scale − frac) + far·frac ) / glide_scale
y[i]    = saturate( x[i] + level · delayed )
```

Every read is off a **frozen snapshot** of the dry prefix (the ALES68 idiom, reused), so a moving read never reads a sample it just wrote. Two facts anchor the interpolation: at `frac = 0` the read returns `near` **exactly** (a whole-sample glide is a moving *integer* tap, so a fixed whole delay reduces to ALES68's one-tap multi-tap byte-for-byte), and at `frac = glide_scale/2` it returns the **exact average** of the two neighbours. `dry[j] = 0` for `j < 0` (silence before the clip). The wet is mixed at `level = num/den` (`num ≤ den`, a chorus voice at or below the dry), and the sum saturates once (ALES3's one true saturation).

## Shape

`lotus/glide.rye` offers `glide(clip, start, count, d0_scaled, d1_scaled, num, den)`. A small pure helper `scaled_delay_at(d0_scaled, d1_scaled, n, k)` computes the linear ramp (honestly `@divTrunc`-quantized, exact at the endpoints `k = 0 → d0`, `k = n−1 → d1`), so the sweep is testable directly. Faults: `BadDelay` (a scaled delay under one whole sample, or a whole delay past `max_clip`), `BadLevel` (`num > den` or `den == 0`), `BadRange` (a span past the samples) — each before any write, the clip untouched.

## The laws to prove

1. **`level = 0` is the dry identity** — the wet turned off, the dry passes byte-for-byte.
2. **A whole-sample glide is an exact integer tap** — `d0 == d1`, both whole multiples of `glide_scale`, `frac = 0`: the read returns `near` exactly, so a fixed whole delay at unity equals ALES68's one-tap multi-tap **byte-for-byte** (both tools run — the interpolation is exact at integer positions).
3. **The half-sample is the exact average** — a fixed delay of `2.5` samples reads `(dry[i−2] + dry[i−3]) / 2` at each sample, computed by hand on a known signal.
4. **The glide honors its endpoints** — `scaled_delay_at` returns `d0_scaled` at the first span sample and `d1_scaled` at the last, and moves monotonically between (the sweep is a true linear ramp).
5. **A loud wet-plus-dry sum saturates** — pins to `sample_max` rather than wrapping.
6. **Every fault refuses by name** — `BadDelay` on a sub-sample or too-wide delay, `BadLevel` on a tap above unity or a zero denominator, `BadRange` on a span past the samples, each leaving the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, siloed to `lotus/`. The delay is counted in sample indices (scaled), not milliseconds — the real-time twin follows exactly as `echo_ms` and `multitap_ms` did. No lookahead beyond the snapshot read, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With fractional interpolation proven, the **periodic** modulated delay — a triangle or sine LFO driving the delay round a centre — is a thin later rung that only chooses how the scaled delay moves; the chorus (a short modulated delay mixed with dry) and the flanger (a shorter one with feedback) fall out from there.
