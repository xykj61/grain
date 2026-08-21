# Fill ALES45 — Lotus's carried-state high-pass: the complement gains a memory too, so a whole split spans and sweeps

**Stamp:** `20260814.164244` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES45**
**Stands on:** [`../lotus/tone.rye`](../lotus/tone.rye) (ALES40 — `lp_step`, `high_pass`) · [`../lotus/tone_carry.rye`](../lotus/tone_carry.rye) (ALES43 — `Lowpass`) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip)

---

## Why this rung, and why now

ALES43 gave the low-pass a carried state, and ALES44 swept it. Yet the filter family is **asymmetric**: the high-pass — the exact complement that thins a boomy take — still runs only **from silence**. So a keeper can span a re-berthed region seamlessly, and sweep, with the low band, but not with the high band; a two-band shelf or a three-band stack cannot yet span or sweep because its high side has no memory. The complement deserves the same memory the low-pass already has.

**Lindy-first:** carrying the high-pass is the missing half of the filter foundation — once both bands carry, the whole split (and therefore the shelf and the stack) can span a re-berthed region and be swept, so this small move unlocks a whole branch of the frequency work. It will still be the floor beneath every carried or automated EQ on the ten-thousandth session. **Crux-first:** the hard-but-tractable core is exactly ALES43's split-equals-whole property, now for the complement — a high-pass filtered over a span in two pieces, the second carrying the first's ending state, equals the whole filtered once byte-for-byte. Because the high-pass output is `x − lp` and the low-pass state is a pure function of `(state, x)`, carrying that one state makes the complement continue too — no new arithmetic.

Purely local — bounded i16 PCM in one in-process buffer. No socket, no network, no keys, no funds, no real sample rate.

## The crux

**A carried-state high-pass filtered over a span in two pieces — the second continuing from the first's ending low-pass state — equals the same high-pass run over the whole span once, byte-for-byte, so re-berthing the high band leaves no seam.** ALES40's `high_pass` already computes `lp = lp_step(state, x)` per sample and writes `saturate(x − lp)`; it simply opens `state` at zero each call. Lifting that `state` to the caller makes the high-pass carry exactly as the low-pass does, and `high_pass` becomes the `state = 0` case of one `high_pass_carry` implementation — the from-silence and carried forms cannot drift.

Properties witnessed:

- **A fresh high-pass is from-silence.** A `Highpass` at `state = 0` equals ALES40's `high_pass` byte-for-byte.
- **Split equals whole (the crux).** A `Highpass` run over `[0, n)` then `[n, m)` equals one run over `[0, m)` — the seam invisible.
- **The complement law still holds under carry.** Run over the same span with the same carried schedule, `low_pass_carry + high_pass_carry = x` where the difference fits — the carried low and high bands still reconstruct the input.
- **Reset re-opens the transient**, so a keeper re-opens a fresh high-pass deliberately.
- **Refusals** — an illegal coefficient refuses `BadCoeff`, an out-of-range span `BadRange`, each before a write, the state and clip untouched on refusal.

## Shape

`tone.rye` (accreted, ALES40 living):

- `high_pass_carry(clip: *timeline.Clip, start: u32, count: u32, state: *i64, num: i32, den: u32) ToneError!void` — the carried-state complement, the caller owning the low-pass state; `high_pass` delegates with a local zero state.

`tone_carry.rye` (accreted beside ALES43's `Lowpass`):

- `Highpass = struct { state: i64 = 0, num: i32, den: u32 }` — a high-pass that holds its own state across calls.
- `Highpass.run(self, clip, start, count) tone.ToneError!void` — filter continuing from `self.state`.
- `Highpass.reset(self) void` — return the state to silence.

## What the witness proves

`tools/ales_carried_highpass_witness.rish`, GREEN on metal:

1. **A fresh high-pass is from-silence** — a `Highpass` at `state = 0` equals ALES40's `high_pass`.
2. **Split equals whole (the crux)** — two pieces with a carried state equal the whole.
3. **The carried complement reconstructs** — `low_pass_carry + high_pass_carry = x` over a mixed span where the difference fits.
4. **Reset re-opens** — after `reset`, the next run is from-silence again.
5. **Refusals** — `BadCoeff` and `BadRange`, the clip and state untouched.

The witness also re-runs the ALES40 tone and ALES43 carried-filter selftests, so the `high_pass_carry` refactor is proven by their green.

## The road on

With both bands carrying their state, Lotus's whole split can span a re-berthed region and be swept. Natural next rungs, each purely local: a **carried shelf/stack** so a whole EQ spans seamlessly, a **high-pass sweep** (ALES44's schedule over the carried high-pass), and the real **time base** so a crossover names a frequency in hertz. The signed and wire carries of a whole session stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May the high band remember as the low band does, may the two continue together where a keeper re-berths, and may the complement stay exact under every carry.*
