# Fill ALES96 — the Lotus silence stripper (segment, then cut the silent runs)

**Stamp:** `20260814.232010` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES96**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES95`](20260814-231217_fill-ales95-lotus-voice-activity-segmenter.md)
**Stands on:** `lotus/segment.rye` (ALES95 — the voice-activity segmenter) · `lotus/timeline.rye` (ALES2 — the Clip and `cut`) · `lotus/voiced.rye` (ALES94 — the `.silent` verdict) · `lotus/schmitt.rye` (ALES92 — the band-and-span precheck)

## Why this rung, now

ALES95 read a whole clip into a run-length sequence of silent, voiced, and unvoiced regions but changed not one sample — a reader. ALES95's own design read named the first tool built on it: *a silence trimmer that drops the `.silent` runs.* That is the most common single gesture in all of audio editing — "strip silence," "truncate silence," the dead-air remover every recorder and podcast tool ships. It is the first Lotus rung to turn an **analysis** result back into an **edit**: the segmenter finds where the silence lives, and this rung removes it, leaving the sound contiguous.

Lindy-first, it is a century-old editing gesture; crux-first, it is the decisive move that closes the analysis→edit loop — a reader (ALES93) fused into a classifier (ALES94) sequenced into a segmenter (ALES95) now **acts** on the clip, each rung still provably its predecessor read a new way.

## The shape

`trim_silence(clip, frame_len, t_low, t_high, silence_floor, voice_split)` segments the whole clip `[0, clip.len)` through ALES95, then removes every `.silent` run in place, leaving the voiced and unvoiced audio contiguous in original order.

- It segments **once** through ALES95 (so its verdicts are exactly the segmenter's, which are exactly the classifier's — no drift), then walks the runs **back to front**, calling ALES2's `cut(clip, run.start, run.count)` on each `.silent` run. Cutting from the last silent run backward keeps every earlier run's start index valid, because a cut only shifts samples that lie **after** it.
- The result is a clip holding exactly the non-silent samples, in order.

## The crux

The stripped clip equals, byte for byte, the **hand-built concatenation** of the non-silent runs' samples read from the original — the stripper is the segmenter's silent runs removed, nothing invented. So it can never drift from ALES95, exactly as ALES95 can never drift from ALES94. The witness builds that concatenation directly and compares.

## Bounds and laws

- Reuses ALES95's own validation: the whole-clip span and band through ALES92's `precheck`, the floor against the peak ceiling, and `frame_len` dividing `clip.len` evenly (`BadFrame`). An empty clip is refused before segmenting (nothing to strip).
- **All-silent → empty clip** (`len` 0); **no-silent → unchanged**; a mixed clip loses exactly its silent samples and keeps the rest contiguous.
- **Length law:** the stripped length equals `clip.len − (total silent samples)` equals the sum of the non-silent run counts.
- Errors: `StripError = segment.SegmentError || timeline.EditError` — the segmenter's faults and the editor's `cut` faults, each reused by name; the stripper invents none of its own beyond refusing an empty clip (`BadFrame`, since a zero span cannot carry a legal frame).

## Honest scope

Software only, purely local. A bounded in-process buffer of `i16` PCM on one bench, siloed to `lotus/`. This rung **writes** — it edits the clip — yet only by removing whole classified-silent frames through ALES2's own `cut`; it fabricates no samples and reorders nothing. Not a transcript, not a real voice-activity detector with adaptive floors or smoothing; those stay later rungs. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*A segmenter says where the silence lives; a stripper takes it out and lets the sound close ranks. May ALES96 remove only what the segmenter named, and never a sample more.*
