# Fill ALES76 — Lotus's auto-pan: the same LFO swept across the stereo field

**Stamp:** `20260814.202856` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the modulation family's rung on the stereo field, the one both ALES74 and ALES75 named as next)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES76**
**Kin:** [`../lotus/pan.rye`](../lotus/pan.rye) (ALES10 — the linear pan and the `StereoClip` this sweeps in time) · [`../lotus/tremolo.rye`](../lotus/tremolo.rye) (ALES74 — the triangle LFO read as an attenuation, the same discipline here) · [`../lotus/chorus.rye`](../lotus/chorus.rye) (ALES71 — the triangle-LFO driver `triangle_delay_at`, now the pan position) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

The modulation family began by pointing ALES71's triangle LFO at a **delay** — the chorus (ALES71), the vibrato (ALES72), the flanger (ALES73). ALES74's tremolo turned that same triangle onto a genuinely new target, the sample's **amplitude**, and ALES75's ring modulator let its carrier cross zero. Both the tremolo and the ring modulator closed on the same named next rung: **auto-pan** — the same LFO on the **stereo field**. This rung is that one, and it is the last of the family's three targets (delay, amplitude, position) to open.

Lindy-first, ALES10's linear pan is already the durable primitive — one mono track split between the two speakers by weights that sum to one. Crux-first, the decisive recognition is a single sentence: **auto-pan is ALES10's linear pan swept across time** — position through the stereo field and position through a triangle period are one parameter, exactly as ALES12 recognized a crossfade to be an equal-power pan swept across an overlap. No new LFO, no new sum; only the pan position moves, sample by sample, on the same triangle that drove the delay and the gain.

## The crux — the moving pan, and the residual that makes the sum exact

ALES10's defining invariant is that **left + right reproduces the mono level exactly, for any pan position** — the property a linear (−6 dB-center) pan owes. ALES10 preserved that sum by folding each channel's weight into its own fader and rendering twice; two independent `@divTrunc` divisions preserve the sum only where the split falls on a whole sample. Auto-pan strengthens the invariant to hold **exactly at every sample, for every signal**, by computing the far channel as the **residual** of the near — the same residual move ALES42's tone stack used to make its mid band reconstruct exactly:

- the right channel is the near division: `right[i] = saturate(x[i]·pos(i)/glide_scale)`, `pos(i)` the triangle read as the right-hand weight (`0` = hard left, `glide_scale` = hard right);
- the left channel is the **residual**: `left[i] = saturate(x[i] − right[i])`, which is `x[i]·(glide_scale − pos(i))/glide_scale` computed so that `left[i] + right[i] == x[i]` **byte-for-byte**, never `x − 1`.

Because the position stays a **non-negative attenuation weight** — `0 ≤ pos ≤ glide_scale` — each channel is a fraction of the dry, so `|left|, |right| ≤ |x|` and both sit inside the i16 rail: the write's `saturate` is a proven **no-op**, exactly as the tremolo's was (auto-pan is the tremolo's non-negative kin, not the ring modulator's bipolar one — there is no sign flip and no two's-complement corner). Auto-pan reads the mono source and writes a fresh `StereoClip`; the source is **untouched**, a stereo-producing render rather than an in-place edit.

## Shape

`lotus/auto_pan.rye` offers `auto_pan(src, out, centre_scaled, depth_scaled, period)` — it pans the whole mono `src` Clip into `out`, an ALES10 `StereoClip`, reading `chorus.triangle_delay_at`, `glide.glide_scale`, and `pan.StereoClip` over their public APIs. It pans the whole clip (a stereo render), where the in-place tremolo family took a span, because the output is a new two-channel clip rather than an edit of the source. Faults, each refused before any write with `src` and `out` untouched:

- `BadPeriod` — a period that is not a positive multiple of four, or wider than `max_clip`.
- `BadDepth` — a negative depth, or a swing whose floor (`centre − depth`) falls past hard-left (below `0`) — a pan weight has no sign.
- `BadPan` — a swing whose top (`centre + depth`) rises past hard-right (above `glide_scale`) — the position stays within the field.

There is no `BadGain` (the field denominator is the fixed `glide_scale`, never a divide the caller supplies), no `BadDelay`, and no `BadRange` on a span (the whole clip is panned, and `out` shares the source's `max_clip` bound, so the render always fits — asserted, never a live error).

## The laws to prove

1. **The moving-pan sum invariant is EXACT** — for every sample under a full triangle swing, `left[i] + right[i] == src[i]` byte-for-byte, on a varied signal including `sample_min`. The residual construction makes ALES10's linear-pan invariant hold everywhere, not only where the split divides evenly. This is the crux.
2. **A hand-computed sweep** — centre `scale/2`, depth `scale/2`, period `4`: the position traces `128 → 256 → 128 → 0 → 128` (center → hard right → center → hard left), so a steady `1000` splits `right = [500, 1000, 500, 0, 500]`, `left = [500, 0, 500, 1000, 500]` — the sound swung across the field, made visible.
3. **A depth-0 auto-pan is a STATIC pan** — the LFO at rest holds one position: centre `scale/2` splits every sample equally (each side `floor(x/2)` and its residual), centre `0` routes the whole clip to the left (right silent), centre `scale` routes it wholly to the right (left silent).
4. **The source is read-only** — after `auto_pan`, `src` is unchanged: a stereo effect reads the mono, never mutates it.
5. **The auto-pan voice never exceeds the dry rail** — each channel is an attenuation of an in-range sample, so both stay within `[sample_min, sample_max]` and the write's `saturate` is a documented no-op.
6. **Every fault refuses by name** — `BadPeriod`, `BadDepth`, `BadPan`, each leaving `src` and `out` untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one mono clip rendered to a two-channel `StereoClip`, siloed to `lotus/`. The position is counted in scaled units (`0` = hard left, `256` = hard right) and the period in samples, not hertz — the real-time twin follows as the family's have. No delay line, no snapshot, no lookahead, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate. No custody gate is touched. With the LFO proven on all three targets — delay, amplitude, and now position — the modulation family's next reach is the **equal-power auto-pan** (ALES11's `power.split` swept in place of the linear weight, so the panned voice holds constant loudness as it crosses the field).
