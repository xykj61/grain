# Fill ALES93 — Lotus's zero-crossing counter: reading ALES92's flips as a count, the first analysis rung on the comparator

**Stamp:** `20260814.225557` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design read — self-approved round (no custody gate; the rung is a bounded, in-process, **read-only** counter over one local i16 clip that composes ALES92's public one-sample comparator, and the ALES92 doc named this rung in as many words — *a zero-crossing counter that reads this trigger's flips as a pitch estimate*)
**Season:** Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES93**
**Kin:** [`../lotus/schmitt.rye`](../lotus/schmitt.rye) (ALES92 — the hysteresis comparator whose flips this rung counts, over its public `schmitt_step`) · [`../lotus/meter.rye`](../lotus/meter.rye) (the read-only analysis shape — a struct that accumulates, accessors that report) · [`../lotus/timeline.rye`](../lotus/timeline.rye) (ALES2 — the Clip, `sample_min`/`max`)

---

## Why this rung

ALES92 landed the **Schmitt trigger** — a hysteresis comparator that carries one bit, *which rail am I on*, and flips only when the signal rises past the upper threshold or falls past the lower. Every rung of the suite so far **writes**: it edits a clip in place. This rung is the suite's first **analysis** move — it **reads** a clip and reports a number, changing not one sample. The number is the count of the trigger's flips over a span: a **zero crossing** in the hysteresis sense is exactly a rail flip, so counting flips is reading how many times the signal genuinely crossed — past the noise the band already suppresses. The ALES92 doc named this rung plainly — *a zero-crossing counter that reads this trigger's flips* — and this is that rung.

Lindy-first, a zero-crossing count reads true for as long as a signal is a stream of samples: it is the oldest activity/pitch estimate there is, the front of voiced/unvoiced detection, of tempo and onset counting, of the cheapest pitch tracker, and it will still be that in ten years. Crux-first, it is the hardest-still-tractable next Lotus move after the comparator pair — it is the first rung that must **carry state across spans for a derived quantity** (the count, not the samples), so it inherits ALES92's split-equals-whole discipline for a value the clip no longer holds.

## The crux — split equals whole, now for a **derived count** across the seam

The Schmitt trigger's split-equals-whole property was about the *samples*: a span triggered in two pieces equals the whole triggered once because the second piece continues the first's rail. This rung carries that property up one level, to a quantity the samples do not store — the running count. A flip can land **exactly at the seam** between the last sample of one piece and the first of the next; a counter that restarted per piece would miss that seam flip, undercounting. So the counter carries two things across a call: the trigger's rail (the hysteresis state) **and** the previous output rail (the memory a crossing is measured against).

> **A span counted in two pieces, the second continuing the first's ending rail and its previous-rail memory, equals the whole span counted once — the seam flip counted exactly once, never missed and never doubled.**

That is what makes ALES93 the analysis **sibling** of ALES92 rather than a re-implementation. It composes ALES92's public one-sample comparator (`schmitt_step`) — the same step the in-place trigger writes — and reads its flips instead of writing its rails. One comparator implementation, two readers; the counter can never drift from the trigger it counts.

## The counting convention — a crossing is a change between consecutive output rails

For `N` samples there are at most `N − 1` crossings. The **first** sample of a stream establishes the initial rail and counts as no crossing (there is no prior sample to differ from); every later sample counts one crossing when its output rail differs from the sample before it. From silence the trigger opens on the low rail (ALES92's convention), yet the first *fed* sample simply sets the starting rail — so a signal that begins already high adds no phantom crossing at index 0. This is the standard zero-crossing-count definition, stated plainly so the carried and from-silence forms cannot drift.

## Shape

`lotus/zero_cross.rye` offers the ALES92/meter idiom — a carried struct with a from-silence convenience:

- `ZeroCounter { trigger, count, prev_high, started }` — the value a keeper holds beside a clip; `feed` advances it over a span (read-only), `crossings` reports the accumulated count, `reset` returns it to silence (count zero, rail low).
- `count_crossings(clip, start, count, t_low, t_high)` — the from-silence convenience, a fresh `ZeroCounter` fed once (so the two forms can never drift).

The band and span are validated by ALES92's own public `precheck`, sharing the exact same law and named errors — so the counter's band discipline is the trigger's, not a second copy. The errors are ALES92's `SchmittError` (`BadThreshold`, `BadRange`) reused by name.

## The laws to prove

1. **The convenience equals a fresh counter fed once** — `count_crossings` equals a `ZeroCounter` fed one span (one implementation, cannot drift).
2. **It counts exactly ALES92's flips** — run `schmitt` into a scratch clip, count the adjacent rail transitions in the ±sample_max output by hand, and the counter agrees byte-for-count. This binds the rung to ALES92 rather than to an independent comparator.
3. **Split equals whole (the crux)** — a span counted in two pieces, the second carrying the first's rail and previous-rail memory, equals the whole counted once — including a flip that lands exactly at the seam.
4. **Hysteresis suppresses chatter counting (the reason it is built on the trigger)** — a dither wholly inside the band after a trigger adds zero crossings, where a single-threshold sign comparator on the same dither would count many.
5. **A known signal counts its known flips** — a hand-built signal with exactly K rail flips counts K.
6. **Silence and in-band-only signals count zero** — a span that never leaves the band yields no crossings.
7. **Reset re-opens from silence** — after a run, `reset` returns the count to zero and the rail to low, so the next run counts from silence.
8. **Read-only (the span discipline in its strongest form)** — the source clip is byte-for-byte unchanged after counting; not one sample is written.
9. **An illegal band refuses `BadThreshold`; an out-of-range span refuses `BadRange`** — the count and state untouched on refusal.
10. **The count is bounded** — it never exceeds `max_crossings`; a run that would exceed it refuses `CountFull` before overcounting, the count left at its bound.

## Honest scope

Software only, purely local, and **read-only** — a bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`, never mutated by this rung. The count is a **pure sample count of rail flips**, not a pitch in Hz: a real pitch is `crossings / (2 · duration · sample_rate)`, and there is **no real sample rate** in the suite yet — so this rung reports the raw, honest count and names the pitch conversion as a later rung (the one that introduces a real sample rate). The "zero crossing" is over the trigger's hysteresis band, not a raw sign change, so the count already resists the chatter a raw zero-cross would miscount; no anti-aliasing, no windowing, no real device, no real speaker, no network, no keys, no funds.

## What this opens

With the comparator pair (ALES89 memoryless, ALES92 hysteresis) and now the first reader over them (ALES93), the analysis family opens beside the edit family. Beyond it the loop names its own next Lotus crux: a **crossing-rate to pitch** rung once a real sample rate exists, an **onset/activity counter** over short windows, a **voiced/unvoiced classifier** that reads this count against an energy floor (the meter's RMS), or a fresh DSP family — each as its own self-approved design round.
