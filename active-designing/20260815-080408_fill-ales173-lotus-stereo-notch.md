# Fill ALES173 — Lotus's stereo_notch: the band-reject carried into stereo, the same two cutoffs on both channels, each channel a stateless parallel sum — the fourth rung of the stereo EQ / filter class

**Stamp:** `20260815.080408` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES173
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-075923_fill-ales172-lotus-stereo-band.md`](20260815-075923_fill-ales172-lotus-stereo-band.md)

---

## The next crux, honestly chosen

The stereo EQ / filter class now has its tone control (ALES170, one edge kept), its two-band shelf (ALES171, both bands tilted), and its band-pass (ALES172, the middle isolated). The exact complement of the band-pass is the band-reject — the **notch**: keep the edges, drop the middle. It is the everyday surgical cut a keeper reaches for — the mains hum pulled from a take, the resonant ring notched from a room, the mud scooped while the lows and the air stay whole. Its mono form (`notch.rye`, ALES47) already stands: sum, in **parallel**, a low-pass at the low cutoff and a high-pass at the high cutoff, and write the sum saturated once; what neither branch keeps — the middle band — is rejected. Carrying it into stereo is the natural fourth rung of the class, the band-pass's mirror image.

## The shape — the same two cutoffs on both channels, stateless

`stereo_notch(sc, start, count, low_num, low_den, high_num, high_den)` validates both cutoffs and the span **once** against the shared length, then runs ALES47's proven mono `notch` on each channel with the **same** two cutoffs:

- **The cutoffs are shared** — a notch's cutoffs are fractions the caller names, not scalars measured across the field, so the same two cutoffs on each channel preserve the stereo image for free. No linking, no measurement — the parametric pattern of ALES171's shelf and ALES172's band.
- **No carried state** — like ALES171's shelf and unlike ALES172's band-pass, ALES47's notch runs a fresh low-pass and high-pass over the whole span each call, so a stereo notch is a stateless per-channel pass with nothing to thread across a seam. The band-pass's stateful complement returns to the shelf's simpler shape.

`StereoNotchError = tone.ToneError` (BadCoeff, BadRange) reused whole — the stereo lift adds no new fault.

## The laws proven

- **The stereo notch law:** each channel equals ALES47's mono `notch` with the same two cutoffs over the same span byte for byte, proven side by side with genuinely different per-channel content — the left notched by the left's spectrum, the right by the right's, never crossed (the two outputs genuinely differ).
- **The zero-width / direct-current law:** equal cutoffs (low = high) reconstruct the input byte for byte on both channels (the reject band has zero width — the identity), and a settled constant survives on both (at direct current the low band keeps the constant and the high band is zero, so the notch keeps direct current, per channel).
- **The complement law:** the notch is genuinely neither the low-pass nor the high-pass alone, and it differs from ALES172's band-pass on the same cutoffs — keep the edges, not the middle, per channel.
- **The image / balance / silence / atomicity / degenerate law:** an identical-channel (mono-in-stereo) master stays identical through the notch; an all-silent master notches to silence on both; `left.len == right.len` after; an illegal low cutoff, an illegal high cutoff, and an out-of-range span each refuse by name with both channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each notched through ALES47's own two scratch bands, every band sum in i64 so nothing overflows before the single clamp per channel. The cutoffs set where the reject band falls over sample indices, not crossovers in hertz (a real time base is a later rung). No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
