# Fill ALES86 — Lotus's inverted half-wave rectifier: keep the negative half, zero the positive, the two halves that partition the wave

**Stamp:** `20260814.214941` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; ALES85's own doc names the inverted half-wave rectifier as its plain sibling, the rung that completes the rectifier family)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES86**
**Kin:** [`../lotus/halve.rye`](../lotus/halve.rye) (ALES85 — the positive half-wave rectifier keeps `max(x, 0)`; this rung keeps `min(x, 0)`, and the two sum back to the dry wave) · [`../lotus/rectify.rye`](../lotus/rectify.rye) (ALES84 — the full-wave rectifier `|x|`; `max(x, 0) − min(x, 0) = |x|`) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max)

---

## Why this rung

ALES85 gave the half-wave rectifier — `y = max(x, 0)`, the positive half of the wave kept whole and the negative half silenced. Its own doc names the plain sibling: the **inverted half-wave rectifier**, which keeps the **negative** half and silences the positive — `y = min(x, 0)`. A half-wave rectifier built from a single diode oriented one way passes the positive half; flip the diode and it passes the negative half. Together the two half-wave rectifiers **partition** the wave: every sample lands in exactly one of them (their zero shared), and their two outputs add back to the original — `max(x, 0) + min(x, 0) = x`. Lindy-first, this decomposition of a signal into its positive and negative parts is a foundational move in signal processing; crux-first, the recognition is that **`min(x, 0)` is exact for every i16 with no rail edge — the mirror of ALES85, with `sample_min` now the sample that passes through untouched rather than the one that silences.**

## The crux — `min(x, 0)`, exact for every i16, the mirror of ALES85

`y = min(x, 0)` never leaves the rail. A non-positive sample passes unchanged (already in `[sample_min, 0]`); a positive sample becomes `0`. Neither branch can overflow, and `sample_min` passes **through** untouched — it is already a legal i16, unlike the full-wave rectifier where its magnitude `32768` overflowed the positive rail and had to saturate. The inverted half-wave rectifier needs **no saturate**:

```
y = if x < 0 then x else 0          // non-positives pass; positives (and zero) become 0 — exact, no wide intermediate
```

Stated positively, the inverted half-wave rectifier is **the negative half of the wave, kept whole; the positive half, silenced.** The map is **memoryless**, **idempotent** (a non-positive sample maps to itself), and its output is always **non-positive** — the below-zero one-sided signal is the inverted rectifier's whole point.

## The partition, and the family

The three rectifiers relate by plain algebra over every sample:

- `max(x, 0) + min(x, 0) = x` — the positive and inverted half-waves **partition** the wave (they add back to the dry signal).
- `max(x, 0) − min(x, 0) = |x|` — their difference is the full-wave rectification.

Harmonically the inverted half-wave is the same **even+odd mix** as ALES85, sign-flipped: `min(x, 0) = (x − |x|) / 2` carries the fundamental (odd) plus the even harmonics **minus** a DC term — a one-sided signal below zero rather than above. This rung closes the **rectifier family**: full-wave (pure even), positive half-wave and inverted half-wave (the even+odd mix, the two halves that partition the wave).

## Shape

`lotus/halve_neg.rye` offers `halve_neg(clip, start, count)` — it folds each sample in `[start, count)` to `min(x, 0)`. It takes **no gain, no ceiling, no resolution, no threshold** — the threshold is fixed at zero — so it names exactly one fault:

- `BadRange` — a span outside the current samples (the suite's shared span law).

A keeper who wants the two halves separately runs ALES85's `halve` and this `halve_neg` over the same span, both in-place maps whose outputs sum back to the dry wave.

## The laws to prove

1. **Non-positives are unchanged** — `min(x, 0) = x` for every `x ≤ 0`; the negative half passes whole.
2. **Positives fold to silence** — `1→0`, `100→0`, `12345→0`, `32767→0`, read by hand.
3. **No rail edge** — `sample_min` passes through untouched (the mirror of ALES85's `sample_max`); `sample_max` folds to `0`; `min(x, 0)` is exact for every i16.
4. **Every output is non-positive, and the map is idempotent** — no output above zero; a second inverted halve changes nothing.
5. **The two half-waves partition the wave** — `max(x, 0) + min(x, 0) = x`, sample for sample.
6. **The span discipline holds** — only `[start, count)` changes; samples outside are untouched.
7. **A span past the end refuses `BadRange`** — before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The shape is an inverted half-wave threshold at zero, instantaneous — no attack/release, no anti-aliasing. One compare-and-keep per sample. No saturate, no delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The rectifier family stands whole — full-wave and the two half-waves. Beyond it the loop names its own next Lotus crux (a **precision rectifier** with an offset threshold, or a fresh DSP family) as its own self-approved design round.

## Witness

`tools/ales_halve_neg_witness.rish` — builds `lotus/halve_neg.rye`, runs its selftest, and asserts the single `GREEN ales-halve-neg` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_halve_neg_witness.rish
```
