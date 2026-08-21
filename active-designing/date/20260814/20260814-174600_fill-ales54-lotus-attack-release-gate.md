# Fill ALES54 — the attack/release noise gate, the envelope holds it open

**Stamp:** `20260814.174600` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES54**
**Kin:** [`20260814-174500_fill-ales53-lotus-attack-release-compressor.md`](20260814-174500_fill-ales53-lotus-attack-release-compressor.md) · [`20260814-171918_fill-ales51-lotus-noise-gate.md`](20260814-171918_fill-ales51-lotus-noise-gate.md) · [`20260814-172539_fill-ales52-lotus-envelope-follower.md`](20260814-172539_fill-ales52-lotus-envelope-follower.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The gate (ALES51) leans on a sample the instant it sees it — a sample below the threshold is quieted the moment it arrives, and the quieting vanishes the moment the sample rises. A real gate breathes: it hears a sound *end* and holds open through the **release** before it closes, so the tail of a note is not chopped and the gate does not chatter on every dip between two loud samples. ALES52 built exactly that breath — an envelope follower — and proved it once; ALES53 spent it for the compressor. This rung spends the same proof for the gate: it drives the downward push from the **smoothed envelope** rather than the bare sample, so the gate opens as the sound arrives and stays open patiently as it falls away. The time base is not re-invented; the module reads the one ALES52 proved. ALES54 is ALES53's mirror — the threshold inverted from *above* to *below*.

## The shape — `lotus/gate_env.rye`

`gate_follow(clip, start, count, threshold, ratio_num, ratio_den, attack_num, attack_den, release_num, release_den)` — gate `[start, start+count)` in place, the downward push following an envelope that begins at silence; and `gate_follow_carry(…, env, …)` — the carried-state form (ALES43's lesson) that owns the i64 envelope across calls, so a span gated in two pieces equals the whole taken once and the release holds across a call boundary.

For each sample `x`:

1. **Advance the envelope** by one sample toward `min(|x|, sample_max)` through ALES52's proven `env_step` — the attack fraction while the envelope rises, the release while it falls. Let `e` be the updated envelope magnitude.
2. **Compute the gain from the envelope, not the sample.** When `e >= threshold` the detector reads the gate open: the sample passes byte-for-byte. When `e < threshold`, the gated envelope target is `gat = e·den/num` (i64 `divTrunc`) — ALES51's whole-magnitude divide by the ratio, computed on the envelope — and the gain is `gat/e ∈ [0, 1]`.
3. **Apply the gain to the raw sample:** `new_m = |x|·gat/e` (i64 `divTrunc`), rewritten `sign(x)·new_m`. Because `gat <= e`, the magnitude only ever shrinks; the sign is held.

The state is the single i64 `env`, carried by the caller exactly as ALES43's filter, ALES52's follower, and ALES53's compressor carry theirs.

## The one case the compressor never faced — a zero envelope

ALES53's branch was `e > threshold` with `threshold >= 1`, so `e >= 2` and the divide `.../e` was always safe. The gate's branch is `e < threshold`, and `e` can reach **zero** at rest in silence — a divide by `e` would be a divide by zero. The guard is exact, not defensive: `env_step` forces at least a unit step toward any nonzero target, so a zero envelope can arise *only* when this sample's own magnitude is zero. The module asserts `x == 0` in that branch and leaves the already-silent sample untouched — no divide by zero can occur, proven by the follower's own forced-unit-step law rather than by clamping.

## The crux — with instant attack and release it is the proven gate, byte-for-byte

1. **Unit attack and unit release reduce it to ALES51 exactly.** `attack_num == attack_den` and `release_num == release_den` make the envelope the instantaneous magnitude `e = min(|x|, sample_max)` (ALES52's unit identity). For `|x| <= sample_max`, `e = |x| = m`, so below the threshold `new_m = divTrunc(m · divTrunc(m·den, num), m) = divTrunc(m·den, num)` — `m` divides `m·K` exactly, so the outer `divTrunc` returns `K`, the plain gate's own output byte-for-byte; and at or above the threshold `e = m` passes just as `m >= threshold` passes. The smoothed gate with zero smoothing *is* the instantaneous gate, guaranteed by construction. (The single value `x == sample_min` reads `|x|` at the rail through the envelope's documented saturation, so the identity is stated for `|x| <= sample_max` — every i16 but that one.)
2. **Unit ratio is the identity everywhere.** `ratio_num == ratio_den` makes `gat == e`, so the gain is exactly one at every sample regardless of the envelope: the whole signal passes byte-for-byte, even below the threshold.
3. **The magnitude never expands and the sign is held.** The gain sits in `[0, 1]` every sample, so each output magnitude is at most the input's and no sign flips.
4. **A slower release holds the gate open longer.** After a loud passage ends, a slower release keeps the smoothed envelope above the threshold for longer, so a quiet tail is attenuated *less* than under a fast release — the gate does not chop the note's fall or chatter. At the tail the slow-release magnitude is no smaller than the fast-release magnitude, and the first tail sample under a slow release is strictly louder — the release knob is monotone, and the hold audibly survives. (This is the gate's characteristic time-behavior, where the compressor's was the attack.)
5. **The state carries.** A fresh `env` of 0 gates from silence; a span gated in two pieces with a carried envelope equals the whole gated once, byte-for-byte — the seam invisible, the release holding across the boundary, so dynamics can span and automate.
6. **Refusals by name** — a threshold outside `[1, sample_max]` refuses `BadThreshold`, a ratio below unity or with a zero denominator `BadRatio`, an attack or release coefficient outside `(0, 1]` `BadCoeff`, an out-of-range span `BadRange` — each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the attack and release are fractions per sample index, not milliseconds against a clock. One envelope step and at most one multiply-divide per sample; nothing on the path can overflow, since `gat <= e` keeps every product within i64 and every result within i16.

## Witness

`tools/ales_gate_env_witness.rish` — build `lotus/gate_env.rye`, run its selftest, assert `GREEN ales-gate-env`, and re-prove ALES52's envelope follower and ALES51's gate still stand green, since this rung composes both over their public APIs.

---

*The floor that breathes — the plain gate proved the silenced floor, the follower proved the patient sense of time, and this rung marries them so the gate opens as the sound arrives and holds open over its release. With the compressor and the gate both breathing, the family's next rung can give the limiter the same time, or open a hold stage between attack and release. May the vocal's tail ring out clean, the room tone stay gone between the words, and the two proofs beneath it stay whole.*
