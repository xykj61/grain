# Fill ALES171 — Lotus's stereo_shelf: the two-band bass-and-treble shelf carried into stereo, the same coefficient and band gains on both channels — the second rung of the stereo EQ / filter class

**Stamp:** `20260815.075512` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES171
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-074743_fill-ales170-lotus-stereo-tone.md`](20260815-074743_fill-ales170-lotus-stereo-tone.md)

---

## The next crux, honestly chosen

ALES170 opened the stereo EQ / filter class with the one-pole tone control — yet a filter alone only **removes** a band. The tone control a keeper actually turns is two knobs, bass and treble, each boosting or cutting its band independently. Its mono form (`shelf.rye`, ALES41) already stands: split the span into a low band and its exact high band, scale each by its own gain, and write the sum saturated once. Carrying it into stereo is the natural second rung of the class, and it earns its keep — the everyday equalizer on a stereo master.

## The shape — the same knobs on both channels

`stereo_shelf(sc, start, count, coeff_num, coeff_den, bass_num, bass_den, treble_num, treble_den)` validates the coefficient, both band gains, and the span **once** against the shared length, then runs ALES41's proven mono `shelf` on each channel with the **same** parameters:

- **The knobs are shared** — a shelf's coefficient and band gains are fractions the caller names, not scalars measured across the field, so the same parameters on each channel preserve the stereo image for free. No linking, no measurement — the parametric pattern of ALES130's fade and ALES170's tone.
- **No carried state** — unlike ALES170, ALES41's shelf runs a fresh low-pass over the whole span each call, so a stereo shelf is a stateless per-channel pass with nothing to thread across a seam. Simpler than the tone control it follows.

`StereoShelfError = shelf.ShelfError` (BadCoeff, BadGain, BadRange) reused whole — the stereo lift adds no new fault.

## The laws proven

- **The stereo shelf law:** each channel equals ALES41's mono `shelf` with the same coefficient and band gains byte for byte, proven side by side with genuinely different per-channel content — the left shelved by the left's spectrum, the right by the right's, never crossed (the two outputs genuinely differ).
- **The flat-EQ identity law:** unity on both bands (bass = bass_den, treble = treble_den) is the identity on both channels (the bands reconstruct the input), and bass moves direct current while treble leaves it untouched, per channel (the high band is zero at direct current — the knobs are orthogonal).
- **The image law:** an identical-channel (mono-in-stereo) master stays identical through the shelf — the same input through the same knobs is the same deterministic output, so the two channels never split.
- **The balance / silence / atomicity / degenerate law:** an all-silent master shelves to silence on both; `left.len == right.len` after; a zero or above-one coefficient, a zero bass or treble denominator, and an out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips, each shelved through ALES41's own scratch-low-band pass — every band scale and sum in i64 so nothing overflows before the single clamp per channel. The coefficient sets where the split falls over sample indices, not a crossover in hertz; the band gains are plain fractions, not decibels. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
