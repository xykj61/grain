# Fill ALES83 — Lotus's sample-rate decimator: hold each sample across a run, crushing time rather than amplitude

**Stamp:** `20260814.213107` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Design read — self-approved round (no custody gate; ALES81 and ALES82 each named the sample-rate decimator as the DRIVE family's remaining rung — the bit-crush's twin on the other axis)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES83**
**Kin:** [`../lotus/crush.rye`](../lotus/crush.rye) (ALES81 — the bit-crush this rung mirrors: crush lowers a sample's *resolution* on the value axis, decimate lowers its *rate* on the time axis) · [`../lotus/tube.rye`](../lotus/tube.rye) (ALES82 — the DRIVE family's most recent rung, which named the decimator as the next) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, sample_min/max, max_clip)

---

## Why this rung

ALES81's bit-crush drops the low bits, so a sample entered at sixteen bits leaves at eight or four — coarse on the **value** axis while every sample keeps its own moment in time. A converter goes coarse the other way too: read too slowly, it **holds each sample across a run** and repeats it, so the effective sample rate falls to half, a quarter, a sixteenth. That is aliasing's plain source — the stepped, sample-and-hold voice of an early sampler, a cheap converter, a signal starved of *time* rather than resolution. Lindy-first, the sample-and-hold is the oldest lo-fi move a converter makes; crux-first, the decisive recognition is that **a decimation by `hold` is a zero-order hold: pin every sample in a run of `hold` to the run's first sample.** The bit-crush and the decimator are twins — one crushes the value axis, the other the time axis — and naming the second completes the two ways a converter goes coarse.

## The crux — a zero-order hold, anchored at `start`

Partition the span `[start, start+count)` into runs of `hold` samples anchored at `start`, and pin every sample in a run to the run's **anchor** — its first sample:

```
anchor(i) = start + ⌊(i − start) / hold⌋ · hold      // ≤ i, equals i at each run's first sample
y[i] = x[anchor(i)]                                    // hold the anchor across its run
```

`hold = 1` is the **identity** (each run is one sample, held to itself), the way ALES81's `bits = 16` reproduces the whole-resolution signal. `hold = 2` keeps every other sample and repeats it once; `hold = 4` keeps one in four. The last run may be **partial** when the span is not a whole multiple of `hold` — it holds its anchor across however many samples remain, exactly as a full run would.

## The family's first non-memoryless map, honestly named

Every prior DRIVE member is **memoryless per sample** — an output depends only on its own input. The decimator is the family's **first** map that is not: an output equals its run's **anchor**, a *neighbor*, not only its own input. Stated positively, the decimator is **memoryless per run** — each run depends only on its own anchor, so decimating a span whose run boundaries align equals decimating it whole. And it is **idempotent**: a run already held is held to the same anchor, so `decimate(decimate(x)) = decimate(x)`.

## Safe by construction, no saturate owed

The decimator writes only sample values that **already live** in the clip — it copies an anchor across its run and computes **no new number** — so every written value is a legal i16 by construction and there is no saturate to do: the map narrows *time*, never magnitude. In place it is safe left to right — a run's anchor sits at or before every index it fills (`anchor ≤ i`), and the anchor is written to *itself* (a no-op) before any later index in the run reads it, so `buf[anchor]` always holds the original anchor value while the run is filled.

## Shape

`lotus/decimate.rye` offers `decimate(clip, start, count, hold)` — it holds each run of `hold` samples in `[start, count)` at the run's first sample. Faults, one consistent name each:

- `BadHold` — a hold of zero (names no run) or past `max_clip` (no span that long to hold across). The decimator's own fault, on the time axis, the way ALES81's `BadBits` names the resolution axis.
- `BadRange` — a span outside the current samples (the suite's shared span law).

`hold = 1` is the identity. A keeper who wants a boosted, clipped, or bit-crushed decimation runs ALES78's `drive`, ALES82's `tube`, or ALES81's `crush` then `decimate` over the same span — all in-place span maps that compose.

## The laws to prove

1. **`hold = 1` is the identity** — each run is one sample held to itself, so the clip returns byte-for-byte.
2. **The zero-order hold by hand** — `hold = 3` over `[10,20,30,40,50,60,70]` gives `[10,10,10,40,40,40,70]`, the last run partial (one sample, held to 70).
3. **Every sample equals its run anchor, and the map is idempotent** — at `hold = 4` each sample equals the first of its run of four, and a second decimation changes nothing.
4. **A hold wider than the span holds the whole span at the first sample** — one run covers everything; `hold ≥ count` is the coarsest decimation the span holds.
5. **The rail is preserved** — a decimation only copies existing samples, so every output is a legal i16 (proven riding both rails).
6. **The span discipline holds** — only `[start, count)` changes; samples outside are untouched.
7. **Each fault refuses by name** — `BadHold` (zero or over-wide hold), `BadRange`, each before any write, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, siloed to `lotus/`. The `hold` is a sample count (unity = 1), the shape a zero-order hold, instantaneous per run — no interpolation, no anti-aliasing filter (a raw decimation aliases in the i16 domain exactly as any hardware sample-and-hold does). One divide, one copy per sample. No delay line, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker, no real sample rate.

## What this opens

The DRIVE family now holds six shapes — the wall (hard clip), the rounded shoulder (overdrive), the mirror (wavefolder), the coarse grid (bit-crush), the uneven rail (tube), and the stepped time (decimator). The bit-crush's twin on the time axis is met, and the waveshaper family is whole. The next Lotus crux steps outside the waveshaper family — a keeper who has shaped amplitude, resolution, and time now reaches for spectral or spatial work — and the loop names it as its own next design round.

## Witness

`tools/ales_decimate_witness.rish` — builds `lotus/decimate.rye`, runs its selftest, and asserts the single `GREEN ales-decimate` line. Run from the repository root:

```
rishi/bin/rishi run tools/ales_decimate_witness.rish
```
