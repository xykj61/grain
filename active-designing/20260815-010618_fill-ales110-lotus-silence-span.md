# Fill ALES110 — Lotus's silence-span, the third way a span meets silence

**Stamp:** `20260815.010618` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — one Lotus rung, one keystone, one send
**Waymark:** ALES · rung **ALES110** · Season C thread (Lotus · the creative suite) of the Six-Season double-seat
**Kin:** [`insert_silence.rye`](../lotus/insert_silence.rye) (ALES109) · [`timeline.rye`](../lotus/timeline.rye) (ALES2) · [`meter.rye`](../lotus/meter.rye) (ALES13)

---

## The crux, chosen Lindy-first

ALES2's **cut** removes a span and closes the gap — the clip **shrinks**. ALES109's **insert_silence** opens a gap of quiet — the clip **grows**. Between them sits the third and last way a span meets silence: **overwrite it in place.** *Silence Audio Selection* is the button every editor ships — drop a cough, mute a bleed, clear a region to quiet **without moving anything around it**. Where cut changes the length by shrinking and insert-silence by growing, silence-span leaves the length exactly as it is and only zeroes the values inside the span. Naming it beside cut and insert-silence completes the trio and teaches the one distinction about a span of quiet: **remove, open, or overwrite.**

## The rule, stated once

`silence_span(clip, start, count)` writes zero into the `count` samples starting at `start`, leaving every sample outside the span and the length itself exactly as they were. It refuses `BadRange` when the span falls outside the current samples — checked without underflow, `count` against the remainder — before any write, reusing `timeline.EditError` whole. One in-place pass bounded by `count`, no allocation, no second buffer.

## The four laws

1. **THE SILENCE LAW** — after `silence_span(clip, start, count)`, the span `[start, start+count)` is all zero and every sample outside it is byte-for-byte unchanged, the length untouched, checked against a hand-built vector.
2. **THE TRIO / LENGTH LAW** — the length is exactly unchanged, the third way a span meets silence beside `cut` (which shrinks) and `insert_silence` (which grows). Proven directly: `silence_span(start, count)` keeps `clip.len`, while the same span through `cut` shrinks it by `count` and through `insert_silence` grows it by `count`.
3. **THE IDEMPOTENCE / PEAK LAW** — silence-span is **idempotent** (silencing a span twice equals once) and **not** invertible (the overwritten samples are gone, a lossy overwrite honest about its loss); the peak magnitude re-measured through ALES13 is **non-increasing** — silencing the span that holds the loudest sample strictly lowers the peak, silencing an already-silent span holds it.
4. **THE DEGENERATE / REFUSAL LAW** — `count = 0` is the identity; `silence_span(0, len)` clears the whole clip to silence; the empty clip is its own silence; a `start` past the samples or a `count` past the remainder refuses `BadRange`, before any write, the clip untouched.

## Honest scope

Software only, purely local. A bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`. It writes **silence** (zero) over an existing span — the one thing it writes, and silence is the honest content of a region a keeper cleared on purpose; it invents no non-zero sample, moves nothing, changes no length, and reads no byte past `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Definition of done

Opening triad; ≥2 positive-invariant asserts per fn; no new `@memcpy`; `timeline.EditError` reused whole; `tools/ales_silence_span_witness.rish` GREEN on metal proving all four laws (the trio law against ALES2's cut and ALES109's insert_silence); width-check clean; TAME style ratchet counts unchanged; README front door synced; session log rides the same signed commit; send to `origin` and `xykj61`.
