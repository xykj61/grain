# Fill ALES94 — Lotus's voiced/unvoiced/silent classifier: the first rung to fuse two analysis readers

**Stamp:** `20260814.230352` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design read — self-approved round (no custody gate; the rung is a bounded, in-process, **read-only** classifier over one local i16 clip that composes ALES93's crossing count and ALES13's RMS, and the ALES93 doc named this rung in as many words — *a voiced/unvoiced classifier that reads this count against an energy floor (the meter's RMS)*)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES94**
**Kin:** [`../lotus/zero_cross.rye`](../lotus/zero_cross.rye) (ALES93 — the crossing count, one of the two features) · [`../lotus/meter.rye`](../lotus/meter.rye) (ALES13 — the RMS energy, the other feature) · [`../lotus/schmitt.rye`](../lotus/schmitt.rye) (ALES92 — the band the crossing count reads through)

---

## Why this rung

ALES93 gave the suite its first analysis reader — a count of the signal's genuine crossings. ALES13 already carried the other classic feature — the RMS energy. This rung is the first to **fuse two readers into one verdict**: the oldest decision in speech processing, *is this frame voiced, unvoiced, or silent?* A century of telephony, every speech codec, every voice-activity gate answers it the same way, from exactly these two features:

- **Energy** (RMS) separates sound from silence — below a floor, there is nothing to classify.
- **Crossing rate** separates the two kinds of sound above that floor — a **voiced** sound (a vowel, a hummed note, a periodic tone) carries most of its energy low and crosses **few** times; an **unvoiced** sound (a fricative *sss*, a hiss, broadband noise) carries its energy high and crosses **many** times.

So the rule, stated once and plainly:

```
if rms < silence_floor         → Silent    (below the energy floor — nothing to classify)
else if crossings ≥ voice_split → Unvoiced  (loud AND high crossing rate — noise, fricatives)
else                            → Voiced    (loud, low crossing rate — periodic)
```

Lindy-first, voiced/unvoiced/silent detection reads true for as long as speech is coded, gated, or transcribed — it is the front of every vocoder, VAD, and pitch tracker, and it will still be that in ten years. Crux-first, it is the hardest-still-tractable next Lotus move: it is the first rung to **compose two analysis families over one span**, so it proves the readers cooperate rather than merely coexist.

## The crux — a verdict that is exactly the two readers' own outputs, fused

This rung invents no new measurement. Its whole correctness is that its verdict equals a decision built **by hand** from ALES93's `count_crossings` and ALES13's RMS over the **same** span — the classifier is the *fusion rule*, not a third reader that could disagree with the two it names.

> **The verdict equals the hand-built decision from `zero_cross.count_crossings` and `meter`'s RMS over the same span** — so the classifier can never drift from the two readers it composes, exactly as ALES93 can never drift from the trigger it counts.

The energy gate comes **first**: a signal that crosses many times but sits below the floor is **silent**, not unvoiced — a quiet noise floor is silence, not a fricative. Reading the floor before the crossing rate is the rule's one ordering invariant, and the rung states it plainly.

## Shape

`lotus/voiced.rye` offers one read-only classifier over a span:

- `Verdict` — the three-valued outcome: `silent`, `voiced`, `unvoiced`.
- `classify(clip, start, count, t_low, t_high, silence_floor, voice_split)` — reads the crossing count through the ALES92 band `[t_low, t_high]` and the RMS over the same span, and returns the verdict. Read-only: not one sample is written.

The band and span are validated through ALES92's own `precheck` (`BadThreshold`, `BadRange`); a `silence_floor` above the peak magnitude ceiling refuses a new named fault `BadFloor`. The `voice_split` needs no bound: `voice_split = 0` means *every non-silent span is unvoiced* and a `voice_split` past the widest span means *never unvoiced*, both legal degenerate settings a keeper may choose.

## The floor-zero convention

A `silence_floor` of `0` **disables** the silence verdict: `rms < 0` is never true, so nothing reads silent, and an all-zero span (RMS 0, zero crossings) classifies **voiced** (the low-crossing branch). A keeper who wants true silence caught sets the floor to at least `1`. Stated plainly so the degenerate is deliberate rather than surprising.

## The laws to prove

1. **Loud and periodic → voiced** — a strong signal that crosses few times (below `voice_split`) classifies voiced.
2. **Loud and noisy → unvoiced** — a strong signal that crosses many times (at or above `voice_split`) classifies unvoiced.
3. **Quiet → silent** — a signal whose RMS is below the floor classifies silent whatever its crossing count.
4. **The floor dominates the crossing rate** — a signal that crosses many times but sits below the floor is silent, not unvoiced (the energy gate is read first).
5. **The verdict is exactly the two readers fused (the crux)** — over several spans, `classify` equals a hand-built decision from `zero_cross.count_crossings` and a `Meter`'s RMS on the same span.
6. **Read-only** — the source clip is byte-for-byte unchanged after classifying.
7. **The floor-zero convention** — with `silence_floor = 0`, an all-zero span classifies voiced, not silent.
8. **An illegal floor refuses `BadFloor`; an illegal band refuses `BadThreshold`; an out-of-range span refuses `BadRange`** — each before any read of the features.
9. **The span discipline** — classifying reads only `[start, count)`; samples outside are neither read into the verdict nor touched.

## Honest scope

Software only, purely local, and **read-only** — a bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`, never mutated. The verdict is a **three-valued label over one span**, not a phoneme, not a transcript, not a probability: a real voice-activity detector adds hysteresis over time, adaptive floors, and a spectral tilt this rung does not — those are later rungs. The "voiced/unvoiced" names follow the classic speech-processing convention over exactly two features (energy and crossing rate); they claim nothing about a real speaker, language, or recording. No real sample rate, no windowing over time, no network, no keys, no funds, no real device, no real speaker.

## What this opens

With two analysis readers now fused into one verdict, the analysis family can grow decisions rather than only measurements. Beyond it the loop names its own next Lotus crux: a **windowed classifier** that slides this decision across a clip to draw a voiced/unvoiced/silence map over time, a **voice-activity gate** that opens ALES65's keyed gate on the *voiced* verdict, an **adaptive floor** that tracks the noise level rather than fixing it, or a fresh DSP family — each as its own self-approved design round.
