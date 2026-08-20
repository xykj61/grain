# Fill ALES168 — Lotus's stereo_expand_env_hold: the attack/hold/release downward expander carried into stereo, the linked held envelope driving one linked widening over time — the third spender of the held time base

**Stamp:** `20260815.073427` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES168
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-072727_fill-ales167-lotus-stereo-gate-env-hold.md`](20260815-072727_fill-ales167-lotus-stereo-gate-env-hold.md)

---

## The next crux, honestly chosen

ALES166 spent the held time base for the compressor and ALES167 for the gate; this rung spends it for the **expander** — the attack/hold/release downward expander carried into stereo, the stereo mirror of ALES62, which took the mono breathing expander (ALES60/61) and drove it from the held mono follower (ALES56). Two stereo `_env_hold` siblings already stand (compressor, gate); the expander is the next of the held quartet, and its mono form (`expand_env_hold.rye`, ALES62) and its un-held linked form (`stereo_expand_env.rye`, ALES164) both already stand — so this rung is exactly their composition, adding no new fault.

The un-held stereo expander (ALES164) breathes, yet it still **pumps** the whole field on a brief dip between two loud samples: the widening deepens on the dip and re-opens the moment the pair rises, and the ear hears the gain move across the image at once. The hold fixes exactly this — on a fall from a peak, the shared countdown pins the peak so the widening stays idle through the dip. Because the detector is one shared held envelope, the two channels never deepen on different samples, so the fix that stops the pumping also keeps the image aligned.

## The shape — one linked held envelope, one widening, over time

`stereo_expand_hold_follow(sc, start, count, threshold, ratio, attack, release, hold)` validates threshold, ratio, both coefficients, the hold, and the span once, then per pair:

- **Advance the one shared held envelope** toward the linked peak `max(|left|, |right|)` by ALES165's `stereo_env_step_hold` (attack while rising and rearming the shared hold, the peak pinned while the countdown lasts, release once it expires).
- **Held envelope at or above the threshold** → the expander is idle, both pass byte for byte (continuous at the threshold).
- **Held envelope below the threshold** → the deficit `thr − e` is widened by the ratio, `exp = max(0, thr − deficit·num/den)` (ALES60's deepened floor on the held *envelope*), and the **one** gain `exp/e ∈ [0, 1)` is applied to **both** raw samples. A shared held envelope of exactly zero arises only when both channels are silent this pair, so no divide by zero.

`StereoExpandEnvHoldError = expand_env_hold.ExpandEnvHoldError` (BadThreshold, BadRatio, BadCoeff, BadHold, BadRange) reused whole. Carried-state (`stereo_expand_hold_follow_carry`, carrying **both** the shared `env` and `hold_left`) and from-silence forms, one implementation, so they cannot drift.

## The laws proven

- **The zero-hold law (the crux link):** `hold == 0` makes the linked held follower the plain linked follower, so `stereo_expand_env_hold` equals ALES164's `stereo_expand_env` byte for byte on both channels — the held rung's no-hold limit is exactly the un-held rung already proven, run against the real tool.
- **The linked-gain-over-time law:** a left-always-peak master has `left'` equal to ALES62's mono `expand_env_hold(left)` byte for byte, the right scaled by the identical fraction `exp/e` — while the independent per-channel `expand_env_hold` genuinely differs.
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob / no-pump laws:** unit ratio is the identity everywhere on both; and a nonzero hold keeps the expander idle across a brief dip — the held magnitude is no smaller than the un-held one everywhere (monotone) and strictly louder at the dip (the pumping avoided).
- **The carry law:** a span expanded in two pieces, the split falling mid-hold, equals expanding the whole once, byte for byte on both — `env` **and** `hold_left` surviving the boundary.
- **The at-threshold / silence / balance / atomicity / degenerate law:** a master whose linked held envelope never falls below the threshold passes byte for byte on both; silence stays silence; `left.len == right.len` after; a bad threshold, sub-unity ratio, illegal coefficient, hold past `max_clip`, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope and one shared `u32` hold countdown — one linked-peak comparison and at most one widen and one multiply-then-divide per channel for the gain, all in i64 (`|sample|·exp ≤ 32768·32767` never overflows), the gain `exp/e ∈ [0, 1)` so every scaled magnitude is at most its input's and fits i16. The threshold is a magnitude in sample units, the ratio a plain fraction, the attack, release, and hold counted in sample indices rather than milliseconds against a clock. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
