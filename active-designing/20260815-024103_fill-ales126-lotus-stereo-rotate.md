# Fill ALES126 — `lotus/stereo_rotate.rye`, the cyclic turn of a master in stereo

**Stamp:** `20260815.024103` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES126**
**Kin:** [`20260815-003935_fill-ales106-lotus-rotate.md`](20260815-003935_fill-ales106-lotus-rotate.md) · [`20260815-023515_fill-ales125-lotus-stereo-reverse.md`](20260815-023515_fill-ales125-lotus-stereo-reverse.md) · [`20260815-023038_fill-ales124-lotus-stereo-shift.md`](20260815-023038_fill-ales124-lotus-stereo-shift.md)

---

## Where the ladder stands

ALES125 opened the stereo suite's **pure rearrangement** class with `stereo_reverse` — every position changing, no value. It named the class's three still-to-lift members: the value-mirror (**invert**), the cyclic shift (**rotate**), and the parity flip (**nyquist_flip**). This rung lifts the second of them — **rotate**, ALES106's cyclic left-shift, the loop-aligning gesture behind every *rotate the loop to the downbeat* and every phase-aligned wavetable. It is the closest companion to reverse: a permutation, exact by construction, standing on the very same swap primitive.

## The crux this round

`stereo_rotate_left(sc, by)` cyclic-left-shifts both channels of a `StereoClip` by the **same** `by` samples, reusing ALES106's mono `rotate_left` per channel. Mono rotate reduces the shift modulo each channel's length, so any `by` is legal — an over-long shift is the equivalent short one — and it names no out-of-range span, so it is **total** and raises no fault. Because both channels enter equal-length, both reduce the same `by` against the same length, both reseat in place, and both hold their length, the lift needs no validation and can never refuse; the function is `void`. One `by` for both channels, because a stereo master is rotated to the downbeat as one thing — the loop swings in both speakers together, the stereo image intact.

## The four laws proven

- **THE STEREO ROTATE LAW** — the left channel equals mono `rotate_left(left, by)` and the right equals mono `rotate_left(right, by)`, each byte for byte against a hand-rotated vector; result index `j` holds original `(j + by) mod len`, per channel, the front `by` samples moving to the tail.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — rotate reseats samples cyclically, never the count, so the stereo image stays aligned.
- **THE MODULAR / COMPOSITION-AND-INVERSE LAW** — rotating by 0, by len, or by a full turn is the identity on both channels, and `rotate(k)` equals `rotate(k mod len)`, so no over-long shift is out of range; `stereo_rotate_left(k1)` then `(k2)` equals `(k1+k2)`, and `(k)` then `(len−k)` returns both channels to the byte — every rotation's inverse another rotation, so a keeper who over-rotates a master rotates the rest of the way home.
- **THE PERMUTATION / FIXPOINT LAW** — rotate is a pure rearrangement, so each channel's peak magnitude re-measured through ALES13 is unchanged (no value moves, only its seat); an empty stereo pair and a single-sample pair are each their own rotation for any shift.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It reseats existing samples cyclically in each channel and fabricates none; it changes no length and reads no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_rotate.rye` — the module.
- `tools/ales_stereo_rotate_witness.rish` — the witness.
