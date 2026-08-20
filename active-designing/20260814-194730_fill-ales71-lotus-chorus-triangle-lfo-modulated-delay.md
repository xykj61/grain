# Fill ALES71 — Lotus's chorus: a triangle-LFO modulated delay round a centre

**Stamp:** `20260814.194730` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the first *periodic* modulated delay, the thin rung that stands on ALES70's fractional interpolation and yields the chorus)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES71**
**Kin:** [`../lotus/glide.rye`](../lotus/glide.rye) (ALES70 — the fractional interpolation this drives with a periodic LFO instead of a one-way ramp) · [`../lotus/taps.rye`](../lotus/taps.rye) (ALES68 — the fixed integer tap a zero-depth chorus reduces to) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and the one true saturate)

---

## Why this rung

ALES70 introduced the one genuinely new arithmetic the modulated-delay family needs — a delay read at a **fractional** position by linear interpolation of its two neighbours — and drove it with the simplest honest motion, a one-way linear **glide** from a start to an end position (the flanger's sweep). The effect a keeper actually reaches for is not a one-way sweep but a **periodic** one: the delay swings gently up and back down round a centre, over and over, and the dry mixed with that slowly-detuned copy of itself is the **chorus** — one voice made to sound like several.

Lindy-first, the interpolation is already proven; this rung adds only the *driver* — the periodic waveform that chooses the scaled delay at each sample — so it is a thin, durable rung the vibrato and the flanger reuse without change. Crux-first, the decisive move is a clean **triangle LFO** with **exact anchors**: a waveform whose value at the quarter points of its period is exactly the centre, the top, the centre, and the bottom, so the modulation is testable directly rather than trusted.

## The crux — a triangle LFO drives the scaled delay round a centre

The chorus reuses ALES70's interpolation read unchanged; the only new thing is *how the scaled delay moves*. Instead of the one-way ramp `scaled_delay_at`, the scaled delay at span offset `k` is a **periodic triangle** round the centre:

```
d_s(k) = centre_scaled + triangle(depth_scaled, period, k)
```

where `triangle` is a symmetric wave with **exact anchors at the quarter points**. Over one period `P` (a positive multiple of four, `q = P/4`), with phase `p = k % P`:

```
p in [0,   q):   +depth · p / q            (centre → top)
p in [q,  2q):   +depth · (2q − p) / q      (top → centre)
p in [2q, 3q):   −depth · (p − 2q) / q      (centre → bottom)
p in [3q, 4q):   −depth · (4q − p) / q      (bottom → centre)
```

so `triangle(depth, P, 0) = 0`, `triangle(depth, P, q) = +depth`, `triangle(depth, P, 2q) = 0`, `triangle(depth, P, 3q) = −depth` — the four anchors, exact. Between anchors it is honestly `@divTrunc`-quantized (a scaled delay rarely lands on a whole triangle step), exactly as the ALES70 ramp is between its endpoints.

Then the read is ALES70's, verbatim:

```
near = dry[i − d_whole]        (the nearer, smaller-delay sample)
far  = dry[i − d_whole − 1]    (the further, larger-delay sample)
delayed = ( near·(glide_scale − frac) + far·frac ) / glide_scale
y[i]    = saturate( x[i] + level · delayed )
```

Every read is off a **frozen snapshot** of the dry prefix (the ALES68/ALES70 idiom, reused), so a moving read never reads a sample it just wrote. The delay never dips below one whole sample (`centre − depth ≥ glide_scale`) and never reaches past the widest clip (`(centre + depth)/glide_scale ≤ max_clip`), both checked at the edge before any write.

## Shape

`lotus/chorus.rye` offers `chorus(clip, start, count, centre_scaled, depth_scaled, period, num, den)`. A small pure public helper `triangle_delay_at(centre_scaled, depth_scaled, period, k)` computes the scaled delay from the LFO, so the modulation is testable directly at and between its anchors. Faults: `BadPeriod` (a period that is not a positive multiple of four), `BadDepth` (`centre − depth` under one whole sample, so the swing would dip below a legal delay), `BadDelay` (`centre + depth` whole past `max_clip`), `BadLevel` (`num > den` or `den == 0`), `BadRange` (a span past the samples) — each before any write, the clip untouched.

## The laws to prove

1. **`level = 0` is the dry identity** — the wet turned off, the dry passes byte-for-byte at any modulation.
2. **A zero-depth chorus is exactly the glide at its centre** — `depth = 0`: the LFO sits at rest, the delay is a fixed whole `centre`, so the chorus equals ALES70's `glide(centre, centre)` **byte-for-byte** (both tools run — the periodic driver reduces to the one-way one when it does not move), which in turn equals ALES68's one-tap multi-tap at that delay.
3. **The triangle honors its anchors** — `triangle_delay_at` returns `centre` at `k = 0` and `k = 2q`, `centre + depth` at `k = q`, `centre − depth` at `k = 3q`, and repeats one period later (`k = P` returns `centre` again), proven directly on the pure helper.
4. **A hand-computed modulated read** — a legible signal and a period whose anchors put the delay on whole samples, so a few output samples are computed by hand and matched exactly.
5. **A loud wet-plus-dry sum saturates** — pins to `sample_max` rather than wrapping.
6. **Every fault refuses by name** — `BadPeriod`, `BadDepth`, `BadDelay`, `BadLevel`, `BadRange`, each leaving the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, siloed to `lotus/`. The delay and the period are counted in sample indices (the delay scaled by `glide_scale`), not milliseconds or hertz — the real-time twin follows exactly as `echo_ms`, `multitap_ms`, and the glide's will. No lookahead beyond the snapshot read, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With the periodic driver proven, the **vibrato** (the same modulated delay heard wet-only, no dry) and the **flanger** (a shorter modulated delay with feedback) are thin later rungs that only change the mix and add the feedback path.
