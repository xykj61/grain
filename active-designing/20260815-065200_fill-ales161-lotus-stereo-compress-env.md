# Fill ALES161 — Lotus's stereo_compress_env: the attack/release compressor carried into stereo, the linked envelope driving one linked gain over time

**Stamp:** `20260815.065200` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES161
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-064459_fill-ales160-lotus-stereo-envelope.md`](20260815-064459_fill-ales160-lotus-stereo-envelope.md)

---

## The next crux, honestly chosen

ALES160 built the linked time base — one shared envelope tracking the linked peak. ALES157 built the linked gain — one gain from the max detector applied to both channels, the image held to the sample. This rung fuses them: the **attack/release compressor carried into stereo**, the gain reduction following the linked envelope over time rather than leaning on the bare pair the instant it arrives. It is the representative member of the stereo time-varying family — the compressor's gain depends nonlinearly on loudness, so proving the fusion here (linked detector *and* linked gain, over time) opens the mechanical gate/limiter/expander versions to follow.

The mono family crossed this exact seam at ALES53: it spent ALES52's proven envelope to drive ALES50's softened ceiling patiently. Stereo spends ALES160's linked envelope to drive ALES157's linked gain — one detector, one gain, both breathing.

## The shape — one linked envelope, one gain, over time

`stereo_compress_env(sc, start, count, threshold, ratio, attack, release)` validates threshold, ratio, both coefficients, and the span once, then per pair:

- **Advance the one shared envelope** toward the linked peak `max(|left|, |right|)` clamped to the rail, by ALES160's `stereo_env_step` (the attack fraction while it rises, the release while it falls — the proven ALES52 step, reused whole).
- **Envelope within the threshold** → both pass byte for byte (the gain reduction has not opened).
- **Envelope above the threshold** → the smoothed excess is softened by the ratio, `comp = threshold + excess·den/num` (exactly ALES50's/ALES53's softened ceiling, computed on the linked *envelope* not the bare sample), and the **one** gain `comp/e` is applied to **both** raw samples — the linked gain, now driven by the linked, time-smoothed detector.

`StereoCompressEnvError = compress_env.CompressEnvError` (BadThreshold, BadRatio, BadCoeff, BadRange) reused whole. Carried-state (`stereo_compress_follow_carry`) and from-silence (`stereo_compress_follow`) forms, one implementation, so they cannot drift.

## The laws proven

- **The instantaneous law (the crux link):** unit attack and unit release make the linked envelope the instantaneous linked peak every sample, so `stereo_compress_env` equals ALES157's memoryless `stereo_compress` byte for byte on both channels — the time-varying rung's zero-smoothing limit is exactly the memoryless rung already proven.
- **The linked-gain-over-time law:** a left-always-peak master has `left'` equal to ALES53's mono `compress_env(left)` byte for byte (the shared envelope equals the mono envelope of the peak-holding channel), the right scaled by the identical fraction `comp/e` — while the independent per-channel `compress_env` genuinely differs (the image-pumping bug this prevents).
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob laws:** unit ratio is the identity everywhere on both; a slower attack lets more of a transient through (the gain reduction lags, monotone in the attack knob).
- **The carry law:** a span compressed in two pieces (the second continuing the first's ending shared envelope) equals compressing the whole once, byte for byte on both.
- **The sub-threshold / silence / balance / atomicity / degenerate law:** a master whose linked envelope never crosses the threshold passes byte for byte on both; silence stays silence; `left.len == right.len` after; a bad threshold, sub-unity or zero-denominator ratio, illegal coefficient, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope — one linked-peak comparison and at most one multiply-then-divide for the envelope step plus one per channel for the gain, all in i64 (`|sample|·comp ≤ 32768·32767` never overflows), the gain `comp/e ∈ (0, 1]` so every scaled magnitude is at most its input's and fits i16. The threshold is a magnitude in sample units, the ratio a plain fraction, the attack and release fractions per sample index rather than milliseconds against a clock. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
