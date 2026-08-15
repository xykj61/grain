# Fill ALES215 — Lotus's WAV container (the open door every effect leaves through)

**Stamp:** `20260815.130110` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local byte work · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES215**
**Kin:** [`20260815-125233_fill-ales214-lotus-reverb-place.md`](20260815-125233_fill-ales214-lotus-reverb-place.md) · [`../lotus/wire.rye`](../lotus/wire.rye) (ALES0) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

The reverb family closed at ALES214, and its design read named the honest next move: **open a fresh Lotus family** rather than fit one more reverb knob. Lindy-first, crux-first points at the single most durable thing the suite still lacks. Two hundred and fifteen rungs of effects edit an in-memory `i16` buffer beautifully — yet nothing a keeper makes can leave the bench as a file another program will open. **A container is that door.**

`reverb_place` reverberates and seats a wet image; nothing yet lets that image become a `.wav` on disk that a phone, a browser, or another DAW will play. That is the crux: the hardest still-tractable move that opens the rest — once a bounded buffer round-trips through the canonical **RIFF/WAVE** container, every one of the 200-plus effects gains an export and an import for free. It is also the most **Lindy** surface in the whole suite: RIFF/WAVE is a public, unencumbered interchange format read and written for over thirty years; a well-named, asserted encoder for it will still read true on its ten-thousandth day.

`lotus/wire.rye` (ALES0) already taught the tree the exact discipline this rung wants — a self-describing frame, deframed **verify-before-trust**, with an *audio border* proving the payload sample-aligned so no torn half-sample ever reaches a timeline. `wav` carries that same discipline to the format the outside world already speaks.

## The shape — encode into a caller's buffer, decode verify-before-trust

Two pure functions over caller-provided buffers, so nothing giant is fixed and every bound is named at the edge:

- `encode(sample_rate, samples, out) WavError!u32` — write the canonical 44-byte mono 16-bit PCM header then the samples little-endian into `out`, returning the byte length written. Refuses `TooManySamples` past `max_samples`, `BadSampleRate` outside `[1, max_sample_rate]`, and `OutputTooSmall` if `out` cannot hold the whole file — each **before any write**.
- `decode(bytes, out) WavError!Pcm` — prove the container whole and canonical, then read its samples into `out`, returning `{ sample_rate, count }`. Every field is checked in order **before a single sample is read**.

The canonical mono/16-bit header is fixed at **44 bytes**: `RIFF` · riff_size(u32 LE) · `WAVE` · `fmt ` · fmt_size(16) · format(1 = PCM) · channels(1) · sample_rate · byte_rate · block_align · bits(16) · `data` · data_size. One layout, a single source of truth, so encode and decode can never read a field at the wrong offset.

## THE AUDIO BORDER, again

Decode runs **two independent gates**, exactly as the wire did. The size chain proves the file *self-consistent* (`riff_size == len - 8`, `header_len + data_size == len`), and the audio border proves it *sample-aligned* (`data_size % 2 == 0`) — so a container whose data chunk is an odd byte count refuses `PartialSample` before any sample is formed, and no timeline ever receives half a value. Integrity of structure and integrity of alignment are two separate proofs.

## The provable laws the witness proves

1. **THE ROUND-TRIP LAW** — a buffer of distinct, boundary-touching `i16` samples encodes to a 44-byte-header container and decodes back **byte-for-byte**, the sample rate preserved.
2. **THE CANONICAL-HEADER LAW** — the encoded bytes carry exactly `RIFF`/`WAVE`/`fmt `/`data`, format 1, 1 channel, 16 bits, `byte_rate == sample_rate * 2`, `block_align == 2`, `riff_size == len - 8`, `data_size == count * 2`.
3. **THE EMPTY LAW** — zero samples encode to a valid 44-byte header with an empty data chunk and decode back to a count of zero.
4. **THE AUDIO-BORDER LAW** — a data chunk one byte short of whole samples refuses `PartialSample` before a value is read.
5. **THE FAULT LAW** — a bad magic, non-`WAVE` form, non-`fmt ` chunk, non-PCM format, non-mono channel count, non-16-bit depth, absent `data` chunk, mismatched riff/data size, a rate of zero or past `max_sample_rate`, a buffer wider than `max_samples`, and an output buffer too small each refuse **by name** before any sample crosses.

## Honest scope

Software only, purely local byte work. `wav` converts between a bounded `i16` buffer and the RIFF/WAVE byte layout and back — it asserts **no** acoustic or electrical fact. The stored sample rate is an integer field the container carries, not a real clock; there is no DAC, no real file handle opened by this rung, no network, no keys, no funds, no real device or speaker. The format is public and unencumbered (RIFF/WAVE, IBM/Microsoft 1991), studied clean-room like every other; this is our own bounded, asserted Rye implementation, siloed to `lotus/`. **No custody gate.**

## Next after this

With mono in place, the natural twin is **`stereo_wav`** — the same canonical container with `channels == 2` and interleaved left/right samples, closing the mono→stereo pair the suite keeps. Beyond the pair, a keeper who can now export one clip will want a **render** rung that runs a small effect chain and writes the result — named then as its own self-approved design round.
