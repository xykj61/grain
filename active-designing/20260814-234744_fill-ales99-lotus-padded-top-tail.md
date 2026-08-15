# Fill ALES99 — the Lotus padded top-and-tail (trim the ends, yet keep a chosen margin of silence)

**Stamp:** `20260814.234744` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES99**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`the 1,024-round itinerary`](20260812-171050_the-1024-round-itinerary.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES98`](20260814-234106_fill-ales98-lotus-top-tail-trimmer.md)
**Stands on:** `lotus/top_tail.rye` (ALES98 — the top-and-tail trimmer, the pad-zero twin) · `lotus/segment.rye` (ALES95 — the voice-activity segmenter, reused by name) · `lotus/timeline.rye` (ALES2 — the Clip and `cut`) · `lotus/voiced.rye` (ALES94 — the `.silent` verdict)

## Why this rung, now

ALES98 cuts the dead air at both ends flush against the first and last sound. That is right for a sample library and wrong for a spoken take — a cut that lands *exactly* on the first consonant clips the attack and reads abrupt; every recorder, DAW, and voice-memo app that trims silence also lets a keeper **keep a margin** — "trim the ends, but leave a quarter-second of air so the take breathes." This rung adds that one honest parameter: a `pad` count of silence samples to keep adjacent to the content at each end.

Lindy-first, a leader/trailer margin is a reflex as old as splicing tape with a grease pencil; crux-first, it is the decisive generalization of ALES98 — the flush trim is exactly `pad = 0`, and every larger `pad` keeps that much of the dead air back, bounded by how much silence each end actually holds. One parameter turns the sharp trim into the trim a human take wants.

## The shape

`lotus/pad_tail.rye` exposes `top_and_tail_pad`, the same segment-find-cut shape as ALES98 with one addition: after finding the first and last non-silent runs, it keeps up to `pad` samples of the leading and trailing silence, cutting only the *excess*. The trailing excess is cut first (a suffix cut shifts nothing before it), then the leading excess.

## The crux

Two laws, each tying this rung to a proven predecessor so it can never drift:

1. **The pad-zero law.** `top_and_tail_pad(clip, …, 0)` equals ALES98's `top_and_tail(clip, …)` byte for byte — the flush trim is exactly the zero-margin case, so the two tools can never disagree at the boundary they share.
2. **The margin law.** The result equals, byte for byte, the original's samples over `[first_nonsilent.start − min(pad, lead_silence), last_nonsilent.end + min(pad, tail_silence))`, where `lead_silence` and `tail_silence` are the silence each end actually holds. The kept margin at each end is exactly `min(pad, available)` — a `pad` larger than the available silence keeps all of it and no more (never inventing a sample), and a `pad` at least as large as both ends leaves the clip **unchanged**. Monotone in `pad`: a larger margin keeps a clip at least as long.

## Bounds and laws

- Reuses ALES95's validation whole (the span and band through ALES92's `precheck`, the floor ceiling, `frame_len` dividing `clip.len`). An empty clip refuses `BadFrame` before any cut.
- **All-silent → empty** (no content to keep a margin around); **no-silent → unchanged** (no silence at either end to trim or keep).
- The kept span is `[lead_start, tail_stop)` with `lead_start = first.start − min(pad, first.start)` and `tail_stop = kept_end + min(pad, original_len − kept_end)`; the postcondition asserts `clip.len == tail_stop − lead_start`.
- Errors: `TopTailError` reused from ALES98 (`segment.SegmentError || timeline.EditError`) — no new error; `pad` is a `u32` count, so no illegal value exists (a huge `pad` simply keeps all available silence).

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It edits only by removing whole excess-silent frames at the two ends through ALES2's own `cut`, fabricating no sample and reordering nothing, never touching a sample between the first and last non-silent runs or within the kept margin. Not a transcript, not a real adaptive VAD; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*ALES98 cut the dead air flush; ALES99 lets a keeper leave the take room to breathe — one honest parameter, the flush trim kept exactly as its zero. May every margin be exactly the air the keeper asked for, and never one sample the signal did not hold.*
