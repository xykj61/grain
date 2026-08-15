# Fill ALES149 — Lotus's stereo_split_silence: the auto-splitter carried into stereo, one cut line for both channels

**Stamp:** `20260815.052853` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES149
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-051802_fill-ales148-lotus-stereo-trim-silence.md`](20260815-051802_fill-ales148-lotus-stereo-trim-silence.md)

---

## The next crux, honestly chosen

ALES148 carried the silence *stripper* into stereo — remove every jointly-silent frame from both channels in lockstep, leaving the audio contiguous and the stereo image balanced. Its mono twin, ALES96 `trim_silence`, has a twin of its own: ALES97 `split_silence`, the auto-splitter — cut *at* the silence and keep each non-silent region as its own take. Ascending mono-ALES order after ALES96 names ALES97 next, and it is the Lindy-first crux: the twin gesture every recorder, sampler, and podcast tool ships, and the natural stereo companion to the trimmer just landed.

## The wall a stereo split meets, and the honest rule

Mono `split_silence` coalesces the segmenter's consecutive non-silent runs into takes and splits on the silent runs between them. Carried into stereo it meets exactly the wall ALES148 met: ALES147 proved the two channels' silences are **independent** — they differ in count and boundary. Split each channel by its own silence and the left could name three takes where the right names two; the two speakers would be cut at different sample positions, and every take would tear the stereo image apart.

So this rung cannot split each channel by its own silence. It must decide **one cut line for both**, and it is the same **silence intersection** ALES148 proved: a moment is dead air only where **neither** speaker carries sound, so a split falls only where a frame is `.silent` in **both** channels. A stereo take is a maximal span of frames that is **not** jointly-silent — a region either speaker fills — cut identically from both channels, so every take is a balanced StereoClip.

## The shape

`split_stereo_on_silence(sc, out, frame_len, t_low, t_high, silence_floor, voice_split)`:

1. Segment **both** channels once through ALES147's `segment_stereo` over one shared frame grid — read-only, all validation up front (band/span precheck, floor ceiling, dividing frame length, empty-clip `BadFrame`). On refusal `out` is left empty.
2. **Forward pass** — walk the frames, advancing one monotonic cursor per channel across its own tiling run list (the same walk ALES148 uses), decide each frame jointly-silent only where it is `.silent` in both channels, and coalesce every maximal span of consecutive **not**-jointly-silent frames into one `StereoTake{start, count}` span into both channels.

`stereo_take_clip(src, out, index, dst)` materializes the `index`-th take into a fresh StereoClip by copying **both** channels' samples over that shared span through ALES2's `splice`, so the take stays balanced.

`StereoSplitError = stereo_segment.StereoSegmentError || timeline.EditError || error{TakesFull}` — the segmenter's and editor's faults reused whole, `TakesFull` named for the honest bounded path (`max_stereo_takes` equals the segmenter's own run ceiling, so it cannot be exceeded).

## The laws proven

- **The stereo take law (the crux):** the index-th take clip equals the original's samples over its shared span on **both** channels, and `out.len` equals the count of not-jointly-silent regions — proven against a second, independent by-hand implementation (frame verdicts read by run scan, coalesced by hand) across many frame lengths, floors, and splits; every take balanced (left span equals right span).
- **The join law:** concatenating every take clip in order, per channel, equals ALES148's `stereo_trim_silence` on the same signal byte for byte — the trimmer joins the not-jointly-silent frames, the splitter keeps them apart, and re-joining the splitter's pieces returns exactly the trimmer's clip. This binds ALES149 to ALES148 the way ALES97 is bound to ALES96.
- **The preservation / lockstep law:** a frame silent on only one channel keeps the open take running (the region spans it), so a hard-panned sound never forces a false split; per-channel mono split would desync the take boundaries where this holds them identical on both.
- **The degenerate / atomicity laws:** an all-jointly-silent master yields zero takes; a master loud on at least one channel per frame yields one whole-clip take; the source is byte-for-byte unchanged (read-only); an empty clip, a ragged frame length, an inverted band, and an illegal floor each refuse by name — `BadFrame`, `BadFrame`, `BadThreshold`, `BadFloor` — `out` left empty.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips read through the split, `stereo_take_clip` writing only fresh balanced destination clips by copying whole not-jointly-silent samples through `splice` — fabricating no samples, reordering nothing. NOT a transcript, not a diarizer, not a real adaptive VAD; no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
