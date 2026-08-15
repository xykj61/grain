# Fill ALES124 — `lotus/stereo_shift.rye`, the grid nudge carried into stereo

**Stamp:** `20260815.023038` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES124**
**Kin:** [`20260815-005300_fill-ales108-lotus-shift.md`](20260815-005300_fill-ales108-lotus-shift.md) · [`20260815-021904_fill-ales122-lotus-stereo-silence-span.md`](20260815-021904_fill-ales122-lotus-stereo-silence-span.md) · [`20260815-022429_fill-ales123-lotus-stereo-insert-silence.md`](20260815-022429_fill-ales123-lotus-stereo-insert-silence.md)

---

## Where the ladder stands

The stereo edit family now carries the destructive span-edits (cut, crop, move), both growth edits (duplicate, insert_silence), the overwrite paste (paste_over), and the in-place span-silence (silence_span). Mono **shift** (ALES108) — the *grid nudge*, slide the whole clip by `by` samples and DROP what falls off the edge, filling the vacated end with silence, the length HOLDING — still has no stereo twin. It is the plainest lift of all: mono shift is **total** (it names no out-of-range span, so it raises no fault), so lifting it needs no validation at all — a shift can never desynchronise the channels because it can never refuse.

## The crux this round

`stereo_shift(sc, by)` slides both channels of a `StereoClip` by the same signed `by`, reusing ALES108's mono `shift` per channel. Because mono shift is total and holds each channel's length, the balance invariant is preserved trivially — both channels enter equal-length, both slide by the same magnitude, both hold their length, so they leave equal-length. There is no fault to forward, no `EditError`, no `try`: the function is `void`, exactly as its mono base is. One signed `by` for both channels, because a stereo master is nudged on the grid as one thing.

## The four laws proven

- **THE STEREO SHIFT LAW** — the left channel equals mono `shift(left, by)` and the right equals mono `shift(right, by)`, each byte for byte in both directions; the surviving samples slide by `by`, the vacated end silent, every value that stays in frame kept.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — shift reseats values and fills silence, never resizing, so the stereo image stays aligned.
- **THE COMPOSITION-LOSS LAW, HONEST** — `stereo_shift(k)` then `stereo_shift(-k)` returns the leading `k` samples as SILENCE on both channels, not their bytes — shift is not invertible, the dropped edge is gone; only a stereo clip whose shifted-off region was already silence round-trips, lifted from mono ALES108 into stereo.
- **THE MAGNITUDE / DEGENERATE LAW** — the peak magnitude of each channel, re-measured through ALES13, is non-increasing (a shift that drops a loud edge strictly lowers it, a shift that drops only silence holds it); `by = 0` the identity on both, `|by| >= len` all silence on both, the empty stereo pair its own shift, balanced throughout.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It reseats existing samples in each channel and fills the vacated end with silence — the one thing it writes that was not already there, and silence is the honest content of an edge a clip was nudged away from; it invents no non-zero sample, changes no length, and reads no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_shift.rye` — the module.
- `tools/ales_stereo_shift_witness.rish` — the witness.
