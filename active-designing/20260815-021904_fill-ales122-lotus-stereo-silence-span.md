# Fill ALES122 — `lotus/stereo_silence_span.rye`, silencing a span carried into stereo

**Stamp:** `20260815.021904` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES122**
**Kin:** [`20260815-010618_fill-ales110-lotus-silence-span.md`](20260815-010618_fill-ales110-lotus-silence-span.md) · [`20260815-021504_fill-ales121-lotus-stereo-paste-over.md`](20260815-021504_fill-ales121-lotus-stereo-paste-over.md)

---

## Where the ladder stands

The stereo edit family now carries the destructive span-edits (cut, crop, move), the growth edit (duplicate), and the overwrite paste (paste_over), each running a proven mono edit on both channels of a `StereoClip` in lockstep. Mono **silence_span** (ALES110) — the *Silence Audio Selection* button, write zeros over a span while the length HOLDS — still has no stereo twin, and it is exactly the zero-paint case of the `stereo_paste_over` just landed at ALES121: silence is the overwrite whose paint is zero.

## The crux this round

`stereo_silence_span(sc, start, count)` writes silence over `[start, start+count)` in both channels, reusing ALES110's mono `silence_span` per channel with the same `start` and `count`. Mono silence_span can fault only with `BadRange` and keeps each channel's length, so the balance invariant is preserved trivially; the span is checked once against the shared length up front so a refusal lands before either channel mutates:

- `start > len` → `BadRange`
- `count > len - start` → `BadRange`

Once those pass, each mono silence_span is pre-validated to succeed. It reuses ALES2's `EditError` whole and invents no fault of its own.

## The four laws proven

- **THE STEREO SILENCE LAW** — the left channel equals mono `silence_span(left, start, count)` and the right equals mono `silence_span(right, start, count)`, each byte for byte; the span all zero, every sample outside it unchanged.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — silencing writes values only, never resizing, so the stereo image stays aligned.
- **THE SPECIALIZATION LAW** — `stereo_silence_span(start, count)` equals ALES121's `stereo_paste_over(start, zeros, zeros)` byte for byte on both channels — silence is the overwrite whose paint is zero, proven side by side.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal leaves BOTH channels byte for byte untouched and still balanced; `count = 0` the identity on both, `silence_span(0, len)` silences both wholly, a span past the samples `BadRange`.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It writes zeros over an existing span in each channel — changing no length, reading no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_silence_span.rye` — the module.
- `tools/ales_stereo_silence_span_witness.rish` — the witness.
