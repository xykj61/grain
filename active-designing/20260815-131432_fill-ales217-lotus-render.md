# Fill ALES217 — Lotus's render rung (an effect chain becomes a .wav)

**Stamp:** `20260815.131432` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local byte work · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES217**
**Kin:** [`20260815-130649_fill-ales216-lotus-stereo-wav.md`](20260815-130649_fill-ales216-lotus-stereo-wav.md) · [`../lotus/wav.rye`](../lotus/wav.rye) · [`../lotus/timeline.rye`](../lotus/timeline.rye) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES2 opened the editable Clip and the three gestures every timeline owes — cut, gain, splice. Two hundred rungs since then edit that Clip a hundred different ways. ALES215 opened the door the Clip leaves through: the canonical RIFF/WAVE container. Both halves stand proven, yet nothing in the tree yet joins them in one call — a keeper still runs an effect by hand, then encodes by hand.

`render` is that join, and it is the honest Lindy-first crux: the **one pipeline endpoint** every effect reaches toward. A render takes a Clip, runs a **bounded, ordered chain of real effects** over it, and encodes the result to a canonical mono `.wav` — bytes → edited samples → the open file another program plays. This is where the suite stops being two hundred separate verbs and becomes a *pipeline*.

## The shape — a bounded chain, applied in order, then encoded

- `pub const Step` — one edit in the chain: a `StepKind` (`gain` · `fade` · `invert`) with the span and coefficients that edit names. `gain` scales a span by `num0/den`; `fade` ramps a span from `num0/den` to `num1/den`; `invert` flips the whole clip's phase.
- `pub const max_steps: u32 = 32` — a render's chain is bounded; a longer chain refuses `TooManySteps` before a single sample is touched.
- `render(sample_rate, clip, steps, out) RenderError!u32` — validate the whole request first (a sane rate, an output buffer wide enough, every step's span within the clip and no zero denominator), **then** apply the chain in order, **then** encode the final samples into `out`, returning the byte length.

The three effects it composes are the tree's own already-proven functions — `timeline.gain`, `fade.fade`, `invert.invert` — reused verbatim, never re-derived. Render adds only the *composition* and its one new promise: atomicity.

## THE ATOMIC PROMISE

The length of a clip is invariant under gain, fade, and invert — none of the three adds or removes a sample. That invariant is what makes a render checkable *before* it runs: every step's span can be validated against the one fixed length up front. So `render` proves the entire request legal before it edits a byte, and a chain carrying any faulty step — a span past the clip, a zero denominator, a rate out of range, an output buffer too small — refuses **by name** and leaves the clip **byte-for-byte unchanged**. A failed render is a no-op, never a half-edited clip beside a half-written file.

## The provable laws the witness proves

1. **THE RENDER LAW** — a Clip through a real three-step chain (gain, fade, invert) encodes to a `.wav` that decodes back **byte-for-byte** to the same chain applied by hand, the sample rate preserved.
2. **THE ORDER LAW** — the same steps in a different order render to a *different* file: gain-then-halve saturates before it divides where halve-then-gain divides before it scales, so order is observable, proving the chain is a sequence and not a set.
3. **THE EMPTY-CHAIN LAW** — a chain of zero steps renders the clip's current samples unchanged (the render equals a bare encode).
4. **THE ATOMIC-FAULT LAW** — a chain whose second step names a span past the clip refuses `BadRange`, and a chain carrying a zero-denominator gain refuses `BadGain`, each leaving the clip byte-for-byte unchanged and nothing written to `out`.
5. **THE OUTPUT-BORDER LAW** — an `out` buffer too small for the container refuses `OutputTooSmall` before any effect runs, the clip untouched.
6. **THE STEP-BOUND LAW** — a chain longer than `max_steps` refuses `TooManySteps` before any effect runs.
7. **THE EMPTY-CLIP LAW** — a zero-sample clip renders to a valid 44-byte header and decodes back to zero samples.

## Honest scope

Software only, purely local byte work — the render composes existing in-process effects over a bounded i16 buffer and writes the canonical RIFF/WAVE byte layout, the same container ALES215 proved. No real file is opened, no DAC driven, no acoustic or electrical fact asserted; the stored sample rate is a carried field, not a real clock. No network, no keys, no funds, no real device or speaker. Siloed to `lotus/`. **No custody gate.**

## Next after this

With render standing, a keeper can turn an edit chain into a file in one call. The natural next rungs: a **stereo render** (the same chain over two channels into `stereo_wav`), or a **named preset chain** a keeper loads by name — each its own self-approved design round.
