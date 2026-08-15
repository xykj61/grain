# Fill ALES177 — Lotus's stereo_ring_mod: the ring modulator (bipolar triangle carrier on amplitude) carried into stereo, the same carrier on both channels — the second rung of the stereo modulation class, the tremolo's sibling

**Stamp:** `20260815.083200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES177
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-082400_fill-ales176-lotus-stereo-tremolo.md`](20260815-082400_fill-ales176-lotus-stereo-tremolo.md)

---

## The next crux, honestly chosen

ALES176 opened the stereo modulation class with the tremolo — a triangle LFO on the gain, held to an **attenuation** so the carrier never crosses zero. Its named sibling (`ring_mod.rye`, ALES75) is that rung with **one restriction lifted**: the carrier may cross zero and go negative, flipping the sample's sign; swung fast it multiplies the signal by a bipolar wave and scatters the spectrum into metallic sum-and-difference tones — the ring modulator's unmistakable clang. Because a ring modulator whose carrier never goes negative is *exactly* the tremolo, carrying it into stereo is the natural second modulation rung: the same thin per-sample discipline, one bound widened.

## The shape — the same bipolar carrier on both channels

`stereo_ring_mod(sc, start, count, centre_scaled, depth_scaled, period)` validates the carrier and span **once** against the shared length, then runs ALES75's proven mono `ring_mod` on each channel with the **same** carrier:

- **The carrier is shared** — a ring modulator's centre, depth, and period are scaled units the caller names (256 = unity), not scalars measured across the field, so the same carrier on each channel preserves the stereo image for free. The parametric pattern of the whole class.
- **The same carrier on both is the linked stereo ring modulator** — both speakers clang together. Because each output is its own input times the **shared** carrier `c(k)`, an identical-channel master stays identical **and** a panned master keeps its pan exactly: both sides multiplied by the same `c(k)`, so the left:right ratio at every sample is untouched — **even when `c(k)` turns negative and flips both signs together**, the ratio holds.
- **No snapshot** — like the tremolo and unlike a delay-line modulation, every output depends only on its own input sample, so the stereo ring modulator writes in place with nothing to thread across a seam.

The one honest subtlety carries too: the two's-complement i16 rail is asymmetric (`sample_min = −32768`), so a carrier at −unity on a full-negative sample lands +32768, one past `sample_max`, and ALES75's one true saturate clamps that lone corner to 32767 per channel. `StereoRingModError = ring_mod.RingModError` (BadPeriod, BadDepth, BadCarrier, BadRange) reused whole; ALES75's four validations are factored into a shared `precheck` (mirroring the ALES176 tremolo refactor) so the stereo lift validates once before either channel writes.

## The laws proven

- **The stereo ring law:** each channel equals ALES75's mono `ring_mod` with the same carrier over the same span byte for byte, genuinely different per-channel content (the two outputs genuinely differ).
- **The tremolo-sibling law:** a non-negative carrier makes the stereo ring modulator exactly ALES176's stereo tremolo on both channels byte for byte (the two rungs one multiply, the sign the only difference); a bipolar carrier then genuinely differs (a sign the tremolo can never produce).
- **The image law:** an identical-channel master stays identical through the ring modulator, **and** a panned pair keeps its left:right ratio at every sample, sign flips and all.
- **The balance / silence / atomicity / degenerate law:** an all-silent master rings to silence on both; `left.len == right.len` after; a bad period, a bad depth, a bad carrier, and an out-of-range span each refuse by name with both channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each rung through ALES75's own unit-bounded bipolar carrier (the triangle and multiply in i64, the write saturating once — a no-op except the lone sample_min-inverted corner). The carrier is counted in scaled units (256 = unity) and the period in samples, not hertz — a real time base is a later rung. No delay line, no snapshot, no lookahead, no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
