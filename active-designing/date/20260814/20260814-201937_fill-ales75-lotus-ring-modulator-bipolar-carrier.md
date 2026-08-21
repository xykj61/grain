# Fill ALES75 — Lotus's ring modulator: the tremolo's carrier let cross zero

**Stamp:** `20260814.201937` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the tremolo's named sibling — the same triangle carrier, allowed to go bipolar)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES75**
**Kin:** [`../lotus/tremolo.rye`](../lotus/tremolo.rye) (ALES74 — the amplitude write this generalizes by removing the floor) · [`../lotus/chorus.rye`](../lotus/chorus.rye) (ALES71 — the triangle-LFO driver `triangle_delay_at`, now the carrier) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and the one true saturate)

---

## Why this rung

ALES74's tremolo pointed the triangle LFO at the sample's amplitude and held the result to an **attenuation** — a gain kept between silence and unity, so the modulated voice was never louder than the dry and the `saturate` on the write was a proven no-op. The tremolo's own closing line named the two rungs that follow it on this new target: **auto-pan** (the same LFO on the stereo field) and the **ring modulator** (a faster carrier on the same gain). The ring modulator is the nearer of the two, and it is the tremolo with **one restriction lifted**: the carrier is allowed to **cross zero** and go negative.

A carrier that dips below zero flips the sample's sign; swung fast, it multiplies the signal by a bipolar wave and scatters the spectrum into metallic sum-and-difference tones — the ring modulator's unmistakable clang. Lindy-first, the amplitude-LFO path is already the durable primitive (ALES74); this rung only widens the carrier's legal range. Crux-first, the decisive recognition is the family identity in the other direction: **a ring modulator whose carrier never goes negative is exactly the tremolo** — so the two rungs are one multiply, the carrier's sign the only difference.

## The crux — the carrier let cross zero, and the one corner it touches

The ring modulator reuses ALES71's `triangle_delay_at` as the carrier and writes, exactly as the tremolo does, `y[i] = saturate(x[i]·c(i)/glide_scale)`. The one change is the legal range of `c`: where the tremolo required `0 ≤ c ≤ glide_scale` (an attenuation), the ring modulator requires only `−glide_scale ≤ c ≤ glide_scale` (a unit-bounded **bipolar** carrier). The floor at silence is gone; the magnitude bound at unity stays, so the voice is still never louder than the dry.

There is one honest subtlety the tremolo never met. The two's-complement `i16` rail is asymmetric — `sample_min = −32768`, `sample_max = 32767` — so **inverting `sample_min` overflows by exactly one**: `−(−32768) = 32768`, one past `sample_max`. The tremolo's non-negative gain could never invert a sample, so its `saturate` was a proven no-op; the ring modulator's carrier at `−unity` on a full-negative sample lands `32768`, and the one true `saturate` **genuinely earns its keep**, clamping that lone corner to `32767` rather than wrapping. So `x·c/scale` sits in `[−32768, 32768]`, and the write saturates the single overflowing point honestly — this is the ring modulator's real distinction from the tremolo, not a restatement of it.

Every output still depends only on **its own** input sample, so the ring modulator writes **in place with no snapshot**, the thinnest-rung discipline the tremolo established.

## Shape

`lotus/ring_mod.rye` offers `ring_mod(clip, start, count, centre_scaled, depth_scaled, period)` — the tremolo's signature exactly, the carrier now bipolar. It reads `chorus.triangle_delay_at` and `glide.glide_scale` over their public APIs. Faults, each refused before any write with the clip untouched:

- `BadPeriod` — a period that is not a positive multiple of four, or wider than `max_clip`.
- `BadDepth` — a negative depth (a swing has a magnitude, never a sign).
- `BadCarrier` — a swing whose magnitude passes unity in either direction (`centre + depth > glide_scale` or `centre − depth < −glide_scale`); past that the voice could exceed the rail by more than the lone two's-complement corner.
- `BadRange` — a span outside the current samples.

There is no `BadGain`, no `BadDelay`, and no `BadLevel` — the carrier is bipolar (so the tremolo's one-sided `BadGain` widens to the two-sided `BadCarrier`), there is no delay line, and the carrier **is** the level.

## The laws to prove

1. **A non-negative carrier is the tremolo** — the family identity. When `centre − depth ≥ 0` the carrier never goes negative, so `ring_mod(…)` equals `tremolo(…)` at every sample (both run), tying the two rungs into one multiply.
2. **A hand-computed bipolar case** — centre `0`, depth `scale`, period `4`: the carrier traces `0 → +1 → 0 → −1 → 0`, so a steady `1000` becomes `0, 1000, 0, −1000, 0, 1000` — the sign flip made visible.
3. **A constant carrier at −unity inverts the signal** — centre `−scale`, depth `0`: `y = −x` exactly, on a signal with no `sample_min` (where inversion is exact).
4. **Unity passthrough is exact** — centre `scale`, depth `0`: `y = x`, a full-scale sample passing through byte-for-byte.
5. **The lone two's-complement corner saturates, never wraps** — `sample_min` under a `−unity` carrier lands `sample_max` (`−(−32768) = 32768` clamped to `32767`), the one place the ring modulator's `saturate` does real work, and it does it without wrapping.
6. **Every fault refuses by name** — `BadPeriod`, `BadDepth`, `BadCarrier`, `BadRange`, each leaving the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, siloed to `lotus/`. The carrier is counted in scaled units (`256` = unity, and now `−256` = inverted unity) and the period in samples, not hertz — the real-time twin follows as the family's have. No delay line, no snapshot, no lookahead, no socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With the bipolar carrier proven, **auto-pan** (the same LFO on ALES10's stereo field) remains the family's next rung on the amplitude-and-position target.
