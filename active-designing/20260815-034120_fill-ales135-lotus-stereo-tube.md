# Fill ALES135 — `lotus/stereo_tube.rye`, the asymmetric tube drive carried into stereo, one shared uneven rail

**Stamp:** `20260815.034120` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- proposes a shape and cites the witnesses that bind what already landed.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES135**
**Kin:** [`20260815-033358_fill-ales134-lotus-stereo-fold.md`](20260815-033358_fill-ales134-lotus-stereo-fold.md) · [`20260814-212318_fill-ales82-lotus-tube-drive.md`](20260814-212318_fill-ales82-lotus-tube-drive.md)

---

## Where the ladder stands

The stereo **nonlinear** class now holds three of the four DRIVE readings of an over-boosted wave: ALES132 *pinned* the excess at the ceiling (the hard clip), ALES133 *rounded* the corner below it (the soft clip), ALES134 *reflected* the excess back down (the wavefolder). All three share one honest property — they are **odd** functions, shaping a sample's magnitude and carrying its sign, so a symmetric input drives to a symmetric output and only odd harmonics arise. This rung carries the family's one member that breaks that symmetry on purpose: ALES82's **asymmetric tube drive**, which pins the positive half of the wave at `ceil_pos` and the negative half at `ceil_neg`, the uneven clipping where a real vacuum tube's warm **even**-order harmonics are born.

The stereo lesson holds exactly as ALES132 stated it, and the tube adds a second edge to it. A tube drive is nonlinear, so a shared map does **not** hold the inter-channel ratio — and because the map is also **not odd**, it does not hold the inter-channel *antisymmetry* either. An out-of-phase master (right the negation of left) driven through unequal ceilings comes back **not** out-of-phase: the left's positive peak pins to `ceil_pos` while the right's mirrored negative peak pins to `−ceil_neg`, and `ceil_pos ≠ ceil_neg`, so the mirror is broken. That is the tube's even-harmonic signature read in the stereo field, not a bug to design around.

## The crux this round

`stereo_tube(sc, start, count, num, den, ceil_pos, ceil_neg)` tube-drives `[start, start+count)` in **both** channels of a `StereoClip` (ALES10) by the same gain `num/den` (at least unity) into the same two ceilings, running ALES82's proven mono `tube` on each. It validates **both channels before either is mutated**: `tube` can refuse `BadGain`, `BadCeiling` (either ceiling outside `[1, sample_max]`), or `BadRange` — each depending only on the shared parameters or the shared length, so every check is made **once** up front, and a refusal never drives one channel and leaves the other dry. `TubeError` is reused whole; the stereo lift invents no new fault and no new primitive.

## The four laws proven

- **THE STEREO TUBE LAW** — each channel equals ALES82's mono `tube` with the same `(num, den, ceil_pos, ceil_neg)` over the same span, **byte for byte**: the positive half pinned to `ceil_pos`, the negative half to `−ceil_neg`, per channel.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a tube drive writes values only.
- **THE PER-CHANNEL ASYMMETRIC LAW** — the tube is nonlinear *and* not odd, so a shared map holds neither the inter-channel ratio nor the inter-channel antisymmetry: a 1:2 master's ratio compresses toward the rail, and an out-of-phase master comes back **not** out-of-phase (`ceil_pos ≠ ceil_neg` breaks the mirror). Yet per channel the discipline holds — the positive half is at most `ceil_pos`, the negative at least `−ceil_neg`, the sign is never flipped, and an identical-channel master stays identical. The **family recognition**: `ceil_pos == ceil_neg` degenerates both channels to ALES132's stereo hard drive, byte for byte — this rung only generalizes, never replaces.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (`BadGain`, `BadCeiling` on either side, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; a unity drive whose samples already sit within both rails is the identity on both, `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES82's own `tube`, fabricating none and changing no length; the gain is a rational `num/den` (unity = 1/1), the two ceilings magnitudes in sample units (not decibels), the shape a piecewise-constant asymmetric clip, instantaneous (no attack/release, no anti-aliasing — the harmonics fold in the i16 domain exactly as any integer clipper's). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_tube.rye` — the module.
- `tools/ales_stereo_tube_witness.rish` — the witness.
