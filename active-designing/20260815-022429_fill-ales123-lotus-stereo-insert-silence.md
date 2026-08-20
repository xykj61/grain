# Fill ALES123 — `lotus/stereo_insert_silence.rye`, opening a silent gap carried into stereo

**Stamp:** `20260815.022429` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES123**
**Kin:** [`20260815-010035_fill-ales109-lotus-insert-silence.md`](20260815-010035_fill-ales109-lotus-insert-silence.md) · [`20260815-020930_fill-ales120-lotus-stereo-duplicate.md`](20260815-020930_fill-ales120-lotus-stereo-duplicate.md) · [`20260815-021904_fill-ales122-lotus-stereo-silence-span.md`](20260815-021904_fill-ales122-lotus-stereo-silence-span.md)

---

## Where the ladder stands

The stereo edit family now carries the destructive span-edits (cut, crop, move), the growth edit that repeats a span (duplicate), the overwrite paste (paste_over), and the length-preserving span-silence (silence_span). Mono **insert_silence** (ALES109) — the *Insert → Silence* gesture, open `count` samples of quiet at `at`, shifting the tail right so the clip GROWS and every existing sample is KEPT — still has no stereo twin. It is the growth-twin of the silence just landed at ALES122: where `stereo_silence_span` writes zeros over an existing span and the length HOLDS, `stereo_insert_silence` opens new zero seats and the length GROWS — silence written in place versus silence made room for.

## The crux this round

`stereo_insert_silence(sc, at, count)` opens `count` silent samples at `at` in both channels, reusing ALES109's mono `insert_silence` per channel with the same `at` and `count`. Mono insert_silence can fault with `BadRange` (an insertion point past the samples) or `ClipFull` (a grow past the fixed buffer). Both channels enter equal-length over the same fixed buffer (`buf.len == max_clip`), so the three checks are made once against the shared length up front, so once they pass each mono insert_silence is pre-validated to succeed and a refusal never desynchronises the channels:

- `at > len` → `BadRange`
- `count > max_clip - len` → `ClipFull`

It reuses ALES2's `EditError` whole and invents no fault of its own.

## The four laws proven

- **THE STEREO INSERT LAW** — the left channel equals mono `insert_silence(left, at, count)` and the right equals mono `insert_silence(right, at, count)`, each byte for byte; both grown by exactly `count`, the opened gap all zero and every existing sample kept.
- **THE BALANCE / INVARIANT LAW** — `left.len == right.len` after the edit, both grown by exactly `count`; the stereo image stays aligned because the same span opens at the same place in both channels.
- **THE INVERSE LAW** — `stereo_insert_silence(at, count)` then ALES117's `stereo_cut(at, count)` returns both channels to the original byte for byte — insert_silence is the EXACT inverse of cut, the lossless round-trip (open a gap, then remove exactly that gap, and nothing is lost), lifted from mono ALES109 into stereo.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal leaves BOTH channels byte for byte untouched and still balanced; `count = 0` the identity on both, `at = 0` opening at the head and `at = len` appending silence at the tail, a bad insertion point `BadRange`, a grow past the buffer `ClipFull`.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It opens a gap in each channel and fills it with silence — the one thing it writes that was not already there, and silence is the honest content of a gap a keeper opened on purpose; it invents no non-zero sample, drops nothing, and reads no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_insert_silence.rye` — the module.
- `tools/ales_stereo_insert_silence_witness.rish` — the witness.
