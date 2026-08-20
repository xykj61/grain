# Fill ALES97 — the Lotus silence splitter (cut *at* the silence, keep each region as its own take)

**Stamp:** `20260814.232954` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES97**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES96`](20260814-232010_fill-ales96-lotus-silence-stripper.md) · [`fill ALES95`](20260814-231217_fill-ales95-lotus-voice-activity-segmenter.md)
**Stands on:** `lotus/segment.rye` (ALES95 — the voice-activity segmenter, reused by name) · `lotus/trim_silence.rye` (ALES96 — the silence stripper, the join-law twin) · `lotus/timeline.rye` (ALES2 — the Clip and `splice`) · `lotus/voiced.rye` (ALES94 — the `.silent` verdict)

## Why this rung, now

ALES95's own design read named three tools its loop enables — *"every voice-activity gate, every silence trimmer, every **auto-splitter** in a hundred years of audio editing is exactly this loop."* ALES96 built the trimmer. This rung builds the **auto-splitter**, the other half of that pair and the twin gesture in every recorder, sampler, and podcast tool: **split on silence** — find where the silence lives and cut the clip *there*, so each spoken sentence, each take, each sample lands as its own separate clip.

The trimmer and the splitter read the exact same segmentation and reach opposite, complementary ends. Where **ALES96 removes the silent runs and closes ranks** into one contiguous clip, **ALES97 cuts at the silence and keeps the non-silent regions apart** as separate takes. Lindy-first, splitting a recording on its pauses is a century-old editing gesture; crux-first, it is the decisive move that turns the segmenter's one run-length sequence into *many clips a keeper can name, export, or drop* — the first Lotus rung whose result is a **list of clips**, not one.

## The shape

`split_on_silence(clip, out, frame_len, t_low, t_high, silence_floor, voice_split)` segments the whole clip `[0, clip.len)` through ALES95, then coalesces every maximal span of **consecutive non-silent runs** into one `Take` — a `{start, count}` span into the original — writing the takes in order into `out` (a bounded `Takes` list). A second call, `take_clip(clip, out, index, dst)`, materializes the index-th take into a fresh `Clip` by copying exactly the original's samples over that span through ALES2's `splice`.

- It splits **at silence**, not at every verdict change: a voiced run followed directly by an unvoiced run (no pause between) belongs to **one** take, because a keeper splits a recording on its *pauses*, not on every phoneme boundary. A take is therefore a maximal non-silent region between two silent runs (or a clip edge).
- The clip is **read-only** through the split — `Takes` names spans, it copies no sample. Copying happens only in `take_clip`, and only on demand.

## The crux

Two laws, each tying this rung to a proven predecessor so it can never drift:

1. **The take law.** The index-th take clip equals, byte for byte, the original's samples over the index-th non-silent region's `[start, start+count)`, and `out.len` equals the number of non-silent regions the segmenter names. The splitter invents no new measurement and no new sample — it is the segmenter's non-silent runs coalesced and named, nothing more.
2. **The join law — split then join equals trim.** Concatenating every take clip in order, in one clip, equals ALES96's `trim_silence` run on the same signal, byte for byte. The two tools read one segmentation to opposite ends: the trimmer joins the non-silent samples, the splitter keeps them apart, and re-joining the splitter's pieces returns exactly the trimmer's clip. This binds ALES97 to ALES96 the way ALES96 is bound to ALES95.

The witness builds both expectations directly — the hand-coalesced takes, and ALES96's trimmed clip — and compares.

## Bounds and laws

- Reuses ALES95's own validation whole: the span and band through ALES92's `precheck`, the floor against the peak ceiling, and `frame_len` dividing `clip.len` evenly (`BadFrame`). An empty clip refuses `BadFrame` through the segmenter before any take is written.
- **Takes are bounded** by `max_takes` (`≤ max_segments`, itself the clip's own sample ceiling), so a `Take` per non-silent run is always representable and `TakesFull` is an honest, unreachable-under-the-bound named path.
- **All-silent → zero takes** (`out.len` 0); **no-silent → one take** equal to the whole clip; a mixed clip yields exactly one take per non-silent region, in original order, each take's start strictly after the previous take's end (a silent run always sits between them).
- **Coverage law:** the takes' spans, concatenated, hold exactly the non-silent samples — the same samples ALES96 leaves, in the same order.
- Errors: `SplitError = segment.SegmentError || timeline.EditError` — the segmenter's faults reused by name for the split, the editor's `splice` faults reused by name for `take_clip`; the splitter invents none of its own.

## Honest scope

Software only, purely local, read-only through the split. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. The split **reads** — it names spans and mutates not one sample of the source; `take_clip` **writes** only a fresh destination clip, copying whole classified-non-silent samples through ALES2's own `splice`, fabricating nothing and reordering nothing. Not a transcript, not a diarizer, not a real adaptive VAD with smoothing or lookahead; those stay later rungs. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*A trimmer takes the silence out and lets the sound close ranks; a splitter cuts on the silence and lets each take stand alone — one segmentation read two honest ways. May ALES97 keep exactly the regions the segmenter named, and re-join to the trimmer's own clip byte for byte.*
