# Fill ALES163 — Lotus's stereo_limit_env: the attack/release brickwall limiter carried into stereo, the linked envelope driving one linked ceiling over time

**Stamp:** `20260815.070439` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES163
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-065745_fill-ales162-lotus-stereo-gate-env.md`](20260815-065745_fill-ales162-lotus-stereo-gate-env.md)

---

## The next crux, honestly chosen

ALES162 carried the gate into stereo over time; this rung takes the second of the three mechanical siblings ALES161 opened: the **attack/release brickwall limiter carried into stereo**, the gain reduction following the linked envelope rather than pinning the bare pair the instant it crosses the ceiling. It is the compressor's linked gain at an infinite ratio — the envelope's target pinned exactly to the ceiling — with no ratio knob to turn.

The mono family crossed this seam at ALES55, completing its breathing trio (compressor · gate · limiter) over ALES52's proven envelope. Stereo spends ALES160's linked envelope to drive ALES158's linked ceiling: one detector, one gain, the peak-holding channel approaching the ceiling over the attack and released gently, the quiet channel scaled by the identical fraction so the image never shifts.

## The shape — one linked envelope, one ceiling, over time

`stereo_limit_env(sc, start, count, ceil, attack, release)` validates the ceiling, both coefficients, and the span once, then per pair:

- **Advance the one shared envelope** toward the linked peak `max(|left|, |right|)` clamped to the rail, by ALES160's `stereo_env_step` (attack while rising, release while falling — the proven ALES52 step, reused whole).
- **Envelope within the ceiling** → both pass byte for byte (the gain reduction has not opened).
- **Envelope above the ceiling** → the single gain `ceil/e ∈ (0, 1)` is applied to **both** raw samples — ALES49's ceiling reached over time on the *linked envelope*, not clamped the instant it is crossed. Since `e > ceil ≥ 1` on this branch, the divide is always safe; the zero-envelope case the gate faced cannot arise here.

`StereoLimitEnvError = limit_env.LimitEnvError` (BadCeiling, BadCoeff, BadRange) reused whole. Carried-state (`stereo_limit_follow_carry`) and from-silence (`stereo_limit_follow`) forms, one implementation, so they cannot drift.

## The laws proven

- **The instantaneous law (the crux link):** unit attack and unit release make the linked envelope the instantaneous linked peak every sample, so `stereo_limit_env` equals ALES158's memoryless `stereo_limit` byte for byte on both channels — the time-varying rung's zero-smoothing limit is exactly the memoryless rung already proven.
- **The linked-gain-over-time law:** a left-always-peak master has `left'` equal to ALES55's mono `limit_env(left)` byte for byte (the shared envelope equals the mono envelope of the peak-holding channel), the right scaled by the identical fraction `ceil/e` — while the independent per-channel `limit_env` genuinely differs (the image-shifting bug this prevents).
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob / no-lookahead law:** below the ceiling is the identity; a slower attack lets a fast transient briefly overshoot the ceiling before the envelope catches it (this is a gain-reducer over time, not a sample-clamp — monotone in the attack knob), while an instant attack pins the peak-holding channel exactly on the ceiling. A true brickwall that never crosses under any attack wants a lookahead delay line, a horizon rung.
- **The carry law:** a span limited in two pieces (the second continuing the first's ending shared envelope) equals limiting the whole once, byte for byte on both.
- **The sub-ceiling / silence / balance / atomicity / degenerate law:** a master whose linked envelope never crosses the ceiling passes byte for byte on both; silence stays silence; `left.len == right.len` after; a zero ceiling, an over-rail ceiling, an illegal coefficient, and an out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope — one linked-peak comparison and at most one multiply-then-divide for the envelope step plus one per channel for the gain, all in i64 (`|sample|·ceil ≤ 32767·32767` never overflows), the gain `ceil/e ∈ (0, 1)` so every scaled magnitude is at most its input's and fits i16. The ceiling is a magnitude in sample units, the attack and release fractions per sample index rather than milliseconds against a clock. No lookahead (the honest overshoot named above), no real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
