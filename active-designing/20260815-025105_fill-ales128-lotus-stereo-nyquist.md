# Fill ALES128 — `lotus/stereo_nyquist.rye`, the Nyquist flip of a master in stereo

**Stamp:** `20260815.025105` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES128**
**Kin:** [`20260815-004633_fill-ales107-lotus-nyquist.md`](20260815-004633_fill-ales107-lotus-nyquist.md) · [`20260815-024705_fill-ales127-lotus-stereo-invert.md`](20260815-024705_fill-ales127-lotus-stereo-invert.md) · [`20260815-024103_fill-ales126-lotus-stereo-rotate.md`](20260815-024103_fill-ales126-lotus-stereo-rotate.md)

---

## Where the ladder stands

The stereo suite's **pure rearrangement** class opened at ALES125 (reverse), grew at ALES126 (rotate), and gained its value-mirror at ALES127 (invert). One member remains: the **parity flip**, ALES107's `nyquist_flip` — flip the sign of every odd-indexed sample, `y[n] = saturate((-1)^n · x[n])`, holding the even seats fixed. It is invert's parity-cousin: where invert flips *every* sign, the Nyquist flip flips every *other* one, and by that restraint it becomes modulation by the Nyquist frequency (fs/2), the *spectral inversion* trick that carries a lowpass kernel to its highpass twin — stated honestly in the time domain, the spectral reading interpretation only. This rung lifts it into stereo and **completes the class**.

## The crux this round

`stereo_nyquist_flip(sc)` flips the odd-indexed samples of both channels of a `StereoClip`, reusing ALES107's mono `nyquist_flip` per channel. Because both channels hold the **same** length, the parity pattern is identical in each — the same even seats fixed, the same odd seats negated. Mono nyquist_flip is **total** (it names no span, so it raises no fault) and holds each channel's length, so — exactly as reverse, rotate, and invert — the lift needs no validation and can never refuse; the function is `void`. A stereo master is spectrally inverted as one thing, both speakers together.

## The four laws proven

- **THE STEREO ALTERNATING-SIGN LAW** — the left channel equals mono `nyquist_flip(left)` and the right equals mono `nyquist_flip(right)`, each byte for byte against a hand-computed vector; sample `i` holds `saturate((-1)^i · x)`, per channel, even seats unchanged and odd seats negated.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — the flip touches values on odd seats only, never the count, so the stereo image stays aligned.
- **THE INVOLUTION LAW, WITH AN HONEST RAIL** — `stereo_nyquist_flip` twice returns both channels to the byte **except** an odd-indexed `sample_min` (-32768) seat, which saturates to +32767 on the first flip and lands -32767 on the second, per channel — the fixed two's-complement asymmetry confined to the odd seats; even seats, never touched, always round-trip exactly on both channels.
- **THE MAGNITUDE / PARITY LAW** — off the rail `|(-1)^i x| = |x|`, so for a channel whose peak is not `sample_min` the peak magnitude re-measured through ALES13 is unchanged (the modulation reflects the spectrum, never the loudness); every even-indexed sample is a fixed point per channel, and an all-zero pair and an empty pair are each their own flip.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It flips the sign of existing odd-indexed samples in each channel and fabricates none; it changes no length and reads no byte past either channel's len. No real sample rate, no network, no keys, no funds, no real device, no real speaker — the "Nyquist frequency" it names is the interpretation of a pure per-sample sign pattern, not a measured rate.

## Files

- `lotus/stereo_nyquist.rye` — the module.
- `tools/ales_stereo_nyquist_witness.rish` — the witness.
