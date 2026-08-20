# Fill ALES172 — Lotus's stereo_band: the band-pass carried into stereo, the same two cutoffs on both channels, each channel carrying its own cascade state — the third rung of the stereo EQ / filter class

**Stamp:** `20260815.075923` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES172
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-075512_fill-ales171-lotus-stereo-shelf.md`](20260815-075512_fill-ales171-lotus-stereo-shelf.md)

---

## The next crux, honestly chosen

ALES170 opened the stereo EQ / filter class with the one-pole tone control (one edge kept), and ALES171 followed with the two-band shelf (both bands tilted by gain). The gesture a keeper reaches for to **isolate** a range on a master — the telephone voice, the drum bus carved to its body, the wah's throat — is the band-pass: drop the lows below one cutoff, drop the highs above another, keep only the band between. Its mono form (`band.rye`, ALES46) already stands as a `Bandpass` struct: a high-pass at the low cutoff cascaded into a low-pass at the high cutoff, each stage carrying its own state so a span band-passed in two pieces equals the whole band-passed once. Carrying it into stereo is the natural third rung of the class, and it earns its keep — the everyday band-pass on a stereo master.

## The shape — the same two cutoffs on both channels, one cascade state per channel

A `StereoBandpass` holds **two** mono `Bandpass` structs, `left` and `right`, both built with the **same** four coefficients (the low cutoff `num_low/den_low`, the high cutoff `num_high/den_high`). `run(sc, start, count)` validates **both** coefficient pairs and the span **once** against the shared length before either channel is touched, then runs each channel's own `Bandpass.run`:

- **The cutoffs are shared** — a band-pass's cutoffs are fractions the caller names, not scalars measured across the field, so the same two cutoffs on each channel preserve the stereo image for free. No linking, no measurement — the parametric pattern of ALES170's tone and ALES171's shelf.
- **The state is per channel** — like ALES170's tone (and unlike ALES171's stateless shelf), a band-pass carries running estimates, so each channel keeps its **own** cascade state. Linking the state across channels would bleed one channel's transients into the other's band — a bug here, exactly as it would be for the tone control. `reset()` returns both channels' four states to silence together.

`StereoBandError = tone.ToneError` (BadCoeff, BadRange) reused whole — the stereo lift adds no new fault, the same error the mono band-pass and every filter rung already refuse by name.

## The laws proven

- **The stereo band-pass law:** each channel equals ALES46's mono `Bandpass.run` with the same two cutoffs over the same span byte for byte, proven side by side with genuinely different per-channel content — the left band-passed by the left's spectrum, the right by the right's, never crossed (the two outputs genuinely differ).
- **The carry law:** a master band-passed in two pieces (each channel continuing its own ending cascade state) equals the whole band-passed once, byte for byte on both channels — both channels' states surviving the boundary independently, no fresh transient at the seam.
- **The image law:** an identical-channel (mono-in-stereo) master stays identical through the band-pass — the same input through the same cutoffs evolves the same state, so the two channels never split; a settled constant is rejected to zero on both (direct current dropped by the high-pass stage, per channel).
- **The reset / balance / silence / atomicity / degenerate law:** `reset` re-opens both channels' transients; an all-silent master band-passes to silence on both; `left.len == right.len` after; an illegal low cutoff, an illegal high cutoff, and an out-of-range span each refuse by name with both channels and all four states untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each band-passed through ALES46's proven two-stage cascade; both channels' four cascade states run at full i64 precision so nothing overflows. The cutoffs set where the split falls over sample indices, not crossovers in hertz (a real time base is a later rung). No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
