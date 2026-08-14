# Fill ALES53 — the attack/release compressor, the envelope leans in

**Stamp:** `20260814.174500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES53**
**Kin:** [`20260814-172539_fill-ales52-lotus-envelope-follower.md`](20260814-172539_fill-ales52-lotus-envelope-follower.md) · [`20260814-171338_fill-ales50-lotus-compressor.md`](20260814-171338_fill-ales50-lotus-compressor.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The compressor (ALES50) leans on a sample the instant it sees it — a peak the moment it arrives is already softened, and the softening vanishes the moment the peak passes. A real compressor breathes: it hears a peak *arrive* and leans in over a few samples (the **attack**), then eases the gain back as the sound falls away (the **release**). ALES52 built exactly that breath — an envelope follower, a running estimate of how loud the signal is right now — and proved it once. This rung spends that proof: it drives the compressor's gain reduction from the **smoothed envelope** rather than the bare sample, so the compressor leans in patiently and lets go gently. The time base is not re-invented; the module reads the one ALES52 proved.

## The shape — `lotus/compress_env.rye`

`compress_follow(clip, start, count, threshold, ratio_num, ratio_den, attack_num, attack_den, release_num, release_den)` — compress `[start, start+count)` in place, the gain reduction following an envelope that begins at silence; and `compress_follow_carry(…, env, …)` — the carried-state form (ALES43's lesson) that owns the i64 envelope across calls, so a span compressed in two pieces equals the whole taken once.

For each sample `x`:

1. **Advance the envelope** by one sample toward `min(|x|, sample_max)` through ALES52's proven `env_step` — the attack fraction while the envelope rises, the release while it falls. Let `e` be the updated envelope magnitude.
2. **Compute the gain from the envelope, not the sample.** When `e <= threshold` the detector has not crossed the ceiling: the sample passes byte-for-byte. When `e > threshold`, the compressed envelope target is `comp = threshold + (e − threshold)·den/num` (i64 `divTrunc`), the same ceiling-softening ALES50 proved, and the gain is `comp/e ∈ (0, 1]`.
3. **Apply the gain to the raw sample:** `new_m = |x|·comp/e` (i64 `divTrunc`), rewritten `sign(x)·new_m`. Because `comp <= e`, the magnitude only ever shrinks; the sign is held.

The state is the single i64 `env`, carried by the caller exactly as ALES43's filter and ALES52's follower carry theirs.

## The crux — with instant attack and release it is the proven compressor, byte-for-byte

1. **Unit attack and unit release reduce it to ALES50 exactly.** `attack_num == attack_den` and `release_num == release_den` make the envelope the instantaneous magnitude `e = min(|x|, sample_max)` (ALES52's unit identity). Then for `|x| <= sample_max` the gain application `|x|·comp/e = |x|·comp/|x| = comp` lands the sample at `threshold + (|x|−threshold)·den/num` — the plain compressor's own output, byte-for-byte. The smoothed compressor with zero smoothing *is* the instantaneous compressor, guaranteed by construction. (The single value `x == sample_min` reads `|x|` at the rail through the envelope's documented saturation, so the identity is stated for `|x| <= sample_max` — every i16 but that one.)
2. **Unit ratio is the identity everywhere.** `ratio_num == ratio_den` makes `comp == e`, so the gain is exactly one at every sample regardless of the envelope: the whole signal passes byte-for-byte.
3. **The magnitude never expands and the sign is held.** The gain sits in `(0, 1]` every sample, so each output magnitude is at most the input's and no sign flips.
4. **A slower attack lets the transient through.** On a sudden loud onset after quiet, a slower attack reduces the first above-threshold samples *less* than a faster one — the gain reduction lags the peak, exactly the breath a real compressor has — so at the onset the slow-attack magnitude is no smaller than the fast-attack magnitude. The attack knob is monotone.
5. **The state carries.** A fresh `env` of 0 compresses from silence; a span compressed in two pieces with a carried envelope equals the whole compressed once, byte-for-byte — the seam invisible, so dynamics can span and automate.
6. **Refusals by name** — a threshold outside `[1, sample_max]` refuses `BadThreshold`, a ratio below unity or with a zero denominator `BadRatio`, an attack or release coefficient outside `(0, 1]` `BadCoeff`, an out-of-range span `BadRange` — each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the attack and release are fractions per sample index, not milliseconds against a clock. One envelope step and at most one multiply-divide per sample; nothing on the path can overflow, since `comp <= e` keeps every product within i64 and every result within i16.

## Witness

`tools/ales_compress_env_witness.rish` — build `lotus/compress_env.rye`, run its selftest, assert `GREEN ales-compress-env`, and re-prove ALES52's envelope follower and ALES50's compressor still stand green, since this rung composes both over their public APIs.

---

*The ceiling that breathes — the plain compressor proved the softened ceiling, the follower proved the patient sense of time, and this rung marries them so the gain leans in over an attack and eases off over a release. May the vocal sit without pumping, the drum bus glue without gasping, and the two proofs beneath it stay whole.*
