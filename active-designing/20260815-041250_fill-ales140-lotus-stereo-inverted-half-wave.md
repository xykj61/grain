# Fill ALES140 — `lotus/stereo_halve_neg.rye`, the inverted half-wave rectifier carried into stereo, completing the rectifier family in stereo

**Stamp:** `20260815.041250` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES140**
**Kin:** [`20260815-040747_fill-ales139-lotus-stereo-half-wave-rectifier.md`](20260815-040747_fill-ales139-lotus-stereo-half-wave-rectifier.md) · [`20260814-215030_fill-ales86-lotus-inverted-half-wave-rectifier.md`](20260814-215030_fill-ales86-lotus-inverted-half-wave-rectifier.md)

---

## Where the ladder stands

The stereo **even** corner now holds the full-wave rectifier (ALES138, which **collapsed** an out-of-phase master to identical channels) and the positive half-wave (ALES139, which **partitioned** it into two disjoint one-sided channels). This rung carries the last member, ALES86's **inverted half-wave rectifier**, `y = min(x, 0)` — keep the **negative** half of the wave whole, silence the positive: the exact mirror of ALES139's positive half-wave, the single diode flipped the other way. With it the rectifier family stands **whole in stereo**.

## The crux this round — the family whole, the two half-waves partitioning the dry master

The two half-waves **partition the wave**: `max(x, 0) + min(x, 0) = x`, the plainest decomposition of a signal into its positive and negative parts. Carried into stereo, this is the round's finishing law — `stereo_halve(sc)` on one copy of a master and `stereo_halve_neg(sc)` on another, summed sample for sample on each channel, reconstruct the **dry** master exactly. On an out-of-phase master (right = −left), the inverted half-wave returns **partitioned** like its sibling but on the **non-positive** side: at each index exactly one channel survives (`left[i] · right[i] = 0`, disjoint) and their sum is the negated magnitude (`left[i] + right[i] = −|left[i]|`, since `min(x, 0) + min(−x, 0) = −|x|`). Every output on both channels is **non-positive** — the mirror of ALES139's non-negative one-sided signal.

## The crux, as a lift

`stereo_halve_neg(sc, start, count)` inverted-half-wave-rectifies `[start, start+count)` in **both** channels of a `StereoClip`, running ALES86's proven mono `halve_neg` on each. `min(x, 0)` is exact for **every** i16 with **no rail edge** (`sample_min` passes through untouched — already a legal i16, unlike the full-wave rectifier where its magnitude overflowed the positive rail), so no saturate is owed. It takes no gain, no ceiling, no threshold (fixed at zero), so it names exactly one fault — it validates the span once against the shared length before either channel is mutated (`BadRange`), so a refusal never rectifies one channel and leaves the other signed. `HalveNegError` is reused whole.

## The four laws proven

- **THE STEREO INVERTED-HALVE LAW** — each channel equals ALES86's mono `halve_neg` over the same span, **byte for byte**: every output is `min(x, 0)`, non-positives passing unchanged and positives going to silence, with no rail edge.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a halve_neg writes values only.
- **THE FAMILY-WHOLE / IMAGE-PARTITION LAW** — the two stereo half-waves partition the dry master: `stereo_halve` plus `stereo_halve_neg` reconstructs it sample for sample on each channel (`max(x, 0) + min(x, 0) = x`). On an out-of-phase master (right = −left) the inverted half-wave returns **partitioned** and **non-positive**: `left[i] · right[i] = 0` (disjoint) and `left[i] + right[i] = −|left[i]|` at every index; yet a 1:2 master keeps its ratio on the kept samples, an identical-channel master stays identical, every output on both channels is **non-positive**, and the map is **idempotent** (a non-positive sample maps to itself).
- **THE ATOMICITY / DEGENERATE LAW** — the lone refusal (`BadRange`) leaves **both** channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES86's own `halve_neg`, each output at least its input and never above zero, never a length; the shape is an inverted half-wave threshold at zero, instantaneous. No saturate is owed — `min(x, 0)` never leaves the rail. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_halve_neg.rye` — the module.
- `tools/ales_stereo_halve_neg_witness.rish` — the witness.
