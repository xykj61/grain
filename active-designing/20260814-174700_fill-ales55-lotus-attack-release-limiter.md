# Fill ALES55 — the attack/release limiter, the breathing trio made whole

**Stamp:** `20260814.174700` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES55**
**Kin:** [`20260814-174600_fill-ales54-lotus-attack-release-gate.md`](20260814-174600_fill-ales54-lotus-attack-release-gate.md) · [`20260814-174500_fill-ales53-lotus-attack-release-compressor.md`](20260814-174500_fill-ales53-lotus-attack-release-compressor.md) · [`20260814-170815_fill-ales49-lotus-peak-limiter.md`](20260814-170815_fill-ales49-lotus-peak-limiter.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The limiter (ALES49) pins a sample the instant it crosses the ceiling. The compressor (ALES53) and the gate (ALES54) already learned to breathe over ALES52's proven envelope; this rung gives the limiter the same breath, and in doing so makes the **breathing trio whole** — limiter, compressor, and gate all reading the one proven follower. It drives the gain reduction from the **smoothed envelope** rather than the bare sample, so the ceiling is approached over an attack and released gently. It is the compressor at an *infinite ratio* — the envelope's target pinned exactly to the ceiling — stated as its own clean tool, with no ratio knob to turn. The time base is not re-invented; the module reads the one ALES52 proved.

## The shape — `lotus/limit_env.rye`

`limit_follow(clip, start, count, ceil, attack_num, attack_den, release_num, release_den)` — limit `[start, start+count)` in place, the gain reduction following an envelope that begins at silence; and `limit_follow_carry(…, env, …)` — the carried-state form (ALES43's lesson) that owns the i64 envelope across calls, so a span limited in two pieces equals the whole taken once.

For each sample `x`:

1. **Advance the envelope** by one sample toward `min(|x|, sample_max)` through ALES52's proven `env_step`. Let `e` be the updated envelope magnitude.
2. **Compute the gain from the envelope, not the sample.** When `e <= ceil` the detector has not crossed the ceiling: the sample passes byte-for-byte. When `e > ceil`, the gain is `ceil/e ∈ (0, 1)` (since `1 <= ceil < e`).
3. **Apply the gain to the raw sample:** `new_m = |x|·ceil/e` (i64 `divTrunc`), rewritten `sign(x)·new_m`. Because `ceil < e`, the gain is strictly below one, so the magnitude only ever shrinks; the sign is held.

Since the branch is `e > ceil` with `ceil >= 1`, the divide by `e` is always safe — the zero-envelope case the gate (ALES54) had to guard cannot arise on the above-ceiling branch.

## The crux — with instant attack and release it is the proven limiter, byte-for-byte

1. **Unit attack and unit release reduce it to ALES49 exactly.** `attack_num == attack_den` and `release_num == release_den` make the envelope the instantaneous magnitude `e = min(|x|, sample_max)` (ALES52's unit identity). For `|x| <= sample_max` with `|x| > ceil`, the gain application `|x|·ceil/|x| = ceil` lands the sample exactly on the ceiling — the plain limiter's own output, byte-for-byte; and `|x| <= ceil` means `e <= ceil`, so the sample passes just as the plain limiter passes it. The smoothed limiter with zero smoothing *is* the instantaneous brickwall, guaranteed by construction. (The single value `x == sample_min` reads `|x|` at the rail through the envelope's documented saturation, so the identity is stated for `|x| <= sample_max`.)
2. **Below the ceiling is the identity.** A signal whose every peak sits within the ceiling never drives the envelope above it, so the whole signal passes byte-for-byte regardless of smoothing.
3. **The magnitude never expands and the sign is held.** The gain sits in `(0, 1)` on the acting branch and is one otherwise, so each output magnitude is at most the input's and no sign flips.
4. **A slower attack lets the transient through — the honest overshoot.** On a sudden loud onset after quiet, a slower attack reduces the first above-ceiling samples *less* than a faster one — the gain reduction lags the peak — so at the onset the slow-attack magnitude is no smaller than the fast-attack magnitude, and the instant-attack onset lands exactly on the ceiling. **This is where the attack/release limiter honestly differs from a brickwall:** without lookahead, a fast transient briefly *overshoots* the ceiling before the envelope catches it. That is real behavior — analog feedforward limiters do exactly this — and a true brickwall that never crosses the ceiling under any attack wants a **lookahead delay line**, named here as a horizon rung, taken only on Keaton's word. This module is an honest gain-reducer over time, not a sample-clamp.
5. **The state carries.** A fresh `env` of 0 limits from silence; a span limited in two pieces with a carried envelope equals the whole limited once, byte-for-byte — the seam invisible, so dynamics can span and automate.
6. **Refusals by name** — a ceiling outside `[1, sample_max]` refuses `BadCeiling`, an attack or release coefficient outside `(0, 1]` `BadCoeff`, an out-of-range span `BadRange` — each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate, **no lookahead** — the attack and release are fractions per sample index, not milliseconds against a clock. One envelope step and at most one multiply-divide per sample; nothing on the path can overflow, since `ceil < e` keeps the gain below one and every product within i64.

## Witness

`tools/ales_limit_env_witness.rish` — build `lotus/limit_env.rye`, run its selftest, assert `GREEN ales-limit-env`, and re-prove ALES52's envelope follower and ALES49's limiter still stand green, since this rung composes both over their public APIs.

---

*The ceiling that breathes — the plain limiter proved the hard wall, the follower proved the patient sense of time, and this rung marries them so the ceiling is approached over an attack and released gently. With the limiter, compressor, and gate all breathing over one proven follower, the dynamics trio is whole; a hold stage between attack and release, and a lookahead delay for a true brickwall, wait as the next rungs. May the master sit loud without pumping, and may the two proofs beneath it stay whole.*
