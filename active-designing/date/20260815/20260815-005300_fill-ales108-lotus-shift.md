# Fill ALES108 — the Lotus shift (the grid nudge, rotate's honest drop-and-zero-fill twin)

**Stamp:** `20260815.005300` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES108**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES106`](20260815-003935_fill-ales106-lotus-rotate.md) · [`fill ALES107`](20260815-004633_fill-ales107-lotus-nyquist.md)
**Stands on:** `lotus/timeline.rye` (ALES2 — the Clip, its `buf`/`len`/`samples`) · `lotus/rotate.rye` (ALES106 — the cyclic shift, imported by the selftest to prove the wrap-vs-drop contrast) · `lotus/meter.rye` (ALES13 — the peak/RMS meter, to witness that dropping samples never raises the peak)

## Why this rung, now

ALES106 (rotate) slides the whole clip and **wraps** the samples that fall off the edge back onto the far end — a permutation, exact and invertible. This rung names its honest twin: **shift**, which slides the clip and **drops** the samples that fall off the edge, filling the vacated end with silence. That is the plainest edit a keeper makes on a timeline — the **grid nudge**, moving a clip a few samples earlier or later so it lands on the beat, so a stereo pair aligns, so a doubled take sits behind the lead. Every DAW ships it.

Shift is Lindy because it is the *other* reading of "move the clip by `k`," and naming it beside rotate teaches the one distinction that matters: **wrap or drop.** Rotate keeps every sample and reorders; shift keeps every *position's* meaning (time) and lets the edges go to silence. The pair is the whole truth about translating a bounded signal.

## The shape

`lotus/shift.rye` exposes `shift(clip, by)` — `by` a signed `i32`, **negative** shifting the clip *left* (earlier), **positive** shifting it *right* (later). It moves the samples in place in the safe direction (a right shift copies back to front, a left shift copies front to back, so no sample is overwritten before it is read), then writes silence into the vacated span. A `by` whose magnitude reaches or passes the length pushes the whole clip out of frame, leaving all silence. `by == 0`, and any clip of length 0 or 1 shifted by 0, return untouched. One in-place pass bounded by `len`, no allocation, no second buffer; the length is never changed and no byte past `len` is read or written.

## The crux — four laws

1. **The shift law.** After `shift(clip, k)` with `k > 0`, sample `j` holds `original[j − k]` for `j ∈ [k, len)` and `0` for `j ∈ [0, k)`; with `k < 0` (write `m = −k`), sample `j` holds `original[j + m]` for `j ∈ [0, len − m)` and `0` for `j ∈ [len − m, len)`. The length is unchanged. Proven against hand-shifted vectors in both directions.
2. **The rotate-contrast law** — the crux that ties this rung to ALES106. `shift(clip, −k)` and `rotate_left(clip, k)` **agree exactly** on the `len − k` samples that stay in frame (both hold `original[i + k]` there) and **differ only** at the vacated `k`-sample tail — where rotate wraps the original head and shift writes silence. Proven by running both on one clip and reading the interior identical, the tail wrapped-vs-zero.
3. **The composition-loss law** — the honest counterpoint to rotate's clean invertibility. Shift is **not** invertible in general: `shift(k)` then `shift(−k)` returns the leading `k` samples as **silence**, not their original bytes, because the dropped samples are truly gone. A clip whose shifted-off region was **already silence** round-trips exactly — the only case that recovers. Proven both ways.
4. **The magnitude / silence law.** Shift replaces dropped samples with silence, so the peak magnitude re-measured through ALES13 is **non-increasing** (`≤` the original peak); a shift that drops only zero samples leaves the peak unchanged. `shift(clip, 0)` is the identity, and a `by` with `|by| ≥ len` yields an all-silent clip (every sample pushed out of frame). The empty clip is its own shift for any `by`.

## Bounds and laws

- In place, one pass bounded by `len`, no allocation and no second buffer; the copy direction is chosen so no live sample is overwritten before it is read.
- `by` is a signed `i32`; its magnitude is clamped to `len` before any work, so the vacated span is always a legal sub-range and `shift` forwards no `EditError` — total on any legal `Clip`.
- The postcondition asserts the length is exactly unchanged and the bound still holds — shift reseats samples and fills silence, never the count.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It reseats existing samples and fills the vacated end with **silence** (zero) — the one thing it writes that was not already there, and silence is the honest content of an edge a clip was nudged away from; it invents no non-zero sample, changes no length, and reads no byte past `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*Rotate carries the edge around to the other side; shift lets it go and leaves silence where it stood. The one wraps and keeps everything, the other drops and forgets — two honest readings of the same small nudge, and a keeper who knows which they hold knows exactly what their timeline will do.*
