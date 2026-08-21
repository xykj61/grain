# Fill ALES129 — `lotus/stereo_normalize.rye`, peak normalization carried into stereo, one shared gain

**Stamp:** `20260815.025919` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES129**
**Kin:** [`20260815-001849_fill-ales103-lotus-peak-normalize.md`](20260815-001849_fill-ales103-lotus-peak-normalize.md) · [`20260815-024705_fill-ales127-lotus-stereo-invert.md`](20260815-024705_fill-ales127-lotus-stereo-invert.md)

---

## Where the ladder stands

The stereo suite has carried every span-edit (ALES116–123) and completed the **pure rearrangement** class (reverse · rotate · invert · nyquist_flip, ALES125–128) — every one of those lifts is *trivial* in the same precise way: it runs the proven mono op on each channel independently, because the operation touches each seat or value in isolation and the two channels never need to agree on a number. This rung opens a new class, the **amplitude** class, on the one member where independence would be a bug: **peak normalization** (ALES103). Lifting it honestly is the crux.

## The crux this round

`stereo_normalize_peak(sc, target)` scales a stereo master so its loudest sample — the loudest sample **anywhere in the master**, across both channels — lands exactly on `target`, while the two channels keep their relative level. The naive lift (normalize each channel to `target` independently) would move the quieter channel's peak up to `target` too, collapsing the inter-channel level difference — the very thing that *is* the stereo image. A vocal panned slightly left would drift to dead centre; a stereo field would go flat.

The honest lift is **linked**: measure the peak of **both** channels, take the larger — the master peak — and scale **both** channels by the **same** fraction `target / master_peak` through ALES2's `gain`. One shared gain, applied to each channel. The channel that held the master peak lands its loudest sample on exactly ±`target`; the other channel, scaled by the identical fraction, keeps its samples strictly inside — its own peak lands proportionally quieter, so the ratio between the channels is preserved to the sample. This is what every DAW's "Normalize (linked / stereo)" does, and why it is a separate button from per-channel normalize.

## The five laws proven

- **THE LINKED-SCALE LAW** — both channels are scaled by the *same* fraction `target / master_peak`, so each channel equals ALES2's `gain(channel, 0, len, target, master_peak)` byte for byte, one shared denominator; the channel holding the master peak maps that sample to exactly ±`target`.
- **THE MASTER-PEAK LAW** — after normalize, the peak magnitude across **both** channels (the max of the two channel peaks, re-measured through ALES13) equals `target` exactly, for any non-silent master at any target — the master's loudest sample lands on the target and nothing overshoots.
- **THE IMAGE-PRESERVING LAW** — the crux made checkable: for a master whose channels differ in level (left peak 8000, right peak 4000), linked normalize to 16000 leaves left peak 16000 and right peak **8000** — the 2:1 ratio held — where an *independent* per-channel normalize would have driven both to 16000 and flattened the image. The quieter channel stays strictly below target.
- **THE BALANCE / SILENCE LAW** — `left.len == right.len` holds and each channel keeps its starting length; a both-silent pair (master peak 0) and an empty pair are unchanged whatever the target — no peak, no gain, no divide by zero.
- **THE IDEMPOTENCE LAW, WITH REFUSALS** — normalizing to a target, then again to the same target, is a no-op the second time (the master peak already sits on the target, so the shared gain is unity); a zero target and a target past `sample_max` each refuse `BadTarget`, both channels untouched.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES2's own `gain`, fabricating none, and changes no length; the target is a plain magnitude in samples, **not** a decibel or a loudness model (this is peak normalization, the plainest reading). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_normalize.rye` — the module.
- `tools/ales_stereo_normalize_witness.rish` — the witness.
