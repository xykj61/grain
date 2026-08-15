# Fill ALES166 — Lotus's stereo_compress_env_hold: the attack/hold/release compressor carried into stereo, the linked held envelope driving one linked gain over time — the first spender of the held time base

**Stamp:** `20260815.072211` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES166
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-071625_fill-ales165-lotus-stereo-hold-env.md`](20260815-071625_fill-ales165-lotus-stereo-hold-env.md)

---

## The next crux, honestly chosen

ALES165 gave the linked detector its hold — the patient time base the stereo held-dynamics family waits for. This rung is the first to *spend* it: the attack/hold/release compressor carried into stereo, exactly the stereo mirror of ALES58, which took the mono breathing compressor (ALES53) and drove it from the held mono follower (ALES56).

The un-held stereo compressor (ALES161) breathes, yet it still pumps the whole field when a loud passage momentarily ducks below the threshold: the gain jumps back toward unity and the ear hears it breathe in and out. The hold fixes exactly this — on a fall from a peak, the shared countdown pins the peak so the gain reduction stays engaged through the duck. Because the detector is one shared held envelope, the two channels never release on different samples, so the fix that steadies the level also keeps the image aligned.

## The shape — one linked held envelope, one gain, over time

`stereo_compress_hold_follow(sc, start, count, threshold, ratio, attack, release, hold)` validates threshold, ratio, both coefficients, the hold, and the span once, then per pair:

- **Advance the one shared held envelope** toward the linked peak `max(|left|, |right|)` by ALES165's `stereo_env_step_hold` (attack while rising and rearming the shared hold, the peak pinned while the countdown lasts, release once it expires).
- **Held envelope within the threshold** → both pass byte for byte.
- **Held envelope above the threshold** → the excess is softened by the ratio, `comp = threshold + excess·den/num` (ALES50's ceiling on the held *envelope*, not the bare sample), and the **one** gain `comp/e ∈ (0, 1]` is applied to **both** raw samples.

`StereoCompressEnvHoldError = compress_env_hold.CompressEnvHoldError` (BadThreshold, BadRatio, BadCoeff, BadHold, BadRange) reused whole. Carried-state (`stereo_compress_hold_follow_carry`, carrying **both** the shared `env` and `hold_left`) and from-silence forms, one implementation, so they cannot drift.

## The laws proven

- **The zero-hold law (the crux link):** `hold == 0` makes the linked held follower the plain linked follower, so `stereo_compress_env_hold` equals ALES161's `stereo_compress_env` byte for byte on both channels — the held rung's no-hold limit is exactly the un-held rung already proven, run against the real tool.
- **The linked-gain-over-time law:** a left-always-peak master has `left'` equal to ALES58's mono `compress_env_hold(left)` byte for byte (the shared held envelope equals the mono held envelope of the peak-holding channel), the right scaled by the identical fraction `comp/e` — while the independent per-channel `compress_env_hold` genuinely differs.
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob / no-pump laws:** unit ratio is the identity everywhere on both; and a nonzero hold keeps the gain reduction engaged across a brief duck — the held magnitude is no larger than the un-held one everywhere (monotone) and strictly quieter at the duck (the pumping avoided).
- **The carry law:** a span compressed in two pieces, the split falling mid-hold, equals compressing the whole once, byte for byte on both — `env` **and** `hold_left` surviving the boundary.
- **The sub-threshold / silence / balance / atomicity / degenerate law:** a master whose linked held envelope never crosses the threshold passes byte for byte on both; silence stays silence; `left.len == right.len` after; a bad threshold, sub-unity ratio, illegal coefficient, hold past `max_clip`, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope and one shared `u32` hold countdown — one linked-peak comparison and at most one multiply-then-divide for the step plus one per channel for the gain, all in i64 (`|sample|·comp ≤ 32768·32767` never overflows), the gain `comp/e ∈ (0, 1]` so every scaled magnitude is at most its input's and fits i16. The threshold is a magnitude in sample units, the ratio a plain fraction, the attack, release, and hold counted in sample indices rather than milliseconds against a clock. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
