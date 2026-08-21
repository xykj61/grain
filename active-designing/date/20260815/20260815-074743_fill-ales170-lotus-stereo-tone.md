# Fill ALES170 — Lotus's stereo_tone: the one-pole tone control carried into stereo, the same coefficient shaping both channels — the rung that opens the stereo EQ / filter class

**Stamp:** `20260815.074743` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES170
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-073957_fill-ales169-lotus-stereo-limit-env-hold.md`](20260815-073957_fill-ales169-lotus-stereo-limit-env-hold.md)

---

## The next crux, honestly chosen

The stereo dynamics family closed at ALES169 — gate, compressor, expander, and limiter each carried into stereo over their linked detector, the held quartet made whole. The most Lindy-durable family the stereo port had not yet opened was the one the mono ladder opened *before* dynamics: the **EQ / filter** class (ALES40–48). A channel strip's tone shaping is read on every master; it is the natural crux to take next, and its simplest member — ALES40's one-pole tone control — is the rung that opens the class, exactly as ALES129's normalize opened the stereo amplitude class with its simplest member.

Its mono form (`tone.rye`, ALES40) already stands: a one-pole low-pass that softens a harsh take and its exact high-pass complement that thins a boomy one, both reaching a constant input exactly rather than drifting. So this rung is exactly ALES40 run on both channels — adding no new fault, only carrying the proven filter into stereo.

## The shape — one coefficient, two independent states, over both channels

`stereo_low_pass(sc, start, count, num, den)` (and its high-pass twin, plus their carried forms) validates the coefficient and span **once** against the shared length, then runs ALES40's proven mono filter on each channel with the **same** coefficient and its **own** i64 state:

- **The coefficient is shared** — a tone control is parametric, its `num/den` a smoothing fraction the caller names, not a measured scalar. The same coefficient on both channels lands the same brightness shaping on both speakers, so the image is held for free — the way ALES130's shared ramp held it, and unlike ALES129's linked scalar or the dynamics detector's linked envelope, which had to measure across both channels to hold the image.
- **The states are independent, one per channel** — a filter's state is the running estimate of the signal it is filtering, and the left and right signals genuinely differ. Linking the state across channels, as the dynamics detector links its envelope, would be a **bug** here: it would bleed one channel's transients into the other's brightness. Independence is exactly right for EQ.

`StereoToneError = tone.ToneError` (BadCoeff, BadRange) reused whole. Carried forms (`stereo_low_pass_carry`, `stereo_high_pass_carry`) lift **both** per-channel states so a master filtered in two pieces continues each side across the seam with no fresh transient — one implementation shared with the from-silence forms, so they cannot drift.

## The laws proven

- **The stereo low-pass law:** each channel equals ALES40's mono `low_pass` with the same coefficient byte for byte, proven side by side with genuinely different per-channel content — the left shaped by the left's spectrum, the right by the right's, never crossed (the two outputs genuinely differ).
- **The stereo high-pass law:** the same for `high_pass`, and the per-channel reconstruction `low_pass + high_pass = x` holds sample for sample where the difference fits.
- **The parametric / image law:** an identical-channel (mono-in-stereo) master stays identical through both filters, and a constant input settles to direct current **exactly** on each channel (ALES40's crux carried per channel) — the shared coefficient holding the image.
- **The carry law:** a span filtered in two pieces, each channel continuing its own ending state, equals the whole filtered once, byte for byte on both — both states surviving the boundary independently.
- **The silence / balance / atomicity / degenerate law:** an all-silent master filters to silence on both; `left.len == right.len` after; a zero denominator, a zero numerator, a coefficient above one, and an out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying two independent `i64` filter states — one estimate step per sample per channel, all in i64 at full precision so no fractional information is lost and nothing overflows before ALES2's saturate on the high-pass difference. The coefficient is a smoothing fraction over sample indices rather than a cutoff in hertz against a real clock. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
