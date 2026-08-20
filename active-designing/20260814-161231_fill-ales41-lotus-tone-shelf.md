# Fill ALES41 — Lotus's two-band tone shelf: bass and treble from the one-pole split

**Stamp:** `20260814.161231` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES41**
**Stands on:** [`../lotus/tone.rye`](../lotus/tone.rye) (ALES40 — the low-pass/high-pass split it scales) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip and `saturate`)

---

## Why this rung, and why now

ALES40 gave Lotus its first filter — a one-pole low-pass and its exact high-pass complement — yet a filter alone only *removes* a band. The tone control a keeper actually turns is two knobs: **bass** and **treble**, each *boosting or cutting* its band independently. The pieces are already proven: ALES40 splits any signal into a low band and a high band whose sum reconstructs the input exactly (`low_pass + high_pass = x`). A two-band shelf is that split, each band scaled by its own gain and summed — the everyday equalizer.

**Lindy-first:** bass and treble are the two controls on every amplifier, mixer, and audio app ever shipped — the shape a keeper reaches for to fit a take into a mix, turned on the ten-thousandth session. **Crux-first:** the hard-but-tractable core is **scaling the two bands in the wide domain and clamping once**, exactly the lesson ALES8's fader column proved — divide-then-sum-then-saturate, never saturate-then-sum, so a boost that would clip pins to the ceiling rather than wrapping, and unity on both bands reconstructs the input byte-for-byte.

Purely local — bounded i16 PCM in one in-process buffer. No socket, no network, no keys, no funds, no real sample rate.

## The crux

**A two-band shelf scales the low band and the high band independently and clamps once, so unity on both bands is the identity and a boost saturates rather than wraps.** For each sample the shelf computes the low-pass output `L` (via ALES40 on a scratch copy of the span), derives the high band `H = x − L`, and writes `saturate( bass·L/bass_den + treble·H/treble_den )` — each band divided in i64, the two summed in i64, the single clamp taken over the true sum.

Two properties fall out and are witnessed:

- **Unity is identity.** With `bass = bass_den` and `treble = treble_den` (both gains one), the shelf writes `L + H = L + (x − L) = x` exactly — a flat EQ passes the audio through untouched, the sharpest proof the bands reconstruct.
- **The knobs are orthogonal at direct current.** A settled constant input has `H = 0` exactly (ALES40's proven direct-current removal), so **treble cannot move a constant** — only bass scales direct current. A constant at `bass = 2` doubles; the same constant at any treble is unchanged. Bass moves the low end, treble the high end, and neither reaches across.

The filter coefficient `coeff_num/coeff_den` sets where the split falls (as in ALES40); a zero/negative/oversize coefficient refuses `BadCoeff`; a zero band denominator refuses `BadGain`; a span outside the clip refuses `BadRange` — each before a sample is touched, the clip untouched on refusal.

## Shape

A new module `lotus/shelf.rye`, over `tone` and `timeline`:

- `shelf(clip: *timeline.Clip, start: u32, count: u32, coeff_num: i32, coeff_den: u32, bass_num: i32, bass_den: u32, treble_num: i32, treble_den: u32) ShelfError!void` — validate every coefficient and the span; copy the span into a scratch Clip and low-pass it (ALES40); then for each sample write the wide-domain sum of the scaled bands, saturated once.
- `ShelfError = tone.ToneError || error{ BadGain }` — the filter's `BadCoeff`/`BadRange` reused whole, plus `BadGain` for a zero band denominator.

The scratch Clip is local to the call and never outlives it; the low-pass runs from silence exactly as ALES40, so the shelf inherits the filter's proven transient and its exact direct current.

## What the witness proves

`tools/ales_shelf_witness.rish`, GREEN on metal:

1. **Silence stays silence** — an all-zero clip shelves to all zeros at any gains.
2. **Unity is identity** — `bass = treble = 1/1` writes the input byte-for-byte (the bands reconstruct), at any coefficient.
3. **Bass moves direct current** — a settled constant at `bass = 2/1`, `treble = 1/1` doubles the constant's tail; the first sample differs (the filter transient), the settled tail is exactly twice the input.
4. **Treble does not move direct current** — the same constant at `bass = 1/1`, `treble = 5/1` leaves the settled tail exactly the input (the high band is zero at direct current — the knobs are orthogonal).
5. **A boost saturates rather than wraps** — a loud constant at `bass = 2/1` whose doubled value exceeds the i16 range pins to `sample_max`, never a wrapped negative.
6. **Refusals** — a zero/oversize/negative coefficient refuses `BadCoeff`, a zero bass or treble denominator refuses `BadGain`, an out-of-range span refuses `BadRange` leaving the clip untouched.

## The road on

With bass and treble, Lotus shapes tone the way a keeper thinks of it. Natural next rungs, each purely local: a **carried-state** filter so a shelf spans a re-berthed region without a fresh transient, a **mid band** (a third knob from a band-pass of the two poles), and a real **time base** so a coefficient names a crossover in hertz. The signed and wire carries of a whole session stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May a keeper's take find its place in the mix with two honest knobs, may flat stay truly flat, and may a boost meet the ceiling gracefully rather than wrap to its opposite.*
