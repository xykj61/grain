# Fill ALES157 — Lotus's stereo_compress: the compressor carried into stereo, ONE LINKED GAIN from the max detector, the image held to the sample

**Stamp:** `20260815.062700` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES157
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-061957_fill-ales156-lotus-stereo-gate.md`](20260815-061957_fill-ales156-lotus-stereo-gate.md)

---

## The next crux, honestly chosen

ALES156 opened the stereo dynamics family on the gate and proved the **linked-detector law**. The most-reached-for member of that family is the compressor (ALES50) — it evens a vocal, glues a bus, tames a jumping bass — so it is the next crux, and it carries the gate's linking one honest step deeper.

## The shape — why the gate's law does not simply copy over

The gate's below-threshold attenuation is a **constant** factor `den/num`, the same for every magnitude. So gating each channel by its own magnitude already applied the same factor to both — the link only decided *whether* to gate. The compressor is different: its gain factor `(threshold + excess/ratio) / magnitude` **depends nonlinearly on the magnitude**. Compress each channel by its own magnitude and the loud channel is pulled down harder than the quiet one — the two receive **different gains**, and the inter-channel level difference that **is** the stereo image shifts. This is the same trap ALES129 (`stereo_normalize`) named for the static amplitude class, now dynamic and per-sample.

So `stereo_compress` computes **one gain from the linked detector and applies it to both**, the per-pair dynamic twin of ALES129's one-shared-gain:

- **key = max(|left|, |right|)** — the louder of the two, the master magnitude of the pair.
- **key ≤ threshold** → the pair is within the threshold: both pass byte for byte.
- **key > threshold** → compute the compressed master `new_key = threshold + (key − threshold)·den/num` exactly as ALES50 would for the loud channel, then scale **both** channels by the single fraction `new_key/key`: `x' = sign(x)·⌊|x|·new_key/key⌋`. The channel holding the peak lands on `new_key` — byte for byte equal to ALES50's mono compress of it — and the quieter channel is scaled by the identical fraction, so the L:R ratio is preserved to within one LSB of truncation.

`StereoCompressError = compress.CompressError` (BadThreshold, BadRatio, BadRange) reused whole; the linked lift adds no fault. Values only, never a length.

## The laws proven

- **The linked-gain law (the stereo crux):** both channels are scaled by the **same** fraction `new_key/key` computed from the linked max, so the loud channel equals ALES50's mono `compress` byte for byte while the quiet channel is scaled by the identical fraction — proven against a master where the left always holds the peak (`left'` equals mono compress of `left`), with the independent lift (mono compress of the quiet right alone) shown to give a **different**, image-shifting result.
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase pair (right = −left) returns still exactly out of phase, and no magnitude expands, no sign flips.
- **The sub-threshold law:** where the linked key is within the threshold, both channels pass byte for byte — below the linked threshold is the identity on both.
- **The knob laws:** unit ratio (num == den) is the identity everywhere on both; a higher ratio compresses at least as hard (monotone); a ratio far past the excess seats the linked key at the threshold — the loud channel lands on `threshold`, the quiet one proportionally — the limiter within the compressor, read in stereo.
- **The balance / atomicity / degenerate law:** `left.len == right.len` after (values only); a bad threshold, sub-unity or zero-denominator ratio, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` and the empty span are the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips compressed by one linked gain — one comparison of the linked key and at most one multiply-then-divide per channel per sample (computed in i64, `|sample|·new_key ≤ 32768·32768` never overflows), memoryless (no attack, release, or knee; those are later rungs). The threshold is a magnitude in sample units, not decibels; the ratio a plain fraction. Nothing on the audio path can overflow — `new_key ≤ key` so every scaled magnitude is at most its input's, which already fits i16. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
