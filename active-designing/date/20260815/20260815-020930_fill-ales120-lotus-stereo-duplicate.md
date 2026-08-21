# Fill ALES120 — `lotus/stereo_duplicate.rye`, the growth-twin carried into stereo

**Stamp:** `20260815.020930` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES120**
**Kin:** [`20260815-011901_fill-ales112-lotus-duplicate.md`](20260815-011901_fill-ales112-lotus-duplicate.md) · [`20260815-020325_fill-ales119-lotus-stereo-move.md`](20260815-020325_fill-ales119-lotus-stereo-move.md)

---

## Where the ladder stands

The stereo edit family has been lifting the mono span-edits one at a time, each rung running a proven mono edit on both channels of a `StereoClip` in lockstep: **stereo_replace** (ALES116), **stereo_cut** (ALES117), **stereo_crop** (ALES118), **stereo_move** (ALES119). Each keeps the defining `StereoClip` invariant — left and right hold the **same length** so the two speakers stay aligned in time — by validating both channels before mutating either, so a refusal can never desynchronise them.

Mono **duplicate** (ALES112) still has no stereo twin. It is the growth-twin of crop: circle a bar, press Duplicate, and a second copy lands immediately after the first — the doubled drum loop, the repeated chorus. Where cut/crop/move keep the sample count or reduce it, duplicate **grows** the clip by exactly the span. Carrying it into stereo completes the growth side of the family.

## The crux this round

`stereo_duplicate(sc, start, count)` inserts a second copy of `[start, start+count)` immediately after the span in **both** channels, reusing ALES112's mono `duplicate` per channel over its public API. Both channels enter equal-length and share the same fixed buffer (`timeline.max_clip`), so mono duplicate's two fault modes — `BadRange` (a span outside the samples) and `ClipFull` (a grow past the fixed buffer) — depend only on the shared length and are checked **once up front**:

- `start > len` → `BadRange`
- `count > len - start` → `BadRange`
- `count > max_clip - len` → `ClipFull` (the grow would overrun)

Once those pass, each mono duplicate is pre-validated to succeed, so no refusal can land between the two channel edits and leave one grown and the other not. It reuses ALES2's `EditError` whole and invents no fault of its own.

## The four laws proven

- **THE STEREO DUPLICATE LAW** — the left channel equals mono `duplicate(left, start, count)` and the right equals mono `duplicate(right, start, count)`, each byte for byte; both grow by `count`.
- **THE BALANCE / INVARIANT LAW** — `left.len == right.len` after the edit, both grown by exactly `count`, the stereo image staying aligned.
- **THE INVERSE LAW** — `stereo_duplicate(start, count)` then a stereo cut of `count` at `end = start+count` (ALES117's `stereo_cut`) returns both channels to the original byte for byte — the inserted copy removed exactly.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal leaves BOTH channels byte for byte untouched and still balanced; `count = 0` the identity on both, a bad range `BadRange`, a grow past the buffer `ClipFull`.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It opens a gap in each channel through the proven mono duplicate and fills it with a copy of an existing span — inventing no sample, changing no value it keeps, reading no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_duplicate.rye` — the module.
- `tools/ales_stereo_duplicate_witness.rish` — the witness.
