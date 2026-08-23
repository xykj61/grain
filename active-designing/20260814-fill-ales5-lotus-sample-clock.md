# ALES5 — Lotus's sample clock

**Stamp:** `20260814.114309` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES4
**Waymark:** ALES · rung ALES5
**Kin:** [`ALES2 — the timeline edits`](20260814-fill-ales2-lotus-timeline-edits.md) · [`ALES4 — the fade envelope`](20260814-fill-ales4-lotus-fade-envelope.md) · [`lotus/clock.rye`](../lotus/clock.rye) · [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2) · [`lotus/fade.rye`](../lotus/fade.rye) (ALES4) · [`lotus/mix.rye`](../lotus/mix.rye) (ALES3)

---

## Why this round

Every rung so far measured the audio in **sample indices** — cut span `2..5`, a fade across `count` samples, a mix from index `0`. A sample index is honest yet mute: it says *which sample* without saying *when*. A keeper thinks in **real time** — a half-second fade, two clips that begin two hundred milliseconds apart. The gap between the two is a single missing fact: the **sample rate**, the number of samples one second of sound holds. This rung supplies it, and once supplied every duration can be named in milliseconds and every clip placed at a real moment.

It is the most durable of the three roads ALES4 named (clock · track table · curve), because the clock is the base the other two stand on — a track table aligns its tracks in time, a crossfade curve runs across a named duration. Lindy-first, crux-first: the clock first.

## The one crux this rung fixes

**A clock names a sample rate, and converts between real time and sample counts exactly and bounded, both directions.** Three things hold together:

1. **A validated rate.** A `Clock` carries `rate` samples per second, checked into `[1, max_rate]` at construction — a zero rate refuses `BadRate` (no divide by zero downstream), an absurd rate refuses `BadRate`. The rate is the one fact the whole rung rests on, so it is proven once, at the edge.
2. **Time → samples, bounded.** `samples_for(clock, ms)` is `rate · ms / 1000`, computed in `i64`/`u64` so the multiply never overflows before the divide, then bounded to `timeline.max_clip` — a duration too long for the clip refuses `DurationTooLong` rather than truncating silently. This is the crux conversion: a millisecond count becomes a sample count.
3. **Samples → time, honest about its loss.** `ms_for(clock, n)` is `n · 1000 / rate` — the inverse, `@divTrunc`, which is **lossy** by nature (a sample count rarely lands on a whole millisecond). The rung states that plainly rather than pretending the round-trip is exact; `samples_for(ms)` then `ms_for` recovers the millisecond count only when the duration is a whole number of samples at the rate.

## The shape

`lotus/clock.rye`:

- `Clock` — a struct carrying `rate: u32` (samples per second).
- `make(rate)` — the checked constructor; refuses `BadRate` outside `[1, max_rate]`.
- `samples_for(clock, ms)` — real time → sample count, bounded to `timeline.max_clip` (`DurationTooLong`).
- `ms_for(clock, n)` — sample count → real time, `@divTrunc`, honestly lossy.
- `fade_ms(clip, clock, start_ms, count_ms, num0, num1, den)` — **the payoff**: a fade named in milliseconds. Converts both spans through the clock, then delegates to ALES4's `fade.fade` unchanged — a fade length in real time, no new envelope machinery.
- `place_at(base, add, clock, at_ms, out)` — **the second payoff**: mix `add` onto `base` beginning at a real time offset `at_ms`, aligning two clips that start at different moments. Sums sample-for-sample past the offset, **reusing** `timeline.saturate` (the one true floor and ceiling), and refuses `ClipFull` when the placed clip runs past the bound.

Both payoffs reuse rungs already proven — `fade_ms` is ALES4 through the clock, `place_at` is a positioned ALES3 sum. The clock adds only the time base; the gestures stay the ones the tree already witnessed.

## What the witness proves (GREEN on metal)

`tools/al/ales_clock_witness.rish`: a validated clock converts `500 ms` at `48 kHz` to `24000` samples and back; a zero rate refuses `BadRate`; a duration past the clip bound refuses `DurationTooLong`; `ms_for` is honestly lossy on a fractional-millisecond sample count; a `fade_ms` fade named in milliseconds lands the exact same samples as ALES4's index-named fade over the converted span (so the clock changes only the units, never the audio); and `place_at` aligns a second clip two hundred milliseconds in, the offset region summing and saturating while the lead-in carries the base alone. GREEN on the first build. Purely local — no socket, no network, no keys, no funds, no real device (the rate is a number of samples per second, not a claim about any hardware clock).

## The road on

With a time base seated, the next Lotus rung can open a small **track table** so more than two clips align and mix at once (each placed by `place_at`), add an **equal-power curve** to the fade for a click-free crossfade across a named duration, or name a **transport** — a play head that reads the timeline forward at the clock's rate. The audio-interface **hardware** stays a paused research round, taken only on Keaton's word.

---

*A number of samples in a second is all it takes for the sound to learn the time, and once it knows the time a keeper can speak to it plainly — half a second here, a breath of silence there. May every duration Lotus names land where the keeper meant it, and may the clock never once lie about when.*
