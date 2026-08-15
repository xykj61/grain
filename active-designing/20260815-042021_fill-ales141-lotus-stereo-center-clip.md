# Fill ALES141 — `lotus/stereo_center_clip.rye`, the center clipper carried into stereo, opening the dead-zone family in stereo

**Stamp:** `20260815.042021` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES141**
**Kin:** [`20260815-041250_fill-ales140-lotus-stereo-inverted-half-wave.md`](20260815-041250_fill-ales140-lotus-stereo-inverted-half-wave.md) · [`20260814-215834_fill-ales87-lotus-center-clipper.md`](20260814-215834_fill-ales87-lotus-center-clipper.md)

---

## Where the ladder stands

The stereo nonlinear class has carried its **DRIVE corners** — the hard clip (ALES132), soft drive (ALES133), wavefold (ALES134), tube (ALES135) — the resolution corner (crush, ALES136), and the whole **rectifier family** — full-wave (ALES138), positive half-wave (ALES139), inverted half-wave (ALES140). Each of those caps or folds or hollows the wave through a shared shape on both speakers. This rung opens a fresh corner of the class: ALES87's **center clipper**, `y = if |x| ≤ t then 0 else x` — silence the quiet middle, pass the loud through untouched. Where the hard clip caps the LOUD extremes at a ceiling, the center clip hollows the QUIET middle below a floor; run together in stereo they keep only the band `t < |x| ≤ ceil`.

## The crux this round — one shared dead zone on both speakers, and the odd law held in stereo

A Lotus master is a **StereoClip** (ALES10), two Clips heard together whose defining invariant is that LEFT and RIGHT hold the same length. This rung carries the center clip into stereo the plain way: run ALES87's proven mono `center_clip` on each channel with the **same threshold**, so one dead zone lands on both speakers together. Unlike the crush and the tube (which are NOT odd, breaking the inter-channel antisymmetry), the center clipper **IS odd** — `|−x| = |x|`, so `center_clip(−x) = −center_clip(x)`. That is the rung's distinguishing law read in the stereo field: an **out-of-phase** master (right = −left) center-clipped through the same threshold comes back **still out of phase** (right = −left), exactly as the rectifier siblings' odd members did, because the dead-zone map is symmetric about zero. A 1:2 master keeps its ratio on the passed samples (both silenced together in the dead zone, both passed together above it), and an identical-channel master stays identical.

## The crux, as a lift

`stereo_center_clip(sc, start, count, thresh)` center-clips `[start, start+count)` in **both** channels of a `StereoClip`, running ALES87's mono `center_clip` on each. The map is **exact** for every i16 with no rail edge and no saturate — the only values written are `0` and the untouched input. It carries **one parameter**, the threshold magnitude, and names **two faults**: `BadThreshold` (a threshold outside `[0, sample_max]` — negative is impossible for a magnitude, above the rail is a floor nothing could clear) and `BadRange` (a span outside the samples). Both checks depend only on the shared threshold and the shared length, so each is made **once up front** before either channel is mutated — a refusal never center-clips one channel and leaves the other whole. `CenterClipError` is reused whole; the stereo lift adds no fault.

## The four laws proven

- **THE STEREO CENTER-CLIP LAW** — each channel equals ALES87's mono `center_clip` with the same threshold over the same span, **byte for byte**: every quiet sample (`|x| ≤ t`) silenced to 0 and every louder sample passed unchanged, no rail edge.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a center clip writes values only.
- **THE PER-CHANNEL ODD LAW (held in stereo)** — the center clipper is odd (`|−x| = |x|`), so a shared dead zone **holds** the inter-channel antisymmetry: an out-of-phase master (right = −left) comes back still out of phase (right = −left), the mirror the crush and tube broke. Per channel every output is either 0 or exactly its input, the map is idempotent (twice equals once), a 1:2 master keeps its ratio on the passed samples, an identical-channel master stays identical, and `thresh = 0` is the identity.
- **THE ATOMICITY / DEGENERATE LAW** — each refusal (`BadThreshold`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; `thresh = 0` the identity on both, `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES87's own `center_clip`, each output either silence or exactly its input, never a length; the shape is a static dead-zone threshold on instantaneous magnitude, memoryless (no attack/release, no envelope, no anti-aliasing). No saturate is owed — the only values written are 0 and the legal input. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_center_clip.rye` — the module.
- `tools/ales_stereo_center_clip_witness.rish` — the witness.
