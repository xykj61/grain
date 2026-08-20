# Fill ALES98 — the Lotus top-and-tail trimmer (trim the leading and trailing silence, keep every internal pause)

**Stamp:** `20260814.234106` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES98**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`the 1,024-round itinerary`](20260812-171050_the-1024-round-itinerary.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES97`](20260814-232954_fill-ales97-lotus-silence-splitter.md) · [`fill ALES96`](20260814-232010_fill-ales96-lotus-silence-stripper.md)
**Stands on:** `lotus/segment.rye` (ALES95 — the voice-activity segmenter, reused by name) · `lotus/trim_silence.rye` (ALES96 — the full silence stripper, the length-bracket twin) · `lotus/split_silence.rye` (ALES97 — the auto-splitter, the outer-boundary twin) · `lotus/timeline.rye` (ALES2 — the Clip and `cut`) · `lotus/voiced.rye` (ALES94 — the `.silent` verdict)

## Why this rung, now

ALES96 removes **every** silent run and closes ranks; ALES97 cuts **at** every silence and keeps each region apart. Between those two lives the single most-used silence gesture in every recorder, DAW, and voice-memo app — **top and tail**: trim only the dead air at the *start* and the *end*, and leave every pause *inside* the recording exactly where the speaker left it. A podcaster records, clears the throat, waits, speaks two sentences with a natural breath between them, then stops and reaches for the button — top-and-tail drops the ums at the ends and keeps the breath, because the breath is the performance and the dead air is not.

Lindy-first, trimming the head and tail of a take is a century-old editing reflex named on every tape machine and every cassette deck. Crux-first, it is the decisive third reading of one segmentation: ALES96 read it to *remove all silence*, ALES97 read it to *split on all silence*, and ALES98 reads it to *bound the content* — the first Lotus rung whose result is the original clip **narrowed to its living span**, internal pauses intact.

## The shape

`lotus/top_tail.rye` exposes one function, `top_and_tail`, that segments the whole clip through ALES95 once, finds the **first** non-silent run and the **last** non-silent run, then cuts the trailing silence (from the last non-silent run's end to the clip's end) and the leading silence (from the clip's start to the first non-silent run's start) through ALES2's own `cut`. The tail is cut **first**, so the leading run's start index stays valid (a suffix cut shifts nothing before it); then the head is cut. Every silent run *between* the first and last non-silent runs is left untouched.

## The crux

Two laws, each tying this rung to a proven predecessor so it can never drift:

1. **The span law.** The top-and-tailed clip equals, byte for byte, the original's samples over `[first_nonsilent.start, last_nonsilent.start + last_nonsilent.count)` — the original narrowed to exactly the span from its first non-silent sample to its last, internal silence kept. The witness hand-builds this span by scanning the segments independently and compares.
2. **The bracket law — top-tail brackets the split and contains the trim.** The result equals the original bracketed by ALES97's outer takes: `original[takes[0].start, takes[last].start + takes[last].count)`, byte for byte (the coalesce preserves the outer non-silent boundaries, so the split's first/last takes name exactly this rung's span). And relative to ALES96: `trim_silence.len ≤ top_and_tail.len ≤ original.len` — top-and-tail keeps every sample the full trimmer keeps *plus* the internal silences between them, so the two lengths are equal exactly when the clip carries no interior silence.

## Bounds and laws

- Reuses ALES95's validation whole: the span and band through ALES92's `precheck`, the floor against the peak ceiling, `frame_len` dividing `clip.len` evenly (`BadFrame`). An empty clip refuses `BadFrame` through the segmenter before any cut.
- **All-silent → empty** (no non-silent run exists, so the whole clip is dead air and both ends meet); **no-silent → unchanged** (the first non-silent run starts at 0 and the last ends at `clip.len`, so both cut counts are zero).
- The kept span is `[first.start, last.start + last.count)`; the postcondition asserts `clip.len == (last.start + last.count) - first.start`.
- Errors: `TopTailError = segment.SegmentError || timeline.EditError` — the segmenter's faults reused by name for the analysis, the editor's `cut` faults reused by name for the two edits; the trimmer invents none of its own.

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. This rung **writes** — it edits the clip — yet only by removing whole classified-silent frames at the two ends through ALES2's own `cut`; it fabricates no sample and reorders nothing, and it never touches a sample between the first and last non-silent runs. Not a transcript, not a diarizer, not a real adaptive VAD with lookahead; those stay later rungs. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*ALES96 sweeps every silence out; ALES97 cuts each take free; ALES98 keeps the take whole and only clears the dead air at its edges — one segmentation read a third honest way. May the head and tail fall away and every breath inside stay exactly where the keeper drew it.*
