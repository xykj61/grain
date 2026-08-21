# Fill ALES60 — Lotus's downward expander: the compressor mirrored under the threshold

**Stamp:** `20260814.183030` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Design read — self-approved round (no custody gate; a fresh dynamics gesture on the proven idiom)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES60**
**Kin:** [`../lotus/compress.rye`](../lotus/compress.rye) (ALES50 — the excess-above-threshold law this mirrors) · [`../lotus/gate.rye`](../lotus/gate.rye) (ALES51 — the below-threshold floor, the expander's infinite-ratio limit) · [`../lotus/README.md`](../lotus/README.md)

---

## Why this rung

The held dynamics arc (ALES56–59) closed the attack/hold/release family for limiter, compressor, and gate. The next Lindy-first crux the ALES59 log named is a fresh dynamics gesture on the proven idiom — and the cleanest of the three is the one that completes the classic quartet.

The dynamics family holds four members, in two mirror-pairs about the threshold:

| Side of threshold | Softens | Extreme (∞ ratio) |
|---|---|---|
| **Above** | compressor (ALES50) — divides the *excess* | limiter (ALES49) — pins the peak to the threshold |
| **Below** | **expander (ALES60, this rung)** — widens the *deficit* | gate (ALES51) — floors the quiet to silence |

The floor already has its brickwall (the gate). What it lacks is its *soft* member — the true downward mirror of the compressor, continuous at the threshold rather than stepping the moment a sample dips below it. That soft member is the **downward expander**, and it is the one clean rung that makes the dynamics family symmetric.

## How the gate differs from the expander (why this is a real rung, not the gate again)

The gate (ALES51) divides the *whole magnitude* of a below-threshold sample by the ratio: at a sample just below the threshold `thr`, the output jumps down to `≈ thr/ratio` — a step at the threshold. Musically that is the gate's whole point (the hard floor), yet it is abrupt.

The expander mirrors the compressor exactly. The compressor keeps the threshold whole and divides only the excess above it:

```
compress:  m > thr  →  new_m = thr + (m − thr) · den/num
```

The expander keeps the threshold whole and *widens* only the deficit below it:

```
expand:    m < thr  →  new_m = thr − (thr − m) · num/den   (floored at 0)
```

- **Continuous at the threshold.** At `m = thr` the deficit is zero, so `new_m = thr` — the expander passes the threshold sample identically, no step.
- **Unit ratio is the identity everywhere.** With `num = den`, `new_m = thr − (thr − m) = m`.
- **Monotone.** A larger ratio widens the deficit more, so a higher ratio expands at least as hard.
- **Reduces, never boosts.** Since `num/den ≥ 1`, the widened deficit is `≥ (thr − m)`, so `new_m ≤ thr − (thr − m) = m`. The magnitude only ever shrinks; the sign is held.
- **The gate is the limit.** A ratio far past the deficit drives `new_m` to the `0` floor — silence. The gate's hardest behaviour is reached from inside the expander, exactly as the limiter is reached from inside the compressor.

## Shape

`lotus/expand.rye` mirrors `lotus/gate.rye`'s frame — same `ExpandError` fault names (`BadThreshold`, `BadRatio`, `BadRange`), same edge checks before any write, same per-sample `|x|` in `i64`. The one changed line is the gain law: where the gate divides the whole magnitude, the expander widens the deficit and floors it at zero.

Overflow: `(thr − m)` is at most `sample_max` (`32767`); `num` is a `u32`; their product is at most `~1.4e14`, well inside `i64`. `new_m` may go sharply negative before the floor, so it is clamped to `0` and only then narrowed to `i16`, where `0 ≤ new_m ≤ m ≤ sample_max` fits.

## Witness — the clauses to prove

1. Silence stays silence.
2. **At or above the threshold is the identity** — a sample reaching `thr` passes byte-for-byte (continuity at the threshold, the expander's signature versus the gate's step).
3. **Unit ratio is the identity everywhere** — `num = den` writes `|x|` byte-for-byte even below the threshold.
4. **The sign is held and the magnitude never expands** — every below-threshold sample lands exactly at `thr − (thr − m)·num/den` floored at 0, sign matched, magnitude never above the input's.
5. **A higher ratio expands at least as hard** (monotone), and a ratio far past the deficit floors the quiet to silence — the gate reached from within the expander.
6. A bad threshold refuses `BadThreshold`, a sub-unity or zero-denominator ratio `BadRatio`, an out-of-range span `BadRange` — each before any write, the clip untouched.

The witness also re-proves ALES50 the compressor (the law this mirrors) still stands GREEN, so the two rest together — the mirror-pair witnessed side by side.

## Honest scope

Software only, purely local. Bounded in-process `i16` PCM on one bench, siloed to `lotus/`. No socket, no network, no keys, no funds, no real device, no real sample rate — the threshold is a magnitude in sample units, the ratio a plain fraction, the expansion instantaneous (attack/hold/release over a real time base is a later rung, exactly as it was for the gate). No custody gate is touched.
