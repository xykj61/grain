# Fill ALES87 — Lotus's center clipper: silence the quiet middle, pass the loud, the static-curve sibling of the noise gate

**Stamp:** `20260814.215834` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the DRIVE family's opener names its static-curve complement, and the rectifier family just closed leaves the dead-zone as the plainest waveshaper still unbuilt)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES87**
**Kin:** [`../lotus/drive.rye`](../lotus/drive.rye) (ALES78 — the hard-clip drive caps the loud at a ceiling `pin(x, ±ceil)`; this rung is its mirror, silencing the quiet below a floor) · [`../lotus/gate.rye`](../lotus/gate.rye) (ALES51 — the noise gate silences the wave when its *level* falls below a threshold; the center clipper is that decision made *static and per-sample*) · [`../lotus/rectify.rye`](../lotus/rectify.rye) (ALES84 — the full-wave rectifier, the memoryless-and-exact aesthetic this rung keeps) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max)

---

## Why this rung

The DRIVE family opened with the hard-clip drive (ALES78): boost a signal and let a **ceiling** catch what overflows — the loud extremes flattened, their flat top the harmonic voice. The rectifier family closed at ALES86, memoryless and exact. What the DRIVE family still lacks is the hard clipper's plain mirror — the **center clipper**, which does to the quiet middle what the clipper does to the loud extremes: where the clipper pins every sample past `±ceil` to the ceiling, the center clipper **silences every sample within a threshold `±t` and passes the rest unchanged**. `y = if |x| ≤ t then 0 else x`.

The noise gate (ALES51) already silences quiet — yet it silences the *whole wave* when the signal's *level* falls below a threshold, a dynamic decision that opens and closes over time. The center clipper is that same silencing made **static and per-sample**: it is a fixed nonlinearity, a memoryless waveshaper that hollows out the low-amplitude core of every wave sample by sample. That distinction is the crux — the gate is a dynamics processor with memory, the center clipper is a distortion curve without any. Lindy-first, the center clipper is a foundational tool in its own right: the classic hiss-and-crosstalk remover of telephony and tape noise reduction (Dolby, dbx), and the exact model of **crossover distortion** in a class-B amplifier, where the small signal near zero falls into the dead zone between two conducting halves.

## The crux — `if |x| ≤ t then 0 else x`, exact for every i16, the hard clip read as a floor not a ceiling

`y = if |x| ≤ t then 0 else x` never leaves the rail. A sample inside the dead zone becomes `0`; a sample outside it passes **byte-for-byte unchanged**. Neither branch can overflow — the only values written are `0` and the untouched input — so the center clipper, like the rectifiers, needs **no saturate**:

```
mag = |x|                              // computed in i32 so |sample_min| = 32768 is representable
y   = if mag <= t then 0 else x        // silence the quiet middle, pass the loud through untouched
```

The magnitude is taken in `i32` because `|sample_min|` is `32768`, one past the positive rail — the same care the full-wave rectifier owed. Stated positively, the center clipper is **the loud kept whole; the quiet middle silenced.** The map is **memoryless** (each output depends only on its own input), **idempotent** (a silenced `0` stays silenced, a passed sample stays passed), and **odd** (`|−x| = |x|`, so a symmetric input yields a symmetric output — the same odd-harmonic honesty the hard clip carries).

## The bracket, and the family

The hard clip and the center clip **bracket** the wave from opposite sides:

- **Hard clip** (ALES78): `|y| ≤ ceil` — the loud extremes capped at a ceiling.
- **Center clip** (ALES87): the quiet core within `±t` silenced — a floor carved out of the middle.

One caps the top, the other hollows the middle; run together they keep only the band `t < |x| ≤ ceil`. Two degenerate readings anchor the rung: a threshold of **zero** is the **identity** (only an already-silent `0` satisfies `|x| ≤ 0`, so nothing changes — the mirror of the hard clip's unity-gain identity), and a threshold at the rail (**sample_max**) silences the whole wave save the single deepest sample `sample_min`, whose magnitude `32768` alone exceeds it.

## Shape

`lotus/center_clip.rye` offers `center_clip(clip, start, count, thresh)` — it folds each sample in `[start, count)` to `0` when `|x| ≤ thresh` and leaves it untouched otherwise. It takes **one parameter**, the threshold magnitude `thresh`, and names exactly two faults:

- `BadThreshold` — a threshold below zero (a magnitude is never negative) or above `sample_max` (a floor no positive sample could clear is not a floor; the mirror of the drive's ceiling bound).
- `BadRange` — a span outside the current samples (the suite's shared span law).

A keeper who wants only the band between the noise floor and the ceiling runs this `center_clip` and ALES78's `drive` over the same span — one silences the quiet, the other caps the loud.

## The laws to prove

1. **A threshold of zero is the identity** — only `x = 0` satisfies `|x| ≤ 0`, and it is already `0`, so the whole clip passes byte-for-byte (the degenerate that proves the map adds nothing without a threshold).
2. **The quiet middle is silenced** — every sample with `|x| ≤ t` becomes `0`, read by hand (`500→0`, `−1000→0`, `999→0` at `t = 1000`).
3. **The loud pass unchanged** — every sample with `|x| > t` passes untouched (`1001→1001`, `−5000→−5000`, `sample_max→sample_max`, `sample_min→sample_min`).
4. **The threshold boundary is inclusive** — exactly `|x| = t` is silenced (the `≤`), and `|x| = t+1` passes; read the boundary by hand on both signs.
5. **The map is idempotent and odd** — a second center clip changes nothing; and `center_clip(−x) = −center_clip(x)`, a symmetric input to a symmetric output (odd harmonics).
6. **A rail threshold silences all but the deepest sample** — `t = sample_max` zeros every sample except `sample_min`, whose magnitude `32768 > 32767` alone clears the floor.
7. **The span discipline holds** — only `[start, count)` changes; samples outside are untouched.
8. **Each fault refuses by name** — a negative threshold and an over-rail threshold refuse `BadThreshold`; a span past the end refuses `BadRange`; the clip untouched before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The shape is a static dead-zone threshold on instantaneous magnitude, memoryless — no attack/release, no envelope, no anti-aliasing (the harmonics a center clip generates fold in the i16 domain exactly as any integer waveshaper). One magnitude and one compare per sample; no saturate, no delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real sample rate.

## What this opens

The DRIVE family now brackets the wave from both sides — the hard clip caps the loud, the center clip hollows the quiet. Beyond it the loop names its own next Lotus crux (a **soft dead-zone** that subtracts the threshold rather than silencing to zero, or a fresh DSP family) as its own self-approved design round.

## Witness

`tools/ales_center_clip_witness.rish` — builds `lotus/center_clip.rye`, runs its selftest, and asserts the single `GREEN ales-center-clip` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_center_clip_witness.rish
```
