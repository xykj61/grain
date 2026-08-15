# Fill ALES156 — Lotus's stereo_gate: the noise gate carried into stereo, ONE LINKED DETECTOR, the image the gate refuses to tear

**Stamp:** `20260815.061957` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES156
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-060518_fill-ales155-lotus-stereo-dc-remove.md`](20260815-060518_fill-ales155-lotus-stereo-dc-remove.md)

---

## The next crux, honestly chosen

The waveshaping and silence/analysis families are now whole in stereo (ALES131–155), yet the whole **dynamics family** — the gate, the compressor, the limiter, the expander (ALES49–51 and their envelope kin) — has **no stereo twin at all**. That is the largest Lindy-durable gap left in the stereo lift: every mixing chain leans on dynamics, and a Lotus master cannot be finished without them. So this rung opens that family, and it opens it on its simplest, most self-contained member: the noise gate (ALES51), memoryless, one threshold and one ratio, no attack/hold/release state to carry.

Gate is crux-first for the family because it names, in the plainest possible form, the one decision every stereo dynamics processor must make and that no waveshaper ever faced: **linked or independent detection.** Once gate proves the linked-detector law, the compressor, limiter, and expander reuse it.

## The shape — the linked detector, the amplitude class's own counterpoint

`stereo_normalize_peak` (ALES129) already taught this shape for the amplitude class: a per-channel lift would be a *bug*, because independent processing flattens or tears the very inter-channel difference that **is** the stereo image. The gate is the dynamics-class version of the same truth. Run the mono gate (ALES51) twice — once per channel, each deciding on its own magnitude — and a moment where the signal sits loud on the left but quiet on the right would **gate the right while the left plays**: the image lurches to one side, and worse, it chatters as the quiet channel opens and closes against its loud partner. Every real stereo gate refuses this by **linking the detector**: it decides open-or-closed once, from both channels together, and applies that one decision to both.

`stereo_gate(sc, start, count, threshold, ratio_num, ratio_den)` validates threshold, ratio, and span **once** against the shared length (the checks are identical for both channels, so a refusal never gates one channel and leaves the other torn), then walks the span one sample-*pair* at a time:

- **key = max(|left[i]|, |right[i]|)** — the linked detector, the louder of the two channels' magnitudes.
- **key ≥ threshold** → the gate is **open**: both samples pass byte for byte, whichever channel was quiet included. This is where linked and independent part ways — independent would have gated the quiet channel; linked holds the image whole.
- **key < threshold** → the gate is **closed**: both channels are genuinely below threshold (the max is), so each channel divides its **own** magnitude by the ratio, `sign(x)·(m·den/num)`, exactly as ALES51 would to each in isolation. A large enough ratio drives the quiet pair to silence.

`StereoGateError = gate.GateError` (BadThreshold, BadRatio, BadRange) reused whole; the linked lift adds no fault. Values only, never a length, so the two channels leave balanced.

## The laws proven

- **The linked-detector law (the stereo crux):** a sample-pair is gated iff **both** channels fall below the threshold (equivalently `max(|L|,|R|) < threshold`) — proven directly against a pair loud on the left and quiet on the right, where independent per-channel gating (mono gate run twice) would quiet the right while the left plays, and `stereo_gate` leaves **both** untouched.
- **The below-both law:** where the whole pair sits below threshold, each channel equals ALES51's mono `gate` over the same span byte for byte — the linked closed decision reduces to the mono gate on each, so the closed floor is proven against the mono tool directly.
- **The image / sign law:** the gate is an even, sign-preserving attenuation — no written magnitude ever exceeds its input's, no sign flips, and an out-of-phase quiet pair (right = −left, both below threshold) comes back still out of phase (each divided by the same ratio).
- **The knob laws:** above the threshold is the identity on both channels; **unit ratio** (num == den) is the identity everywhere on both, even below threshold; a **higher ratio** gates at least as hard (monotone), and a ratio far past the magnitude drives a closed pair exactly to silence — the hard gate.
- **The balance / atomicity / degenerate law:** `left.len == right.len` after (values only); a bad threshold, sub-unity or zero-denominator ratio, and out-of-range span each refuse by name with **both** channels byte for byte untouched and still balanced; `count = 0` and the empty span are the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips gated by one linked detector — one comparison of the linked key and at most one divide per channel per sample, memoryless (no attack, hold, or release; those are the envelope rungs ALES52+ and their later stereo twins). The threshold is a magnitude in sample units, not decibels; the ratio a plain fraction. Nothing on the audio path can overflow — the ratio is at least one, so a gated magnitude is at most the input's, which already fits i16 (|sample_min| = 32768 computed in i64). No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
