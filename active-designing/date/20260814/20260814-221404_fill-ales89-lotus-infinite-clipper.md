# Fill ALES89 — Lotus's infinite clipper: pin the survivor to the rail, the infinite-gain limit that completes the dead-zone trilogy

**Stamp:** `20260814.221404` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the center-clip pair already names the survivor's fate as its axis, and this rung reads the third and last reading of that axis)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES89**
**Kin:** [`../lotus/center_clip.rye`](../lotus/center_clip.rye) (ALES87 — the hard center clip; the survivor *passes* at its own value) · [`../lotus/soft_center_clip.rye`](../lotus/soft_center_clip.rye) (ALES88 — the soft center clip; the survivor is *shifted* toward zero by the threshold) · [`../lotus/drive.rye`](../lotus/drive.rye) (ALES78 — the hard clip whose ceiling this rung pushes to its limit) · [`../lotus/crush.rye`](../lotus/crush.rye) (ALES81 — the 1-bit crush, a *floored* two-level map, so its two levels are `0` / `sample_min`, not the rail-symmetric pair this rung yields) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max)

---

## Why this rung

The two center clippers (ALES87, ALES88) share one dead zone and differ only in **what happens to the survivor** — the sample loud enough to clear the threshold:

- **Hard center clip** (ALES87): the survivor **passes** at its own value `x` — a jump at the boundary.
- **Soft center clip** (ALES88): the survivor is **shifted** toward zero by `t` — continuous from zero.

There is a third and final reading of that same axis, and it is the loudest one: the survivor is **pinned to the rail**. The **infinite clipper** silences the same quiet middle, then slams every louder sample all the way to `±sample_max` — `y = if |x| ≤ t then 0 else sign(x)·sample_max`. This is the infinite-gain limit of the whole clip family: where the hard clip (ALES78) pins only the part of the wave *above* its ceiling and passes the rest linearly, the infinite clip discards every trace of amplitude and keeps only the **sign** — the zero-crossings. A sine in becomes a square out; the harshest, most recognizable fuzz there is, the comparator of every zero-crossing detector, the "square-wave fuzz" of the pedal world.

Lindy-first, the comparator/square is a primitive that reads true for decades — it is how a tuner finds a pitch, how a fuzz pedal makes its wall of odd harmonics, how a 1-bit sign is taken. Crux-first, it is the recognition that **the survivor's fate has exactly three readings — pass, shift, pin — and this rung is the last of the three**, closing the dead-zone trilogy the center clippers opened.

## The crux — `sign(x)·sample_max`, exact for every i16, exactly odd, no saturate

`y = if |x| ≤ t then 0 else sign(x)·sample_max` never leaves the rail. Only three values can ever be written — `−sample_max`, `0`, `sample_max` — and every one is a legal i16 by construction, so, like both center clippers, the infinite clipper needs **no saturate**.

The negative survivor is pinned to `−sample_max` (`−32767`), **not** `sample_min` (`−32768`), on purpose: with `−sample_max` the map is **exactly odd** — `infinite_clip(−x) = −infinite_clip(x)` for *every* i16, the deepest sample included (`sample_min → −sample_max = −infinite_clip(sample_max)`). Choosing `sample_min` would buy one extra LSB of negative swing at the cost of the odd symmetry the whole DRIVE family prizes; the rung states the one-LSB rail care plainly and keeps the symmetry, exactly as the full-wave rectifier and the soft center clipper handle the same two's-complement corner.

```
mag = |x|                                        // in i32 so |sample_min| = 32768 is representable
y   = if mag <= t then 0 else sign(x)*sample_max  // silence the quiet; pin the loud to the rail
```

The map is **memoryless** (every output depends only on its own input) and **odd**. It is **idempotent for every threshold below the rail** — a pinned survivor has magnitude `sample_max = 32767`, which clears any threshold `t ≤ 32766`, so a second pass leaves it at the rail; only at `t = sample_max` does the pinned survivor itself fall back into the dead zone (magnitude `32767 ≤ 32767`) and drop to `0`, so idempotence holds precisely on `[0, sample_max − 1]` and the rung states that boundary rather than claiming a symmetry it lacks at the rail.

## The trilogy, and the family

The three dead-zone maps silence the **same** middle and differ only in the surviving band:

| Rung | Survivor `x` (with `|x| > t`) becomes | Boundary at `|x| = t+1` |
|---|---|---|
| ALES87 hard center clip | `x` (passes) | `±(t+1)` — a small jump |
| ALES88 soft center clip | `x − sign(x)·t` (shifted) | `±1` — continuous |
| **ALES89 infinite clip** | `sign(x)·sample_max` (pinned) | `±sample_max` — the infinite-gain jump |

The pure comparator is the degenerate `t = 0`: every nonzero sample pins to the rail, only exact silence survives as `0`. Read against the DRIVE family's other two-level map, the 1-bit crush (ALES81): the crush **floors** the signed value, so its two levels are `0` (for `x ≥ 0`) and `sample_min` (for `x < 0`) — an *even*, DC-heavy map. The infinite clip is *odd* and rail-symmetric (`±sample_max` about `0`). Two two-level maps, opposite symmetries — the honest distinction is worth proving sample-for-sample.

## Shape

`lotus/infinite_clip.rye` offers `infinite_clip(clip, start, count, thresh)` — it silences each sample in `[start, count)` whose magnitude is at most `thresh` and pins every louder sample to `sign(x)·sample_max`. It names exactly two faults, the same pair by name as the center clippers (Zig merges error sets by name):

- `BadThreshold` — a threshold below zero (a magnitude is never negative) or above `sample_max` (a floor no positive sample could clear).
- `BadRange` — a span outside the current samples (the suite's shared span law).

## The laws to prove

1. **The pure comparator** — at `t = 0`, every nonzero sample pins to `±sample_max` and exact `0` stays `0`; read by hand on both signs and the deepest rail (`sample_min → −sample_max`).
2. **The dead-band comparator** — at `t = 1000`, `|x| ≤ 1000 → 0` and every louder sample → `±32767`, read by hand.
3. **The boundary is the infinite-gain jump** — `|x| = t → 0` and `|x| = t+1 → ±sample_max` (the whole point against ALES88's continuous `±1`); read on both signs.
4. **The map is exactly odd** — `infinite_clip(−x) = −infinite_clip(x)` on symmetric pairs including `sample_min`/`sample_max`.
5. **Idempotent below the rail** — a mid threshold applied twice equals once (the pinned rail survives its own dead zone); named precisely, since `t = sample_max` is the sole exception.
6. **Only three values ever appear** — every output is `−sample_max`, `0`, or `sample_max`.
7. **The same dead zone as the center clips** — the infinite clip silences exactly the samples ALES88 silences at the same `t`, proven sample-for-sample; and its odd rail pair is *not* the 1-bit crush's floored `0`/`sample_min` pair.
8. **The span discipline holds** — only `[start, count)` changes.
9. **Each fault refuses by name** — a negative and an over-rail threshold refuse `BadThreshold`; a span past the end refuses `BadRange`; the clip untouched before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The shape is a static dead-zone comparator on instantaneous magnitude, memoryless — no attack/release, no envelope, no hysteresis (a Schmitt trigger's memory is a different, later rung), no anti-aliasing (a square is a heavy odd-harmonic generator; band-limiting it is a separate concern). One magnitude, one compare, one signed constant per sample; no saturate (every output is a legal i16 by construction), no delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real sample rate.

## What this opens

The dead-zone trilogy is closed — pass, shift, pin. Beyond it the loop names its own next Lotus crux (the booked **DC blocker** that removes the offset the rectifiers and the 1-bit crush introduce, a **hysteresis comparator** that gives this rung a memory against chatter, or a fresh DSP family) as its own self-approved design round.
