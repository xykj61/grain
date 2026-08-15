# Fill ALES167 — Lotus's stereo_gate_env_hold: the attack/hold/release noise gate carried into stereo, the linked held envelope driving one linked gate over time — the second spender of the held time base

**Stamp:** `20260815.072727` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES167
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-072211_fill-ales166-lotus-stereo-compress-env-hold.md`](20260815-072211_fill-ales166-lotus-stereo-compress-env-hold.md)

---

## The next crux, honestly chosen

ALES166 spent the held time base for the first time (the compressor); this rung spends it for the gate — the attack/hold/release noise gate carried into stereo, the stereo mirror of ALES57, which took the mono breathing gate (ALES54) and drove it from the held mono follower (ALES56).

The un-held stereo gate (ALES162) breathes, yet it still chatters the whole field on a brief dip between two loud samples: the gate slams shut and re-opens, and the ear hears the door swing. The hold fixes exactly this — on a fall from a peak, the shared countdown pins the peak so the gate stays open through the dip. Because the detector is one shared held envelope, the two channels never re-open on different samples, so the fix that stops the chatter also keeps the image aligned.

## The shape — one linked held envelope, one gate, over time

`stereo_gate_hold_follow(sc, start, count, threshold, ratio, attack, release, hold)` validates threshold, ratio, both coefficients, the hold, and the span once, then per pair:

- **Advance the one shared held envelope** toward the linked peak `max(|left|, |right|)` by ALES165's `stereo_env_step_hold` (attack while rising and rearming the shared hold, the peak pinned while the countdown lasts, release once it expires).
- **Held envelope at or above the threshold** → the gate is open, both pass byte for byte.
- **Held envelope below the threshold** → the whole magnitude is divided by the ratio, `gat = e·den/num` (ALES51's silenced floor on the held *envelope*), and the **one** gain `gat/e ∈ [0, 1]` is applied to **both** raw samples. A shared held envelope of exactly zero arises only when both channels are silent this pair, so no divide by zero.

`StereoGateEnvHoldError = gate_env_hold.GateEnvHoldError` (BadThreshold, BadRatio, BadCoeff, BadHold, BadRange) reused whole. Carried-state (`stereo_gate_hold_follow_carry`, carrying **both** the shared `env` and `hold_left`) and from-silence forms, one implementation, so they cannot drift.

## The laws proven

- **The zero-hold law (the crux link):** `hold == 0` makes the linked held follower the plain linked follower, so `stereo_gate_env_hold` equals ALES162's `stereo_gate_env` byte for byte on both channels — the held rung's no-hold limit is exactly the un-held rung already proven, run against the real tool.
- **The linked-gate-over-time law:** a left-always-peak master has `left'` equal to ALES57's mono `gate_env_hold(left)` byte for byte, the right scaled by the identical fraction `gat/e` — while the independent per-channel `gate_env_hold` genuinely differs.
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob / no-chatter laws:** unit ratio is the identity everywhere on both; and a nonzero hold keeps the gate open across a brief dip — the held magnitude is no smaller than the un-held one everywhere (monotone) and strictly louder at the dip (the chatter avoided).
- **The carry law:** a span gated in two pieces, the split falling mid-hold, equals gating the whole once, byte for byte on both — `env` **and** `hold_left` surviving the boundary.
- **The above-threshold / silence / balance / atomicity / degenerate law:** a master whose linked held envelope never falls below the threshold passes byte for byte on both; silence stays silence; `left.len == right.len` after; a bad threshold, sub-unity ratio, illegal coefficient, hold past `max_clip`, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope and one shared `u32` hold countdown — one linked-peak comparison and at most one multiply-then-divide for the step plus one per channel for the gain, all in i64 (`|sample|·gat ≤ 32768·32767` never overflows), the gain `gat/e ∈ [0, 1]` so every scaled magnitude is at most its input's and fits i16. The threshold is a magnitude in sample units, the ratio a plain fraction, the attack, release, and hold counted in sample indices rather than milliseconds against a clock. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
