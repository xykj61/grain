# Fill ALES155 — Lotus's stereo_dc_remove: the DC-offset remover carried into stereo, two independent means, the image-preserving translation

**Stamp:** `20260815.060518` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES155
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-060518_fill-ales154-lotus-stereo-smooth-trim.md`](20260815-060518_fill-ales154-lotus-stereo-smooth-trim.md)

---

## The next crux, honestly chosen

The silence/analysis family is now whole in stereo (ALES146–154). Turning back to the still-unlifted processing rungs, `dc_remove` (ALES90) and `dc_block` (ALES91) are the highest mono rungs with no stereo twin — and DC removal is the tool every chain reaches for right after a nonlinearity, so it is the crux that lets the whole even-harmonic drive family (rectifier, tube, crush) be used honestly in stereo. In ascending order the block-mean remover (ALES90) comes first and is the foundation of the one-pole blocker (ALES91), so this rung takes it.

## The shape — the image-preserving counterpoint to the rectifier

`stereo_dc_remove(sc, start, count)` is the length-preserving per-channel lift, the same corner ALES138 (`stereo_rectify`) took: validate the span once against the shared length, then run ALES90's proven mono `dc_remove` on each channel over `[start, start+count)`. The stereo insight is that the two channels carry **their own offsets** — an even map or asymmetric clip biases them by different amounts — so each channel removes its **own** mean, independently. `StereoDcError = dc_remove.DcError` (BadRange) reused whole; the lift adds no fault.

Where the rectifier is an even map that **collapses** an out-of-phase master to mono, DC removal is a per-channel **pure translation**, and a translation preserves every sample-to-sample difference — so it **preserves** the image. This rung is the honest opposite pole of ALES138, and the two prove the same field from two sides.

## The laws proven

- **The stereo DC-remove law (the crux):** each channel equals ALES90's mono `dc_remove` over the same span byte for byte — proven against the mono remover directly, a left biased +1100 and a right biased −500.
- **The independent-offset law (the stereo crux):** two channels carrying different offsets each land under one LSB independently — the left's offset never leaking into the right, a zero-mean channel unchanged while its partner is corrected.
- **The image-preserve law:** an out-of-phase master (right = −left AC) riding a common-mode +1000 offset returns **still exactly out of phase** — the antisymmetry kept, the honest opposite of the rectifier's collapse; a both-zero-mean master unchanged exactly; the map idempotent where nothing saturates.
- **The composition law:** it undoes the stereo rectifier's per-channel offset — a symmetric master rectified through ALES138 rides a positive DC on both channels (left 18000, right 12000), and `stereo_dc_remove` restores a near-zero mean on each.
- **The balance / atomicity / degenerate law:** `left.len == right.len` after (values only); a refusal leaves both channels byte for byte untouched and still balanced; `count = 0` and the empty span are the identity on both.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips DC-removed through the proven mono remover — a two-pass block statistic per channel (sum in i64 so the accumulation never overflows, then subtract, one saturate per sample), memoryless, no carried state, never a length. The "DC" is the arithmetic mean of the block, the zero-frequency component by definition, not a claim about any hardware highpass; the one-pole IIR DC blocker with carried state (ALES91) is the next rung. No real sample rate, no anti-aliasing, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
