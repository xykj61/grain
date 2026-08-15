# Fill ALES169 — Lotus's stereo_limit_env_hold: the attack/hold/release brickwall limiter carried into stereo, the linked held envelope driving one linked ceiling over time — the fourth spender of the held time base, the stereo held quartet made whole

**Stamp:** `20260815.073957` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES169
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-073427_fill-ales168-lotus-stereo-expand-env-hold.md`](20260815-073427_fill-ales168-lotus-stereo-expand-env-hold.md)

---

## The next crux, honestly chosen

ALES166 spent the held time base for the compressor, ALES167 for the gate, ALES168 for the expander; this rung spends it for the **limiter** — the fourth and last member, so the stereo held-dynamics quartet closes exactly as the mono held quartet closed at ALES62 and the stereo time-varying quartet closed at ALES164. Its mono form (`limit_env_hold.rye`, ALES59) and its un-held linked form (`stereo_limit_env.rye`, ALES163) both already stand — so this rung is exactly their composition, adding no new fault. The limiter is the compressor's gain at an infinite ratio: the envelope's target pinned to the ceiling, no ratio knob.

The un-held stereo limiter (ALES163) breathes, yet its gain reduction still **pumps** the whole field when a loud passage momentarily ducks below the ceiling: the reduction releases on the duck and re-engages the moment the pair rises. The hold fixes exactly this — on a fall from a peak, the shared countdown pins the peak so the reduction stays engaged through the duck. Because the detector is one shared held envelope, the two channels never release on different samples, so the fix that steadies the level also keeps the image aligned.

## The shape — one linked held envelope, one ceiling, over time

`stereo_limit_hold_follow(sc, start, count, ceil, attack, release, hold)` validates the ceiling, both coefficients, the hold, and the span once, then per pair:

- **Advance the one shared held envelope** toward the linked peak `max(|left|, |right|)` by ALES165's `stereo_env_step_hold` (attack while rising and rearming the shared hold, the peak pinned while the countdown lasts, release once it expires).
- **Held envelope within the ceiling** → the gain reduction has not opened, both pass byte for byte.
- **Held envelope above the ceiling** → the **one** gain `ceil/e ∈ (0, 1)` is applied to **both** raw samples (ALES49's ceiling on the held *envelope*). On this branch `e > ceil ≥ 1`, so the divide is always safe — the zero-envelope case the gate faced cannot arise.

`StereoLimitEnvHoldError = limit_env_hold.LimitEnvHoldError` (BadCeiling, BadCoeff, BadHold, BadRange — no ratio, so no BadRatio) reused whole. Carried-state (`stereo_limit_hold_follow_carry`, carrying **both** the shared `env` and `hold_left`) and from-silence forms, one implementation, so they cannot drift.

## The laws proven

- **The zero-hold law (the crux link):** `hold == 0` makes the linked held follower the plain linked follower, so `stereo_limit_env_hold` equals ALES163's `stereo_limit_env` byte for byte on both channels — the held rung's no-hold limit is exactly the un-held rung already proven, run against the real tool.
- **The linked-gain-over-time law:** a left-always-peak master has `left'` equal to ALES59's mono `limit_env_hold(left)` byte for byte, the right scaled by the identical fraction `ceil/e` — while the independent per-channel `limit_env_hold` genuinely differs.
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob / no-pump laws:** below the ceiling is the identity everywhere on both; and a nonzero hold keeps the gain reduction engaged across a brief duck — the held magnitude is no larger than the un-held one everywhere (monotone) and strictly quieter at the duck (the pumping avoided).
- **The carry law:** a span limited in two pieces, the split falling mid-hold, equals limiting the whole once, byte for byte on both — `env` **and** `hold_left` surviving the boundary.
- **The sub-ceiling / silence / balance / atomicity / degenerate law:** a master whose linked held envelope never crosses the ceiling passes byte for byte on both; silence stays silence; `left.len == right.len` after; a bad ceiling, illegal coefficient, hold past `max_clip`, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope and one shared `u32` hold countdown — one linked-peak comparison and at most one multiply-then-divide per channel for the gain, all in i64 (`|sample|·ceil ≤ 32768·32767` never overflows), the gain `ceil/e ∈ (0, 1)` so every scaled magnitude is strictly below its input's and fits i16. The ceiling is a magnitude in sample units, the attack, release, and hold counted in sample indices rather than milliseconds against a clock. No lookahead, no real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
