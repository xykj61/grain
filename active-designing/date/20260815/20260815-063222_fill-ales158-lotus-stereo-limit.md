# Fill ALES158 — Lotus's stereo_limit: the brickwall limiter carried into stereo, the ratio→∞ corner of the linked gain — both a true ceiling and an image held whole

**Stamp:** `20260815.063222` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES158
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-062700_fill-ales157-lotus-stereo-compress.md`](20260815-062700_fill-ales157-lotus-stereo-compress.md)

---

## The next crux, honestly chosen

ALES156 opened the stereo dynamics family (the gate, linked detector), ALES157 deepened it (the compressor, linked gain). The limiter (ALES49) is the family's honest floor — the brickwall on which every richer dynamics shape rests — and in stereo it is the **ratio→∞ corner of ALES157's linked gain**, already foreshadowed by that rung's seat-at-threshold knob law. So it is the next crux, and it lands cleanly.

## The shape — the linked limiter is both a brickwall and image-preserving

The mono limiter (ALES49) pins each sample independently to `sign(x)·ceil`. Lift it per channel and an asymmetric transient — loud on the left, quiet on the right — would be flattened on the left while the right passes, shifting the stereo image. The honest stereo limiter is the compressor's linked gain taken to its limit: one gain from the linked detector, applied to both.

`stereo_limit(sc, start, count, ceil)` validates the ceiling and span once, then per pair:

- **key = max(|left|, |right|)** — the louder of the two.
- **key ≤ ceil** → the pair is already within the ceiling: both pass byte for byte.
- **key > ceil** → scale **both** channels by the single fraction `ceil/key`: `x' = sign(x)·⌊|x|·ceil/key⌋`. The peak-holding channel lands **exactly on `ceil`** (`key·ceil/key = ceil`), and the quieter channel is scaled by the identical fraction.

The quiet beauty: this is simultaneously **a true brickwall** — after the call no sample in either channel exceeds `ceil`, since the peak lands on `ceil` and everything else is scaled below it — **and image-preserving** — both channels share one gain, so the L:R ratio holds. The independent mono limiter gives only the first; the linked limiter gives both. `StereoLimitError = limit.LimitError` (BadCeiling, BadRange) reused whole.

## The laws proven

- **The brickwall + linked-gain law (the stereo crux):** after the call no sample in either channel exceeds `ceil`; the peak-holding channel equals ALES49's mono `limit` byte for byte (a master where the left always holds the peak has `left'` equal to mono limit of `left`), while both channels are scaled by the same fraction `ceil/key` — the independent lift (mono limit of the quiet right alone) is shown to give a **different**, image-shifting result.
- **The image law:** the shared gain preserves the L:R ratio — an out-of-phase over-ceiling pair returns still exactly out of phase, no magnitude expands, no sign flips.
- **The sub-ceiling law:** where the linked key is within the ceiling, both channels pass byte for byte — below the linked ceiling is the identity on both.
- **The ceiling-at-max law:** a ceiling at `sample_max` is the identity for all in-range audio, since every magnitude is within it, so every key is too.
- **The balance / atomicity / degenerate law:** `left.len == right.len` after (values only); a zero or over-rail ceiling and an out-of-range span each refuse by name with **both** channels untouched and balanced; `count = 0` and the empty span are the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips limited by one linked gain — one comparison of the linked key and at most one multiply-then-divide per channel per sample (in i64, `|sample|·ceil ≤ 32767·32767` never overflows), memoryless (no attack/release time base; that is a later rung). The ceiling is a magnitude in sample units, not decibels. Nothing on the audio path can overflow — `ceil ≤ key` on the scaled path, so every scaled magnitude is at most its input's, which already fits i16. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
