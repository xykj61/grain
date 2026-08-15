# Fill ALES85 — Lotus's half-wave rectifier: keep the positive half, zero the negative, exact everywhere

**Stamp:** `20260814.214355` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; ALES84's own doc names the half-wave rectifier as the full-wave's plain sibling, the next rung of the even family)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES85**
**Kin:** [`../lotus/rectify.rye`](../lotus/rectify.rye) (ALES84 — the full-wave rectifier folds the negative half *up*, `y = |x|`; the half-wave rectifier folds it *away*, `y = max(x, 0)`) · [`../lotus/gate.rye`](../lotus/gate.rye) (ALES44 — a threshold silences below a floor; the half-wave rectifier is the threshold set exactly at zero, one-sided) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, the one true saturate)

---

## Why this rung

ALES84 gave the even family its first member — the full-wave rectifier, `y = |x|`, which folds the whole negative half of the wave *up* onto the positive side. Its own doc names the plain sibling: the **half-wave rectifier**, which keeps the positive half and folds the negative half *away* to silence — `y = max(x, 0)`. Where the diode bridge (four diodes) makes full-wave rectification, a single diode makes half-wave: it passes current one way and blocks it the other. The half-wave output is the classic single-diode clipper of a crystal radio and the octave-up voice of a one-diode fuzz. Lindy-first, half-wave rectification is the oldest rectifier of all — one diode predates the bridge; crux-first, the decisive recognition is that **`max(x, 0)` is EXACT for every i16 — there is no rail edge at all**, the very fact that separates it from its full-wave sibling.

## The crux — `max(x, 0)`, exact for every i16

`y = max(x, 0)` never leaves the rail. A non-negative sample passes unchanged (already in `[0, sample_max]`); a negative sample becomes `0`. Neither branch can overflow — unlike the full-wave rectifier, whose lone most-negative sample (`sample_min = −32768`, magnitude `32768`) had to saturate to the rail. The half-wave rectifier needs **no saturate**:

```
y = if x > 0 then x else 0          // non-negatives pass; negatives (and zero) become 0 — exact, no wide intermediate
```

Stated positively, the half-wave rectifier is **the positive half of the wave, kept whole; the negative half, silenced.** The map is **memoryless** (every output depends only on its own input), **idempotent** (a non-negative sample maps to itself, so `halve(halve(x)) = halve(x)`), and its output is always **non-negative** — the one-sided signal is the rectifier's whole point, exactly as with full-wave.

## The harmonic difference, stated honestly

The full-wave rectifier is a **pure even** generator (`|x|` is an even function). The half-wave rectifier is the average of the dry wave and the full-wave rectified wave — `max(x, 0) = (x + |x|) / 2` — so its output carries the **fundamental (odd) plus the even harmonics plus a DC term**: an **even+odd mix**, not pure even. Half the amplitude of the full-wave move, half the DC. That mix is the half-wave rectifier's voice, and naming it keeps the even family honest: the full-wave doubles frequency into pure even; the half-wave keeps the fundamental and adds the even overtones beside it.

## Shape

`lotus/halve.rye` offers `halve(clip, start, count)` — it folds each sample in `[start, count)` to `max(x, 0)`. It takes **no gain, no ceiling, no resolution, no threshold** — the threshold is fixed at zero, and `max(x, 0)` has no parameter that could be illegal — so it names exactly one fault:

- `BadRange` — a span outside the current samples (the suite's shared span law).

The name is `halve` for **half-wave**, sibling to `rectify` for full-wave. A keeper who wants a boosted or negatively-clamped half-wave composes this with ALES78's `drive` over the same span, both in-place span maps that compose.

## The laws to prove

1. **Non-negatives are unchanged** — `max(x, 0) = x` for every `x ≥ 0`; the positive half passes whole.
2. **Negatives fold to silence** — `−1→0`, `−100→0`, `−12345→0`, `sample_min→0`, read by hand; the negative half is silenced, not folded up.
3. **No rail edge** — unlike full-wave, `max(x, 0)` is exact for every i16, `sample_min` included (it maps to `0`, not a saturate); the map never leaves the rail.
4. **Every output is non-negative, and the map is idempotent** — no output below zero; a second halve changes nothing.
5. **Half of the full-wave move** — for a symmetric pair `+a` and `−a`, half-wave keeps `+a→a` and `−a→0`, where full-wave sent both to `a`; the half-wave output is the full-wave output masked to the positive half.
6. **The span discipline holds** — only `[start, count)` changes; samples outside are untouched.
7. **A span past the end refuses `BadRange`** — before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The shape is a half-wave threshold at zero, instantaneous — no attack/release, no anti-aliasing (a rectifier doubles frequency and is a heavy harmonic generator, and its harmonics fold in the i16 domain exactly as any diode rectifier's). One compare-and-keep per sample. No saturate, no delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The half-wave rectifier completes the **rectifier pair** — full-wave (pure even) and half-wave (even+odd mix) — beside the DRIVE clippers. Its plain sibling beyond the pair is the **inverted half-wave** (keep the negative half, zero the positive) or a **precision rectifier with an offset threshold**; the loop names its own next Lotus crux as its own self-approved design round.

## Witness

`tools/ales_halve_witness.rish` — builds `lotus/halve.rye`, runs its selftest, and asserts the single `GREEN ales-halve` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_halve_witness.rish
```
