# Fill ALES133 — `lotus/stereo_soft_drive.rye`, the soft-clip overdrive carried into stereo, one shared shoulder

**Stamp:** `20260815.032747` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES133**
**Kin:** [`20260815-032122_fill-ales132-lotus-stereo-drive.md`](20260815-032122_fill-ales132-lotus-stereo-drive.md) · [`20260814-205812_fill-ales79-lotus-soft-clip-overdrive.md`](20260814-205812_fill-ales79-lotus-soft-clip-overdrive.md)

---

## Where the ladder stands

ALES132 opened the stereo **nonlinear** class on ALES78's hard-clip drive — the sharp corner, a boosted sample pinned abruptly at the ceiling. The DRIVE family holds two corners in mono: the sharp (ALES78) and the **rounded** (ALES79's `soft_drive`, the overdrive whose knee opens a half-slope shoulder below the ceiling, the warmth of a pushed tube rather than the buzz of a fuzz). This rung carries that rounded corner into stereo, the sibling of ALES132: run ALES79's proven mono `soft_drive` on each channel with the **same** rational gain, knee, and ceiling, so one overdrive lands on both speakers together.

The nonlinear lesson holds exactly as ALES132 stated it, honestly: a soft drive is still nonlinear, so the same shared shoulder does **not** preserve the inter-channel ratio in general — each channel bends toward the same ceiling by its own level, a louder channel bending harder. What the shared map *does* keep, per channel, is the ceiling and sign discipline (an odd waveshaper never flips a sample, never crosses the ceiling); and an identical-channel master still soft-drives to an identical-channel output.

## The crux this round

`stereo_soft_drive(sc, start, count, num, den, knee, ceil)` soft-drives `[start, start+count)` in **both** channels of a `StereoClip` (ALES10) by the same gain `num/den` (at least unity) through the same knee into the same ceiling, running ALES79's proven mono `soft_drive` on each. It validates **both channels before either is mutated**: `soft_drive` can refuse `BadGain` (a zero denominator, a below-unity gain, an oversized numerator), `BadKnee` (a knee below one sample unit or above the ceiling), `BadCeiling` (a ceiling outside `[1, sample_max]`), or `BadRange` (a span outside the samples). Every fault depends only on the shared parameters or the shared length — so each check is made **once** up front, and a refusal never soft-drives one channel and leaves the other dry. `SoftDriveError` is reused whole; the stereo lift adds no new fault.

## The four laws proven

- **THE STEREO SOFT-DRIVE LAW** — each channel equals ALES79's mono `soft_drive` with the same `(num, den, knee, ceil)` over the same span, **byte for byte**: a boosted sample below the knee passes clean, one in the shoulder rises at half slope, one past the top pins to `sign(x)·ceil`.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a soft drive writes values only.
- **THE PER-CHANNEL NONLINEAR LAW** — a soft drive is nonlinear, so a shared shoulder does **not** hold the inter-channel ratio (a 1:2 master driven hard enough bends both toward the ceiling, the ratio compressing) — unlike the linear amplitude class; yet the ceiling and sign discipline hold per channel (every output magnitude at most `ceil`, every sign matching its input), and an identical-channel master stays identical. A **knee AT the ceiling** degenerates both channels to ALES132's hard drive, proven byte for byte — the two stereo corners are one waveshaper read at two knee positions.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (`BadGain`, `BadKnee`, `BadCeiling`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; a unity drive at the rail is the identity on both, `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES79's own `soft_drive` (itself ALES78's pre-gain and ceiling with a knee opened below it), fabricating none and changing no length; the gain is a rational `num/den`, the knee and ceiling magnitudes in sample units (not decibels), the shape a piecewise-linear waveshaper, instantaneous (no attack/release, no anti-aliasing). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_soft_drive.rye` — the module.
- `tools/ales_stereo_soft_drive_witness.rish` — the witness.
