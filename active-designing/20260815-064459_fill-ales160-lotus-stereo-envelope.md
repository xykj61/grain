# Fill ALES160 — Lotus's stereo_envelope: the envelope follower carried into stereo, one linked detector for the time-varying family to come

**Stamp:** `20260815.064459` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES160
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-063651_fill-ales159-lotus-stereo-expand.md`](20260815-063651_fill-ales159-lotus-stereo-expand.md)

---

## The next crux, honestly chosen

The stereo memoryless dynamics quartet stands whole and witnessed — the gate links the **decision** (ALES156), the compressor links the **gain** (ALES157), the limiter is the compressor's brickwall (ALES158), the expander fuses both linking laws (ALES159). Each acts on a pair the instant it sees it, with no memory of the sound a moment ago. The mono family crossed exactly this seam once: ALES52 built the **envelope follower**, the running estimate of loudness that rises quickly toward a new peak (the attack) and falls slowly after it (the release), and the attack/release limiter, compressor, gate, and expander all read that one proven time base.

Stereo wants the same crux, and it wants it **linked**. The next durable rung is `stereo_envelope` — one shared detector envelope, driven by the louder of the two channels, so the whole time-varying family to come pumps on **one** loudness curve rather than two that drift apart and shift the image. It is the crux that opens the rest of stereo dynamics, and it is Lindy-first: every stereo `*_env` rung will read it.

## The shape — one envelope, the linked key, written to both

A follower renders the loudness curve itself (ALES52 replaces each sample with the smoothed magnitude — the detector made visible, before it is ever routed into a gain). Carried into stereo the single truth is that **the detector is shared**:

- **The key is the linked peak.** At each index the envelope steps toward `max(|left|, |right|)` clamped to the rail — the louder channel decides the shared loudness, exactly as the stereo gate/compressor/expander read their per-pair key. Following each channel by its own magnitude would give two envelopes that lean in and ease off on different samples; a later gain read from two curves would pump the image.
- **The one curve is written to both.** The shared envelope value lands in both channels, so `left == right` after — the detector aligned in time across the stereo field, one time base a stereo dynamics rung reads once.

`stereo_env_step(env, xl, xr, attack, release)` computes `key = max(|xl|, |xr|)` clamped to `sample_max` and delegates to ALES52's proven `env_step` on that key, reusing the forced-unit-step exact-reach guarantee and the attack/release asymmetry whole. `stereo_follow_carry(sc, start, count, env, …)` and `stereo_follow(sc, start, count, …)` carry the caller's `i64` envelope across calls (the seam invisible) or start from silence, writing the shared value to both channels. `StereoEnvelopeError = envelope.EnvelopeError` (BadCoeff, BadRange) reused whole — the linked detector adds no fault.

## The laws proven

- **The linked detector law (the stereo crux):** the shared curve equals ALES52's mono `follow` of the per-sample linked key (a synthetic clip of `max(|left|, |right|)` clamped) byte for byte, and **both** output channels equal that shared curve — while an independent per-channel follow (each channel by its own magnitude) genuinely differs, the image-pumping bug this rung prevents.
- **The balance law:** after the call `left == right` byte for byte and `left.len == right.len`, the detector aligned across the field.
- **The instantaneous law:** unit attack and unit release make the shared envelope the linked peak `max(|left|, |right|)` clamped, every sample — a follower with no smoothing is the rectified louder channel.
- **The convergence laws:** a constant linked input is reached exactly and monotonically from below via the attack and from above via the release, never overshooting; a faster attack rises at least as fast (the knob is monotone).
- **The carry law:** following a span in two pieces (the second continuing the first's ending envelope) equals following the whole once, byte for byte on both — so the coming attack/release dynamics can span and automate without a fresh transient at the seam.
- **The silence / atomicity / degenerate law:** an all-silent master follows to all zeros on both; an illegal coefficient and an out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope — one comparison for the linked key and at most one multiply-then-divide per sample (ALES52's proven step), the envelope bounded in `[0, sample_max]` which fits i16, so nothing on the path can overflow. The attack and release are fractions per sample index, not milliseconds against a clock; the follower renders the linked magnitude curve rather than routing it into a gain yet (wiring the linked envelope into the stereo compressor, gate, limiter, and expander is the next rung). No real sample rate, no anti-aliasing, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.
