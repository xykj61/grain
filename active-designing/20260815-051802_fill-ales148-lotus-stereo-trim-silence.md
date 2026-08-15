# Fill ALES148 — Lotus's stereo_trim_silence: the silence stripper carried into stereo, the first stereo edit built on the segmenter

**Stamp:** `20260815.051802` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES148
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-050741_fill-ales147-lotus-stereo-segment.md`](20260815-050741_fill-ales147-lotus-stereo-segment.md)

---

## The next crux, honestly chosen

ALES147 carried the voice-activity segmenter into stereo — two channels read apart, each into its own run-length label sequence, writing not one sample. ALES96 (`trim_silence`) is the mono edit built directly on the segmenter: segment the clip, cut every `.silent` run, leave the sound contiguous. Ascending mono-ALES order after ALES95 (segment → ALES147) names ALES96 next, and it is also the Lindy-first crux: it turns the analysis corner's first reader back into the suite's first stereo edit that *composes* an analysis result rather than mapping a sample.

## The wall a stereo trim meets, and the honest rule

Every stereo edit so far ran the proven mono edit twice — one shared setting, per-channel independence, the two channels naturally staying balanced because the edit wrote *values* (a gain, a clip, a rail) and never changed length. `trim_silence` changes length. And ALES147 just proved the two channels' silences are **independent** — they differ in count and boundary. Run the mono trimmer on each channel apart and the left could lose two frames while the right loses one: the two speakers end at different lengths, and the stereo image tears.

So this rung cannot run the mono trimmer twice. It must decide **one cut for both**. The honest rule is the **silence intersection**: a frame is dead air only where **neither** speaker carries sound, so cut a frame only where it is `.silent` in **both** channels, and cut it from both in lockstep. A frame quiet on the left yet loud on the right is real audio — a sound panned hard left — and the right's silence must never delete it. Union would delete real content; intersection keeps every frame either speaker fills. This is exactly how a real stereo silence trimmer must behave.

## The shape

`stereo_trim_silence(sc, frame_len, t_low, t_high, silence_floor, voice_split)`:

1. Segment **both** channels once through ALES147's `segment_stereo` over one shared frame grid — read-only, all validation up front (band/span precheck, floor ceiling, dividing frame length, empty-clip `BadFrame`). On refusal both channels are untouched.
2. **Forward pass** — walk the frames, advancing one monotonic cursor per channel across its own tiling run list, and mark a bounded jointly-silent mask (`[max_clip]bool`, sized once) only where the frame is `.silent` in both channels. Count the jointly-silent samples for the exact length postcondition.
3. **Backward pass** — cut every marked frame from both channels through ALES2's `cut`, back to front so earlier frame indices stay valid, the in-bounds span asserted before each cut so neither can fault and leave the pair half-trimmed.

`StereoTrimError = stereo_segment.StereoSegmentError || timeline.EditError` — reused whole, no new fault.

## The four laws proven

- **The stereo trim law (the crux):** the result equals a by-hand keep of the frames NOT jointly-silent, per channel — a second, independent implementation (frame verdicts read by run scan) — across five frame lengths, four floors, three splits, both channels leaving equal length.
- **The preservation law:** a frame quiet on the left yet loud on the right is kept on both; only the jointly-silent frame is removed and its gap closed.
- **The lockstep law:** the reason the rung exists — running the proven mono `trim_silence` per channel desyncs the pair (left 8, right 12) where the stereo trim holds both at 12.
- **The atomicity / degenerate law:** an all-jointly-silent master trims to empty on both; a master loud on at least one channel per frame is unchanged on both; an empty clip, a ragged frame length, an inverted band, and an illegal floor each refuse by name with both channels untouched and still balanced.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips edited only by removing whole jointly-silent frames through `cut`, in lockstep — fabricating no samples, reordering nothing. NOT a transcript or a real adaptive VAD; no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
