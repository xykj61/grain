# Fill ALES67 — Lotus's echo in real time: a delay named in milliseconds

**Stamp:** `20260814.191951` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the ALES66 echo given the ALES5 clock's units, exactly as `fade_ms` gave the fade real time)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES67**
**Kin:** [`../lotus/echo.rye`](../lotus/echo.rye) (ALES66 — the feedback delay this speaks in real time) · [`../lotus/clock.rye`](../lotus/clock.rye) (ALES5 — the sample clock, its `fade_ms` / `place_at` the payoff pattern) · [`../lotus/marker_time.rye`](../lotus/marker_time.rye) (ALES21 — the timed twin of a base rung, the module shape this follows)

---

## Why this rung

ALES66 opened the time-based wing, yet its delay is a count of sample **indices** — "echo every 12000 samples." A musician does not think in samples; they think in **time** — "an echo an eighth of a second later." The one missing fact is the **sample rate**, and the tree already has a validated `Clock` that holds it (ALES5). Every rung named in samples has earned its real-time twin this way: `fade_ms` followed the index-named fade, `place_at` aligned clips in seconds, `marker_time` gave the markers track a face in milliseconds. This rung gives the echo the same face.

Lindy-first, real-time thinking is what a keeper carries across every session and every tool; crux-first, the tractable-and-decisive move is the composition that lands the **exact same audio** as the proven index-named echo, only spoken in the units the ear uses.

## The crux — the clock adds only the units, never the audio

`echo_ms` converts `start_ms`, `count_ms`, and `delay_ms` through ALES5's proven `clock.samples_for` (bounded, refusing `DurationTooLong` past the clip) and delegates to ALES66's `echo` **unchanged**. The grounding law is the family's signature: **the millisecond-named echo lands byte-for-byte the same samples as the index-named echo over the converted delay and span** — the clock changes only the units. Because `samples_for` is `@divTrunc(rate·ms, 1000)`, a delay too short to be one whole sample converts to `0`, which ALES66 already refuses `BadDelay` — so a sub-sample echo refuses honestly rather than silently doing nothing.

## Shape

`lotus/echo_time.rye` offers `echo_ms(clip, clock, start_ms, count_ms, delay_ms, fb_num, fb_den)`, a thin twin over ALES66 exactly as `marker_time` is over ALES20. The fault set is `clock.ClockError || echo.EchoError`, every edge forwarded unchanged: `DurationTooLong` from the clock (a span or delay past the clip), and `BadDelay` / `BadFeedback` / `BadRange` from the echo (the converted delay being zero among them). No new arithmetic on the audio path — the clock's own conversion, then the proven echo.

## The laws to prove

1. **The clock adds only units** — at a legible clock (1 sample per ms) an echo named in ms lands byte-for-byte the same samples as the index-named echo over the converted delay and span (both tools run).
2. **A real-rate clock converts honestly** — at 48 kHz a delay in ms converts to `@divTrunc(48000·ms, 1000)` samples and the echo lands over exactly that delay.
3. **`fb = 0` is the dry identity** — in real time too.
4. **A sub-sample delay refuses `BadDelay`** — a `delay_ms` that converts to zero samples is refused, not silently ignored.
5. **A span or delay past the clip refuses `DurationTooLong`** — the clock's own bound, before any write.
6. **The echo's faults forward** — `BadFeedback` on an at-or-above-unity or zero-denominator feedback, `BadRange` on a span past the samples.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip and a validated clock, siloed to `lotus/`. The clock is a samples-per-second count, not a claim about any hardware clock; the feedback is a plain fraction. No lookahead beyond the in-place delay read, no socket, no network, no keys, no funds, no real device. No custody gate is touched. With a real time base under the echo, the modulated delay (chorus, flanger) and the multi-tap forms follow as later rungs, each nameable in milliseconds from here.
