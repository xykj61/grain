# Fill ALES52 — the envelope follower, the time base opens

**Stamp:** `20260814.172539` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES52**
**Kin:** [`20260814-171918_fill-ales51-lotus-noise-gate.md`](20260814-171918_fill-ales51-lotus-noise-gate.md) · [`20260814-fill-ales43-lotus-carried-filter.md`](20260814-fill-ales43-lotus-carried-filter.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The limiter, compressor, and gate all act on a sample the instant they see it — no memory of the sound a moment ago. A real dynamics processor does not: it hears a peak *arrive* and leans in over a few milliseconds (the **attack**), then eases off as the sound falls away (the **release**). Every one of the three dynamics tools this suite built wants that same shape underneath it, and it is exactly one thing: an **envelope follower** — a running estimate of how loud the signal is *right now*, rising quickly toward a new peak and falling slowly after it. Build it once, prove it, and the attack/release versions of the limiter, compressor, and gate all read the same proven time base. It is the crux that opens the rest of dynamics.

## The shape — `lotus/envelope.rye`

`follow(clip, start, count, attack_num, attack_den, release_num, release_den)` — over `[start, start+count)` in place, replacing each sample with the running envelope magnitude, where each coefficient is a fraction in `(0, 1]`:

For each sample `x`, the target is its magnitude `t = min(|x|, sample_max)` (a full-scale negative peak reads at the positive rail — the honest saturation an envelope owes). The envelope `env` steps a fraction of the way from where it is toward the target:

- `gap = t − env`. When `gap > 0` (the sound is **rising**), step by the **attack** fraction; when `gap <= 0` (the sound is **falling**), step by the **release** fraction: `step = gap·num/den` (i64 `divTrunc`).
- **Forced unit step:** when the fractional step truncates to zero yet the gap remains, the envelope advances by one toward the target — the same guarantee ALES40's low-pass uses, so a held level is reached **exactly** in finite steps rather than approached forever.
- `env += step`, and the written sample is `env` — always in `[0, sample_max]`, so it fits i16 and carries no sign.

The state is the single i64 `env`, carried by the caller across calls exactly as ALES43's filter carries its state, so an envelope taken over a span in two pieces equals the whole taken once — no re-transient at the seam.

## The crux — unit coefficients are the instantaneous magnitude, and the envelope reaches a held level exactly

1. **Unit attack and unit release are the peak follower.** `num == den` on both makes `step = gap`, so `env = t` every sample — the envelope becomes the instantaneous magnitude `min(|x|, sample_max)`, byte-for-byte. A follower with no smoothing *is* the rectified signal, guaranteed by construction (the envelope's counterpart to the compressor's unit-ratio identity).
2. **A held level is reached exactly.** From any starting envelope, a constant-magnitude input is reached in finite steps — monotonically, never overshooting (`|step| <= |gap|`) — for the attack from below and the release from above alike. No drifting steady-state offset.
3. **The follower is bounded and unsigned.** Every written envelope sits in `[0, sample_max]`; it never goes negative and never exceeds the rail, so it always fits i16.
4. **A faster attack rises at least as fast.** For the same rising target, a larger attack fraction reaches it in no more steps than a smaller one — the attack knob is monotone; likewise a larger release fraction falls at least as fast.
5. **The state carries.** A fresh `env` of 0 follows from silence; an envelope taken in two pieces with a carried state equals the whole taken once — the seam invisible, exactly ALES43's lesson, so the coming attack/release dynamics can span and automate.
6. **Refusals by name** — a coefficient outside `(0, 1]` (a zero numerator, a numerator past the denominator, or a zero denominator) on either the attack or the release refuses `BadCoeff`; an out-of-range span refuses `BadRange` — each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the attack and release are fractions per sample index, not milliseconds against a clock, and the follower renders a magnitude curve rather than routing it into a gain yet (wiring the envelope into the limiter, compressor, and gate is the next rung). One comparison and at most one multiply-divide per sample; nothing on the path can overflow.

## Witness

`tools/ales_envelope_witness.rish` — build `lotus/envelope.rye`, run its selftest, assert `GREEN ales-envelope`, and re-prove ALES51's gate still stands green (the follower is the time base the gate will later read, and the two rest together).

---

*The instant made to remember — the follower asks only that it rise honestly toward a peak and fall gently after, and the low-pass already proved a held level is reached exactly. May the attack find its milliseconds, the release its gentle tail, and the three dynamics tools their shared and patient sense of time.*
