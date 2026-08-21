# Fill ALES134 — `lotus/stereo_fold.rye`, the wavefolder carried into stereo, one shared triangle

**Stamp:** `20260815.033358` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES134**
**Kin:** [`20260815-032747_fill-ales133-lotus-stereo-soft-drive.md`](20260815-032747_fill-ales133-lotus-stereo-soft-drive.md) · [`20260814-210615_fill-ales80-lotus-wavefolder.md`](20260814-210615_fill-ales80-lotus-wavefolder.md)

---

## Where the ladder stands

ALES132 opened the stereo **nonlinear** class on the hard clip (the excess *pinned* at the ceiling), ALES133 rounded that corner with the soft clip. This rung carries the third DRIVE reading of the same excess: ALES80's **wavefolder**, where the part of a boosted wave that would cross the ceiling **reflects back down** instead of pinning — a triangle in the boosted magnitude with period `2·ceil`, the West-Coast fold that turns a plain tone into a bright metallic swarm. Where the clip builds a wall, the fold builds a mirror.

The nonlinear lesson holds as ALES132 stated it, honestly: a fold is nonlinear, so the same shared triangle does **not** preserve the inter-channel ratio in general — a 1:2 master folded through a ceiling can land both channels on the *same* value (a 1000/2000 field folded through 1500 gives 1000/1000), the ratio collapsing not by pinning but by reflection. What the shared map *does* keep, per channel, is the ceiling and sign discipline; and an identical-channel master still folds to an identical-channel output.

## The crux this round

`stereo_fold(sc, start, count, num, den, ceil)` wavefolds `[start, start+count)` in **both** channels of a `StereoClip` (ALES10) by the same gain `num/den` (at least unity) into the same ceiling, running ALES80's proven mono `wavefold` on each. It validates **both channels before either is mutated**: `wavefold` can refuse `BadGain`, `BadCeiling` (a ceiling outside `[1, sample_max]`), or `BadRange` — each depending only on the shared parameters or the shared length, so every check is made **once** up front, and a refusal never folds one channel and leaves the other dry. `FoldError` is reused whole.

## The four laws proven

- **THE STEREO FOLD LAW** — each channel equals ALES80's mono `wavefold` with the same `(num, den, ceil)` over the same span, **byte for byte**: a boosted sample below the ceiling passes clean, the excess above reflecting back down the triangle.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a fold writes values only.
- **THE PER-CHANNEL NONLINEAR LAW** — a fold is nonlinear, so a shared triangle does **not** hold the inter-channel ratio (a 1:2 master folded through a ceiling landing both channels on one value, the ratio collapsing by reflection); yet the ceiling and sign discipline hold per channel (every output magnitude at most `ceil`, every sign matching its input), and an identical-channel master stays identical. Where the hard drive (ALES132) *pins* the excess, the fold *reflects* it — the two agree below the ceiling and diverge above.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (`BadGain`, `BadCeiling`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; a unity fold whose samples all sit below the ceiling is the identity on both, `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES80's own `wavefold`, fabricating none and changing no length; the gain is a rational `num/den`, the ceiling a magnitude in sample units (not decibels), the fold a piecewise-linear triangle, instantaneous (no attack/release, no anti-aliasing). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_fold.rye` — the module.
- `tools/ales_stereo_fold_witness.rish` — the witness.
