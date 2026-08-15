# Fill ALES73 — Lotus's flanger: a modulated delay with a feedback path

**Stamp:** `20260814.200314` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the modulated-delay family's rung that adds a genuinely new element — feedback — rather than only changing the mix)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES73**
**Kin:** [`../lotus/chorus.rye`](../lotus/chorus.rye) (ALES71 — the triangle-LFO driver `triangle_delay_at` this reuses) · [`../lotus/echo.rye`](../lotus/echo.rye) (ALES66 — the feedback delay whose in-place delay-line-is-the-buffer idiom this reuses, and which a zero-depth flanger equals byte-for-byte) · [`../lotus/glide.rye`](../lotus/glide.rye) (ALES70 — the fractional interpolation read) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and the one true saturate)

---

## Why this rung

The chorus (ALES71) and the vibrato (ALES72) both read a **modulated** delay off a **frozen snapshot** of the dry — precisely so a moving read never reads a sample it just wrote. The echo (ALES66) does the opposite: it reads the **live buffer**, so each output feeds the next and the train decays. The **flanger** is the rung where the two meet — a **short modulated delay** whose delayed voice is **fed back into itself**. The moving comb it makes, its notches sliding up and down the spectrum and deepened by the feedback, is the jet-plane whoosh a keeper reaches for by name.

It is the family's first rung that adds a **genuinely new element** rather than only changing the mix: the vibrato and chorus only chose what reached the output; the flanger adds a **feedback path**. Lindy-first, both halves are already proven — the triangle-LFO driver (ALES71) and fractional interpolation (ALES70) on one side, the in-place decaying feedback loop (ALES66) on the other. Crux-first, the one decisive move is to marry them safely: the modulated delay reads the **output** (feedback), not a frozen dry, and stays bounded and decaying exactly as the echo does.

## The crux — a modulated fractional delay read off the live output

The flanger reuses ALES71's `triangle_delay_at` driver and ALES70's interpolation read, and reuses ALES66's discipline that **the delay line is the clip buffer itself**:

```
d_s(k) = centre_scaled + triangle(depth_scaled, period, k)   (ALES71's driver, reused)
near   = buf[i − d_whole]        (a prior OUTPUT — feedback — or dry before the span, silence before the clip)
far    = buf[i − d_whole − 1]    (one sample further back, likewise)
delayed = ( near·(glide_scale − frac) + far·frac ) / glide_scale   (ALES70's read, reused)
y[i]    = saturate( x[i] + fb · delayed )                          (ALES66's feedback sum, reused)
```

Because the delay never dips below one whole sample (`centre − depth ≥ glide_scale`, so `d_whole ≥ 1`), both neighbours are at indices **strictly before `i`** — already written this pass (true feedback), or dry before the span, or silence before the clip. So the read is **off the live buffer, not a snapshot**: the flanger *wants* to hear its own output, and reading strictly-earlier indices keeps that safe in place. This is the exact inversion of the chorus/vibrato snapshot, and the reason the flanger needs none.

Two facts keep it bounded, both inherited from the echo. First, `delayed` is a convex combination of two `i16` neighbours (each an already-saturated output or dry audio), so it fits the rail with no snapshot and no separate delay buffer. Second, **feedback below unity decays and the sum saturates once**: `fb = num/den` with `num < den` is refused above that (`BadFeedback`, a runaway), so each fed term is strictly smaller than the output it read, and a constructive sum past the rail saturates through the one true `saturate` rather than wrapping. `fb = 0` is the dry identity.

## The reuse anchor — a zero-depth flanger is exactly the echo

When `depth = 0` the LFO sits at rest and the delay is a fixed whole `centre`; the interpolation returns the nearer sample exactly (`frac = 0`), so the flanger becomes `y[i] = saturate(x[i] + fb·buf[i − centre])` — **exactly ALES66's echo** at that delay, byte-for-byte (both tools run). The periodic modulated feedback delay reduces to the fixed feedback delay when it does not move, exactly as the zero-depth chorus reduced to the glide.

## Shape

`lotus/flanger.rye` offers `flanger(clip, start, count, centre_scaled, depth_scaled, period, fb_num, fb_den)` — the chorus's modulation parameters with the echo's feedback fraction in place of the wet mix. Faults: `BadPeriod` (a period that is not a positive multiple of four, or past `max_clip`), `BadDepth` (`centre − depth` under one whole sample), `BadDelay` (`centre + depth` whole past `max_clip`), `BadFeedback` (`num ≥ den` — a runaway — or `den == 0`), `BadRange` (a span past the samples) — each before any write, the clip untouched.

## The laws to prove

1. **`fb = 0` is the dry identity** — the feedback turned off, the dry passes byte-for-byte at any modulation.
2. **A zero-depth flanger is exactly the echo** — `depth = 0`: the flanger equals ALES66's `echo(centre, fb)` **byte-for-byte** (both tools run — the periodic driver reduces to the fixed one at rest), inheriting the echo's proven decay for the fixed case.
3. **A hand-computed modulated-feedback read** — a legible impulse and a period whose anchors put the delay on whole samples (`centre = 2·scale`, `depth = 1·scale`, `period = 4`, delays `2,3,2,1,2,3`), so each read is an exact integer *feedback* tap off the live buffer and a few outputs are computed by hand and matched exactly.
4. **A loud constructive sum saturates** — a loud in-phase feedback sum pins to `sample_max` rather than wrapping (the echo's safety, under the moving delay).
5. **Every fault refuses by name** — `BadPeriod`, `BadDepth`, `BadDelay`, `BadFeedback`, `BadRange`, each leaving the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, siloed to `lotus/`. The delay is counted in scaled sample indices and the period in samples, not milliseconds or hertz — the real-time twin follows exactly as `echo_ms` and `multitap_ms` did. No lookahead beyond the in-place feedback read; one delayed fractional read and one multiply-divide per sample, the sum in `i64` saturating once, so nothing on the path can overflow. No socket, no network, no keys, no funds, no real device, no real sample rate. No custody gate is touched. With the flanger proven, the family's remaining reach is the **reverb** — many delays and feedbacks composed into a dense tail — the last and largest rung of the time-based wing.
