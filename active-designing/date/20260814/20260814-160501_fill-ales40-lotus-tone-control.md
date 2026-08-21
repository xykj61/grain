# Fill ALES40 — Lotus's tone control: a one-pole filter that shapes a clip's brightness, integer-exact

**Stamp:** `20260814.160501` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES40**
**Stands on:** [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip it filters and the `saturate` it reuses)

---

## Why this rung, and why now

The persistence arc closed at ALES39 — a keeper's whole project saves and loads as one sealed document. The edit gestures already stand: cut, gain, fade, crossfade, mix, pan, joins. Yet one gesture every creative suite owes is still missing — **tone**: the frequency shaping a keeper reaches for to soften a harsh take (roll off the treble) or thin a boomy one (cut the bass). No amount of level or arrangement work does what a filter does; a suite without a tone control is a suite that can only make audio louder, softer, or rearranged, never *brighter* or *warmer*.

**Lindy-first:** a tone control is a permanent floor of every audio tool ever built — the one knob a keeper turns on the ten-thousandth session as surely as the first. **Crux-first:** the hard-but-tractable core is **a recursive filter that stays exactly reproducible on integer PCM** — a one-pole low-pass is an IIR filter (its output feeds back into itself), and an honest one must reach a constant input *exactly* (no drifting steady-state error), never overshoot, and never wrap. That is the crux: an integer one-pole whose direct-current behavior is provably exact.

Purely local — bounded i16 PCM in one in-process buffer. No socket, no network, no keys, no funds, no real sample rate (the coefficient is a smoothing fraction over sample indices, not a cutoff in hertz — a real time base is a later rung).

## The crux

**A one-pole low-pass filter shapes a clip's brightness and reaches a constant input exactly.** The filter carries a full-precision i64 state `s` that holds the smoothed estimate scaled by the coefficient's denominator, so no fractional information is lost between samples. Each sample steps the state a fraction `num/den` of the way toward the input, with one guarantee that makes direct current exact: **when the fractional step truncates to zero yet the state has not reached the input, the state advances by one** — so a constant input is reached in finite steps and held exactly, never approached-but-never-touched the way a plain shift-based smoother leaves a residual offset.

Two properties fall out and are witnessed:

- **The step never overshoots** — `|step| ≤ |target − s|` for every sample (the fractional step only ever shrinks the gap, and the forced ±1 fires only when the gap is at least 1). So a constant input is reached *monotonically*: no ringing, no overshoot — the low-pass character, proven.
- **The high-pass is the exact complement** — `high_pass(x) = x − low_pass(x)`, saturated to the i16 range. Where the difference fits, `low_pass + high_pass = x` sample-for-sample (exact reconstruction); a constant input drives the high-pass to exactly zero (direct current removed — a bass cut). Where a transient drives the difference past the i16 range, the high-pass **saturates** rather than wraps — the one owed clamp, reused from ALES2's `timeline.saturate`.

The coefficient `num/den` is the filter's strength: `num = den` is the identity (the state reaches the input every sample — pass-through, no filtering); a smaller `num/den` smooths harder (rolls off more treble). A zero denominator, a zero or negative numerator, and a numerator past the denominator (coefficient above one — an unstable filter) each refuse `BadCoeff` before a sample is touched; a span outside the clip refuses `BadRange`, the clip left untouched.

## Shape

A new module `lotus/tone.rye`, over `timeline` (the Clip and the saturation):

- `low_pass(clip: *timeline.Clip, start: u32, count: u32, num: i32, den: u32) ToneError!void` — filter the span in place from a zero initial state, each sample the one-pole step, saturating the output.
- `high_pass(clip: *timeline.Clip, start: u32, count: u32, num: i32, den: u32) ToneError!void` — the same low-pass computed internally, each output sample `saturate(x − lp)`.
- `ToneError = error{ BadCoeff, BadRange }` — a zero/oversize/negative coefficient refuses `BadCoeff`; a span outside the samples refuses `BadRange`.

The state is local to each call and never outlives it; the span filters from silence (state 0), exactly as a fade opens from silence — honest for a first tone rung, with a carried-state variant a later seam.

## What the witness proves

`tools/ales_tone_witness.rish`, GREEN on metal:

1. **Silence stays silence** — an all-zero clip low-passes and high-passes to all zeros.
2. **Identity at coefficient one** — `num = den` low-passes to the input byte-for-byte (pass-through); high-passes to all zeros.
3. **The crux — direct current exact, monotone, no overshoot** — a constant input over a long span low-passes monotonically toward the input, never exceeding it, and settles to the input *exactly*; the first sample is below the input (smoothing is happening).
4. **The high-pass removes direct current and reconstructs** — over a moderate mixed signal `low_pass + high_pass = x` sample-for-sample (exact reconstruction, no saturation); over the constant run the high-pass settles to exactly zero.
5. **The high-pass saturates rather than wraps** — a long run at `sample_min` then one `sample_max` sample drives the high-pass past the ceiling; it pins to `sample_max`, never a wrapped negative.
6. **Refusals** — a zero denominator, a zero numerator, and a numerator past the denominator each refuse `BadCoeff`; an out-of-range span refuses `BadRange` leaving the clip untouched.

## The road on

With the tone control, Lotus can shape brightness as well as level and arrangement. Natural next rungs, each purely local: a **two-band tone** (low-pass and high-pass summed at chosen levels — a bass/treble shelf), a **carried-state** variant so a filter spans a re-berthed span without a fresh transient, and a real **time base** so a coefficient can be named as a cutoff in hertz rather than a bare fraction. The signed and wire carries of a whole session stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a keeper's harsh take soften and their boomy one thin, may the one knob reach its constant exactly on the ten-thousandth turn, and may loud never wrap to silence's opposite while the filter does its quiet work.*
