# Fill ALES90 — Lotus's DC-offset remover: the pure translation that undoes the offset the even-harmonic family introduces

**Stamp:** `20260814.222356` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the rung is a bounded, memoryless block operation over one local i16 clip, and the ALES89 doc already *booked* the DC remover as the next Lotus crux)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES90**
**Kin:** [`../lotus/rectify.rye`](../lotus/rectify.rye) (ALES84 — the full-wave rectifier, `y = |x|`, the plainest DC generator this rung answers) · [`../lotus/crush.rye`](../lotus/crush.rye) (ALES81 — the 1-bit crush, a floored `0`/`sample_min` map, DC-heavy by construction) · [`../lotus/drive.rye`](../lotus/drive.rye) (ALES82 — the asymmetric tube drive, a different rail per sign, so its mean drifts off zero) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, `sample_min`/`max`, and the one true `saturate`)

---

## Why this rung

The DRIVE family closed its dead-zone trilogy at ALES89, and along the way it grew a whole shelf of **even-harmonic generators** — the full-wave rectifier (ALES84, `y = |x|`), the two half-wave rectifiers (ALES85, ALES86), the asymmetric tube drive (ALES82, a different ceiling per sign), the 1-bit crush (ALES81, a floored two-level map). Each of them does one thing beyond adding harmonics that none of the odd maps do: it **shifts the signal's mean off zero**. Rectify a symmetric wave and every sample turns positive — the audio now rides on a large positive DC offset. Nothing in the suite yet takes that offset back out.

A DC offset is not a sound; it is a silent thief. It eats headroom (the whole wave rides toward one rail, so it saturates sooner), it thumps when a clip is cut or spliced (the mean steps at the seam), and it stresses every downstream stage. Every real chain that carries a nonlinearity carries a **DC remover** right after it. Lindy-first, DC removal is a primitive that reads true for as long as audio is stored as signed samples — it is on every console channel, in every plugin host, at the front of every codec. Crux-first, it is the tool the family that *just landed* demands: the ALES89 doc named it in as many words — "the booked DC blocker that removes the offset the rectifiers and the 1-bit crush introduce."

## The crux — DC removal is a **pure translation**

This rung removes the offset the honest, exact way an integer buffer can prove: compute the span's **mean** and subtract it from every sample. That is a **pure translation** — the *same* constant leaves every sample — and a translation has one defining property the rung is built around:

> **A pure translation preserves every sample-to-sample difference exactly.** Where no sample saturates, `y[i] − y[j] = (x[i] − m) − (x[j] − m) = x[i] − x[j]` for every pair. Only the mean moves; the waveform *shape* — all of its AC content, every harmonic the distortion just generated — is carried through untouched.

That is what distinguishes DC removal from ALES2's `gain`: a gain scales the differences (it changes the shape and the loudness), a DC remove **slides** them (it changes only where zero sits). The mean is the one offset whose subtraction lands the span's average on zero.

```
sum  = Σ x[i]   over the span, accumulated in i64 (count ≤ max_clip samples, each ≤ 32768 — vast headroom)
mean = trunc(sum / count)          // @divTrunc, the suite's honest-lossy division rule (ALES2's gain rule)
y[i] = saturate(x[i] − mean)       // the same constant off every sample; saturate at the rails (ALES2 reused)
```

The mean is truncated toward zero, so it is honestly lossy by at most one LSB, and the residual is **bounded and provable**: after subtraction the span's remaining sum satisfies `|Σ y[i]| < count`, i.e. the residual mean magnitude is **strictly less than one LSB**. Two facts fall straight out of that bound:

- **A zero-mean signal is unchanged, exactly** — `mean = 0`, so every sample is subtracted by nothing; a wave already centered on zero passes through byte-for-byte.
- **Idempotent where nothing saturates** — the residual sum is smaller than `count`, so a second pass computes `mean' = trunc(residual / count) = 0` and changes nothing. Removing DC twice equals removing it once.

Saturation is the one honest caveat, stated rather than hidden: if a sample sits near a rail and the mean pushes it past, the value pins to `±sample_max` (ALES2's `saturate`, reused — never a wrap to the opposite sign), and at that one sample the translation is no longer exact. That is correct behavior for a fixed-point buffer, and the rung names it plainly.

## The block-mean remover, and the one-pole DC blocker it is the sibling of

This rung is the **block-mean** DC remover: exact, memoryless, no feedback, no carried state — it looks at a whole span at once and subtracts its average. Its cousin, the classic **one-pole IIR DC blocker** (`y[n] = x[n] − x[n−1] + R·y[n−1]`), removes a *drifting* offset sample-by-sample with a feedback coefficient, and it wants a carried-state design and a stability bound of its own — the shape ALES43's carried low-pass already opened. That IIR blocker is a later, named rung. The block-mean remover is the right first tool: it undoes exactly the *constant* offset a rectifier or an asymmetric clip introduces over a bounded region, and it proves in pure integers with no float and no stability argument.

## Shape

`lotus/dc_remove.rye` offers `dc_remove(clip, start, count)` — it subtracts the span's mean from each sample in `[start, count)`, saturating at the rails. It names one fault:

- `BadRange` — a span outside the current samples (the suite's shared span law), refused before any read or write.

An **empty span** (`count == 0`) is a clean no-op: the mean of nothing is undefined, so there is nothing to remove and no divide by zero — the clip is returned exactly as it was.

## The laws to prove

1. **Removes a pure DC offset** — a constant span `[1000, 1000, 1000, 1000]` has `mean = 1000` and becomes all `0`.
2. **A zero-mean signal is unchanged exactly** — `[100, −100, 200, −200]` (`sum = 0`) passes through byte-for-byte.
3. **A pure translation preserves differences (the crux)** — every adjacent difference `x[i+1] − x[i]` is unchanged after removal, wherever no sample saturates; read on a positive-biased ramp.
4. **The residual mean is bounded below one LSB** — after removal, `|Σ y[i]| < count` on a signal whose sum is not divisible by the count.
5. **Idempotent where nothing saturates** — a mid-level signal DC-removed twice equals once.
6. **It undoes the rectifier's offset (the composition crux)** — a symmetric zero-mean wave full-wave-rectified (ALES84 — every sample positive, a large DC offset) then DC-removed has residual mean magnitude `< 1`.
7. **Saturation at the rail is honest** — a `sample_max` sample under a negative mean pins to `sample_max` rather than wrapping.
8. **The span discipline holds** — only `[start, count)` changes; the samples outside are untouched.
9. **The empty span is a clean no-op** — `count = 0` leaves the clip exactly as it was, with no divide by zero.
10. **BadRange refuses by name** — a span past the end refuses `BadRange`, the clip untouched before any write.

## Honest scope

Software only, purely local. A bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`. The operation is a two-pass block statistic — sum, then subtract — memoryless in the DSP sense (no carried state, no feedback, no delay line), computed in i64 so the accumulation never overflows and clamped once per sample by the one true `saturate`. No frequency, no real sample rate (the "DC" is the arithmetic mean of the block, the zero-frequency component by definition, not a claim about any hardware highpass), no anti-aliasing, no snapshot, no socket, no network, no keys, no funds, no real device, no real speaker.

## What this opens

With the block-mean remover in hand, the family that generates offsets and the tool that clears them stand together. Beyond it the loop names its own next Lotus crux — the **one-pole IIR DC blocker** (a drifting-offset remover with carried state, the ALES43-shaped sibling of this rung), a **hysteresis comparator** that gives ALES89's square a memory against chatter, or a fresh DSP family — as its own self-approved design round.
