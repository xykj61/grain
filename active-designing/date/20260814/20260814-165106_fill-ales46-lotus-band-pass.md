# Fill ALES46 — the band-pass, the middle kept

**Stamp:** `20260814.165106` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — one keystone, one send
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES46**
**Kin:** [`20260814-164244_fill-ales45-lotus-carried-highpass.md`](20260814-164244_fill-ales45-lotus-carried-highpass.md) · [`20260814-163647_fill-ales44-lotus-filter-sweep.md`](20260814-163647_fill-ales44-lotus-filter-sweep.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md)

---

## The gesture

Every filter rung so far keeps or trims one edge of the spectrum: the low-pass keeps the lows (ALES40), the high-pass keeps the highs (ALES45), the shelf and stack tilt bands by gain (ALES41–42). The gesture a musician reaches for to *isolate* a range — the telephone voice, the wah's throat, the drum bus carved to its body — is the **band-pass**: keep the middle, drop the lows below one cutoff and the highs above another.

The band-pass wants no new arithmetic. It is exactly the high-pass at the **low** cutoff followed by the low-pass at the **high** cutoff — two filters already proven byte-for-byte (ALES40 · ALES45). ALES46 composes them into one carried value and proves the composition is faithful.

## The shape — `lotus/band.rye`

A `Bandpass` struct carries **two** i64 states, one per stage, and the two coefficients:

```
Bandpass = struct {
    hp_state: i64 = 0,   // the high-pass stage's carried low-pass estimate (the complement x − lp)
    lp_state: i64 = 0,   // the low-pass stage's carried estimate
    low_num: i32, low_den: u32,    // high-pass cutoff — drops content below it
    high_num: i32, high_den: u32,  // low-pass cutoff — drops content above it
}
```

`run(clip, start, count)` applies, in place over `[start, start+count)`:

1. `tone.high_pass_carry(clip, start, count, &hp_state, low_num, low_den)` — drop the lows, continuing the hp state.
2. `tone.low_pass_carry(clip, start, count, &lp_state, high_num, high_den)` — drop the highs, continuing the lp state.

Each stage carries its own state, so a span run in two pieces continues both states across the seam. `reset` returns both states to silence.

## The correctness (each a selftest clause)

1. **The composition crux.** A `Bandpass.run` over the whole span equals `tone.high_pass` (low cutoff) then `tone.low_pass` (high cutoff) applied in that order to a copy — byte-for-byte. The band-pass adds no arithmetic on the audio path; it is the two proven stages in cascade.
2. **Split-equals-whole.** A span band-passed in two pieces (the second carrying both ending states) equals the whole band-passed once, byte-for-byte — both states carry, so neither stage re-transients at the seam.
3. **Low-pass identity collapses to the high-pass.** With the low-pass stage at identity (`high_num == high_den`), the band-pass equals the high-pass alone at the low cutoff — the upper edge opened all the way passes the whole high band. (The high-pass stage has no exact pass-through in this integer scheme — its identity coefficient is silence, not a bypass — so the symmetric collapse is stated honestly as absent, not faked.)
4. **The band rejects direct current.** A constant input settles to zero: the high-pass stage drives the constant to zero, and the low-pass of a settled zero stays zero. A band-pass keeps no DC.
5. **Reset re-opens.** After a settled run, `reset` returns both states to silence, so the next run re-opens both transients.
6. **Refusals by name, states untouched.** An illegal coefficient on either stage refuses `BadCoeff`; an out-of-range span refuses `BadRange`; each before any write, leaving the clip and both states untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM buffers on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the coefficients still smooth over sample indices; a crossover named in hertz is the later time-base rung. Both stage states run at full i64 precision, as in ALES40.

## Witness

`tools/ales_band_witness.rish` — build `lotus/band.rye`, run its selftest, assert the `GREEN ales-band` line, and re-prove ALES45's carried high-pass still stands green under the new composition.

---

*The middle kept, the edges let go — the band-pass asks for nothing the tree has not already proven, only that the two proven filters meet cleanly. May the next rung sweep this band, or name its two cutoffs in hertz.*
