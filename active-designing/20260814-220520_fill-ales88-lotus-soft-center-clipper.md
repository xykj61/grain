# Fill ALES88 — Lotus's soft center clipper: silence the quiet middle and subtract the threshold, the continuous dead-zone that completes the bracket

**Stamp:** `20260814.220520` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Design read — self-approved round (no custody gate; ALES87's own doc names the soft dead-zone as its plain sibling, and the DRIVE family already carries a hard/soft pair on the ceiling side)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES88**
**Kin:** [`../lotus/center_clip.rye`](../lotus/center_clip.rye) (ALES87 — the hard center clipper silences the quiet middle and passes the loud *unchanged*, a jump at the boundary; this rung subtracts the threshold so the survivor rises *continuously* from zero) · [`../lotus/soft_drive.rye`](../lotus/soft_drive.rye) (ALES79 — the soft-clip overdrive, the rounded sibling of ALES78's hard clip; the ceiling-side pair this rung mirrors on the floor side) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max)

---

## Why this rung

The DRIVE family already carries a **hard/soft pair on the ceiling side**: the hard-clip drive (ALES78) pins abruptly at the corner, and the soft-clip overdrive (ALES79) rounds that corner into a shoulder. ALES87 opened the **floor side** with the hard center clipper — silence the quiet middle, pass the loud *unchanged* — yet it leaves a **jump** at the boundary: a sample at `|x| = t` becomes `0`, and the very next louder sample at `|x| = t+1` leaps straight to `t+1`. That discontinuity is a click, the floor-side twin of the hard clip's buzz.

This rung rounds it. The **soft center clipper** silences the same quiet middle, then **subtracts the threshold** from every surviving sample so the curve is **continuous** at the boundary: `y = if |x| ≤ t then 0 else x − sign(x)·t`. A survivor at `|x| = t+1` now rises to `±1` rather than leaping to `±(t+1)` — the output climbs smoothly out of silence. This is the classic **continuous center clipper** of noise reduction and the static curve of a **downward expander**: it not only silences the quiet, it pulls the surviving signal gently toward zero by exactly the threshold, so nothing jumps. Lindy-first, the continuous dead-zone is the form a real hiss remover uses precisely because it has no click; crux-first, it is the recognition that **the soft center clip is the hard center clip with its boundary made continuous — and the hard center clip is the soft one read at the survivor's own value rather than shifted.**

## The crux — `x − sign(x)·t`, exact for every i16, the soft clip read on the floor

`y = if |x| ≤ t then 0 else x − sign(x)·t` never leaves the rail. A sample inside the dead zone becomes `0`; a positive survivor drops to `x − t` (still positive, since `x > t`); a negative survivor rises to `x + t` (still negative, since `x < −t`). Every branch lands in a legal i16 by construction — `[1, sample_max]` for positive survivors, `[sample_min, −1]` for negative, `0` for the dead zone — so, like ALES87, the soft center clipper needs **no saturate**:

```
mag = |x|                                       // in i32 so |sample_min| = 32768 is representable
y   = if mag <= t then 0 else x - sign(x)*t      // silence the quiet; shift the survivor toward zero by t
```

Stated positively, the soft center clipper is **the loud kept whole minus the threshold; the quiet middle silenced.** The map is **memoryless** and **odd** (`sign(−x)·t` flips with the sign, so a symmetric input yields a symmetric output — odd harmonics). Unlike the hard center clipper it is **not idempotent** — each pass subtracts `t` again — and that is honest: the soft dead-zone is a shift, not a mask, and stating so plainly is truer than dressing it in a symmetry it lacks.

## The bracket, and the family

The two center clippers silence the **same** dead zone and differ only in the surviving band:

- **Hard center clip** (ALES87): a survivor passes at its own value `x` — a jump at the boundary.
- **Soft center clip** (ALES88): a survivor passes at `x − sign(x)·t` — continuous from zero, exactly `t` quieter in magnitude.

So on every survivor `|soft| = |hard| − t`: the soft form is the hard form pulled toward zero by the threshold. Together the DRIVE family now carries a **hard/soft pair on each side** — the ceiling (hard clip / overdrive) and the floor (hard / soft center clip). Two degenerate readings anchor the rung: a threshold of **zero** is the **identity** (no sample is silenced and nothing is subtracted), and a threshold at the rail (**sample_max**) silences the whole wave save `sample_min`, which survives shifted to `sample_min + sample_max = −1`.

## Shape

`lotus/soft_center_clip.rye` offers `soft_center_clip(clip, start, count, thresh)` — it silences each sample in `[start, count)` whose magnitude is at most `thresh` and shifts every louder sample toward zero by `thresh`. It names exactly two faults, the same as ALES87:

- `BadThreshold` — a threshold below zero (a magnitude is never negative) or above `sample_max` (a floor no positive sample could clear).
- `BadRange` — a span outside the current samples (the suite's shared span law).

## The laws to prove

1. **A threshold of zero is the identity** — nothing is silenced and nothing subtracted, so the clip passes byte-for-byte.
2. **The quiet middle is silenced, the loud shifted inward** — at `t = 1000`: `500→0`, `1000→0` (the `≤`), `1500→500`, `3000→2000`, `−1500→−500`, `−3000→−2000`, read by hand.
3. **The boundary is continuous** — `|x| = t` → `0` and `|x| = t+1` → `±1` (rises from zero, no jump), the whole point against ALES87's leap to `±(t+1)`; read on both signs.
4. **The map is odd** — `soft_center_clip(−x) = −soft_center_clip(x)`, a symmetric input to a symmetric output (odd harmonics).
5. **The soft/hard bond** — the soft and hard center clips silence the same dead zone, and on every survivor `|soft| = |hard| − t` (the soft form exactly `t` quieter), proven sample for sample against ALES87.
6. **A rail threshold silences all but the deepest sample** — `t = sample_max` zeros every sample except `sample_min`, which survives shifted to `−1`.
7. **The span discipline holds** — only `[start, count)` changes.
8. **Each fault refuses by name** — a negative and an over-rail threshold refuse `BadThreshold`; a span past the end refuses `BadRange`; the clip untouched before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The shape is a static continuous dead-zone on instantaneous magnitude, memoryless — no attack/release, no envelope, no anti-aliasing. One magnitude, one compare, one signed subtract per sample; no saturate (every output fits the rail by construction), no delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real sample rate.

## What this opens

The DRIVE family now carries a hard/soft pair on both the ceiling and the floor — the wave shaped smoothly from above and below. Beyond it the loop names its own next Lotus crux (the booked **DC blocker** that removes the offset the rectifier and asymmetric-drive rungs introduce, or a fresh DSP family) as its own self-approved design round.

## Witness

`tools/ales_soft_center_clip_witness.rish` — builds `lotus/soft_center_clip.rye`, runs its selftest, and asserts the single `GREEN ales-soft-center-clip` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_soft_center_clip_witness.rish
```
