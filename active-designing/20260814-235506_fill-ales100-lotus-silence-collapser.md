# Fill ALES100 — the Lotus silence collapser (cap every silent run to a maximum; keep the pauses, shorten them)

**Stamp:** `20260814.235506` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES100**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`the 1,024-round itinerary`](20260812-171050_the-1024-round-itinerary.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES99`](20260814-234744_fill-ales99-lotus-padded-top-tail.md)
**Stands on:** `lotus/trim_silence.rye` (ALES96 — the silence stripper, the zero-cap twin) · `lotus/segment.rye` (ALES95 — the voice-activity segmenter, reused by name) · `lotus/timeline.rye` (ALES2 — the Clip and `cut`) · `lotus/voiced.rye` (ALES94 — the `.silent` verdict)

## Why this rung, now

ALES96 removes *every* silent sample, which is right for a sample library and wrong for a spoken take — strip all the pauses and a conversation runs together, breathless, the natural rhythm gone. ALES98/99 handled the *ends*. This rung handles the *interior*, the way a podcast editor actually works: **keep the pauses, but cap the long ones.** "Truncate silence to a quarter-second" is the single most-reached-for gesture in Adobe Audition, Descript, and every voice-memo cleanup tool — it shortens dead air without deleting the breath that makes speech legible.

Lindy-first, capping a pause is as old as splicing tape and leaving a beat; crux-first, it is the decisive generalization of ALES96 — the full strip is exactly `max_silence = 0`, and every larger cap keeps that many samples of each silent run back, bounded by how long each run actually is. One parameter turns the total strip into the trim a human take wants.

## The shape

`lotus/collapse_silence.rye` exposes `collapse_silence`, the same segment-then-cut shape as ALES96 with one addition: instead of cutting each silent run whole, it keeps the first `min(run.count, max_silence)` samples of the run and cuts only the *excess*. It walks the runs **back to front** exactly as ALES96 does, so every earlier run's index stays valid — a cut shifts only the samples after it.

## The crux

Two laws, each tying this rung to a proven predecessor so it can never drift:

1. **The zero-cap law.** `collapse_silence(clip, …, 0)` equals ALES96's `trim_silence(clip, …)` byte for byte — capping every silent run to zero samples removes all the silence, which is exactly the stripper. The two tools can never disagree at the boundary they share.
2. **The cap law.** The result equals, byte for byte, the hand-built concatenation where each silent run keeps its first `min(run.count, max_silence)` samples and each non-silent run keeps all of its. A `max_silence` at least as large as the longest silent run leaves the clip **unchanged** (the identity cap keeps every pause whole). Monotone in `max_silence`: a larger cap keeps a clip at least as long.

## Bounds and laws

- Reuses ALES95's validation whole (the span and band through ALES92's `precheck`, the floor ceiling, `frame_len` dividing `clip.len`). An empty clip refuses `BadFrame` before any cut.
- **No-silent → unchanged** (no silent run to cap); **all-silent → one capped run** — the segmenter coalesces a wholly-silent clip into a single silent run, so it caps to `min(clip.len, max_silence)` (empty at cap 0, unchanged at a cap past its length), never the top-and-tail's flat "empty."
- The trimmed length is `original_len − total_excess`, where `total_excess = Σ (run.count − min(run.count, max_silence))` over the silent runs; the postcondition asserts it exactly.
- Errors: `CollapseError = trim_silence.TrimError` reused from ALES96 (`segment.SegmentError || timeline.EditError`) — no new error; `max_silence` is a `u32` count, so no illegal value exists (a huge cap simply keeps every run whole).

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. It edits only by removing whole excess-silent frames from within each silent run through ALES2's own `cut`, fabricating no sample and reordering nothing, never touching a non-silent sample or the kept head of any pause. Not a transcript, not a real adaptive VAD; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*ALES96 stripped every pause; ALES100 keeps them and shortens only the long ones — one honest cap, the full strip kept exactly as its zero. May every pause be exactly the beat the keeper asked for, and never one sample the take did not hold.*
