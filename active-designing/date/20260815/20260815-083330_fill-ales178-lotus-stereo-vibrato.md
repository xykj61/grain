# Fill ALES178 — Lotus's stereo_vibrato: the wet-only triangle-LFO modulated delay carried into stereo, the same LFO on both channels, each channel read off its own frozen snapshot — the third rung of the stereo modulation class, and the first that snapshots

**Stamp:** `20260815.083330` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES178
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-083200_fill-ales177-lotus-stereo-ring-mod.md`](20260815-083200_fill-ales177-lotus-stereo-ring-mod.md)

---

## The next crux, honestly chosen

ALES176 and ALES177 opened the stereo modulation class with the two **thin per-sample** modulations — the tremolo (a triangle LFO on the gain) and the ring modulator (a bipolar carrier on amplitude). Both write in place with **no snapshot**, because every output depends only on its own input sample. The delay-line modulations are the class's other half, and none has yet been carried into stereo: the **chorus**, the **vibrato**, and the **flanger** each read a *modulated* delay, so an output depends on an earlier *input*, and the read must be taken off a frozen copy so a moving read never reads a sample it just wrote.

The **vibrato** (ALES72) is the thinnest of those three — the wet-only modulated delay, the delayed voice heard **alone** with no dry mixed under it and no mix level to name, so it carries only four faults (BadPeriod, BadDepth, BadDelay, BadRange) and no BadLevel. That makes it the honest first delay-line stereo lift: the crux is not the arithmetic (ALES72's is reused verbatim) but the **snapshot discipline**, carried cleanly into two channels.

## The shape — the same LFO on both channels, each on its own snapshot

`stereo_vibrato(sc, start, count, centre_scaled, depth_scaled, period)` validates the LFO and span **once** against the shared length (ALES72's own `precheck`, newly factored out for this exactly as ALES75's was for the ring modulator), then runs ALES72's proven mono `vibrato` on each channel with the **same** LFO:

- **The LFO is shared** — a vibrato's centre, depth, and period are scaled units the caller names (256 = unity delay resolution), not scalars measured across the field, so the same LFO on each channel wobbles both voices in lockstep and preserves the stereo image for free. The parametric pattern of the whole class, unchanged.
- **Each channel reads its OWN frozen snapshot** — this is the honest new thing versus the tremolo and ring modulator. Mono `vibrato` snapshots the dry prefix of its own clip before any write; run once per channel, the left reads the left's dry and the right reads the right's, never crossed. There is no *cross-channel* snapshot — the two channels never read each other — so the discipline is exactly the mono one, twice, with nothing threaded across the seam.
- **Wet-only carries no mix** — the delayed voice is the whole output on each channel, so `StereoVibratoError = vibrato.VibratoError` is reused whole with no new fault, and there is no BadLevel to lift.

## The laws proven

- **The stereo vibrato law:** each channel equals ALES72's mono `vibrato` with the same LFO over the same span byte for byte, proven side by side with genuinely different per-channel content (the two outputs genuinely differ — the left rung by the left's samples, the right by the right's).
- **The chorus-family law:** the family identity `chorus[i] = saturate(dry[i] + vibrato[i])` holds per channel — a stereo chorus at full wet equals the dry master plus this stereo vibrato, sample for sample on both channels (proven against ALES71's mono chorus run per channel), so the wet-only lift sits under the eventual stereo chorus exactly as the mono rungs do.
- **The image law:** an identical-channel (mono-in-stereo) master stays identical through the vibrato (the same input through the same LFO and the same snapshot logic is the same output), **and** a panned pair keeps its left:right ratio at every sample — the interpolation read is a convex combination linear in the input, so where the pre-vibrato pair held `2·right == left`, the post-vibrato pair holds it too (the wet voice never touches the rail, so no saturation breaks the ratio).
- **The balance / silence / atomicity / degenerate law:** an all-silent master wobbles to silence on both; `left.len == right.len` after; a bad period, a bad depth, a bad delay top, and an out-of-range span each refuse by name with both channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each rung through ALES72's own wet-only modulated delay — the triangle and the fractional interpolation in i64, each channel snapshotting its own dry prefix into one bounded `[max_clip]i16` scratch, the write saturating once (a proven no-op, since the vibrato voice is a convex combination of two in-range dry neighbours). The LFO is counted in scaled units (256 = unity) and the period in samples, not hertz — a real time base is a later rung. No cross-channel snapshot, no lookahead beyond each channel's own prefix, no feedback (the flanger's element, a later rung), no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
