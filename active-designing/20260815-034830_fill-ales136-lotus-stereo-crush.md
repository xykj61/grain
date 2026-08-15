# Fill ALES136 — `lotus/stereo_crush.rye`, the bit-crusher carried into stereo, one shared grid

**Stamp:** `20260815.034830` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES136**
**Kin:** [`20260815-034120_fill-ales135-lotus-stereo-tube.md`](20260815-034120_fill-ales135-lotus-stereo-tube.md) · [`20260814-211634_fill-ales81-lotus-bit-crush.md`](20260814-211634_fill-ales81-lotus-bit-crush.md)

---

## Where the ladder stands

The stereo **nonlinear** class now holds all four DRIVE readings of an over-boosted wave — pinned (ALES132), rounded (ALES133), reflected (ALES134), unevenly pinned (ALES135) — and with the tube it gained its first **not-odd** corner. This rung carries the DRIVE family's *other* not-odd member and its second axis: ALES81's **bit-crusher**, which leaves the amplitude alone and shapes **resolution** instead — dropping the low `16 − bits` bits so a sixteen-bit signal leaves at eight, four, or one, the coarse quantized voice of an early sampler.

Dropping the low bits floors a two's-complement value toward −∞, so the crush — like the tube — is **not odd**: `crush(−100) = −256` while `crush(100) = 0` at eight bits, a faint downward DC offset that is bit reduction's honest fingerprint. The stereo lift inherits the lesson ALES135 named: a not-odd map holds neither the inter-channel ratio nor the inter-channel **antisymmetry**. An out-of-phase master driven through the same grid comes back **not** out of phase, because the floor is not symmetric about zero.

## The crux this round

`stereo_crush(sc, start, count, bits)` crushes `[start, start+count)` in **both** channels of a `StereoClip` (ALES10) to the same `bits` of resolution, running ALES81's proven mono `crush` on each. The mono crush carries **no** pre-gain and **no** ceiling — the purest DRIVE member — so the stereo lift is the plainest of the nonlinear class: it validates `bits` and the span **once** against the shared length before either channel is mutated (`BadBits` on a resolution outside `[1, 16]`, `BadRange` on a span past the samples), so a refusal never crushes one channel and leaves the other at full resolution. `CrushError` is reused whole.

## The four laws proven

- **THE STEREO CRUSH LAW** — each channel equals ALES81's mono `crush` with the same `bits` over the same span, **byte for byte**: every written sample lands on a multiple of the grid step `2^(16−bits)`.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a crush writes values only.
- **THE PER-CHANNEL NOT-ODD LAW** — the crush floors toward −∞, so a shared grid holds neither the inter-channel ratio nor the inter-channel **antisymmetry**: an out-of-phase master (right the negation of left) comes back **not** out of phase (at eight bits `crush(100)=0` but `crush(−100)=−256`, so `right ≠ −left`), the downward DC fingerprint landing on both channels. Yet per channel the discipline holds — every output is a grid point at or below its input, the map is **idempotent** (a grid point crushes to itself, so twice equals once on both channels), an identical-channel master stays identical, and `bits = 16` is the identity on both.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (`BadBits`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; `bits = 16` the identity on both, `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES81's own `crush`, fabricating none and changing no length; the resolution is a bit count, the grid a power-of-two step in sample units, the shape a quantizer, instantaneous (no dither, no anti-aliasing). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_crush.rye` — the module.
- `tools/ales_stereo_crush_witness.rish` — the witness.
