# Fill ALES216 — Lotus's stereo WAV container (the door widened to two channels)

**Stamp:** `20260815.130649` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local byte work · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES216**
**Kin:** [`20260815-130110_fill-ales215-lotus-wav-container.md`](20260815-130110_fill-ales215-lotus-wav-container.md) · [`../lotus/wav.rye`](../lotus/wav.rye) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES215 opened the container family with mono. The suite keeps a mono→stereo pair for almost every effect, because a stereo master is the common case a mixer works in — the reverb, width, and pan families all closed their axis *whole* across both channels. The container owes the same completeness: a keeper who reverberated and *placed* a wet image in the field (ALES214) needs to export **that stereo result**, not fold it to mono first.

`stereo_wav` widens the door to two channels: the canonical RIFF/WAVE container with `channels == 2`, samples stored **interleaved** left/right/left/right as every WAV writer and reader expects, so the file a phone or browser opens plays in stereo. It carries ALES215's discipline verbatim and adds exactly one new border — a whole-*frame* border, since a stereo data chunk must be a whole number of two-sample frames, not merely a whole number of samples.

## The shape — two channel buffers in, two channel buffers out

- `encode(sample_rate, left, right, out) StereoWavError!u32` — the two channels must be equal length (`ChannelLengthMismatch`); write the canonical stereo header (`channels == 2`, `block_align == 4`, `byte_rate == rate * 4`) then interleave the samples `L₀ R₀ L₁ R₁ …` into `out`, returning the byte length. Refuses `TooManyFrames`, `BadSampleRate`, `OutputTooSmall` before any write.
- `decode(bytes, left, right) StereoWavError!StereoPcm` — prove the container whole and canonical stereo, then de-interleave its frames into the two channel buffers, returning `{ sample_rate, frames }`. Every field checked in order before a sample is read.

The header is the same 44-byte canonical layout, differing only where stereo differs: `channels`, `block_align`, `byte_rate`.

## THE FRAME BORDER

Decode runs the same two independent gates, with the alignment gate widened. The size chain proves the file self-consistent; the **frame border** proves the data chunk a whole number of *frames* (`data_size % 4 == 0`, one frame = two i16 samples = 4 bytes) — so a container missing half a stereo frame refuses `PartialFrame` before a single sample is read, and neither channel ever receives a lone, unpaired sample.

## The provable laws the witness proves

1. **THE ROUND-TRIP LAW** — two distinct, boundary-touching channel buffers encode to a stereo container and decode back **byte-for-byte on each channel**, the sample rate preserved.
2. **THE INTERLEAVE LAW** — the encoded payload is exactly `L₀ R₀ L₁ R₁ …`; the left samples sit at even frame offsets, the right at odd.
3. **THE CANONICAL-STEREO-HEADER LAW** — `channels == 2`, `block_align == 4`, `byte_rate == sample_rate * 4`, `data_size == frames * 4`, `riff_size == len - 8`, format 1, 16 bits.
4. **THE EMPTY LAW** — zero frames encode to a valid 44-byte header and decode back to zero frames.
5. **THE FRAME-BORDER LAW** — a data chunk one byte short of a whole frame refuses `PartialFrame` before a value is read.
6. **THE FAULT LAW** — bad magic/form/chunk tags, wrong fmt size, non-PCM format, a **mono** channel count (a stereo decoder must refuse a mono container `NotStereo`), mismatched byte rate or block align, non-16-bit depth, mismatched riff/data size, a zero/over-bound rate, unequal channel lengths on encode, too many frames, and an output buffer too small each refuse **by name** before any sample crosses.

## Honest scope

Software only, purely local byte work — the same as ALES215, widened to interleaved stereo. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device or speaker. The stored sample rate is a carried field, not a real clock. RIFF/WAVE studied clean-room; our own bounded, asserted Rye implementation, siloed to `lotus/`. **No custody gate.**

## Next after this

The container family stands whole for mono and stereo. A keeper who can now export a stereo clip will want a **render** rung — run a small effect chain over a buffer and write the `.wav` result — the honest next step, named then as its own self-approved design round.
