# Fill ALES115 — Lotus's replace, the general span-edit (cut and splice, composed)

**Stamp:** `20260815.014021` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — one Lotus rung, one keystone, one send
**Waymark:** ALES · rung **ALES115** · Season C thread (Lotus · the creative suite) of the Six-Season double-seat
**Kin:** [`timeline.rye`](../lotus/timeline.rye) (ALES2 — `cut`, `splice`, `EditError`) · [`paste_over.rye`](../lotus/paste_over.rye) (ALES114) · [`move.rye`](../lotus/move.rye) (ALES113) · [`meter.rye`](../lotus/meter.rye) (ALES13)

---

## The crux, chosen Lindy-first

ALES2 gave the timeline two exact inverses over a span: `cut` **removes** it and the clip shrinks, `splice` **inserts** and the clip grows. ALES114's `paste_over` writes new samples **on top** of a span the same length. Every editor also ships the one gesture that ties all three together — **paste into a selection**: circle a span, drop different audio in its place, and the take changes length by however much longer or shorter the new audio is. Fix a flubbed bar with a shorter clean take and the song tightens; drop a fuller phrase over a thin one and it lengthens. This rung names that gesture: `replace`. It is the **general span-edit** — remove `count`, insert `src` — and it is exactly the composition **`cut(at, count)` then `splice(at, src)`** over ALES2's own public API, inventing no new transport, buffer, or error.

Chosen crux-first because `replace` is the one move that **generalizes three proven rungs at once**, so naming it makes the whole edit family a single law with three corners rather than four separate tools:

- an **empty `src`** is pure `cut` (remove, no insert),
- a **zero `count`** is pure `splice` (insert, no remove),
- a **`src.len == count`** is ALES114's `paste_over` (overwrite, the length held).

## The rule, stated once

`replace(clip, at, count, src)` removes the `count` samples starting at `at` and inserts `src` in their place, so `[at, at+src.len)` becomes `src`, every sample before `at` is untouched, every sample after the removed span follows the new audio unchanged, and the length becomes `len − count + src.len`. **All bounds are checked before any write:** `BadRange` when the removed span falls outside the current samples (`at > len`, or `count > len − at`, without underflow), and `ClipFull` when the result would run past the fixed buffer (`src.len > buf.len − len + count`). Only once every check passes does it compose ALES2's `cut` then `splice`, each pre-validated to succeed, so a refusal never lands mid-edit. It reuses `timeline.EditError` whole.

## The four laws

1. **THE REPLACE LAW** — after `replace(clip, at, count, src)` the span `[at, at+src.len)` holds `src` exactly, the samples before `at` are byte for byte unchanged, the samples after the removed span follow the new audio unchanged, and the length is `len − count + src.len`. Checked with a shorter replacement, a longer one, and an equal-length one.
2. **THE GENERALIZATION LAW** — the crux, three corners proven **byte for byte** against their own rungs: an empty `src` equals ALES2's `cut(clip, at, count)`; a zero `count` equals ALES2's `splice(clip, at, src)`; a `src.len == count` equals ALES114's `paste_over(clip, at, src)`. One law with three faces.
3. **THE LENGTH LAW** — the length changes by exactly `src.len − count`: it **shrinks** when the replacement is shorter, **grows** when longer, and **holds** when equal, proven all three directions over one anchor.
4. **THE DEGENERATE / REFUSAL LAW** — `replace(clip, at, 0, &[_]i16{})` is the identity; a removed span past the samples refuses `BadRange`, and a result past the buffer refuses `ClipFull`, each before any write, the clip untouched.

## Honest scope

Software only, purely local. A bounded in-process buffer of i16 PCM on one bench, siloed to `lotus/`. It removes an existing span and writes caller-supplied samples in its place, changing the length by a bounded amount and reading no byte past `len`. No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Definition of done

Opening triad; ≥2 positive-invariant asserts per fn; no new `@memcpy` (the composition writes through ALES2's own bounded loops); `timeline.EditError` reused whole; `tools/ales_replace_witness.rish` GREEN on metal proving all four laws (the generalization law against ALES2's own `cut` and `splice` and ALES114's own `paste_over`, the length law in all three directions); width-check clean; TAME style ratchet counts unchanged; README front door synced; session log rides the same signed commit; send to `origin` and `xykj61`.
