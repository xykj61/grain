# Fill ALES142 — `lotus/stereo_soft_center_clip.rye`, the soft center clipper carried into stereo, the continuous dead zone that holds phase yet breaks ratio

**Stamp:** `20260815.042641` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES142**
**Kin:** [`20260815-042021_fill-ales141-lotus-stereo-center-clip.md`](20260815-042021_fill-ales141-lotus-stereo-center-clip.md) · [`20260814-220520_fill-ales88-lotus-soft-center-clipper.md`](20260814-220520_fill-ales88-lotus-soft-center-clipper.md)

---

## Where the ladder stands

ALES141 opened the dead-zone corner in stereo with the **hard** center clipper — silence the quiet middle, pass the loud unchanged, leaving a **jump** at the boundary. This rung carries its continuous twin, ALES88's **soft center clipper**, `y = if |x| ≤ t then 0 else x − sign(x)·t` — it silences the same dead zone, then shifts every survivor **toward zero** by exactly the threshold, so the survivor rises **continuously** from zero (`|x| = t+1 → ±1`, not `±(t+1)`). It is the floor-side twin of the ceiling pair the DRIVE family already carries: ALES132's hard clip pins abruptly, ALES133's soft drive rounds the corner; ALES141's hard center clip jumps, this soft center clip is continuous.

## The crux this round — phase held, ratio broken, and NOT idempotent

The soft center clip is **odd** (`sign(−x)·t` flips with the sign), so like ALES141 it **holds** the inter-channel antisymmetry: an out-of-phase master (right = −left) comes back **still out of phase**. Yet unlike the hard center clip it is a **shift, not a mask**, and a shift is not scale-invariant — so the soft form **breaks** the inter-channel ratio: a 1:2 master does not stay 1:2, because subtracting the same `t` from both channels' survivors pulls the quieter one proportionally harder (`2x − t ≠ 2(x − t)`). And it is **NOT idempotent** — each pass subtracts `t` again. This is the honest middle of the class: the hard center clip (ALES141) held both ratio and antisymmetry and was idempotent; the soft center clip holds only the antisymmetry, stated plainly rather than dressed in symmetries it lacks.

## The soft/hard bond, read in stereo

Carried into stereo, the soft and hard center clips silence the **same** dead zone, and on every survivor the soft output is exactly `t` quieter in magnitude: `|soft| = |hard| − t`, per channel, per sample. This round proves that bond directly against ALES141's `stereo_center_clip` — the family read across the two dead-zone members.

## The crux, as a lift

`stereo_soft_center_clip(sc, start, count, thresh)` soft-center-clips `[start, start+count)` in **both** channels of a `StereoClip`, running ALES88's mono `soft_center_clip` on each with the same threshold. The map is **exact** for every i16 with no rail edge and no saturate — a positive survivor lands in `[1, sample_max]`, a negative in `[sample_min, −1]`, the dead zone at 0. It carries **one parameter** and names **two faults** (`BadThreshold` outside `[0, sample_max]`, `BadRange`), both checked **once up front** before either channel mutates. `SoftCenterClipError` reused whole.

## The four laws proven

- **THE STEREO SOFT CENTER-CLIP LAW** — each channel equals ALES88's mono `soft_center_clip` with the same threshold over the same span, **byte for byte**: the quiet middle silenced, every survivor shifted toward zero by `t`, the boundary continuous, no rail edge.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length.
- **THE PER-CHANNEL ODD / SHIFT LAW** — the soft center clip is odd, so a shared dead zone **holds** the inter-channel antisymmetry (an out-of-phase master staying out of phase); yet it is a **shift**, so it **breaks** the inter-channel ratio (a 1:2 master not staying 1:2) and is **NOT idempotent** (twice ≠ once); an identical-channel master stays identical; `thresh = 0` is the identity. The soft/hard bond holds per channel: `|soft| = |hard| − t` on every survivor, against ALES141's `stereo_center_clip`.
- **THE ATOMICITY / DEGENERATE LAW** — each refusal (`BadThreshold`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; `thresh = 0` and `count = 0` the identities on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips, siloed to `lotus/`. It changes sample values only, through ALES88's own `soft_center_clip`; the shape is a static continuous dead-zone threshold on instantaneous magnitude, memoryless. No saturate is owed — every output fits the i16 rail by construction. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_soft_center_clip.rye` — the module.
- `tools/ales_stereo_soft_center_clip_witness.rish` — the witness.
