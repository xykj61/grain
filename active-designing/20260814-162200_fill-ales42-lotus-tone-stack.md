# Fill ALES42 — Lotus's three-band tone stack: bass, mid, and treble from two splits

**Stamp:** `20260814.162200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES42**
**Stands on:** [`../lotus/shelf.rye`](../lotus/shelf.rye) (ALES41 — the two-band scale-and-clamp it widens) · [`../lotus/tone.rye`](../lotus/tone.rye) (ALES40 — the one-pole low-pass/high-pass split) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and `saturate`)

---

## Why this rung, and why now

ALES41 gave Lotus two knobs — bass and treble — by scaling ALES40's low band and its exact high-band complement. Yet the tone stack a keeper reaches for on a guitar amp, a mixing desk, or an everyday audio app has **three** knobs: bass, **mid**, and treble. The middle band is the one a two-band shelf cannot touch — the vocal presence, the snare crack, the body of a take. This rung opens it.

**Lindy-first:** the three-band tone stack is the oldest and most-used equalizer shape there is — bass · mid · treble is on the front panel of nearly every amplifier and console ever built, the control a keeper turns on the ten-thousandth session. **Crux-first:** the hard-but-tractable core is the **mid band as an exact residual** — `M = x − L − H`, defined so the three bands sum to the input by construction, then each scaled in the wide domain and clamped once (ALES41's lesson, itself ALES8's). Reconstruction is not approximated; it is guaranteed by the definition of the mid band.

Purely local — bounded i16 PCM in one in-process buffer. No socket, no network, no keys, no funds, no real sample rate.

## The crux

**A three-band stack scales the low band, the mid band, and the high band independently and clamps once, so unity on all three is the identity, and only bass moves direct current.** For each sample the stack computes the low-pass output `L` at the bass crossover (ALES40 on a scratch copy), the high-pass output `H` at the treble crossover (ALES40 on a second scratch copy), the mid band `M = x − L − H` (the exact residual), and writes `saturate( bass·L/bass_den + mid·M/mid_den + treble·H/treble_den )` — each band divided in i64, the three summed in i64, the single clamp over the true sum.

Three properties fall out and are witnessed:

- **Unity is identity.** With all three gains one, the stack writes `L + M + H = L + (x − L − H) + H = x` exactly — a flat three-band EQ passes the audio through untouched. Reconstruction holds *by construction*, at any two crossovers, even if a band saturated: the mid is defined as the residual, so the three always sum back to `x`.
- **The knobs are orthogonal at direct current.** A settled constant has `L = x` exactly (ALES40's proven direct-current reach) and `H = 0` exactly (its proven removal), so `M = x − x − 0 = 0`. **Neither mid nor treble can move a constant** — only bass scales direct current. Bass owns the low end; mid and treble reach only what changes.
- **A boost saturates rather than wraps.** A loud constant at `bass = 2/1` whose doubled value exceeds the i16 range pins to `sample_max`, the wide-domain scale clamped once.

Each crossover `lo_num/lo_den`, `hi_num/hi_den` is validated as ALES40's own coefficient (a fraction in (0, 1]); an illegal one refuses `BadCoeff`; a zero band denominator refuses `BadGain`; a span outside the clip refuses `BadRange` — each before a sample is touched, the clip untouched on refusal.

## Shape

A new module `lotus/stack.rye`, over `tone` and `timeline`:

- `stack(clip: *timeline.Clip, start: u32, count: u32, lo_num: i32, lo_den: u32, hi_num: i32, hi_den: u32, bass_num: i32, bass_den: u32, mid_num: i32, mid_den: u32, treble_num: i32, treble_den: u32) StackError!void` — validate the two crossovers, the three gains, and the span; copy the span into two scratch Clips, low-pass one at the bass crossover and high-pass the other at the treble crossover (ALES40); then for each sample write the wide-domain sum of the three scaled bands, saturated once.
- `StackError = tone.ToneError || error{ BadGain }` — the filter's `BadCoeff`/`BadRange` reused whole, plus `BadGain` for a zero band denominator (shelf's own fault, reused).

Each scratch Clip is local to the call and never outlives it; both filters run from silence exactly as ALES40, so the stack inherits the filter's proven transient and its exact direct current.

## What the witness proves

`tools/ales_stack_witness.rish`, GREEN on metal:

1. **Silence stays silence** — an all-zero clip stacks to all zeros at any gains.
2. **Unity is identity** — all three gains `1/1` writes the input byte-for-byte (the bands reconstruct), at any two crossovers.
3. **Bass moves direct current** — a settled constant at `bass = 2/1`, mid and treble `1/1` doubles the constant's tail; the first sample differs (the filter transient), the settled tail is exactly twice the input.
4. **Mid does not move direct current** — the same constant at `mid = 5/1`, bass and treble `1/1` leaves the settled tail exactly the input (the mid band is zero at direct current).
5. **Treble does not move direct current** — the same constant at `treble = 5/1` leaves the settled tail exactly the input (the high band is zero at direct current — the knobs are orthogonal).
6. **A boost saturates rather than wraps** — a loud constant at `bass = 2/1` whose doubled value exceeds the i16 range pins to `sample_max`, never a wrapped negative.
7. **Refusals** — an illegal low or high crossover refuses `BadCoeff`, a zero bass, mid, or treble denominator refuses `BadGain`, an out-of-range span refuses `BadRange` leaving the clip untouched.

## The road on

With bass, mid, and treble, Lotus shapes tone the way every console names it. Natural next rungs, each purely local: a **carried-state** filter so a stack spans a re-berthed region without a fresh transient, a **sweepable** mid whose crossovers move under an envelope (a parametric band), and a real **time base** so a crossover names a frequency in hertz. The signed and wire carries of a whole session stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a keeper find the body of a take with the third knob, may flat stay truly flat across all three bands, and may the mid reach only what moves — never the still low end that bass alone should hold.*
