# Fill ALES146 — `lotus/stereo_voiced.rye`, the voiced/unvoiced/silent classifier carried into stereo, the suite's second stereo analysis rung

**Stamp:** `20260815.045940` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES146**
**Kin:** [`20260815-044940_fill-ales145-lotus-stereo-zero-cross.md`](20260815-044940_fill-ales145-lotus-stereo-zero-cross.md) · [`20260814-230352_fill-ales94-lotus-voiced-unvoiced-classifier.md`](20260814-230352_fill-ales94-lotus-voiced-unvoiced-classifier.md)

---

## Where the ladder stands

Last round carried the suite's first analysis reader — the zero-crossing counter — into stereo (ALES145 `stereo_zero_cross`: two counters reading two channels). This round carries the reader that **fuses two of them**. ALES94's `classify` is the first Lotus rung to join two analysis features into one verdict: energy (ALES13's RMS) separates sound from silence, crossing rate (ALES93's count read through the ALES92 band) separates the two kinds of sound above the floor — the oldest decision in speech processing, is this frame **voiced**, **unvoiced**, or **silent**? Carried into stereo, it is the suite's **second stereo analysis rung** — two classifiers reading two channels, each returning a three-valued verdict, writing not one sample.

## The crux this round — two independent verdicts, the energy gate read first per channel

Each channel is classified on **its own** two features — its own RMS energy, its own crossing count — through **one shared** band, floor, and split. So the two verdicts are **independent**: an identical-channel master (left = right) reads the **same** verdict on both, while a loud periodic left over a quiet right reports **voiced** left and **silent** right. A keeper reads left and right apart, exactly as the stereo meter (ALES17) reads two levels and the stereo zero-cross (ALES145) reads two counts — this rung mirrors that analysis shape a third time.

ALES94's own crux is that `classify` **invents no new measurement**: its verdict equals a decision built by hand from ALES93's `count_crossings` and ALES13's RMS over the same span, so it can never drift from the two readers it composes. That crux is carried whole into stereo — each channel's stereo verdict equals ALES94's mono `classify` on that channel, so `classify_stereo` can never drift from the mono classifier, which itself cannot drift from its two readers. The fusion rule made stereo.

## The crux, as a lift

`classify_stereo(sc, start, count, t_low, t_high, silence_floor, voice_split)` classifies both channels of a `StereoClip` over the same span and returns the pair `StereoVerdict{left, right}`. Unlike ALES145's zero-cross counter, the classifier carries **no running state** — a verdict is a pure function of one span, so this rung mirrors the stereo meter's whole-master `measure_stereo` shape (a pair returned) rather than a carried counter. The shared band, span, and floor are validated **once** up front — ALES92's own `precheck` for the band and span (`BadThreshold`/`BadRange`), and the floor against the peak ceiling (`BadFloor`) — before either channel is read, so a refusal never classifies one channel and returns a half answer. `ClassifyError` reused whole; the stereo lift adds no fault.

## The four laws proven

- **THE STEREO FUSION LAW** — each channel's verdict equals ALES94's mono `classify` on that channel with the same band, floor, and split (so the stereo classifier can never drift from the mono one, which cannot drift from its two readers).
- **THE READ-ONLY / BALANCE LAW** — the source `StereoClip` is byte for byte unchanged after classifying (both channels), and the two channels stay balanced (reading writes nothing).
- **THE INDEPENDENT-VERDICT LAW** — each channel is classified on its own features, so a loud-periodic left over a quiet right reads voiced / silent, an identical master reads equal verdicts on both, and the energy gate is read first on each (a quiet many-crossing channel reads silent, never unvoiced).
- **THE ATOMICITY / DEGENERATE LAW** — a shared illegal floor (`BadFloor`), inverted band (`BadThreshold`), or out-of-range span (`BadRange`) refuses before either channel is classified, the clip untouched; the floor-zero convention holds on both (floor 0 disables silence, an all-zero span reads voiced).

## Honest scope

Software only, purely local, **read-only**. Two bounded in-process i16 Clips, siloed to `lotus/`, never mutated by this rung. Each verdict is a three-valued label over one span per channel — **not** a phoneme, transcript, or probability; the voiced/unvoiced names follow the classic speech convention over exactly two features and claim nothing about a real speaker, language, or recording. No adaptive floor, no time windowing, no real sample rate, no anti-aliasing, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_voiced.rye` — the module.
- `tools/ales_stereo_voiced_witness.rish` — the witness.
