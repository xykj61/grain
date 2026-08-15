# Fill ALES147 — `lotus/stereo_segment.rye`, the voice-activity segmenter carried into stereo, the suite's third stereo analysis rung

**Stamp:** `20260815.050741` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES147**
**Kin:** [`20260815-045940_fill-ales146-lotus-stereo-voiced.md`](20260815-045940_fill-ales146-lotus-stereo-voiced.md) · [`20260814-231217_fill-ales95-lotus-voice-activity-segmenter.md`](20260814-231217_fill-ales95-lotus-voice-activity-segmenter.md)

---

## Where the ladder stands

Last round carried the per-span classifier into stereo (ALES146 `stereo_voiced`: two verdicts over one span). This round carries the reader that runs that classifier **across a whole clip**. ALES95's `segment` reads a span frame by frame, classifies each frame through ALES94, and coalesces neighbouring frames of the same verdict into runs — the voice-activity loop at the heart of every silence trimmer and auto-splitter. Carried into stereo, it is the suite's **third stereo analysis rung** — two segmenters reading two channels, each producing its own run-length label sequence, writing not one sample.

## The crux this round — two independent segmentations, over one shared frame grid

Each channel is segmented on **its own** frames through **one shared** frame length, band, floor, and split. So the two segmentations are **independent**: an identical-channel master (left = right) produces the **same** runs on both, while a channel that goes voiced-then-silent segments into two runs where a uniform channel stays one. A keeper reads left and right apart — the deepest independence yet in the analysis corner, since the two channels may differ not just in a scalar but in the **count and boundaries** of their runs.

ALES95's own crux is that its segmentation equals a decision built by hand from repeated ALES94 classify calls, coalesced — the segmenter is the **sequencing** rule, not a fourth reader. Carried into stereo, each channel's segmentation equals ALES95's mono `segment` on that channel, so `segment_stereo` can never drift from the mono segmenter, which cannot drift from the classifier, which cannot drift from its two readers. The tower of readers stays a tower, in stereo.

## The crux, as a lift

`segment_stereo(sc, out, start, count, frame_len, t_low, t_high, silence_floor, voice_split)` writes both channels' runs into `out: *StereoSegments{left: Segments, right: Segments}` through an out-pointer — the same discipline mono `segment` keeps, since a `Segments` is far too large to return by value. The shared frame length, band, span, and floor are validated **once** up front (ALES92's `precheck`, the floor ceiling, and the frame-length divisibility) before either channel is read; because both channels are balanced and share every parameter, an up-front pass guarantees both mono calls succeed, so a refusal never segments one channel and leaves the other's run list half-written. `SegmentError` reused whole; the stereo lift adds no fault.

## The four laws proven

- **THE STEREO SEGMENT LAW** — each channel's run sequence equals ALES95's mono `segment` on that channel with the same frame length and setting, run for run (start, count, verdict).
- **THE READ-ONLY / BALANCE LAW** — the source `StereoClip` is byte for byte unchanged after segmenting (both channels), and the two channels stay balanced (reading writes nothing).
- **THE INDEPENDENT-SEGMENTATION LAW** — each channel is segmented on its own frames, so a voiced-then-silent left produces two runs where a uniform right stays one; an identical-channel master produces identical runs on both; each channel's runs **tile** its span exactly (coverage) and no two adjacent runs share a verdict (coalescing).
- **THE ATOMICITY / DEGENERATE LAW** — a shared illegal frame length (`BadFrame`), floor (`BadFloor`), band (`BadThreshold`), or span (`BadRange`) refuses before either channel is segmented, both run lists left as they were and the clip untouched; a uniform channel is one run on both.

## Honest scope

Software only, purely local, **read-only**. Two bounded in-process i16 Clips, siloed to `lotus/`, never mutated by this rung. Each output is a run-length label sequence over one channel — **not** a transcript, diarization, or phoneme boundary; a real voice-activity detector adds adaptive floors, spectral tilt, and smoothing hysteresis this rung does not. No real sample rate, no windowing overlap, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_segment.rye` — the module.
- `tools/ales_stereo_segment_witness.rish` — the witness.
