# Fill ALES174 — Lotus's stereo_bell: the parametric bell (peaking EQ) carried into stereo, the same two cutoffs and one gain on both channels — the fifth rung of the stereo EQ / filter class, the surgical everyday EQ

**Stamp:** `20260815.080752` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES174
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-080408_fill-ales173-lotus-stereo-notch.md`](20260815-080408_fill-ales173-lotus-stereo-notch.md)

---

## The next crux, honestly chosen

The stereo EQ / filter class now has its tone control (ALES170), shelf (ALES171), band-pass (ALES172, isolate the middle), and notch (ALES173, drop the middle). The gesture a mixer reaches for more than any other is the **bell** — the parametric peaking EQ: *turn* the middle band by a chosen gain while the edges stay exactly as they were. Lift a vocal's presence, tame a boxy room mode, dig out a kick's thump. Its mono form (`bell.rye`, ALES48) already stands, resting on the tone stack's lesson: the middle is the exact residual `M = x − L − H`, so gaining only the middle can never disturb the edges. The bell is the whole fixed-EQ family at three gains — unity is the identity, zero is the notch, a larger gain boosts. Carrying it into stereo is the natural fifth rung, and the everyday one.

## The shape — the same two cutoffs and one gain on both channels, stateless

`stereo_bell(sc, start, count, low_num, low_den, high_num, high_den, gain_num, gain_den)` validates the two cutoffs, the gain denominator, and the span **once** against the shared length, then runs ALES48's proven mono `bell` on each channel with the **same** cutoffs and gain:

- **The knobs are shared** — a bell's cutoffs and gain are fractions the caller names, not scalars measured across the field, so the same parameters on each channel preserve the stereo image for free. No linking, no measurement — the parametric pattern of ALES171's shelf, ALES172's band, ALES173's notch.
- **No carried state** — like the shelf and notch and unlike the band-pass, ALES48's bell runs fresh filters over the whole span each call, so a stereo bell is a stateless per-channel pass with nothing to thread across a seam.

`StereoBellError = bell.BellError` (BadCoeff, BadGain, BadRange) reused whole — the stereo lift adds no new fault.

## The laws proven

- **The stereo bell law:** each channel equals ALES48's mono `bell` with the same cutoffs and gain over the same span byte for byte, proven side by side with genuinely different per-channel content — the left belled by the left's spectrum, the right by the right's, never crossed (the two outputs genuinely differ).
- **The three-gain law:** unity gain (gain_num = gain_den) reconstructs the input byte for byte on both channels (the residual keeps the edges); zero gain (gain_num = 0) equals ALES173's stereo notch on both (the middle rejected); a settled constant survives on both at any gain (the mid band is zero at direct current — the bell turns only the middle, per channel).
- **The image law:** an identical-channel (mono-in-stereo) master stays identical through the bell — the same input through the same knobs is the same deterministic output, so the two channels never split.
- **The balance / silence / atomicity / degenerate law:** an all-silent master bells to silence on both; `left.len == right.len` after; an illegal low cutoff, an illegal high cutoff, a zero gain denominator, and an out-of-range span each refuse by name with both channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each belled through ALES48's own residual and scratch bands, every band scale and sum in i64 so nothing overflows before the single clamp per channel. The cutoffs set where the turned band falls over sample indices, not crossovers in hertz; the gain is a plain fraction, not decibels. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
