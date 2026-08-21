# Fill ALES151 — Lotus's stereo_pad_tail: the padded top-and-tail carried into stereo, one margin of joint silence for both channels

**Stamp:** `20260815.054529` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES151
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-053823_fill-ales150-lotus-stereo-top-tail.md`](20260815-053823_fill-ales150-lotus-stereo-top-tail.md)

---

## The next crux, honestly chosen

ALES150 carried the flush top-and-tail into stereo. Its mono twin, ALES98 `top_tail`, has a twin of its own: ALES99 `pad_tail`, the *padded* top-and-tail — trim the ends, yet keep a chosen margin of silence so a spoken take breathes rather than clipping its first consonant. Ascending mono-ALES order after ALES98 names ALES99 next, and it is the Lindy-first crux: the one honest parameter every recorder and DAW adds to its silence trim, and the natural companion to the flush stereo trim just landed.

## The wall a stereo pad meets, and the honest rule

Mono `pad_tail` keeps `min(pad, available)` of the leading and trailing silence and cuts only the excess. Carried into stereo it meets exactly the wall ALES148, ALES149, and ALES150 met: ALES147 proved the two channels' silences are **independent**. Padding each channel by its own silence would give the two speakers different margins and different lengths, and tear the stereo image apart.

So this rung keeps **one margin for both**, the leading and trailing **joint** silence — a run of frames `.silent` in both channels. The content bracket is exactly ALES150's: the span from the first frame either speaker fills to the last, the union of the two speakers' outer content. The leading joint silence is every frame before it; the trailing joint silence every frame after. Keep up to `pad` of each and cut only the excess, identically from both channels, so both leave equal length.

## The shape

`stereo_top_and_tail_pad(sc, frame_len, t_low, t_high, silence_floor, voice_split, pad)`:

1. Segment **both** channels once through ALES147's `segment_stereo` over one shared frame grid — read-only, all validation up front. On refusal both channels are untouched.
2. **Forward pass** — walk the frames, decide each jointly-silent, and record the first and last not-jointly-silent frame (the content bracket).
3. If every frame is jointly silent, the whole master is dead air — cut it whole from both channels, leaving each empty, regardless of pad (a margin needs a sound beside it).
4. Otherwise compute the leading and trailing joint silence, keep `min(pad, available)` of each, and cut the trailing excess from both channels **first**, then the leading excess — both in lockstep.

`StereoPadTailError = stereo_top_tail.StereoTopTailError` — ALES150's faults reused whole; `pad` has no illegal value.

## The laws proven

- **The pad-zero law (the crux):** `stereo_top_and_tail_pad(pad=0)` equals ALES150's `stereo_top_and_tail` byte for byte on both channels — the flush trim is exactly the zero-margin case, across many frame lengths, floors, and splits.
- **The margin law:** the result equals the original over `[content_start - min(pad, lead_joint_silence), content_end + min(pad, tail_joint_silence))` byte for byte on both channels — proven against a second, independent by-hand implementation. The kept margin at each end is exactly `min(pad, available)`; a pad larger than the available joint silence keeps all of it and no more (never inventing a sample); a pad at least as large as both ends leaves the master unchanged; monotone in pad; both channels balanced.
- **The degenerate / atomicity laws:** an all-jointly-silent master trims to empty on both whatever the pad; a no-joint-silent master is unchanged on both; an empty clip, a ragged frame length, an inverted band, and an illegal floor each refuse by name — `BadFrame`, `BadFrame`, `BadThreshold`, `BadFloor` — both channels untouched and still balanced.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips edited in lockstep, removing only whole excess-jointly-silent frames at the two ends through ALES2's `cut` — fabricating no samples, reordering nothing, never touching a sample within the content bracket or the kept margin. NOT a transcript, not a real adaptive VAD; no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
