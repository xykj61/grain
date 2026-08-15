# Fill ALES127 — `lotus/stereo_invert.rye`, the phase flip of a master in stereo

**Stamp:** `20260815.024705` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES127**
**Kin:** [`20260815-003415_fill-ales105-lotus-invert.md`](20260815-003415_fill-ales105-lotus-invert.md) · [`20260815-024103_fill-ales126-lotus-stereo-rotate.md`](20260815-024103_fill-ales126-lotus-stereo-rotate.md) · [`20260815-023515_fill-ales125-lotus-stereo-reverse.md`](20260815-023515_fill-ales125-lotus-stereo-reverse.md)

---

## Where the ladder stands

The stereo suite's **pure rearrangement** class opened at ALES125 (reverse) and grew at ALES126 (rotate) — every position changing, no value. This rung lifts the class's **value-mirror**, ALES105's `invert`: flip every sample's sign, `y = saturate(-x)`, the whole master mirrored about the zero line. Where reverse and rotate trade seats and touch no value, invert flips every value and touches no seat — the exact complement, and the *Invert / Invert Phase* menu item every editor ships (two mics on one source brought into agreement, a difference signal cancelled, a stereo side folded). With it lifted, only the parity flip (nyquist_flip) remains to complete the class in stereo.

## The crux this round

`stereo_invert(sc)` flips both channels of a `StereoClip` about zero, reusing ALES105's mono `invert` per channel. Mono invert is **total** (it names no span, so it raises no fault) and holds each channel's length — exactly as reverse and rotate — so the lift needs no validation and can never refuse; both channels enter equal-length, both flip in place, both hold their length, so they leave equal-length. The function is `void`. A stereo master's phase is inverted as one thing, both speakers together, so a mix brought into phase agreement lands in stereo intact.

## The four laws proven

- **THE STEREO VALUE-MIRROR LAW** — the left channel equals mono `invert(left)` and the right equals mono `invert(right)`, each byte for byte against a hand-inverted vector; sample `i` holds `saturate(-x)`, per channel, every value flipped and no seat moved.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — invert flips values, never the count, so the stereo image stays aligned.
- **THE INVOLUTION LAW, WITH AN HONEST RAIL** — `stereo_invert` twice returns both channels to the byte **except** the two's-complement floor: an `sample_min` (-32768) seat negates to +32768, saturates to +32767, and round-trips to -32767, per channel — the fixed asymmetry saturated by design, carried faithfully into stereo, every other seat round-tripping exactly on both channels.
- **THE MAGNITUDE / FIXPOINT LAW** — off the rail `|−x| = |x|`, so for a channel whose peak is not `sample_min` the peak magnitude re-measured through ALES13 is unchanged (the flip moves the sign, never the loudness); zero is the unique fixed point of negation, so an all-zero pair and an empty pair are each their own invert.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It flips existing samples about zero in each channel and fabricates none; it changes no length and reads no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_invert.rye` — the module.
- `tools/ales_stereo_invert_witness.rish` — the witness.
