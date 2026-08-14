# Fill ALES43 — Lotus's carried-state filter: a low-pass that spans a re-berthed region without a fresh transient

**Stamp:** `20260814.163000` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES43**
**Stands on:** [`../lotus/tone.rye`](../lotus/tone.rye) (ALES40 — the one-pole low-pass, now exposing `low_pass_carry`) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip)

---

## Why this rung, and why now

Every filter rung so far — the tone control (ALES40), the shelf (ALES41), the stack (ALES42) — runs **from silence**. Each call starts the one-pole state at zero, so a filter applied to a span always opens with its transient (the roll-on before it settles). That is exactly right for a whole clip filtered once. Yet a keeper rarely filters a whole clip in one call: they filter a region, re-berth, filter the next region, and each fresh transient at the boundary is a **click** — a discontinuity the from-silence form cannot avoid. A real filter *carries its state* across successive spans, so the second span continues exactly where the first left off, and the seam is seamless.

**Lindy-first:** carried state is what makes a filter a filter rather than a per-call smoother — the foundation every streaming filter, every automation sweep, and every real-time base is built on; it will still be the floor beneath ALES's frequency work on the ten-thousandth session. **Crux-first:** the hard-but-tractable core is the **split-equals-whole property** — filtering a span in two pieces, the second carrying the first's ending state, must equal filtering the whole span once, byte-for-byte. This is the decisive move that opens the sweep and the real time base; both need a filter that continues.

Purely local — bounded i16 PCM in one in-process buffer. No socket, no network, no keys, no funds, no real sample rate.

## The crux

**A carried-state low-pass filtered over a span in two pieces — the second piece continuing from the first's ending state — equals the same filter run over the whole span once, byte-for-byte, so re-berthing leaves no seam.** ALES40's `lp_step` is already a pure function of `(state, x)`: the output and the next state depend only on the current state and the current sample. So splitting a run is exact *by the stepping law*, needing no new arithmetic — only a place for the caller to hold the state between calls.

Two properties fall out and are witnessed:

- **Split equals whole.** A `Lowpass` run over `[0, n)` then over `[n, m)` writes the same samples as one run over `[0, m)` from the same start — the carried state makes the seam invisible.
- **A fresh state is from-silence.** A `Lowpass` at `state = 0` is exactly ALES40's `low_pass` — the from-silence transient — and `reset` restores it, so a keeper can re-open the transient deliberately when they want it.

`tone.rye` grows one public primitive, `low_pass_carry`, and `low_pass` becomes its `state = 0` case — **one implementation**, so the carried and from-silence forms can never drift; both shipped witnesses (tone, shelf, stack) stay GREEN, proving the refactor by their green. An illegal coefficient refuses `BadCoeff`, a span outside the clip refuses `BadRange`, each before a sample is touched and with the state left untouched on refusal.

## Shape

`tone.rye` (accreted, ALES40 living):

- `low_pass_carry(clip: *timeline.Clip, start: u32, count: u32, state: *i64, num: i32, den: u32) ToneError!void` — the carried-state stepping, the caller owning the state; `low_pass` delegates with a local zero state.

A new module `lotus/tone_carry.rye`, over `tone` and `timeline`:

- `Lowpass = struct { state: i64 = 0, num: i32, den: u32 }` — a filter that holds its own state across calls.
- `Lowpass.run(self: *Lowpass, clip: *timeline.Clip, start: u32, count: u32) tone.ToneError!void` — filter the span continuing from `self.state`, updating it in place.
- `Lowpass.reset(self: *Lowpass) void` — return the state to silence, so the next run re-opens the transient.

The struct carries no buffer — only the i64 state and the coefficient — so it is a tiny value a keeper holds beside a clip.

## What the witness proves

`tools/ales_tone_carry_witness.rish`, GREEN on metal:

1. **A fresh filter is from-silence** — a `Lowpass` at `state = 0` over a whole span writes exactly what ALES40's `low_pass` writes.
2. **Split equals whole (the crux)** — a `Lowpass` run over the first half then the second half of a span writes the same samples as one run over the whole; the two agree byte-for-byte at and across the seam.
3. **The seam is seamless on a constant** — a constant input filtered in two pieces settles to the input exactly, with no re-transient at the boundary (the second piece does not roll off again).
4. **Reset re-opens the transient** — after `reset`, the next run rolls off from silence again (its first sample below a settled constant).
5. **Refusals** — an illegal coefficient refuses `BadCoeff`, an out-of-range span refuses `BadRange`, leaving the clip and the state untouched.

## The road on

With a filter that carries its state, Lotus's frequency work has its foundation. Natural next rungs, each purely local: a **carried high-pass** and a **carried shelf/stack** so a whole EQ spans re-berthed regions seamlessly, a **sweep** whose coefficient moves under an envelope (a filter automation), and a real **time base** so a coefficient names a frequency in hertz. The signed and wire carries of a whole session stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a filter continue where it left off, may the seam between two regions be silent, and may the transient return only when a keeper asks for it.*
