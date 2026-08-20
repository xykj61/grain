# Fill ALES159 — Lotus's stereo_expand: the downward expander carried into stereo, the gate's linked decision fused with the compressor's linked gain

**Stamp:** `20260815.063651` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES159
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-063222_fill-ales158-lotus-stereo-limit.md`](20260815-063222_fill-ales158-lotus-stereo-limit.md)

---

## The next crux, honestly chosen

The stereo dynamics arc so far: the gate links the **decision** (ALES156), the compressor links the **gain** (ALES157), the limiter is the compressor's ratio→∞ brickwall (ALES158). The downward expander (ALES60) is the fourth member — the one that makes the mono family symmetric (it softens the gate's hard floor, continuous at the threshold) — and it completes the core stereo dynamics quartet by **fusing both linking laws**: it links the decision like the gate *and* the gain like the compressor.

## The shape — linked decision, linked gain, below the threshold

The expander widens the **deficit** below the threshold, mirroring the compressor's excess above it. Two truths meet:

- **Its decision must be linked, like the gate.** The expander pushes down the quiet. Expand each channel by whether it alone is below threshold and a pair loud on the left but quiet on the right would push the right down while the left plays — the image tears, exactly the gate's bug. So a pair is expanded **only when both channels are below threshold** (`key = max(|left|, |right|) < threshold`).
- **Its gain must be linked, like the compressor.** The expander's gain factor is magnitude-dependent (`max(0, threshold − deficit·ratio)/magnitude`), so expanding each channel by its own deficit gives different gains and shifts the image. So the one gain is computed from the linked key and applied to both.

`stereo_expand(sc, start, count, threshold, ratio_num, ratio_den)` validates threshold, ratio, and span once, then per pair with `key = max(|left|, |right|)`:

- **key ≥ threshold** → the pair plays: both pass byte for byte (continuous at the threshold — a threshold pair is the identity).
- **key = 0** → the pair is already silent: both stay zero (silence stays silence; no divide by zero).
- **0 < key < threshold** → expand: compute `new_key = max(0, threshold − (threshold − key)·num/den)` exactly as ALES60 would for the louder channel, then scale **both** channels by the single fraction `new_key/key`. The peak-holding (louder-quiet) channel lands on `new_key`; the quieter channel is scaled by the identical fraction. A ratio large enough drives the whole quiet pair to silence — the gate reached from within.

`StereoExpandError = expand.ExpandError` (BadThreshold, BadRatio, BadRange) reused whole.

## The laws proven

- **The linked decision + gain law (the stereo crux):** a pair is expanded iff **both** channels are below the threshold, and where expanded both are scaled by the **same** fraction `new_key/key` — so the louder-quiet channel equals ALES60's mono `expand` byte for byte (a master where the left always holds the peak has `left'` equal to mono expand of `left`), while the independent lift (mono expand of the quiet right alone) is shown to give a **different**, image-shifting result.
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase quiet pair returns still exactly out of phase, no magnitude expands, no sign flips.
- **The at-threshold law:** a pair whose linked key is at or above the threshold passes byte for byte on both — the expander is continuous at the threshold.
- **The knob laws:** unit ratio (num == den) is the identity everywhere on both; a higher ratio expands at least as hard (pushes further down, monotone); a ratio far past the threshold drives a quiet pair exactly to silence — the gate reached from within, in stereo.
- **The silence / balance / atomicity / degenerate law:** a both-silent pair stays silent (the `key = 0` guard, no divide by zero); `left.len == right.len` after; a bad threshold, sub-unity or zero-denominator ratio, and out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` and the empty span are the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips expanded by one linked gain — one comparison of the linked key and at most one multiply-then-divide per channel per sample (in i64, `|sample|·new_key ≤ 32768·32768` never overflows), memoryless (no attack, hold, or release; those are later rungs). The threshold is a magnitude in sample units, not decibels; the ratio a plain fraction. Nothing on the audio path can overflow — the widened result is floored at zero and `new_key ≤ key`, so every scaled magnitude is at most its input's, which already fits i16. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
