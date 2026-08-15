# Fill ALES179 — Lotus's stereo_chorus: the triangle-LFO modulated delay mixed dry-plus-wet, carried into stereo, the same LFO and mix on both channels, each channel read off its own frozen snapshot — the fourth rung of the stereo modulation class, the vibrato's parent

**Stamp:** `20260815.083932` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES179
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-083330_fill-ales178-lotus-stereo-vibrato.md`](20260815-083330_fill-ales178-lotus-stereo-vibrato.md)

---

## The next crux, honestly chosen

ALES178 carried the vibrato — the modulated delay heard **wet-only** — into stereo, the first delay-line stereo lift. The vibrato is exactly ALES71's **chorus** with the dry removed and the wet at full: `chorus[i] = saturate(dry[i] + vibrato[i])`. Carrying the chorus itself into stereo is the natural parent rung — the same shared LFO on both channels, each on its own snapshot, but now the delayed voice is **mixed under the dry at a named level** rather than heard alone. That mix returns the one fault the vibrato dropped: **BadLevel** (a zero denominator or a wet above unity), so `StereoChorusError = chorus.ChorusError` carries five faults where the vibrato carried four. The chorus is what a keeper actually reaches for — one voice made to sound like several, the width a mix wants on a thin vocal or a lone guitar.

## The shape — the same LFO and mix on both channels, each on its own snapshot

`stereo_chorus(sc, start, count, centre_scaled, depth_scaled, period, num, den)` validates the LFO, mix level, and span **once** against the shared length (ALES71's own `precheck`, newly factored out exactly as ALES72's and ALES75's were), then runs ALES71's proven mono `chorus` on each channel with the **same** LFO and the **same** `num/den` mix:

- **The LFO and the mix are both shared** — a chorus's centre, depth, period, and level are all scaled units or fractions the caller names, not scalars measured across the field, so the same parameters on each channel widen both voices in lockstep and preserve the stereo image for free.
- **Each channel reads its OWN frozen snapshot** — as in the stereo vibrato, mono `chorus` snapshots the dry prefix of its own clip before any write; run once per channel, the left reads the left's dry and the right the right's, never crossed. No cross-channel snapshot.
- **The dry is added under the wet, saturated once** — unlike the wet-only vibrato, the chorus write is `saturate(dry[i] + level·wet[i])`, so a loud dry-plus-wet sum clamps to the i16 rail per channel rather than wrapping.

## The laws proven

- **The stereo chorus law:** each channel equals ALES71's mono `chorus` with the same LFO and mix over the same span byte for byte, proven side by side with genuinely different per-channel content (the two outputs genuinely differ).
- **The vibrato-family law:** the family identity holds per channel — a full-wet (1/1) stereo chorus equals the dry master plus ALES178's stereo vibrato, sample for sample on both channels (`stereo_chorus[i] = saturate(dry[i] + stereo_vibrato[i])`), so the parent and the wet-only child are one delay heard two ways in stereo.
- **The dry-identity law:** a zero-level (`num = 0`) stereo chorus is the exact dry master on both channels — no wet added, the identity — proving the mix genuinely governs the wet.
- **The image law:** an identical-channel master stays identical through the chorus, **and** a panned pair (values kept off the rail) keeps its left:right ratio at every sample — the read and the mix are linear in the input away from saturation.
- **The balance / silence / atomicity / degenerate law:** an all-silent master widens to silence on both; `left.len == right.len` after; a bad period, a bad depth, a bad delay top, a bad level, and an out-of-range span each refuse by name with both channels byte for byte untouched and still balanced; `count = 0` is the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips (left, right), each rung through ALES71's own modulated delay — the triangle and the fractional interpolation in i64, each channel snapshotting its own dry prefix into one bounded `[max_clip]i16` scratch, the dry-plus-wet sum saturating once. The LFO is counted in scaled units (256 = unity) and the period in samples, not hertz; the mix is a named fraction, not a decibel. No cross-channel snapshot, no feedback (the flanger's element, the next rung), no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
