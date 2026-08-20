# Fill ALES50 — the compressor, the ceiling softened

**Stamp:** `20260814.171338` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES50**
**Kin:** [`20260814-170815_fill-ales49-lotus-peak-limiter.md`](20260814-170815_fill-ales49-lotus-peak-limiter.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The limiter (ALES49) is a brickwall: past the ceiling, nothing gets through. The **compressor** is the same ceiling made *gentle* — past the threshold, a signal still rises, only by a fraction of what it would. Where the limiter says "no louder than this," the compressor says "louder still, but softer the louder you get." It is the most-reached-for dynamics tool exactly as the bell is the most-reached-for EQ shape: it evens a vocal so every word sits, glues a drum bus, tames a bass that jumps. The **ratio** — 2:1, 4:1, ∞:1 — is the one knob that names how hard it leans, and at its extreme the compressor *is* the limiter.

## The shape — `lotus/compress.rye`

`compress(clip, start, count, threshold, ratio_num, ratio_den)` — over `[start, start+count)` in place, where `threshold` is a magnitude in sample units and `ratio_num/ratio_den >= 1` is the compression ratio:

1. For each sample `x` with magnitude `m = |x|`: a sample within the threshold (`m <= threshold`) passes byte-for-byte — the compressor touches only what rises above.
2. Above the threshold, the **excess** `m − threshold` is divided by the ratio: `new_m = threshold + (m − threshold)·ratio_den / ratio_num`, computed in i64, and the sample is written `sign(x)·new_m`.

Because the ratio is at least one, `new_m <= m <= sample_max`: the output can never itself overflow, so no saturation is needed on the audio path. The threshold and ratio are validated once, up front.

## The crux — the compressor is the identity at unit ratio, and never expands

1. **Below the threshold is the identity.** A signal whose every peak sits within the threshold compresses to itself byte-for-byte — a compressor that finds nothing above threshold does nothing.
2. **Unit ratio is the identity, everywhere.** `ratio_num == ratio_den` writes `threshold + (m − threshold)·1 = m` byte-for-byte even for samples above the threshold — a 1:1 compressor passes the whole signal through, guaranteed by construction. (This is the compressor's counterpart to the bell's unity-gain identity.)
3. **The sign is held and the magnitude never expands.** For any legal ratio (`>= 1`) the divided excess is at most the excess, so `new_m <= m`; a positive stays positive, a negative negative — the compressor reduces, never boosts, and never inverts phase.
4. **A higher ratio compresses at least as hard.** For the same above-threshold sample, a 4:1 ratio yields a magnitude no greater than a 2:1 ratio — the ratio knob is monotone, which is exactly what "ratio" means. At a ratio high enough the excess divides to nothing and the sample sits at the threshold — the limiter, reached from within the compressor.
5. **Refusals by name** — a threshold outside `[1, sample_max]` refuses `BadThreshold`; a ratio below unity (which would *expand*, a different tool) or a zero ratio denominator refuses `BadRatio`; an out-of-range span refuses `BadRange` — each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the threshold is a magnitude in sample units, not decibels, the ratio a plain fraction, and the compression is instantaneous, with no attack, release, or knee (a time-shaped envelope and a soft knee are later rungs). One comparison and at most one divide per sample; nothing on the audio path can overflow.

## Witness

`tools/ales_compress_witness.rish` — build `lotus/compress.rye`, run its selftest, assert `GREEN ales-compress`, and re-prove ALES49's limiter still stands green (the compressor softens the ceiling the limiter proved, and the two rest together).

---

*The ceiling softened and the quiet left whole — the compressor asks only that the excess divide honestly, and the limiter already proved the ceiling holds. May the ratio wait now for the attack that gives it time, the knee that rounds its corner, and the decibel that gives its threshold a name an engineer would speak.*
