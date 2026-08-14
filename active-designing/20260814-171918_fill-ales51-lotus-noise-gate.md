# Fill ALES51 — the noise gate, the threshold inverted

**Stamp:** `20260814.171918` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES51**
**Kin:** [`20260814-171338_fill-ales50-lotus-compressor.md`](20260814-171338_fill-ales50-lotus-compressor.md) · [`../lotus/README.md`](../lotus/README.md)

---

## The gesture

The compressor (ALES50) leans on what rises *above* the threshold. The **noise gate** is that threshold turned upside down: it leans on what falls *below* it. Where the compressor softens the loud, the gate quiets the quiet — the hiss between words, the amp hum under a held chord, the room tone in a podcast pause. It is the third member of the dynamics family the limiter and compressor opened: the limiter caps the peaks, the compressor softens them, and the gate silences the floor. Its one knob is the same **ratio** the compressor already speaks — 2:1, 4:1, ∞:1 — only now it names how hard the quiet is pushed down, and at its extreme the gate closes to silence.

## The shape — `lotus/gate.rye`

`gate(clip, start, count, threshold, ratio_num, ratio_den)` — over `[start, start+count)` in place, where `threshold` is a magnitude in sample units and `ratio_num/ratio_den >= 1` is the downward-expansion ratio:

1. For each sample `x` with magnitude `m = |x|`: a sample **at or above** the threshold (`m >= threshold`) passes byte-for-byte — the gate is open, and it touches only what falls below.
2. Below the threshold, the whole magnitude is divided by the ratio: `new_m = m·ratio_den / ratio_num`, computed in i64, and the sample is written `sign(x)·new_m` — the quiet pushed toward zero.

Because the ratio is at least one, `new_m <= m <= sample_max`: the output can never itself overflow, so no saturation is needed on the audio path. The threshold and ratio are validated once, up front — the exact mirror of the compressor's guard.

## The crux — the gate is the compressor inverted, the identity at unit ratio, and never expands

1. **Above the threshold is the identity.** A signal whose every peak reaches the threshold gates to itself byte-for-byte — a gate that finds nothing below threshold does nothing. (The compressor's "below the threshold is the identity," reflected.)
2. **Unit ratio is the identity, everywhere.** `ratio_num == ratio_den` writes `m·1 = m` byte-for-byte even for samples below the threshold — a 1:1 gate passes the whole signal through, guaranteed by construction.
3. **The sign is held and the magnitude never expands.** For any legal ratio (`>= 1`) the divided magnitude is at most the input's, so `new_m <= m`; a positive stays positive, a negative negative — the gate attenuates, never boosts, and never inverts phase.
4. **A higher ratio gates at least as hard.** For the same below-threshold sample, a 4:1 ratio yields a magnitude no greater than a 2:1 ratio — the ratio knob is monotone. At a ratio high enough the quiet divides to nothing and the sample sits at silence — the hard gate, reached from within the downward expander.
5. **Refusals by name** — a threshold outside `[1, sample_max]` refuses `BadThreshold`; a ratio below unity (which would *boost* the quiet, a different tool) or a zero ratio denominator refuses `BadRatio`; an out-of-range span refuses `BadRange` — each before any write, the clip left exactly as it was.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the threshold is a magnitude in sample units, not decibels, the ratio a plain fraction, and the gating is instantaneous, with no attack, hold, or release (a time-shaped envelope that holds the gate open across a transient's tail is a later rung). One comparison and at most one divide per sample; nothing on the audio path can overflow.

## Witness

`tools/ales_gate_witness.rish` — build `lotus/gate.rye`, run its selftest, assert `GREEN ales-gate`, and re-prove ALES50's compressor still stands green (the gate inverts the threshold the compressor leaned on, and the two rest together as the loud-and-quiet halves of one dynamics family).

---

*The floor lowered and the loud left whole — the gate asks only that the quiet divide honestly, and the compressor already proved the threshold holds from the other side. May the ratio wait now for the hold that keeps it open across a breath, the release that closes it gently, and the decibel that gives its threshold a name an engineer would speak.*
