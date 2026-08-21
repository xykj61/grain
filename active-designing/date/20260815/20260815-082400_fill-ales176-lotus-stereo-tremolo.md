# Fill ALES176 — Lotus's stereo_tremolo: the tremolo (triangle LFO on amplitude) carried into stereo, the same swing on both channels — the rung that OPENS the stereo modulation class

**Stamp:** `20260815.082400` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES176
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-081412_fill-ales175-lotus-stereo-sweep.md`](20260815-081412_fill-ales175-lotus-stereo-sweep.md)

---

## The next crux, honestly chosen

The stereo EQ / filter class stands whole (ALES170–175: tone, shelf, band-pass, notch, bell, and the swept low-pass). That class shapes a signal's **spectrum** by a fixed or swept coefficient. The other great family of everyday effects points a moving **LFO** at a target and lets it swing over time — the **modulation** family: chorus, vibrato, flanger, and the oldest of all, the **tremolo**. Its mono form (`tremolo.rye`, ALES74) is called "the thinnest rung in the modulation family": a triangle LFO drives the **gain**, so a steady note gently rises and falls in loudness, and because every output sample depends only on **its own** input sample, it writes in place with no snapshot, no delay line, no lookahead. That thinness makes it the right rung to **open** the stereo modulation class — exactly as ALES170's tone (the thinnest filter) opened the stereo EQ class.

## The shape — the same swing on both channels, the linked auto-tremolo

`stereo_tremolo(sc, start, count, centre_scaled, depth_scaled, period)` validates the swing and span **once** against the shared length, then runs ALES74's proven mono `tremolo` on each channel with the **same** swing:

- **The swing is shared** — a tremolo's centre, depth, and period are scaled units the caller names (256 = unity gain), not scalars measured across the field, so the same swing on each channel preserves the stereo image for free. No linking machinery, no measurement — the parametric pattern of the whole EQ class.
- **The same LFO on both is the classic linked (auto-)tremolo** — both speakers pulse together. Because each output is its own input times the **shared** gain `g(k)`, an identical-channel master stays identical **and** a panned master keeps its pan exactly: both sides scaled by the same `g(k)`, so the left:right ratio at every sample is untouched. The tremolo pulses the whole field without wandering the image. (An offset-phase stereo tremolo, which deliberately wanders the image, is a later rung; this opener is the linked one.)
- **No carried state** — like the stateless shelf/notch/bell and unlike the band-pass, nothing threads across a seam.

To keep the up-front atomic check, ALES74's four validations are factored into a shared `precheck` (mirroring `tone.precheck` across the EQ rungs); the mono `tremolo` now calls it, and the stereo lift calls it once before either channel writes. `StereoTremoloError = tremolo.TremoloError` (BadPeriod, BadDepth, BadGain, BadRange) reused whole.

## The laws proven

- **The stereo tremolo law:** each channel equals ALES74's mono `tremolo` with the same swing over the same span byte for byte, proven side by side with genuinely different per-channel content (the two outputs genuinely differ).
- **The image law:** an identical-channel master stays identical through the tremolo, **and** a panned pair keeps its left:right ratio at every sample (both sides scaled by the same shared gain — the linked tremolo pulses without wandering the image).
- **The attenuation law:** unity gain (centre = glide_scale, depth = 0) passes both channels byte for byte even at the rail (the saturate a no-op), and no tremolo voice exceeds the dry it scales on either channel.
- **The balance / silence / atomicity / degenerate law:** an all-silent master tremolos to silence on both; `left.len == right.len` after; a bad period, a bad depth, a bad gain, and an out-of-range span each refuse by name with both channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each tremoloed through ALES74's own attenuating triangle gain (the triangle and multiply in i64, the write saturating once as a proven no-op). The gain is counted in scaled units (256 = unity) and the period in samples, not hertz — a real time base is a later rung. No delay line, no snapshot, no lookahead, no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
