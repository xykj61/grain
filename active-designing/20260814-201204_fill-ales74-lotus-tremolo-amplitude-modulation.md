# Fill ALES74 — Lotus's tremolo: the triangle LFO turned on amplitude

**Stamp:** `20260814.201204` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the modulation family's first rung on a NEW target — amplitude, not delay)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES74**
**Kin:** [`../lotus/chorus.rye`](../lotus/chorus.rye) (ALES71 — the triangle-LFO driver `triangle_delay_at` this reuses, now read as a gain) · [`../lotus/glide.rye`](../lotus/glide.rye) (ALES70 — `glide_scale`, the fixed-point unit both stand on) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and the one true saturate)

---

## Why this rung

The chorus (ALES71), the vibrato (ALES72), and the flanger (ALES73) all point the triangle LFO at **one target** — the delay. The chorus mixes the swinging delayed copy with the dry, the vibrato hears it alone, the flanger feeds it back; each is a different thing done with a **modulated delay**. The LFO driver `triangle_delay_at`, though, is a **general scaled triangle** — it was named for its first use, yet it knows nothing of delay. Point it at the sample's **amplitude** instead, and a steady note gently rises and falls in loudness: that is the **tremolo**, the oldest amplitude effect there is.

Lindy-first, the tremolo is the natural companion the family had not yet grown: the modulation family so far only ever changed a *delay*, and the tremolo opens modulation of *gain*. It is the primitive that auto-pan (the LFO on the stereo field) and the ring modulator (a faster carrier on the same gain) will later stand on, so proving the amplitude-LFO path now is the durable move. Crux-first, the decisive recognition is that **the same triangle that drove the delay drives the gain** — no new LFO, no new arithmetic, only a new target — and that reading amplitude needs **no delay line and no snapshot at all**, making the tremolo the thinnest rung in the whole modulation family.

## The crux — the LFO's other target

The tremolo reuses ALES71's `triangle_delay_at` **verbatim**, reading its result as a **gain in units of `glide_scale`** (`256` = unity) rather than a delay in scaled samples:

```
g(k) = centre_scaled + triangle(depth_scaled, period, k)   (ALES71's driver, reused — now a GAIN)
y[i] = saturate( x[i] · g(i) / glide_scale )
```

Because every output sample depends only on **its own** input sample — never a neighbour — the tremolo writes **in place with no snapshot**: reading `x[i]` and writing `y[i]` at the same index touches no sample another step needs. The vibrato had to freeze the dry prefix precisely because its read moved backward through samples it was overwriting; the tremolo's read never moves, so the whole snapshot machinery falls away.

The gain is held to an **attenuation** — `0 ≤ g(k) ≤ glide_scale` (top at or below unity, floor at or above silence) — so `x·g/scale` is always no louder than `x` itself. It therefore **already fits the `i16` rail**: the write goes through the one true `saturate` for family uniformity, yet an invariant states plainly that it never actually clips, exactly as the vibrato's wet-only write never clips. A full-scale sample at unity gain passes through byte-for-byte; at the trough it falls to silence; between, it traces the triangle.

## Shape

`lotus/tremolo.rye` offers `tremolo(clip, start, count, centre_scaled, depth_scaled, period)` — the vibrato's signature exactly, the two scaled parameters now naming a **gain centre and swing** rather than a delay centre and swing. It reads `chorus.triangle_delay_at` and `glide.glide_scale` over their public APIs — no new driver. Faults, each refused before any write with the clip untouched:

- `BadPeriod` — a period that is not a positive multiple of four (the triangle's quarter anchors need `P/4` whole), or wider than `max_clip`.
- `BadDepth` — a negative depth, or a swing whose floor (`centre − depth`) falls below silence (a negative gain would be a sign flip, a different effect).
- `BadGain` — a swing whose top (`centre + depth`) rises above unity (`glide_scale`); the tremolo attenuates, it does not boost.
- `BadRange` — a span outside the current samples.

There is no `BadDelay` and no `BadLevel` — the tremolo has no delay line to overrun and no dry/wet mix to level; the gain **is** the level.

## The laws to prove

1. **A steady signal traces the triangle gain** — the family recognition. A DC signal of value `A` under the tremolo yields `y[k] = A·g(k)/glide_scale` at every sample, matched directly against `triangle_delay_at`. This shows the LFO drives amplitude the same way it drove delay.
2. **A hand-computed whole-anchor case** — centre `scale/2`, depth `scale/2`, period `4`: the gain traces `½ → 1 → ½ → 0 → …` on the four quarter anchors, so a steady `1000` becomes `500, 1000, 500, 0, 500, 1000`, computed by hand and matched exactly.
3. **A zero-depth tremolo is a constant-gain fader** — `depth = 0`: the LFO sits at rest, the gain is a fixed `centre`, so the output is a plain scaling `x·centre/scale`, equal to a fader set once.
4. **Unity passthrough is exact** — centre `scale`, depth `0`: the gain is one, so a full-scale sample (including `sample_min`) passes through byte-for-byte, proving the write's `saturate` is a documented no-op.
5. **The tremolo never exceeds the dry rail** — a loud steady signal under any legal gain stays within `[sample_min, sample_max]` and never wraps, because an attenuation of an in-range sample is in range (the invariant the `saturate` no-op documents).
6. **Every fault refuses by name** — `BadPeriod`, `BadDepth`, `BadGain`, `BadRange`, each leaving the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, siloed to `lotus/`. The gain is counted in scaled units (`256` = unity) and the period in samples, not in hertz — the real-time twin follows exactly as `echo_ms` and `multitap_ms` did. No delay line, no snapshot, no lookahead, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With amplitude modulation proven, **auto-pan** (the same LFO on the stereo field) and the **ring modulator** (a faster carrier on the same gain) become the family's next rungs on this new target.
