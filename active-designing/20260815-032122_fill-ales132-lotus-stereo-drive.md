# Fill ALES132 — `lotus/stereo_drive.rye`, the hard-clip drive carried into stereo, one shared map, opening the stereo nonlinear class

**Stamp:** `20260815.032122` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES132**
**Kin:** [`20260815-031427_fill-ales131-lotus-stereo-crossfade.md`](20260815-031427_fill-ales131-lotus-stereo-crossfade.md) · [`20260814-204949_fill-ales78-lotus-hard-clip-drive.md`](20260814-204949_fill-ales78-lotus-hard-clip-drive.md)

---

## Where the ladder stands

The stereo **amplitude** class stands whole in three — normalize (ALES129, one measured shared scalar), fade (ALES130, one shared positional ramp), and crossfade (ALES131, one shared equal-power split). All three carried the same lesson: a per-channel quantity that is **identical** across channels preserves the stereo image for free, because scaling is **linear**. This rung opens the stereo **nonlinear** class on its foundation, ALES78's **hard-clip drive** — the DRIVE family's root, the pre-gain into a ceiling where a clipped wave's flat top is its harmonic voice (the grit of an overdriven amp, the crunch of a fuzz).

The nonlinear class states the amplitude class's lesson **in reverse, honestly**: a drive is not linear, so applying the *same* map to both channels does **not** preserve the inter-channel ratio in general — each channel clips against the same ceiling by its **own** level, so a louder channel clips harder. That is not a bug to design around; it is what a stereo drive *is*. What the shared map *does* keep, per channel, is the ceiling and sign discipline; and an identical-channel master still drives to an identical-channel output.

## The crux this round

`stereo_drive(sc, start, count, num, den, ceil)` drives `[start, start+count)` in **both** channels of a `StereoClip` (ALES10) by the same rational gain `num/den` (at least unity) into the same ceiling, running ALES78's proven mono `drive` on each. It validates **both channels before either is mutated**: `drive` can refuse `BadGain` (a zero denominator, a below-unity gain, an oversized numerator), `BadCeiling` (a ceiling outside `[1, sample_max]`), or `BadRange` (a span outside the samples). `BadGain` and `BadCeiling` depend only on the shared parameters, and `BadRange` on the shared length — so every check is made **once** up front, and a refusal never drives one channel and leaves the other dry. `DriveError` is reused whole.

## The four laws proven

- **THE STEREO DRIVE LAW** — each channel equals ALES78's mono `drive` with the same `(num, den, ceil)` over the same span, **byte for byte**: a boosted sample within the ceiling passes at its boosted value, one past pins to `sign(x)·ceil`.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a drive writes values only.
- **THE PER-CHANNEL NONLINEAR LAW** — the crux made checkable and honest: a drive is nonlinear, so a shared map does **not** hold the inter-channel ratio (a 1:2 master driven hard clips both toward the ceiling, the ratio compressing) — unlike the linear amplitude class; yet the ceiling and sign discipline hold per channel (every output magnitude at most `ceil`, every sign matching its input), and an identical-channel master stays identical (a shared map on equal inputs gives equal outputs).
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (`BadGain`, `BadCeiling`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; a unity drive at the rail is the identity on both, `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES78's own `drive` (itself ALES6's i64 gain into ALES49's ceiling law), fabricating none and changing no length; the drive gain is a rational `num/den`, the ceiling a magnitude in sample units (not decibels), the clip instantaneous (no attack/release, no anti-aliasing). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_drive.rye` — the module.
- `tools/ales_stereo_drive_witness.rish` — the witness.
