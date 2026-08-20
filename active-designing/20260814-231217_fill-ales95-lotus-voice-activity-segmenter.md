# Fill ALES95 — the Lotus voice-activity segmenter (classify across frames)

**Stamp:** `20260814.231217` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES95**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`waymark ladders`](../.claude/rules/waymark-ladders.md)
**Stands on:** `lotus/voiced.rye` (ALES94 — the voiced/unvoiced/silent classifier over one span) · `lotus/timeline.rye` (ALES2 — the Clip) · `lotus/schmitt.rye` (ALES92 — the band-and-span precheck) · `lotus/meter.rye` (ALES13 — the RMS energy)

---

## Why this rung, now

ALES94 answered the oldest question in speech processing over **one span**: is this frame voiced, unvoiced, or silent? Its own honest-scope note named the next rung plainly — *"a real voice-activity detector adds hysteresis over time"* — a classifier reads a single window; a **segmenter** reads a whole clip as a sequence of windows and reports where each kind of sound begins and ends. That is the Lindy-durable next crux: every voice-activity gate, every silence trimmer, every auto-splitter in a hundred years of audio editing is exactly this loop — classify each frame, then coalesce neighbouring frames of the same verdict into runs.

The crux, crux-first: the segmenter **invents no new measurement**. Its segmentation equals a decision built BY HAND from repeated ALES94 `classify` calls over consecutive frames, coalesced. So it can never drift from the classifier it composes, exactly as ALES94 can never drift from the two readers it fuses and ALES93 can never drift from the trigger it counts. The whole family stays a tower of readers, each one provably its predecessor's own answer read a new way.

## The shape

`segment(clip, out, start, count, frame_len, t_low, t_high, silence_floor, voice_split)` splits `[start, count)` into consecutive frames of exactly `frame_len` samples, classifies each frame through ALES94, and writes the coalesced runs into `out`:

- **A `Segment`** is `{ verdict, start, count }` — one contiguous run of frames that all classified the same. Its `start` is the first frame's start; its `count` is the summed length of the frames it holds (always a whole multiple of `frame_len`).
- **`Segments`** holds a bounded `items` array and a `len`. Written through an out-pointer, the same discipline every Lotus writer keeps (`splice(&clip, …)`, `feed(&m, …)`), so no large struct is returned by value.
- **The energy gate is still first**, per frame, because it is `classify` doing the classifying — the segmenter only sequences and coalesces.

## Bounds (every one named)

- `max_segments = timeline.max_clip` (4096) — the worst case is one segment per single-sample frame over the largest clip, so any legal span is representable and `SegmentsFull` can be raised honestly even though it cannot fire under this bound.
- `frame_len` must be `≥ 1`, must be `≤ count`, and must divide `count` evenly — a ragged final frame is refused `BadFrame` rather than silently classified short. A clean, checkable invariant a keeper can reason about.
- The whole `[start, count)` span and the band are validated once up front through ALES92's `precheck` (`BadRange` / `BadThreshold`), and the floor against the peak ceiling (`BadFloor`), before a single frame is read — on refusal nothing is written and `out` is untouched.

## Errors (reused by name)

`SegmentError = voiced.ClassifyError || error{ BadFrame, SegmentsFull }` — the classifier's faults are the segmenter's faults, reused by name so the segmenter never invents an error the classifier does not raise, plus one for an illegal frame length and one for the (unreachable-under-bound, still-honest) segment overflow.

## The invariants the witness proves

1. **Coverage.** The segments tile `[start, count)` exactly — contiguous, non-overlapping, the sum of their counts equal to `count`, the first starting at `start`.
2. **Coalescing.** No two adjacent segments carry the same verdict (they would have been one run).
3. **The crux.** Over many spans, frame lengths, floors, and splits, the segmentation equals a hand-built loop of ALES94 `classify` calls coalesced — the segmenter is the sequencing rule, not a fourth reader that could disagree.
4. **Read-only.** The source clip is byte-for-byte unchanged after segmenting.
5. **A single-frame span** yields exactly one segment whose verdict equals `classify` over that span.
6. **Refusals by name.** A zero frame length, a ragged span, an inverted band, an out-of-range span, and an illegal floor each refuse by their own name, the clip untouched.

## Honest scope

Software only, purely local, read-only. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`, never mutated. The output is a run-length label sequence over one clip — **not** a transcript, not a diarization, not a phoneme boundary. A real voice-activity detector adds adaptive floors, spectral tilt, and smoothing hysteresis this rung does not; those are later rungs. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*A classifier names one moment; a segmenter reads the whole tape and says where each sound lives. May ALES95 stay exactly its own classifier, read across time.*
