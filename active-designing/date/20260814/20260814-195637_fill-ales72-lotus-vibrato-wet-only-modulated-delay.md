# Fill ALES72 — Lotus's vibrato: the modulated delay heard wet-only

**Stamp:** `20260814.195637` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the wet-only sibling of the chorus, the thinnest rung on ALES71's triangle-LFO modulated delay)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES72**
**Kin:** [`../lotus/chorus.rye`](../lotus/chorus.rye) (ALES71 — the triangle-LFO modulated delay whose driver and read this reuses verbatim, only dropping the dry) · [`../lotus/glide.rye`](../lotus/glide.rye) (ALES70 — the fractional interpolation both stand on) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and the one true saturate)

---

## Why this rung

ALES71 gave Lotus the **chorus** — a triangle LFO swings the scaled delay gently up and back round a centre, and the **dry mixed with** that slowly-detuned copy of itself makes one voice sound like several. The chorus's own closing line names its two siblings: *the vibrato (this delay heard wet-only) and the flanger (a shorter one with feedback) follow.* The vibrato is the nearer of the two, and the thinner.

Heard **wet-only** — the modulated delayed copy **alone**, with no dry underneath — the same swinging delay is no longer a widening of one voice but a **pitch wobble**: as the delay lengthens the copy is read slower and drops in pitch, as it shortens the copy is read faster and rises, so a steady note gently waves sharp and flat. That is **vibrato**, and it is exactly the chorus with the dry removed and the wet at full.

Lindy-first, every part of the arithmetic is already proven — the triangle driver (ALES71), the fractional interpolation read (ALES70), the frozen-snapshot discipline (ALES68). This rung invents no new arithmetic; it only **changes what reaches the output**. Crux-first, the one decisive move is to prove the family identity outright: **the chorus is the dry plus the vibrato**, so the two rungs are shown to be one delay heard two ways rather than two independent tools.

## The crux — the same modulated read, heard alone

The vibrato reuses ALES71's `triangle_delay_at` and ALES70's interpolation read **verbatim**. The only change is the write:

```
d_s(k) = centre_scaled + triangle(depth_scaled, period, k)   (ALES71's driver, reused)
near   = dry[i − d_whole]        (the nearer, smaller-delay sample)
far    = dry[i − d_whole − 1]    (the further, larger-delay sample)
delayed = ( near·(glide_scale − frac) + far·frac ) / glide_scale   (ALES70's read, reused)

chorus:   y[i] = saturate( x[i] + delayed )     — the dry plus the wet voice
vibrato:  y[i] =           delayed              — the wet voice ALONE
```

`delayed` is a convex combination of two `i16` neighbours (the weights are non-negative and sum to `glide_scale`), so it **already fits the `i16` rail** — there is no dry sum to overflow. The write goes through the one true `saturate` for uniformity with the family, yet an invariant states plainly that it never actually clips: the vibrato voice can only ever be as loud as the dry it is read from. Every read is off a **frozen snapshot** of the dry prefix (the ALES68/ALES70/ALES71 idiom, reused), so a moving read never reads a sample it just wrote.

Because the vibrato is inherently full-wet — the delayed voice **is** the whole output — there is no `num/den` mix level, and so **no `BadLevel` fault**. The other four faults carry over exactly from the chorus.

## Shape

`lotus/vibrato.rye` offers `vibrato(clip, start, count, centre_scaled, depth_scaled, period)` — the chorus's signature with the `num, den` pair dropped. It reads `chorus.triangle_delay_at` and `glide.glide_scale` over their public APIs (no new driver, no new interpolation). Faults: `BadPeriod` (a period that is not a positive multiple of four, or past `max_clip`), `BadDepth` (`centre − depth` under one whole sample, so the swing would dip below a legal delay), `BadDelay` (`centre + depth` whole past `max_clip`), `BadRange` (a span past the samples) — each before any write, the clip untouched.

## The laws to prove

1. **The chorus is the dry plus the vibrato** — the family identity. Snapshot the dry, run the vibrato to get the wet voice `V`, run the chorus at full wet `1/1` to get `C`; then `C[i] == saturate(dry[i] + V[i])` at every sample, proven directly. This ties the two rungs into one delay heard two ways.
2. **A hand-computed wet-only read** — the chorus's whole-sample-anchored case (centre `2·scale`, depth `1·scale`, period `4`), but heard wet-only: each output is `dry[i − delay(i)]` alone, computed by hand and matched exactly.
3. **A zero-depth vibrato is a fixed fractional delay** — `depth = 0`: the LFO sits at rest, the delay is a fixed whole `centre`, so the output is that steady delayed copy alone (a pure echo voice with no dry), computed by hand.
4. **The vibrato voice never exceeds the dry rail** — a loud steady signal read wet-only stays within `[sample_min, sample_max]` and never wraps, because a convex combination of two in-range samples is in range (the invariant the `saturate` no-op documents).
5. **Every fault refuses by name** — `BadPeriod`, `BadDepth`, `BadDelay`, `BadRange`, each leaving the clip untouched. There is no `BadLevel` — the vibrato has no mix level.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, siloed to `lotus/`. The delay is counted in scaled sample indices and the period in samples, not milliseconds or hertz — the real-time twin follows exactly as `echo_ms`, `multitap_ms`, and the modulated family's will. No lookahead beyond the snapshot read, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With the vibrato proven, the **flanger** (a shorter modulated delay with a feedback path) remains the family's next rung — the one that adds a genuinely new element rather than only changing the mix.
