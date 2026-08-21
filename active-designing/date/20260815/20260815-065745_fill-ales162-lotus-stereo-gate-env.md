# Fill ALES162 — Lotus's stereo_gate_env: the attack/release noise gate carried into stereo, the linked envelope driving one linked gate over time

**Stamp:** `20260815.065745` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES162
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-065200_fill-ales161-lotus-stereo-compress-env.md`](20260815-065200_fill-ales161-lotus-stereo-compress-env.md)

---

## The next crux, honestly chosen

ALES161 fused the linked detector with the linked gain for the compressor — the representative member of the stereo time-varying dynamics family, and the one whose gain depends nonlinearly on loudness. Its design read closed on the promise that proving that fusion "opens the mechanical gate/limiter/expander versions to follow." This rung takes the first of those three: the **attack/release noise gate carried into stereo**, the downward push following the linked envelope over time rather than leaning on the bare pair the instant it arrives.

The mono family crossed this exact seam at ALES54 — one rung after the mono attack/release compressor (ALES53), it spent ALES52's proven envelope to drive ALES51's silenced floor patiently, so a note's tail is not chopped and the gate does not chatter on every dip. Stereo spends ALES160's linked envelope to drive ALES156's linked gate decision: one detector, one gate, both channels holding open or closing together, the image never lurching to one side as a quiet channel opens and closes against its loud partner.

## The shape — one linked envelope, one gate decision, over time

`stereo_gate_env(sc, start, count, threshold, ratio, attack, release)` validates threshold, ratio, both coefficients, and the span once, then per pair:

- **Advance the one shared envelope** toward the linked peak `max(|left|, |right|)` clamped to the rail, by ALES160's `stereo_env_step` (the attack fraction while it rises, the release while it falls — the proven ALES52 step, reused whole).
- **Envelope at or above the threshold** → the gate is open, both pass byte for byte.
- **Envelope below the threshold** → the gate is closed; the envelope's whole magnitude is divided by the ratio, `gat = e·den/num` (exactly ALES51's/ALES54's silenced floor, computed on the linked *envelope* not the bare sample), and the **one** gain `gat/e` is applied to **both** raw samples — the linked gate, now driven by the linked, time-smoothed detector. A shared envelope of exactly zero can only arise when both channels are silent, so no divide by zero and nothing to gate.

`StereoGateEnvError = gate_env.GateEnvError` (BadThreshold, BadRatio, BadCoeff, BadRange) reused whole. Carried-state (`stereo_gate_follow_carry`) and from-silence (`stereo_gate_follow`) forms, one implementation, so they cannot drift.

## The laws proven

- **The instantaneous law (the crux link):** unit attack and unit release make the linked envelope the instantaneous linked peak every sample, so `stereo_gate_env` equals ALES156's memoryless `stereo_gate` byte for byte on both channels — the time-varying rung's zero-smoothing limit is exactly the memoryless rung already proven.
- **The linked-gate-over-time law:** a left-always-peak master has `left'` equal to ALES54's mono `gate_env(left)` byte for byte (the shared envelope equals the mono envelope of the peak-holding channel), the right scaled by the identical fraction `gat/e` — while the independent per-channel `gate_env` genuinely differs (the image-tearing bug this prevents).
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair returns still out of phase, no magnitude expands, no sign flips.
- **The knob laws:** unit ratio is the identity everywhere on both; a slower release holds the gate open longer (a quiet tail after a loud passage is attenuated less, monotone in the release knob) — the gate's own transient survival, mirroring the compressor's slower-attack law.
- **The carry law:** a span gated in two pieces (the second continuing the first's ending shared envelope) equals gating the whole once, byte for byte on both — the release holding across the call boundary.
- **The above-threshold / silence / balance / atomicity / degenerate law:** a master whose linked envelope never falls below the threshold passes byte for byte on both; silence stays silence; `left.len == right.len` after; a bad threshold, sub-unity or zero-denominator ratio, illegal coefficient, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips carrying one shared `i64` envelope — one linked-peak comparison and at most one multiply-then-divide for the envelope step plus one per channel for the gain, all in i64 (`|sample|·gat ≤ 32768·32767` never overflows), the gain `gat/e ∈ [0, 1]` so every scaled magnitude is at most its input's and fits i16. The threshold is a magnitude in sample units, the ratio a plain fraction, the attack and release fractions per sample index rather than milliseconds against a clock. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
