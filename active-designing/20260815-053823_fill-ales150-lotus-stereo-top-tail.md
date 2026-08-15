# Fill ALES150 — Lotus's stereo_top_tail: the top-and-tail trimmer carried into stereo, one bracket for both channels

**Stamp:** `20260815.053823` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES150
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-052853_fill-ales149-lotus-stereo-split-silence.md`](20260815-052853_fill-ales149-lotus-stereo-split-silence.md)

---

## The next crux, honestly chosen

ALES148 carried the silence *stripper* into stereo, ALES149 the *auto-splitter*. Between those two mono gestures — ALES96 `trim_silence` and ALES97 `split_silence` — lives the single most-used silence move every recorder and DAW ships: ALES98 `top_tail`, top-and-tail, which drops only the dead air at the *ends* and keeps every pause inside. Ascending mono-ALES order after ALES97 names ALES98 next, and it is the Lindy-first crux: the trim removes every silence, the split keeps each region apart, and top-and-tail keeps the whole living take with its interior breath intact. Its stereo twin is the natural companion to the trimmer and splitter just landed.

## The wall a stereo top-and-tail meets, and the honest rule

Mono `top_tail` segments the clip, finds the first and last non-silent runs, and cuts only the leading and trailing silence. Carried into stereo it meets exactly the wall ALES148 and ALES149 met: ALES147 proved the two channels' silences are **independent**. Trim each channel's ends by its own silence and the left could keep `[4, 16)` where the right keeps `[16, 20)` — the two speakers cut to different lengths, the stereo image torn apart.

So this rung cannot top-and-tail each channel by its own silence. It brackets by the same **silence intersection** the trimmer and splitter use: a moment is dead air only where **neither** speaker carries sound, so the leading and trailing silence to remove is the run of **jointly-silent** frames at each end. The kept span runs from the **first** frame either speaker fills to the **last** frame either speaker fills — one bracket, cut identically from both channels, so both leave exactly as long as each other. Every interior pause — jointly-silent or not — is kept where the speaker left it.

## The shape

`stereo_top_and_tail(sc, frame_len, t_low, t_high, silence_floor, voice_split)`:

1. Segment **both** channels once through ALES147's `segment_stereo` over one shared frame grid — read-only, all validation up front (band/span precheck, floor ceiling, dividing frame length, empty-clip `BadFrame`). On refusal both channels are untouched.
2. **Forward pass** — walk the frames, advancing one monotonic cursor per channel across its own tiling run list (the same walk ALES148 uses), decide each frame jointly-silent only where it is `.silent` in both channels, and record the **first** and **last** frame index that is **not** jointly-silent.
3. If every frame is jointly silent, the whole master is dead air — cut it whole from both channels, leaving each empty.
4. Otherwise cut the trailing joint-silence (from the last not-joint frame's end to the clip's end) from both channels **first**, so the leading index stays valid, then cut the leading joint-silence (from the start to the first not-joint frame) from both — both channels in lockstep.

`StereoTopTailError = stereo_segment.StereoSegmentError || timeline.EditError` — the segmenter's and editor's faults reused whole, none invented.

## The laws proven

- **The stereo span law (the crux):** the top-and-tailed pair equals the original over `[first_not_joint.start, last_not_joint.end)` on **both** channels, both balanced, proven against a second, independent by-hand implementation (frame verdicts read by run scan, first/last found by hand) across many frame lengths, floors, and splits.
- **The bracket law:** the result equals the original bracketed by ALES149's stereo split outer takes (`take[0].start` to `take[last].end`) byte for byte on both channels, since the coalesce preserves the outer not-jointly-silent boundaries; and `stereo_trim_silence.len <= stereo_top_tail.len <= original.len` — top-tail keeps every sample the joint trim keeps PLUS the interior joint-silences, equal only when there is no interior joint-silence.
- **The preservation / lockstep law:** an interior jointly-silent frame is KEPT (where ALES148's trim removes it, so top-tail is strictly longer on a gapped master); and running the proven mono `top_tail` per channel would DESYNC the pair (the left bracketing `[4, 16)` to length 12, the right `[16, 20)` to length 4) where this brackets both by the union of the two speakers' outer content to one shared length.
- **The degenerate / atomicity laws:** an all-jointly-silent master trims to empty on both; a master loud on at least one channel per frame is unchanged on both; a head-joint-silent master loses only its head, a tail-joint-silent only its tail; an empty clip, a ragged frame length, an inverted band, and an illegal floor each refuse by name — `BadFrame`, `BadFrame`, `BadThreshold`, `BadFloor` — both channels untouched and still balanced.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips edited in lockstep, removing only whole jointly-silent frames at the two ends through ALES2's `cut` — fabricating no samples, reordering nothing, never touching a sample between the first and last not-jointly-silent frames. NOT a transcript, not a real adaptive VAD with lookahead; no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
