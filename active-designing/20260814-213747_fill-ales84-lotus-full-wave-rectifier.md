# Fill ALES84 — Lotus's full-wave rectifier: fold the wave at zero, the plainest even-harmonic generator

**Stamp:** `20260814.213747` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Design read — self-approved round (no custody gate; the DRIVE family closed whole at ALES83, and the plainest step beside it is the even-harmonic complement to its odd clippers — the rectifier)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES84**
**Kin:** [`../lotus/tube.rye`](../lotus/tube.rye) (ALES82 — coaxes even harmonics from an *uneven* clip; the rectifier makes them from the *purest* even map) · [`../lotus/fold.rye`](../lotus/fold.rye) (ALES80 — the wavefolder folds the excess *past a ceiling*; the rectifier folds the whole negative half *at zero*) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

The DRIVE family (ALES78–ALES83) is whole — the hard clip, overdrive, wavefolder, bit-crush, tube, and decimator shape a wave by clipping, quantizing, or holding it. Three of those are **odd** maps (they shape the magnitude and carry the sign), so they make only odd harmonics; the tube coaxes even harmonics from an *uneven* clip. The plainest even-harmonic generator is simpler than any of them: **take the absolute value.** A full-wave rectifier folds the whole negative half of the wave up onto the positive side, turning a symmetric wave into a one-sided, DC-heavy signal at **double** the frequency — the diode bridge of a power supply, the octave-up fuzz of a guitar pedal, a signal made entirely of even harmonics and a DC term. Lindy-first, rectification is the oldest even-harmonic move in analog electronics; crux-first, the decisive recognition is that **`|−x| = |x|` is the purest even map there is, and the only place it is not exact in i16 is the single most-negative sample.**

## The crux — `|x|`, exact everywhere but one sample

`y = |x|` is exact for every i16 except `sample_min = −32768`, whose true magnitude `32768` overflows the positive rail (`sample_max = 32767`). Rather than wrap — the one place `|x|` would leave the rail — the rectifier **saturates** that lone sample to `sample_max`, the same honest ceiling every Lotus edit owes so loud never wraps to quiet:

```
mag = if x < 0 then −x else x          // in i64, so −sample_min = +32768 never overflows
y   = saturate(mag)                     // pins the one over-rail value (32768) to sample_max; every other |x| passes
```

Stated positively, the rectifier is **`|x|` pinned to the rail** — exact everywhere the rail can hold the magnitude, one unit shy at the single sample it cannot. The map is **memoryless** (every output depends only on its own input), **idempotent** (a non-negative sample rectifies to itself, so `rectify(rectify(x)) = rectify(x)`), and its output is always **non-negative** — the one-sided signal is the rectifier's whole point.

## Shape

`lotus/rectify.rye` offers `rectify(clip, start, count)` — it folds each sample in `[start, count)` to its absolute value. It takes **no gain, no ceiling, no resolution** — an absolute value has no parameter that could be illegal — so it names exactly one fault:

- `BadRange` — a span outside the current samples (the suite's shared span law).

A keeper who wants a boosted or half-wave rectification composes this with ALES78's `drive` over the same span, both in-place span maps that compose.

## The laws to prove

1. **Non-negatives are unchanged** — `|x| = x` for every `x ≥ 0`; a one-sided signal rectifies to itself.
2. **Negatives fold to their magnitude** — `−1→1`, `−100→100`, `−12345→12345`, `−32767→32767`, read by hand.
3. **The rail edge** — `|sample_min| = 32768` saturates to `sample_max`, the one sample `|x|` cannot hold.
4. **Every output is non-negative, and the map is idempotent** — no output below zero; a second rectify changes nothing.
5. **The even-harmonic signature** — `+a` and `−a` both map to `a`, folding the two halves onto one side (the doubling that is the rectifier's even voice).
6. **The span discipline holds** — only `[start, count)` changes; samples outside are untouched.
7. **A span past the end refuses `BadRange`** — before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The shape is a full-wave absolute value, instantaneous — no attack/release, no anti-aliasing (a rectifier doubles frequency and is a heavy even-harmonic generator, and its harmonics fold in the i16 domain exactly as any diode rectifier's). One negate-and-pin per sample. No delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The rectifier opens the **even family** beside the DRIVE clippers — the plainest even-harmonic generator. Its plain sibling is the **half-wave rectifier** (keep the positive half, zero the negative — an even+odd mix rather than pure even), the next rung this family names. Beyond the pair, the loop names its own next Lotus crux as its own self-approved design round.

## Witness

`tools/ales_rectify_witness.rish` — builds `lotus/rectify.rye`, runs its selftest, and asserts the single `GREEN ales-rectify` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_rectify_witness.rish
```
