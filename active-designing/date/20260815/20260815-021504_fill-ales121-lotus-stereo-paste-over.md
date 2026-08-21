# Fill ALES121 — `lotus/stereo_paste_over.rye`, the overwrite paste carried into stereo

**Stamp:** `20260815.021504` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES121**
**Kin:** [`20260815-013334_fill-ales114-lotus-paste-over.md`](20260815-013334_fill-ales114-lotus-paste-over.md) · [`20260815-014739_fill-ales116-lotus-stereo-replace.md`](20260815-014739_fill-ales116-lotus-stereo-replace.md) · [`20260815-020930_fill-ales120-lotus-stereo-duplicate.md`](20260815-020930_fill-ales120-lotus-stereo-duplicate.md)

---

## Where the ladder stands

The stereo edit family has grown steadily: **stereo_replace** (ALES116), **stereo_cut** (ALES117), **stereo_crop** (ALES118), **stereo_move** (ALES119), and **stereo_duplicate** (ALES120) all run a proven mono edit on both channels of a `StereoClip` in lockstep, keeping the defining invariant — left and right hold the **same length** so the two speakers stay aligned in time.

Mono **paste_over** (ALES114) — the Overwrite paste mode, write a payload *on top of* a span while the length HOLDS — still has no stereo twin. Its insert-cousin `splice` was lifted through `stereo_replace`'s general case; the overwrite mode itself deserves its own rung, so a keeper can punch a clean stereo take over a flubbed bar without moving anything after it.

## The crux this round

`stereo_paste_over(sc, at, left_src, right_src)` writes `left_src` over `[at, at+left_src.len)` in the left channel and `right_src` over the same span in the right, reusing ALES114's mono `paste_over` per channel. Because a stereo payload names **one** span across both channels, the two sides must be the **same length** — an unequal pair names inconsistent spans and refuses `BadRange`. Mono `paste_over` keeps each channel's length, so balance is preserved trivially; the up-front validation exists to keep the *edit* coherent and to refuse before either channel mutates:

- `left_src.len != right_src.len` → `BadRange`
- `left_src.len > max_clip` → `BadRange` (bound the caller slice)
- `at > len` → `BadRange`
- `count > len - at` → `BadRange`

Once those pass, each mono paste_over is pre-validated to succeed. It reuses ALES2's `EditError` whole and invents no fault of its own.

## The four laws proven

- **THE STEREO OVERWRITE LAW** — the left channel equals mono `paste_over(left, at, left_src)` and the right equals mono `paste_over(right, at, right_src)`, each byte for byte; every sample outside the span unchanged.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — overwrite writes values only, never resizing, so the stereo image stays aligned.
- **THE INSERT-CONTRAST LAW** — the same payloads at the same `at` **keep** the length here and **grow** both channels through `stereo_replace` with `count = 0` (the insert twin), the two paste modes side by side.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal leaves BOTH channels byte for byte untouched and still balanced; empty payloads the identity on both, mismatched payloads `BadRange`, a paste past the samples `BadRange`.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It writes caller-supplied samples over an existing span in each channel — changing no length, inventing no sample, reading no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_paste_over.rye` — the module.
- `tools/ales_stereo_paste_over_witness.rish` — the witness.
