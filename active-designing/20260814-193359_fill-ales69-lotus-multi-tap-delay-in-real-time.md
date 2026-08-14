# Fill ALES69 — Lotus's multi-tap delay in real time: taps named in milliseconds

**Stamp:** `20260814.193359` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the ALES68 multi-tap given the ALES5 clock's units, exactly as `echo_ms` gave the feedback echo real time)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES69**
**Kin:** [`../lotus/taps.rye`](../lotus/taps.rye) (ALES68 — the multi-tap delay this speaks in real time) · [`../lotus/echo_time.rye`](../lotus/echo_time.rye) (ALES67 — the timed twin this mirrors) · [`../lotus/clock.rye`](../lotus/clock.rye) (ALES5 — the sample clock)

---

## Why this rung

ALES68 opened the multi-tap delay, yet each tap's delay is a count of sample **indices** — "a tap 4800 samples later." A musician names an early reflection in **time** — "a tap a tenth of a second later." The one missing fact is the sample rate, and ALES5's validated `Clock` holds it. Every index-named rung has earned its real-time twin this way: `fade_ms` over the fade, `place_at` in seconds, `marker_time` over the markers, and — one rung ago — `echo_ms` over the feedback echo. This rung gives the multi-tap the same face, mirroring `echo_ms` exactly.

Lindy-first, real-time thinking is what a keeper carries across every session and tool; crux-first, the decisive, tractable move is the composition that lands the **exact same audio** as the proven index-named multi-tap, only spoken in the units the ear uses — a small, high-confidence twin rather than the larger fractional-delay primitive the modulated delay will want.

## The crux — the clock adds only the units, never the audio

`multitap_ms` converts `start_ms`, `count_ms`, and each tap's `delay_ms` through ALES5's proven `clock.samples_for` (bounded, refusing `DurationTooLong` past the clip) into an index-named `Tap` set, then delegates to ALES68's `multitap` **unchanged**. The grounding law is the family's signature: **the millisecond-named multi-tap lands byte-for-byte the same samples as the index-named multi-tap over the converted delays and span.** Because `samples_for` is `@divTrunc(rate·ms, 1000)`, a tap delay too short to be one whole sample converts to `0`, which ALES68 already refuses `BadDelay` — so a sub-sample tap refuses honestly rather than silently doing nothing.

## Shape

`lotus/multitap_time.rye` offers `multitap_ms(clip, clock, start_ms, count_ms, taps_ms)` over a bounded slice of `TapMs = struct { delay_ms: u32, num: u32, den: u32 }`. It checks the count against `taps.max_taps` first (`BadTapCount` before any conversion), converts each `TapMs` into a `Tap` in a bounded stack buffer, and delegates. The fault set is `clock.ClockError || taps.TapError`, every edge forwarded unchanged: `DurationTooLong` from the clock, and `BadTapCount` / `BadDelay` / `BadLevel` / `BadRange` from the multi-tap. No new arithmetic on the audio path — the clock's own conversion, then the proven multi-tap.

## The laws to prove

1. **The clock adds only units** — at a legible clock (1 sample per ms) a multi-tap named in ms lands byte-for-byte the same samples as the index-named multi-tap over the converted delays and span (both tools run).
2. **A real-rate clock converts honestly** — at 48 kHz a tap delay in ms converts to `@divTrunc(48000·ms, 1000)` samples and lands there.
3. **Two timed taps are two independent copies** — the ALES68 independence carried into real time (an impulse's two timed taps land two distinct copies, neither feeding the other).
4. **A sub-sample tap refuses `BadDelay`** — a `delay_ms` that converts to zero samples is refused, not silently ignored.
5. **A span or delay past the clip refuses `DurationTooLong`** — the clock's own bound, before any write.
6. **The multi-tap's faults forward** — `BadTapCount` on zero or too many taps, `BadLevel` on a tap above unity or a zero denominator, `BadRange` on a span past the samples.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM in one clip, a validated clock, and a bounded timed-tap slice, siloed to `lotus/`. The clock is a samples-per-second count, not a claim about any hardware clock; each tap gain is a plain fraction. No lookahead beyond ALES68's snapshot read, no socket, no network, no keys, no funds, no real device. No custody gate is touched. With the multi-tap nameable in milliseconds, the modulated delay (chorus, flanger — whose tap position *moves* and wants fractional-delay interpolation) is the next genuinely new primitive, itself nameable in milliseconds from here.
